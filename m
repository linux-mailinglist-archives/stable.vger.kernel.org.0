Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098316B4296
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCJOEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjCJOEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:04:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB8915171
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:04:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55E4BB822B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98F5C4339C;
        Fri, 10 Mar 2023 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457069;
        bh=9R1HBx8meFWbKpE7KPKXA+5E9RUOnDSCLEHUISCKaxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtjLpkV+u5Sjbv7uBGQhD03dZGRwwKO43mUrEtkhf9kbkEF1qeaULtpAU4HDqQsii
         u7M8Y3aesdDmug58wiX2kQvOGjj7alW8hFFM7GBLYSDqtRgS7I0U9NUfm74gr3lw3h
         k3HXIe1IG1/MbGETifvch8w1gHnTdrzUnNjgEbmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/200] memory: renesas-rpc-if: Move resource acquisition to .probe()
Date:   Fri, 10 Mar 2023 14:36:57 +0100
Message-Id: <20230310133717.367047969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 8b3580df15f53045fda3ffae53f74575c96aa77e ]

While the acquired resources are tied to the lifetime of the RPC-IF core
device (through the use of managed resource functions), the actual
resource acquisition is triggered from the HyperBus and SPI child
drivers.  Due to this mismatch, unbinding and rebinding the child
drivers manually fails with -EBUSY:

    # echo rpc-if-hyperflash > /sys/bus/platform/drivers/rpc-if-hyperflash/unbind
    # echo rpc-if-hyperflash > /sys/bus/platform/drivers/rpc-if-hyperflash/bind
    rpc-if ee200000.spi: can't request region for resource [mem 0xee200000-0xee2001ff]
    rpc-if-hyperflash: probe of rpc-if-hyperflash failed with error -16

The same is true for rpc-if-spi.

Fix this by moving all resource acquisition to the core driver's probe
routine.

Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/c1012ef1de799e08a70817ab7313794e2d8d7bfb.1669213027.git.geert+renesas@glider.be
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 49 ++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 309c0b59f3a2f..7343dbb79c9f7 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -276,32 +276,7 @@ static const struct regmap_config rpcif_regmap_config = {
 
 int rpcif_sw_init(struct rpcif *rpcif, struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
 	struct rpcif_priv *rpc = dev_get_drvdata(dev);
-	struct resource *res;
-
-	rpc->base = devm_platform_ioremap_resource_byname(pdev, "regs");
-	if (IS_ERR(rpc->base))
-		return PTR_ERR(rpc->base);
-
-	rpc->regmap = devm_regmap_init(&pdev->dev, NULL, rpc, &rpcif_regmap_config);
-	if (IS_ERR(rpc->regmap)) {
-		dev_err(&pdev->dev,
-			"failed to init regmap for rpcif, error %ld\n",
-			PTR_ERR(rpc->regmap));
-		return	PTR_ERR(rpc->regmap);
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
-	rpc->dirmap = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(rpc->dirmap))
-		return PTR_ERR(rpc->dirmap);
-	rpc->size = resource_size(res);
-
-	rpc->type = (uintptr_t)of_device_get_match_data(dev);
-	rpc->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-	if (IS_ERR(rpc->rstc))
-		return PTR_ERR(rpc->rstc);
 
 	rpcif->dev = dev;
 	rpcif->dirmap = rpc->dirmap;
@@ -701,9 +676,11 @@ EXPORT_SYMBOL(rpcif_dirmap_read);
 
 static int rpcif_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct platform_device *vdev;
 	struct device_node *flash;
 	struct rpcif_priv *rpc;
+	struct resource *res;
 	const char *name;
 	int ret;
 
@@ -728,6 +705,28 @@ static int rpcif_probe(struct platform_device *pdev)
 	if (!rpc)
 		return -ENOMEM;
 
+	rpc->base = devm_platform_ioremap_resource_byname(pdev, "regs");
+	if (IS_ERR(rpc->base))
+		return PTR_ERR(rpc->base);
+
+	rpc->regmap = devm_regmap_init(dev, NULL, rpc, &rpcif_regmap_config);
+	if (IS_ERR(rpc->regmap)) {
+		dev_err(dev, "failed to init regmap for rpcif, error %ld\n",
+			PTR_ERR(rpc->regmap));
+		return	PTR_ERR(rpc->regmap);
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
+	rpc->dirmap = devm_ioremap_resource(dev, res);
+	if (IS_ERR(rpc->dirmap))
+		return PTR_ERR(rpc->dirmap);
+	rpc->size = resource_size(res);
+
+	rpc->type = (uintptr_t)of_device_get_match_data(dev);
+	rpc->rstc = devm_reset_control_get_exclusive(dev, NULL);
+	if (IS_ERR(rpc->rstc))
+		return PTR_ERR(rpc->rstc);
+
 	vdev = platform_device_alloc(name, pdev->id);
 	if (!vdev)
 		return -ENOMEM;
-- 
2.39.2



