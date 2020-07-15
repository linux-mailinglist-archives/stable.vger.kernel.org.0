Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BE2220D73
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgGOMyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:54:15 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6356 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgGOMyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 08:54:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594817654; x=1626353654;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JoNK/q2iYvYFvbaflGD2Rg+e5vGTcnyC23z8HfTCMEM=;
  b=vm/hAQ+P+j25PpJABnxEcOfKWrNriNiXU2OgPeyJrakrJwUyon3XvC6E
   YcllKxJ9hThLA4Qlu2scHuPFc6abcNDQ5xy/CkmEdnLKOrHvl6cT8qDgs
   76P/L9kT97MTjXMDD6ap4+JzE7tsfb1gvWPMJLVagDEyczcOWFsWwfG4c
   jZZ72KH1of/C2YkoepXekpJ/Eaxt8WBAt9YcprjJ2C28hKC0AaeLYV9zx
   b8qUvNkjuU5FMk0u6Mf0Lb09EWucrhsG9oczkae29P7so6DcMXUj4HEcD
   gMt8LzeugiqVUdG64OGGPmA3GoQNE6Hu0I+StShX8hEqmeiOM4ip04XhG
   w==;
IronPort-SDR: LnILQd3PXb3RzJUt2/ZliFsFQYJ2ETxT7gx08wO+8hkdRe90t43vaOdebkGvUYUmi/XZlGO++0
 agbX0LJX5Ma5l+gMRnstX9V2bcguFFlnQAFbTRt9g5smq/6Lm3SYn1Z08B33Vmlq6xZv+l+l5u
 UetNnst/aqC1XCOu/8+WNIzHxRe4fKm7VXdhQCf3Jce8rm/4iy6ioREl4Jk33RhubaOyYTrShL
 XsoDxYz0hrHFmySqyc90447znrJpNFHfXvwp6l/GAGcfLvsNvjy0aKEIIkh8oT2ae1HReJpm9K
 xtk=
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="83971980"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jul 2020 05:54:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 05:53:41 -0700
Received: from atudor-ThinkPad-T470p.amer.actel.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 15 Jul 2020 05:54:11 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <gregkh@linuxfoundation.org>, <alexander.levin@microsoft.com>
CC:     <stable@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 for 5.4 1/2] crypto: atmel - Fix selection of CRYPTO_AUTHENC
Date:   Wed, 15 Jul 2020 15:54:09 +0300
Message-ID: <20200715125410.479112-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport to 5.4.52-rc1:
commit d158367682cd822aca811971e988be6a8d8f679f upstream.

The following error is raised when CONFIG_CRYPTO_DEV_ATMEL_AES=y and
CONFIG_CRYPTO_DEV_ATMEL_AUTHENC=m:
drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_setkey':
atmel-aes.c:(.text+0x9bc): undefined reference to `crypto_authenc_extractkeys'
Makefile:1094: recipe for target 'vmlinux' failed

Fix it by moving the selection of CRYPTO_AUTHENC under
config CRYPTO_DEV_ATMEL_AES.

Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 06b2b3fa5206..b76ded4f829b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -493,7 +493,6 @@ endif # if CRYPTO_DEV_UX500
 config CRYPTO_DEV_ATMEL_AUTHENC
 	tristate "Support for Atmel IPSEC/SSL hw accelerator"
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_AUTHENC
 	select CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_DEV_ATMEL_SHA
 	help
@@ -508,6 +507,7 @@ config CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_AUTHENC
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for
-- 
2.25.1

