Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A83419DB9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 20:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhI0SCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 14:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbhI0SCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 14:02:00 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD7C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 11:00:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m26so16605106pff.3
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 11:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yXcjXLEUU3nildNYoxMEqnc4/GAMyWaGrIeKlsoekxA=;
        b=eO4zMx8OK7l/Fm2RzIja0dJMHLRaZVs+qdiiZALORr4ePn7i4YzxTulZJFJ7zcM3OI
         8AforHwrwN7yvarhMfLRs88sMEYRL3kJgwJXr41UcM2LJjtmaIKFmY1jR7W/tjrZx/UB
         hC2NGRNozfO8MeVjYXwzIR9mjAQDVfVRN0kNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXcjXLEUU3nildNYoxMEqnc4/GAMyWaGrIeKlsoekxA=;
        b=z4hMKVtzehyH9i9GgJWuTxUdM1HaU85o3O7vUODrKehk8c9kImLf8fBQ26am928Ufw
         /dI6RSY+z+DC7pMaL8C18vMO3D1NXdVpEH1dDMQgq3XHR7MEDvF6Gp+1mPtylpAlrqWH
         bidzfCPhHEB1oJARtGWPuijJK+LzBGTZ8Pp+8ek9wwo00VmAfISkuHZj/4OGD0g63CCE
         WaUPd2sCFf35E9xqSfmmKrOl3eCl51jbt6b/QYWBK6M6vBsXe1nRLb7Xy6uPzSC5F8WW
         Hp7tW45TXNebEoOprOmH88NdsFFboYSgmZyfGt9cuut22KpSsEmmysYyWY8GSPohFvaZ
         M8Pg==
X-Gm-Message-State: AOAM533glOewXmnAacN9noyvoio5XxS7Yn57sCYDl80mfoRvEQTIaf0j
        wN7Ui1cDYYwXyqwPF8G83/ww2w==
X-Google-Smtp-Source: ABdhPJzM6DN9j/wrGa72mB8jLhaCKul3eWC8j2VmrO3BGILG46pb9iWJWPOeyJI5sfh/OVJ13Gl1hw==
X-Received: by 2002:a62:1409:0:b0:447:a1bf:9f44 with SMTP id 9-20020a621409000000b00447a1bf9f44mr959209pfu.76.1632765621703;
        Mon, 27 Sep 2021 11:00:21 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:82d7:f099:76bc:7017])
        by smtp.gmail.com with UTF8SMTPSA id w13sm116228pjc.29.2021.09.27.11.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 11:00:21 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, dri-devel@lists.freedesktop.org,
        Chen-Yu Tsai <wenst@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, linux-kernel@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        aleksandr.o.makarov@gmail.com, stable@vger.kernel.org,
        =?UTF-8?q?N=C3=ADcolas=20F=20=2E=20R=20=2E=20A=20=2E=20Prado?= 
        <nfraprado@collabora.com>
Subject: [PATCH v2 1/3] drm/rockchip: dsi: Hold pm-runtime across bind/unbind
Date:   Mon, 27 Sep 2021 10:59:42 -0700
Message-Id: <20210927105928.v2.1.Ic2904d37f30013a7f3d8476203ad3733c186827e@changeid>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210927175944.3381314-1-briannorris@chromium.org>
References: <20210927175944.3381314-1-briannorris@chromium.org>
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

