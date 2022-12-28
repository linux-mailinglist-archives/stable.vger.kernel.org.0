Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3996F6580A9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiL1QTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbiL1QSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:18:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A071A052
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0912CB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFC3C433EF;
        Wed, 28 Dec 2022 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244252;
        bh=22tb6SCy+zVazC/MOAPqPzppOhp+45mRhkG6WrOxtVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEnsBndOGfjynvbQrnNPa2zeHkHxv4TNgkkXnIOZ/XxzW46OlV0oVMx5BhZhu/rh6
         l4WD5jznmnOxY6Zv6KBWyoQa9vi0h3OLb7RfUxJNl7XS8hZz/iUBvT48RIYmn5QQCB
         2H30lUEkpkQc2thxZ4r1EzVv3JQvMXFsC3ZdzqKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0636/1146] crypto: x86/aria - fix crash with CFI enabled
Date:   Wed, 28 Dec 2022 15:36:15 +0100
Message-Id: <20221228144347.439118172@linuxfoundation.org>
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

[ Upstream commit c67b553a4f4a8bd921e4c9ceae00e111be09c488 ]

aria_aesni_avx_encrypt_16way(), aria_aesni_avx_decrypt_16way(),
aria_aesni_avx_ctr_crypt_16way(), aria_aesni_avx_gfni_encrypt_16way(),
aria_aesni_avx_gfni_decrypt_16way(), and
aria_aesni_avx_gfni_ctr_crypt_16way() are called via indirect function
calls.  Therefore they need to use SYM_TYPED_FUNC_START instead of
SYM_FUNC_START to cause their type hashes to be emitted when the kernel
is built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a
CFI failure.

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index c75fd7d015ed..03ae4cd1d976 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 /* struct aria_ctx: */
@@ -913,7 +914,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_crypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_encrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_encrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -938,7 +939,7 @@ SYM_FUNC_START(aria_aesni_avx_encrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_encrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_decrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_decrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1039,7 +1040,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_ctr_gen_keystream_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_ctr_gen_keystream_16way)
 
-SYM_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
 	/* input:
 	*      %rdi: ctx
 	*      %rsi: dst
@@ -1208,7 +1209,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_gfni_crypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1233,7 +1234,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_encrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1258,7 +1259,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_decrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
 	/* input:
 	*      %rdi: ctx
 	*      %rsi: dst
-- 
2.35.1



