Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4126B00D4
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 09:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjCHIWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 03:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjCHIVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 03:21:22 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFC850FB5;
        Wed,  8 Mar 2023 00:20:52 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 9B5CA1682;
        Wed,  8 Mar 2023 09:20:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678263631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAMTuERNi5qJ5J2h23oJyeBeqJlcNnQwXiDuZ+qFEoo=;
        b=PKL5PtYz/bMjz4cxIcC8vIUdQ4+Jm10yyo3BPNlL6qIwlzqBZWnL7WnS/uPoNMvNZMUS+J
        rBEDvg8HzmWRea8GK1Mex6fjBqAFse89WwuT+U1MuBBFmdKjnXXft1ldkzyoAAeg81ac5s
        crYfufJ4eca0J5ltVqMIZJA+aBYd+eEH86LhOd4eVZDsLWvKfSKhLtE7Osnry4V77ANvoF
        2GajLhZZEtY/6YHAR9IkQyKyNs7nxaVyT1uflo5GtJPEybtU5D23NhchnwJ1UTDdIcngKq
        Cp/WNzTiax8PWJH+n8UIYGbl3Ni775RvqA8XMAFEBTvNWM7ewkZ/1Vqbvtg36A==
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>, stable@vger.kernel.org
Subject: [PATCH v2 2/4] mtd: core: fix nvmem error reporting
Date:   Wed,  8 Mar 2023 09:20:19 +0100
Message-Id: <20230308082021.870459-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230308082021.870459-1-michael@walle.cc>
References: <20230308082021.870459-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The master MTD will only have an associated device if
CONFIG_MTD_PARTITIONED_MASTER is set, thus we cannot use dev_err() on
mtd->dev. Instead use the parent device which is the physical flash
memory.

Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - none

 drivers/mtd/mtdcore.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 8fc66cda4a09..c38a13cb8d5e 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -939,6 +939,7 @@ static int mtd_nvmem_fact_otp_reg_read(void *priv, unsigned int offset,
 
 static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 {
+	struct device *dev = mtd->dev.parent;
 	struct nvmem_device *nvmem;
 	ssize_t size;
 	int err;
@@ -952,7 +953,7 @@ static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 			nvmem = mtd_otp_nvmem_register(mtd, "user-otp", size,
 						       mtd_nvmem_user_otp_reg_read);
 			if (IS_ERR(nvmem)) {
-				dev_err(&mtd->dev, "Failed to register OTP NVMEM device\n");
+				dev_err(dev, "Failed to register OTP NVMEM device\n");
 				return PTR_ERR(nvmem);
 			}
 			mtd->otp_user_nvmem = nvmem;
@@ -970,7 +971,7 @@ static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 			nvmem = mtd_otp_nvmem_register(mtd, "factory-otp", size,
 						       mtd_nvmem_fact_otp_reg_read);
 			if (IS_ERR(nvmem)) {
-				dev_err(&mtd->dev, "Failed to register OTP NVMEM device\n");
+				dev_err(dev, "Failed to register OTP NVMEM device\n");
 				err = PTR_ERR(nvmem);
 				goto err;
 			}
-- 
2.30.2

