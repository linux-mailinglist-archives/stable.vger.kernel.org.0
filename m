Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBBC6674CC
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjALONN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbjALOMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:12:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC60959FBD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:05:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E41962028
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F0CC433EF;
        Thu, 12 Jan 2023 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532348;
        bh=XW5BGB6Fbmlww7SCnTNvvbQMV1QidxN2J4qJ/R4ArCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wE1rEWbCyuqeq7LeN8GjGj0frtwQynzIfPGXlY3JbQYu9M+gEAbokYyec/ur56ODr
         1Yy/LFsWK669UUGhQcmzFn81e1x0GDCHF+sCxO1q5VySNUsNV5S4uKNEbTPwp7vpk7
         yzDJzhCzBH97KChH+OVg9FtvyAicEybzggJKH5FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/783] drm/msm/hdmi: switch to drm_bridge_connector
Date:   Thu, 12 Jan 2023 14:47:27 +0100
Message-Id: <20230112135530.383544061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit caa24223463dfd75702a24daac13c93edb4aafac ]

Merge old hdmi_bridge and hdmi_connector implementations. Use
drm_bridge_connector instead.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20211015001100.4193241-2-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: b964444b2b64 ("drm/msm/hdmi: use devres helper for runtime PM management")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/Makefile                  |   2 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c               |  12 +-
 drivers/gpu/drm/msm/hdmi/hdmi.h               |  19 ++-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c        |  81 ++++++++-
 .../msm/hdmi/{hdmi_connector.c => hdmi_hpd.c} | 154 ++----------------
 5 files changed, 109 insertions(+), 159 deletions(-)
 rename drivers/gpu/drm/msm/hdmi/{hdmi_connector.c => hdmi_hpd.c} (63%)

diff --git a/drivers/gpu/drm/msm/Makefile b/drivers/gpu/drm/msm/Makefile
index 340682cd0f32..2457ef9851bb 100644
--- a/drivers/gpu/drm/msm/Makefile
+++ b/drivers/gpu/drm/msm/Makefile
@@ -19,7 +19,7 @@ msm-y := \
 	hdmi/hdmi.o \
 	hdmi/hdmi_audio.o \
 	hdmi/hdmi_bridge.o \
-	hdmi/hdmi_connector.o \
+	hdmi/hdmi_hpd.o \
 	hdmi/hdmi_i2c.o \
 	hdmi/hdmi_phy.o \
 	hdmi/hdmi_phy_8960.o \
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index bd65dc9b8892..f6b09e8eca67 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -8,6 +8,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 
+#include <drm/drm_bridge_connector.h>
+
 #include <sound/hdmi-codec.h>
 #include "hdmi.h"
 
@@ -41,7 +43,7 @@ static irqreturn_t msm_hdmi_irq(int irq, void *dev_id)
 	struct hdmi *hdmi = dev_id;
 
 	/* Process HPD: */
-	msm_hdmi_connector_irq(hdmi->connector);
+	msm_hdmi_hpd_irq(hdmi->bridge);
 
 	/* Process DDC: */
 	msm_hdmi_i2c_irq(hdmi->i2c);
@@ -311,7 +313,7 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 		goto fail;
 	}
 
-	hdmi->connector = msm_hdmi_connector_init(hdmi);
+	hdmi->connector = drm_bridge_connector_init(hdmi->dev, encoder);
 	if (IS_ERR(hdmi->connector)) {
 		ret = PTR_ERR(hdmi->connector);
 		DRM_DEV_ERROR(dev->dev, "failed to create HDMI connector: %d\n", ret);
@@ -319,6 +321,8 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 		goto fail;
 	}
 
+	drm_connector_attach_encoder(hdmi->connector, hdmi->encoder);
+
 	hdmi->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
 	if (!hdmi->irq) {
 		ret = -EINVAL;
@@ -335,7 +339,9 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 		goto fail;
 	}
 
-	ret = msm_hdmi_hpd_enable(hdmi->connector);
+	drm_bridge_connector_enable_hpd(hdmi->connector);
+
+	ret = msm_hdmi_hpd_enable(hdmi->bridge);
 	if (ret < 0) {
 		DRM_DEV_ERROR(&hdmi->pdev->dev, "failed to enable HPD: %d\n", ret);
 		goto fail;
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.h b/drivers/gpu/drm/msm/hdmi/hdmi.h
index d0b84f0abee1..8d2706bec3b9 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.h
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.h
@@ -114,6 +114,13 @@ struct hdmi_platform_config {
 	struct hdmi_gpio_data gpios[HDMI_MAX_NUM_GPIO];
 };
 
+struct hdmi_bridge {
+	struct drm_bridge base;
+	struct hdmi *hdmi;
+	struct work_struct hpd_work;
+};
+#define to_hdmi_bridge(x) container_of(x, struct hdmi_bridge, base)
+
 void msm_hdmi_set_mode(struct hdmi *hdmi, bool power_on);
 
 static inline void hdmi_write(struct hdmi *hdmi, u32 reg, u32 data)
@@ -230,13 +237,11 @@ void msm_hdmi_audio_set_sample_rate(struct hdmi *hdmi, int rate);
 struct drm_bridge *msm_hdmi_bridge_init(struct hdmi *hdmi);
 void msm_hdmi_bridge_destroy(struct drm_bridge *bridge);
 
-/*
- * hdmi connector:
- */
-
-void msm_hdmi_connector_irq(struct drm_connector *connector);
-struct drm_connector *msm_hdmi_connector_init(struct hdmi *hdmi);
-int msm_hdmi_hpd_enable(struct drm_connector *connector);
+void msm_hdmi_hpd_irq(struct drm_bridge *bridge);
+enum drm_connector_status msm_hdmi_bridge_detect(
+		struct drm_bridge *bridge);
+int msm_hdmi_hpd_enable(struct drm_bridge *bridge);
+void msm_hdmi_hpd_disable(struct hdmi_bridge *hdmi_bridge);
 
 /*
  * i2c adapter for ddc:
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
index 6e380db9287b..efcfdd70a02e 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -5,17 +5,16 @@
  */
 
 #include <linux/delay.h>
+#include <drm/drm_bridge_connector.h>
 
+#include "msm_kms.h"
 #include "hdmi.h"
 
-struct hdmi_bridge {
-	struct drm_bridge base;
-	struct hdmi *hdmi;
-};
-#define to_hdmi_bridge(x) container_of(x, struct hdmi_bridge, base)
-
 void msm_hdmi_bridge_destroy(struct drm_bridge *bridge)
 {
+	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
+
+	msm_hdmi_hpd_disable(hdmi_bridge);
 }
 
 static void msm_hdmi_power_on(struct drm_bridge *bridge)
@@ -259,14 +258,76 @@ static void msm_hdmi_bridge_mode_set(struct drm_bridge *bridge,
 		msm_hdmi_audio_update(hdmi);
 }
 
+static struct edid *msm_hdmi_bridge_get_edid(struct drm_bridge *bridge,
+		struct drm_connector *connector)
+{
+	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
+	struct hdmi *hdmi = hdmi_bridge->hdmi;
+	struct edid *edid;
+	uint32_t hdmi_ctrl;
+
+	hdmi_ctrl = hdmi_read(hdmi, REG_HDMI_CTRL);
+	hdmi_write(hdmi, REG_HDMI_CTRL, hdmi_ctrl | HDMI_CTRL_ENABLE);
+
+	edid = drm_get_edid(connector, hdmi->i2c);
+
+	hdmi_write(hdmi, REG_HDMI_CTRL, hdmi_ctrl);
+
+	hdmi->hdmi_mode = drm_detect_hdmi_monitor(edid);
+
+	return edid;
+}
+
+static enum drm_mode_status msm_hdmi_bridge_mode_valid(struct drm_bridge *bridge,
+		const struct drm_display_info *info,
+		const struct drm_display_mode *mode)
+{
+	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
+	struct hdmi *hdmi = hdmi_bridge->hdmi;
+	const struct hdmi_platform_config *config = hdmi->config;
+	struct msm_drm_private *priv = bridge->dev->dev_private;
+	struct msm_kms *kms = priv->kms;
+	long actual, requested;
+
+	requested = 1000 * mode->clock;
+	actual = kms->funcs->round_pixclk(kms,
+			requested, hdmi_bridge->hdmi->encoder);
+
+	/* for mdp5/apq8074, we manage our own pixel clk (as opposed to
+	 * mdp4/dtv stuff where pixel clk is assigned to mdp/encoder
+	 * instead):
+	 */
+	if (config->pwr_clk_cnt > 0)
+		actual = clk_round_rate(hdmi->pwr_clks[0], actual);
+
+	DBG("requested=%ld, actual=%ld", requested, actual);
+
+	if (actual != requested)
+		return MODE_CLOCK_RANGE;
+
+	return 0;
+}
+
 static const struct drm_bridge_funcs msm_hdmi_bridge_funcs = {
 		.pre_enable = msm_hdmi_bridge_pre_enable,
 		.enable = msm_hdmi_bridge_enable,
 		.disable = msm_hdmi_bridge_disable,
 		.post_disable = msm_hdmi_bridge_post_disable,
 		.mode_set = msm_hdmi_bridge_mode_set,
+		.mode_valid = msm_hdmi_bridge_mode_valid,
+		.get_edid = msm_hdmi_bridge_get_edid,
+		.detect = msm_hdmi_bridge_detect,
 };
 
+static void
+msm_hdmi_hotplug_work(struct work_struct *work)
+{
+	struct hdmi_bridge *hdmi_bridge =
+		container_of(work, struct hdmi_bridge, hpd_work);
+	struct drm_bridge *bridge = &hdmi_bridge->base;
+
+	drm_bridge_hpd_notify(bridge, drm_bridge_detect(bridge));
+}
 
 /* initialize bridge */
 struct drm_bridge *msm_hdmi_bridge_init(struct hdmi *hdmi)
@@ -283,11 +344,17 @@ struct drm_bridge *msm_hdmi_bridge_init(struct hdmi *hdmi)
 	}
 
 	hdmi_bridge->hdmi = hdmi;
+	INIT_WORK(&hdmi_bridge->hpd_work, msm_hdmi_hotplug_work);
 
 	bridge = &hdmi_bridge->base;
 	bridge->funcs = &msm_hdmi_bridge_funcs;
+	bridge->ddc = hdmi->i2c;
+	bridge->type = DRM_MODE_CONNECTOR_HDMIA;
+	bridge->ops = DRM_BRIDGE_OP_HPD |
+		DRM_BRIDGE_OP_DETECT |
+		DRM_BRIDGE_OP_EDID;
 
-	ret = drm_bridge_attach(hdmi->encoder, bridge, NULL, 0);
+	ret = drm_bridge_attach(hdmi->encoder, bridge, NULL, DRM_BRIDGE_ATTACH_NO_CONNECTOR);
 	if (ret)
 		goto fail;
 
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c b/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
similarity index 63%
rename from drivers/gpu/drm/msm/hdmi/hdmi_connector.c
rename to drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
index 58707a1f3878..c3a236bb952c 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
@@ -11,13 +11,6 @@
 #include "msm_kms.h"
 #include "hdmi.h"
 
-struct hdmi_connector {
-	struct drm_connector base;
-	struct hdmi *hdmi;
-	struct work_struct hpd_work;
-};
-#define to_hdmi_connector(x) container_of(x, struct hdmi_connector, base)
-
 static void msm_hdmi_phy_reset(struct hdmi *hdmi)
 {
 	unsigned int val;
@@ -139,10 +132,10 @@ static void enable_hpd_clocks(struct hdmi *hdmi, bool enable)
 	}
 }
 
-int msm_hdmi_hpd_enable(struct drm_connector *connector)
+int msm_hdmi_hpd_enable(struct drm_bridge *bridge)
 {
-	struct hdmi_connector *hdmi_connector = to_hdmi_connector(connector);
-	struct hdmi *hdmi = hdmi_connector->hdmi;
+	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
+	struct hdmi *hdmi = hdmi_bridge->hdmi;
 	const struct hdmi_platform_config *config = hdmi->config;
 	struct device *dev = &hdmi->pdev->dev;
 	uint32_t hpd_ctrl;
@@ -202,9 +195,9 @@ int msm_hdmi_hpd_enable(struct drm_connector *connector)
 	return ret;
 }
 
-static void hdp_disable(struct hdmi_connector *hdmi_connector)
+void msm_hdmi_hpd_disable(struct hdmi_bridge *hdmi_bridge)
 {
-	struct hdmi *hdmi = hdmi_connector->hdmi;
+	struct hdmi *hdmi = hdmi_bridge->hdmi;
 	const struct hdmi_platform_config *config = hdmi->config;
 	struct device *dev = &hdmi->pdev->dev;
 	int i, ret = 0;
@@ -233,19 +226,10 @@ static void hdp_disable(struct hdmi_connector *hdmi_connector)
 	}
 }
 
-static void
-msm_hdmi_hotplug_work(struct work_struct *work)
-{
-	struct hdmi_connector *hdmi_connector =
-		container_of(work, struct hdmi_connector, hpd_work);
-	struct drm_connector *connector = &hdmi_connector->base;
-	drm_helper_hpd_irq_event(connector->dev);
-}
-
-void msm_hdmi_connector_irq(struct drm_connector *connector)
+void msm_hdmi_hpd_irq(struct drm_bridge *bridge)
 {
-	struct hdmi_connector *hdmi_connector = to_hdmi_connector(connector);
-	struct hdmi *hdmi = hdmi_connector->hdmi;
+	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
+	struct hdmi *hdmi = hdmi_bridge->hdmi;
 	uint32_t hpd_int_status, hpd_int_ctrl;
 
 	/* Process HPD: */
@@ -268,7 +252,7 @@ void msm_hdmi_connector_irq(struct drm_connector *connector)
 			hpd_int_ctrl |= HDMI_HPD_INT_CTRL_INT_CONNECT;
 		hdmi_write(hdmi, REG_HDMI_HPD_INT_CTRL, hpd_int_ctrl);
 
-		queue_work(hdmi->workq, &hdmi_connector->hpd_work);
+		queue_work(hdmi->workq, &hdmi_bridge->hpd_work);
 	}
 }
 
@@ -299,11 +283,11 @@ static enum drm_connector_status detect_gpio(struct hdmi *hdmi)
 			connector_status_disconnected;
 }
 
-static enum drm_connector_status hdmi_connector_detect(
-		struct drm_connector *connector, bool force)
+enum drm_connector_status msm_hdmi_bridge_detect(
+		struct drm_bridge *bridge)
 {
-	struct hdmi_connector *hdmi_connector = to_hdmi_connector(connector);
-	struct hdmi *hdmi = hdmi_connector->hdmi;
+	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
+	struct hdmi *hdmi = hdmi_bridge->hdmi;
 	const struct hdmi_platform_config *config = hdmi->config;
 	struct hdmi_gpio_data hpd_gpio = config->gpios[HPD_GPIO_INDEX];
 	enum drm_connector_status stat_gpio, stat_reg;
@@ -337,115 +321,3 @@ static enum drm_connector_status hdmi_connector_detect(
 
 	return stat_gpio;
 }
-
-static void hdmi_connector_destroy(struct drm_connector *connector)
-{
-	struct hdmi_connector *hdmi_connector = to_hdmi_connector(connector);
-
-	hdp_disable(hdmi_connector);
-
-	drm_connector_cleanup(connector);
-
-	kfree(hdmi_connector);
-}
-
-static int msm_hdmi_connector_get_modes(struct drm_connector *connector)
-{
-	struct hdmi_connector *hdmi_connector = to_hdmi_connector(connector);
-	struct hdmi *hdmi = hdmi_connector->hdmi;
-	struct edid *edid;
-	uint32_t hdmi_ctrl;
-	int ret = 0;
-
-	hdmi_ctrl = hdmi_read(hdmi, REG_HDMI_CTRL);
-	hdmi_write(hdmi, REG_HDMI_CTRL, hdmi_ctrl | HDMI_CTRL_ENABLE);
-
-	edid = drm_get_edid(connector, hdmi->i2c);
-
-	hdmi_write(hdmi, REG_HDMI_CTRL, hdmi_ctrl);
-
-	hdmi->hdmi_mode = drm_detect_hdmi_monitor(edid);
-	drm_connector_update_edid_property(connector, edid);
-
-	if (edid) {
-		ret = drm_add_edid_modes(connector, edid);
-		kfree(edid);
-	}
-
-	return ret;
-}
-
-static int msm_hdmi_connector_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
-{
-	struct hdmi_connector *hdmi_connector = to_hdmi_connector(connector);
-	struct hdmi *hdmi = hdmi_connector->hdmi;
-	const struct hdmi_platform_config *config = hdmi->config;
-	struct msm_drm_private *priv = connector->dev->dev_private;
-	struct msm_kms *kms = priv->kms;
-	long actual, requested;
-
-	requested = 1000 * mode->clock;
-	actual = kms->funcs->round_pixclk(kms,
-			requested, hdmi_connector->hdmi->encoder);
-
-	/* for mdp5/apq8074, we manage our own pixel clk (as opposed to
-	 * mdp4/dtv stuff where pixel clk is assigned to mdp/encoder
-	 * instead):
-	 */
-	if (config->pwr_clk_cnt > 0)
-		actual = clk_round_rate(hdmi->pwr_clks[0], actual);
-
-	DBG("requested=%ld, actual=%ld", requested, actual);
-
-	if (actual != requested)
-		return MODE_CLOCK_RANGE;
-
-	return 0;
-}
-
-static const struct drm_connector_funcs hdmi_connector_funcs = {
-	.detect = hdmi_connector_detect,
-	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = hdmi_connector_destroy,
-	.reset = drm_atomic_helper_connector_reset,
-	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
-};
-
-static const struct drm_connector_helper_funcs msm_hdmi_connector_helper_funcs = {
-	.get_modes = msm_hdmi_connector_get_modes,
-	.mode_valid = msm_hdmi_connector_mode_valid,
-};
-
-/* initialize connector */
-struct drm_connector *msm_hdmi_connector_init(struct hdmi *hdmi)
-{
-	struct drm_connector *connector = NULL;
-	struct hdmi_connector *hdmi_connector;
-
-	hdmi_connector = kzalloc(sizeof(*hdmi_connector), GFP_KERNEL);
-	if (!hdmi_connector)
-		return ERR_PTR(-ENOMEM);
-
-	hdmi_connector->hdmi = hdmi;
-	INIT_WORK(&hdmi_connector->hpd_work, msm_hdmi_hotplug_work);
-
-	connector = &hdmi_connector->base;
-
-	drm_connector_init_with_ddc(hdmi->dev, connector,
-				    &hdmi_connector_funcs,
-				    DRM_MODE_CONNECTOR_HDMIA,
-				    hdmi->i2c);
-	drm_connector_helper_add(connector, &msm_hdmi_connector_helper_funcs);
-
-	connector->polled = DRM_CONNECTOR_POLL_CONNECT |
-			DRM_CONNECTOR_POLL_DISCONNECT;
-
-	connector->interlace_allowed = 0;
-	connector->doublescan_allowed = 0;
-
-	drm_connector_attach_encoder(connector, hdmi->encoder);
-
-	return connector;
-}
-- 
2.35.1



