Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE14172CA
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344108AbhIXMvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343995AbhIXMuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2516A6128E;
        Fri, 24 Sep 2021 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487685;
        bh=+os6h3+603k8KxKhCv8nCdcFOo2nH+zYn1AAiuUodKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6E1cdG6PsACiKbPd11a4RSyB99ZEsElQPqBP/lQO4dV9SkiYAXerIvFIZRxrtvwu
         qBbl4HMfwPEE5VpYPA3V1klv/Zl+kZtx5dnqknl/xqdNieaPjkHGrvGAQLgoZBvaN6
         87qRGvI8ywnCM3vbG7Zs3GhgGOWCcV7UTklCzN5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.14 04/27] crypto: talitos - fix max key size for sha384 and sha512
Date:   Fri, 24 Sep 2021 14:43:58 +0200
Message-Id: <20210924124329.323456478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 192125ed5ce62afba24312d8e7a0314577565b4a upstream.

Below commit came with a typo in the CONFIG_ symbol, leading
to a permanently reduced max key size regarless of the driver
capabilities.

Reported-by: Horia Geantă <horia.geanta@nxp.com>
Fixes: b8fbdc2bc4e7 ("crypto: talitos - reduce max key size for SEC1")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -816,7 +816,7 @@ static void talitos_unregister_rng(struc
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-#ifdef CONFIG_CRYPTO_DEV_TALITOS_SEC2
+#ifdef CONFIG_CRYPTO_DEV_TALITOS2
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
 #else
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)


