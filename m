Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC893E3977
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhHHHXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231576AbhHHHXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E8DE60C40;
        Sun,  8 Aug 2021 07:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407396;
        bh=t2x4MMJGjpeLVqHrlnTStvWC0xWniWrXx/JRaH3tJuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZYBZM22HNC8iHtWlupw5xzk0yNDySCzbQl3XVmSyy6XlWQl3x0+e93hBb13T9zFk
         Hs3Nc+NUr3kTlPTHnC93q38j189PY4lVPxThKjqkFQ9jKvrGv2f41Mk9crgRHwoe+A
         fUkfqCu5senawOPhvfTIL3RGk5RsbNX8aZZ2NiZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gratian Crisan <gratian.crisan@ni.com>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Joe Korty <joe.korty@concurrent-rt.com>
Subject: [PATCH 4.4 08/11] futex: Handle transient "ownerless" rtmutex state correctly
Date:   Sun,  8 Aug 2021 09:22:43 +0200
Message-Id: <20210808072217.606471864@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210808072217.322468704@linuxfoundation.org>
References: <20210808072217.322468704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

[ Upstream commit 9f5d1c336a10c0d24e83e40b4c1b9539f7dba627 ]

Gratian managed to trigger the BUG_ON(!newowner) in fixup_pi_state_owner().
This is one possible chain of events leading to this:

Task Prio       Operation
T1   120	lock(F)
T2   120	lock(F)   -> blocks (top waiter)
T3   50 (RT)	lock(F)   -> boosts T1 and blocks (new top waiter)
XX   		timeout/  -> wakes T2
		signal
T1   50		unlock(F) -> wakes T3 (rtmutex->owner == NULL, waiter bit is set)
T2   120	cleanup   -> try_to_take_mutex() fails because T3 is the top waiter
     			     and the lower priority T2 cannot steal the lock.
     			  -> fixup_pi_state_owner() sees newowner == NULL -> BUG_ON()

The comment states that this is invalid and rt_mutex_real_owner() must
return a non NULL owner when the trylock failed, but in case of a queued
and woken up waiter rt_mutex_real_owner() == NULL is a valid transient
state. The higher priority waiter has simply not yet managed to take over
the rtmutex.

The BUG_ON() is therefore wrong and this is just another retry condition in
fixup_pi_state_owner().

Drop the locks, so that T3 can make progress, and then try the fixup again.

Gratian provided a great analysis, traces and a reproducer. The analysis is
to the point, but it confused the hell out of that tglx dude who had to
page in all the futex horrors again. Condensed version is above.

[ tglx: Wrote comment and changelog ]

Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
Reported-by: Gratian Crisan <gratian.crisan@ni.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87a6w6x7bb.fsf@ni.com
Link: https://lore.kernel.org/r/87sg9pkvf7.fsf@nanos.tec.linutronix.de
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2437,10 +2437,22 @@ retry:
 		}
 
 		/*
-		 * Since we just failed the trylock; there must be an owner.
+		 * The trylock just failed, so either there is an owner or
+		 * there is a higher priority waiter than this one.
 		 */
 		newowner = rt_mutex_owner(&pi_state->pi_mutex);
-		BUG_ON(!newowner);
+		/*
+		 * If the higher priority waiter has not yet taken over the
+		 * rtmutex then newowner is NULL. We can't return here with
+		 * that state because it's inconsistent vs. the user space
+		 * state. So drop the locks and try again. It's a valid
+		 * situation and not any different from the other retry
+		 * conditions.
+		 */
+		if (unlikely(!newowner)) {
+			err = -EAGAIN;
+			goto handle_fault;
+		}
 	} else {
 		WARN_ON_ONCE(argowner != current);
 		if (oldowner == current) {


