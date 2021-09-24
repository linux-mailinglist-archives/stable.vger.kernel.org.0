Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A47417E23
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 01:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344195AbhIXXZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 19:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhIXXZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 19:25:31 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E02FC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 16:23:58 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so8690412pjb.4
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 16:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZGh0IJWufh01powSTdVx5YAdtheJ5mkv5nCF0lb+5k=;
        b=Bdypi4AoRYyPQV/WrOBQVtgF+UF/fI2bXzxtvauSLQOCVb5r0rfFvfICzo4AoUNQxp
         mmCTqJk4sH469ZT8FEzHZE5VPXYygqhS2HTnQ0HkQQMt6rEQcQqsC46gRqemwGhWM7Y4
         e8OF69jqXcNw3uI9AdlSAi5V7GO9lh6g/Un5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZGh0IJWufh01powSTdVx5YAdtheJ5mkv5nCF0lb+5k=;
        b=yfV6VgxiH3E2TWxfgsdFaUjxOEvXPulnXbLK9nQNMcrr4yolSbdP9dX3/HzLIrCTwH
         T3WdPISa6+r2EkqpyMtPg2RMWTYRKPM/KjQkUpC39Zovcf1dbVeoROMHWAk5nMLkDXe7
         4mXjk+AKaz+p0NuD+PNlYXknC6RDwE4W0d7M97X3mHZafY3zlnoPutEyVEyPUw++1F8a
         JoSQ3vdXaEZ6LNv+oBPpJzC3AQpE9ARGP6zsPYB1l/TLigJpghfS+3qMT7EPK3680ljQ
         QHZqTngdMhHteEbD3NkCQ5QXV8tLIy9wng7w89sduiO4CPqfVQTwgqfEiU4t5yHz2qy4
         qE/A==
X-Gm-Message-State: AOAM532QV+3SExLrKpwxBIuWLxIdtUVsYbbDeancbRN01n+0o+fklx/a
        vOrYN3lkYkHlJNVIZcHfEVhvLA==
X-Google-Smtp-Source: ABdhPJyj7C/w++WE5M0qMOoytO2CFEADcDfViRtt1xg+ksq9CtCLBoM8O3bLexZsO3TOlq4YFbWnuQ==
X-Received: by 2002:a17:902:7144:b0:13c:8d49:fc46 with SMTP id u4-20020a170902714400b0013c8d49fc46mr11073502plm.45.1632525837863;
        Fri, 24 Sep 2021 16:23:57 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:74de:c8b7:3a35:1063])
        by smtp.gmail.com with UTF8SMTPSA id b12sm9792028pfp.5.2021.09.24.16.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 16:23:57 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Thomas Hebb <tommyhebb@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        aleksandr.o.makarov@gmail.com, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/rockchip: dsi: hold pm-runtime across bind/unbind
Date:   Fri, 24 Sep 2021 16:23:45 -0700
Message-Id: <20210924162321.1.Ic2904d37f30013a7f3d8476203ad3733c186827e@changeid>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 59eb7193bef2, we moved most HW configuration to bind(), but we
didn't move the runtime PM management. Therefore, depending on initial
boot state, runtime-PM workqueue delays, and other timing factors, we
may disable our power domain in between the hardware configuration
(bind()) and when we enable the display. This can cause us to lose
hardware state and fail to configure our display. For example:

  dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
  panel-innolux-p079zca ff960000.mipi.0: failed to write command 0

or:

  dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
  panel-kingdisplay-kd097d04 ff960000.mipi.0: failed write init cmds: -110

We should match the runtime PM to the lifetime of the bind()/unbind()
cycle.

Tested on Acer Chrometab 10 (RK3399 Gru-Scarlet), with panel drivers
built either as modules or built-in.

Side notes: it seems one is more likely to see this problem when the
panel driver is built into the kernel. I've also seen this problem
bisect down to commits that simply changed Kconfig dependencies, because
it changed the order in which driver init functions were compiled into
the kernel, and therefore the ordering and timing of built-in device
probe.

Fixes: 59eb7193bef2 ("drm/rockchip: dsi: move all lane config except LCDC mux to bind()")
Link: https://lore.kernel.org/linux-rockchip/9aedfb528600ecf871885f7293ca4207c84d16c1.camel@gmail.com/
Reported-by: <aleksandr.o.makarov@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

 .../gpu/drm/rockchip/dw-mipi-dsi-rockchip.c   | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index a2262bee5aa4..4340a99edb97 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -773,10 +773,6 @@ static void dw_mipi_dsi_encoder_enable(struct drm_encoder *encoder)
 	if (mux < 0)
 		return;
 
-	pm_runtime_get_sync(dsi->dev);
-	if (dsi->slave)
-		pm_runtime_get_sync(dsi->slave->dev);
-
 	/*
 	 * For the RK3399, the clk of grf must be enabled before writing grf
 	 * register. And for RK3288 or other soc, this grf_clk must be NULL,
@@ -795,20 +791,10 @@ static void dw_mipi_dsi_encoder_enable(struct drm_encoder *encoder)
 	clk_disable_unprepare(dsi->grf_clk);
 }
 
-static void dw_mipi_dsi_encoder_disable(struct drm_encoder *encoder)
-{
-	struct dw_mipi_dsi_rockchip *dsi = to_dsi(encoder);
-
-	if (dsi->slave)
-		pm_runtime_put(dsi->slave->dev);
-	pm_runtime_put(dsi->dev);
-}
-
 static const struct drm_encoder_helper_funcs
 dw_mipi_dsi_encoder_helper_funcs = {
 	.atomic_check = dw_mipi_dsi_encoder_atomic_check,
 	.enable = dw_mipi_dsi_encoder_enable,
-	.disable = dw_mipi_dsi_encoder_disable,
 };
 
 static int rockchip_dsi_drm_create_encoder(struct dw_mipi_dsi_rockchip *dsi,
@@ -938,6 +924,10 @@ static int dw_mipi_dsi_rockchip_bind(struct device *dev,
 		put_device(second);
 	}
 
+	pm_runtime_get_sync(dsi->dev);
+	if (dsi->slave)
+		pm_runtime_get_sync(dsi->slave->dev);
+
 	ret = clk_prepare_enable(dsi->pllref_clk);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to enable pllref_clk: %d\n", ret);
@@ -989,6 +979,10 @@ static void dw_mipi_dsi_rockchip_unbind(struct device *dev,
 	dw_mipi_dsi_unbind(dsi->dmd);
 
 	clk_disable_unprepare(dsi->pllref_clk);
+
+	pm_runtime_put(dsi->dev);
+	if (dsi->slave)
+		pm_runtime_put(dsi->slave->dev);
 }
 
 static const struct component_ops dw_mipi_dsi_rockchip_ops = {
-- 
2.33.0.685.g46640cef36-goog

