Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD027423D67
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 14:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbhJFMDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 08:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238167AbhJFMDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 08:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40DF661151;
        Wed,  6 Oct 2021 12:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633521671;
        bh=ymrJ8GEZjJOzlz8voJgghmaov/XpttXyjUhcxY3Gz5g=;
        h=From:To:Cc:Subject:Date:From;
        b=Lyz32HR1VzD/3w+DJNVDuSy+v2TPRL6ZH+9MDsRo30BKKIOXWSQ2Op+MKyS2DHdMP
         CFIWxlBgNKuNPPk/r9ikRSKvboVM2EE4ZgR+pMbXNYzqXXdep2bLwo+tqP9aMfArjd
         gCN7+B8I5oofoLm0wTPXuTliLWFWj5Lpa6P+vG98HsmGPy4jy9tBNypEL+2R8mralF
         78cH5OLkm6XlILQHD/YsgjndJ0m0jzXvmOZnOrdUUf2RaGeMQkIrpnq1WTrZ+kCQLZ
         y2u62R3FRf+PRfbi4s98Ar+5BlpW7B9dQFEjXOinajTBAuLC+z4bO/kvR9DBrcJhVS
         kx6NLoyKyWs5w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mY5bg-0004RO-Pw; Wed, 06 Oct 2021 14:01:08 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@denx.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] workqueue: fix state-dump console deadlock
Date:   Wed,  6 Oct 2021 13:58:52 +0200
Message-Id: <20211006115852.16986-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Changes in v2
 - defer printing also of worker pool state (Peter Mladek)
 - add Fabio's tested-by tag


 kernel/workqueue.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

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
-- 
2.32.0

