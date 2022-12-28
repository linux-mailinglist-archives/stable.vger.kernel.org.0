Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F35657B3A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiL1PTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiL1PTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04B514007
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7429FB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0C1C433EF;
        Wed, 28 Dec 2022 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240751;
        bh=j76NZNX+VuyFiUsR6EsmZCpiE7DtsTkC7Vrl3ZjW4XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1v4Kwej7S+nKtDoSoX0ZQ57bCLxxkQHUQPOoiEXZoaNiBuPlrZ9MHMsOWaw25YsQh
         SWq93D++BEVz7WKRtqexSorZymL8shNoxfFI3UEuxn3giBLGRJwJsljwUgrdVEZoT2
         LTK5I4csvgFDqVcNFsBtQtgpfVyb8YVPaBihwP9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexey Izbyshev <izbyshev@ispras.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0163/1146] futex: Resend potentially swallowed owner death notification
Date:   Wed, 28 Dec 2022 15:28:22 +0100
Message-Id: <20221228144334.588331609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Izbyshev <izbyshev@ispras.ru>

[ Upstream commit 90d758896787048fa3d4209309d4800f3920e66f ]

Commit ca16d5bee598 ("futex: Prevent robust futex exit race") addressed
two cases when tasks waiting on a robust non-PI futex remained blocked
despite the futex not being owned anymore:

* if the owner died after writing zero to the futex word, but before
  waking up a waiter

* if a task waiting on the futex was woken up, but died before updating
  the futex word (effectively swallowing the notification without acting
  on it)

In the second case, the task could be woken up either by the previous
owner (after the futex word was reset to zero) or by the kernel (after
the OWNER_DIED bit was set and the TID part of the futex word was reset
to zero) if the previous owner died without the resetting the futex.

Because the referenced commit wakes up a potential waiter only if the
whole futex word is zero, the latter subcase remains unaddressed.

Fix this by looking only at the TID part of the futex when deciding
whether a wake up is needed.

Fixes: ca16d5bee598 ("futex: Prevent robust futex exit race")
Signed-off-by: Alexey Izbyshev <izbyshev@ispras.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221111215439.248185-1-izbyshev@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index b22ef1efe751..514e4582b863 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -638,6 +638,7 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
 			      bool pi, bool pending_op)
 {
 	u32 uval, nval, mval;
+	pid_t owner;
 	int err;
 
 	/* Futex address must be 32bit aligned */
@@ -659,6 +660,10 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
 	 * 2. A woken up waiter is killed before it can acquire the
 	 *    futex in user space.
 	 *
+	 * In the second case, the wake up notification could be generated
+	 * by the unlock path in user space after setting the futex value
+	 * to zero or by the kernel after setting the OWNER_DIED bit below.
+	 *
 	 * In both cases the TID validation below prevents a wakeup of
 	 * potential waiters which can cause these waiters to block
 	 * forever.
@@ -667,24 +672,27 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
 	 *
 	 *	1) task->robust_list->list_op_pending != NULL
 	 *	   @pending_op == true
-	 *	2) User space futex value == 0
+	 *	2) The owner part of user space futex value == 0
 	 *	3) Regular futex: @pi == false
 	 *
 	 * If these conditions are met, it is safe to attempt waking up a
 	 * potential waiter without touching the user space futex value and
-	 * trying to set the OWNER_DIED bit. The user space futex value is
-	 * uncontended and the rest of the user space mutex state is
-	 * consistent, so a woken waiter will just take over the
-	 * uncontended futex. Setting the OWNER_DIED bit would create
-	 * inconsistent state and malfunction of the user space owner died
-	 * handling.
+	 * trying to set the OWNER_DIED bit. If the futex value is zero,
+	 * the rest of the user space mutex state is consistent, so a woken
+	 * waiter will just take over the uncontended futex. Setting the
+	 * OWNER_DIED bit would create inconsistent state and malfunction
+	 * of the user space owner died handling. Otherwise, the OWNER_DIED
+	 * bit is already set, and the woken waiter is expected to deal with
+	 * this.
 	 */
-	if (pending_op && !pi && !uval) {
+	owner = uval & FUTEX_TID_MASK;
+
+	if (pending_op && !pi && !owner) {
 		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
 		return 0;
 	}
 
-	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(curr))
+	if (owner != task_pid_vnr(curr))
 		return 0;
 
 	/*
-- 
2.35.1



