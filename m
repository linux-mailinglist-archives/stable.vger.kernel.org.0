Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30152ABBCC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbgKINbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731927AbgKINJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D6620867;
        Mon,  9 Nov 2020 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927394;
        bh=NxLkAppQ6PmYh0NPAhhL/yVb1zIohjow3YLIx1Ib5/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWgvyeqZs6puOVrwFUoGwAWDVAf+nPbY5YTgQVOVHsqA2m9h/adL0gloVf9oRgEA6
         5s7bMTc97Hw8PCltXECvZAWo9dO8M6THgZWyCdNviHUbHVuaI4HemjPLKrVTeBJ6F/
         7KLVnnilz6h8d7yKHkyPkykFB7BaftVOgdEtHVY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gratian Crisan <gratian.crisan@ni.com>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 45/71] futex: Handle transient "ownerless" rtmutex state correctly
Date:   Mon,  9 Nov 2020 13:55:39 +0100
Message-Id: <20201109125022.015975548@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

commit 9f5d1c336a10c0d24e83e40b4c1b9539f7dba627 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2417,10 +2417,22 @@ retry:
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


