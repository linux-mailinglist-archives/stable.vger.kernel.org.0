Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C192E3B87
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406822AbgL1NvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406497AbgL1NvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 952AA206D4;
        Mon, 28 Dec 2020 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163445;
        bh=oVlP5CyOAGEWwhdM0Le/ucp8yLDKWgmdt2WsICQTp7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aS7FBtNjot7bbqii5kcd3eFYUx7G8MXcxMXqumqHg/7g3yfR4DCW94MMgy8hA3oJg
         guhX/bF2IWSmwkCO0DBXDVpAdEdauRzAqSGzPTaCLPdG7ugVNThZNBVJY2DN2tpSQv
         xz6IBcv5b78dxxBX2JrKMhP44ohGh7IiUjjy0Zto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 271/453] crypto: atmel-i2c - select CONFIG_BITREVERSE
Date:   Mon, 28 Dec 2020 13:48:27 +0100
Message-Id: <20201228124950.270839133@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 0952f059d967c..1f6308cdf79a2 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -544,6 +544,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_ATMEL_I2C
 	tristate
+	select BITREVERSE
 
 config CRYPTO_DEV_ATMEL_ECC
 	tristate "Support for Microchip / Atmel ECC hw accelerator"
-- 
2.27.0



