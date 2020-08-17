Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A2F246F48
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389339AbgHQRov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388792AbgHQQOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:14:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A61920578;
        Mon, 17 Aug 2020 16:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680872;
        bh=5KGiXZqA0KWzec0awu2qfq/1IAew9sXfSH80X8CoOmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCDg7PbMACvPDIRHX95LklEsNV+DNEy6a/h1AUxoM28YGs7W8eN6BTqEeIXhYdGTF
         bFXFVhDqqZO/etub3+nzPJnuzgmwjoHA9rMILN4pPMIxj5o8YDjc7a9m0nFhz6lcvo
         0vwYqUcW/iOFG2mQ347bYntIyFayhlL0a8UTTs8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/168] drm/imx: tve: fix regulator_disable error path
Date:   Mon, 17 Aug 2020 17:17:02 +0200
Message-Id: <20200817143738.256178488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 7bb58b987fee26da2a1665c01033022624986b7c ]

Add missing regulator_disable() as devm_action to avoid dedicated
unbind() callback and fix the missing error handling.

Fixes: fcbc51e54d2a ("staging: drm/imx: Add support for Television Encoder (TVEv2)")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/imx-tve.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index cffd3310240e5..c19c1dfbfcdc4 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -498,6 +498,13 @@ static int imx_tve_register(struct drm_device *drm, struct imx_tve *tve)
 	return 0;
 }
 
+static void imx_tve_disable_regulator(void *data)
+{
+	struct imx_tve *tve = data;
+
+	regulator_disable(tve->dac_reg);
+}
+
 static bool imx_tve_readable_reg(struct device *dev, unsigned int reg)
 {
 	return (reg % 4 == 0) && (reg <= 0xdc);
@@ -622,6 +629,9 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 		ret = regulator_enable(tve->dac_reg);
 		if (ret)
 			return ret;
+		ret = devm_add_action_or_reset(dev, imx_tve_disable_regulator, tve);
+		if (ret)
+			return ret;
 	}
 
 	tve->clk = devm_clk_get(dev, "tve");
@@ -668,18 +678,8 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 }
 
-static void imx_tve_unbind(struct device *dev, struct device *master,
-	void *data)
-{
-	struct imx_tve *tve = dev_get_drvdata(dev);
-
-	if (!IS_ERR(tve->dac_reg))
-		regulator_disable(tve->dac_reg);
-}
-
 static const struct component_ops imx_tve_ops = {
 	.bind	= imx_tve_bind,
-	.unbind	= imx_tve_unbind,
 };
 
 static int imx_tve_probe(struct platform_device *pdev)
-- 
2.25.1



