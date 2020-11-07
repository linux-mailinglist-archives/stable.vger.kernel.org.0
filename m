Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBB32AA805
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 22:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgKGVIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 16:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGVIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 16:08:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF3CC0613CF;
        Sat,  7 Nov 2020 13:08:24 -0800 (PST)
Date:   Sat, 07 Nov 2020 21:08:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604783302;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WmfDsakZIWHD+NwFPXvMcaDmIMMEaMz35ydaZGU4Npo=;
        b=OdHBpqRnq2pngGGtp4TDB6+NdExoHQIkMiKk8p5CCLrXlWfF6ynCBLh1Hm7CbFR8hTQZ0d
        JMJVAauYmrUUU5k0WGlsR2tGEbSNU2Qi0DOnnas397TXJwrPR19/mkWsXvTLb/GIKgw6Dp
        Yv+o4zDUm8zHmaVC1M/hB/RhYglckIEyFcnHsZgg2AhrnSJoYeLki+iWW5BVW9rX7mMoqV
        8TdJyJ7jLG9lMVp/1OtdYt8WkHLLUjiQXRKhvf/wMXyHKiEvcQ4ZNBw6cVV9q8INeS0G3d
        EeTSr+HrDlZgstAVE62ByYotMbpg4pqYsi650iAXHh8NhCxa9pEnCwEbqgTflg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604783302;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WmfDsakZIWHD+NwFPXvMcaDmIMMEaMz35ydaZGU4Npo=;
        b=ZGnaczaf5mxaTTb8NcztQhTFfYXv9Cm3zpJU4ih4EDFug8abLZN23kaWg3Dw14P0nYHwU4
        GqSW7m0vUkb7J0Bg==
From:   "tip-bot2 for Mike Galbraith" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Handle transient "ownerless" rtmutex
 state correctly
Cc:     Gratian Crisan <gratian.crisan@ni.com>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87a6w6x7bb.fsf@ni.com>
References: <87a6w6x7bb.fsf@ni.com>
MIME-Version: 1.0
Message-ID: <160478330115.11244.17107406724104832304.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     9f5d1c336a10c0d24e83e40b4c1b9539f7dba627
Gitweb:        https://git.kernel.org/tip/9f5d1c336a10c0d24e83e40b4c1b9539f7dba627
Author:        Mike Galbraith <efault@gmx.de>
AuthorDate:    Wed, 04 Nov 2020 16:12:44 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 07 Nov 2020 22:07:04 +01:00

futex: Handle transient "ownerless" rtmutex state correctly

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
---
 kernel/futex.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f8614ef..ac32887 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2380,10 +2380,22 @@ retry:
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
+			goto handle_err;
+		}
 	} else {
 		WARN_ON_ONCE(argowner != current);
 		if (oldowner == current) {
