Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061D360AC24
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiJXODC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbiJXOCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92F1BECFD;
        Mon, 24 Oct 2022 05:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BA8461335;
        Mon, 24 Oct 2022 12:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBD9C433C1;
        Mon, 24 Oct 2022 12:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615578;
        bh=9BePWnK8/VkHjNuHRA8V9IPoLddrvuN0dJOkG015dOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZKWwxJkaWFEIlwbGEwWoSjcAkIwfa8+qaV/Esp3kxmWckOhdJ3gjMZ71G4ewmYqD
         6bfUQ+hWr4n2JPD0B8LKJl7g8skiMhLQ/7kg9ZL5GdOcV4VRCqSAhkq2nNy/2weSr5
         EaA48ab+Q+bzunc59AEFrmAIpWPAszmSCssXuGW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/530] mtd: rawnand: intel: Read the chip-select line from the correct OF node
Date:   Mon, 24 Oct 2022 13:30:49 +0200
Message-Id: <20221024113058.876066655@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit bfc618fcc3f167ad082053e81e9d664e724c6288 ]

The chip select has to be read from the flash node which is a child node
of the NAND controller.

Fixes: 0b1039f016e8a3 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220702231227.1579176-4-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index e91b879b32bd..3df3f32423f9 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -16,6 +16,7 @@
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/nand.h>
 
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -580,6 +581,7 @@ static int ebu_nand_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ebu_nand_controller *ebu_host;
+	struct device_node *chip_np;
 	struct nand_chip *nand;
 	struct mtd_info *mtd;
 	struct resource *res;
@@ -604,7 +606,12 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	if (IS_ERR(ebu_host->hsnand))
 		return PTR_ERR(ebu_host->hsnand);
 
-	ret = device_property_read_u32(dev, "reg", &cs);
+	chip_np = of_get_next_child(dev->of_node, NULL);
+	if (!chip_np)
+		return dev_err_probe(dev, -EINVAL,
+				     "Could not find child node for the NAND chip\n");
+
+	ret = of_property_read_u32(chip_np, "reg", &cs);
 	if (ret) {
 		dev_err(dev, "failed to get chip select: %d\n", ret);
 		return ret;
@@ -660,7 +667,7 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	writel(ebu_host->cs[cs].addr_sel | EBU_ADDR_MASK(5) | EBU_ADDR_SEL_REGEN,
 	       ebu_host->ebu + EBU_ADDR_SEL(cs));
 
-	nand_set_flash_node(&ebu_host->chip, dev->of_node);
+	nand_set_flash_node(&ebu_host->chip, chip_np);
 
 	mtd = nand_to_mtd(&ebu_host->chip);
 	if (!mtd->name) {
-- 
2.35.1



