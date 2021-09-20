Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F718411B5B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242217AbhITQ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244010AbhITQzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57AF661351;
        Mon, 20 Sep 2021 16:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156660;
        bh=Yi2OEh4XJmR6gsXS2GG62TRXrCo+BXYyyvtYX97RDI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbm5h8c7TeACLH3qYi4Pp/YQPPaYegQUdkjs01HGd10rGwUeJprJ/OkrV8U5d4tRE
         egiBrADbcaumxSrC4w3tCjLi6O9m8rfhNuETTj4IcfxGiiRyg+84cRrU7scFTusLDI
         7CAmR2RVuGX/O1lzKssTzleIzJV13DQaaC1mNSoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 027/175] crypto: talitos - reduce max key size for SEC1
Date:   Mon, 20 Sep 2021 18:41:16 +0200
Message-Id: <20210920163918.956276762@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit b8fbdc2bc4e71b62646031d5df5f08aafe15d5ad upstream.

SEC1 doesn't support SHA384/512, so it doesn't require
longer keys.

This patch reduces the max key size when the driver
is built for SEC1 only.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 03d2c5114c95 ("crypto: talitos - Extend max key length for SHA384/512-HMAC and AEAD")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -816,7 +816,11 @@ static void talitos_unregister_rng(struc
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
+#ifdef CONFIG_CRYPTO_DEV_TALITOS_SEC2
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
+#else
+#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
+#endif
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 struct talitos_ctx {


