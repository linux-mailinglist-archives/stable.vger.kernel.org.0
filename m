Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745194510AB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242203AbhKOSw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243038AbhKOSuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A627B63312;
        Mon, 15 Nov 2021 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999716;
        bh=bc2mkQdXRTv39dWaMp1xI6OR/Y4Q0dRQZUJzfHhsIAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lc1YSphYHgAIm4eIregRcAMmfH0Ky7q7bAzxCZYnSbbgsjCQTW0Xt2aGwq6Ym0Lsr
         fg4X2Q0Jqc+QynX+9Io8maSddITM6anxuTrqqX/kvbX1GqK4a1Y4RfpNT3KDfHi/Mi
         f7OZD8vVXb0VqYyk71PIYEUY9CpibhwYEN3ccTWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 398/849] crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency
Date:   Mon, 15 Nov 2021 17:58:01 +0100
Message-Id: <20211115165433.717609398@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 38aa192a05f22f9778f9420e630f0322525ef12e ]

The ecc.c file started out as part of the ECDH algorithm but got
moved out into a standalone module later. It does not build without
CRYPTO_DEFAULT_RNG, so now that other modules are using it as well we
can run into this link error:

aarch64-linux-ld: ecc.c:(.text+0xfc8): undefined reference to `crypto_default_rng'
aarch64-linux-ld: ecc.c:(.text+0xff4): undefined reference to `crypto_put_default_rng'

Move the 'select CRYPTO_DEFAULT_RNG' statement into the correct symbol.

Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 64b772c5d1c9b..46129f49a38c3 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -233,12 +233,12 @@ config CRYPTO_DH
 
 config CRYPTO_ECC
 	tristate
+	select CRYPTO_RNG_DEFAULT
 
 config CRYPTO_ECDH
 	tristate "ECDH algorithm"
 	select CRYPTO_ECC
 	select CRYPTO_KPP
-	select CRYPTO_RNG_DEFAULT
 	help
 	  Generic implementation of the ECDH algorithm
 
-- 
2.33.0



