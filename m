Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398A25F2B4B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiJCH4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJCHz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:55:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB85A5140A;
        Mon,  3 Oct 2022 00:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8127560FAB;
        Mon,  3 Oct 2022 07:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942FDC433C1;
        Mon,  3 Oct 2022 07:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781776;
        bh=pkiKzZqM6+JbgCqQ2ob2gtDePEoLK5AGKIv58CA9PUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1pD8NYFuprBAI0o9yjzkZ/YoxXBKO5uUTg9L9IeNHaawWZMCLTbnDoSO7I08HiZk
         tw7A1+4WTK1dTWEYF3/vbKq4fPqcKObYQDy72NysaIeT6fUgr8e01El3DtypJTLwV6
         3zemOxONyNqeum8w1nZ0aKmLyBGYCEGDf9azCSX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/52] soc: sunxi: sram: Fix probe function ordering issues
Date:   Mon,  3 Oct 2022 09:11:43 +0200
Message-Id: <20221003070719.812591046@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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
index ba05727b2614..ef1620ea4bdb 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -321,9 +321,9 @@ static struct regmap_config sunxi_sram_emac_clock_regmap = {
 
 static int __init sunxi_sram_probe(struct platform_device *pdev)
 {
-	struct dentry *d;
 	struct regmap *emac_clock;
 	const struct sunxi_sramc_variant *variant;
+	struct device *dev = &pdev->dev;
 
 	sram_dev = &pdev->dev;
 
@@ -335,13 +335,6 @@ static int __init sunxi_sram_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
-
-	d = debugfs_create_file("sram", S_IRUGO, NULL, NULL,
-				&sunxi_sram_fops);
-	if (!d)
-		return -ENOMEM;
-
 	if (variant->has_emac_clock) {
 		emac_clock = devm_regmap_init_mmio(&pdev->dev, base,
 						   &sunxi_sram_emac_clock_regmap);
@@ -350,6 +343,10 @@ static int __init sunxi_sram_probe(struct platform_device *pdev)
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



