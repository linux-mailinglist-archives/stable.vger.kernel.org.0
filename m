Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81597191B2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfEISwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbfEISwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F5812182B;
        Thu,  9 May 2019 18:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427933;
        bh=470NZB2kKHQn1HDTjfZigknZIavOuUfXqk1JNoQXSOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BJkaj/293e4aflYNnc8djbxbgVUzHB4E6uqPOTym0LkcCoMa2jPZb9IS3v7X0qBq
         u9KlPbZpliVE3gc4IOhc/84HUImzgg8x/sAWpWMXa7w5RDM5P//bXNbkIpAwm3tECg
         dlp7y8I4xEoikKIrt7DmryeiYrduIyV9uU3gXyjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wangyan Wang <wangyan.wang@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 58/95] drm/mediatek: remove flag CLK_SET_RATE_PARENT for MT2701 hdmi phy
Date:   Thu,  9 May 2019 20:42:15 +0200
Message-Id: <20190509181313.556196468@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 827abdd024207146822f66ba3ba74867135866b9 ]

This is the first step to make MT2701 hdmi stable.
The parent rate of hdmi phy had set by DPI driver.
We should not set or change the parent rate of MT2701 hdmi phy,
as a result we should remove the flags of "CLK_SET_RATE_PARENT"
from the clock of MT2701 hdmi phy.

Signed-off-by: Wangyan Wang <wangyan.wang@mediatek.com>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_phy.c        | 13 +++++--------
 drivers/gpu/drm/mediatek/mtk_hdmi_phy.h        |  1 +
 drivers/gpu/drm/mediatek/mtk_mt2701_hdmi_phy.c |  1 +
 drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c |  1 +
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c b/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c
index efc400ebbb90b..08b029772c5a5 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_phy.c
@@ -102,13 +102,11 @@ mtk_hdmi_phy_dev_get_ops(const struct mtk_hdmi_phy *hdmi_phy)
 		return NULL;
 }
 
-static void mtk_hdmi_phy_clk_get_ops(struct mtk_hdmi_phy *hdmi_phy,
-				     const struct clk_ops **ops)
+static void mtk_hdmi_phy_clk_get_data(struct mtk_hdmi_phy *hdmi_phy,
+				      struct clk_init_data *clk_init)
 {
-	if (hdmi_phy && hdmi_phy->conf && hdmi_phy->conf->hdmi_phy_clk_ops)
-		*ops = hdmi_phy->conf->hdmi_phy_clk_ops;
-	else
-		dev_err(hdmi_phy->dev, "Failed to get clk ops of phy\n");
+	clk_init->flags = hdmi_phy->conf->flags;
+	clk_init->ops = hdmi_phy->conf->hdmi_phy_clk_ops;
 }
 
 static int mtk_hdmi_phy_probe(struct platform_device *pdev)
@@ -121,7 +119,6 @@ static int mtk_hdmi_phy_probe(struct platform_device *pdev)
 	struct clk_init_data clk_init = {
 		.num_parents = 1,
 		.parent_names = (const char * const *)&ref_clk_name,
-		.flags = CLK_SET_RATE_PARENT | CLK_SET_RATE_GATE,
 	};
 
 	struct phy *phy;
@@ -159,7 +156,7 @@ static int mtk_hdmi_phy_probe(struct platform_device *pdev)
 	hdmi_phy->dev = dev;
 	hdmi_phy->conf =
 		(struct mtk_hdmi_phy_conf *)of_device_get_match_data(dev);
-	mtk_hdmi_phy_clk_get_ops(hdmi_phy, &clk_init.ops);
+	mtk_hdmi_phy_clk_get_data(hdmi_phy, &clk_init);
 	hdmi_phy->pll_hw.init = &clk_init;
 	hdmi_phy->pll = devm_clk_register(dev, &hdmi_phy->pll_hw);
 	if (IS_ERR(hdmi_phy->pll)) {
diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_phy.h b/drivers/gpu/drm/mediatek/mtk_hdmi_phy.h
index 71430691ffe43..d28b8d5ed2b44 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_phy.h
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_phy.h
@@ -21,6 +21,7 @@ struct mtk_hdmi_phy;
 
 struct mtk_hdmi_phy_conf {
 	bool tz_disabled;
+	unsigned long flags;
 	const struct clk_ops *hdmi_phy_clk_ops;
 	void (*hdmi_phy_enable_tmds)(struct mtk_hdmi_phy *hdmi_phy);
 	void (*hdmi_phy_disable_tmds)(struct mtk_hdmi_phy *hdmi_phy);
diff --git a/drivers/gpu/drm/mediatek/mtk_mt2701_hdmi_phy.c b/drivers/gpu/drm/mediatek/mtk_mt2701_hdmi_phy.c
index feb6a7ed63d16..31f3175f032bc 100644
--- a/drivers/gpu/drm/mediatek/mtk_mt2701_hdmi_phy.c
+++ b/drivers/gpu/drm/mediatek/mtk_mt2701_hdmi_phy.c
@@ -232,6 +232,7 @@ static void mtk_hdmi_phy_disable_tmds(struct mtk_hdmi_phy *hdmi_phy)
 
 struct mtk_hdmi_phy_conf mtk_hdmi_phy_2701_conf = {
 	.tz_disabled = true,
+	.flags = CLK_SET_RATE_GATE,
 	.hdmi_phy_clk_ops = &mtk_hdmi_phy_pll_ops,
 	.hdmi_phy_enable_tmds = mtk_hdmi_phy_enable_tmds,
 	.hdmi_phy_disable_tmds = mtk_hdmi_phy_disable_tmds,
diff --git a/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c b/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c
index 83662a2084916..37f9503d76433 100644
--- a/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c
+++ b/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c
@@ -317,6 +317,7 @@ static void mtk_hdmi_phy_disable_tmds(struct mtk_hdmi_phy *hdmi_phy)
 }
 
 struct mtk_hdmi_phy_conf mtk_hdmi_phy_8173_conf = {
+	.flags = CLK_SET_RATE_PARENT | CLK_SET_RATE_GATE,
 	.hdmi_phy_clk_ops = &mtk_hdmi_phy_pll_ops,
 	.hdmi_phy_enable_tmds = mtk_hdmi_phy_enable_tmds,
 	.hdmi_phy_disable_tmds = mtk_hdmi_phy_disable_tmds,
-- 
2.20.1



