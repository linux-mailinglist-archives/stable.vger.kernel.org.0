Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0A06580BE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiL1QUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiL1QTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:19:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0251A236
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6F91B81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137CEC433D2;
        Wed, 28 Dec 2022 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244266;
        bh=VCv7kPvmJsamiNAhbe+x+EvY9uTVZsC3fSoTJm3XvSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMB7vm9oYolH9NtCsN3PwOdZrqfKkkJPDrqXnnK1C/MTeYEBQHWEgK3/yRdp2WS8k
         xgAhqVYJTcJHiNp2zH0FsvyPNR+LaacNHIz6qlDMWrSwT+tkMed4xr4MBMF/qY9a63
         XPxrG20sXbzKh2eSp5ml2/hHHpfggdRLmDy+89W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0638/1146] crypto: x86/sha256 - fix possible crash with CFI enabled
Date:   Wed, 28 Dec 2022 15:36:17 +0100
Message-Id: <20221228144347.492670853@linuxfoundation.org>
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

[ Upstream commit 19940ebbb59c12146d05c5f8acd873197b290648 ]

sha256_transform_ssse3(), sha256_transform_avx(),
sha256_transform_rorx(), and sha256_ni_transform() are called via
indirect function calls.  Therefore they need to use
SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause their type
hashes to be emitted when the kernel is built with CONFIG_CFI_CLANG=y.
Otherwise, the code crashes with a CFI failure (if the compiler didn't
happen to optimize out the indirect calls).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha256-avx-asm.S   | 3 ++-
 arch/x86/crypto/sha256-avx2-asm.S  | 3 ++-
 arch/x86/crypto/sha256-ssse3-asm.S | 3 ++-
 arch/x86/crypto/sha256_ni_asm.S    | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 3baa1ec39097..06ea30c20828 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -48,6 +48,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 ## assume buffers not aligned
 #define    VMOVDQ vmovdqu
@@ -346,7 +347,7 @@ a = TMP_
 ## arg 3 : Num blocks
 ########################################################################
 .text
-SYM_FUNC_START(sha256_transform_avx)
+SYM_TYPED_FUNC_START(sha256_transform_avx)
 .align 32
 	pushq   %rbx
 	pushq   %r12
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 9bcdbc47b8b4..2d2be531a11e 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -49,6 +49,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 ## assume buffers not aligned
 #define	VMOVDQ vmovdqu
@@ -523,7 +524,7 @@ STACK_SIZE	= _CTX      + _CTX_SIZE
 ## arg 3 : Num blocks
 ########################################################################
 .text
-SYM_FUNC_START(sha256_transform_rorx)
+SYM_TYPED_FUNC_START(sha256_transform_rorx)
 .align 32
 	pushq	%rbx
 	pushq	%r12
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index c4a5db612c32..7db28839108d 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -47,6 +47,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 ## assume buffers not aligned
 #define    MOVDQ movdqu
@@ -355,7 +356,7 @@ a = TMP_
 ## arg 3 : Num blocks
 ########################################################################
 .text
-SYM_FUNC_START(sha256_transform_ssse3)
+SYM_TYPED_FUNC_START(sha256_transform_ssse3)
 .align 32
 	pushq   %rbx
 	pushq   %r12
diff --git a/arch/x86/crypto/sha256_ni_asm.S b/arch/x86/crypto/sha256_ni_asm.S
index 94d50dd27cb5..47f93937f798 100644
--- a/arch/x86/crypto/sha256_ni_asm.S
+++ b/arch/x86/crypto/sha256_ni_asm.S
@@ -54,6 +54,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define DIGEST_PTR	%rdi	/* 1st arg */
 #define DATA_PTR	%rsi	/* 2nd arg */
@@ -97,7 +98,7 @@
 
 .text
 .align 32
-SYM_FUNC_START(sha256_ni_transform)
+SYM_TYPED_FUNC_START(sha256_ni_transform)
 
 	shl		$6, NUM_BLKS		/*  convert to bytes */
 	jz		.Ldone_hash
-- 
2.35.1



