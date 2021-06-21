Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547CA3AF08A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhFUQuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232546AbhFUQrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 293BC61456;
        Mon, 21 Jun 2021 16:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293222;
        bh=MZjtSJzO+qywH8efNw6SjL2tbIzjlSHbRH0jKMh3a+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lij4Hh2kJ3fEVUc7E1FCTjTWwRL2cejCgwIXxtFCiu6L4WasgfcdfqMblb4oDShcy
         tdxPEyt7isotneDA4sQbUpp6t9ep/+CHZM4ez7giyhk5KrBHILJNdwpic0IRel2UBU
         ZCbfOh/NGLM8e11yr5JPWXcwyU170/6sHR6dkPnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH 5.12 144/178] x86/fpu: Prevent state corruption in __fpu__restore_sig()
Date:   Mon, 21 Jun 2021 18:15:58 +0200
Message-Id: <20210621154927.675535697@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 484cea4f362e1eeb5c869abbfb5f90eae6421b38 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
 


