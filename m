Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3850312153D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbfLPSTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:19:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731669AbfLPSTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBE7C21582;
        Mon, 16 Dec 2019 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520393;
        bh=K9TVDu3naj+9rclK3RiDbwJOiwvzuYuomCT8QY5Ykic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O97N8TQiW20mt6a8q/cJtMwcqjILQtN/EczgiK1k+dXKWF3Bv8P4Nmp+Emdl6kAJ6
         0b8vmvhco8EQ1MQM4eFOMW4zVskNy1HF2MUOGABPkevJVGhxpVj3FYSY5Th3OkxA3W
         9GaycEzdrrG49pzxjsJG94ec5jFioC5ZbNGVv6js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kenneth R. Crudup" <kenny@panix.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 129/177] ACPI: EC: Rework flushing of pending work
Date:   Mon, 16 Dec 2019 18:49:45 +0100
Message-Id: <20191216174844.284145651@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 016b87ca5c8c6e9e87db442f04dc99609b11ed36 upstream.

There is a race condition in the ACPI EC driver, between
__acpi_ec_flush_event() and acpi_ec_event_handler(), that may
cause systems to stay in suspended-to-idle forever after a wakeup
event coming from the EC.

Namely, acpi_s2idle_wake() calls acpi_ec_flush_work() to wait until
the delayed work resulting from the handling of the EC GPE in
acpi_ec_dispatch_gpe() is processed, and that function invokes
__acpi_ec_flush_event() which uses wait_event() to wait for
ec->nr_pending_queries to become zero on ec->wait, and that wait
queue may be woken up too early.

Suppose that acpi_ec_dispatch_gpe() has caused acpi_ec_gpe_handler()
to run, so advance_transaction() has been called and it has invoked
acpi_ec_submit_query() to queue up an event work item, so
ec->nr_pending_queries has been incremented (under ec->lock).  The
work function of that work item, acpi_ec_event_handler() runs later
and calls acpi_ec_query() to process the event.  That function calls
acpi_ec_transaction() which invokes acpi_ec_transaction_unlocked()
and the latter wakes up ec->wait under ec->lock, but it drops that
lock before returning.

When acpi_ec_query() returns, acpi_ec_event_handler() acquires
ec->lock and decrements ec->nr_pending_queries, but at that point
__acpi_ec_flush_event() (woken up previously) may already have
acquired ec->lock, checked the value of ec->nr_pending_queries (and
it would not have been zero then) and decided to go back to sleep.
Next, if ec->nr_pending_queries is equal to zero now, the loop
in acpi_ec_event_handler() terminates, ec->lock is released and
acpi_ec_check_event() is called, but it does nothing unless
ec_event_clearing is equal to ACPI_EC_EVT_TIMING_EVENT (which is
not the case by default).  In the end, if no more event work items
have been queued up while executing acpi_ec_transaction_unlocked(),
there is nothing to wake up __acpi_ec_flush_event() again and it
sleeps forever, so the suspend-to-idle loop cannot make progress and
the system is permanently suspended.

To avoid this issue, notice that it actually is not necessary to
wait for ec->nr_pending_queries to become zero in every case in
which __acpi_ec_flush_event() is used.

First, during platform-based system suspend (not suspend-to-idle),
__acpi_ec_flush_event() is called by acpi_ec_disable_event() after
clearing the EC_FLAGS_QUERY_ENABLED flag, which prevents
acpi_ec_submit_query() from submitting any new event work items,
so calling flush_scheduled_work() and flushing ec_query_wq
subsequently (in order to wait until all of the queries in that
queue have been processed) would be sufficient to flush all of
the pending EC work in that case.

Second, the purpose of the flushing of pending EC work while
suspended-to-idle described above really is to wait until the
first event work item coming from acpi_ec_dispatch_gpe() is
complete, because it should produce system wakeup events if
that is a valid EC-based system wakeup, so calling
flush_scheduled_work() followed by flushing ec_query_wq is also
sufficient for that purpose.

Rework the code to follow the above observations.

Fixes: 56b9918490 ("PM: sleep: Simplify suspend-to-idle control flow")
Reported-by: Kenneth R. Crudup <kenny@panix.com>
Tested-by: Kenneth R. Crudup <kenny@panix.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -525,26 +525,10 @@ static void acpi_ec_enable_event(struct
 }
 
 #ifdef CONFIG_PM_SLEEP
-static bool acpi_ec_query_flushed(struct acpi_ec *ec)
+static void __acpi_ec_flush_work(void)
 {
-	bool flushed;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ec->lock, flags);
-	flushed = !ec->nr_pending_queries;
-	spin_unlock_irqrestore(&ec->lock, flags);
-	return flushed;
-}
-
-static void __acpi_ec_flush_event(struct acpi_ec *ec)
-{
-	/*
-	 * When ec_freeze_events is true, we need to flush events in
-	 * the proper position before entering the noirq stage.
-	 */
-	wait_event(ec->wait, acpi_ec_query_flushed(ec));
-	if (ec_query_wq)
-		flush_workqueue(ec_query_wq);
+	flush_scheduled_work(); /* flush ec->work */
+	flush_workqueue(ec_query_wq); /* flush queries */
 }
 
 static void acpi_ec_disable_event(struct acpi_ec *ec)
@@ -554,15 +538,21 @@ static void acpi_ec_disable_event(struct
 	spin_lock_irqsave(&ec->lock, flags);
 	__acpi_ec_disable_event(ec);
 	spin_unlock_irqrestore(&ec->lock, flags);
-	__acpi_ec_flush_event(ec);
+
+	/*
+	 * When ec_freeze_events is true, we need to flush events in
+	 * the proper position before entering the noirq stage.
+	 */
+	__acpi_ec_flush_work();
 }
 
 void acpi_ec_flush_work(void)
 {
-	if (first_ec)
-		__acpi_ec_flush_event(first_ec);
+	/* Without ec_query_wq there is nothing to flush. */
+	if (!ec_query_wq)
+		return;
 
-	flush_scheduled_work();
+	__acpi_ec_flush_work();
 }
 #endif /* CONFIG_PM_SLEEP */
 


