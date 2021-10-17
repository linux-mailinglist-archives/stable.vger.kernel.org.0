Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF3943081F
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 12:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245360AbhJQKpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 06:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245356AbhJQKpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 06:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B473604DB;
        Sun, 17 Oct 2021 10:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634467371;
        bh=ygrEPY8u+yd018YkvRzFomQd4n9EJUgY/o779P6NyzM=;
        h=Subject:To:Cc:From:Date:From;
        b=djnRZKY8dYGG39K8mTIZN3Wrp2RJukoF4VqA2pNg6kagjWG08NryJcAu78WcFEuqs
         meb2r/9b5A0UMDDuGLmi/Kaq934HMa95F8RVcIHG6rkmcGzlD4S/33KbFukYQ/AHgQ
         t5NSEcAzXpl7aRnQ73GxljoxU67oOFXglqw+1AxQ=
Subject: FAILED: patch "[PATCH] workqueue: fix state-dump console deadlock" failed to apply to 5.14-stable tree
To:     johan@kernel.org, festevam@denx.de, john.ogness@linutronix.de,
        tj@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Oct 2021 12:42:35 +0200
Message-ID: <163446735515877@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57116ce17b04fde2fe30f0859df69d8dbe5809f6 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 6 Oct 2021 13:58:52 +0200
Subject: [PATCH] workqueue: fix state-dump console deadlock

Console drivers often queue work while holding locks also taken in their
console write paths, something which can lead to deadlocks on SMP when
dumping workqueue state (e.g. sysrq-t or on suspend failures).

For serial console drivers this could look like:

	CPU0				CPU1
	----				----

	show_workqueue_state();
	  lock(&pool->lock);		<IRQ>
	  				  lock(&port->lock);
					  schedule_work();
					    lock(&pool->lock);
	  printk();
	    lock(console_owner);
	    lock(&port->lock);

where workqueues are, for example, used to push data to the line
discipline, process break signals and handle modem-status changes. Line
disciplines and serdev drivers can also queue work on write-wakeup
notifications, etc.

Reworking every console driver to avoid queuing work while holding locks
also taken in their write paths would complicate drivers and is neither
desirable or feasible.

Instead use the deferred-printk mechanism to avoid printing while
holding pool locks when dumping workqueue state.

Note that there are a few WARN_ON() assertions in the workqueue code
which could potentially also trigger a deadlock. Hopefully the ongoing
printk rework will provide a general solution for this eventually.

This was originally reported after a lockdep splat when executing
sysrq-t with the imx serial driver.

Fixes: 3494fc30846d ("workqueue: dump workqueues on sysrq-t")
Cc: stable@vger.kernel.org	# 4.0
Reported-by: Fabio Estevam <festevam@denx.de>
Tested-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 33a6b4a2443d..1b3eb1e9531f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4830,8 +4830,16 @@ void show_workqueue_state(void)
 
 		for_each_pwq(pwq, wq) {
 			raw_spin_lock_irqsave(&pwq->pool->lock, flags);
-			if (pwq->nr_active || !list_empty(&pwq->inactive_works))
+			if (pwq->nr_active || !list_empty(&pwq->inactive_works)) {
+				/*
+				 * Defer printing to avoid deadlocks in console
+				 * drivers that queue work while holding locks
+				 * also taken in their write paths.
+				 */
+				printk_deferred_enter();
 				show_pwq(pwq);
+				printk_deferred_exit();
+			}
 			raw_spin_unlock_irqrestore(&pwq->pool->lock, flags);
 			/*
 			 * We could be printing a lot from atomic context, e.g.
@@ -4849,7 +4857,12 @@ void show_workqueue_state(void)
 		raw_spin_lock_irqsave(&pool->lock, flags);
 		if (pool->nr_workers == pool->nr_idle)
 			goto next_pool;
-
+		/*
+		 * Defer printing to avoid deadlocks in console drivers that
+		 * queue work while holding locks also taken in their write
+		 * paths.
+		 */
+		printk_deferred_enter();
 		pr_info("pool %d:", pool->id);
 		pr_cont_pool_info(pool);
 		pr_cont(" hung=%us workers=%d",
@@ -4864,6 +4877,7 @@ void show_workqueue_state(void)
 			first = false;
 		}
 		pr_cont("\n");
+		printk_deferred_exit();
 	next_pool:
 		raw_spin_unlock_irqrestore(&pool->lock, flags);
 		/*

