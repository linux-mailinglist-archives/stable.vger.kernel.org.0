Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0534D398F71
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 17:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhFBP75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 11:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhFBP74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 11:59:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7F9C061574;
        Wed,  2 Jun 2021 08:58:13 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622649492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WBUTfGNxNvSgHbeI2jsrGUtW90Hi09xpMn/ER3bz4aI=;
        b=Q1HwTSAnNmKjG5VfbJrVPl0BZWtHe38jyV+9UlcAlmzAPTv1hMSMJ/2x+pAdZrm8h2XLiT
        7LFtuwAc1OXzxpcZiKKFr4fCJh8iFUuRZZV3dJBkvwrbuihHZG688gdgsF69czjqnZNpBY
        JyNMVZWiVP6xXCiOroqDBCPrN2uQqeKByOmKOt9fvAnjn26zzJmgQa4+JP9M/wjX1zRvCo
        oej198PKio4KyPds2VpNU8j021wiDJ3atzuBneAI9ISgpD2Y/0lHOsSxpCszq4s5hYLrRj
        OWi7hTI9dZqEZmcLKOcunI6XdT6rRrX1tpJceTQiVlE10f7OyBppl578PYm1zg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622649492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WBUTfGNxNvSgHbeI2jsrGUtW90Hi09xpMn/ER3bz4aI=;
        b=xvTHoFzERmxU1F7J1o/5k/I5q454qdshhO0o5mjdMinO9NI1Zm8xG/UHbadWCvqQF9VMJz
        zCFIjOThBTxNewDg==
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [patch V2 2/8] x86/fpu: Prevent state corruption in __fpu__restore_sig()
In-Reply-To: <20210602101618.462908825@linutronix.de>
References: <20210602095543.149814064@linutronix.de> <20210602101618.462908825@linutronix.de>
Date:   Wed, 02 Jun 2021 17:58:11 +0200
Message-ID: <87y2bsz2b0.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
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
 
