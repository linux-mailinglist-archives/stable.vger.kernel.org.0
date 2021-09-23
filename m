Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21244156CC
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbhIWDnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239310AbhIWDmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E5026124D;
        Thu, 23 Sep 2021 03:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368406;
        bh=htC7IBlUxwUYSSB+pZhwJu+KsbGIN7ATgsvr5svQKEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaZOeAwGs9WIUzsCAxHUSP54VFWvZO0xcOD+zD480mZ9hDTBHJviML7fW29m8iuYD
         Z2FCzju95yVL6GwSDAYbX2GsJR8YLG/j0zutSC67VYiPIDaX3jbDGw9H8fqeoNrYn2
         z62Ltcj68XyVBdmdRdtnSI+1C2JNGlsls4Q8jKROrC3NjSntWCOAwUbt4xwlHCCL1p
         tv0cN9FkyBPFGt4DhxhIdgQ5qLdRhmSehdcH1/B4Lz+7fx7bcpawSwy/lUUNhLQfQB
         lCVHpyNTj3p9sDAVf2j+6E+VCUWB6KZuWcPTNTeNZmAnMKzOr7dFsDzoj9Ud+CCaEF
         Wic11KYIl2Smg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.14 04/13] xen/balloon: use a kernel thread instead a workqueue
Date:   Wed, 22 Sep 2021 23:39:50 -0400
Message-Id: <20210923033959.1421662-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033959.1421662-1-sashal@kernel.org>
References: <20210923033959.1421662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 8480ed9c2bbd56fc86524998e5f2e3e22f5038f6 ]

Today the Xen ballooning is done via delayed work in a workqueue. This
might result in workqueue hangups being reported in case of large
amounts of memory are being ballooned in one go (here 16GB):

BUG: workqueue lockup - pool cpus=6 node=0 flags=0x0 nice=0 stuck for 64s!
Showing busy workqueues and worker pools:
workqueue events: flags=0x0
  pwq 12: cpus=6 node=0 flags=0x0 nice=0 active=2/256 refcnt=3
    in-flight: 229:balloon_process
    pending: cache_reap
workqueue events_freezable_power_: flags=0x84
  pwq 12: cpus=6 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
    pending: disk_events_workfn
workqueue mm_percpu_wq: flags=0x8
  pwq 12: cpus=6 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
    pending: vmstat_update
pool 12: cpus=6 node=0 flags=0x0 nice=0 hung=64s workers=3 idle: 2222 43

This can easily be avoided by using a dedicated kernel thread for doing
the ballooning work.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210827123206.15429-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/balloon.c | 62 +++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a8e0836dffd4..b9abe3ef2188 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -43,6 +43,8 @@
 #include <linux/sched.h>
 #include <linux/cred.h>
 #include <linux/errno.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
 #include <linux/mm.h>
 #include <linux/bootmem.h>
 #include <linux/pagemap.h>
@@ -119,7 +121,7 @@ static struct ctl_table xen_root[] = {
 #define EXTENT_ORDER (fls(XEN_PFN_PER_PAGE) - 1)
 
 /*
- * balloon_process() state:
+ * balloon_thread() state:
  *
  * BP_DONE: done or nothing to do,
  * BP_WAIT: wait to be rescheduled,
@@ -134,6 +136,8 @@ enum bp_state {
 	BP_ECANCELED
 };
 
+/* Main waiting point for xen-balloon thread. */
+static DECLARE_WAIT_QUEUE_HEAD(balloon_thread_wq);
 
 static DEFINE_MUTEX(balloon_mutex);
 
@@ -148,10 +152,6 @@ static xen_pfn_t frame_list[PAGE_SIZE / sizeof(xen_pfn_t)];
 static LIST_HEAD(ballooned_pages);
 static DECLARE_WAIT_QUEUE_HEAD(balloon_wq);
 
-/* Main work function, always executed in process context. */
-static void balloon_process(struct work_struct *work);
-static DECLARE_DELAYED_WORK(balloon_worker, balloon_process);
-
 /* When ballooning out (allocating memory to return to Xen) we don't really
    want the kernel to try too hard since that can trigger the oom killer. */
 #define GFP_BALLOON \
@@ -389,7 +389,7 @@ static void xen_online_page(struct page *page)
 static int xen_memory_notifier(struct notifier_block *nb, unsigned long val, void *v)
 {
 	if (val == MEM_ONLINE)
-		schedule_delayed_work(&balloon_worker, 0);
+		wake_up(&balloon_thread_wq);
 
 	return NOTIFY_OK;
 }
@@ -571,18 +571,43 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 }
 
 /*
- * As this is a work item it is guaranteed to run as a single instance only.
+ * Stop waiting if either state is not BP_EAGAIN and ballooning action is
+ * needed, or if the credit has changed while state is BP_EAGAIN.
+ */
+static bool balloon_thread_cond(enum bp_state state, long credit)
+{
+	if (state != BP_EAGAIN)
+		credit = 0;
+
+	return current_credit() != credit || kthread_should_stop();
+}
+
+/*
+ * As this is a kthread it is guaranteed to run as a single instance only.
  * We may of course race updates of the target counts (which are protected
  * by the balloon lock), or with changes to the Xen hard limit, but we will
  * recover from these in time.
  */
-static void balloon_process(struct work_struct *work)
+static int balloon_thread(void *unused)
 {
 	enum bp_state state = BP_DONE;
 	long credit;
+	unsigned long timeout;
+
+	set_freezable();
+	for (;;) {
+		if (state == BP_EAGAIN)
+			timeout = balloon_stats.schedule_delay * HZ;
+		else
+			timeout = 3600 * HZ;
+		credit = current_credit();
 
+		wait_event_interruptible_timeout(balloon_thread_wq,
+				 balloon_thread_cond(state, credit), timeout);
+
+		if (kthread_should_stop())
+			return 0;
 
-	do {
 		mutex_lock(&balloon_mutex);
 
 		credit = current_credit();
@@ -609,12 +634,7 @@ static void balloon_process(struct work_struct *work)
 		mutex_unlock(&balloon_mutex);
 
 		cond_resched();
-
-	} while (credit && state == BP_DONE);
-
-	/* Schedule more work if there is some still to be done. */
-	if (state == BP_EAGAIN)
-		schedule_delayed_work(&balloon_worker, balloon_stats.schedule_delay * HZ);
+	}
 }
 
 /* Resets the Xen limit, sets new target, and kicks off processing. */
@@ -622,7 +642,7 @@ void balloon_set_new_target(unsigned long target)
 {
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.target_pages = target;
-	schedule_delayed_work(&balloon_worker, 0);
+	wake_up(&balloon_thread_wq);
 }
 EXPORT_SYMBOL_GPL(balloon_set_new_target);
 
@@ -727,7 +747,7 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
 
 	/* The balloon may be too large now. Shrink it if needed. */
 	if (current_credit())
-		schedule_delayed_work(&balloon_worker, 0);
+		wake_up(&balloon_thread_wq);
 
 	mutex_unlock(&balloon_mutex);
 }
@@ -761,6 +781,8 @@ static void __init balloon_add_region(unsigned long start_pfn,
 
 static int __init balloon_init(void)
 {
+	struct task_struct *task;
+
 	if (!xen_domain())
 		return -ENODEV;
 
@@ -804,6 +826,12 @@ static int __init balloon_init(void)
 	}
 #endif
 
+	task = kthread_run(balloon_thread, NULL, "xen-balloon");
+	if (IS_ERR(task)) {
+		pr_err("xen-balloon thread could not be started, ballooning will not work!\n");
+		return PTR_ERR(task);
+	}
+
 	/* Init the xen-balloon driver. */
 	xen_balloon_init();
 
-- 
2.30.2

