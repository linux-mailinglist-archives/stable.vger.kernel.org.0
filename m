Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B19201439
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391362AbgFSPFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391356AbgFSPFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:05:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBA1E21841;
        Fri, 19 Jun 2020 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579153;
        bh=1ZqBWfgeh7FOkLqgoKPI+U9m04VMyCuq7dbiqJMlu9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjs+Ux9oTaJdgr7YmjoWcPfFHUuVHLy0PNI1vZYAuTENLUVX0FYRrL6BstiYNFhzm
         DuSpJZfb/x1YP8Yba1EjEk3WSS5J9CKgt/XcxoS/jyfAUqrkkP0gCeUGywP29lAMiv
         1tq/cDUDWzZMIcWGj1NeV1478rVuIViCYClA1Skw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/261] crypto: ccp -- dont "select" CONFIG_DMADEVICES
Date:   Fri, 19 Jun 2020 16:30:18 +0200
Message-Id: <20200619141650.244907382@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit eebac678556d6927f09a992872f4464cf3aecc76 ]

DMADEVICES is the top-level option for the slave DMA
subsystem, and should not be selected by device drivers,
as this can cause circular dependencies such as:

drivers/net/ethernet/freescale/Kconfig:6:error: recursive dependency detected!
drivers/net/ethernet/freescale/Kconfig:6:	symbol NET_VENDOR_FREESCALE depends on PPC_BESTCOMM
drivers/dma/bestcomm/Kconfig:6:	symbol PPC_BESTCOMM depends on DMADEVICES
drivers/dma/Kconfig:6:	symbol DMADEVICES is selected by CRYPTO_DEV_SP_CCP
drivers/crypto/ccp/Kconfig:10:	symbol CRYPTO_DEV_SP_CCP depends on CRYPTO
crypto/Kconfig:16:	symbol CRYPTO is selected by LIBCRC32C
lib/Kconfig:222:	symbol LIBCRC32C is selected by LIQUIDIO
drivers/net/ethernet/cavium/Kconfig:65:	symbol LIQUIDIO depends on PTP_1588_CLOCK
drivers/ptp/Kconfig:8:	symbol PTP_1588_CLOCK is implied by FEC
drivers/net/ethernet/freescale/Kconfig:23:	symbol FEC depends on NET_VENDOR_FREESCALE

The LIQUIDIO driver causing this problem is addressed in a
separate patch, but this change is needed to prevent it from
happening again.

Using "depends on DMADEVICES" is what we do for all other
implementations of slave DMA controllers as well.

Fixes: b3c2fee5d66b ("crypto: ccp - Ensure all dependencies are specified")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 8fec733f567f..63e227adbb13 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -10,10 +10,9 @@ config CRYPTO_DEV_CCP_DD
 config CRYPTO_DEV_SP_CCP
 	bool "Cryptographic Coprocessor device"
 	default y
-	depends on CRYPTO_DEV_CCP_DD
+	depends on CRYPTO_DEV_CCP_DD && DMADEVICES
 	select HW_RANDOM
 	select DMA_ENGINE
-	select DMADEVICES
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	help
-- 
2.25.1



