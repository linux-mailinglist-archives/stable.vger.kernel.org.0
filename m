Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC8C220D74
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgGOMyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:54:17 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17438 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgGOMyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 08:54:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594817656; x=1626353656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D/A/EoC9cIhjSGq6bNuGGeKbBGpUWt9W44edXpBm9kk=;
  b=w1UgBWH+bdAkQDQXsJMTOJ5rRgKIswkm6AlKCrd9276PdvQVfvJxJ0x7
   n0So8MEdEYRVIMXUZ1tK8ODHMsz7FTE7Ar/WlABfHOBOkzBFIrUQYcd1F
   l0zZfbcShmiD9dObsf3XYDTYP0LRjWC8zcs5LJGt6l86zoPmIACE/o4fh
   8ItDcpUnh/126VIKfCG3/MfAeVzxfEATVBfYqWfbCzsTYXhC4fMfkIQjZ
   ASfkvU/uYkXL8wdooFGY6k1Sgd6NImhHwM/Aih/8s/zv2Z1pGryAIfv8a
   /afsDVt8goN72LhIsgdVpQ8d1MqDc26kSxiVcyCwsAQ9Y62Yj+H3j6dnt
   g==;
IronPort-SDR: V8Nvv8yid8nuArjaiMwUt3GVLk022Vza6oLj3+jLJHniZnMEN4zyrQg821sC0r0aTCYZekGcWQ
 +QENXAhbDdrGjdmdWlMDFJMNfOD4nQL/BR/r6oVdgeRGkoTaNeAUPEC+E6eoYMNYl+c7nCDex/
 vjFnpjo+NvqF9j4fvnE3odWr9ANoYsoAPdNdGFF4xnn1tx+Vg6MOO499qzEjrfRn3uSALKw0RD
 P8/fLPbPYwLn880ib+ySMzgy2SJn3D84keFmY0GkDtkJqWJn8aS1d9V323SnO7dfRx73LhmK5+
 h+E=
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="79996243"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jul 2020 05:54:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 05:54:15 -0700
Received: from atudor-ThinkPad-T470p.amer.actel.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 15 Jul 2020 05:54:13 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <gregkh@linuxfoundation.org>, <alexander.levin@microsoft.com>
CC:     <stable@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        YueHaibing <yuehaibing@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        kernel test robot <lkp@intel.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 for 5.4 2/2] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Date:   Wed, 15 Jul 2020 15:54:10 +0300
Message-ID: <20200715125410.479112-2-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200715125410.479112-1-tudor.ambarus@microchip.com>
References: <20200715125410.479112-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Backport to 5.4.52-rc1:
commit aee1f9f3c30e1e20e7f74729ced61eac7d74ca68 upstream.

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
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b76ded4f829b..0952f059d967 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -491,10 +491,9 @@ if CRYPTO_DEV_UX500
 endif # if CRYPTO_DEV_UX500
 
 config CRYPTO_DEV_ATMEL_AUTHENC
-	tristate "Support for Atmel IPSEC/SSL hw accelerator"
+	bool "Support for Atmel IPSEC/SSL hw accelerator"
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_DEV_ATMEL_AES
-	select CRYPTO_DEV_ATMEL_SHA
+	depends on CRYPTO_DEV_ATMEL_AES
 	help
 	  Some Atmel processors can combine the AES and SHA hw accelerators
 	  to enhance support of IPSEC/SSL.
@@ -507,7 +506,8 @@ config CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AUTHENC
+	select CRYPTO_AUTHENC if CRYPTO_DEV_ATMEL_AUTHENC
+	select CRYPTO_DEV_ATMEL_SHA if CRYPTO_DEV_ATMEL_AUTHENC
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for
-- 
2.25.1

