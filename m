Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA351EA2B7
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgFALeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 07:34:16 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:48085 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgFALeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 07:34:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 42E4E1940359;
        Mon,  1 Jun 2020 07:34:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Jun 2020 07:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uyl8Dg
        1qrNVBIcQ/Oq6RYFkOfUPgbE6tWu6dL0OtpUA=; b=4fq5Lj4fjVFXQbw3QXJpdR
        jt9H01meEdpsZoI/pu2qnH3pyORsRitTdo0s4vYli1bnYMiVt/lO34GAMGmL8HDK
        BCtSrmQpeBcZgaAukW15FQ4do1qsGW4YAH6YFjHjq/nfULWwkogm2/40W2pNRvX1
        tgv/XMmGm7amLJV7093lWyCQO/105uviK/LPvk5fTxMTspHeKT4e2nw8EbCY5Apo
        2WidP4ISsR0p/jHFAjDtZUcoK73Xv9955BnrTUJ2GTP8mQODPByBI4l/+5y/+WNU
        mnakd+iZfdg3+vSWMTplT8xlxh2isz4k5QLifBWJlWA/rUFwO755DB50WK2mdGhw
        ==
X-ME-Sender: <xms:tefUXuXNLAVXY6UGNGYKupHcTiv0kCHg6mOyuCv2zmHllfu6FwuT8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:tefUXqmEISL2RwNCYVsdVGgKAVnNHcOQxr-ZjFA9ZdY50C67qepG8A>
    <xmx:tefUXiaqoXamPt53K42AZJPZf_1Djd2y97FITanxEtGGG19RtGu2bQ>
    <xmx:tefUXlUCn9VHtX62-a-G4YNGW0l5Sth6noQwKNn4iKFaLsVSNZ7MyQ>
    <xmx:tufUXvulTw2w7SsQOnHbljL3Y7kmz99In9iuA7Xe5rY4eB5EssM4Bg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BE65328005E;
        Mon,  1 Jun 2020 07:34:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] copy_xstate_to_kernel(): don't leave parts of destination" failed to apply to 4.4-stable tree
To:     viro@zeniv.linux.org.uk, bp@suse.de, glider@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jun 2020 13:34:11 +0200
Message-ID: <1591011251230102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e4636545933131de15e1ecd06733538ae939b2f Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 26 May 2020 18:39:49 -0400
Subject: [PATCH] copy_xstate_to_kernel(): don't leave parts of destination
 uninitialized

copy the corresponding pieces of init_fpstate into the gaps instead.

Cc: stable@kernel.org
Tested-by: Alexander Potapenko <glider@google.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 32b153d38748..6a54e83d5589 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -957,18 +957,31 @@ static inline bool xfeatures_mxcsr_quirk(u64 xfeatures)
 	return true;
 }
 
-/*
- * This is similar to user_regset_copyout(), but will not add offset to
- * the source data pointer or increment pos, count, kbuf, and ubuf.
- */
-static inline void
-__copy_xstate_to_kernel(void *kbuf, const void *data,
-			unsigned int offset, unsigned int size, unsigned int size_total)
+static void fill_gap(unsigned to, void **kbuf, unsigned *pos, unsigned *count)
 {
-	if (offset < size_total) {
-		unsigned int copy = min(size, size_total - offset);
+	if (*pos < to) {
+		unsigned size = to - *pos;
+
+		if (size > *count)
+			size = *count;
+		memcpy(*kbuf, (void *)&init_fpstate.xsave + *pos, size);
+		*kbuf += size;
+		*pos += size;
+		*count -= size;
+	}
+}
 
-		memcpy(kbuf + offset, data, copy);
+static void copy_part(unsigned offset, unsigned size, void *from,
+			void **kbuf, unsigned *pos, unsigned *count)
+{
+	fill_gap(offset, kbuf, pos, count);
+	if (size > *count)
+		size = *count;
+	if (size) {
+		memcpy(*kbuf, from, size);
+		*kbuf += size;
+		*pos += size;
+		*count -= size;
 	}
 }
 
@@ -981,8 +994,9 @@ __copy_xstate_to_kernel(void *kbuf, const void *data,
  */
 int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int offset_start, unsigned int size_total)
 {
-	unsigned int offset, size;
 	struct xstate_header header;
+	const unsigned off_mxcsr = offsetof(struct fxregs_state, mxcsr);
+	unsigned count = size_total;
 	int i;
 
 	/*
@@ -998,46 +1012,42 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
 	header.xfeatures = xsave->header.xfeatures;
 	header.xfeatures &= ~XFEATURE_MASK_SUPERVISOR;
 
+	if (header.xfeatures & XFEATURE_MASK_FP)
+		copy_part(0, off_mxcsr,
+			  &xsave->i387, &kbuf, &offset_start, &count);
+	if (header.xfeatures & (XFEATURE_MASK_SSE | XFEATURE_MASK_YMM))
+		copy_part(off_mxcsr, MXCSR_AND_FLAGS_SIZE,
+			  &xsave->i387.mxcsr, &kbuf, &offset_start, &count);
+	if (header.xfeatures & XFEATURE_MASK_FP)
+		copy_part(offsetof(struct fxregs_state, st_space), 128,
+			  &xsave->i387.st_space, &kbuf, &offset_start, &count);
+	if (header.xfeatures & XFEATURE_MASK_SSE)
+		copy_part(xstate_offsets[XFEATURE_MASK_SSE], 256,
+			  &xsave->i387.xmm_space, &kbuf, &offset_start, &count);
+	/*
+	 * Fill xsave->i387.sw_reserved value for ptrace frame:
+	 */
+	copy_part(offsetof(struct fxregs_state, sw_reserved), 48,
+		  xstate_fx_sw_bytes, &kbuf, &offset_start, &count);
 	/*
 	 * Copy xregs_state->header:
 	 */
-	offset = offsetof(struct xregs_state, header);
-	size = sizeof(header);
-
-	__copy_xstate_to_kernel(kbuf, &header, offset, size, size_total);
+	copy_part(offsetof(struct xregs_state, header), sizeof(header),
+		  &header, &kbuf, &offset_start, &count);
 
-	for (i = 0; i < XFEATURE_MAX; i++) {
+	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
 		/*
 		 * Copy only in-use xstates:
 		 */
 		if ((header.xfeatures >> i) & 1) {
 			void *src = __raw_xsave_addr(xsave, i);
 
-			offset = xstate_offsets[i];
-			size = xstate_sizes[i];
-
-			/* The next component has to fit fully into the output buffer: */
-			if (offset + size > size_total)
-				break;
-
-			__copy_xstate_to_kernel(kbuf, src, offset, size, size_total);
+			copy_part(xstate_offsets[i], xstate_sizes[i],
+				  src, &kbuf, &offset_start, &count);
 		}
 
 	}
-
-	if (xfeatures_mxcsr_quirk(header.xfeatures)) {
-		offset = offsetof(struct fxregs_state, mxcsr);
-		size = MXCSR_AND_FLAGS_SIZE;
-		__copy_xstate_to_kernel(kbuf, &xsave->i387.mxcsr, offset, size, size_total);
-	}
-
-	/*
-	 * Fill xsave->i387.sw_reserved value for ptrace frame:
-	 */
-	offset = offsetof(struct fxregs_state, sw_reserved);
-	size = sizeof(xstate_fx_sw_bytes);
-
-	__copy_xstate_to_kernel(kbuf, xstate_fx_sw_bytes, offset, size, size_total);
+	fill_gap(size_total, &kbuf, &offset_start, &count);
 
 	return 0;
 }

