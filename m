Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AB527C83A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgI2L7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730594AbgI2Lky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A17206A5;
        Tue, 29 Sep 2020 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379654;
        bh=2dQoNSLwcFHgL9nUDXpmWel0uijiSICTv+90Rw3dA60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsZRO6eQ2mV4Rmp4xVgWCvMfUTMJhuMPZDXRMLQS1H2WzuvcAiDQZliot4OmzPbbh
         8YfJqkL6959Uvi2K0hRRXRNhpskPCBzMrqYAlslxW7Xsvh+Xzlz52xh57+TuM+IB2/
         y0KEq2XxJHbWui0EeCKMJwDYH5A4f/5nUzKuz76M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 260/388] drm/exynos: dsi: Remove bridge node reference in error handling path in probe function
Date:   Tue, 29 Sep 2020 12:59:51 +0200
Message-Id: <20200929110023.057281005@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 547a7348633b1f9923551f94ac3157a613d2c9f2 ]

'exynos_dsi_parse_dt()' takes a reference to 'dsi->in_bridge_node'.
This must be released in the error handling path.

In order to do that, add an error handling path and move the
'exynos_dsi_parse_dt()' call from the beginning to the end of the probe
function to ease the error handling path.
This function only sets some variables which are used only in the
'transfer' function.

The call chain is:
   .transfer
    --> exynos_dsi_host_transfer
      --> exynos_dsi_init
        --> exynos_dsi_enable_clock  (use burst_clk_rate and esc_clk_rate)
          --> exynos_dsi_set_pll     (use pll_clk_rate)

While at it, also handle cases where 'component_add()' fails.

This patch is similar to commit 70505c2ef94b ("drm/exynos: dsi: Remove bridge node reference in removal")
which fixed the issue in the remove function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 8ed94c9948008..b83acd696774b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -1741,10 +1741,6 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 	dsi->dev = dev;
 	dsi->driver_data = of_device_get_match_data(dev);
 
-	ret = exynos_dsi_parse_dt(dsi);
-	if (ret)
-		return ret;
-
 	dsi->supplies[0].supply = "vddcore";
 	dsi->supplies[1].supply = "vddio";
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(dsi->supplies),
@@ -1805,11 +1801,25 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = exynos_dsi_parse_dt(dsi);
+	if (ret)
+		return ret;
+
 	platform_set_drvdata(pdev, &dsi->encoder);
 
 	pm_runtime_enable(dev);
 
-	return component_add(dev, &exynos_dsi_component_ops);
+	ret = component_add(dev, &exynos_dsi_component_ops);
+	if (ret)
+		goto err_disable_runtime;
+
+	return 0;
+
+err_disable_runtime:
+	pm_runtime_disable(dev);
+	of_node_put(dsi->in_bridge_node);
+
+	return ret;
 }
 
 static int exynos_dsi_remove(struct platform_device *pdev)
-- 
2.25.1



