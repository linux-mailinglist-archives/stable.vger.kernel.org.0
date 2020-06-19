Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E12201452
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391604AbgFSQIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391593AbgFSPHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:07:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB9221852;
        Fri, 19 Jun 2020 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579253;
        bh=CbDnseCi3WYnIk/nKUsBden8JvPliQjGqjORSKArbAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gosf0DMel8ixizgMQKNlGb1mWBMHJ+gme+F9Wl+vMlQxQ82/FljMou5rO89QwM6EA
         VVg4mzoRsLQjfuKYJCvvRFSz6HTb6A8qGSfqgRi0eS2WoBMe+C3/520eFIX+22gcdo
         6Tse9ylOEr6QuzUOqn9W04XZ4HyytkeGTW94W6iU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jitao Shi <jitao.shi@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/261] drm/mediatek: set dpi pin mode to gpio low to avoid leakage current
Date:   Fri, 19 Jun 2020 16:31:17 +0200
Message-Id: <20200619141653.075978252@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jitao Shi <jitao.shi@mediatek.com>

[ Upstream commit 6bd4763fd532cff43f9b15704f324c45a9806f53 ]

Config dpi pins mode to output and pull low when dpi is disabled.
Aovid leakage current from some dpi pins (Hsync Vsync DE ... ).

Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 31 ++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index be6d95c5ff25..48de07e9059e 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -10,7 +10,9 @@
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_gpio.h>
 #include <linux/of_graph.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>
 
@@ -73,6 +75,9 @@ struct mtk_dpi {
 	enum mtk_dpi_out_yc_map yc_map;
 	enum mtk_dpi_out_bit_num bit_num;
 	enum mtk_dpi_out_channel_swap channel_swap;
+	struct pinctrl *pinctrl;
+	struct pinctrl_state *pins_gpio;
+	struct pinctrl_state *pins_dpi;
 	int refcount;
 };
 
@@ -378,6 +383,9 @@ static void mtk_dpi_power_off(struct mtk_dpi *dpi)
 	if (--dpi->refcount != 0)
 		return;
 
+	if (dpi->pinctrl && dpi->pins_gpio)
+		pinctrl_select_state(dpi->pinctrl, dpi->pins_gpio);
+
 	mtk_dpi_disable(dpi);
 	clk_disable_unprepare(dpi->pixel_clk);
 	clk_disable_unprepare(dpi->engine_clk);
@@ -402,6 +410,9 @@ static int mtk_dpi_power_on(struct mtk_dpi *dpi)
 		goto err_pixel;
 	}
 
+	if (dpi->pinctrl && dpi->pins_dpi)
+		pinctrl_select_state(dpi->pinctrl, dpi->pins_dpi);
+
 	mtk_dpi_enable(dpi);
 	return 0;
 
@@ -689,6 +700,26 @@ static int mtk_dpi_probe(struct platform_device *pdev)
 	dpi->dev = dev;
 	dpi->conf = (struct mtk_dpi_conf *)of_device_get_match_data(dev);
 
+	dpi->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (IS_ERR(dpi->pinctrl)) {
+		dpi->pinctrl = NULL;
+		dev_dbg(&pdev->dev, "Cannot find pinctrl!\n");
+	}
+	if (dpi->pinctrl) {
+		dpi->pins_gpio = pinctrl_lookup_state(dpi->pinctrl, "sleep");
+		if (IS_ERR(dpi->pins_gpio)) {
+			dpi->pins_gpio = NULL;
+			dev_dbg(&pdev->dev, "Cannot find pinctrl idle!\n");
+		}
+		if (dpi->pins_gpio)
+			pinctrl_select_state(dpi->pinctrl, dpi->pins_gpio);
+
+		dpi->pins_dpi = pinctrl_lookup_state(dpi->pinctrl, "default");
+		if (IS_ERR(dpi->pins_dpi)) {
+			dpi->pins_dpi = NULL;
+			dev_dbg(&pdev->dev, "Cannot find pinctrl active!\n");
+		}
+	}
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dpi->regs = devm_ioremap_resource(dev, mem);
 	if (IS_ERR(dpi->regs)) {
-- 
2.25.1



