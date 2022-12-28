Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81B1658162
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiL1Q2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiL1Q1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:27:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211061CFD6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:23:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BCB56157B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF94C433D2;
        Wed, 28 Dec 2022 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244619;
        bh=JgxFYTenMO74yrkIpVwBc94p+F9fD0CyR7c+sK9K6XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPF35FSyuCGZkLxWKWyFjmrUWRV5WlsOPR8npJ4LeSBELulWcuyVF6dX2rPJsz8eR
         3EWkbeciUCmobbYswLmFQhP4lDwEmBfmsHw4zRwmNKwTu3Eem8Vtke+D5P/qSF2Vix
         BkllUCKnDtq7zf8ERpdfrcolZQ2z9jBe4d2AzHng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Sicelo Mhlongo <absicsz@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0704/1146] usb: musb: omap2430: Fix probe regression for missing resources
Date:   Wed, 28 Dec 2022 15:37:23 +0100
Message-Id: <20221228144349.268642447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit ffbe2feac59b37c8dc536727552b4f375e1b9aec ]

Probe for omap2430 glue layer is now broken for interrupt resources in
all cases.

Commit  239071064732 ("partially Revert "usb: musb: Set the DT node on the
child device"") broke probing for SoCs using ti-sysc interconnect target
module as the dt node is not found.

Commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from
DT core") caused omap3 to fail with error "-ENXIO: IRQ mc not found" as
the IRQ resources are no longer automatically populated from devicetree.

Let's fix the issues by calling device_set_of_node_from_dev() only if the
SoC has been updated to probe with ti-sysc. And for legacy SoCs, let's
populate the resources manually as needed.

Note that once we have updated the SoCs to probe with proper devicetree
data in all cases, this is no longer needed. But doing that requires
patching both devicetree and SoC code, so let's fix the probe issues first.

Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
Fixes: 239071064732 ("partially Revert "usb: musb: Set the DT node on the child device"")
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Reported-by: Sicelo Mhlongo <absicsz@gmail.com>
Tested-by: Sicelo Mhlongo <absicsz@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221118102532.34458-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/omap2430.c | 54 +++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index f571a65ae6ee..476f55d1fec3 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
@@ -310,6 +311,7 @@ static int omap2430_probe(struct platform_device *pdev)
 	struct device_node		*control_node;
 	struct platform_device		*control_pdev;
 	int				ret = -ENOMEM, val;
+	bool				populate_irqs = false;
 
 	if (!np)
 		return -ENODEV;
@@ -328,6 +330,18 @@ static int omap2430_probe(struct platform_device *pdev)
 	musb->dev.dma_mask		= &omap2430_dmamask;
 	musb->dev.coherent_dma_mask	= omap2430_dmamask;
 
+	/*
+	 * Legacy SoCs using omap_device get confused if node is moved
+	 * because of interconnect properties mixed into the node.
+	 */
+	if (of_get_property(np, "ti,hwmods", NULL)) {
+		dev_warn(&pdev->dev, "please update to probe with ti-sysc\n");
+		populate_irqs = true;
+	} else {
+		device_set_of_node_from_dev(&musb->dev, &pdev->dev);
+	}
+	of_node_put(np);
+
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
 	glue->status			= MUSB_UNKNOWN;
@@ -389,6 +403,46 @@ static int omap2430_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
+	if (populate_irqs) {
+		struct resource musb_res[3];
+		struct resource *res;
+		int i = 0;
+
+		memset(musb_res, 0, sizeof(*musb_res) * ARRAY_SIZE(musb_res));
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res)
+			goto err2;
+
+		musb_res[i].start = res->start;
+		musb_res[i].end = res->end;
+		musb_res[i].flags = res->flags;
+		musb_res[i].name = res->name;
+		i++;
+
+		ret = of_irq_get_byname(np, "mc");
+		if (ret > 0) {
+			musb_res[i].start = ret;
+			musb_res[i].flags = IORESOURCE_IRQ;
+			musb_res[i].name = "mc";
+			i++;
+		}
+
+		ret = of_irq_get_byname(np, "dma");
+		if (ret > 0) {
+			musb_res[i].start = ret;
+			musb_res[i].flags = IORESOURCE_IRQ;
+			musb_res[i].name = "dma";
+			i++;
+		}
+
+		ret = platform_device_add_resources(musb, musb_res, i);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to add IRQ resources\n");
+			goto err2;
+		}
+	}
+
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-- 
2.35.1



