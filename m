Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE62585252
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbiG2PVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbiG2PVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:21:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB74A83F0F;
        Fri, 29 Jul 2022 08:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D429CB8282F;
        Fri, 29 Jul 2022 15:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B8FC433C1;
        Fri, 29 Jul 2022 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659108047;
        bh=wH8M6/RTgRGyOVOEbCmeh17Nv82xkUtUTZfNGEUL0DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANAzxLjlEhwY7Xtb1Q33ZDCzYladcJDbWvANmGnwYObkzeXHq7w8hxShE6HaRx0ki
         qsQE2jVMrCfIbUVdQSE8Sfdo6JMqSXAQYES0dh03nau3o0F+woOlB583z2e+/Sganb
         NclPbFDZ1xR+JLIR3u3gkQqm6yOYRY/WJWJWJeb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.254
Date:   Fri, 29 Jul 2022 17:20:32 +0200
Message-Id: <165910803275166@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165910803220811@kroah.com>
References: <165910803220811@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 7ae832b9156f..c7a0dc943e74 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 253
+SUBLEVEL = 254
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 438b10c44d73..2b7a314b8452 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -59,7 +59,7 @@ srmcons_do_receive_chars(struct tty_port *port)
 	} while((result.bits.status & 1) && (++loops < 10));
 
 	if (count)
-		tty_schedule_flip(port);
+		tty_flip_buffer_push(port);
 
 	return count;
 }
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 110be14e6122..b6c972941881 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -66,6 +66,7 @@ ifeq ($(CONFIG_MODULE_SECTIONS),y)
 endif
 
 KBUILD_CFLAGS_MODULE += $(call cc-option,-mno-relax)
+KBUILD_AFLAGS_MODULE += $(call as-option,-Wa$(comma)-mno-relax)
 
 # GCC versions that support the "-mstrict-align" option default to allowing
 # unaligned accesses.  While unaligned accesses are explicitly allowed in the
diff --git a/drivers/char/random.c b/drivers/char/random.c
index bac4dc501dc4..2be38780a7f7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -183,8 +183,8 @@ static void __cold process_random_ready_list(void)
 
 #define warn_unseeded_randomness() \
 	if (IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) && !crng_ready()) \
-		pr_notice("%s called from %pS with crng_init=%d\n", \
-			  __func__, (void *)_RET_IP_, crng_init)
+		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n", \
+				__func__, (void *)_RET_IP_, crng_init)
 
 
 /*********************************************************************
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
index 1067e702c22c..31a2d1ecce3e 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -657,9 +657,6 @@ static bool tilcdc_crtc_mode_fixup(struct drm_crtc *crtc,
 static int tilcdc_crtc_atomic_check(struct drm_crtc *crtc,
 				    struct drm_crtc_state *state)
 {
-	struct drm_display_mode *mode = &state->mode;
-	int ret;
-
 	/* If we are not active we don't care */
 	if (!state->active)
 		return 0;
@@ -671,12 +668,6 @@ static int tilcdc_crtc_atomic_check(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
-	ret = tilcdc_crtc_mode_valid(crtc, mode);
-	if (ret) {
-		dev_dbg(crtc->dev->dev, "Mode \"%s\" not valid", mode->name);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -728,13 +719,6 @@ static const struct drm_crtc_funcs tilcdc_crtc_funcs = {
 	.disable_vblank	= tilcdc_crtc_disable_vblank,
 };
 
-static const struct drm_crtc_helper_funcs tilcdc_crtc_helper_funcs = {
-		.mode_fixup     = tilcdc_crtc_mode_fixup,
-		.atomic_check	= tilcdc_crtc_atomic_check,
-		.atomic_enable	= tilcdc_crtc_atomic_enable,
-		.atomic_disable	= tilcdc_crtc_atomic_disable,
-};
-
 int tilcdc_crtc_max_width(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
@@ -749,7 +733,9 @@ int tilcdc_crtc_max_width(struct drm_crtc *crtc)
 	return max_width;
 }
 
-int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode)
+static enum drm_mode_status
+tilcdc_crtc_mode_valid(struct drm_crtc *crtc,
+		       const struct drm_display_mode *mode)
 {
 	struct tilcdc_drm_private *priv = crtc->dev->dev_private;
 	unsigned int bandwidth;
@@ -837,6 +823,14 @@ int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode)
 	return MODE_OK;
 }
 
+static const struct drm_crtc_helper_funcs tilcdc_crtc_helper_funcs = {
+	.mode_valid	= tilcdc_crtc_mode_valid,
+	.mode_fixup	= tilcdc_crtc_mode_fixup,
+	.atomic_check	= tilcdc_crtc_atomic_check,
+	.atomic_enable	= tilcdc_crtc_atomic_enable,
+	.atomic_disable	= tilcdc_crtc_atomic_disable,
+};
+
 void tilcdc_crtc_set_panel_info(struct drm_crtc *crtc,
 		const struct tilcdc_panel_info *info)
 {
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index e1868776da25..96457fe2b8d5 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -202,7 +202,6 @@ static void tilcdc_fini(struct drm_device *dev)
 
 	drm_irq_uninstall(dev);
 	drm_mode_config_cleanup(dev);
-	tilcdc_remove_external_device(dev);
 
 	if (priv->clk)
 		clk_put(priv->clk);
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.h b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
index ead512216669..35558bbd5cd8 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
@@ -89,7 +89,6 @@ struct tilcdc_drm_private {
 
 	struct drm_encoder *external_encoder;
 	struct drm_connector *external_connector;
-	const struct drm_connector_helper_funcs *connector_funcs;
 
 	bool is_registered;
 	bool is_componentized;
@@ -171,7 +170,6 @@ void tilcdc_crtc_set_panel_info(struct drm_crtc *crtc,
 		const struct tilcdc_panel_info *info);
 void tilcdc_crtc_set_simulate_vesa_sync(struct drm_crtc *crtc,
 					bool simulate_vesa_sync);
-int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode);
 int tilcdc_crtc_max_width(struct drm_crtc *crtc);
 void tilcdc_crtc_shutdown(struct drm_crtc *crtc);
 int tilcdc_crtc_update_fb(struct drm_crtc *crtc,
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.c b/drivers/gpu/drm/tilcdc/tilcdc_external.c
index b4eaf9bc87f8..9c1be0635b53 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_external.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_external.c
@@ -40,64 +40,6 @@ static const struct tilcdc_panel_info panel_info_default = {
 		.raster_order           = 0,
 };
 
-static int tilcdc_external_mode_valid(struct drm_connector *connector,
-				      struct drm_display_mode *mode)
-{
-	struct tilcdc_drm_private *priv = connector->dev->dev_private;
-	int ret;
-
-	ret = tilcdc_crtc_mode_valid(priv->crtc, mode);
-	if (ret != MODE_OK)
-		return ret;
-
-	BUG_ON(priv->external_connector != connector);
-	BUG_ON(!priv->connector_funcs);
-
-	/* If the connector has its own mode_valid call it. */
-	if (!IS_ERR(priv->connector_funcs) &&
-	    priv->connector_funcs->mode_valid)
-		return priv->connector_funcs->mode_valid(connector, mode);
-
-	return MODE_OK;
-}
-
-static int tilcdc_add_external_connector(struct drm_device *dev,
-					 struct drm_connector *connector)
-{
-	struct tilcdc_drm_private *priv = dev->dev_private;
-	struct drm_connector_helper_funcs *connector_funcs;
-
-	/* There should never be more than one connector */
-	if (WARN_ON(priv->external_connector))
-		return -EINVAL;
-
-	priv->external_connector = connector;
-	connector_funcs = devm_kzalloc(dev->dev, sizeof(*connector_funcs),
-				       GFP_KERNEL);
-	if (!connector_funcs)
-		return -ENOMEM;
-
-	/* connector->helper_private contains always struct
-	 * connector_helper_funcs pointer. For tilcdc crtc to have a
-	 * say if a specific mode is Ok, we need to install our own
-	 * helper functions. In our helper functions we copy
-	 * everything else but use our own mode_valid() (above).
-	 */
-	if (connector->helper_private) {
-		priv->connector_funcs =	connector->helper_private;
-		*connector_funcs = *priv->connector_funcs;
-	} else {
-		priv->connector_funcs = ERR_PTR(-ENOENT);
-	}
-	connector_funcs->mode_valid = tilcdc_external_mode_valid;
-	drm_connector_helper_add(connector, connector_funcs);
-
-	dev_dbg(dev->dev, "External connector '%s' connected\n",
-		connector->name);
-
-	return 0;
-}
-
 static
 struct drm_connector *tilcdc_encoder_find_connector(struct drm_device *ddev,
 						    struct drm_encoder *encoder)
@@ -118,40 +60,30 @@ struct drm_connector *tilcdc_encoder_find_connector(struct drm_device *ddev,
 int tilcdc_add_component_encoder(struct drm_device *ddev)
 {
 	struct tilcdc_drm_private *priv = ddev->dev_private;
-	struct drm_connector *connector;
-	struct drm_encoder *encoder;
+	struct drm_encoder *encoder = NULL, *iter;
 
-	list_for_each_entry(encoder, &ddev->mode_config.encoder_list, head)
-		if (encoder->possible_crtcs & (1 << priv->crtc->index))
+	list_for_each_entry(iter, &ddev->mode_config.encoder_list, head)
+		if (iter->possible_crtcs & (1 << priv->crtc->index)) {
+			encoder = iter;
 			break;
+		}
 
 	if (!encoder) {
 		dev_err(ddev->dev, "%s: No suitable encoder found\n", __func__);
 		return -ENODEV;
 	}
 
-	connector = tilcdc_encoder_find_connector(ddev, encoder);
+	priv->external_connector =
+		tilcdc_encoder_find_connector(ddev, encoder);
 
-	if (!connector)
+	if (!priv->external_connector)
 		return -ENODEV;
 
 	/* Only tda998x is supported at the moment. */
 	tilcdc_crtc_set_simulate_vesa_sync(priv->crtc, true);
 	tilcdc_crtc_set_panel_info(priv->crtc, &panel_info_tda998x);
 
-	return tilcdc_add_external_connector(ddev, connector);
-}
-
-void tilcdc_remove_external_device(struct drm_device *dev)
-{
-	struct tilcdc_drm_private *priv = dev->dev_private;
-
-	/* Restore the original helper functions, if any. */
-	if (IS_ERR(priv->connector_funcs))
-		drm_connector_helper_add(priv->external_connector, NULL);
-	else if (priv->connector_funcs)
-		drm_connector_helper_add(priv->external_connector,
-					 priv->connector_funcs);
+	return 0;
 }
 
 static const struct drm_encoder_funcs tilcdc_external_encoder_funcs = {
@@ -162,7 +94,6 @@ static
 int tilcdc_attach_bridge(struct drm_device *ddev, struct drm_bridge *bridge)
 {
 	struct tilcdc_drm_private *priv = ddev->dev_private;
-	struct drm_connector *connector;
 	int ret;
 
 	priv->external_encoder->possible_crtcs = BIT(0);
@@ -175,13 +106,12 @@ int tilcdc_attach_bridge(struct drm_device *ddev, struct drm_bridge *bridge)
 
 	tilcdc_crtc_set_panel_info(priv->crtc, &panel_info_default);
 
-	connector = tilcdc_encoder_find_connector(ddev, priv->external_encoder);
-	if (!connector)
+	priv->external_connector =
+		tilcdc_encoder_find_connector(ddev, priv->external_encoder);
+	if (!priv->external_connector)
 		return -ENODEV;
 
-	ret = tilcdc_add_external_connector(ddev, connector);
-
-	return ret;
+	return 0;
 }
 
 int tilcdc_attach_external_device(struct drm_device *ddev)
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.h b/drivers/gpu/drm/tilcdc/tilcdc_external.h
index 763d18f006c7..a28b9df68c8f 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_external.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_external.h
@@ -19,7 +19,6 @@
 #define __TILCDC_EXTERNAL_H__
 
 int tilcdc_add_component_encoder(struct drm_device *dev);
-void tilcdc_remove_external_device(struct drm_device *dev);
 int tilcdc_get_external_components(struct device *dev,
 				   struct component_match **match);
 int tilcdc_attach_external_device(struct drm_device *ddev);
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 096a33f12c61..253c555e2997 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -174,14 +174,6 @@ static int panel_connector_get_modes(struct drm_connector *connector)
 	return i;
 }
 
-static int panel_connector_mode_valid(struct drm_connector *connector,
-		  struct drm_display_mode *mode)
-{
-	struct tilcdc_drm_private *priv = connector->dev->dev_private;
-	/* our only constraints are what the crtc can generate: */
-	return tilcdc_crtc_mode_valid(priv->crtc, mode);
-}
-
 static struct drm_encoder *panel_connector_best_encoder(
 		struct drm_connector *connector)
 {
@@ -199,7 +191,6 @@ static const struct drm_connector_funcs panel_connector_funcs = {
 
 static const struct drm_connector_helper_funcs panel_connector_helper_funcs = {
 	.get_modes          = panel_connector_get_modes,
-	.mode_valid         = panel_connector_mode_valid,
 	.best_encoder       = panel_connector_best_encoder,
 };
 
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index daebf1aa6b0a..54c6d825b1a0 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -183,14 +183,6 @@ static int tfp410_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int tfp410_connector_mode_valid(struct drm_connector *connector,
-		  struct drm_display_mode *mode)
-{
-	struct tilcdc_drm_private *priv = connector->dev->dev_private;
-	/* our only constraints are what the crtc can generate: */
-	return tilcdc_crtc_mode_valid(priv->crtc, mode);
-}
-
 static struct drm_encoder *tfp410_connector_best_encoder(
 		struct drm_connector *connector)
 {
@@ -209,7 +201,6 @@ static const struct drm_connector_funcs tfp410_connector_funcs = {
 
 static const struct drm_connector_helper_funcs tfp410_connector_helper_funcs = {
 	.get_modes          = tfp410_connector_get_modes,
-	.mode_valid         = tfp410_connector_mode_valid,
 	.best_encoder       = tfp410_connector_best_encoder,
 };
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8d4153c73f5c..70079d29822b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -727,6 +727,8 @@
 #define USB_DEVICE_ID_LENOVO_TPPRODOCK	0x6067
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
+#define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
+#define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 
 #define USB_VENDOR_ID_LG		0x1fd2
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e99286258f62..ce027eda9b17 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -72,6 +72,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_STICKY_FINGERS		BIT(16)
 #define MT_QUIRK_ASUS_CUSTOM_UP		BIT(17)
 #define MT_QUIRK_WIN8_PTP_BUTTONS	BIT(18)
+#define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -107,6 +108,7 @@ struct mt_usages {
 struct mt_application {
 	struct list_head list;
 	unsigned int application;
+	unsigned int report_id;
 	struct list_head mt_usages;	/* mt usages list */
 
 	__s32 quirks;
@@ -207,6 +209,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_VTL				0x0110
 #define MT_CLS_GOOGLE				0x0111
 #define MT_CLS_RAZER_BLADE_STEALTH		0x0112
+#define MT_CLS_SMART_TECH			0x0113
 
 #define MT_DEFAULT_MAXCONTACT	10
 #define MT_MAX_MAXCONTACT	250
@@ -357,6 +360,12 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_WIN8_PTP_BUTTONS,
 	},
+	{ .name = MT_CLS_SMART_TECH,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_SEPARATE_APP_REPORT,
+	},
 	{ }
 };
 
@@ -513,8 +522,9 @@ static struct mt_usages *mt_allocate_usage(struct hid_device *hdev,
 }
 
 static struct mt_application *mt_allocate_application(struct mt_device *td,
-						      unsigned int application)
+						      struct hid_report *report)
 {
+	unsigned int application = report->application;
 	struct mt_application *mt_application;
 
 	mt_application = devm_kzalloc(&td->hdev->dev, sizeof(*mt_application),
@@ -539,6 +549,7 @@ static struct mt_application *mt_allocate_application(struct mt_device *td,
 	mt_application->scantime = DEFAULT_ZERO;
 	mt_application->raw_cc = DEFAULT_ZERO;
 	mt_application->quirks = td->mtclass.quirks;
+	mt_application->report_id = report->id;
 
 	list_add_tail(&mt_application->list, &td->applications);
 
@@ -546,19 +557,23 @@ static struct mt_application *mt_allocate_application(struct mt_device *td,
 }
 
 static struct mt_application *mt_find_application(struct mt_device *td,
-						  unsigned int application)
+						  struct hid_report *report)
 {
+	unsigned int application = report->application;
 	struct mt_application *tmp, *mt_application = NULL;
 
 	list_for_each_entry(tmp, &td->applications, list) {
 		if (application == tmp->application) {
-			mt_application = tmp;
-			break;
+			if (!(td->mtclass.quirks & MT_QUIRK_SEPARATE_APP_REPORT) ||
+			    tmp->report_id == report->id) {
+				mt_application = tmp;
+				break;
+			}
 		}
 	}
 
 	if (!mt_application)
-		mt_application = mt_allocate_application(td, application);
+		mt_application = mt_allocate_application(td, report);
 
 	return mt_application;
 }
@@ -575,7 +590,7 @@ static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
 		return NULL;
 
 	rdata->report = report;
-	rdata->application = mt_find_application(td, report->application);
+	rdata->application = mt_find_application(td, report);
 
 	if (!rdata->application) {
 		devm_kfree(&td->hdev->dev, rdata);
@@ -1332,6 +1347,13 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		return mt_touch_input_mapping(hdev, hi, field, usage, bit, max,
 					      application);
 
+	/*
+	 * some egalax touchscreens have "application == DG_TOUCHSCREEN"
+	 * for the stylus. Overwrite the hid_input application
+	 */
+	if (field->physical == HID_DG_STYLUS)
+		hi->application = HID_DG_STYLUS;
+
 	/* let hid-core decide for the others */
 	return 0;
 }
@@ -1520,14 +1542,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	struct mt_device *td = hid_get_drvdata(hdev);
 	char *name;
 	const char *suffix = NULL;
-	unsigned int application = 0;
 	struct mt_report_data *rdata;
 	struct mt_application *mt_application = NULL;
 	struct hid_report *report;
 	int ret;
 
 	list_for_each_entry(report, &hi->reports, hidinput_list) {
-		application = report->application;
 		rdata = mt_find_report_data(td, report);
 		if (!rdata) {
 			hid_err(hdev, "failed to allocate data for report\n");
@@ -1542,46 +1562,36 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 			if (ret)
 				return ret;
 		}
-
-		/*
-		 * some egalax touchscreens have "application == DG_TOUCHSCREEN"
-		 * for the stylus. Check this first, and then rely on
-		 * the application field.
-		 */
-		if (report->field[0]->physical == HID_DG_STYLUS) {
-			suffix = "Pen";
-			/* force BTN_STYLUS to allow tablet matching in udev */
-			__set_bit(BTN_STYLUS, hi->input->keybit);
-		}
 	}
 
-	if (!suffix) {
-		switch (application) {
-		case HID_GD_KEYBOARD:
-		case HID_GD_KEYPAD:
-		case HID_GD_MOUSE:
-		case HID_DG_TOUCHPAD:
-		case HID_GD_SYSTEM_CONTROL:
-		case HID_CP_CONSUMER_CONTROL:
-		case HID_GD_WIRELESS_RADIO_CTLS:
-		case HID_GD_SYSTEM_MULTIAXIS:
-			/* already handled by hid core */
-			break;
-		case HID_DG_TOUCHSCREEN:
-			/* we do not set suffix = "Touchscreen" */
-			hi->input->name = hdev->name;
-			break;
-		case HID_DG_STYLUS:
-			/* force BTN_STYLUS to allow tablet matching in udev */
-			__set_bit(BTN_STYLUS, hi->input->keybit);
-			break;
-		case HID_VD_ASUS_CUSTOM_MEDIA_KEYS:
-			suffix = "Custom Media Keys";
-			break;
-		default:
-			suffix = "UNKNOWN";
-			break;
-		}
+	switch (hi->application) {
+	case HID_GD_KEYBOARD:
+	case HID_GD_KEYPAD:
+	case HID_GD_MOUSE:
+	case HID_DG_TOUCHPAD:
+	case HID_GD_SYSTEM_CONTROL:
+	case HID_CP_CONSUMER_CONTROL:
+	case HID_GD_WIRELESS_RADIO_CTLS:
+	case HID_GD_SYSTEM_MULTIAXIS:
+		/* already handled by hid core */
+		break;
+	case HID_DG_TOUCHSCREEN:
+		/* we do not set suffix = "Touchscreen" */
+		hi->input->name = hdev->name;
+		break;
+	case HID_DG_STYLUS:
+		/* force BTN_STYLUS to allow tablet matching in udev */
+		__set_bit(BTN_STYLUS, hi->input->keybit);
+		break;
+	case HID_VD_ASUS_CUSTOM_MEDIA_KEYS:
+		suffix = "Custom Media Keys";
+		break;
+	case HID_DG_PEN:
+		suffix = "Stylus";
+		break;
+	default:
+		suffix = "UNKNOWN";
+		break;
 	}
 
 	if (suffix) {
@@ -1805,6 +1815,12 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X1_TAB) },
 
+	/* Lenovo X1 TAB Gen 3 */
+	{ .driver_data = MT_CLS_WIN_8_DUAL,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
+
 	/* Anton devices */
 	{ .driver_data = MT_CLS_EXPORT_ALL_INPUTS,
 		MT_USB_DEVICE(USB_VENDOR_ID_ANTON,
@@ -2040,6 +2056,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_SYNAPTICS, 0x8323) },
 
+	/* Smart Tech panels */
+	{ .driver_data = MT_CLS_SMART_TECH,
+		MT_USB_DEVICE(0x0b8c, 0x0092)},
+
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 48e9761d4ace..c1b76ba85fb4 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -111,6 +111,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_PENSKETCH_M912), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C007), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C077), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KEYBOARD_G710_PLUS), HID_QUIRK_NOGET },
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 273f57e277b3..512c61d31fe5 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -203,9 +203,9 @@ static inline bool cdns_is_holdquirk(struct cdns_i2c *id, bool hold_wrkaround)
  */
 static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 {
-	unsigned int isr_status, avail_bytes, updatetx;
+	unsigned int isr_status, avail_bytes;
 	unsigned int bytes_to_send;
-	bool hold_quirk;
+	bool updatetx;
 	struct cdns_i2c *id = ptr;
 	/* Signal completion only after everything is updated */
 	int done_flag = 0;
@@ -224,11 +224,7 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 	 * Check if transfer size register needs to be updated again for a
 	 * large data receive operation.
 	 */
-	updatetx = 0;
-	if (id->recv_count > id->curr_recv_count)
-		updatetx = 1;
-
-	hold_quirk = (id->quirks & CDNS_I2C_BROKEN_HOLD_BIT) && updatetx;
+	updatetx = id->recv_count > id->curr_recv_count;
 
 	/* When receiving, handle data interrupt and completion interrupt */
 	if (id->p_recv_buf &&
@@ -251,7 +247,7 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 			id->recv_count--;
 			id->curr_recv_count--;
 
-			if (cdns_is_holdquirk(id, hold_quirk))
+			if (cdns_is_holdquirk(id, updatetx))
 				break;
 		}
 
@@ -262,7 +258,7 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 		 * maintain transfer size non-zero while performing a large
 		 * receive operation.
 		 */
-		if (cdns_is_holdquirk(id, hold_quirk)) {
+		if (cdns_is_holdquirk(id, updatetx)) {
 			/* wait while fifo is full */
 			while (cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET) !=
 			       (id->curr_recv_count - CDNS_I2C_FIFO_DEPTH))
@@ -284,22 +280,6 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 						  CDNS_I2C_XFER_SIZE_OFFSET);
 				id->curr_recv_count = id->recv_count;
 			}
-		} else if (id->recv_count && !hold_quirk &&
-						!id->curr_recv_count) {
-
-			/* Set the slave address in address register*/
-			cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
-						CDNS_I2C_ADDR_OFFSET);
-
-			if (id->recv_count > CDNS_I2C_TRANSFER_SIZE) {
-				cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-				id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE;
-			} else {
-				cdns_i2c_writereg(id->recv_count,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-				id->curr_recv_count = id->recv_count;
-			}
 		}
 
 		/* Clear hold (if not repeated start) and signal completion */
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 1e9d882c04ef..a4a448d97451 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -2291,7 +2291,7 @@ int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num, u32 *state)
 
 /* Uses sync mcc */
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data)
+				      u8 page_num, u32 off, u32 len, u8 *data)
 {
 	struct be_dma_mem cmd;
 	struct be_mcc_wrb *wrb;
@@ -2325,10 +2325,10 @@ int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
 	req->port = cpu_to_le32(adapter->hba_port_num);
 	req->page_num = cpu_to_le32(page_num);
 	status = be_mcc_notify_wait(adapter);
-	if (!status) {
+	if (!status && len > 0) {
 		struct be_cmd_resp_port_type *resp = cmd.va;
 
-		memcpy(data, resp->page_data, PAGE_DATA_LEN);
+		memcpy(data, resp->page_data + off, len);
 	}
 err:
 	mutex_unlock(&adapter->mcc_lock);
@@ -2419,7 +2419,7 @@ int be_cmd_query_cable_type(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		switch (adapter->phy.interface_type) {
 		case PHY_TYPE_QSFP:
@@ -2444,7 +2444,7 @@ int be_cmd_query_sfp_info(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		strlcpy(adapter->phy.vendor_name, page_data +
 			SFP_VENDOR_NAME_OFFSET, SFP_VENDOR_NAME_LEN - 1);
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.h b/drivers/net/ethernet/emulex/benet/be_cmds.h
index e8b43cf44b6f..f6f9c51a7d47 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.h
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.h
@@ -2431,7 +2431,7 @@ int be_cmd_set_beacon_state(struct be_adapter *adapter, u8 port_num, u8 beacon,
 int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num,
 			    u32 *state);
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data);
+				      u8 page_num, u32 off, u32 len, u8 *data);
 int be_cmd_query_cable_type(struct be_adapter *adapter);
 int be_cmd_query_sfp_info(struct be_adapter *adapter);
 int lancer_cmd_read_object(struct be_adapter *adapter, struct be_dma_mem *cmd,
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index d1905d50c26c..1c1ac3488da2 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1342,7 +1342,7 @@ static int be_get_module_info(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		if (!page_data[SFP_PLUS_SFF_8472_COMP]) {
 			modinfo->type = ETH_MODULE_SFF_8079;
@@ -1360,25 +1360,32 @@ static int be_get_module_eeprom(struct net_device *netdev,
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	int status;
+	u32 begin, end;
 
 	if (!check_privilege(adapter, MAX_PRIVILEGES))
 		return -EOPNOTSUPP;
 
-	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   data);
-	if (status)
-		goto err;
+	begin = eeprom->offset;
+	end = eeprom->offset + eeprom->len;
+
+	if (begin < PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0, begin,
+							   min_t(u32, end, PAGE_DATA_LEN) - begin,
+							   data);
+		if (status)
+			goto err;
+
+		data += PAGE_DATA_LEN - begin;
+		begin = PAGE_DATA_LEN;
+	}
 
-	if (eeprom->offset + eeprom->len > PAGE_DATA_LEN) {
-		status = be_cmd_read_port_transceiver_data(adapter,
-							   TR_PAGE_A2,
-							   data +
-							   PAGE_DATA_LEN);
+	if (end > PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A2,
+							   begin - PAGE_DATA_LEN,
+							   end - begin, data);
 		if (status)
 			goto err;
 	}
-	if (eeprom->offset)
-		memcpy(data, data + eeprom->offset, eeprom->len);
 err:
 	return be_cmd_status(status);
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index bc8871e7351f..00b6af0b2f3a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -222,6 +222,9 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	if (queue == 0 || queue == 4) {
 		value &= ~MTL_RXQ_DMA_Q04MDMACH_MASK;
 		value |= MTL_RXQ_DMA_Q04MDMACH(chan);
+	} else if (queue > 4) {
+		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
+		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
 	} else {
 		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue);
 		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index cf6ff8732fb2..efee7bacfd76 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1706,7 +1706,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1719,7 +1719,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1732,7 +1732,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1745,7 +1745,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1758,7 +1758,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1771,7 +1771,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1784,7 +1784,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1797,7 +1797,7 @@ static const struct driver_info belkin_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 5c2849846641..63c79e140f1a 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -831,6 +831,10 @@ static void hv_int_desc_free(struct hv_pci_dev *hpdev,
 		u8 buffer[sizeof(struct pci_delete_interrupt)];
 	} ctxt;
 
+	if (!int_desc->vector_count) {
+		kfree(int_desc);
+		return;
+	}
 	memset(&ctxt, 0, sizeof(ctxt));
 	int_pkt = (struct pci_delete_interrupt *)&ctxt.pkt.message;
 	int_pkt->message_type.type =
@@ -893,6 +897,28 @@ static void hv_irq_mask(struct irq_data *data)
 	pci_msi_mask_irq(data);
 }
 
+static unsigned int hv_msi_get_int_vector(struct irq_data *data)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+
+	return cfg->vector;
+}
+
+static int hv_msi_prepare(struct irq_domain *domain, struct device *dev,
+			  int nvec, msi_alloc_info_t *info)
+{
+	int ret = pci_msi_prepare(domain, dev, nvec, info);
+
+	/*
+	 * By using the interrupt remapper in the hypervisor IOMMU, contiguous
+	 * CPU vectors is not needed for multi-MSI
+	 */
+	if (info->type == X86_IRQ_ALLOC_TYPE_MSI)
+		info->flags &= ~X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
+
+	return ret;
+}
+
 /**
  * hv_irq_unmask() - "Unmask" the IRQ by setting its current
  * affinity.
@@ -908,6 +934,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	struct msi_desc *msi_desc = irq_data_get_msi_desc(data);
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct retarget_msi_interrupt *params;
+	struct tran_int_desc *int_desc;
 	struct hv_pcibus_device *hbus;
 	struct cpumask *dest;
 	struct pci_bus *pbus;
@@ -922,6 +949,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	pdev = msi_desc_to_pci_dev(msi_desc);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
+	int_desc = data->chip_data;
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -929,8 +957,8 @@ static void hv_irq_unmask(struct irq_data *data)
 	memset(params, 0, sizeof(*params));
 	params->partition_id = HV_PARTITION_ID_SELF;
 	params->int_entry.source = 1; /* MSI(-X) */
-	params->int_entry.address = msi_desc->msg.address_lo;
-	params->int_entry.data = msi_desc->msg.data;
+	params->int_entry.address = int_desc->address & 0xffffffff;
+	params->int_entry.data = int_desc->data;
 	params->device_id = (hbus->hdev->dev_instance.b[5] << 24) |
 			   (hbus->hdev->dev_instance.b[4] << 16) |
 			   (hbus->hdev->dev_instance.b[7] << 8) |
@@ -1018,12 +1046,12 @@ static void hv_pci_compose_compl(void *context, struct pci_response *resp,
 
 static u32 hv_compose_msi_req_v1(
 	struct pci_create_interrupt *int_pkt, struct cpumask *affinity,
-	u32 slot, u8 vector)
+	u32 slot, u8 vector, u8 vector_count)
 {
 	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE;
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = dest_Fixed;
 
 	/*
@@ -1037,14 +1065,14 @@ static u32 hv_compose_msi_req_v1(
 
 static u32 hv_compose_msi_req_v2(
 	struct pci_create_interrupt2 *int_pkt, struct cpumask *affinity,
-	u32 slot, u8 vector)
+	u32 slot, u8 vector, u8 vector_count)
 {
 	int cpu;
 
 	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE2;
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = dest_Fixed;
 
 	/*
@@ -1072,7 +1100,6 @@ static u32 hv_compose_msi_req_v2(
  */
 static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_pcibus_device *hbus;
 	struct hv_pci_dev *hpdev;
 	struct pci_bus *pbus;
@@ -1081,6 +1108,8 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	unsigned long flags;
 	struct compose_comp_ctxt comp;
 	struct tran_int_desc *int_desc;
+	struct msi_desc *msi_desc;
+	u8 vector, vector_count;
 	struct {
 		struct pci_packet pci_pkt;
 		union {
@@ -1092,7 +1121,17 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	u32 size;
 	int ret;
 
-	pdev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
+	/* Reuse the previous allocation */
+	if (data->chip_data) {
+		int_desc = data->chip_data;
+		msg->address_hi = int_desc->address >> 32;
+		msg->address_lo = int_desc->address & 0xffffffff;
+		msg->data = int_desc->data;
+		return;
+	}
+
+	msi_desc  = irq_data_get_msi_desc(data);
+	pdev = msi_desc_to_pci_dev(msi_desc);
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
@@ -1100,17 +1139,40 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	if (!hpdev)
 		goto return_null_message;
 
-	/* Free any previous message that might have already been composed. */
-	if (data->chip_data) {
-		int_desc = data->chip_data;
-		data->chip_data = NULL;
-		hv_int_desc_free(hpdev, int_desc);
-	}
-
 	int_desc = kzalloc(sizeof(*int_desc), GFP_ATOMIC);
 	if (!int_desc)
 		goto drop_reference;
 
+	if (!msi_desc->msi_attrib.is_msix && msi_desc->nvec_used > 1) {
+		/*
+		 * If this is not the first MSI of Multi MSI, we already have
+		 * a mapping.  Can exit early.
+		 */
+		if (msi_desc->irq != data->irq) {
+			data->chip_data = int_desc;
+			int_desc->address = msi_desc->msg.address_lo |
+					    (u64)msi_desc->msg.address_hi << 32;
+			int_desc->data = msi_desc->msg.data +
+					 (data->irq - msi_desc->irq);
+			msg->address_hi = msi_desc->msg.address_hi;
+			msg->address_lo = msi_desc->msg.address_lo;
+			msg->data = int_desc->data;
+			put_pcichild(hpdev);
+			return;
+		}
+		/*
+		 * The vector we select here is a dummy value.  The correct
+		 * value gets sent to the hypervisor in unmask().  This needs
+		 * to be aligned with the count, and also not zero.  Multi-msi
+		 * is powers of 2 up to 32, so 32 will always work here.
+		 */
+		vector = 32;
+		vector_count = msi_desc->nvec_used;
+	} else {
+		vector = hv_msi_get_int_vector(data);
+		vector_count = 1;
+	}
+
 	memset(&ctxt, 0, sizeof(ctxt));
 	init_completion(&comp.comp_pkt.host_event);
 	ctxt.pci_pkt.completion_func = hv_pci_compose_compl;
@@ -1121,14 +1183,16 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	case PCI_PROTOCOL_VERSION_1_2:
 		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	default:
@@ -1240,7 +1304,7 @@ static irq_hw_number_t hv_msi_domain_ops_get_hwirq(struct msi_domain_info *info,
 
 static struct msi_domain_ops hv_msi_ops = {
 	.get_hwirq	= hv_msi_domain_ops_get_hwirq,
-	.msi_prepare	= pci_msi_prepare,
+	.msi_prepare	= hv_msi_prepare,
 	.set_desc	= pci_msi_set_desc,
 	.msi_free	= hv_msi_free,
 };
diff --git a/drivers/power/reset/arm-versatile-reboot.c b/drivers/power/reset/arm-versatile-reboot.c
index 06d34ab47df5..8022c782f6ff 100644
--- a/drivers/power/reset/arm-versatile-reboot.c
+++ b/drivers/power/reset/arm-versatile-reboot.c
@@ -150,6 +150,7 @@ static int __init versatile_reboot_probe(void)
 	versatile_reboot_type = (enum versatile_reboot)reboot_id->data;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
diff --git a/drivers/s390/char/keyboard.h b/drivers/s390/char/keyboard.h
index c467589c7f45..c06d399b9b1f 100644
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -56,7 +56,7 @@ static inline void
 kbd_put_queue(struct tty_port *port, int ch)
 {
 	tty_insert_flip_char(port, ch, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static inline void
@@ -64,5 +64,5 @@ kbd_puts_queue(struct tty_port *port, char *cp)
 {
 	while (*cp)
 		tty_insert_flip_char(port, *cp++, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
diff --git a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
index ad811c0438cc..031526cb1b21 100644
--- a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
+++ b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
@@ -267,6 +267,8 @@ static int rt2880_pinmux_pins(struct rt2880_priv *p)
 						p->func[i]->pin_count,
 						sizeof(int),
 						GFP_KERNEL);
+		if (!p->func[i]->pins)
+			return -ENOMEM;
 		for (j = 0; j < p->func[i]->pin_count; j++)
 			p->func[i]->pins[j] = p->func[i]->pin_first + j;
 
diff --git a/drivers/staging/speakup/spk_ttyio.c b/drivers/staging/speakup/spk_ttyio.c
index 5c282e8522fb..8a44da5b0565 100644
--- a/drivers/staging/speakup/spk_ttyio.c
+++ b/drivers/staging/speakup/spk_ttyio.c
@@ -88,7 +88,7 @@ static int spk_ttyio_receive_buf2(struct tty_struct *tty,
 	}
 
 	if (!ldisc_data->buf_free)
-		/* ttyio_in will tty_schedule_flip */
+		/* ttyio_in will tty_flip_buffer_push */
 		return 0;
 
 	/* Make sure the consumer has read buf before we have seen
@@ -321,7 +321,7 @@ static unsigned char ttyio_in(int timeout)
 	mb();
 	ldisc_data->buf_free = true;
 	/* Let TTY push more characters */
-	tty_schedule_flip(speakup_tty->port);
+	tty_flip_buffer_push(speakup_tty->port);
 
 	return rv;
 }
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 6d3c58051ce3..db048dbe9f78 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -556,7 +556,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		}
 		info->idle_stats.recv_idle = jiffies;
 	}
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 
 	/* end of service */
 	cyy_writeb(info, CyRIR, save_xir & 0x3f);
@@ -996,7 +996,7 @@ static void cyz_handle_rx(struct cyclades_port *info)
 		mod_timer(&info->rx_full_timer, jiffies + 1);
 #endif
 	info->idle_stats.recv_idle = jiffies;
-	tty_schedule_flip(&info->port);
+	tty_flip_buffer_push(&info->port);
 
 	/* Update rx_get */
 	cy_writel(&buf_ctrl->rx_get, new_rx_get);
@@ -1172,7 +1172,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 		if (delta_count)
 			wake_up_interruptible(&info->port.delta_msr_wait);
 		if (special_count)
-			tty_schedule_flip(&info->port);
+			tty_flip_buffer_push(&info->port);
 	}
 }
 
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 9180ca5e4dcd..d6e82eb61fc2 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -151,7 +151,7 @@ static irqreturn_t goldfish_tty_interrupt(int irq, void *dev_id)
 	address = (unsigned long)(void *)buf;
 	goldfish_tty_rw(qtty, address, count, 0);
 
-	tty_schedule_flip(&qtty->port);
+	tty_flip_buffer_push(&qtty->port);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 250a19f042d7..181381fa5126 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1393,7 +1393,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		if (inited && !tty_throttled(tty) &&
 				MoxaPortRxQueue(p) > 0) { /* RX */
 			MoxaPortReadData(p);
-			tty_schedule_flip(&p->port);
+			tty_flip_buffer_push(&p->port);
 		}
 	} else {
 		clear_bit(EMPTYWAIT, &p->statusflags);
@@ -1418,7 +1418,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
 		tty_insert_flip_char(&p->port, 0, TTY_BREAK);
-		tty_schedule_flip(&p->port);
+		tty_flip_buffer_push(&p->port);
 	}
 
 	if (intr & IntrLine)
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index c6a1d8c4e689..73226e482e91 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -111,21 +111,11 @@ static void pty_unthrottle(struct tty_struct *tty)
 static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 {
 	struct tty_struct *to = tty->link;
-	unsigned long flags;
 
-	if (tty->stopped)
+	if (tty->stopped || !c)
 		return 0;
 
-	if (c > 0) {
-		spin_lock_irqsave(&to->port->lock, flags);
-		/* Stuff the data into the input queue of the other end */
-		c = tty_insert_flip_string(to->port, buf, c);
-		spin_unlock_irqrestore(&to->port->lock, flags);
-		/* And shovel */
-		if (c)
-			tty_flip_buffer_push(to->port);
-	}
-	return c;
+	return tty_insert_flip_string_and_push_buffer(to->port, buf, c);
 }
 
 /**
diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index d1d73261575b..9c145ed0dcf7 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -341,7 +341,7 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 		       LPC32XX_HSUART_IIR(port->membase));
 		port->icount.overrun++;
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
-		tty_schedule_flip(tport);
+		tty_flip_buffer_push(tport);
 	}
 
 	/* Data received? */
diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 77f3f3728a79..6449c156c4d6 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -442,14 +442,14 @@ static void mvebu_uart_shutdown(struct uart_port *port)
 	}
 }
 
-static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
+static unsigned int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 {
 	struct mvebu_uart *mvuart = to_mvuart(port);
 	unsigned int d_divisor, m_divisor;
 	u32 brdv;
 
 	if (IS_ERR(mvuart->clk))
-		return -PTR_ERR(mvuart->clk);
+		return 0;
 
 	/*
 	 * The baudrate is derived from the UART clock thanks to two divisors:
@@ -469,7 +469,7 @@ static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 	brdv |= d_divisor;
 	writel(brdv, port->membase + UART_BRDV);
 
-	return 0;
+	return DIV_ROUND_CLOSEST(port->uartclk, d_divisor * m_divisor);
 }
 
 static void mvebu_uart_set_termios(struct uart_port *port,
@@ -506,15 +506,11 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 	max_baud = 230400;
 
 	baud = uart_get_baud_rate(port, termios, old, min_baud, max_baud);
-	if (mvebu_uart_baud_rate_set(port, baud)) {
-		/* No clock available, baudrate cannot be changed */
-		if (old)
-			baud = uart_get_baud_rate(port, old, NULL,
-						  min_baud, max_baud);
-	} else {
-		tty_termios_encode_baud_rate(termios, baud, baud);
-		uart_update_timeout(port, termios->c_cflag, baud);
-	}
+	baud = mvebu_uart_baud_rate_set(port, baud);
+
+	/* In case baudrate cannot be changed, report previous old value */
+	if (baud == 0 && old)
+		baud = tty_termios_baud_rate(old);
 
 	/* Only the following flag changes are supported */
 	if (old) {
@@ -525,6 +521,11 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 		termios->c_cflag |= CS8;
 	}
 
+	if (baud != 0) {
+		tty_termios_encode_baud_rate(termios, baud, baud);
+		uart_update_timeout(port, termios->c_cflag, baud);
+	}
+
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index dfe0c8c22cd3..3ef4899c8f6a 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -389,27 +389,6 @@ int __tty_insert_flip_char(struct tty_port *port, unsigned char ch, char flag)
 }
 EXPORT_SYMBOL(__tty_insert_flip_char);
 
-/**
- *	tty_schedule_flip	-	push characters to ldisc
- *	@port: tty port to push from
- *
- *	Takes any pending buffers and transfers their ownership to the
- *	ldisc side of the queue. It then schedules those characters for
- *	processing by the line discipline.
- */
-
-void tty_schedule_flip(struct tty_port *port)
-{
-	struct tty_bufhead *buf = &port->buf;
-
-	/* paired w/ acquire in flush_to_ldisc(); ensures
-	 * flush_to_ldisc() sees buffer data.
-	 */
-	smp_store_release(&buf->tail->commit, buf->tail->used);
-	queue_work(system_unbound_wq, &buf->work);
-}
-EXPORT_SYMBOL(tty_schedule_flip);
-
 /**
  *	tty_prepare_flip_string		-	make room for characters
  *	@port: tty port
@@ -539,6 +518,15 @@ static void flush_to_ldisc(struct work_struct *work)
 
 }
 
+static inline void tty_flip_buffer_commit(struct tty_buffer *tail)
+{
+	/*
+	 * Paired w/ acquire in flush_to_ldisc(); ensures flush_to_ldisc() sees
+	 * buffer data.
+	 */
+	smp_store_release(&tail->commit, tail->used);
+}
+
 /**
  *	tty_flip_buffer_push	-	terminal
  *	@port: tty port to push
@@ -552,10 +540,44 @@ static void flush_to_ldisc(struct work_struct *work)
 
 void tty_flip_buffer_push(struct tty_port *port)
 {
-	tty_schedule_flip(port);
+	struct tty_bufhead *buf = &port->buf;
+
+	tty_flip_buffer_commit(buf->tail);
+	queue_work(system_unbound_wq, &buf->work);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);
 
+/**
+ * tty_insert_flip_string_and_push_buffer - add characters to the tty buffer and
+ *	push
+ * @port: tty port
+ * @chars: characters
+ * @size: size
+ *
+ * The function combines tty_insert_flip_string() and tty_flip_buffer_push()
+ * with the exception of properly holding the @port->lock.
+ *
+ * To be used only internally (by pty currently).
+ *
+ * Returns: the number added.
+ */
+int tty_insert_flip_string_and_push_buffer(struct tty_port *port,
+		const unsigned char *chars, size_t size)
+{
+	struct tty_bufhead *buf = &port->buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	size = tty_insert_flip_string(port, chars, size);
+	if (size)
+		tty_flip_buffer_commit(buf->tail);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	queue_work(system_unbound_wq, &buf->work);
+
+	return size;
+}
+
 /**
  *	tty_buffer_init		-	prepare a tty buffer structure
  *	@tty: tty to initialise
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 94cad9f86ff9..e3aac11d770f 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -310,7 +310,7 @@ int kbd_rate(struct kbd_repeat *rpt)
 static void put_queue(struct vc_data *vc, int ch)
 {
 	tty_insert_flip_char(&vc->port, ch, 0);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void puts_queue(struct vc_data *vc, char *cp)
@@ -319,7 +319,7 @@ static void puts_queue(struct vc_data *vc, char *cp)
 		tty_insert_flip_char(&vc->port, *cp, 0);
 		cp++;
 	}
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -564,7 +564,7 @@ static void fn_inc_console(struct vc_data *vc)
 static void fn_send_intr(struct vc_data *vc)
 {
 	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index dca627ccece5..20565603a365 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1838,7 +1838,7 @@ static void respond_string(const char *p, struct tty_port *port)
 		tty_insert_flip_char(port, *p, 0);
 		p++;
 	}
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static void cursor_report(struct vc_data *vc, struct tty_struct *tty)
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 492084814f55..27d955c5d9f9 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -416,7 +416,8 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset+i].status &&
+			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ac53403e9edb..35bfb681bf13 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4069,13 +4069,14 @@ static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
 	rv = _create_message(ls, sizeof(struct dlm_message) + len,
 			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
 	if (rv)
-		return;
+		goto out;
 
 	memcpy(ms->m_extra, name, len);
 	ms->m_hash = hash;
 
 	send_message(mh, ms);
 
+out:
 	spin_lock(&ls->ls_remove_spin);
 	ls->ls_remove_len = 0;
 	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 767f62086bd9..c326bfdb5ec2 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -12,7 +12,6 @@ extern int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 extern int tty_prepare_flip_string(struct tty_port *port,
 		unsigned char **chars, size_t size);
 extern void tty_flip_buffer_push(struct tty_port *port);
-void tty_schedule_flip(struct tty_port *port);
 int __tty_insert_flip_char(struct tty_port *port, unsigned char ch, char flag);
 
 static inline int tty_insert_flip_char(struct tty_port *port,
@@ -40,4 +39,7 @@ static inline int tty_insert_flip_string(struct tty_port *port,
 extern void tty_buffer_lock_exclusive(struct tty_port *port);
 extern void tty_buffer_unlock_exclusive(struct tty_port *port);
 
+int tty_insert_flip_string_and_push_buffer(struct tty_port *port,
+		const unsigned char *chars, size_t cnt);
+
 #endif /* _LINUX_TTY_FLIP_H */
diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index fabee6db0abb..421d41ef4e9c 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -370,6 +370,71 @@ static inline struct sk_buff *bt_skb_send_alloc(struct sock *sk,
 	return NULL;
 }
 
+/* Shall not be called with lock_sock held */
+static inline struct sk_buff *bt_skb_sendmsg(struct sock *sk,
+					     struct msghdr *msg,
+					     size_t len, size_t mtu,
+					     size_t headroom, size_t tailroom)
+{
+	struct sk_buff *skb;
+	size_t size = min_t(size_t, len, mtu);
+	int err;
+
+	skb = bt_skb_send_alloc(sk, size + headroom + tailroom,
+				msg->msg_flags & MSG_DONTWAIT, &err);
+	if (!skb)
+		return ERR_PTR(err);
+
+	skb_reserve(skb, headroom);
+	skb_tailroom_reserve(skb, mtu, tailroom);
+
+	if (!copy_from_iter_full(skb_put(skb, size), size, &msg->msg_iter)) {
+		kfree_skb(skb);
+		return ERR_PTR(-EFAULT);
+	}
+
+	skb->priority = sk->sk_priority;
+
+	return skb;
+}
+
+/* Similar to bt_skb_sendmsg but can split the msg into multiple fragments
+ * accourding to the MTU.
+ */
+static inline struct sk_buff *bt_skb_sendmmsg(struct sock *sk,
+					      struct msghdr *msg,
+					      size_t len, size_t mtu,
+					      size_t headroom, size_t tailroom)
+{
+	struct sk_buff *skb, **frag;
+
+	skb = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
+	if (IS_ERR_OR_NULL(skb))
+		return skb;
+
+	len -= skb->len;
+	if (!len)
+		return skb;
+
+	/* Add remaining data over MTU as continuation fragments */
+	frag = &skb_shinfo(skb)->frag_list;
+	while (len) {
+		struct sk_buff *tmp;
+
+		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
+		if (IS_ERR(tmp)) {
+			return skb;
+		}
+
+		len -= tmp->len;
+
+		*frag = tmp;
+		frag = &(*frag)->next;
+	}
+
+	return skb;
+}
+
 int bt_to_errno(u16 code);
 
 void hci_sock_set_flag(struct sock *sk, int nr);
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index a80fd0ac4563..d5552ff1d361 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -111,7 +111,8 @@ static inline struct inet_request_sock *inet_rsk(const struct request_sock *sk)
 
 static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 {
-	if (!sk->sk_mark && sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept)
+	if (!sk->sk_mark &&
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept))
 		return skb->mark;
 
 	return sk->sk_mark;
@@ -357,7 +358,7 @@ static inline bool inet_get_convert_csum(struct sock *sk)
 static inline bool inet_can_nonlocal_bind(struct net *net,
 					  struct inet_sock *inet)
 {
-	return net->ipv4.sysctl_ip_nonlocal_bind ||
+	return READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind) ||
 		inet->freebind || inet->transparent;
 }
 
diff --git a/include/net/ip.h b/include/net/ip.h
index d1a4efedbc03..0f820e68bd8f 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -341,7 +341,7 @@ void ipfrag_init(void);
 void ip_static_sysctl_init(void);
 
 #define IP4_REPLY_MARK(net, mark) \
-	((net)->ipv4.sysctl_fwmark_reflect ? (mark) : 0)
+	(READ_ONCE((net)->ipv4.sysctl_fwmark_reflect) ? (mark) : 0)
 
 static inline bool ip_is_fragment(const struct iphdr *iph)
 {
@@ -402,7 +402,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	struct net *net = dev_net(dst->dev);
 	unsigned int mtu;
 
-	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding)
 		return dst_mtu(dst);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5c5807ed66ee..d28fa78dedb5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1339,8 +1339,8 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	s32 delta;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
-	    ca_ops->cong_control)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) ||
+	    tp->packets_out || ca_ops->cong_control)
 		return;
 	delta = tcp_jiffies32 - tp->lsndtime;
 	if (delta > inet_csk(sk)->icsk_rto)
@@ -1430,7 +1430,8 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
 
 static inline int tcp_fin_time(const struct sock *sk)
 {
-	int fin_timeout = tcp_sk(sk)->linger2 ? : sock_net(sk)->ipv4.sysctl_tcp_fin_timeout;
+	int fin_timeout = tcp_sk(sk)->linger2 ? :
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fin_timeout);
 	const int rto = inet_csk(sk)->icsk_rto;
 
 	if (fin_timeout < (rto << 2) - (rto >> 1))
@@ -1875,7 +1876,7 @@ void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
 static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
-	return tp->notsent_lowat ?: net->ipv4.sysctl_tcp_notsent_lowat;
+	return tp->notsent_lowat ?: READ_ONCE(net->ipv4.sysctl_tcp_notsent_lowat);
 }
 
 static inline bool tcp_stream_memory_free(const struct sock *sk)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 4e5b5ae05406..cbbd0168f50c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -66,11 +66,13 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
 {
 	u8 *ptr = NULL;
 
-	if (k >= SKF_NET_OFF)
+	if (k >= SKF_NET_OFF) {
 		ptr = skb_network_header(skb) + k - SKF_NET_OFF;
-	else if (k >= SKF_LL_OFF)
+	} else if (k >= SKF_LL_OFF) {
+		if (unlikely(!skb_mac_header_was_set(skb)))
+			return NULL;
 		ptr = skb_mac_header(skb) + k - SKF_LL_OFF;
-
+	}
 	if (ptr >= skb->head && ptr + size <= skb_tail_pointer(skb))
 		return ptr;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 88dd1398ae88..ba66ea3ca705 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5719,10 +5719,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
 			/*
-			 * Raced against perf_mmap_close() through
-			 * perf_event_set_output(). Try again, hope for better
-			 * luck.
+			 * Raced against perf_mmap_close(); remove the
+			 * event and try again.
 			 */
+			ring_buffer_attach(event, NULL);
 			mutex_unlock(&event->mmap_mutex);
 			goto again;
 		}
@@ -10396,14 +10396,25 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	goto out;
 }
 
+static void mutex_lock_double(struct mutex *a, struct mutex *b)
+{
+	if (b < a)
+		swap(a, b);
+
+	mutex_lock(a);
+	mutex_lock_nested(b, SINGLE_DEPTH_NESTING);
+}
+
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
 	struct ring_buffer *rb = NULL;
 	int ret = -EINVAL;
 
-	if (!output_event)
+	if (!output_event) {
+		mutex_lock(&event->mmap_mutex);
 		goto set;
+	}
 
 	/* don't allow circular references */
 	if (event == output_event)
@@ -10441,8 +10452,15 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	    event->pmu != output_event->pmu)
 		goto out;
 
+	/*
+	 * Hold both mmap_mutex to serialize against perf_mmap_close().  Since
+	 * output_event is already on rb->event_list, and the list iteration
+	 * restarts after every removal, it is guaranteed this new event is
+	 * observed *OR* if output_event is already removed, it's guaranteed we
+	 * observe !rb->mmap_count.
+	 */
+	mutex_lock_double(&event->mmap_mutex, &output_event->mmap_mutex);
 set:
-	mutex_lock(&event->mmap_mutex);
 	/* Can't redirect output if we've got an active mmap() */
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
@@ -10452,6 +10470,12 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 		rb = ring_buffer_get(output_event);
 		if (!rb)
 			goto unlock;
+
+		/* did we race against perf_mmap_close() */
+		if (!atomic_read(&rb->mmap_count)) {
+			ring_buffer_put(rb);
+			goto unlock;
+		}
 	}
 
 	ring_buffer_attach(event, rb);
@@ -10459,20 +10483,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
+	if (output_event)
+		mutex_unlock(&output_event->mmap_mutex);
 
 out:
 	return ret;
 }
 
-static void mutex_lock_double(struct mutex *a, struct mutex *b)
-{
-	if (b < a)
-		swap(a, b);
-
-	mutex_lock(a);
-	mutex_lock_nested(b, SINGLE_DEPTH_NESTING);
-}
-
 static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 {
 	bool nmi_safe = false;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5ada8897ef0e..e44e737e90a3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -348,7 +348,7 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
  */
 static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
 {
-	if (!pol)
+	if (!pol || pol->mode == MPOL_LOCAL)
 		return;
 	if (!mpol_store_user_nodemask(pol) && !(pol->flags & MPOL_F_LOCAL) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index b98225d65e87..e4eaf5d2acbd 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -552,22 +552,58 @@ struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel)
 	return dlc;
 }
 
+static int rfcomm_dlc_send_frag(struct rfcomm_dlc *d, struct sk_buff *frag)
+{
+	int len = frag->len;
+
+	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+
+	if (len > d->mtu)
+		return -EINVAL;
+
+	rfcomm_make_uih(frag, d->addr);
+	__skb_queue_tail(&d->tx_queue, frag);
+
+	return len;
+}
+
 int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
-	int len = skb->len;
+	unsigned long flags;
+	struct sk_buff *frag, *next;
+	int len;
 
 	if (d->state != BT_CONNECTED)
 		return -ENOTCONN;
 
-	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+	frag = skb_shinfo(skb)->frag_list;
+	skb_shinfo(skb)->frag_list = NULL;
 
-	if (len > d->mtu)
-		return -EINVAL;
+	/* Queue all fragments atomically. */
+	spin_lock_irqsave(&d->tx_queue.lock, flags);
 
-	rfcomm_make_uih(skb, d->addr);
-	skb_queue_tail(&d->tx_queue, skb);
+	len = rfcomm_dlc_send_frag(d, skb);
+	if (len < 0 || !frag)
+		goto unlock;
+
+	for (; frag; frag = next) {
+		int ret;
+
+		next = frag->next;
+
+		ret = rfcomm_dlc_send_frag(d, frag);
+		if (ret < 0) {
+			kfree_skb(frag);
+			goto unlock;
+		}
+
+		len += ret;
+	}
+
+unlock:
+	spin_unlock_irqrestore(&d->tx_queue.lock, flags);
 
-	if (!test_bit(RFCOMM_TX_THROTTLED, &d->flags))
+	if (len > 0 && !test_bit(RFCOMM_TX_THROTTLED, &d->flags))
 		rfcomm_schedule();
 	return len;
 }
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index c044ff2f73e6..78830efe89d7 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -578,46 +578,20 @@ static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	lock_sock(sk);
 
 	sent = bt_sock_wait_ready(sk, msg->msg_flags);
-	if (sent)
-		goto done;
-
-	while (len) {
-		size_t size = min_t(size_t, len, d->mtu);
-		int err;
-
-		skb = sock_alloc_send_skb(sk, size + RFCOMM_SKB_RESERVE,
-				msg->msg_flags & MSG_DONTWAIT, &err);
-		if (!skb) {
-			if (sent == 0)
-				sent = err;
-			break;
-		}
-		skb_reserve(skb, RFCOMM_SKB_HEAD_RESERVE);
-
-		err = memcpy_from_msg(skb_put(skb, size), msg, size);
-		if (err) {
-			kfree_skb(skb);
-			if (sent == 0)
-				sent = err;
-			break;
-		}
 
-		skb->priority = sk->sk_priority;
+	release_sock(sk);
 
-		err = rfcomm_dlc_send(d, skb);
-		if (err < 0) {
-			kfree_skb(skb);
-			if (sent == 0)
-				sent = err;
-			break;
-		}
+	if (sent)
+		return sent;
 
-		sent += size;
-		len  -= size;
-	}
+	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
+			      RFCOMM_SKB_TAIL_RESERVE);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
 
-done:
-	release_sock(sk);
+	sent = rfcomm_dlc_send(d, skb);
+	if (sent < 0)
+		kfree_skb(skb);
 
 	return sent;
 }
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 14b5288d1432..ee321d62b7d6 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -279,12 +279,10 @@ static int sco_connect(struct hci_dev *hdev, struct sock *sk)
 	return err;
 }
 
-static int sco_send_frame(struct sock *sk, void *buf, int len,
-			  unsigned int msg_flags)
+static int sco_send_frame(struct sock *sk, struct sk_buff *skb)
 {
 	struct sco_conn *conn = sco_pi(sk)->conn;
-	struct sk_buff *skb;
-	int err;
+	int len = skb->len;
 
 	/* Check outgoing MTU */
 	if (len > conn->mtu)
@@ -292,11 +290,6 @@ static int sco_send_frame(struct sock *sk, void *buf, int len,
 
 	BT_DBG("sk %p len %d", sk, len);
 
-	skb = bt_skb_send_alloc(sk, len, msg_flags & MSG_DONTWAIT, &err);
-	if (!skb)
-		return err;
-
-	memcpy(skb_put(skb, len), buf, len);
 	hci_send_sco(conn->hcon, skb);
 
 	return len;
@@ -715,7 +708,7 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len)
 {
 	struct sock *sk = sock->sk;
-	void *buf;
+	struct sk_buff *skb;
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -727,24 +720,21 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (memcpy_from_msg(buf, msg, len)) {
-		kfree(buf);
-		return -EFAULT;
-	}
+	skb = bt_skb_sendmsg(sk, msg, len, len, 0, 0);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
 
 	lock_sock(sk);
 
 	if (sk->sk_state == BT_CONNECTED)
-		err = sco_send_frame(sk, buf, len, msg->msg_flags);
+		err = sco_send_frame(sk, skb);
 	else
 		err = -ENOTCONN;
 
 	release_sock(sk);
-	kfree(buf);
+
+	if (err < 0)
+		kfree_skb(skb);
 	return err;
 }
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index dadd42a07c07..229519001cc3 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -218,7 +218,7 @@ int inet_listen(struct socket *sock, int backlog)
 		 * because the socket was in TCP_LISTEN state previously but
 		 * was shutdown() rather than close().
 		 */
-		tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
+		tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
 		if ((tcp_fastopen & TFO_SERVER_WO_SOCKOPT1) &&
 		    (tcp_fastopen & TFO_SERVER_ENABLE) &&
 		    !inet_csk(sk)->icsk_accept_queue.fastopenq.max_qlen) {
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index ee179e08dd20..b831825f234f 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -471,7 +471,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ip_mc_list *pmc,
 
 	if (pmc->multiaddr == IGMP_ALL_HOSTS)
 		return skb;
-	if (ipv4_is_local_multicast(pmc->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(pmc->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -597,7 +598,7 @@ static int igmpv3_send_report(struct in_device *in_dev, struct ip_mc_list *pmc)
 			if (pmc->multiaddr == IGMP_ALL_HOSTS)
 				continue;
 			if (ipv4_is_local_multicast(pmc->multiaddr) &&
-			     !net->ipv4.sysctl_igmp_llm_reports)
+			    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 				continue;
 			spin_lock_bh(&pmc->lock);
 			if (pmc->sfcount[MCAST_EXCLUDE])
@@ -740,7 +741,8 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	if (type == IGMPV3_HOST_MEMBERSHIP_REPORT)
 		return igmpv3_send_report(in_dev, pmc);
 
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return 0;
 
 	if (type == IGMP_HOST_LEAVE_MESSAGE)
@@ -924,7 +926,8 @@ static bool igmp_heard_report(struct in_device *in_dev, __be32 group)
 
 	if (group == IGMP_ALL_HOSTS)
 		return false;
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return false;
 
 	rcu_read_lock();
@@ -1049,7 +1052,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 		spin_lock_bh(&im->lock);
 		if (im->tm_running)
@@ -1299,7 +1302,8 @@ static void igmp_group_dropped(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	reporter = im->reporter;
@@ -1336,7 +1340,8 @@ static void igmp_group_added(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	if (in_dev->dead)
@@ -1657,7 +1662,7 @@ static void ip_mc_rejoin_groups(struct in_device *in_dev)
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 
 		/* a failover is happening and switches
@@ -2207,7 +2212,7 @@ static int __ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr,
 		count++;
 	}
 	err = -ENOBUFS;
-	if (count >= net->ipv4.sysctl_igmp_max_memberships)
+	if (count >= READ_ONCE(net->ipv4.sysctl_igmp_max_memberships))
 		goto done;
 	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL);
 	if (!iml)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d7f17581df7d..57e2316529d0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1419,7 +1419,7 @@ u32 ip_mtu_from_fib_result(struct fib_result *res, __be32 daddr)
 	struct net_device *dev = nh->nh_dev;
 	u32 mtu = 0;
 
-	if (dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    fi->fib_metrics->metrics[RTAX_LOCK - 1] & (1 << RTAX_MTU))
 		mtu = fi->fib_mtu;
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f7795488b0ad..7acc0d07f148 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -436,7 +436,7 @@ void tcp_init_sock(struct sock *sk)
 	tp->snd_cwnd_clamp = ~0;
 	tp->mss_cache = TCP_MSS_DEFAULT;
 
-	tp->reordering = sock_net(sk)->ipv4.sysctl_tcp_reordering;
+	tp->reordering = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering);
 	tcp_assign_congestion_control(sk);
 
 	tp->tsoffset = 0;
@@ -1160,7 +1160,8 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 	struct sockaddr *uaddr = msg->msg_name;
 	int err, flags;
 
-	if (!(sock_net(sk)->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) ||
+	if (!(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) &
+	      TFO_CLIENT_ENABLE) ||
 	    (uaddr && msg->msg_namelen >= sizeof(uaddr->sa_family) &&
 	     uaddr->sa_family == AF_UNSPEC))
 		return -EOPNOTSUPP;
@@ -3056,7 +3057,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 	case TCP_FASTOPEN_CONNECT:
 		if (val > 1 || val < 0) {
 			err = -EINVAL;
-		} else if (net->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) {
+		} else if (READ_ONCE(net->ipv4.sysctl_tcp_fastopen) &
+			   TFO_CLIENT_ENABLE) {
 			if (sk->sk_state == TCP_CLOSE)
 				tp->fastopen_connect = val;
 			else
@@ -3386,7 +3388,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	case TCP_LINGER2:
 		val = tp->linger2;
 		if (val >= 0)
-			val = (val ? : net->ipv4.sysctl_tcp_fin_timeout) / HZ;
+			val = (val ? : READ_ONCE(net->ipv4.sysctl_tcp_fin_timeout)) / HZ;
 		break;
 	case TCP_DEFER_ACCEPT:
 		val = retrans_to_secs(icsk->icsk_accept_queue.rskq_defer_accept,
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 119d2c2f3b04..f726591de7c7 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -313,7 +313,7 @@ static bool tcp_fastopen_no_cookie(const struct sock *sk,
 				   const struct dst_entry *dst,
 				   int flag)
 {
-	return (sock_net(sk)->ipv4.sysctl_tcp_fastopen & flag) ||
+	return (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) & flag) ||
 	       tcp_sk(sk)->fastopen_no_cookie ||
 	       (dst && dst_metric(dst, RTAX_FASTOPEN_NO_COOKIE));
 }
@@ -328,7 +328,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 			      const struct dst_entry *dst)
 {
 	bool syn_data = TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq + 1;
-	int tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
+	int tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
 	struct tcp_fastopen_cookie valid_foc = { .len = -1 };
 	struct sock *child;
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 92f5068c7680..26f0994da31b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -893,7 +893,7 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 			 tp->undo_marker ? tp->undo_retrans : 0);
 #endif
 		tp->reordering = min_t(u32, (metric + mss - 1) / mss,
-				       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+				       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	}
 
 	/* This exciting event is worth to be remembered. 8) */
@@ -1878,7 +1878,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 		return;
 
 	tp->reordering = min_t(u32, tp->packets_out + addend,
-			       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	tp->reord_seen++;
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRENOREORDER);
 }
@@ -1938,7 +1938,8 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
 
 static bool tcp_is_rack(const struct sock *sk)
 {
-	return sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION;
+	return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		TCP_RACK_LOSS_DETECTION;
 }
 
 /* If we detect SACK reneging, forget all SACK information
@@ -1982,6 +1983,7 @@ void tcp_enter_loss(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	bool new_recovery = icsk->icsk_ca_state < TCP_CA_Recovery;
+	u8 reordering;
 
 	tcp_timeout_mark_lost(sk);
 
@@ -2002,10 +2004,12 @@ void tcp_enter_loss(struct sock *sk)
 	/* Timeout in disordered state after receiving substantial DUPACKs
 	 * suggests that the degree of reordering is over-estimated.
 	 */
+	reordering = READ_ONCE(net->ipv4.sysctl_tcp_reordering);
 	if (icsk->icsk_ca_state <= TCP_CA_Disorder &&
-	    tp->sacked_out >= net->ipv4.sysctl_tcp_reordering)
+	    tp->sacked_out >= reordering)
 		tp->reordering = min_t(unsigned int, tp->reordering,
-				       net->ipv4.sysctl_tcp_reordering);
+				       reordering);
+
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
 	tcp_ecn_queue_cwr(tp);
@@ -3303,7 +3307,8 @@ static inline bool tcp_may_raise_cwnd(const struct sock *sk, const int flag)
 	 * new SACK or ECE mark may first advance cwnd here and later reduce
 	 * cwnd in tcp_fastretrans_alert() based on more states.
 	 */
-	if (tcp_sk(sk)->reordering > sock_net(sk)->ipv4.sysctl_tcp_reordering)
+	if (tcp_sk(sk)->reordering >
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering))
 		return flag & FLAG_FORWARD_PROGRESS;
 
 	return flag & FLAG_DATA_ACKED;
@@ -5287,7 +5292,7 @@ static void tcp_check_urg(struct sock *sk, const struct tcphdr *th)
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 ptr = ntohs(th->urg_ptr);
 
-	if (ptr && !sock_net(sk)->ipv4.sysctl_tcp_stdurg)
+	if (ptr && !READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_stdurg))
 		ptr--;
 	ptr += ntohl(th->seq);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2719c60f285b..ddc1af8731e3 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -110,10 +110,10 @@ static u32 tcp_v4_init_ts_off(const struct net *net, const struct sk_buff *skb)
 
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 {
+	int reuse = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tw_reuse);
 	const struct inet_timewait_sock *tw = inet_twsk(sktw);
 	const struct tcp_timewait_sock *tcptw = tcp_twsk(sktw);
 	struct tcp_sock *tp = tcp_sk(sk);
-	int reuse = sock_net(sk)->ipv4.sysctl_tcp_tw_reuse;
 
 	if (reuse == 2) {
 		/* Still does not detect *everything* that goes through
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 03b51cdcc731..61843c6d7a47 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -425,7 +425,8 @@ void tcp_update_metrics(struct sock *sk)
 		if (!tcp_metric_locked(tm, TCP_METRIC_REORDERING)) {
 			val = tcp_metric_get(tm, TCP_METRIC_REORDERING);
 			if (val < tp->reordering &&
-			    tp->reordering != net->ipv4.sysctl_tcp_reordering)
+			    tp->reordering !=
+			    READ_ONCE(net->ipv4.sysctl_tcp_reordering))
 				tcp_metric_set(tm, TCP_METRIC_REORDERING,
 					       tp->reordering);
 		}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c79cb949da66..0fc238d79b03 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -179,7 +179,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			 * Oh well... nobody has a sufficient solution to this
 			 * protocol bug yet.
 			 */
-			if (twsk_net(tw)->ipv4.sysctl_tcp_rfc1337 == 0) {
+			if (!READ_ONCE(twsk_net(tw)->ipv4.sysctl_tcp_rfc1337)) {
 kill:
 				inet_twsk_deschedule_put(tw);
 				return TCP_TW_SUCCESS;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 25dbdb27a571..13d9e8570ce5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1523,7 +1523,7 @@ void tcp_mtup_init(struct sock *sk)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
 
-	icsk->icsk_mtup.enabled = net->ipv4.sysctl_tcp_mtu_probing > 1;
+	icsk->icsk_mtup.enabled = READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing) > 1;
 	icsk->icsk_mtup.search_high = tp->rx_opt.mss_clamp + sizeof(struct tcphdr) +
 			       icsk->icsk_af_ops->net_header_len;
 	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, net->ipv4.sysctl_tcp_base_mss);
@@ -1658,7 +1658,7 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 		if (tp->packets_out > tp->snd_cwnd_used)
 			tp->snd_cwnd_used = tp->packets_out;
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle &&
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) &&
 		    (s32)(tcp_jiffies32 - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto &&
 		    !ca_ops->cong_control)
 			tcp_cwnd_application_limited(sk);
@@ -2030,7 +2030,7 @@ static inline void tcp_mtu_check_reprobe(struct sock *sk)
 	u32 interval;
 	s32 delta;
 
-	interval = net->ipv4.sysctl_tcp_probe_interval;
+	interval = READ_ONCE(net->ipv4.sysctl_tcp_probe_interval);
 	delta = tcp_jiffies32 - icsk->icsk_mtup.probe_timestamp;
 	if (unlikely(delta >= interval * HZ)) {
 		int mss = tcp_current_mss(sk);
@@ -2112,7 +2112,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	 * probing process by not resetting search range to its orignal.
 	 */
 	if (probe_size > tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_high) ||
-		interval < net->ipv4.sysctl_tcp_probe_threshold) {
+	    interval < READ_ONCE(net->ipv4.sysctl_tcp_probe_threshold)) {
 		/* Check whether enough time has elaplased for
 		 * another round of probing.
 		 */
@@ -2454,7 +2454,7 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	if (tp->fastopen_rsk)
 		return false;
 
-	early_retrans = sock_net(sk)->ipv4.sysctl_tcp_early_retrans;
+	early_retrans = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_early_retrans);
 	/* Schedule a loss probe in 2*RTT for SACK capable connections
 	 * not in loss recovery, that are either limited by cwnd or application.
 	 */
@@ -2816,7 +2816,7 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
 	struct sk_buff *skb = to, *tmp;
 	bool first = true;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_retrans_collapse)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_retrans_collapse))
 		return;
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		return;
@@ -3776,7 +3776,7 @@ void tcp_send_probe0(struct sock *sk)
 	}
 
 	if (err <= 0) {
-		if (icsk->icsk_backoff < net->ipv4.sysctl_tcp_retries2)
+		if (icsk->icsk_backoff < READ_ONCE(net->ipv4.sysctl_tcp_retries2))
 			icsk->icsk_backoff++;
 		icsk->icsk_probes_out++;
 		probe_max = TCP_RTO_MAX;
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 0d96decba13d..61969bb9395c 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -33,7 +33,8 @@ static u32 tcp_rack_reo_wnd(const struct sock *sk)
 			return 0;
 
 		if (tp->sacked_out >= tp->reordering &&
-		    !(sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_NO_DUPTHRESH))
+		    !(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		      TCP_RACK_NO_DUPTHRESH))
 			return 0;
 	}
 
@@ -203,7 +204,8 @@ void tcp_rack_update_reo_wnd(struct sock *sk, struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_STATIC_REO_WND ||
+	if ((READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+	     TCP_RACK_STATIC_REO_WND) ||
 	    !rs->prior_delivered)
 		return;
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index d071ed6b8b9a..84069db0423a 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -124,7 +124,7 @@ static int tcp_out_of_resources(struct sock *sk, bool do_reset)
  */
 static int tcp_orphan_retries(struct sock *sk, bool alive)
 {
-	int retries = sock_net(sk)->ipv4.sysctl_tcp_orphan_retries; /* May be zero. */
+	int retries = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_orphan_retries); /* May be zero. */
 
 	/* We know from an ICMP that something is wrong. */
 	if (sk->sk_err_soft && !alive)
@@ -144,7 +144,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 	int mss;
 
 	/* Black hole detection */
-	if (!net->ipv4.sysctl_tcp_mtu_probing)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing))
 		return;
 
 	if (!icsk->icsk_mtup.enabled) {
@@ -226,7 +226,7 @@ static int tcp_write_timeout(struct sock *sk)
 		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
 		expired = icsk->icsk_retransmits >= retry_until;
 	} else {
-		if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
+		if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1), 0)) {
 			/* Black hole detection */
 			tcp_mtu_probing(icsk, sk);
 
@@ -235,7 +235,7 @@ static int tcp_write_timeout(struct sock *sk)
 			sk_rethink_txhash(sk);
 		}
 
-		retry_until = net->ipv4.sysctl_tcp_retries2;
+		retry_until = READ_ONCE(net->ipv4.sysctl_tcp_retries2);
 		if (sock_flag(sk, SOCK_DEAD)) {
 			const bool alive = icsk->icsk_rto < TCP_RTO_MAX;
 
@@ -362,7 +362,7 @@ static void tcp_probe_timer(struct sock *sk)
 		 (s32)(tcp_time_stamp(tp) - start_ts) > icsk->icsk_user_timeout)
 		goto abort;
 
-	max_probes = sock_net(sk)->ipv4.sysctl_tcp_retries2;
+	max_probes = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_retries2);
 	if (sock_flag(sk, SOCK_DEAD)) {
 		const bool alive = inet_csk_rto_backoff(icsk, TCP_RTO_MAX) < TCP_RTO_MAX;
 
@@ -545,7 +545,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	 * linear-timeout retransmissions into a black hole
 	 */
 	if (sk->sk_state == TCP_ESTABLISHED &&
-	    (tp->thin_lto || net->ipv4.sysctl_tcp_thin_linear_timeouts) &&
+	    (tp->thin_lto || READ_ONCE(net->ipv4.sysctl_tcp_thin_linear_timeouts)) &&
 	    tcp_stream_is_thin(tp) &&
 	    icsk->icsk_retransmits <= TCP_THIN_LINEAR_RETRIES) {
 		icsk->icsk_backoff = 0;
@@ -556,7 +556,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	}
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
 				  tcp_clamp_rto_to_user_timeout(sk), TCP_RTO_MAX);
-	if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1 + 1, 0))
+	if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1) + 1, 0))
 		__sk_dst_reset(sk);
 
 out:;
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 7207a9769f1a..8db8209c5b61 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -373,7 +373,7 @@ static int sctp_v4_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (addr->v4.sin_addr.s_addr != htonl(INADDR_ANY) &&
 	   ret != RTN_LOCAL &&
 	   !sp->inet.freebind &&
-	   !net->ipv4.sysctl_ip_nonlocal_bind)
+	    !READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind))
 		return 0;
 
 	if (ipv6_only_sock(sctp_opt2sk(sp)))
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 228e3ce48d43..b290eb3ae155 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -110,13 +110,16 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
+	if (unlikely(!refcount_dec_and_test(&ctx->refcount)))
+		goto unlock;
+
 	list_move_tail(&ctx->list, &tls_device_gc_list);
 
 	/* schedule_work inside the spinlock
 	 * to make sure tls_device_down waits for that work.
 	 */
 	schedule_work(&tls_device_gc_work);
-
+unlock:
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 }
 
@@ -214,8 +217,7 @@ void tls_device_sk_destruct(struct sock *sk)
 		clean_acked_data_disable(inet_csk(sk));
 	}
 
-	if (refcount_dec_and_test(&tls_ctx->refcount))
-		tls_device_queue_ctx_destruction(tls_ctx);
+	tls_device_queue_ctx_destruction(tls_ctx);
 }
 EXPORT_SYMBOL(tls_device_sk_destruct);
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index bb1c94e20e82..3582f77bab6a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1697,8 +1697,10 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		*num_xfrms = 0;
 		return 0;
 	}
-	if (IS_ERR(pols[0]))
+	if (IS_ERR(pols[0])) {
+		*num_pols = 0;
 		return PTR_ERR(pols[0]);
+	}
 
 	*num_xfrms = pols[0]->xfrm_nr;
 
@@ -1713,6 +1715,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				xfrm_pols_put(pols, *num_pols);
+				*num_pols = 0;
 				return PTR_ERR(pols[1]);
 			}
 			(*num_pols)++;
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 5095b2e8fcee..3ec45028a8c5 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -68,10 +68,9 @@ choice
 	  hash, defined as 20 bytes, and a null terminated pathname,
 	  limited to 255 characters.  The 'ima-ng' measurement list
 	  template permits both larger hash digests and longer
-	  pathnames.
+	  pathnames. The configured default template can be replaced
+	  by specifying "ima_template=" on the boot command line.
 
-	config IMA_TEMPLATE
-		bool "ima"
 	config IMA_NG_TEMPLATE
 		bool "ima-ng (default)"
 	config IMA_SIG_TEMPLATE
@@ -81,7 +80,6 @@ endchoice
 config IMA_DEFAULT_TEMPLATE
 	string
 	depends on IMA
-	default "ima" if IMA_TEMPLATE
 	default "ima-ng" if IMA_NG_TEMPLATE
 	default "ima-sig" if IMA_SIG_TEMPLATE
 
@@ -101,15 +99,15 @@ choice
 
 	config IMA_DEFAULT_HASH_SHA256
 		bool "SHA256"
-		depends on CRYPTO_SHA256=y && !IMA_TEMPLATE
+		depends on CRYPTO_SHA256=y
 
 	config IMA_DEFAULT_HASH_SHA512
 		bool "SHA512"
-		depends on CRYPTO_SHA512=y && !IMA_TEMPLATE
+		depends on CRYPTO_SHA512=y
 
 	config IMA_DEFAULT_HASH_WP512
 		bool "WP512"
-		depends on CRYPTO_WP512=y && !IMA_TEMPLATE
+		depends on CRYPTO_WP512=y
 endchoice
 
 config IMA_DEFAULT_HASH
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 753d5fc4b284..81a171668f42 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -179,6 +179,7 @@ int snd_dma_alloc_pages(int type, struct device *device, size_t size,
 	if (WARN_ON(!dmab))
 		return -ENXIO;
 
+	size = PAGE_ALIGN(size);
 	dmab->dev.type = type;
 	dmab->dev.dev = device;
 	dmab->bytes = 0;
