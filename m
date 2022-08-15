Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D46593996
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbiHOSnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244074AbiHOSmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A752F39B;
        Mon, 15 Aug 2022 11:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5365660693;
        Mon, 15 Aug 2022 18:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5042EC433C1;
        Mon, 15 Aug 2022 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587950;
        bh=7kTuRjWeXotfCma1C7/3Cu45ZAi4uAA33+Sq6BvAK7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwdK1Wnb/wmsvLDAR5b5l5iSB9uBCLT7H1kzkNnR6nQtw3hGGG6C9JeHjdKmkyWd3
         cr2RstdO+b3nv2nhozi8qFK3I/cuUsePbdIMWRZo8kZcaiT4DmB6lgZb9vcPOs+RNN
         DkPMDg5WZEa/DLnkB+5iI7DI2C+8ytNQXMiqg6Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/779] drm/meson: encoder_hdmi: switch to bridge DRM_BRIDGE_ATTACH_NO_CONNECTOR
Date:   Mon, 15 Aug 2022 19:58:11 +0200
Message-Id: <20220815180347.894058731@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 0af5e0b41110e2da872030395231ab19c45be931 ]

This implements the necessary change to no more use the embedded
connector in dw-hdmi and use the dedicated bridge connector driver
by passing DRM_BRIDGE_ATTACH_NO_CONNECTOR to the bridge attach call.

The necessary connector properties are added to handle the same
functionalities as the embedded dw-hdmi connector, i.e. the HDR
metadata, the CEC notifier & other flags.

The dw-hdmi output_port is set to 1 in order to look for a connector
next bridge in order to get DRM_BRIDGE_ATTACH_NO_CONNECTOR working.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211020123947.2585572-5-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/Kconfig              |  2 +
 drivers/gpu/drm/meson/meson_dw_hdmi.c      |  1 +
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 81 +++++++++++++++++++++-
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/meson/Kconfig b/drivers/gpu/drm/meson/Kconfig
index 9f9281dd49f8..a4e1ed96e5e8 100644
--- a/drivers/gpu/drm/meson/Kconfig
+++ b/drivers/gpu/drm/meson/Kconfig
@@ -6,9 +6,11 @@ config DRM_MESON
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
+	select DRM_DISPLAY_CONNECTOR
 	select VIDEOMODE_HELPERS
 	select REGMAP_MMIO
 	select MESON_CANVAS
+	select CEC_CORE if CEC_NOTIFIER
 
 config DRM_MESON_DW_HDMI
 	tristate "HDMI Synopsys Controller support for Amlogic Meson Display"
diff --git a/drivers/gpu/drm/meson/meson_dw_hdmi.c b/drivers/gpu/drm/meson/meson_dw_hdmi.c
index fb540a503efe..5cd2b2ebbbd3 100644
--- a/drivers/gpu/drm/meson/meson_dw_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_dw_hdmi.c
@@ -803,6 +803,7 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 	dw_plat_data->input_bus_encoding = V4L2_YCBCR_ENC_709;
 	dw_plat_data->ycbcr_420_allowed = true;
 	dw_plat_data->disable_cec = true;
+	dw_plat_data->output_port = 1;
 
 	if (dw_hdmi_is_compatible(meson_dw_hdmi, "amlogic,meson-gxl-dw-hdmi") ||
 	    dw_hdmi_is_compatible(meson_dw_hdmi, "amlogic,meson-gxm-dw-hdmi") ||
diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index db332fa4cd54..5e306de6f485 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -14,8 +14,11 @@
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 
+#include <media/cec-notifier.h>
+
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_bridge.h>
+#include <drm/drm_bridge_connector.h>
 #include <drm/drm_device.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_probe_helper.h>
@@ -34,8 +37,10 @@ struct meson_encoder_hdmi {
 	struct drm_encoder encoder;
 	struct drm_bridge bridge;
 	struct drm_bridge *next_bridge;
+	struct drm_connector *connector;
 	struct meson_drm *priv;
 	unsigned long output_bus_fmt;
+	struct cec_notifier *cec_notifier;
 };
 
 #define bridge_to_meson_encoder_hdmi(x) \
@@ -50,6 +55,14 @@ static int meson_encoder_hdmi_attach(struct drm_bridge *bridge,
 				 &encoder_hdmi->bridge, flags);
 }
 
+static void meson_encoder_hdmi_detach(struct drm_bridge *bridge)
+{
+	struct meson_encoder_hdmi *encoder_hdmi = bridge_to_meson_encoder_hdmi(bridge);
+
+	cec_notifier_conn_unregister(encoder_hdmi->cec_notifier);
+	encoder_hdmi->cec_notifier = NULL;
+}
+
 static void meson_encoder_hdmi_set_vclk(struct meson_encoder_hdmi *encoder_hdmi,
 					const struct drm_display_mode *mode)
 {
@@ -298,9 +311,30 @@ static int meson_encoder_hdmi_atomic_check(struct drm_bridge *bridge,
 	return 0;
 }
 
+static void meson_encoder_hdmi_hpd_notify(struct drm_bridge *bridge,
+					  enum drm_connector_status status)
+{
+	struct meson_encoder_hdmi *encoder_hdmi = bridge_to_meson_encoder_hdmi(bridge);
+	struct edid *edid;
+
+	if (!encoder_hdmi->cec_notifier)
+		return;
+
+	if (status == connector_status_connected) {
+		edid = drm_bridge_get_edid(encoder_hdmi->next_bridge, encoder_hdmi->connector);
+		if (!edid)
+			return;
+
+		cec_notifier_set_phys_addr_from_edid(encoder_hdmi->cec_notifier, edid);
+	} else
+		cec_notifier_phys_addr_invalidate(encoder_hdmi->cec_notifier);
+}
+
 static const struct drm_bridge_funcs meson_encoder_hdmi_bridge_funcs = {
 	.attach = meson_encoder_hdmi_attach,
+	.detach = meson_encoder_hdmi_detach,
 	.mode_valid = meson_encoder_hdmi_mode_valid,
+	.hpd_notify = meson_encoder_hdmi_hpd_notify,
 	.atomic_enable = meson_encoder_hdmi_atomic_enable,
 	.atomic_disable = meson_encoder_hdmi_atomic_disable,
 	.atomic_get_input_bus_fmts = meson_encoder_hdmi_get_inp_bus_fmts,
@@ -313,6 +347,7 @@ static const struct drm_bridge_funcs meson_encoder_hdmi_bridge_funcs = {
 int meson_encoder_hdmi_init(struct meson_drm *priv)
 {
 	struct meson_encoder_hdmi *meson_encoder_hdmi;
+	struct platform_device *pdev;
 	struct device_node *remote;
 	int ret;
 
@@ -337,6 +372,7 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 	meson_encoder_hdmi->bridge.funcs = &meson_encoder_hdmi_bridge_funcs;
 	meson_encoder_hdmi->bridge.of_node = priv->dev->of_node;
 	meson_encoder_hdmi->bridge.type = DRM_MODE_CONNECTOR_HDMIA;
+	meson_encoder_hdmi->bridge.interlace_allowed = true;
 
 	drm_bridge_add(&meson_encoder_hdmi->bridge);
 
@@ -353,17 +389,58 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 	meson_encoder_hdmi->encoder.possible_crtcs = BIT(0);
 
 	/* Attach HDMI Encoder Bridge to Encoder */
-	ret = drm_bridge_attach(&meson_encoder_hdmi->encoder, &meson_encoder_hdmi->bridge, NULL, 0);
+	ret = drm_bridge_attach(&meson_encoder_hdmi->encoder, &meson_encoder_hdmi->bridge, NULL,
+				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
 	if (ret) {
 		dev_err(priv->dev, "Failed to attach bridge: %d\n", ret);
 		return ret;
 	}
 
+	/* Initialize & attach Bridge Connector */
+	meson_encoder_hdmi->connector = drm_bridge_connector_init(priv->drm,
+							&meson_encoder_hdmi->encoder);
+	if (IS_ERR(meson_encoder_hdmi->connector)) {
+		dev_err(priv->dev, "Unable to create HDMI bridge connector\n");
+		return PTR_ERR(meson_encoder_hdmi->connector);
+	}
+	drm_connector_attach_encoder(meson_encoder_hdmi->connector,
+				     &meson_encoder_hdmi->encoder);
+
 	/*
 	 * We should have now in place:
-	 * encoder->[hdmi encoder bridge]->[dw-hdmi bridge]->[dw-hdmi connector]
+	 * encoder->[hdmi encoder bridge]->[dw-hdmi bridge]->[display connector bridge]->[display connector]
 	 */
 
+	/*
+	 * drm_connector_attach_max_bpc_property() requires the
+	 * connector to have a state.
+	 */
+	drm_atomic_helper_connector_reset(meson_encoder_hdmi->connector);
+
+	if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_GXL) ||
+	    meson_vpu_is_compatible(priv, VPU_COMPATIBLE_GXM) ||
+	    meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
+		drm_connector_attach_hdr_output_metadata_property(meson_encoder_hdmi->connector);
+
+	drm_connector_attach_max_bpc_property(meson_encoder_hdmi->connector, 8, 8);
+
+	/* Handle this here until handled by drm_bridge_connector_init() */
+	meson_encoder_hdmi->connector->ycbcr_420_allowed = true;
+
+	pdev = of_find_device_by_node(remote);
+	if (pdev) {
+		struct cec_connector_info conn_info;
+		struct cec_notifier *notifier;
+
+		cec_fill_conn_info_from_drm(&conn_info, meson_encoder_hdmi->connector);
+
+		notifier = cec_notifier_conn_register(&pdev->dev, NULL, &conn_info);
+		if (!notifier)
+			return -ENOMEM;
+
+		meson_encoder_hdmi->cec_notifier = notifier;
+	}
+
 	dev_dbg(priv->dev, "HDMI encoder initialized\n");
 
 	return 0;
-- 
2.35.1



