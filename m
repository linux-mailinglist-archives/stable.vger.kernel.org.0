Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809A3541C3F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382879AbiFGV6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383274AbiFGVxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF262431AB;
        Tue,  7 Jun 2022 12:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9B24B823AF;
        Tue,  7 Jun 2022 19:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55636C385A2;
        Tue,  7 Jun 2022 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629058;
        bh=Dj50xF/Cx05yHTw1UmRpKXoSA61hVVmCLVX9Gzhm0fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhR0FUnOmPSjIikivBuIWgoUhtO8bsS7w27PfxC7MJSM99GkOqyxFT1kmmkMxbE8g
         Zgev/R3JeTUr1JT0PRsn/t8TpE6b8mI6ZUVYcNJ/sCN2x7ZNvZ7SM99DdQ52+HiMTK
         Q1tXZvpmAYEGNHqUfSc6YcmpowaNe1OSVJ+L4uRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 555/879] crypto: qat - set CIPHER capability for DH895XCC
Date:   Tue,  7 Jun 2022 19:01:13 +0200
Message-Id: <20220607165018.975643273@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

[ Upstream commit 6a23804cb8bcb85c6998bf193d94d4036db26f51 ]

Set the CIPHER capability for QAT DH895XCC devices if the hardware supports
it. This is done if both the CIPHER and the AUTHENTICATION engines are
available on the device.

Fixes: ad1332aa67ec ("crypto: qat - add support for capability detection")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 1e7bed8b011f..8a526badf5bf 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -60,17 +60,23 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 	capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 		       ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
-		       ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+		       ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+		       ICP_ACCEL_CAPABILITIES_CIPHER;
 
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
 	if (legfuses & ICP_ACCEL_MASK_COMPRESS_SLICE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
-- 
2.35.1



