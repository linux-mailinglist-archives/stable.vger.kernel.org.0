Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFAF431DEF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhJRN4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234464AbhJRNxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF146137E;
        Mon, 18 Oct 2021 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564361;
        bh=4YWK8YQ/UiVM+ddsm64SVdz/ByGf+J5v/Lv4c2utpzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIAIeFv59i4AwaYFVQ+jkfGgK/Xxhg88UjfPkOV7UmWCPDo+yepFQt1hUvfLyo1m8
         ehs5T7iAUNHCC390gI8JUtl9hr6GmnELHRvHsfm5gy7o75IG090q6yUuUTbF73EBqy
         x+cv6WcSZ5dSqfVuhekzACbf8Xf+nS6QBtZ2uulg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 060/151] KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()
Date:   Mon, 18 Oct 2021 15:23:59 +0200
Message-Id: <20211018132342.644684017@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 9b4416c5095c20e110c82ae602c254099b83b72f upstream.

In commit 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in
C") kvm_start_guest() became idle_kvm_start_guest(). The old code
allocated a stack frame on the emergency stack, but didn't use the
frame to store anything, and also didn't store anything in its caller's
frame.

idle_kvm_start_guest() on the other hand is written more like a normal C
function, it creates a frame on entry, and also stores CR/LR into its
callers frame (per the ABI). The problem is that there is no caller
frame on the emergency stack.

The emergency stack for a given CPU is allocated with:

  paca_ptrs[i]->emergency_sp = alloc_stack(limit, i) + THREAD_SIZE;

So emergency_sp actually points to the first address above the emergency
stack allocation for a given CPU, we must not store above it without
first decrementing it to create a frame. This is different to the
regular kernel stack, paca->kstack, which is initialised to point at an
initial frame that is ready to use.

idle_kvm_start_guest() stores the backchain, CR and LR all of which
write outside the allocation for the emergency stack. It then creates a
stack frame and saves the non-volatile registers. Unfortunately the
frame it creates is not large enough to fit the non-volatiles, and so
the saving of the non-volatile registers also writes outside the
emergency stack allocation.

The end result is that we corrupt whatever is at 0-24 bytes, and 112-248
bytes above the emergency stack allocation.

In practice this has gone unnoticed because the memory immediately above
the emergency stack happens to be used for other stack allocations,
either another CPUs mc_emergency_sp or an IRQ stack. See the order of
calls to irqstack_early_init() and emergency_stack_init().

The low addresses of another stack are the top of that stack, and so are
only used if that stack is under extreme pressue, which essentially
never happens in practice - and if it did there's a high likelyhood we'd
crash due to that stack overflowing.

Still, we shouldn't be corrupting someone else's stack, and it is purely
luck that we aren't corrupting something else.

To fix it we save CR/LR into the caller's frame using the existing r1 on
entry, we then create a SWITCH_FRAME_SIZE frame (which has space for
pt_regs) on the emergency stack with the backchain pointing to the
existing stack, and then finally we switch to the new frame on the
emergency stack.

Fixes: 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in C")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211015133929.832061-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -255,13 +255,15 @@ kvm_novcpu_exit:
  * r3 contains the SRR1 wakeup value, SRR1 is trashed.
  */
 _GLOBAL(idle_kvm_start_guest)
-	ld	r4,PACAEMERGSP(r13)
 	mfcr	r5
 	mflr	r0
-	std	r1,0(r4)
-	std	r5,8(r4)
-	std	r0,16(r4)
-	subi	r1,r4,STACK_FRAME_OVERHEAD
+	std	r5, 8(r1)	// Save CR in caller's frame
+	std	r0, 16(r1)	// Save LR in caller's frame
+	// Create frame on emergency stack
+	ld	r4, PACAEMERGSP(r13)
+	stdu	r1, -SWITCH_FRAME_SIZE(r4)
+	// Switch to new frame on emergency stack
+	mr	r1, r4
 	SAVE_NVGPRS(r1)
 
 	/*
@@ -395,10 +397,9 @@ kvm_no_guest:
 	/* set up r3 for return */
 	mfspr	r3,SPRN_SRR1
 	REST_NVGPRS(r1)
-	addi	r1, r1, STACK_FRAME_OVERHEAD
-	ld	r0, 16(r1)
-	ld	r5, 8(r1)
-	ld	r1, 0(r1)
+	ld	r1, 0(r1)	// Switch back to caller stack
+	ld	r0, 16(r1)	// Reload LR
+	ld	r5, 8(r1)	// Reload CR
 	mtlr	r0
 	mtcr	r5
 	blr


