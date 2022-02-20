Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFBB4BCF36
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 15:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiBTO6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 09:58:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239167AbiBTO6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 09:58:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE26A1D0DC
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 06:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A0C9611C8
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 14:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625DDC340E8;
        Sun, 20 Feb 2022 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645369103;
        bh=vuq8jgpiJTvytfN4VBKiuRd0vdoDKiJdewIRFlJmezM=;
        h=Subject:To:Cc:From:Date:From;
        b=aB9u+nFcQxhajIcugHqDWdPyZHXMekKkq3JMcuEjAHyZ5EFtLiBisnS7892XY0f4R
         ULBuqarZX6Y+mwYGxOulTjf/iU3M4fIpMApDs1DvWlpBn8GEt+NO6jIws3nHr2n7yN
         TylQPxfweD1rMVUiXRorgI3UmN5auyhUaw6JHljE=
Subject: FAILED: patch "[PATCH] mtd: rawnand: qcom: Fix clock sequencing in" failed to apply to 4.14-stable tree
To:     bryan.odonoghue@linaro.org, mani@kernel.org,
        miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 20 Feb 2022 15:58:12 +0100
Message-ID: <16453690924156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c23b3f965bc9ee696bf2ed4bdc54d339dd9a455 Mon Sep 17 00:00:00 2001
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Date: Mon, 3 Jan 2022 03:03:15 +0000
Subject: [PATCH] mtd: rawnand: qcom: Fix clock sequencing in
 qcom_nandc_probe()

Interacting with a NAND chip on an IPQ6018 I found that the qcomsmem NAND
partition parser was returning -EPROBE_DEFER waiting for the main smem
driver to load.

This caused the board to reset. Playing about with the probe() function
shows that the problem lies in the core clock being switched off before the
nandc_unalloc() routine has completed.

If we look at how qcom_nandc_remove() tears down allocated resources we see
the expected order is

qcom_nandc_unalloc(nandc);

clk_disable_unprepare(nandc->aon_clk);
clk_disable_unprepare(nandc->core_clk);

dma_unmap_resource(&pdev->dev, nandc->base_dma, resource_size(res),
		   DMA_BIDIRECTIONAL, 0);

Tweaking probe() to both bring up and tear-down in that order removes the
reset if we end up deferring elsewhere.

Fixes: c76b78d8ec05 ("mtd: nand: Qualcomm NAND controller driver")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220103030316.58301-2-bryan.odonoghue@linaro.org

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 7c6efa3b6255..1a77542c6d67 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2,7 +2,6 @@
 /*
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
  */
-
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
@@ -3073,10 +3072,6 @@ static int qcom_nandc_probe(struct platform_device *pdev)
 	if (dma_mapping_error(dev, nandc->base_dma))
 		return -ENXIO;
 
-	ret = qcom_nandc_alloc(nandc);
-	if (ret)
-		goto err_nandc_alloc;
-
 	ret = clk_prepare_enable(nandc->core_clk);
 	if (ret)
 		goto err_core_clk;
@@ -3085,6 +3080,10 @@ static int qcom_nandc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_aon_clk;
 
+	ret = qcom_nandc_alloc(nandc);
+	if (ret)
+		goto err_nandc_alloc;
+
 	ret = qcom_nandc_setup(nandc);
 	if (ret)
 		goto err_setup;
@@ -3096,15 +3095,14 @@ static int qcom_nandc_probe(struct platform_device *pdev)
 	return 0;
 
 err_setup:
+	qcom_nandc_unalloc(nandc);
+err_nandc_alloc:
 	clk_disable_unprepare(nandc->aon_clk);
 err_aon_clk:
 	clk_disable_unprepare(nandc->core_clk);
 err_core_clk:
-	qcom_nandc_unalloc(nandc);
-err_nandc_alloc:
 	dma_unmap_resource(dev, res->start, resource_size(res),
 			   DMA_BIDIRECTIONAL, 0);
-
 	return ret;
 }
 

