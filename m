Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859FF64A07C
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiLLNZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiLLNZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:25:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A53513E9F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:25:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE32E6106D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2808C433D2;
        Mon, 12 Dec 2022 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851516;
        bh=XYArURAkXAvAkbmm+Cm1Z/1xfusRTaI91j3+d8JHuUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWC/XYcb4B+mapIOBmgziFlkdOvoERmLkvKIaM/4UbYfKRalLJJNYpk6E0TinEpi0
         4vIMq66WYov8TliFmBKKYwpRo1cAHxH3fV5iahfl/PgecJGfKNi4lkK2R6I5Yeow8s
         89q3C19qZlWQGRQBCa5OFHXbPIQtH2mfzwkB8DXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhichao Liu <zhichao.liu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/123] spi: mediatek: Fix DEVAPC Violation at KO Remove
Date:   Mon, 12 Dec 2022 14:16:20 +0100
Message-Id: <20221212130927.465484798@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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
index 2ca19b01948a..49acba1dea1e 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -912,14 +912,20 @@ static int mtk_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct mtk_spi *mdata = spi_master_get_devdata(master);
+	int ret;
 
-	pm_runtime_disable(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
+		return ret;
 
 	mtk_spi_reset(mdata);
 
 	if (mdata->dev_comp->no_need_unprepare)
 		clk_unprepare(mdata->spi_clk);
 
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
-- 
2.35.1



