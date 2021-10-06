Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C740D423977
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 10:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbhJFIOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 04:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237771AbhJFIOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 04:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D721960F9D;
        Wed,  6 Oct 2021 08:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633507943;
        bh=aJyTVkoBDT25cCj9K161A8klU5lEuxkvGK6eMdnsbKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLeAHFkMAjVAlwbAS8mJEu0Escwr0IctrL+9zn5ePsnJijA69oN7nkf/XsTOb1amz
         WLUiZqUozao1QXB4ucQXDGcM9tIp96qFy9SL+WqI2nrZ1g2ibAnCLL1xuD9180+Xor
         R1Q7Vz9RtQvUKewh0W3EzliNov81WwiLCr1WNHsXaAG/VXLVcXKNHE/yw+4aoJiPcr
         UxR8icm+iNTYCASy/C+65/lTAyY7GtXdzaaWr8jLcLxpq+3zMW1+8HJ81O6mbK10BO
         zHzRmWWxULuSWiuB8CDqFzdoFXyZwNzAFvimy7AT/eVFEo73cIiPtNBzStqqPi0fHb
         5Wh5I/5Mj2nUg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mY22K-0005L3-DB; Wed, 06 Oct 2021 10:12:24 +0200
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
Subject: [PATCH] workqueue: fix state-dump console deadlock
Date:   Wed,  6 Oct 2021 10:11:15 +0200
Message-Id: <20211006081115.20451-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YV1Z8JslFiBSFGJF@hovoldconsulting.com>
References: <YV1Z8JslFiBSFGJF@hovoldconsulting.com>
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
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 kernel/workqueue.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 33a6b4a2443d..fded64b48b96 100644
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
-- 
2.32.0

