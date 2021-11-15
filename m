Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70429452679
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237809AbhKPCFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239582AbhKOSDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0BD261C14;
        Mon, 15 Nov 2021 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997854;
        bh=/0ngF0PMk3mtqCiSzqkDdg37fF/jiw7iczghTE3uxt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mc9sK2NJWGXHbgto17w21yi00YTCs8x6z2GrH0Fx7BvIyRSDOsjN3LvDJXe5Bp+aR
         68MCYIq/jXE08mUoOXr4f8sFPVORPCeUIGl7rf3NfbWRgR40pteq0bD5sRPHNCvYaL
         wwgwDZRLLRkDlCTA+mXz29mMVuHRANefJWFHIOIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/575] crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency
Date:   Mon, 15 Nov 2021 18:00:25 +0100
Message-Id: <20211115165354.146595865@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 774adc9846fa8..1157f82dc9cf4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -238,12 +238,12 @@ config CRYPTO_DH
 
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



