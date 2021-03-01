Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7340A328808
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbhCARcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:32:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238409AbhCAR0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB9A764F12;
        Mon,  1 Mar 2021 16:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617443;
        bh=OgBdPdWb093J5ORSeNAH035yB+RLNi53YQqSSCkQcJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSFfuJl3fVpdffiUqzJwfr/5ETgjE2Gw1JAgjHMw5Kam0EWjG9rCgk4fgfXQb6CWr
         YVxH+zvsMob+G57U5lGAVKAuu03+NP9leNow3bS8pM5eeAH5wS56XwQZbWnaUZBZUL
         VlnyIqo0Sqev0IAxayPUwROirElVCIbK+4okOatU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/340] crypto: arm64/aes-ce - really hide slower algos when faster ones are enabled
Date:   Mon,  1 Mar 2021 17:10:20 +0100
Message-Id: <20210301161052.072691533@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index aa57dc639f77f..aa13344a3a5e8 100644
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
@@ -668,7 +668,7 @@ static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aes_algs[] = { {
-#if defined(USE_V8_CRYPTO_EXTENSIONS) || !defined(CONFIG_CRYPTO_AES_ARM64_BS)
+#if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 	.base = {
 		.cra_name		= "__ecb(aes)",
 		.cra_driver_name	= "__ecb-aes-" MODE,
-- 
2.27.0



