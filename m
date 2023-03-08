Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249686B00D5
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 09:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCHIWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 03:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjCHIVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 03:21:22 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D04B06D6;
        Wed,  8 Mar 2023 00:20:52 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 2768516DE;
        Wed,  8 Mar 2023 09:20:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678263632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQro8lAsxYdfyKtXuzQP2F4xpI7uvYsRP5+6tnRPfKk=;
        b=QFTk0YH6t7zZMfpisKd1d1db9X237jRHj3oezB+gQ69KGAq+FeRGnktvA8Eo6mJGOd7b2/
        AEjC/DbAD1os8B0YfEkDU9n/RIZjz+FD+A2rDwBSICQqoDIJLXNa2X66DbmiymyZDYHhpi
        zdjIuvQR1S1ynay7zaGTHw0/6Tso0HEsFV4mbOcTMuKHNvSAbMO2EHBvOX8aVJRXwP6Bnw
        K6m8MdVzc5QAHjWyWr+SP55SLwAORXhekigxg7KwvyZ4eOlo2ORSIC4dt0F5UuwNsnaJhJ
        n8Wm6siWFaXBn1gh3AGdWFtf+8cG+a9zzZqwNVTn+J/sDEU0Z1q/1thSUGaGxw==
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>, stable@vger.kernel.org
Subject: [PATCH v2 3/4] mtd: core: fix error path for nvmem provider
Date:   Wed,  8 Mar 2023 09:20:20 +0100
Message-Id: <20230308082021.870459-3-michael@walle.cc>
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

If mtd_otp_nvmem_add() fails, the partitions won't be removed
because there is simply no call to del_mtd_partitions().
Unfortunately, add_mtd_partitions() will print all partitions to
the kernel console. If mtd_otp_nvmem_add() returns -EPROBE_DEFER
this would print the partitions multiple times to the kernel
console. Instead move mtd_otp_nvmem_add() to the beginning of the
function.

Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - none

 drivers/mtd/mtdcore.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c38a13cb8d5e..0bc9676fe029 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1023,10 +1023,14 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
 
 	mtd_set_dev_defaults(mtd);
 
+	ret = mtd_otp_nvmem_add(mtd);
+	if (ret)
+		goto out;
+
 	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER)) {
 		ret = add_mtd_device(mtd);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	/* Prefer parsed partitions over driver-provided fallback */
@@ -1061,9 +1065,12 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
 		register_reboot_notifier(&mtd->reboot_notifier);
 	}
 
-	ret = mtd_otp_nvmem_add(mtd);
-
 out:
+	if (ret) {
+		nvmem_unregister(mtd->otp_user_nvmem);
+		nvmem_unregister(mtd->otp_factory_nvmem);
+	}
+
 	if (ret && device_is_registered(&mtd->dev))
 		del_mtd_device(mtd);
 
-- 
2.30.2

