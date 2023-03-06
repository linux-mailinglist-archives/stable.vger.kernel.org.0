Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9BD6AC002
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 13:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCFM63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 07:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjCFM62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 07:58:28 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4440623874;
        Mon,  6 Mar 2023 04:58:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D7E6D100;
        Mon,  6 Mar 2023 13:58:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678107498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=felfT43D0ByEEC43Rq1xqotzNKKcG2VF+lRhbg02WB4=;
        b=tgaP+NM0dhhp7GXFV8BWTt6vnZLjr1w+1W/5++uBU3EwNELH8TA/dSk8nEjPE7hC3vvvxV
        xbADrut9+vZU3+IEgKrhA+DFgS52V98rRBEtFn2AumZX+b3sLMpowctuF45agryOrcwb0j
        Sb7fNhecL0+AmyBRFj+tcx/2EGLu4N0DXl9xfDa8qjbniCuD7rZZZXiHDDeckY2xuv/2VW
        TNUzuwazhSNsxkH5RuJqdv71mgPVF1Eqlul+RjJo6GJtj2rqp4T9MeIybpjy9y9sz0yeIN
        AvF88gzzRDul1iVPKJ2w+dI2iwVV7eaSkUrh4hVju4W6cZX/+9UjD39RETt4aw==
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>, stable@vger.kernel.org
Subject: [PATCH 1/4] mtd: core: provide unique name for nvmem device, take two
Date:   Mon,  6 Mar 2023 13:58:02 +0100
Message-Id: <20230306125805.678668-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
tries to give the nvmem device a unique name, but fails badly if the mtd
device doesn't have a "struct device" associated with it, i.e. if
CONFIG_MTD_PARTITIONED_MASTER is not set. This will result in the name
"(null)-user-otp", which is not unique. It seems the best we can do is
to use the compatible name together with a unique identifier added by
the nvmem subsystem by using NVMEM_DEVID_AUTO.

Fixes: c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/mtd/mtdcore.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 0feacb9fbdac..3fe2825a85a1 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -888,8 +888,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 
 	/* OTP nvmem will be registered on the physical device */
 	config.dev = mtd->dev.parent;
-	config.name = kasprintf(GFP_KERNEL, "%s-%s", dev_name(&mtd->dev), compatible);
-	config.id = NVMEM_DEVID_NONE;
+	config.name = compatible;
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
@@ -905,7 +904,6 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 		nvmem = NULL;
 
 	of_node_put(np);
-	kfree(config.name);
 
 	return nvmem;
 }
-- 
2.30.2

