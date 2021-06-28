Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521173B6130
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhF1OdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhF1Oan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA8F761CCF;
        Mon, 28 Jun 2021 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890428;
        bh=kRkkdBSK9MbzVLfnBU/bdoew6ycpzlGvh1n13YWZ0+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWlhwNneBTZIJD7rCGNx9lVpPgfROfRKaeFuQtgY19J7AdiOPuDWty7T2ILY1Dnu3
         gUshAh4QVxZFWCNLj4GM4rkg23hIP2Q3RYwiIAuo6r7fEFL92GjpbooWBmfB9XaLQZ
         IkB0KJ6FiYLP8dtmbc3rlJM5J4TEzWOQ+Zoos3o+JfsCLLfx4gEr3eQ7pLcRvrJHiE
         1OaUgiSWkviazkmhC8+yPXEFyzLNNYKX3lZcWPN9EfwFZTA7tS/mXfBSrH0GDAtvS2
         wL294SxynIvdaQhwU+y9adX5DkwOt2pudYCiFQclKI81ZAZctMzs3MjLVcoqtk8ZDd
         HLO9yW+V4H5jQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 069/101] x86/fpu: Preserve supervisor states in sanitize_restored_user_xstate()
Date:   Mon, 28 Jun 2021 10:25:35 -0400
Message-Id: <20210628142607.32218-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 9301982c424a003c0095bf157154a85bf5322bd0 upstream.

sanitize_restored_user_xstate() preserves the supervisor states only
when the fx_only argument is zero, which allows unprivileged user space
to put supervisor states back into init state.

Preserve them unconditionally.

 [ bp: Fix a typo or two in the text. ]

Fixes: 5d6b6a6f9b5c ("x86/fpu/xstate: Update sanitize_restored_xstate() for supervisor xstates")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210618143444.438635017@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index ec3ae3054792..b7b92cdf3add 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -221,28 +221,18 @@ sanitize_restored_user_xstate(union fpregs_state *state,
 
 	if (use_xsave()) {
 		/*
-		 * Note: we don't need to zero the reserved bits in the
-		 * xstate_header here because we either didn't copy them at all,
-		 * or we checked earlier that they aren't set.
+		 * Clear all feature bits which are not set in
+		 * user_xfeatures and clear all extended features
+		 * for fx_only mode.
 		 */
+		u64 mask = fx_only ? XFEATURE_MASK_FPSSE : user_xfeatures;
 
 		/*
-		 * 'user_xfeatures' might have bits clear which are
-		 * set in header->xfeatures. This represents features that
-		 * were in init state prior to a signal delivery, and need
-		 * to be reset back to the init state.  Clear any user
-		 * feature bits which are set in the kernel buffer to get
-		 * them back to the init state.
-		 *
-		 * Supervisor state is unchanged by input from userspace.
-		 * Ensure supervisor state bits stay set and supervisor
-		 * state is not modified.
+		 * Supervisor state has to be preserved. The sigframe
+		 * restore can only modify user features, i.e. @mask
+		 * cannot contain them.
 		 */
-		if (fx_only)
-			header->xfeatures = XFEATURE_MASK_FPSSE;
-		else
-			header->xfeatures &= user_xfeatures |
-					     xfeatures_mask_supervisor();
+		header->xfeatures &= mask | xfeatures_mask_supervisor();
 	}
 
 	if (use_fxsr()) {
-- 
2.30.2

