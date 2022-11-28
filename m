Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A89E63AF32
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbiK1Rjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiK1RjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:39:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F2412D0D;
        Mon, 28 Nov 2022 09:38:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B855B80E9F;
        Mon, 28 Nov 2022 17:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FA7C433D6;
        Mon, 28 Nov 2022 17:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657114;
        bh=SVNlqFMeW1EbUZbel3/ygwlBs6fe3l3AOdsXJS7vuUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpPyqvubExdv+joUlANHLtO8pg2kdGC7nrqhJIQNWQot9MSY7ux6YyHXYbP+oUkBc
         BhlXW4lf35ws4tDp4kRBg0vfx9r12LqS2Ua3x4mUxaHmN9U5dYCPZ0w/F7ULQzmeld
         SsP7a3/SlaoCAyaFUWeyULL1UfO26U7iFtNYMebqP0+Xt9cvAN9uwZ08vuJKeuc0U2
         fqFEgHga2EraE+RO/4ateXZMcONBQRoFPK2nnPhhA/a5NmdHplgQ8PObGq6x7DhfH7
         6v2mOkW+UiV7tPwp2WSXrFGxYZX7omzVveJbOEz0ODKrq1MEPyRY3BgoFBqD0uKGzK
         +hC163cbtZw3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhichao Liu <zhichao.liu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, matthias.bgg@gmail.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 17/39] spi: mediatek: Fix DEVAPC Violation at KO Remove
Date:   Mon, 28 Nov 2022 12:35:57 -0500
Message-Id: <20221128173642.1441232-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhichao Liu <zhichao.liu@mediatek.com>

[ Upstream commit 0d10e90cee9eb57882b0f7e19fd699033722e226 ]

A DEVAPC violation occurs when removing the module
due to accessing HW registers without base clock.
To fix this bug, the correct method is:
1. Call the runtime resume function to enable the
   clock;
2. Operate the registers to reset the HW;
3. Turn off the clocks and disable the device
   RPM mechanism.

Signed-off-by: Zhichao Liu <zhichao.liu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221110072839.30961-1-zhichao.liu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index cd9dc358d396..a7cc96aeb590 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1268,8 +1268,11 @@ static int mtk_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct mtk_spi *mdata = spi_master_get_devdata(master);
+	int ret;
 
-	pm_runtime_disable(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
+		return ret;
 
 	mtk_spi_reset(mdata);
 
@@ -1278,6 +1281,9 @@ static int mtk_spi_remove(struct platform_device *pdev)
 		clk_unprepare(mdata->spi_hclk);
 	}
 
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
-- 
2.35.1

