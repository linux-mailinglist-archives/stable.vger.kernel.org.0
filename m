Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B25DA0EB
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfJPWRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395092AbfJPVyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:55 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B88521928;
        Wed, 16 Oct 2019 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262894;
        bh=+IG6tGYgGoLbuBZ79yfPKMgVZv30lypkPm307m9NWhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozkMzroh/oEI6nE29Lw1ux/fR1QQcdjsGgAMJ2SG1IbRfTS+am/MgqhEEdHq0hb3v
         CrelDg9DeV2yUvG6aQiIywHmNjm7UR/FwsZ+8BoGLmiB2OcBFJNJsh1NzNJ/Qim/00
         jJjGvDV+nvUUdorcyOI6oCKz7vtscCTLZW+fqhgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Liang ZhiCheng <liangzhicheng@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 11/92] timer: Read jiffies once when forwarding base clk
Date:   Wed, 16 Oct 2019 14:49:44 -0700
Message-Id: <20191016214807.820860828@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

commit e430d802d6a3aaf61bd3ed03d9404888a29b9bf9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1586,21 +1586,23 @@ void timer_clear_idle(void)
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
 			/* The call site will increment clock! */
-			base->clk = jiffies - 1;
+			base->clk = now - 1;
 			return 0;
 		}
 		base->clk = next;


