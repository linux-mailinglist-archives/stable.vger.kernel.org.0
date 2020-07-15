Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267DF220786
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 10:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgGOIiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 04:38:10 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:20400 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgGOIiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 04:38:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594802288; x=1626338288;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zkOPZga5dYjTfkahTVbo+6M0cJuULmnOy6fWthXpK9k=;
  b=gMHt6ncBsSW1LSfyYL5gHtBolOP/3Y5Q3EYAdMyZFwoehmrgvIoscpvf
   +rcSQBfN5aWylaDOLZkEc171E/Cut3FfJH9K61QB4Ko4S4qMG7rqzkTD1
   t1Gpw9JiV0VwrZIOjsKx3IIixLe0492Sx9w6+8rfEBzX7xMKe88ddtFjE
   pUMN9Og29/mvWvWT4G/Ss0OTtyR7LpSKRR98W69zP/lOjx8ivZGzEvS2R
   NldAeW5StFnx4BomE10lS3usINs1w/CRz0beU9GA7pKNvCSFGoezFLgi9
   lr/MviGTJCXmJWGn8WBCR2UP4/dmmqkxFyzGzDQNy6rTBg9ClsVyrnPC+
   Q==;
IronPort-SDR: NZaz99ak4TN9N/ru3szRqpCtjyZ57j3xIjUar/s5uyN826UBRDbFY0pxIlWHPJOMo7SlenK/ua
 MnDeVpXtGK/Pfvo0QTPkien4gcCPuc42k0437EYGvJt9XmLHTTWH1w0KcAymNWTczSAbvvua3H
 N9S5jdWLCT4ukRGuqRC2bN4u3wF+lSNvdIl93QKLREzuIkdXPryINnBGShQwhPb3ImMUv2l9SF
 6hjtpjbPODJfMaQs4c4ugUdK/wNgJb1njA+6J9R/XKb/YgFfAeAJU7c2DuAerlEHYjGxd7Db3v
 isc=
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="19255443"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jul 2020 01:38:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 01:37:34 -0700
Received: from atudor-ThinkPad-T470p.amer.actel.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 15 Jul 2020 01:37:31 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <gregkh@linuxfoundation.org>, <alexander.levin@microsoft.com>
CC:     <stable@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Hulk Robot <hulkci@huawei.com>,
        "kernel test robot" <lkp@intel.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 5.4] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Date:   Wed, 15 Jul 2020 11:38:02 +0300
Message-ID: <20200715083802.460760-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport to 5.4.52-rc1 the following commits in upstream:
commit aee1f9f3c30e1e20e7f74729ced61eac7d74ca68 upstream.
commit d158367682cd822aca811971e988be6a8d8f679f upstream.

If CRYPTO_DEV_ATMEL_AUTHENC is m, CRYPTO_DEV_ATMEL_SHA is m,
but CRYPTO_DEV_ATMEL_AES is y, building will fail:

drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_init_tfm':
atmel-aes.c:(.text+0x670): undefined reference to `atmel_sha_authenc_get_reqsize'
atmel-aes.c:(.text+0x67a): undefined reference to `atmel_sha_authenc_spawn'
drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_setkey':
atmel-aes.c:(.text+0x7e5): undefined reference to `atmel_sha_authenc_setkey'

Make CRYPTO_DEV_ATMEL_AUTHENC depend on CRYPTO_DEV_ATMEL_AES,
and select CRYPTO_DEV_ATMEL_SHA and CRYPTO_AUTHENC for it under there.

Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[tudor.ambarus@microchip.com: Backport to 5.4.52-rc1]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 06b2b3fa5206..0952f059d967 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -491,11 +491,9 @@ if CRYPTO_DEV_UX500
 endif # if CRYPTO_DEV_UX500
 
 config CRYPTO_DEV_ATMEL_AUTHENC
-	tristate "Support for Atmel IPSEC/SSL hw accelerator"
+	bool "Support for Atmel IPSEC/SSL hw accelerator"
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_AUTHENC
-	select CRYPTO_DEV_ATMEL_AES
-	select CRYPTO_DEV_ATMEL_SHA
+	depends on CRYPTO_DEV_ATMEL_AES
 	help
 	  Some Atmel processors can combine the AES and SHA hw accelerators
 	  to enhance support of IPSEC/SSL.
@@ -508,6 +506,8 @@ config CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_AUTHENC if CRYPTO_DEV_ATMEL_AUTHENC
+	select CRYPTO_DEV_ATMEL_SHA if CRYPTO_DEV_ATMEL_AUTHENC
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for
-- 
2.25.1

