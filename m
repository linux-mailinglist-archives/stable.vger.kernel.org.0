Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AE26A3B46
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 07:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjB0Gda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 01:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB0Gd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 01:33:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AAACA2A;
        Sun, 26 Feb 2023 22:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF64960C88;
        Mon, 27 Feb 2023 06:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421A1C433D2;
        Mon, 27 Feb 2023 06:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677479607;
        bh=a5mHCJD7eGPHcY7tdYCOHWp/H8HJlXIIMr3FEKuf2dI=;
        h=From:To:Cc:Subject:Date:From;
        b=WyLuIGrk3u3eei9RYGf3GFDOiW81rpJWwPmzp2E76grynA6jGtii5HlenrRj3jH8E
         3McoJcTqPTxUPjq2RdrxDu1Nb/5rr4aBVUfQcsKXyfb/WEkuWrU/QOLs0Bq9/aG25C
         1tBdpFzoVa2eyjJGmdeW6H4NktxFJEJ0SX1Rcwd8lZNOrebv64lm+K6+ChyUqkD1Qj
         CLVb9uK0new5un+aaup/J8mooWB5LVjo2RPg+AHZyJ1FlCsG90XEBDaYpDs+rFsQ6E
         ukYdIrhb9TbScHkV2wUiaqpigwQuAdN8H1jiN2ec1vF+2hTITUGF7nknoc21/p7L8y
         lXHn5ZtkDqfZw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Subject: [PATCH] crypto: arm64/aes-neonbs - fix crash with CFI enabled
Date:   Sun, 26 Feb 2023 22:32:23 -0800
Message-Id: <20230227063223.1829703-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

aesbs_ecb_encrypt(), aesbs_ecb_decrypt(), aesbs_xts_encrypt(), and
aesbs_xts_decrypt() are called via indirect function calls.  Therefore
they need to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause
their type hashes to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure if
the compiler doesn't happen to optimize out the indirect calls.

Fixes: c50d32859e70 ("arm64: Add types to indirect called assembly functions")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-neonbs-core.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index 7278a37c2d5c..baf450717b24 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -15,6 +15,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 	.text
@@ -620,12 +621,12 @@ SYM_FUNC_END(aesbs_decrypt8)
 	.endm
 
 	.align		4
-SYM_FUNC_START(aesbs_ecb_encrypt)
+SYM_TYPED_FUNC_START(aesbs_ecb_encrypt)
 	__ecb_crypt	aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
 SYM_FUNC_END(aesbs_ecb_encrypt)
 
 	.align		4
-SYM_FUNC_START(aesbs_ecb_decrypt)
+SYM_TYPED_FUNC_START(aesbs_ecb_decrypt)
 	__ecb_crypt	aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
 SYM_FUNC_END(aesbs_ecb_decrypt)
 
@@ -799,11 +800,11 @@ SYM_FUNC_END(__xts_crypt8)
 	ret
 	.endm
 
-SYM_FUNC_START(aesbs_xts_encrypt)
+SYM_TYPED_FUNC_START(aesbs_xts_encrypt)
 	__xts_crypt	aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
 SYM_FUNC_END(aesbs_xts_encrypt)
 
-SYM_FUNC_START(aesbs_xts_decrypt)
+SYM_TYPED_FUNC_START(aesbs_xts_decrypt)
 	__xts_crypt	aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
 SYM_FUNC_END(aesbs_xts_decrypt)
 

base-commit: f3a2439f20d918930cc4ae8f76fe1c1afd26958f
-- 
2.39.2

