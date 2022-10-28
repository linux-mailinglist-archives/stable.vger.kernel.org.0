Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB9611084
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiJ1MG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiJ1MGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CEC9DDAD
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41F66280A
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B212DC433C1;
        Fri, 28 Oct 2022 12:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958781;
        bh=usumVKRXMPZUsGMJcY0f1cVOhkLxyrcKJp9IFOALwIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCOV0N1RK/iAbhUm5XkMi0onz3pTpTUEhzU5UW2YiTYmecb7RXXOSTLf390/PNHJP
         sreWz2QlrDPis4QPBMcqRpiNnvByVjmgU9yPBYwUwka4X7KZCMz1I/5y/OjWb2EU+Y
         APU/dPEZ74d5M5CZXSqxSE/pxhiTSAezFqgvRxaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/73] dmaengine: mxs-dma: Remove the unused .id_table
Date:   Fri, 28 Oct 2022 14:03:47 +0200
Message-Id: <20221028120234.554386917@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit cc2afb0d4c7cbba6743ed6d9564f0883cab6bae1 ]

The mxs-dma driver is only used by DT platforms and the .id_table
is unused.

Get rid of it to simplify the code.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20201123193051.17285-1-festevam@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 26696d465716 ("dmaengine: mxs: use platform_driver_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mxs-dma.c |   37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -167,29 +167,11 @@ static struct mxs_dma_type mxs_dma_types
 	}
 };
 
-static const struct platform_device_id mxs_dma_ids[] = {
-	{
-		.name = "imx23-dma-apbh",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[0],
-	}, {
-		.name = "imx23-dma-apbx",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[1],
-	}, {
-		.name = "imx28-dma-apbh",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[2],
-	}, {
-		.name = "imx28-dma-apbx",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[3],
-	}, {
-		/* end of list */
-	}
-};
-
 static const struct of_device_id mxs_dma_dt_ids[] = {
-	{ .compatible = "fsl,imx23-dma-apbh", .data = &mxs_dma_ids[0], },
-	{ .compatible = "fsl,imx23-dma-apbx", .data = &mxs_dma_ids[1], },
-	{ .compatible = "fsl,imx28-dma-apbh", .data = &mxs_dma_ids[2], },
-	{ .compatible = "fsl,imx28-dma-apbx", .data = &mxs_dma_ids[3], },
+	{ .compatible = "fsl,imx23-dma-apbh", .data = &mxs_dma_types[0], },
+	{ .compatible = "fsl,imx23-dma-apbx", .data = &mxs_dma_types[1], },
+	{ .compatible = "fsl,imx28-dma-apbh", .data = &mxs_dma_types[2], },
+	{ .compatible = "fsl,imx28-dma-apbx", .data = &mxs_dma_types[3], },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mxs_dma_dt_ids);
@@ -762,8 +744,6 @@ static struct dma_chan *mxs_dma_xlate(st
 static int __init mxs_dma_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	const struct platform_device_id *id_entry;
-	const struct of_device_id *of_id;
 	const struct mxs_dma_type *dma_type;
 	struct mxs_dma_engine *mxs_dma;
 	struct resource *iores;
@@ -779,13 +759,7 @@ static int __init mxs_dma_probe(struct p
 		return ret;
 	}
 
-	of_id = of_match_device(mxs_dma_dt_ids, &pdev->dev);
-	if (of_id)
-		id_entry = of_id->data;
-	else
-		id_entry = platform_get_device_id(pdev);
-
-	dma_type = (struct mxs_dma_type *)id_entry->driver_data;
+	dma_type = (struct mxs_dma_type *)of_device_get_match_data(&pdev->dev);
 	mxs_dma->type = dma_type->type;
 	mxs_dma->dev_id = dma_type->id;
 
@@ -865,7 +839,6 @@ static struct platform_driver mxs_dma_dr
 		.name	= "mxs-dma",
 		.of_match_table = mxs_dma_dt_ids,
 	},
-	.id_table	= mxs_dma_ids,
 };
 
 static int __init mxs_dma_module_init(void)


