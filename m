Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AE43CE3E1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhGSPkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347175AbhGSPe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B956145D;
        Mon, 19 Jul 2021 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711121;
        bh=NCAiqup3mFcTE8F78TiDxXkbxnUUE4cvThcpe8p2y0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddVIVEWHLPFaJdU1FjkBSIn7mca+rZ5juiDurm3ehWchBqH2Pki+T1nJFi4qfVMRM
         n/r5uZlsiYByW0M9PjE4mA3sCIILzeWyQmVraScPwi8f0TIrggBxALb+8Rk3EoFuN8
         EPYJ+aQRPijmUSTBydAD98g2gTvAAKrZQImWnN9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 234/351] x86/fpu: Fix copy_xstate_to_kernel() gap handling
Date:   Mon, 19 Jul 2021 16:53:00 +0200
Message-Id: <20210719144952.691062503@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 9625895011d130033d1bc7aac0d77a9bf68ff8a6 ]

The gap handling in copy_xstate_to_kernel() is wrong when XSAVES is in
use.

Using init_fpstate for copying the init state of features which are
not set in the xstate header is only correct for the legacy area, but
not for the extended features area because when XSAVES is in use then
init_fpstate is in compacted form which means the xstate offsets which
are used to copy from init_fpstate are not valid.

Fortunately, this is not a real problem today because all extended
features in use have an all-zeros init state, but it is wrong
nevertheless and with a potentially dynamically sized init_fpstate this
would result in an access outside of the init_fpstate.

Fix this by keeping track of the last copied state in the target buffer and
explicitly zero it when there is a feature or alignment gap.

Use the compacted offset when accessing the extended feature space in
init_fpstate.

As this is not a functional issue on older kernels this is intentionally
not tagged for stable.

Fixes: b8be15d58806 ("x86/fpu/xstate: Re-enable XSAVES")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210623121451.294282032@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 105 ++++++++++++++++++++---------------
 1 file changed, 61 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1cadb2faf740..4819251ffe7c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1084,20 +1084,10 @@ static inline bool xfeatures_mxcsr_quirk(u64 xfeatures)
 	return true;
 }
 
-static void fill_gap(struct membuf *to, unsigned *last, unsigned offset)
+static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
+			 void *init_xstate, unsigned int size)
 {
-	if (*last >= offset)
-		return;
-	membuf_write(to, (void *)&init_fpstate.xsave + *last, offset - *last);
-	*last = offset;
-}
-
-static void copy_part(struct membuf *to, unsigned *last, unsigned offset,
-		      unsigned size, void *from)
-{
-	fill_gap(to, last, offset);
-	membuf_write(to, from, size);
-	*last = offset + size;
+	membuf_write(to, from_xstate ? xstate : init_xstate, size);
 }
 
 /*
@@ -1109,10 +1099,10 @@ static void copy_part(struct membuf *to, unsigned *last, unsigned offset,
  */
 void copy_xstate_to_kernel(struct membuf to, struct xregs_state *xsave)
 {
+	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
+	struct xregs_state *xinit = &init_fpstate.xsave;
 	struct xstate_header header;
-	const unsigned off_mxcsr = offsetof(struct fxregs_state, mxcsr);
-	unsigned size = to.left;
-	unsigned last = 0;
+	unsigned int zerofrom;
 	int i;
 
 	/*
@@ -1122,41 +1112,68 @@ void copy_xstate_to_kernel(struct membuf to, struct xregs_state *xsave)
 	header.xfeatures = xsave->header.xfeatures;
 	header.xfeatures &= xfeatures_mask_user();
 
-	if (header.xfeatures & XFEATURE_MASK_FP)
-		copy_part(&to, &last, 0, off_mxcsr, &xsave->i387);
-	if (header.xfeatures & (XFEATURE_MASK_SSE | XFEATURE_MASK_YMM))
-		copy_part(&to, &last, off_mxcsr,
-			  MXCSR_AND_FLAGS_SIZE, &xsave->i387.mxcsr);
-	if (header.xfeatures & XFEATURE_MASK_FP)
-		copy_part(&to, &last, offsetof(struct fxregs_state, st_space),
-			  128, &xsave->i387.st_space);
-	if (header.xfeatures & XFEATURE_MASK_SSE)
-		copy_part(&to, &last, xstate_offsets[XFEATURE_SSE],
-			  256, &xsave->i387.xmm_space);
-	/*
-	 * Fill xsave->i387.sw_reserved value for ptrace frame:
-	 */
-	copy_part(&to, &last, offsetof(struct fxregs_state, sw_reserved),
-		  48, xstate_fx_sw_bytes);
-	/*
-	 * Copy xregs_state->header:
-	 */
-	copy_part(&to, &last, offsetof(struct xregs_state, header),
-		  sizeof(header), &header);
+	/* Copy FP state up to MXCSR */
+	copy_feature(header.xfeatures & XFEATURE_MASK_FP, &to, &xsave->i387,
+		     &xinit->i387, off_mxcsr);
+
+	/* Copy MXCSR when SSE or YMM are set in the feature mask */
+	copy_feature(header.xfeatures & (XFEATURE_MASK_SSE | XFEATURE_MASK_YMM),
+		     &to, &xsave->i387.mxcsr, &xinit->i387.mxcsr,
+		     MXCSR_AND_FLAGS_SIZE);
+
+	/* Copy the remaining FP state */
+	copy_feature(header.xfeatures & XFEATURE_MASK_FP,
+		     &to, &xsave->i387.st_space, &xinit->i387.st_space,
+		     sizeof(xsave->i387.st_space));
+
+	/* Copy the SSE state - shared with YMM, but independently managed */
+	copy_feature(header.xfeatures & XFEATURE_MASK_SSE,
+		     &to, &xsave->i387.xmm_space, &xinit->i387.xmm_space,
+		     sizeof(xsave->i387.xmm_space));
+
+	/* Zero the padding area */
+	membuf_zero(&to, sizeof(xsave->i387.padding));
+
+	/* Copy xsave->i387.sw_reserved */
+	membuf_write(&to, xstate_fx_sw_bytes, sizeof(xsave->i387.sw_reserved));
+
+	/* Copy the user space relevant state of @xsave->header */
+	membuf_write(&to, &header, sizeof(header));
+
+	zerofrom = offsetof(struct xregs_state, extended_state_area);
 
 	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
 		/*
-		 * Copy only in-use xstates:
+		 * The ptrace buffer is in non-compacted XSAVE format.
+		 * In non-compacted format disabled features still occupy
+		 * state space, but there is no state to copy from in the
+		 * compacted init_fpstate. The gap tracking will zero this
+		 * later.
 		 */
-		if ((header.xfeatures >> i) & 1) {
-			void *src = __raw_xsave_addr(xsave, i);
+		if (!(xfeatures_mask_user() & BIT_ULL(i)))
+			continue;
 
-			copy_part(&to, &last, xstate_offsets[i],
-				  xstate_sizes[i], src);
-		}
+		/*
+		 * If there was a feature or alignment gap, zero the space
+		 * in the destination buffer.
+		 */
+		if (zerofrom < xstate_offsets[i])
+			membuf_zero(&to, xstate_offsets[i] - zerofrom);
+
+		copy_feature(header.xfeatures & BIT_ULL(i), &to,
+			     __raw_xsave_addr(xsave, i),
+			     __raw_xsave_addr(xinit, i),
+			     xstate_sizes[i]);
 
+		/*
+		 * Keep track of the last copied state in the non-compacted
+		 * target buffer for gap zeroing.
+		 */
+		zerofrom = xstate_offsets[i] + xstate_sizes[i];
 	}
-	fill_gap(&to, &last, size);
+
+	if (to.left)
+		membuf_zero(&to, to.left);
 }
 
 /*
-- 
2.30.2



