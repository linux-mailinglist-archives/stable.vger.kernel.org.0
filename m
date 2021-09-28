Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8DA41B962
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 23:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbhI1Vhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 17:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242935AbhI1Vhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 17:37:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CC2C061745
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 14:36:06 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w14so158976pfu.2
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 14:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BvgM4m2pXG/PIUkUjK73FJ7j4ardNCogAkvXuK07AJc=;
        b=PeeFov8qVje38hwQE1/feYtxaMpRkaXGWrx5zgYmfRhTQa8AbjATUWcYuE4sNTy0jc
         NzTMXMdnRkmlW7O8FqV/jpXabij0r1eBzE1+47CCs2eRykDvxNMvVT62RAW5lSmIO8de
         qpcOP5VzseHI2aOAYmtEvQyxXOcmwqewSG+gs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BvgM4m2pXG/PIUkUjK73FJ7j4ardNCogAkvXuK07AJc=;
        b=TNq9dLjo4F9HJeaT1Z6DlSIRjWlhj78qKkCCNqZ2AbHC6MqnZ4dyxolJnYxTwvjyJA
         tCK4oKgZlAMfzu8w/snTrufYdF5cZBbsWRgaUKZyf9NTsGEODnUE9uRhUzLAaFeZwtKH
         5qiEM1H/tMQIIOZJxwulZV9cOZK2q9VngmRG+UGHxiDyeC+hsGqg3cjSJAaPXTpRYsMs
         vqf0kOkE35OCINePXOpDIY3n5nGROu5ixfd0M3mjrTYKoMLnlXFSz7obpfj05mzQq0ZQ
         VdNSg4S0CTw4J/vmadxy5oJMh65RLmtS8dJoU/Ov1ST8J5FGh8K6luaJ3l1oaIGZcP7P
         f7ag==
X-Gm-Message-State: AOAM532o4T/oMhqisIShWiDat6JJKwK5bCBTqZpfOE/sigE0wxq7F7tf
        QgU+kcztF72OWIoUS1pLIrNdjg==
X-Google-Smtp-Source: ABdhPJy7hthTjTmdF7Zg1yCAFxkJ0NU3YER4rdGOklhBmFktJSD3x8/bYr7IvIK0Q4BJbFDVzPRKnw==
X-Received: by 2002:a62:7a4f:0:b0:448:6a41:14bb with SMTP id v76-20020a627a4f000000b004486a4114bbmr7479777pfc.31.1632864966354;
        Tue, 28 Sep 2021 14:36:06 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:d7ca:580:94ab:8af8])
        by smtp.gmail.com with UTF8SMTPSA id q19sm105131pgn.81.2021.09.28.14.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 14:36:05 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        aleksandr.o.makarov@gmail.com, stable@vger.kernel.org,
        =?UTF-8?q?N=C3=ADcolas=20F=20=2E=20R=20=2E=20A=20=2E=20Prado?= 
        <nfraprado@collabora.com>
Subject: [PATCH v3 1/4] drm/rockchip: dsi: Hold pm-runtime across bind/unbind
Date:   Tue, 28 Sep 2021 14:35:49 -0700
Message-Id: <20210928143413.v3.1.Ic2904d37f30013a7f3d8476203ad3733c186827e@changeid>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210928213552.1001939-1-briannorris@chromium.org>
References: <20210928213552.1001939-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 43c2de1002d2, we moved most HW configuration to bind(), but we
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

Fixes: 43c2de1002d2 ("drm/rockchip: dsi: move all lane config except LCDC mux to bind()")
Link: https://lore.kernel.org/linux-rockchip/9aedfb528600ecf871885f7293ca4207c84d16c1.camel@gmail.com/
Reported-by: <aleksandr.o.makarov@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
---

(no changes since v2)

Changes in v2:
- Clean up pm-runtime state in error cases.
- Correct git hash for Fixes.

 .../gpu/drm/rockchip/dw-mipi-dsi-rockchip.c   | 37 ++++++++++---------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index a2262bee5aa4..45676b23c019 100644
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
@@ -938,10 +924,14 @@ static int dw_mipi_dsi_rockchip_bind(struct device *dev,
 		put_device(second);
 	}
 
+	pm_runtime_get_sync(dsi->dev);
+	if (dsi->slave)
+		pm_runtime_get_sync(dsi->slave->dev);
+
 	ret = clk_prepare_enable(dsi->pllref_clk);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to enable pllref_clk: %d\n", ret);
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	/*
@@ -953,7 +943,7 @@ static int dw_mipi_dsi_rockchip_bind(struct device *dev,
 	ret = clk_prepare_enable(dsi->grf_clk);
 	if (ret) {
 		DRM_DEV_ERROR(dsi->dev, "Failed to enable grf_clk: %d\n", ret);
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	dw_mipi_dsi_rockchip_config(dsi);
@@ -965,16 +955,23 @@ static int dw_mipi_dsi_rockchip_bind(struct device *dev,
 	ret = rockchip_dsi_drm_create_encoder(dsi, drm_dev);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to create drm encoder\n");
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	ret = dw_mipi_dsi_bind(dsi->dmd, &dsi->encoder);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to bind: %d\n", ret);
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	return 0;
+
+out_pm_runtime:
+	pm_runtime_put(dsi->dev);
+	if (dsi->slave)
+		pm_runtime_put(dsi->slave->dev);
+
+	return ret;
 }
 
 static void dw_mipi_dsi_rockchip_unbind(struct device *dev,
@@ -989,6 +986,10 @@ static void dw_mipi_dsi_rockchip_unbind(struct device *dev,
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

