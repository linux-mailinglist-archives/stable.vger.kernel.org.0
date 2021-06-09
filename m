Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C563A17B8
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbhFIOsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 10:48:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55002 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbhFIOsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 10:48:45 -0400
Date:   Wed, 09 Jun 2021 14:46:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623250009;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uoNSXecwPTM8KLMLKvqKdv/yoVNFbm4SZsZ81D/wnus=;
        b=BFwdXAQ/MUq9/OvvfimhkotJwL61rjulhUzZ1XHjbG9tCEGanE2PRVJd0xejLAPKUfClMe
        cuY35RlAOBIF3nrdr9deDVbxd2MVDltVFX1Rkw7sxyPZp22s1+MGCRVDbbYnOVEjyj+WnP
        nht38GRCBmk+fDG0l5KIb/ZETNSjSyzR/Q6os5B7MnCeHFUs4aG32nfzOBLaKgjtPW6lkK
        MZr8aiJgqF3+c+s7yyv1ft6QayI3yNHysgSPc4RaYx/CkCchVpS93mwOKEd5IWx4xfiyP8
        R6NvGWtjsZ2EqzwvuJ/d4D+x7pFQMcpitaMvlcAW7bhvHcYkWB/EMQ/UxVcYjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623250009;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uoNSXecwPTM8KLMLKvqKdv/yoVNFbm4SZsZ81D/wnus=;
        b=h3/XVeFarSdYuEwcYV8rSuNDXethdaHJBQXOeZSt3pxJ+bScD1Og4USHMH710evAlyxuc/
        AqAGASUmAi3Ug0Dw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Prevent state corruption in __fpu__restore_sig()
Cc:     syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210608144345.611833074@linutronix.de>
References: <20210608144345.611833074@linutronix.de>
MIME-Version: 1.0
Message-ID: <162325000866.29796.4167433091280111109.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     484cea4f362e1eeb5c869abbfb5f90eae6421b38
Gitweb:        https://git.kernel.org/tip/484cea4f362e1eeb5c869abbfb5f90eae6421b38
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 08 Jun 2021 16:36:18 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Jun 2021 09:28:21 +02:00

x86/fpu: Prevent state corruption in __fpu__restore_sig()

The non-compacted slowpath uses __copy_from_user() and copies the entire
user buffer into the kernel buffer, verbatim.  This means that the kernel
buffer may now contain entirely invalid state on which XRSTOR will #GP.
validate_user_xstate_header() can detect some of that corruption, but that
leaves the onus on callers to clear the buffer.

Prior to XSAVES support, it was possible just to reinitialize the buffer,
completely, but with supervisor states that is not longer possible as the
buffer clearing code split got it backwards. Fixing that is possible but
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
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210608144345.611833074@linutronix.de
---
 arch/x86/kernel/fpu/signal.c |  9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index a4ec653..d5bc96a 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -405,14 +405,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
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
 
