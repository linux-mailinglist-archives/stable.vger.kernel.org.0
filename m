Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2020B1B3D87
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgDVKPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbgDVKPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17DC120575;
        Wed, 22 Apr 2020 10:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550541;
        bh=0ouXlNHJWvjkfuC2gmYfU3a8nAoZ49GTebh8z7Xu9Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQNfYVxu4RYggsU00ZeNBvaFzXCrJ4hubyJ3wzpWJoCF8ZUhhNPVMj5x6Y2kVRZ4m
         W+IFmNIk3l/PizGvTAEkwjOUUhO3gSdlfAf+On2W5dg2JnarKaN39vIYcrLPX0Ogop
         OEsNgrzynvlv0UrnSYpVLypKshLMRUMdWt3ggcqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 16/64] lib/raid6: use vdupq_n_u8 to avoid endianness warnings
Date:   Wed, 22 Apr 2020 11:57:00 +0200
Message-Id: <20200422095015.766450493@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ndesaulniers@google.com <ndesaulniers@google.com>

commit 1ad3935b39da78a403e7df7a3813f866c731bc64 upstream.

Clang warns: vector initializers are not compatible with NEON intrinsics
in big endian mode [-Wnonportable-vector-initialization]

While this is usually the case, it's not an issue for this case since
we're initializing the uint8x16_t (16x uint8_t's) with the same value.

Instead, use vdupq_n_u8 which both compilers lower into a single movi
instruction: https://godbolt.org/z/vBrgzt

This avoids the static storage for a constant value.

Link: https://github.com/ClangBuiltLinux/linux/issues/214
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/raid6/neon.uc            |    5 ++---
 lib/raid6/recov_neon_inner.c |    7 ++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/lib/raid6/neon.uc
+++ b/lib/raid6/neon.uc
@@ -28,7 +28,6 @@
 
 typedef uint8x16_t unative_t;
 
-#define NBYTES(x) ((unative_t){x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x})
 #define NSIZE	sizeof(unative_t)
 
 /*
@@ -61,7 +60,7 @@ void raid6_neon$#_gen_syndrome_real(int
 	int d, z, z0;
 
 	register unative_t wd$$, wq$$, wp$$, w1$$, w2$$;
-	const unative_t x1d = NBYTES(0x1d);
+	const unative_t x1d = vdupq_n_u8(0x1d);
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
@@ -92,7 +91,7 @@ void raid6_neon$#_xor_syndrome_real(int
 	int d, z, z0;
 
 	register unative_t wd$$, wq$$, wp$$, w1$$, w2$$;
-	const unative_t x1d = NBYTES(0x1d);
+	const unative_t x1d = vdupq_n_u8(0x1d);
 
 	z0 = stop;		/* P/Q right side optimization */
 	p = dptr[disks-2];	/* XOR parity */
--- a/lib/raid6/recov_neon_inner.c
+++ b/lib/raid6/recov_neon_inner.c
@@ -10,11 +10,6 @@
 
 #include <arm_neon.h>
 
-static const uint8x16_t x0f = {
-	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
-	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
-};
-
 #ifdef CONFIG_ARM
 /*
  * AArch32 does not provide this intrinsic natively because it does not
@@ -41,6 +36,7 @@ void __raid6_2data_recov_neon(int bytes,
 	uint8x16_t pm1 = vld1q_u8(pbmul + 16);
 	uint8x16_t qm0 = vld1q_u8(qmul);
 	uint8x16_t qm1 = vld1q_u8(qmul + 16);
+	uint8x16_t x0f = vdupq_n_u8(0x0f);
 
 	/*
 	 * while ( bytes-- ) {
@@ -87,6 +83,7 @@ void __raid6_datap_recov_neon(int bytes,
 {
 	uint8x16_t qm0 = vld1q_u8(qmul);
 	uint8x16_t qm1 = vld1q_u8(qmul + 16);
+	uint8x16_t x0f = vdupq_n_u8(0x0f);
 
 	/*
 	 * while (bytes--) {


