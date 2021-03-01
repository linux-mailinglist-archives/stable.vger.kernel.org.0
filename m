Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7F7328EF1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241578AbhCATlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241601AbhCATcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B651A65303;
        Mon,  1 Mar 2021 17:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620508;
        bh=GwEJmiFERp6COY/bVv1LD7Jx8iMrIUfQCXRWYVeMC5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkDIOYcWnGrORmWNn+VnoX9/R0FNbK9mJ5YiEsmf3goqfURc7cTcqYlSPInpNpXfB
         0ZnXQgOmTJ2oZHcAY9sfKof8Ju1bXwwPHG8atRuKkxTvdowJVaQlr9cNMZ1MUn6QjF
         3s7w4ZXO/31mikkYL/dcuGi8vJWMEp+oh4Axo26A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 179/775] crypto: arm64/aes-ce - really hide slower algos when faster ones are enabled
Date:   Mon,  1 Mar 2021 17:05:47 +0100
Message-Id: <20210301161210.475967803@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 15deb4333cd6d4e1e3216582e4c531ec40a6b060 ]

Commit 69b6f2e817e5b ("crypto: arm64/aes-neon - limit exposed routines if
faster driver is enabled") intended to hide modes from the plain NEON
driver that are also implemented by the faster bit sliced NEON one if
both are enabled. However, the defined() CPP function does not detect
if the bit sliced NEON driver is enabled as a module. So instead, let's
use IS_ENABLED() here.

Fixes: 69b6f2e817e5b ("crypto: arm64/aes-neon - limit exposed routines if ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/crypto/aes-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 34b8a89197be3..cafb5b96be0e6 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -55,7 +55,7 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_mac_update		neon_aes_mac_update
 MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
 #endif
-#if defined(USE_V8_CRYPTO_EXTENSIONS) || !defined(CONFIG_CRYPTO_AES_ARM64_BS)
+#if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("cbc(aes)");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
@@ -650,7 +650,7 @@ static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aes_algs[] = { {
-#if defined(USE_V8_CRYPTO_EXTENSIONS) || !defined(CONFIG_CRYPTO_AES_ARM64_BS)
+#if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 	.base = {
 		.cra_name		= "__ecb(aes)",
 		.cra_driver_name	= "__ecb-aes-" MODE,
-- 
2.27.0



