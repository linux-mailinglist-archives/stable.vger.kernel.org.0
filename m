Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7971EAE8F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgFASzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729814AbgFASBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E75EB20776;
        Mon,  1 Jun 2020 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034494;
        bh=zSDmvYYRnv1+LlKvRo10Y1i8mPchkOobWDngou8BWwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoO3rpa93i/bz5AcS4/7ohiD4ALCnaVx8jkNGe/ghBIVKd7gTLh/YdOi4V4IeFBHd
         YTUDeQ/FEGcTJm2xZD/fbL8yhoNssa74ya/QHqMHbrwZra7HSTl/Foz2CEdj7zYVoI
         9WkCHe/qUB+boo5E7Q5aQkUOh5db7DO8gm22KHPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Alexander Potapenko <glider@google.com>,
        Borislav Petkov <bp@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.14 55/77] copy_xstate_to_kernel(): dont leave parts of destination uninitialized
Date:   Mon,  1 Jun 2020 19:54:00 +0200
Message-Id: <20200601174025.927328180@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 9e4636545933131de15e1ecd06733538ae939b2f upstream.

copy the corresponding pieces of init_fpstate into the gaps instead.

Cc: stable@kernel.org
Tested-by: Alexander Potapenko <glider@google.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/fpu/xstate.c |   86 ++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 38 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -964,18 +964,31 @@ static inline bool xfeatures_mxcsr_quirk
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
 
@@ -988,8 +1001,9 @@ __copy_xstate_to_kernel(void *kbuf, cons
  */
 int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int offset_start, unsigned int size_total)
 {
-	unsigned int offset, size;
 	struct xstate_header header;
+	const unsigned off_mxcsr = offsetof(struct fxregs_state, mxcsr);
+	unsigned count = size_total;
 	int i;
 
 	/*
@@ -1005,46 +1019,42 @@ int copy_xstate_to_kernel(void *kbuf, st
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
 			void *src = __raw_xsave_addr(xsave, 1 << i);
 
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


