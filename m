Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6953A6B4878
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbjCJPCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbjCJPC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:02:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F47E126996
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:55:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B890961A0A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89BFC4339B;
        Fri, 10 Mar 2023 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460045;
        bh=Ub/ZpnZEji3h4XX3RPjqlTWVyKgoc3jMKGjlIua6AHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htIs9CVE/P/o1ps2RoRlBXEGkgJ4iJyY1C4OTv0Gfqjn+XsGLAKBPLdnz2ttm3g7+
         gucTpAcQxQbfG7b/C6TzXESFzII94L78DybK79YkHPDcvxGp8U2o+1I2faknK3kLgE
         m0+hOADF9wqNxQcSBkX1QSVTLnfEqlTs3TJ82Ipo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/529] spi: bcm63xx-hsspi: fix pm_runtime
Date:   Fri, 10 Mar 2023 14:35:47 +0100
Message-Id: <20230310133814.457967159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 216e8e80057a9f0b6366327881acf88eaf9f1fd4 ]

The driver sets auto_runtime_pm to true, but it doesn't call
pm_runtime_enable(), which results in "Failed to power device" when PM support
is enabled.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://lore.kernel.org/r/20210223151851.4110-3-noltari@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 811ff802aaf8 ("spi: bcm63xx-hsspi: Fix multi-bit mode setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index f591a543b1d07..a74345ed0e2ff 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/reset.h>
+#include <linux/pm_runtime.h>
 
 #define HSSPI_GLOBAL_CTRL_REG			0x0
 #define GLOBAL_CTRL_CS_POLARITY_SHIFT		0
@@ -439,13 +440,17 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_put_master;
 
+	pm_runtime_enable(&pdev->dev);
+
 	/* register and we are done */
 	ret = devm_spi_register_master(dev, master);
 	if (ret)
-		goto out_put_master;
+		goto out_pm_disable;
 
 	return 0;
 
+out_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 out_put_master:
 	spi_master_put(master);
 out_disable_pll_clk:
-- 
2.39.2



