Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0124BE923
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346992AbiBUJDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347434AbiBUJBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:01:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD09310A8;
        Mon, 21 Feb 2022 00:56:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C539B80EB0;
        Mon, 21 Feb 2022 08:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAAFC340EB;
        Mon, 21 Feb 2022 08:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433783;
        bh=Wy4mJoN20U98Cm52ZyFWsaPcCLt5lNHiuQSa3YpeI+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeBi8rTAcGgMhgu40tSPjSZl20hp5PVonKvJFuZurXaMQHOuzMbfJKLPTKfWwGG5u
         +jKytDCVB3naVbr8fFbkdvvalqov2d489vljgpENtmADj3dC/YFZ3Bz28Mz/izQtDu
         5Q/Jo4mVcQxqQP+h6vD6iYvlujgsJZnaCLwpFE9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 40/58] mtd: rawnand: qcom: Fix clock sequencing in qcom_nandc_probe()
Date:   Mon, 21 Feb 2022 09:49:33 +0100
Message-Id: <20220221084913.172673927@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 5c23b3f965bc9ee696bf2ed4bdc54d339dd9a455 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -10,7 +10,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
@@ -2959,10 +2958,6 @@ static int qcom_nandc_probe(struct platf
 	if (!nandc->base_dma)
 		return -ENXIO;
 
-	ret = qcom_nandc_alloc(nandc);
-	if (ret)
-		goto err_nandc_alloc;
-
 	ret = clk_prepare_enable(nandc->core_clk);
 	if (ret)
 		goto err_core_clk;
@@ -2971,6 +2966,10 @@ static int qcom_nandc_probe(struct platf
 	if (ret)
 		goto err_aon_clk;
 
+	ret = qcom_nandc_alloc(nandc);
+	if (ret)
+		goto err_nandc_alloc;
+
 	ret = qcom_nandc_setup(nandc);
 	if (ret)
 		goto err_setup;
@@ -2982,15 +2981,14 @@ static int qcom_nandc_probe(struct platf
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
 


