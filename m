Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87132E419E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438534AbgL1PJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438515AbgL1OHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAD1E207B6;
        Mon, 28 Dec 2020 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164424;
        bh=3hOfFZ7oqQW1o/4GO2YXfX/2Tj0BUj8IVjRF20Rsr7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlunDWrUUpRn5smtVlptdCcUOAlMjJPAfyXNC/nstzmbRAF8iIchq2TbYF+4VS3BK
         vkxOeDO+9H3/GDA7JdzgYNwkmyIjdoe8+W8kR8u1+gNSdqnJGmZckmgV6afxgvvteM
         AHlU6e57hLurbpxkg7N3/gwvNH3y3ElVminrElow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/717] drm/meson: dw-hdmi: Disable clocks on driver teardown
Date:   Mon, 28 Dec 2020 13:42:52 +0100
Message-Id: <20201228125029.298765527@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 1dfeea904550c11eccf3fd5f6256e4b0f0208dfe ]

The HDMI driver request clocks early, but never disable them, leaving
the clocks on even when the driver is removed.

Fix it by slightly refactoring the clock code, and register a devm
action that will eventually disable/unprepare the enabled clocks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201120094205.525228-2-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_dw_hdmi.c | 43 ++++++++++++++++++---------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_dw_hdmi.c b/drivers/gpu/drm/meson/meson_dw_hdmi.c
index 7f8eea4941472..29623b309cb11 100644
--- a/drivers/gpu/drm/meson/meson_dw_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_dw_hdmi.c
@@ -145,8 +145,6 @@ struct meson_dw_hdmi {
 	struct reset_control *hdmitx_apb;
 	struct reset_control *hdmitx_ctrl;
 	struct reset_control *hdmitx_phy;
-	struct clk *hdmi_pclk;
-	struct clk *venci_clk;
 	struct regulator *hdmi_supply;
 	u32 irq_stat;
 	struct dw_hdmi *hdmi;
@@ -946,6 +944,29 @@ static void meson_disable_regulator(void *data)
 	regulator_disable(data);
 }
 
+static void meson_disable_clk(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
+static int meson_enable_clk(struct device *dev, char *name)
+{
+	struct clk *clk;
+	int ret;
+
+	clk = devm_clk_get(dev, name);
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Unable to get %s pclk\n", name);
+		return PTR_ERR(clk);
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (!ret)
+		ret = devm_add_action_or_reset(dev, meson_disable_clk, clk);
+
+	return ret;
+}
+
 static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 				void *data)
 {
@@ -1026,19 +1047,13 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 	if (IS_ERR(meson_dw_hdmi->hdmitx))
 		return PTR_ERR(meson_dw_hdmi->hdmitx);
 
-	meson_dw_hdmi->hdmi_pclk = devm_clk_get(dev, "isfr");
-	if (IS_ERR(meson_dw_hdmi->hdmi_pclk)) {
-		dev_err(dev, "Unable to get HDMI pclk\n");
-		return PTR_ERR(meson_dw_hdmi->hdmi_pclk);
-	}
-	clk_prepare_enable(meson_dw_hdmi->hdmi_pclk);
+	ret = meson_enable_clk(dev, "isfr");
+	if (ret)
+		return ret;
 
-	meson_dw_hdmi->venci_clk = devm_clk_get(dev, "venci");
-	if (IS_ERR(meson_dw_hdmi->venci_clk)) {
-		dev_err(dev, "Unable to get venci clk\n");
-		return PTR_ERR(meson_dw_hdmi->venci_clk);
-	}
-	clk_prepare_enable(meson_dw_hdmi->venci_clk);
+	ret = meson_enable_clk(dev, "venci");
+	if (ret)
+		return ret;
 
 	dw_plat_data->regm = devm_regmap_init(dev, NULL, meson_dw_hdmi,
 					      &meson_dw_hdmi_regmap_config);
-- 
2.27.0



