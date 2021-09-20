Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18570411EEC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346324AbhITRgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351235AbhITRcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7788261AED;
        Mon, 20 Sep 2021 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157502;
        bh=PvS1AAQEt6tZylI6z9g9kWmK5tDs+S0OIYRmXS5hoP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+UmnriAbXKYtkJxilRY/ItjQXK9tXEvGuqIZEJnqw9rX9D4EFXzJS8z6YGvC1W5/
         RWue9tw5p+tD2GRhntOoTn6b1rSPzkcpdgpBHpwprku5VhC1ypHR0ikH/O+zGDOk+h
         kNKyWvyKeu5TuX+08tR25uGZ1VRlKFnnrD6zDbdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 020/293] crypto: talitos - reduce max key size for SEC1
Date:   Mon, 20 Sep 2021 18:39:42 +0200
Message-Id: <20210920163933.961295389@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -853,7 +853,11 @@ static void talitos_unregister_rng(struc
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


