Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAAD6674CD
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjALONR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbjALOMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:12:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA4A31F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A0C261FBB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B1AC433EF;
        Thu, 12 Jan 2023 14:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532351;
        bh=2C4UsBUFRzfVoYE6c1Xq0Uujtvt3G/dJ4L10WiMdJgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i89kSpqaHgwXf3KwYNge/54BIL6yB8koCD8sv6LCewWM1zhUj59W50gFrW4XUC/Ll
         kb/siMLErUOpk8Cq4QZbKYF7xqLK7TnH8nX2XdDUJeGQp8/foIe8FD6NXVI6bxBSIY
         F89Tc5bSC02f/MfQb5fTWB/6zE2sabSCR5njh8Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/783] drm/msm/hdmi: drop unused GPIO support
Date:   Thu, 12 Jan 2023 14:47:28 +0100
Message-Id: <20230112135530.434857285@linuxfoundation.org>
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

[ Upstream commit 68e674b13b17ed41aac2763d12ece6deaae8df58 ]

The HDMI driver has code to configure extra GPIOs, which predates
pinctrl support. Nowadays all platforms should use pinctrl instead.
Neither of upstreamed Qualcomm platforms uses these properties, so it's
safe to drop them.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/488858/
Link: https://lore.kernel.org/r/20220609122350.3157529-7-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: b964444b2b64 ("drm/msm/hdmi: use devres helper for runtime PM management")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c     | 66 +++++++----------------------
 drivers/gpu/drm/msm/hdmi/hdmi.h     | 13 +-----
 drivers/gpu/drm/msm/hdmi/hdmi_hpd.c | 62 ++-------------------------
 3 files changed, 21 insertions(+), 120 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index f6b09e8eca67..efb14043a6ec 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -247,6 +247,20 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 		hdmi->pwr_clks[i] = clk;
 	}
 
+	hdmi->hpd_gpiod = devm_gpiod_get_optional(&pdev->dev, "hpd", GPIOD_IN);
+	/* This will catch e.g. -EPROBE_DEFER */
+	if (IS_ERR(hdmi->hpd_gpiod)) {
+		ret = PTR_ERR(hdmi->hpd_gpiod);
+		DRM_DEV_ERROR(&pdev->dev, "failed to get hpd gpio: (%d)\n", ret);
+		goto fail;
+	}
+
+	if (!hdmi->hpd_gpiod)
+		DBG("failed to get HPD gpio");
+
+	if (hdmi->hpd_gpiod)
+		gpiod_set_consumer_name(hdmi->hpd_gpiod, "HDMI_HPD");
+
 	pm_runtime_enable(&pdev->dev);
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
@@ -429,20 +443,6 @@ static struct hdmi_platform_config hdmi_tx_8996_config = {
 		.hpd_freq      = hpd_clk_freq_8x74,
 };
 
-static const struct {
-	const char *name;
-	const bool output;
-	const int value;
-	const char *label;
-} msm_hdmi_gpio_pdata[] = {
-	{ "qcom,hdmi-tx-ddc-clk", true, 1, "HDMI_DDC_CLK" },
-	{ "qcom,hdmi-tx-ddc-data", true, 1, "HDMI_DDC_DATA" },
-	{ "qcom,hdmi-tx-hpd", false, 1, "HDMI_HPD" },
-	{ "qcom,hdmi-tx-mux-en", true, 1, "HDMI_MUX_EN" },
-	{ "qcom,hdmi-tx-mux-sel", true, 0, "HDMI_MUX_SEL" },
-	{ "qcom,hdmi-tx-mux-lpm", true, 1, "HDMI_MUX_LPM" },
-};
-
 /*
  * HDMI audio codec callbacks
  */
@@ -555,7 +555,7 @@ static int msm_hdmi_bind(struct device *dev, struct device *master, void *data)
 	struct hdmi_platform_config *hdmi_cfg;
 	struct hdmi *hdmi;
 	struct device_node *of_node = dev->of_node;
-	int i, err;
+	int err;
 
 	hdmi_cfg = (struct hdmi_platform_config *)
 			of_device_get_match_data(dev);
@@ -567,42 +567,6 @@ static int msm_hdmi_bind(struct device *dev, struct device *master, void *data)
 	hdmi_cfg->mmio_name     = "core_physical";
 	hdmi_cfg->qfprom_mmio_name = "qfprom_physical";
 
-	for (i = 0; i < HDMI_MAX_NUM_GPIO; i++) {
-		const char *name = msm_hdmi_gpio_pdata[i].name;
-		struct gpio_desc *gpiod;
-
-		/*
-		 * We are fetching the GPIO lines "as is" since the connector
-		 * code is enabling and disabling the lines. Until that point
-		 * the power-on default value will be kept.
-		 */
-		gpiod = devm_gpiod_get_optional(dev, name, GPIOD_ASIS);
-		/* This will catch e.g. -PROBE_DEFER */
-		if (IS_ERR(gpiod))
-			return PTR_ERR(gpiod);
-		if (!gpiod) {
-			/* Try a second time, stripping down the name */
-			char name3[32];
-
-			/*
-			 * Try again after stripping out the "qcom,hdmi-tx"
-			 * prefix. This is mainly to match "hpd-gpios" used
-			 * in the upstream bindings.
-			 */
-			if (sscanf(name, "qcom,hdmi-tx-%s", name3))
-				gpiod = devm_gpiod_get_optional(dev, name3, GPIOD_ASIS);
-			if (IS_ERR(gpiod))
-				return PTR_ERR(gpiod);
-			if (!gpiod)
-				DBG("failed to get gpio: %s", name);
-		}
-		hdmi_cfg->gpios[i].gpiod = gpiod;
-		if (gpiod)
-			gpiod_set_consumer_name(gpiod, msm_hdmi_gpio_pdata[i].label);
-		hdmi_cfg->gpios[i].output = msm_hdmi_gpio_pdata[i].output;
-		hdmi_cfg->gpios[i].value = msm_hdmi_gpio_pdata[i].value;
-	}
-
 	dev->platform_data = hdmi_cfg;
 
 	hdmi = msm_hdmi_init(to_platform_device(dev));
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.h b/drivers/gpu/drm/msm/hdmi/hdmi.h
index 8d2706bec3b9..20f554312b17 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.h
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.h
@@ -19,17 +19,9 @@
 #include "msm_drv.h"
 #include "hdmi.xml.h"
 
-#define HDMI_MAX_NUM_GPIO	6
-
 struct hdmi_phy;
 struct hdmi_platform_config;
 
-struct hdmi_gpio_data {
-	struct gpio_desc *gpiod;
-	bool output;
-	int value;
-};
-
 struct hdmi_audio {
 	bool enabled;
 	struct hdmi_audio_infoframe infoframe;
@@ -61,6 +53,8 @@ struct hdmi {
 	struct clk **hpd_clks;
 	struct clk **pwr_clks;
 
+	struct gpio_desc *hpd_gpiod;
+
 	struct hdmi_phy *phy;
 	struct device *phy_dev;
 
@@ -109,9 +103,6 @@ struct hdmi_platform_config {
 	/* clks that need to be on for screen pwr (ie pixel clk): */
 	const char **pwr_clk_names;
 	int pwr_clk_cnt;
-
-	/* gpio's: */
-	struct hdmi_gpio_data gpios[HDMI_MAX_NUM_GPIO];
 };
 
 struct hdmi_bridge {
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c b/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
index c3a236bb952c..52ebe562ca9b 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
@@ -60,48 +60,6 @@ static void msm_hdmi_phy_reset(struct hdmi *hdmi)
 	}
 }
 
-static int gpio_config(struct hdmi *hdmi, bool on)
-{
-	const struct hdmi_platform_config *config = hdmi->config;
-	int i;
-
-	if (on) {
-		for (i = 0; i < HDMI_MAX_NUM_GPIO; i++) {
-			struct hdmi_gpio_data gpio = config->gpios[i];
-
-			if (gpio.gpiod) {
-				if (gpio.output) {
-					gpiod_direction_output(gpio.gpiod,
-							       gpio.value);
-				} else {
-					gpiod_direction_input(gpio.gpiod);
-					gpiod_set_value_cansleep(gpio.gpiod,
-								 gpio.value);
-				}
-			}
-		}
-
-		DBG("gpio on");
-	} else {
-		for (i = 0; i < HDMI_MAX_NUM_GPIO; i++) {
-			struct hdmi_gpio_data gpio = config->gpios[i];
-
-			if (!gpio.gpiod)
-				continue;
-
-			if (gpio.output) {
-				int value = gpio.value ? 0 : 1;
-
-				gpiod_set_value_cansleep(gpio.gpiod, value);
-			}
-		}
-
-		DBG("gpio off");
-	}
-
-	return 0;
-}
-
 static void enable_hpd_clocks(struct hdmi *hdmi, bool enable)
 {
 	const struct hdmi_platform_config *config = hdmi->config;
@@ -157,11 +115,8 @@ int msm_hdmi_hpd_enable(struct drm_bridge *bridge)
 		goto fail;
 	}
 
-	ret = gpio_config(hdmi, true);
-	if (ret) {
-		DRM_DEV_ERROR(dev, "failed to configure GPIOs: %d\n", ret);
-		goto fail;
-	}
+	if (hdmi->hpd_gpiod)
+		gpiod_set_value_cansleep(hdmi->hpd_gpiod, 1);
 
 	pm_runtime_get_sync(dev);
 	enable_hpd_clocks(hdmi, true);
@@ -210,10 +165,6 @@ void msm_hdmi_hpd_disable(struct hdmi_bridge *hdmi_bridge)
 	enable_hpd_clocks(hdmi, false);
 	pm_runtime_put_autosuspend(dev);
 
-	ret = gpio_config(hdmi, false);
-	if (ret)
-		dev_warn(dev, "failed to unconfigure GPIOs: %d\n", ret);
-
 	ret = pinctrl_pm_select_sleep_state(dev);
 	if (ret)
 		dev_warn(dev, "pinctrl state chg failed: %d\n", ret);
@@ -275,10 +226,7 @@ static enum drm_connector_status detect_reg(struct hdmi *hdmi)
 #define HPD_GPIO_INDEX	2
 static enum drm_connector_status detect_gpio(struct hdmi *hdmi)
 {
-	const struct hdmi_platform_config *config = hdmi->config;
-	struct hdmi_gpio_data hpd_gpio = config->gpios[HPD_GPIO_INDEX];
-
-	return gpiod_get_value(hpd_gpio.gpiod) ?
+	return gpiod_get_value(hdmi->hpd_gpiod) ?
 			connector_status_connected :
 			connector_status_disconnected;
 }
@@ -288,8 +236,6 @@ enum drm_connector_status msm_hdmi_bridge_detect(
 {
 	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
 	struct hdmi *hdmi = hdmi_bridge->hdmi;
-	const struct hdmi_platform_config *config = hdmi->config;
-	struct hdmi_gpio_data hpd_gpio = config->gpios[HPD_GPIO_INDEX];
 	enum drm_connector_status stat_gpio, stat_reg;
 	int retry = 20;
 
@@ -297,7 +243,7 @@ enum drm_connector_status msm_hdmi_bridge_detect(
 	 * some platforms may not have hpd gpio. Rely only on the status
 	 * provided by REG_HDMI_HPD_INT_STATUS in this case.
 	 */
-	if (!hpd_gpio.gpiod)
+	if (!hdmi->hpd_gpiod)
 		return detect_reg(hdmi);
 
 	do {
-- 
2.35.1



