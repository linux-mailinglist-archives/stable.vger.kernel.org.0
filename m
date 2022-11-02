Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9C2615844
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiKBCsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiKBCsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129E2E8E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85318601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6BEC433D7;
        Wed,  2 Nov 2022 02:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357301;
        bh=hkhbXcCo2X15dwth/wZlV+Ef61jpj0QmUAa1PqGlrJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWRvstMn1wmgnS9+GnjDj59ZO1kdijdIT0/L8a/LW4Ki/gjA5EO/kCtBu612YEPwM
         DjlUvp+cz7XCpouop4xHviXgQPQ4kt/8YC6femVfUzEx/JZDWjv3iQRlfaJbjVG2oS
         tGZvUKjq03Exy9qI4/EA4U4l8cz6dm5dcjOE4zg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 146/240] mtd: rawnand: intel: Use devm_platform_ioremap_resource_byname()
Date:   Wed,  2 Nov 2022 03:32:01 +0100
Message-Id: <20221102022114.678983484@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 7471a53ddce54cee9b7a340dc930eb35b02c9eed ]

Switch from open-coded platform_get_resource_byname() and
devm_ioremap_resource() to devm_platform_ioremap_resource_byname() where
possible to simplify the code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220702231227.1579176-9-martin.blumenstingl@googlemail.com
Stable-dep-of: 1f3b494d1fc1 ("mtd: rawnand: intel: Add missing of_node_put() in ebu_nand_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index 8c78a05099bf..bd821e435329 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -595,13 +595,11 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ebu_host->dev = dev;
 	nand_controller_init(&ebu_host->controller);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ebunand");
-	ebu_host->ebu = devm_ioremap_resource(&pdev->dev, res);
+	ebu_host->ebu = devm_platform_ioremap_resource_byname(pdev, "ebunand");
 	if (IS_ERR(ebu_host->ebu))
 		return PTR_ERR(ebu_host->ebu);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hsnand");
-	ebu_host->hsnand = devm_ioremap_resource(&pdev->dev, res);
+	ebu_host->hsnand = devm_platform_ioremap_resource_byname(pdev, "hsnand");
 	if (IS_ERR(ebu_host->hsnand))
 		return PTR_ERR(ebu_host->hsnand);
 
@@ -623,8 +621,8 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ebu_host->cs_num = cs;
 
 	resname = devm_kasprintf(dev, GFP_KERNEL, "nand_cs%d", cs);
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resname);
-	ebu_host->cs[cs].chipaddr = devm_ioremap_resource(dev, res);
+	ebu_host->cs[cs].chipaddr = devm_platform_ioremap_resource_byname(pdev,
+									  resname);
 	if (IS_ERR(ebu_host->cs[cs].chipaddr))
 		return PTR_ERR(ebu_host->cs[cs].chipaddr);
 
-- 
2.35.1



