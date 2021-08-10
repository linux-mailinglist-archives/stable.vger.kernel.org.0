Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF75E3E81C5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbhHJSCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234851AbhHJSAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862976139F;
        Tue, 10 Aug 2021 17:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617608;
        bh=e550DMyvd6Ig4dLJ8EyHUKjkfg7Ghj7WJ4I0ornA3Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy0tWOrywneIJc6h/xP172oitjbdvj16S7DQq0HIJrFNWvkK/eZ15noP+mWpJvMBn
         kZtgN9q2ATIKJIzQphZjAbu5NB4JdW4WP1H76WhB3JDlP6/ZauVD+Qs/VaBSotW6nG
         aNA1cLnF/3lP7nngsKEaRH8+DYPEMDQMZaY7ICgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+aa7c2385d46c5eba0b89@syzkaller.appspotmail.com,
        syzbot+abea4558531bae1ba9fe@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5.13 132/175] timers: Move clearing of base::timer_running under base:: Lock
Date:   Tue, 10 Aug 2021 19:30:40 +0200
Message-Id: <20210810173005.296442500@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit bb7262b295472eb6858b5c49893954794027cd84 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1279,8 +1279,10 @@ static inline void timer_base_unlock_exp
 static void timer_sync_wait_running(struct timer_base *base)
 {
 	if (atomic_read(&base->timer_waiters)) {
+		raw_spin_unlock_irq(&base->lock);
 		spin_unlock(&base->expiry_lock);
 		spin_lock(&base->expiry_lock);
+		raw_spin_lock_irq(&base->lock);
 	}
 }
 
@@ -1471,14 +1473,14 @@ static void expire_timers(struct timer_b
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


