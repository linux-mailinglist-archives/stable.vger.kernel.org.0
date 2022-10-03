Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0945F29C0
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiJCHYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiJCHYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:24:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B07C46630;
        Mon,  3 Oct 2022 00:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 170F5B80E68;
        Mon,  3 Oct 2022 07:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8B0C433C1;
        Mon,  3 Oct 2022 07:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781332;
        bh=tb0bQpnUQ+TPZ2/ugxZ8lhm5RCQjTZugfa0mWmPiO8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRrPDU5nYxvY7B6DXKLxf5CKxp3W0lgLYQ4v6Xp6lhiXd0HwpymYzPbVRAdnd9Hqr
         vaijMxUOpEItEPFd19weaiVBzvxUFrEAeCHT/tyA1U/PIrHr485ymO8ddCns0fXSGm
         IdLuQ5S1n7H8ykv2PxSetXfN1FSnxAqTg+egVxPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 056/101] soc: sunxi: sram: Fix probe function ordering issues
Date:   Mon,  3 Oct 2022 09:10:52 +0200
Message-Id: <20221003070725.856379254@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 49fad91a7b8941979c3e9a35f9894ac45bc5d3d6 ]

Errors from debugfs are intended to be non-fatal, and should not prevent
the driver from probing.

Since debugfs file creation is treated as infallible, move it below the
parts of the probe function that can fail. This prevents an error
elsewhere in the probe function from causing the file to leak. Do the
same for the call to of_platform_populate().

Finally, checkpatch suggests an octal literal for the file permissions.

Fixes: 4af34b572a85 ("drivers: soc: sunxi: Introduce SoC driver to map SRAMs")
Fixes: 5828729bebbb ("soc: sunxi: export a regmap for EMAC clock reg on A64")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220815041248.53268-6-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sunxi/sunxi_sram.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index a858a37fcdd4..52d07bed7664 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -332,9 +332,9 @@ static struct regmap_config sunxi_sram_emac_clock_regmap = {
 
 static int __init sunxi_sram_probe(struct platform_device *pdev)
 {
-	struct dentry *d;
 	struct regmap *emac_clock;
 	const struct sunxi_sramc_variant *variant;
+	struct device *dev = &pdev->dev;
 
 	sram_dev = &pdev->dev;
 
@@ -346,13 +346,6 @@ static int __init sunxi_sram_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
-
-	d = debugfs_create_file("sram", S_IRUGO, NULL, NULL,
-				&sunxi_sram_fops);
-	if (!d)
-		return -ENOMEM;
-
 	if (variant->num_emac_clocks > 0) {
 		emac_clock = devm_regmap_init_mmio(&pdev->dev, base,
 						   &sunxi_sram_emac_clock_regmap);
@@ -361,6 +354,10 @@ static int __init sunxi_sram_probe(struct platform_device *pdev)
 			return PTR_ERR(emac_clock);
 	}
 
+	of_platform_populate(dev->of_node, NULL, NULL, dev);
+
+	debugfs_create_file("sram", 0444, NULL, NULL, &sunxi_sram_fops);
+
 	return 0;
 }
 
-- 
2.35.1



