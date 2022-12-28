Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0876580BA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbiL1QTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiL1QSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:18:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFCF19C1A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F77FB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9653DC433D2;
        Wed, 28 Dec 2022 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244245;
        bh=8eDiZnpoVyGp1Wn/OiEOQMkqTSKufieerMiv1MdhCz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHexxYVyLsFsAgkgLf+hIu803biGlFErb3RBXpMya5qmlqKEhAP2WY8mGrczHWMLh
         pfkn22Exf3G7JCXTSZDfE16ghKfNVcavQIuvZK5yd8mRvMfiuVsZEMUN4JWksbnFVr
         hyGIuWPfrWMDqFD030NzLnbDsSOGFQ3cC9qupT4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0635/1146] crypto: x86/aegis128 - fix possible crash with CFI enabled
Date:   Wed, 28 Dec 2022 15:36:14 +0100
Message-Id: <20221228144347.412551398@linuxfoundation.org>
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

[ Upstream commit 8bd9974b6bfcd1e14a001deeca051aed7295559a ]

crypto_aegis128_aesni_enc(), crypto_aegis128_aesni_enc_tail(),
crypto_aegis128_aesni_dec(), and crypto_aegis128_aesni_dec_tail() are
called via indirect function calls.  Therefore they need to use
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
 arch/x86/crypto/aegis128-aesni-asm.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index b48ddebb4748..cdf3215ec272 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 #define STATE0	%xmm0
@@ -402,7 +403,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_ad)
  * void crypto_aegis128_aesni_enc(void *state, unsigned int length,
  *                                const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_enc)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc)
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
@@ -499,7 +500,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc)
  * void crypto_aegis128_aesni_enc_tail(void *state, unsigned int length,
  *                                     const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc_tail)
 	FRAME_BEGIN
 
 	/* load the state: */
@@ -556,7 +557,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
  * void crypto_aegis128_aesni_dec(void *state, unsigned int length,
  *                                const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_dec)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec)
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
@@ -653,7 +654,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_dec)
  * void crypto_aegis128_aesni_dec_tail(void *state, unsigned int length,
  *                                     const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_dec_tail)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec_tail)
 	FRAME_BEGIN
 
 	/* load the state: */
-- 
2.35.1



