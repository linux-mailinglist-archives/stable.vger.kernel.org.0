Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214CCB7E91
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 17:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391460AbfISPwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 11:52:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50194 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390134AbfISPwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 11:52:13 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iAyiw-0007jL-NO; Thu, 19 Sep 2019 17:52:02 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 1DCF51C0896;
        Thu, 19 Sep 2019 17:52:02 +0200 (CEST)
Date:   Thu, 19 Sep 2019 15:52:01 -0000
From:   "tip-bot2 for Li RongQing" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] timer: Read jiffies once when forwarding base clk
Cc:     Li RongQing <lirongqing@baidu.com>,
        Liang ZhiCheng <liangzhicheng@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1568894687-14499-1-git-send-email-lirongqing@baidu.com>
References: <1568894687-14499-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Message-ID: <156890832199.24167.16270557930790056516.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     e430d802d6a3aaf61bd3ed03d9404888a29b9bf9
Gitweb:        https://git.kernel.org/tip/e430d802d6a3aaf61bd3ed03d9404888a29b9bf9
Author:        Li RongQing <lirongqing@baidu.com>
AuthorDate:    Thu, 19 Sep 2019 20:04:47 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 19 Sep 2019 17:50:11 +02:00

timer: Read jiffies once when forwarding base clk

The timer delayed for more than 3 seconds warning was triggered during
testing.

  Workqueue: events_unbound sched_tick_remote
  RIP: 0010:sched_tick_remote+0xee/0x100
  ...
  Call Trace:
   process_one_work+0x18c/0x3a0
   worker_thread+0x30/0x380
   kthread+0x113/0x130
   ret_from_fork+0x22/0x40

The reason is that the code in collect_expired_timers() uses jiffies
unprotected:

    if (next_event > jiffies)
        base->clk = jiffies;

As the compiler is allowed to reload the value base->clk can advance
between the check and the store and in the worst case advance farther than
next event. That causes the timer expiry to be delayed until the wheel
pointer wraps around.

Convert the code to use READ_ONCE()

Fixes: 236968383cf5 ("timers: Optimize collect_expired_timers() for NOHZ")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Liang ZhiCheng <liangzhicheng@baidu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1568894687-14499-1-git-send-email-lirongqing@baidu.com

---
 kernel/time/timer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 0e315a2..4820823 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1678,24 +1678,26 @@ void timer_clear_idle(void)
 static int collect_expired_timers(struct timer_base *base,
 				  struct hlist_head *heads)
 {
+	unsigned long now = READ_ONCE(jiffies);
+
 	/*
 	 * NOHZ optimization. After a long idle sleep we need to forward the
 	 * base to current jiffies. Avoid a loop by searching the bitfield for
 	 * the next expiring timer.
 	 */
-	if ((long)(jiffies - base->clk) > 2) {
+	if ((long)(now - base->clk) > 2) {
 		unsigned long next = __next_timer_interrupt(base);
 
 		/*
 		 * If the next timer is ahead of time forward to current
 		 * jiffies, otherwise forward to the next expiry time:
 		 */
-		if (time_after(next, jiffies)) {
+		if (time_after(next, now)) {
 			/*
 			 * The call site will increment base->clk and then
 			 * terminate the expiry loop immediately.
 			 */
-			base->clk = jiffies;
+			base->clk = now;
 			return 0;
 		}
 		base->clk = next;
