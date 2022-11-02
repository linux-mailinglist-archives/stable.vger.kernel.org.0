Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B8A615913
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKBDE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiKBDED (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:04:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509F0233A8
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E521B8206F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3BDC433C1;
        Wed,  2 Nov 2022 03:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358238;
        bh=r7vgTSGzxfVritWX59r7DBJhWBYEb2v6phspvGV/8Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Znff43+0ci8/GsM2coOOKx2/kwHSK/Xxvo2e4e1Wqcyu+j3oQG7rJGNQPq+ymCfio
         1EpZLQZ4O1hJ/7qScVVY+VXGtbRdyQFmIy9B8DWxavMsB3E/ce6VfMsFDeR7+uXLfQ
         6DFrxQvtGQ8XSyirjIIM0iG+LiP7qSMzWrD3dfhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/132] mtd: rawnand: intel: Add missing of_node_put() in ebu_nand_probe()
Date:   Wed,  2 Nov 2022 03:32:50 +0100
Message-Id: <20221102022101.287078231@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1f3b494d1fc18ebb37aaa47107e9b84bf5b54ff7 ]

The 'chip_np' returned by of_get_next_child() with refcount decremented,
of_node_put() need be called in error path to decrease the refcount.

Fixes: bfc618fcc3f1 ("mtd: rawnand: intel: Read the chip-select line from the correct OF node")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220924131010.957117-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index 056835fd4562..53071e791e17 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -614,11 +614,12 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ret = of_property_read_u32(chip_np, "reg", &cs);
 	if (ret) {
 		dev_err(dev, "failed to get chip select: %d\n", ret);
-		return ret;
+		goto err_of_node_put;
 	}
 	if (cs >= MAX_CS) {
 		dev_err(dev, "got invalid chip select: %d\n", cs);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_of_node_put;
 	}
 
 	ebu_host->cs_num = cs;
@@ -627,18 +628,20 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resname);
 	ebu_host->cs[cs].chipaddr = devm_ioremap_resource(dev, res);
 	if (IS_ERR(ebu_host->cs[cs].chipaddr))
-		return PTR_ERR(ebu_host->cs[cs].chipaddr);
+		goto err_of_node_put;
 	ebu_host->cs[cs].nand_pa = res->start;
 
 	ebu_host->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(ebu_host->clk))
-		return dev_err_probe(dev, PTR_ERR(ebu_host->clk),
-				     "failed to get clock\n");
+	if (IS_ERR(ebu_host->clk)) {
+		ret = dev_err_probe(dev, PTR_ERR(ebu_host->clk),
+				    "failed to get clock\n");
+		goto err_of_node_put;
+	}
 
 	ret = clk_prepare_enable(ebu_host->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clock: %d\n", ret);
-		return ret;
+		goto err_of_node_put;
 	}
 	ebu_host->clk_rate = clk_get_rate(ebu_host->clk);
 
@@ -703,6 +706,8 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ebu_dma_cleanup(ebu_host);
 err_disable_unprepare_clk:
 	clk_disable_unprepare(ebu_host->clk);
+err_of_node_put:
+	of_node_put(chip_np);
 
 	return ret;
 }
-- 
2.35.1



