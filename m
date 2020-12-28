Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00672E405A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502336AbgL1Ouo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436590AbgL1OUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 707A4208B6;
        Mon, 28 Dec 2020 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165192;
        bh=eDtlkN/uQRrSLj+hooNLEcFWfstvoopKkKILnGJFquA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SO1l2dkUBwOcaNsguv7n/nt8C7QkJyu+RNLrBbV68AH3NdDmuUWTgEuQyHVisKv56
         lQPpO/krnNvmXofOL+2EbS2JovyTOHRCy8Z/29eI78Y6r+QDLMzYl5F+Oo+r07hG+2
         5ss0wSDagd17rZUaVFM4cgZVjV7LIkb86sL51pNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/717] crypto: atmel-i2c - select CONFIG_BITREVERSE
Date:   Mon, 28 Dec 2020 13:46:52 +0100
Message-Id: <20201228125040.805651764@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d33a23b0532d5d1b5b700e8641661261e7dbef61 ]

The bitreverse helper is almost always built into the kernel,
but in a rare randconfig build it is possible to hit a case
in which it is a loadable module while the atmel-i2c driver
is built-in:

arm-linux-gnueabi-ld: drivers/crypto/atmel-i2c.o: in function `atmel_i2c_checksum':
atmel-i2c.c:(.text+0xa0): undefined reference to `byte_rev_table'

Add one more 'select' statement to prevent this.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 37da0c070a883..9d6645b1f0abe 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -548,6 +548,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_ATMEL_I2C
 	tristate
+	select BITREVERSE
 
 config CRYPTO_DEV_ATMEL_ECC
 	tristate "Support for Microchip / Atmel ECC hw accelerator"
-- 
2.27.0



