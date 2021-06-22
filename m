Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32753B031E
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 13:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhFVLsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 07:48:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56664 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhFVLsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 07:48:15 -0400
Date:   Tue, 22 Jun 2021 11:45:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624362358;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3bk1RgaCmQnXTMB8X9258azBGCiHqHpM27KkOSNNsY=;
        b=OQqaBb9WlZM6w9v8BFofJ0EU7quCLlhWExhsoLj1DXkftOzLbSwoArNyfb48u3JFqDychu
        RG/kP2ruaiWdECulQIKl3awmGCx7CGmBq98wpNViAi6ELNiq0yEqbLSPT434gLSdosMBLU
        uyPDPaDvwKPOwLkpRITH/WuO/srLvWBB02EdtTp25A6YgFnopnC8ngaswZwSXbdKdHdZ1q
        40DZA6ZhfGDKsEvzcTlbyi2bHe4WEBi6FtB056PaS94GVHzTbCdnThDRnCtXFzKxqJX3Q3
        Hmy4Cov39KsYg2+9+qy+CF2KQGDx63M6O6xc5IFjEKewE+wQyMUv1Xz9LIMFYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624362358;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3bk1RgaCmQnXTMB8X9258azBGCiHqHpM27KkOSNNsY=;
        b=sGNGce76zpzpZnEkzfyGHoASSpEFiqA12ldGp6sOVKCbN7d/JRvtQperCKcj0b5Pq2BvEK
        n80Bvg2hUmaUWpBQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Preserve supervisor states in
 sanitize_restored_user_xstate()
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210618143444.438635017@linutronix.de>
References: <20210618143444.438635017@linutronix.de>
MIME-Version: 1.0
Message-ID: <162436235798.395.14118811977860915293.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9301982c424a003c0095bf157154a85bf5322bd0
Gitweb:        https://git.kernel.org/tip/9301982c424a003c0095bf157154a85bf5322bd0
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 18 Jun 2021 16:18:24 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 22 Jun 2021 10:51:23 +02:00

x86/fpu: Preserve supervisor states in sanitize_restored_user_xstate()

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
---
 arch/x86/kernel/fpu/signal.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index ec3ae30..b7b92cd 100644
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
