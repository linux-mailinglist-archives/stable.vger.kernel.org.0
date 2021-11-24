Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEE945BF74
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345243AbhKXM64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345916AbhKXM4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:56:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62451611C7;
        Wed, 24 Nov 2021 12:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757138;
        bh=K+wEwZiDKkqq0t6QOW0dxQvL7+XcIP/VJFY3u+C1heQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSt1AoKTC5eQDc6ySDnSA3x8H9XyN+aES8XFELuzhLs1QEy/oCiFbx5qzP3+QCnsk
         7vsnUTU3GDoDwgczZiWYRE25QqTs7dzIpdx5Vt8q1tYFVVEVamPvOUpk904w/ShNBB
         rUOl8cpimKDp95/MotgJvQQ0iAuihD12g3aFauyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.19 071/323] xen/balloon: add late_initcall_sync() for initial ballooning done
Date:   Wed, 24 Nov 2021 12:54:21 +0100
Message-Id: <20211124115721.257579601@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 40fdea0284bb20814399da0484a658a96c735d90 upstream.

When running as PVH or HVM guest with actual memory < max memory the
hypervisor is using "populate on demand" in order to allow the guest
to balloon down from its maximum memory size. For this to work
correctly the guest must not touch more memory pages than its target
memory size as otherwise the PoD cache will be exhausted and the guest
is crashed as a result of that.

In extreme cases ballooning down might not be finished today before
the init process is started, which can consume lots of memory.

In order to avoid random boot crashes in such cases, add a late init
call to wait for ballooning down having finished for PVH/HVM guests.

Warn on console if initial ballooning fails, panic() after stalling
for more than 3 minutes per default. Add a module parameter for
changing this timeout.

[boris: replaced pr_info() with pr_notice()]

Cc: <stable@vger.kernel.org>
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20211102091944.17487-1-jgross@suse.com
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    7 +
 drivers/xen/balloon.c                           |   86 +++++++++++++++++-------
 2 files changed, 70 insertions(+), 23 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5284,6 +5284,13 @@
 			with /sys/devices/system/xen_memory/xen_memory0/scrub_pages.
 			Default value controlled with CONFIG_XEN_SCRUB_PAGES_DEFAULT.
 
+	xen.balloon_boot_timeout= [XEN]
+			The time (in seconds) to wait before giving up to boot
+			in case initial ballooning fails to free enough memory.
+			Applies only when running as HVM or PVH guest and
+			started with less memory configured than allowed at
+			max. Default is 180.
+
 	xen.event_eoi_delay=	[XEN]
 			How long to delay EOI handling in case of event
 			storms (jiffies). Default is 10.
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -58,6 +58,7 @@
 #include <linux/percpu-defs.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/moduleparam.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -75,6 +76,12 @@
 #include <xen/page.h>
 #include <xen/mem-reservation.h>
 
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "xen."
+
+static uint __read_mostly balloon_boot_timeout = 180;
+module_param(balloon_boot_timeout, uint, 0444);
+
 static int xen_hotplug_unpopulated;
 
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
@@ -130,12 +137,12 @@ static struct ctl_table xen_root[] = {
  * BP_ECANCELED: error, balloon operation canceled.
  */
 
-enum bp_state {
+static enum bp_state {
 	BP_DONE,
 	BP_WAIT,
 	BP_EAGAIN,
 	BP_ECANCELED
-};
+} balloon_state = BP_DONE;
 
 /* Main waiting point for xen-balloon thread. */
 static DECLARE_WAIT_QUEUE_HEAD(balloon_thread_wq);
@@ -206,18 +213,15 @@ static struct page *balloon_next_page(st
 	return list_entry(next, struct page, lru);
 }
 
-static enum bp_state update_schedule(enum bp_state state)
+static void update_schedule(void)
 {
-	if (state == BP_WAIT)
-		return BP_WAIT;
-
-	if (state == BP_ECANCELED)
-		return BP_ECANCELED;
+	if (balloon_state == BP_WAIT || balloon_state == BP_ECANCELED)
+		return;
 
-	if (state == BP_DONE) {
+	if (balloon_state == BP_DONE) {
 		balloon_stats.schedule_delay = 1;
 		balloon_stats.retry_count = 1;
-		return BP_DONE;
+		return;
 	}
 
 	++balloon_stats.retry_count;
@@ -226,7 +230,8 @@ static enum bp_state update_schedule(enu
 			balloon_stats.retry_count > balloon_stats.max_retry_count) {
 		balloon_stats.schedule_delay = 1;
 		balloon_stats.retry_count = 1;
-		return BP_ECANCELED;
+		balloon_state = BP_ECANCELED;
+		return;
 	}
 
 	balloon_stats.schedule_delay <<= 1;
@@ -234,7 +239,7 @@ static enum bp_state update_schedule(enu
 	if (balloon_stats.schedule_delay > balloon_stats.max_schedule_delay)
 		balloon_stats.schedule_delay = balloon_stats.max_schedule_delay;
 
-	return BP_EAGAIN;
+	balloon_state = BP_EAGAIN;
 }
 
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
@@ -511,9 +516,9 @@ static enum bp_state decrease_reservatio
  * Stop waiting if either state is BP_DONE and ballooning action is
  * needed, or if the credit has changed while state is not BP_DONE.
  */
-static bool balloon_thread_cond(enum bp_state state, long credit)
+static bool balloon_thread_cond(long credit)
 {
-	if (state == BP_DONE)
+	if (balloon_state == BP_DONE)
 		credit = 0;
 
 	return current_credit() != credit || kthread_should_stop();
@@ -527,13 +532,12 @@ static bool balloon_thread_cond(enum bp_
  */
 static int balloon_thread(void *unused)
 {
-	enum bp_state state = BP_DONE;
 	long credit;
 	unsigned long timeout;
 
 	set_freezable();
 	for (;;) {
-		switch (state) {
+		switch (balloon_state) {
 		case BP_DONE:
 		case BP_ECANCELED:
 			timeout = 3600 * HZ;
@@ -549,7 +553,7 @@ static int balloon_thread(void *unused)
 		credit = current_credit();
 
 		wait_event_freezable_timeout(balloon_thread_wq,
-			balloon_thread_cond(state, credit), timeout);
+			balloon_thread_cond(credit), timeout);
 
 		if (kthread_should_stop())
 			return 0;
@@ -560,22 +564,23 @@ static int balloon_thread(void *unused)
 
 		if (credit > 0) {
 			if (balloon_is_inflated())
-				state = increase_reservation(credit);
+				balloon_state = increase_reservation(credit);
 			else
-				state = reserve_additional_memory();
+				balloon_state = reserve_additional_memory();
 		}
 
 		if (credit < 0) {
 			long n_pages;
 
 			n_pages = min(-credit, si_mem_available());
-			state = decrease_reservation(n_pages, GFP_BALLOON);
-			if (state == BP_DONE && n_pages != -credit &&
+			balloon_state = decrease_reservation(n_pages,
+							     GFP_BALLOON);
+			if (balloon_state == BP_DONE && n_pages != -credit &&
 			    n_pages < totalreserve_pages)
-				state = BP_EAGAIN;
+				balloon_state = BP_EAGAIN;
 		}
 
-		state = update_schedule(state);
+		update_schedule();
 
 		mutex_unlock(&balloon_mutex);
 
@@ -784,3 +789,38 @@ static int __init balloon_init(void)
 	return 0;
 }
 subsys_initcall(balloon_init);
+
+static int __init balloon_wait_finish(void)
+{
+	long credit, last_credit = 0;
+	unsigned long last_changed = 0;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	/* PV guests don't need to wait. */
+	if (xen_pv_domain() || !current_credit())
+		return 0;
+
+	pr_notice("Waiting for initial ballooning down having finished.\n");
+
+	while ((credit = current_credit()) < 0) {
+		if (credit != last_credit) {
+			last_changed = jiffies;
+			last_credit = credit;
+		}
+		if (balloon_state == BP_ECANCELED) {
+			pr_warn_once("Initial ballooning failed, %ld pages need to be freed.\n",
+				     -credit);
+			if (jiffies - last_changed >= HZ * balloon_boot_timeout)
+				panic("Initial ballooning failed!\n");
+		}
+
+		schedule_timeout_interruptible(HZ / 10);
+	}
+
+	pr_notice("Initial ballooning down finished.\n");
+
+	return 0;
+}
+late_initcall_sync(balloon_wait_finish);


