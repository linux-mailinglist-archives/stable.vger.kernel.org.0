Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6960341C4B
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCSMUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhCSMTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5325C64F70;
        Fri, 19 Mar 2021 12:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156392;
        bh=GLt5xl/ilrgrMpBTMm+O8JI2A0wKPkD4vyWK+pTFAzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=runpVgnelJezwz8D/Thbj4nPk6nBwABhhXcby/95kbvOZHLMJNIGBlVcNTMDJ/6is
         MP/F5HtO7dBt4HIaabwZM62rPICTzMcJAailI2wu4aBmzuMGirNUR/9DfFDirkwpSZ
         DV6jQ0yFsSqIVOY5oWwznIWoitbgE4oKpv6STKYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/13] crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg
Date:   Fri, 19 Mar 2021 13:18:58 +0100
Message-Id: <20210319121745.162749017@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
References: <20210319121745.112612545@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 032d049ea0f45b45c21f3f02b542aa18bc6b6428 ]

CMP $0,%reg can't set overflow flag, so we can use shorter TEST %reg,%reg
instruction when only zero and sign flags are checked (E,L,LE,G,GE conditions).

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S        | 20 ++++++++++----------
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 20 ++++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 1852b19a73a0..d1436c37008b 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -318,7 +318,7 @@ _initial_blocks_\@:
 
 	# Main loop - Encrypt/Decrypt remaining blocks
 
-	cmp	$0, %r13
+	test	%r13, %r13
 	je	_zero_cipher_left_\@
 	sub	$64, %r13
 	je	_four_cipher_left_\@
@@ -437,7 +437,7 @@ _multiple_of_16_bytes_\@:
 
 	mov PBlockLen(%arg2), %r12
 
-	cmp $0, %r12
+	test %r12, %r12
 	je _partial_done\@
 
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
@@ -474,7 +474,7 @@ _T_8_\@:
 	add	$8, %r10
 	sub	$8, %r11
 	psrldq	$8, %xmm0
-	cmp	$0, %r11
+	test	%r11, %r11
 	je	_return_T_done_\@
 _T_4_\@:
 	movd	%xmm0, %eax
@@ -482,7 +482,7 @@ _T_4_\@:
 	add	$4, %r10
 	sub	$4, %r11
 	psrldq	$4, %xmm0
-	cmp	$0, %r11
+	test	%r11, %r11
 	je	_return_T_done_\@
 _T_123_\@:
 	movd	%xmm0, %eax
@@ -619,7 +619,7 @@ _get_AAD_blocks\@:
 
 	/* read the last <16B of AAD */
 _get_AAD_rest\@:
-	cmp	   $0, %r11
+	test	   %r11, %r11
 	je	   _get_AAD_done\@
 
 	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, \TMP7
@@ -640,7 +640,7 @@ _get_AAD_done\@:
 .macro PARTIAL_BLOCK CYPH_PLAIN_OUT PLAIN_CYPH_IN PLAIN_CYPH_LEN DATA_OFFSET \
 	AAD_HASH operation
 	mov 	PBlockLen(%arg2), %r13
-	cmp	$0, %r13
+	test	%r13, %r13
 	je	_partial_block_done_\@	# Leave Macro if no partial blocks
 	# Read in input data without over reading
 	cmp	$16, \PLAIN_CYPH_LEN
@@ -692,7 +692,7 @@ _no_extra_mask_1_\@:
 	pshufb	%xmm2, %xmm3
 	pxor	%xmm3, \AAD_HASH
 
-	cmp	$0, %r10
+	test	%r10, %r10
 	jl	_partial_incomplete_1_\@
 
 	# GHASH computation for the last <16 Byte block
@@ -727,7 +727,7 @@ _no_extra_mask_2_\@:
 	pshufb	%xmm2, %xmm9
 	pxor	%xmm9, \AAD_HASH
 
-	cmp	$0, %r10
+	test	%r10, %r10
 	jl	_partial_incomplete_2_\@
 
 	# GHASH computation for the last <16 Byte block
@@ -747,7 +747,7 @@ _encode_done_\@:
 	pshufb	%xmm2, %xmm9
 .endif
 	# output encrypted Bytes
-	cmp	$0, %r10
+	test	%r10, %r10
 	jl	_partial_fill_\@
 	mov	%r13, %r12
 	mov	$16, %r13
@@ -2720,7 +2720,7 @@ SYM_FUNC_END(aesni_ctr_enc)
  */
 SYM_FUNC_START(aesni_xts_crypt8)
 	FRAME_BEGIN
-	cmpb $0, %cl
+	testb %cl, %cl
 	movl $0, %ecx
 	movl $240, %r10d
 	leaq _aesni_enc4, %r11
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 5fee47956f3b..2cf8e94d986a 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -369,7 +369,7 @@ _initial_num_blocks_is_0\@:
 
 
 _initial_blocks_encrypted\@:
-        cmp     $0, %r13
+        test    %r13, %r13
         je      _zero_cipher_left\@
 
         sub     $128, %r13
@@ -528,7 +528,7 @@ _multiple_of_16_bytes\@:
         vmovdqu HashKey(arg2), %xmm13
 
         mov PBlockLen(arg2), %r12
-        cmp $0, %r12
+        test %r12, %r12
         je _partial_done\@
 
 	#GHASH computation for the last <16 Byte block
@@ -573,7 +573,7 @@ _T_8\@:
         add     $8, %r10
         sub     $8, %r11
         vpsrldq $8, %xmm9, %xmm9
-        cmp     $0, %r11
+        test    %r11, %r11
         je     _return_T_done\@
 _T_4\@:
         vmovd   %xmm9, %eax
@@ -581,7 +581,7 @@ _T_4\@:
         add     $4, %r10
         sub     $4, %r11
         vpsrldq     $4, %xmm9, %xmm9
-        cmp     $0, %r11
+        test    %r11, %r11
         je     _return_T_done\@
 _T_123\@:
         vmovd     %xmm9, %eax
@@ -625,7 +625,7 @@ _get_AAD_blocks\@:
 	cmp     $16, %r11
 	jge     _get_AAD_blocks\@
 	vmovdqu \T8, \T7
-	cmp     $0, %r11
+	test    %r11, %r11
 	je      _get_AAD_done\@
 
 	vpxor   \T7, \T7, \T7
@@ -644,7 +644,7 @@ _get_AAD_rest8\@:
 	vpxor   \T1, \T7, \T7
 	jmp     _get_AAD_rest8\@
 _get_AAD_rest4\@:
-	cmp     $0, %r11
+	test    %r11, %r11
 	jle      _get_AAD_rest0\@
 	mov     (%r10), %eax
 	movq    %rax, \T1
@@ -749,7 +749,7 @@ _done_read_partial_block_\@:
 .macro PARTIAL_BLOCK GHASH_MUL CYPH_PLAIN_OUT PLAIN_CYPH_IN PLAIN_CYPH_LEN DATA_OFFSET \
         AAD_HASH ENC_DEC
         mov 	PBlockLen(arg2), %r13
-        cmp	$0, %r13
+        test	%r13, %r13
         je	_partial_block_done_\@	# Leave Macro if no partial blocks
         # Read in input data without over reading
         cmp	$16, \PLAIN_CYPH_LEN
@@ -801,7 +801,7 @@ _no_extra_mask_1_\@:
         vpshufb	%xmm2, %xmm3, %xmm3
         vpxor	%xmm3, \AAD_HASH, \AAD_HASH
 
-        cmp	$0, %r10
+        test	%r10, %r10
         jl	_partial_incomplete_1_\@
 
         # GHASH computation for the last <16 Byte block
@@ -836,7 +836,7 @@ _no_extra_mask_2_\@:
         vpshufb %xmm2, %xmm9, %xmm9
         vpxor	%xmm9, \AAD_HASH, \AAD_HASH
 
-        cmp	$0, %r10
+        test	%r10, %r10
         jl	_partial_incomplete_2_\@
 
         # GHASH computation for the last <16 Byte block
@@ -856,7 +856,7 @@ _encode_done_\@:
         vpshufb	%xmm2, %xmm9, %xmm9
 .endif
         # output encrypted Bytes
-        cmp	$0, %r10
+        test	%r10, %r10
         jl	_partial_fill_\@
         mov	%r13, %r12
         mov	$16, %r13
-- 
2.30.1



