Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB39540D31
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352181AbiFGSre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346859AbiFGSnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:43:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A55187C20;
        Tue,  7 Jun 2022 10:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18313616B6;
        Tue,  7 Jun 2022 17:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B05C34119;
        Tue,  7 Jun 2022 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624747;
        bh=8zuQueNsSr1TyJypSiaofzqDHTFGwa1xbHSs9LGhZiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyT0SnVmqkJ1EZIgkI2uyadYHUqceF9uD7gC99fC3G3p8VTtNHlGGeszesKQEC8Om
         epxLIDILbZ8o6b9oKx2KFdwOk9ci7QZExKfy4JI6CIHgK2Mu2wWww7XSb478bP1Rh9
         Uv5ss4AZuWbajElRLuzuOCj6MzKrIhtj4Orw/a3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/667] crypto: qat - set CIPHER capability for QAT GEN2
Date:   Tue,  7 Jun 2022 19:01:03 +0200
Message-Id: <20220607164946.681876644@linuxfoundation.org>
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

[ Upstream commit 547bde7bd4ecd78f36f98744e6c9a0999e52da5a ]

Set the CIPHER capability for QAT GEN2 devices if the hardware supports
it. This is done if both the CIPHER and the AUTHENTICATION engines are
available on the device.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 9e560c7d4163..9c5871e1752a 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -161,17 +161,23 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 	u32 legfuses;
 	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
-			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+			   ICP_ACCEL_CAPABILITIES_CIPHER;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
 
-	if (legfuses & ICP_ACCEL_MASK_CIPHER_SLICE)
+	/* A set bit in legfuses means the feature is OFF in this SKU */
+	if (legfuses & ICP_ACCEL_MASK_CIPHER_SLICE) {
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+	}
 	if (legfuses & ICP_ACCEL_MASK_PKE_SLICE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
-	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE)
+	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE) {
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+	}
 
 	if ((straps | fuses) & ADF_POWERGATE_PKE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
-- 
2.35.1



