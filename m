Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC8540EDE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354138AbiFGSzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353528AbiFGSot (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:44:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF674187C36;
        Tue,  7 Jun 2022 10:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3240617A7;
        Tue,  7 Jun 2022 17:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0222C385A5;
        Tue,  7 Jun 2022 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624750;
        bh=qCYD97p53XY74HmVJjyiatLsAqhNx7HV7fex3PN+4Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+u7PvhshQslc9HB1u2GE6SgB4oyJw8hGKXHbacg27mIZLKd1ZrBref37PWD4s8g/
         fz9LJ1I7x7GfRcPNrH9ZOPrOhvxrul874YnsNRYYy9yuw1AtApdyUQ+zWqFDoe0hNd
         hvWw8+pQEmSSSeNdTjaV7JjQTMOAS9NsHkxD92fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/667] crypto: qat - set COMPRESSION capability for QAT GEN2
Date:   Tue,  7 Jun 2022 19:01:04 +0200
Message-Id: <20220607164946.712231844@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit cfe4894eccdc7fa5cd35bf34e918614d06ecce38 ]

Enhance the device capability detection for QAT GEN2 devices to detect if
a device supports the compression service.

This is done by checking both the fuse and the strap registers for c62x
and c3xxx and only the fuse register for dh895xcc.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c       | 8 +++++++-
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h       | 1 +
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 9c5871e1752a..0ba62b286a85 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -162,7 +162,8 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
-			   ICP_ACCEL_CAPABILITIES_CIPHER;
+			   ICP_ACCEL_CAPABILITIES_CIPHER |
+			   ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
@@ -178,10 +179,15 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
+	if (legfuses & ICP_ACCEL_MASK_COMPRESS_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	if ((straps | fuses) & ADF_POWERGATE_PKE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
 
+	if ((straps | fuses) & ADF_POWERGATE_DC)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
+
 	return capabilities;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_get_accel_cap);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 756b0ddfac5e..2aaf02ccbb3a 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -111,6 +111,7 @@ do { \
 	(ADF_ARB_REG_SLOT * (index)), value)
 
 /* Power gating */
+#define ADF_POWERGATE_DC		BIT(23)
 #define ADF_POWERGATE_PKE		BIT(24)
 
 /* WDT timers
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 0a9ce365a544..a61ad6c93632 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -97,6 +97,8 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
 	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+	if (legfuses & ICP_ACCEL_MASK_COMPRESS_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	return capabilities;
 }
-- 
2.35.1



