Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939843D7E31
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhG0TAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhG0TAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 15:00:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF13C061757;
        Tue, 27 Jul 2021 12:00:34 -0700 (PDT)
Date:   Tue, 27 Jul 2021 19:00:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1627412430;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hjXqd+8WALUAXb/KLRjFz68ozAL0V3ApCcpw58bV/6g=;
        b=Hz8E+Ga31/sFe2JSkrtSreMwKexs4S/nTKA7Nucg4JJ06r6GCYb+UDMcOUSmMLKAEpGx1+
        AkU5jzCGgKySUeSZKtFqpZGzxqTYQ9X6VYf/dV2MX54wJ+63UmE/X+qtGIJ6D3Ugn+goJF
        wzOo8wBEFS+2xp013AX3mMYAmLr1UTYeDSMpjWgVNMo+MlKVfoxnYdAIzYvje8MQJ/2vij
        bPXRp0sLcnCIMQem8HCnFspOHDQFZa3LNZsImehVWGzwNBzc/XhC0BNAFgRnDNnT6q2nUJ
        728v1WuzYLO7AzxIUrAdLO9HCQ5ikJBRAaXceSKRlAcz6uFOwa0kDAXDYQPQcA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1627412430;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hjXqd+8WALUAXb/KLRjFz68ozAL0V3ApCcpw58bV/6g=;
        b=3CmNbDmHkGsB7y2g+mUzdW9PW30EEJS5hQRBZe3Ibp2hMEGNfeHLk/zvf2FtWByS3hY8CP
        rgedoZQdquKmdjAg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] timers: Move clearing of base::timer_running
 under base:: Lock
Cc:     syzbot+aa7c2385d46c5eba0b89@syzkaller.appspotmail.com,
        syzbot+abea4558531bae1ba9fe@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87lfea7gw8.fsf@nanos.tec.linutronix.de>
References: <87lfea7gw8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <162741242945.395.1178547166318427399.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     bb7262b295472eb6858b5c49893954794027cd84
Gitweb:        https://git.kernel.org/tip/bb7262b295472eb6858b5c49893954794027cd84
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sun, 06 Dec 2020 22:40:07 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 27 Jul 2021 20:57:44 +02:00

timers: Move clearing of base::timer_running under base:: Lock

syzbot reported KCSAN data races vs. timer_base::timer_running being set to
NULL without holding base::lock in expire_timers().

This looks innocent and most reads are clearly not problematic, but
Frederic identified an issue which is:

 int data = 0;

 void timer_func(struct timer_list *t)
 {
    data = 1;
 }

 CPU 0                                            CPU 1
 ------------------------------                   --------------------------
 base = lock_timer_base(timer, &flags);           raw_spin_unlock(&base->lock);
 if (base->running_timer != timer)                call_timer_fn(timer, fn, baseclk);
   ret = detach_if_pending(timer, base, true);    base->running_timer = NULL;
 raw_spin_unlock_irqrestore(&base->lock, flags);  raw_spin_lock(&base->lock);

 x = data;

If the timer has previously executed on CPU 1 and then CPU 0 can observe
base->running_timer == NULL and returns, assuming the timer has completed,
but it's not guaranteed on all architectures. The comment for
del_timer_sync() makes that guarantee. Moving the assignment under
base->lock prevents this.

For non-RT kernel it's performance wise completely irrelevant whether the
store happens before or after taking the lock. For an RT kernel moving the
store under the lock requires an extra unlock/lock pair in the case that
there is a waiter for the timer, but that's not the end of the world.

Reported-by: syzbot+aa7c2385d46c5eba0b89@syzkaller.appspotmail.com
Reported-by: syzbot+abea4558531bae1ba9fe@syzkaller.appspotmail.com
Fixes: 030dcdd197d7 ("timers: Prepare support for PREEMPT_RT")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/87lfea7gw8.fsf@nanos.tec.linutronix.de
Cc: stable@vger.kernel.org
---
 kernel/time/timer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 9eb11c2..e3d2c23 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1265,8 +1265,10 @@ static inline void timer_base_unlock_expiry(struct timer_base *base)
 static void timer_sync_wait_running(struct timer_base *base)
 {
 	if (atomic_read(&base->timer_waiters)) {
+		raw_spin_unlock_irq(&base->lock);
 		spin_unlock(&base->expiry_lock);
 		spin_lock(&base->expiry_lock);
+		raw_spin_lock_irq(&base->lock);
 	}
 }
 
@@ -1457,14 +1459,14 @@ static void expire_timers(struct timer_base *base, struct hlist_head *head)
 		if (timer->flags & TIMER_IRQSAFE) {
 			raw_spin_unlock(&base->lock);
 			call_timer_fn(timer, fn, baseclk);
-			base->running_timer = NULL;
 			raw_spin_lock(&base->lock);
+			base->running_timer = NULL;
 		} else {
 			raw_spin_unlock_irq(&base->lock);
 			call_timer_fn(timer, fn, baseclk);
+			raw_spin_lock_irq(&base->lock);
 			base->running_timer = NULL;
 			timer_sync_wait_running(base);
-			raw_spin_lock_irq(&base->lock);
 		}
 	}
 }
