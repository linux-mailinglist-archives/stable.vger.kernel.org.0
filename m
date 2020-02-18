Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8EF163226
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgBRUAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbgBRUAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8492464E;
        Tue, 18 Feb 2020 20:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056039;
        bh=zFBPkorORv1mDODvlEy84IkG/6oz+vyKN4G57irLDDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyVKbcL3sD65msr0/t0pp+o8unEeLxzd4QNVM0V9lvULoCwbJAUiHVwAvRA6yaNRl
         qC8FiZrexwhbQJX5B1DnLH1k0uCmJ9REeD+gqyNkKZ/Ts35gJvv79pPIou8Hs7lP2E
         fMggKyHfx3wrwz0+GQ98ta63TS8lJVQ8YT426WQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.5 12/80] ACPI: EC: Fix flushing of pending work
Date:   Tue, 18 Feb 2020 20:54:33 +0100
Message-Id: <20200218190433.261249514@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f0ac20c3f6137910c8a927953e8a92f5b3716166 upstream.

Commit 016b87ca5c8c ("ACPI: EC: Rework flushing of pending work")
introduced a subtle bug into the flushing of pending EC work while
suspended to idle, which may cause the EC driver to fail to
re-enable the EC GPE after handling a non-wakeup event (like a
battery status change event, for example).

The problem is that the work item flushed by flush_scheduled_work()
in __acpi_ec_flush_work() may disable the EC GPE and schedule another
work item expected to re-enable it, but that new work item is not
flushed, so __acpi_ec_flush_work() returns with the EC GPE disabled
and the CPU running it goes into an idle state subsequently.  If all
of the other CPUs are in idle states at that point, the EC GPE won't
be re-enabled until at least one CPU is woken up by another interrupt
source, so system wakeup events that would normally come from the EC
then don't work.

This is reproducible on a Dell XPS13 9360 in my office which
sometimes stops reacting to power button and lid events (triggered
by the EC on that machine) after switching from AC power to battery
power or vice versa while suspended to idle (each of those switches
causes the EC GPE to trigger for several times in a row, but they
are not system wakeup events).

To avoid this problem, it is necessary to drain the workqueue
entirely in __acpi_ec_flush_work(), but that cannot be done with
respect to system_wq, because work items may be added to it from
other places while __acpi_ec_flush_work() is running.  For this
reason, make the EC driver use a dedicated workqueue for EC events
processing (let that workqueue be ordered so that EC events are
processed sequentially) and use drain_workqueue() on it in
__acpi_ec_flush_work().

Fixes: 016b87ca5c8c ("ACPI: EC: Rework flushing of pending work")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -179,6 +179,7 @@ EXPORT_SYMBOL(first_ec);
 
 static struct acpi_ec *boot_ec;
 static bool boot_ec_is_ecdt = false;
+static struct workqueue_struct *ec_wq;
 static struct workqueue_struct *ec_query_wq;
 
 static int EC_FLAGS_QUERY_HANDSHAKE; /* Needs QR_EC issued when SCI_EVT set */
@@ -469,7 +470,7 @@ static void acpi_ec_submit_query(struct
 		ec_dbg_evt("Command(%s) submitted/blocked",
 			   acpi_ec_cmd_string(ACPI_EC_COMMAND_QUERY));
 		ec->nr_pending_queries++;
-		schedule_work(&ec->work);
+		queue_work(ec_wq, &ec->work);
 	}
 }
 
@@ -535,7 +536,7 @@ static void acpi_ec_enable_event(struct
 #ifdef CONFIG_PM_SLEEP
 static void __acpi_ec_flush_work(void)
 {
-	flush_scheduled_work(); /* flush ec->work */
+	drain_workqueue(ec_wq); /* flush ec->work */
 	flush_workqueue(ec_query_wq); /* flush queries */
 }
 
@@ -556,8 +557,8 @@ static void acpi_ec_disable_event(struct
 
 void acpi_ec_flush_work(void)
 {
-	/* Without ec_query_wq there is nothing to flush. */
-	if (!ec_query_wq)
+	/* Without ec_wq there is nothing to flush. */
+	if (!ec_wq)
 		return;
 
 	__acpi_ec_flush_work();
@@ -2115,25 +2116,33 @@ static struct acpi_driver acpi_ec_driver
 	.drv.pm = &acpi_ec_pm,
 };
 
-static inline int acpi_ec_query_init(void)
+static void acpi_ec_destroy_workqueues(void)
 {
-	if (!ec_query_wq) {
-		ec_query_wq = alloc_workqueue("kec_query", 0,
-					      ec_max_queries);
-		if (!ec_query_wq)
-			return -ENODEV;
+	if (ec_wq) {
+		destroy_workqueue(ec_wq);
+		ec_wq = NULL;
 	}
-	return 0;
-}
-
-static inline void acpi_ec_query_exit(void)
-{
 	if (ec_query_wq) {
 		destroy_workqueue(ec_query_wq);
 		ec_query_wq = NULL;
 	}
 }
 
+static int acpi_ec_init_workqueues(void)
+{
+	if (!ec_wq)
+		ec_wq = alloc_ordered_workqueue("kec", 0);
+
+	if (!ec_query_wq)
+		ec_query_wq = alloc_workqueue("kec_query", 0, ec_max_queries);
+
+	if (!ec_wq || !ec_query_wq) {
+		acpi_ec_destroy_workqueues();
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static const struct dmi_system_id acpi_ec_no_wakeup[] = {
 	{
 		.ident = "Thinkpad X1 Carbon 6th",
@@ -2164,8 +2173,7 @@ int __init acpi_ec_init(void)
 	int result;
 	int ecdt_fail, dsdt_fail;
 
-	/* register workqueue for _Qxx evaluations */
-	result = acpi_ec_query_init();
+	result = acpi_ec_init_workqueues();
 	if (result)
 		return result;
 
@@ -2196,6 +2204,6 @@ static void __exit acpi_ec_exit(void)
 {
 
 	acpi_bus_unregister_driver(&acpi_ec_driver);
-	acpi_ec_query_exit();
+	acpi_ec_destroy_workqueues();
 }
 #endif	/* 0 */


