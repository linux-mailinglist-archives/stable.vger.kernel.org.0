Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213A16580C2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiL1QUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiL1QTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:19:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5C31A80E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33717B81888
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86674C433F2;
        Wed, 28 Dec 2022 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244271;
        bh=76SbrkjyDdkHkvXCQCqaibBx5NpDPkZFk1cw3Ud3S5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUyonKNx9TbX+Rkf9DSjk2z9oAnAYwd1xj6Gu+za4odJ6HDW4gZMyVIgFTjllwZ9G
         jm3CKKiJ6FgYnLgh9rHU1MzHqETuyv4X3WcROs97aFUttWjia/s7nsDznk3Ca0IYF9
         kPKFzlPzOhIc4WEd4L8F9lXBxMTy9Q17CWHNxelA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0639/1146] crypto: x86/sha512 - fix possible crash with CFI enabled
Date:   Wed, 28 Dec 2022 15:36:18 +0100
Message-Id: <20221228144347.519292072@linuxfoundation.org>
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

[ Upstream commit a1d72fa33186ac69c7d8120c71f41ea4fc23dcc9 ]

sha512_transform_ssse3(), sha512_transform_avx(), and
sha512_transform_rorx() are called via indirect function calls.
Therefore they need to use SYM_TYPED_FUNC_START instead of
SYM_FUNC_START to cause their type hashes to be emitted when the kernel
is built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a
CFI failure (if the compiler didn't happen to optimize out the indirect
calls).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha512-avx-asm.S   | 3 ++-
 arch/x86/crypto/sha512-avx2-asm.S  | 3 ++-
 arch/x86/crypto/sha512-ssse3-asm.S | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index 1fefe6dd3a9e..b0984f19fdb4 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -48,6 +48,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 .text
 
@@ -273,7 +274,7 @@ frame_size = frame_WK + WK_SIZE
 # of SHA512 message blocks.
 # "blocks" is the message length in SHA512 blocks
 ########################################################################
-SYM_FUNC_START(sha512_transform_avx)
+SYM_TYPED_FUNC_START(sha512_transform_avx)
 	test msglen, msglen
 	je nowork
 
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 5cdaab7d6901..b1ca99055ef9 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -50,6 +50,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 .text
 
@@ -565,7 +566,7 @@ frame_size = frame_CTX + CTX_SIZE
 # of SHA512 message blocks.
 # "blocks" is the message length in SHA512 blocks
 ########################################################################
-SYM_FUNC_START(sha512_transform_rorx)
+SYM_TYPED_FUNC_START(sha512_transform_rorx)
 	# Save GPRs
 	push	%rbx
 	push	%r12
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index b84c22e06c5f..c06afb5270e5 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -48,6 +48,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 .text
 
@@ -274,7 +275,7 @@ frame_size = frame_WK + WK_SIZE
 # of SHA512 message blocks.
 # "blocks" is the message length in SHA512 blocks.
 ########################################################################
-SYM_FUNC_START(sha512_transform_ssse3)
+SYM_TYPED_FUNC_START(sha512_transform_ssse3)
 
 	test msglen, msglen
 	je nowork
-- 
2.35.1



