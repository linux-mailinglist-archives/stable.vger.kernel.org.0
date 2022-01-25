Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1997B49A9AB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323116AbiAYD03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:26:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56456 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359574AbiAXVDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16BFFB81257;
        Mon, 24 Jan 2022 21:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4456AC340EF;
        Mon, 24 Jan 2022 21:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058189;
        bh=bOT/9j3CWMqdCF6D64BdPYF7kNSLQZRb4VP1RAgo61E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSbxeMDWipZ3RjGlKUwQpL7moa2uB6IK2ftPJ+hL8pOqyS2jsYPmu7kUbQPE2YZmy
         QKS2ezMObvirDLx1s2q5P1RbRUuCPi01KxUzHPLwdu7h94g9CEDuQLDqE4lTSA46XF
         1ZuLG7+vzdroi3/9GkCJ1kOt7S2307/rbz9oREv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0209/1039] ACPI: EC: Rework flushing of EC work while suspended to idle
Date:   Mon, 24 Jan 2022 19:33:18 +0100
Message-Id: <20220124184132.350878842@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 4a9af6cac050dce2e895ec3205c4615383ad9112 ]

The flushing of pending work in the EC driver uses drain_workqueue()
to flush the event handling work that can requeue itself via
advance_transaction(), but this is problematic, because that
work may also be requeued from the query workqueue.

Namely, if an EC transaction is carried out during the execution of
a query handler, it involves calling advance_transaction() which
may queue up the event handling work again.  This causes the kernel
to complain about attempts to add a work item to the EC event
workqueue while it is being drained and worst-case it may cause a
valid event to be skipped.

To avoid this problem, introduce two new counters, events_in_progress
and queries_in_progress, incremented when a work item is queued on
the event workqueue or the query workqueue, respectively, and
decremented at the end of the corresponding work function, and make
acpi_ec_dispatch_gpe() the workqueues in a loop until the both of
these counters are zero (or system wakeup is pending) instead of
calling acpi_ec_flush_work().

At the same time, change __acpi_ec_flush_work() to call
flush_workqueue() instead of drain_workqueue() to flush the event
workqueue.

While at it, use the observation that the work item queued in
acpi_ec_query() cannot be pending at that time, because it is used
only once, to simplify the code in there.

Additionally, clean up a comment in acpi_ec_query() and adjust white
space in acpi_ec_event_processor().

Fixes: f0ac20c3f613 ("ACPI: EC: Fix flushing of pending work")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c       | 57 +++++++++++++++++++++++++++++++----------
 drivers/acpi/internal.h |  2 ++
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a6366d3f0c786..b9c44e6c5e400 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -166,6 +166,7 @@ struct acpi_ec_query {
 	struct transaction transaction;
 	struct work_struct work;
 	struct acpi_ec_query_handler *handler;
+	struct acpi_ec *ec;
 };
 
 static int acpi_ec_query(struct acpi_ec *ec, u8 *data);
@@ -452,6 +453,7 @@ static void acpi_ec_submit_query(struct acpi_ec *ec)
 		ec_dbg_evt("Command(%s) submitted/blocked",
 			   acpi_ec_cmd_string(ACPI_EC_COMMAND_QUERY));
 		ec->nr_pending_queries++;
+		ec->events_in_progress++;
 		queue_work(ec_wq, &ec->work);
 	}
 }
@@ -518,7 +520,7 @@ static void acpi_ec_enable_event(struct acpi_ec *ec)
 #ifdef CONFIG_PM_SLEEP
 static void __acpi_ec_flush_work(void)
 {
-	drain_workqueue(ec_wq); /* flush ec->work */
+	flush_workqueue(ec_wq); /* flush ec->work */
 	flush_workqueue(ec_query_wq); /* flush queries */
 }
 
@@ -1103,7 +1105,7 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 }
 EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
 
-static struct acpi_ec_query *acpi_ec_create_query(u8 *pval)
+static struct acpi_ec_query *acpi_ec_create_query(struct acpi_ec *ec, u8 *pval)
 {
 	struct acpi_ec_query *q;
 	struct transaction *t;
@@ -1111,11 +1113,13 @@ static struct acpi_ec_query *acpi_ec_create_query(u8 *pval)
 	q = kzalloc(sizeof (struct acpi_ec_query), GFP_KERNEL);
 	if (!q)
 		return NULL;
+
 	INIT_WORK(&q->work, acpi_ec_event_processor);
 	t = &q->transaction;
 	t->command = ACPI_EC_COMMAND_QUERY;
 	t->rdata = pval;
 	t->rlen = 1;
+	q->ec = ec;
 	return q;
 }
 
@@ -1132,13 +1136,21 @@ static void acpi_ec_event_processor(struct work_struct *work)
 {
 	struct acpi_ec_query *q = container_of(work, struct acpi_ec_query, work);
 	struct acpi_ec_query_handler *handler = q->handler;
+	struct acpi_ec *ec = q->ec;
 
 	ec_dbg_evt("Query(0x%02x) started", handler->query_bit);
+
 	if (handler->func)
 		handler->func(handler->data);
 	else if (handler->handle)
 		acpi_evaluate_object(handler->handle, NULL, NULL, NULL);
+
 	ec_dbg_evt("Query(0x%02x) stopped", handler->query_bit);
+
+	spin_lock_irq(&ec->lock);
+	ec->queries_in_progress--;
+	spin_unlock_irq(&ec->lock);
+
 	acpi_ec_delete_query(q);
 }
 
@@ -1148,7 +1160,7 @@ static int acpi_ec_query(struct acpi_ec *ec, u8 *data)
 	int result;
 	struct acpi_ec_query *q;
 
-	q = acpi_ec_create_query(&value);
+	q = acpi_ec_create_query(ec, &value);
 	if (!q)
 		return -ENOMEM;
 
@@ -1170,19 +1182,20 @@ static int acpi_ec_query(struct acpi_ec *ec, u8 *data)
 	}
 
 	/*
-	 * It is reported that _Qxx are evaluated in a parallel way on
-	 * Windows:
+	 * It is reported that _Qxx are evaluated in a parallel way on Windows:
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=94411
 	 *
-	 * Put this log entry before schedule_work() in order to make
-	 * it appearing before any other log entries occurred during the
-	 * work queue execution.
+	 * Put this log entry before queue_work() to make it appear in the log
+	 * before any other messages emitted during workqueue handling.
 	 */
 	ec_dbg_evt("Query(0x%02x) scheduled", value);
-	if (!queue_work(ec_query_wq, &q->work)) {
-		ec_dbg_evt("Query(0x%02x) overlapped", value);
-		result = -EBUSY;
-	}
+
+	spin_lock_irq(&ec->lock);
+
+	ec->queries_in_progress++;
+	queue_work(ec_query_wq, &q->work);
+
+	spin_unlock_irq(&ec->lock);
 
 err_exit:
 	if (result)
@@ -1240,6 +1253,10 @@ static void acpi_ec_event_handler(struct work_struct *work)
 	ec_dbg_evt("Event stopped");
 
 	acpi_ec_check_event(ec);
+
+	spin_lock_irqsave(&ec->lock, flags);
+	ec->events_in_progress--;
+	spin_unlock_irqrestore(&ec->lock, flags);
 }
 
 static void acpi_ec_handle_interrupt(struct acpi_ec *ec)
@@ -2021,6 +2038,7 @@ void acpi_ec_set_gpe_wake_mask(u8 action)
 
 bool acpi_ec_dispatch_gpe(void)
 {
+	bool work_in_progress;
 	u32 ret;
 
 	if (!first_ec)
@@ -2041,8 +2059,19 @@ bool acpi_ec_dispatch_gpe(void)
 	if (ret == ACPI_INTERRUPT_HANDLED)
 		pm_pr_dbg("ACPI EC GPE dispatched\n");
 
-	/* Flush the event and query workqueues. */
-	acpi_ec_flush_work();
+	/* Drain EC work. */
+	do {
+		acpi_ec_flush_work();
+
+		pm_pr_dbg("ACPI EC work flushed\n");
+
+		spin_lock_irq(&first_ec->lock);
+
+		work_in_progress = first_ec->events_in_progress +
+			first_ec->queries_in_progress > 0;
+
+		spin_unlock_irq(&first_ec->lock);
+	} while (work_in_progress && !pm_wakeup_pending());
 
 	return false;
 }
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index d91b560e88674..54b2be94d23dc 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -183,6 +183,8 @@ struct acpi_ec {
 	struct work_struct work;
 	unsigned long timestamp;
 	unsigned long nr_pending_queries;
+	unsigned int events_in_progress;
+	unsigned int queries_in_progress;
 	bool busy_polling;
 	unsigned int polling_guard;
 };
-- 
2.34.1



