Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FD7398649
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 12:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhFBKUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 06:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhFBKUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 06:20:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD56C061355;
        Wed,  2 Jun 2021 03:17:55 -0700 (PDT)
Message-Id: <20210602101618.462908825@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622629074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=S+BtLMFUO8zq4x2FDJtHKocyWQSVYtuFhC95M+ZhZFc=;
        b=Ii3X8E/zAVy6/kZZ9z70Oi04k6dk1NnoNWKPvnlTeAeLsKtYbILctCzDWtCCwjyv2ElSz7
        iWFbRpqAYaUn/PwT36EOssgMkrbtOjOyh8wkB6lo/ptXTpnd4uZtrmdZrTPrkdmbw61FNc
        RpZHYjhLglDgyUx5X2/AiL/BX9d/wKoWPuZSoeN06NoHW6Sb0fu9GEZpCcQ0c6MHEIlKdf
        9gXbZuwbEBKpH9+bqafD+17SOm+obtFX1HETaT5RzonC5lEBd2iEF7egzNeF/bhlGsRqWN
        Mb1hrM8nQ/Js102htKHLmu33FSOokfHAg2VXooIes8OdXv+1F/PBe8pUwzq2cg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622629074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=S+BtLMFUO8zq4x2FDJtHKocyWQSVYtuFhC95M+ZhZFc=;
        b=pSq2Zv33pVpLNBaXnE7UDtDhnPcjAMqQcGuB+mn9IwV8t2qimSLm0nft1UbrWdDGujz3vu
        CgzO7/v4bW04/RCw==
Date:   Wed, 02 Jun 2021 11:55:45 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [patch 2/8] x86/fpu: Prevent state corruption in __fpu__restore_sig()
References: <20210602095543.149814064@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The non-compacted slowpath uses __copy_from_user() and copies the entire
user buffer into the kernel buffer, verbatim.  This means that the kernel
buffer may now contain entirely invalid state on which XRSTOR will #GP.
validate_user_xstate_header() can detect some of that corruption, but that
leaves the onus on callers to clear the buffer.

Prior to XSAVES support it was possible just to reinitialize the buffer,
completely, but with supervisor states that is not longer possible as the
buffer clearing code split got it backwards. Fixing that is possible, but
not corrupting the state in the first place is more robust.

Avoid corruption of the kernel XSAVE buffer by using copy_user_to_xstate()
which validates the XSAVE header contents before copying the actual states
to the kernel. copy_user_to_xstate() was previously only called for
compacted-format kernel buffers, but it works for both compacted and
non-compacted forms.

Using it for the non-compacted form is slower because of multiple
__copy_from_user() operations, but that cost is less important than robust
code in an already slow path.

[ Changelog polished by Dave Hansen ]

Fixes: b860eb8dce59 ("x86/fpu/xstate: Define new functions for clearing fpregs and xstates")
Reported-by: syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 arch/x86/include/asm/fpu/xstate.h |    4 ----
 arch/x86/kernel/fpu/signal.c      |    9 +--------
 arch/x86/kernel/fpu/xstate.c      |    2 +-
 3 files changed, 2 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -112,8 +112,4 @@ void copy_supervisor_to_kernel(struct xr
 void copy_dynamic_supervisor_to_kernel(struct xregs_state *xstate, u64 mask);
 void copy_kernel_to_dynamic_supervisor(struct xregs_state *xstate, u64 mask);
 
-
-/* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
-int validate_user_xstate_header(const struct xstate_header *hdr);
-
 #endif
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -405,14 +405,7 @@ static int __fpu__restore_sig(void __use
 	if (use_xsave() && !fx_only) {
 		u64 init_bv = xfeatures_mask_user() & ~user_xfeatures;
 
-		if (using_compacted_format()) {
-			ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
-		} else {
-			ret = __copy_from_user(&fpu->state.xsave, buf_fx, state_size);
-
-			if (!ret && state_size > offsetof(struct xregs_state, header))
-				ret = validate_user_xstate_header(&fpu->state.xsave.header);
-		}
+		ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
 		if (ret)
 			goto err_out;
 
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -515,7 +515,7 @@ int using_compacted_format(void)
 }
 
 /* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
-int validate_user_xstate_header(const struct xstate_header *hdr)
+static int validate_user_xstate_header(const struct xstate_header *hdr)
 {
 	/* No unknown or supervisor features may be set */
 	if (hdr->xfeatures & ~xfeatures_mask_user())

