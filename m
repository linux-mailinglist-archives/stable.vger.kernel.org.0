Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3286580C9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbiL1QUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiL1QU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:20:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217811AF03
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:18:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC633B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB8FC43392;
        Wed, 28 Dec 2022 16:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244291;
        bh=Eomowx/T3GjyFCvBrMDvjqjHDMzuD2GLU8lAWek0qUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBTdVc7hLpB6SNIFau0EXXl6fjE2bJAY9bfWTSZ8nvKhBzD0bh9netIl7L40akYbf
         jhBlKY+7EhWv1Hsn46hSs7jWP2Cpi7jKtWZaRAN3u40Y0jLbtbScCQ4nVcEEcd02ox
         IMxnGQDDEEhquUUkLH0ruCS5z70s577N1Q9pLzuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0641/1146] crypto: x86/sm4 - fix crash with CFI enabled
Date:   Wed, 28 Dec 2022 15:36:20 +0100
Message-Id: <20221228144347.572779132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 2d203c46a0fa5df0785383b13b722483e1fd27a8 ]

sm4_aesni_avx_ctr_enc_blk8(), sm4_aesni_avx_cbc_dec_blk8(),
sm4_aesni_avx_cfb_dec_blk8(), sm4_aesni_avx2_ctr_enc_blk16(),
sm4_aesni_avx2_cbc_dec_blk16(), and sm4_aesni_avx2_cfb_dec_blk16() are
called via indirect function calls.  Therefore they need to use
SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause their type
hashes to be emitted when the kernel is built with CONFIG_CFI_CLANG=y.
Otherwise, the code crashes with a CFI failure.

(Or at least that should be the case.  For some reason the CFI checks in
sm4_avx_cbc_decrypt(), sm4_avx_cfb_decrypt(), and sm4_avx_ctr_crypt()
are not always being generated, using current tip-of-tree clang.
Anyway, this patch is a good idea anyway.)

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sm4-aesni-avx-asm_64.S  | 7 ++++---
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sm4-aesni-avx-asm_64.S b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
index 4767ab61ff48..22b6560eb9e1 100644
--- a/arch/x86/crypto/sm4-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
@@ -14,6 +14,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 #define rRIP         (%rip)
@@ -420,7 +421,7 @@ SYM_FUNC_END(sm4_aesni_avx_crypt8)
  *                                 const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx_ctr_enc_blk8)
+SYM_TYPED_FUNC_START(sm4_aesni_avx_ctr_enc_blk8)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (8 blocks)
@@ -495,7 +496,7 @@ SYM_FUNC_END(sm4_aesni_avx_ctr_enc_blk8)
  *                                 const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx_cbc_dec_blk8)
+SYM_TYPED_FUNC_START(sm4_aesni_avx_cbc_dec_blk8)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (8 blocks)
@@ -545,7 +546,7 @@ SYM_FUNC_END(sm4_aesni_avx_cbc_dec_blk8)
  *                                 const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx_cfb_dec_blk8)
+SYM_TYPED_FUNC_START(sm4_aesni_avx_cfb_dec_blk8)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (8 blocks)
diff --git a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
index 4732fe8bb65b..23ee39a8ada8 100644
--- a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
@@ -14,6 +14,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 #define rRIP         (%rip)
@@ -282,7 +283,7 @@ SYM_FUNC_END(__sm4_crypt_blk16)
  *                                   const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx2_ctr_enc_blk16)
+SYM_TYPED_FUNC_START(sm4_aesni_avx2_ctr_enc_blk16)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (16 blocks)
@@ -395,7 +396,7 @@ SYM_FUNC_END(sm4_aesni_avx2_ctr_enc_blk16)
  *                                   const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx2_cbc_dec_blk16)
+SYM_TYPED_FUNC_START(sm4_aesni_avx2_cbc_dec_blk16)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (16 blocks)
@@ -449,7 +450,7 @@ SYM_FUNC_END(sm4_aesni_avx2_cbc_dec_blk16)
  *                                   const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx2_cfb_dec_blk16)
+SYM_TYPED_FUNC_START(sm4_aesni_avx2_cfb_dec_blk16)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (16 blocks)
-- 
2.35.1



