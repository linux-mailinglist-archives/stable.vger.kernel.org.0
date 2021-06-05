Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AF339CBDB
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 02:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhFFAeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 20:34:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32968 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFFAeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 20:34:11 -0400
Message-Id: <20210606001323.067157324@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622939541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=WBUTfGNxNvSgHbeI2jsrGUtW90Hi09xpMn/ER3bz4aI=;
        b=QjCMBXSplhThOU1uvhnkFuqIX//M1kbOsGmGhjQHRoT8NKFstACd5n/nm/POiNDt4tZTVV
        jnhGJPVOI0e07Cb/sXa3kZiXLj7qgdui3Miynem0mKEjvYpmg9+tgo2U8X4kj4Cx9suGF0
        SVzC8tnULI9zM51FpQZGWR74FuSA84a+sa3oxFqqZ4HX5YWH9LyQUCMq5zr0QlPVbGQImF
        IkyE53NxcZ2z9rvLG5o5DNu26Qmm/Y7fHZKMH/SuVmRHNxtADANIWyd47OXf27H+jXUwqu
        uE+SZ4W/N6R+3mZYlXazQTmYhPC7dImcXhAfQgEOMCjM7EbMcRgVNDJYCMigmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622939541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=WBUTfGNxNvSgHbeI2jsrGUtW90Hi09xpMn/ER3bz4aI=;
        b=A+FNEQPJumjdkbDH4Sp2SvWSmKCm28qOda6hpUo8zQiBL7nayVAIq4p4YHcEOkmXnMfh/4
        fiK/mzSxiT3XQPCg==
Date:   Sun, 06 Jun 2021 01:47:44 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [patch V2 02/14] x86/fpu: Prevent state corruption in __fpu__restore_sig()
References: <20210605234742.712464974@linutronix.de>
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
V2: Removed the make validate_user_xstate_header() static hunks (Borislav)
---
 arch/x86/kernel/fpu/signal.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

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
 

