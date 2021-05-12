Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C8737CCD9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhELQsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243654AbhELQlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8614D61E51;
        Wed, 12 May 2021 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835533;
        bh=nEox49Q27QjSFSdwjXlwD39vhc2AGO4HNO9RINfC0wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8NrNC8rG6xSiJ5D0BQQwG2m4mMwkWCl0MivrtzJb+wjKxErADhJG5F9xDjPdhAhF
         qxHHDbkV4ggDCvBwwFzS5OGF0fHZXHJggBPQcbJlSb4G7xu7980ETV5YLTrYpiBLqW
         St321TE9RRkSWLkQmh7RSo1QFLnX+RGaTGcXtb3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 383/677] drm/mediatek: Dont support hdmi connector creation
Date:   Wed, 12 May 2021 16:47:09 +0200
Message-Id: <20210512144850.062090214@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit 2e477391522354e763aa62ee3e281c1ad9e8eb1b ]

commit f01195148967 ("drm/mediatek: mtk_dpi: Create connector for bridges")
broke the display support for elm device since mtk_dpi calls
drm_bridge_attach with the flag DRM_BRIDGE_ATTACH_NO_CONNECTOR
while mtk_hdmi does not yet support this flag.

Fix this by accepting DRM_BRIDGE_ATTACH_NO_CONNECTOR in bridge attachment.
Implement the drm_bridge_funcs .detect() and .get_edid() operations, and
call drm_bridge_hpd_notify() to report HPD. This provides the
necessary API to support disabling connector creation.

In addition, the field 'conn' is removed from the mtk_hdmi struct since
mtk_hdmi don't create a connector. It is replaced with a pointer
'curr_conn' that points to the current connector which can be access
through the global state.

This patch is inspired by a similar patch for bridge/synopsys/dw-hdmi.c:
commit ec971aaa6775
("drm: bridge: dw-hdmi: Make connector creation optional")
But with the difference that in mtk-hdmi only the option of not creating
a connector is supported.

Fixes: f01195148967 ("drm/mediatek: mtk_dpi: Create connector for bridges")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 151 +++++++++++-----------------
 1 file changed, 56 insertions(+), 95 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index f2c810b767ef..7fb358167f8d 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -153,7 +153,7 @@ struct mtk_hdmi_conf {
 struct mtk_hdmi {
 	struct drm_bridge bridge;
 	struct drm_bridge *next_bridge;
-	struct drm_connector conn;
+	struct drm_connector *curr_conn;/* current connector (only valid when 'enabled') */
 	struct device *dev;
 	const struct mtk_hdmi_conf *conf;
 	struct phy *phy;
@@ -186,11 +186,6 @@ static inline struct mtk_hdmi *hdmi_ctx_from_bridge(struct drm_bridge *b)
 	return container_of(b, struct mtk_hdmi, bridge);
 }
 
-static inline struct mtk_hdmi *hdmi_ctx_from_conn(struct drm_connector *c)
-{
-	return container_of(c, struct mtk_hdmi, conn);
-}
-
 static u32 mtk_hdmi_read(struct mtk_hdmi *hdmi, u32 offset)
 {
 	return readl(hdmi->regs + offset);
@@ -974,7 +969,7 @@ static int mtk_hdmi_setup_avi_infoframe(struct mtk_hdmi *hdmi,
 	ssize_t err;
 
 	err = drm_hdmi_avi_infoframe_from_display_mode(&frame,
-						       &hdmi->conn, mode);
+						       hdmi->curr_conn, mode);
 	if (err < 0) {
 		dev_err(hdmi->dev,
 			"Failed to get AVI infoframe from mode: %zd\n", err);
@@ -1054,7 +1049,7 @@ static int mtk_hdmi_setup_vendor_specific_infoframe(struct mtk_hdmi *hdmi,
 	ssize_t err;
 
 	err = drm_hdmi_vendor_infoframe_from_display_mode(&frame,
-							  &hdmi->conn, mode);
+							  hdmi->curr_conn, mode);
 	if (err) {
 		dev_err(hdmi->dev,
 			"Failed to get vendor infoframe from mode: %zd\n", err);
@@ -1201,48 +1196,16 @@ mtk_hdmi_update_plugged_status(struct mtk_hdmi *hdmi)
 	       connector_status_connected : connector_status_disconnected;
 }
 
-static enum drm_connector_status hdmi_conn_detect(struct drm_connector *conn,
-						  bool force)
+static enum drm_connector_status mtk_hdmi_detect(struct mtk_hdmi *hdmi)
 {
-	struct mtk_hdmi *hdmi = hdmi_ctx_from_conn(conn);
 	return mtk_hdmi_update_plugged_status(hdmi);
 }
 
-static void hdmi_conn_destroy(struct drm_connector *conn)
-{
-	struct mtk_hdmi *hdmi = hdmi_ctx_from_conn(conn);
-
-	mtk_cec_set_hpd_event(hdmi->cec_dev, NULL, NULL);
-
-	drm_connector_cleanup(conn);
-}
-
-static int mtk_hdmi_conn_get_modes(struct drm_connector *conn)
-{
-	struct mtk_hdmi *hdmi = hdmi_ctx_from_conn(conn);
-	struct edid *edid;
-	int ret;
-
-	if (!hdmi->ddc_adpt)
-		return -ENODEV;
-
-	edid = drm_get_edid(conn, hdmi->ddc_adpt);
-	if (!edid)
-		return -ENODEV;
-
-	hdmi->dvi_mode = !drm_detect_monitor_audio(edid);
-
-	drm_connector_update_edid_property(conn, edid);
-
-	ret = drm_add_edid_modes(conn, edid);
-	kfree(edid);
-	return ret;
-}
-
-static int mtk_hdmi_conn_mode_valid(struct drm_connector *conn,
-				    struct drm_display_mode *mode)
+static int mtk_hdmi_bridge_mode_valid(struct drm_bridge *bridge,
+				      const struct drm_display_info *info,
+				      const struct drm_display_mode *mode)
 {
-	struct mtk_hdmi *hdmi = hdmi_ctx_from_conn(conn);
+	struct mtk_hdmi *hdmi = hdmi_ctx_from_bridge(bridge);
 	struct drm_bridge *next_bridge;
 
 	dev_dbg(hdmi->dev, "xres=%d, yres=%d, refresh=%d, intl=%d clock=%d\n",
@@ -1267,74 +1230,57 @@ static int mtk_hdmi_conn_mode_valid(struct drm_connector *conn,
 	return drm_mode_validate_size(mode, 0x1fff, 0x1fff);
 }
 
-static struct drm_encoder *mtk_hdmi_conn_best_enc(struct drm_connector *conn)
-{
-	struct mtk_hdmi *hdmi = hdmi_ctx_from_conn(conn);
-
-	return hdmi->bridge.encoder;
-}
-
-static const struct drm_connector_funcs mtk_hdmi_connector_funcs = {
-	.detect = hdmi_conn_detect,
-	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = hdmi_conn_destroy,
-	.reset = drm_atomic_helper_connector_reset,
-	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
-};
-
-static const struct drm_connector_helper_funcs
-		mtk_hdmi_connector_helper_funcs = {
-	.get_modes = mtk_hdmi_conn_get_modes,
-	.mode_valid = mtk_hdmi_conn_mode_valid,
-	.best_encoder = mtk_hdmi_conn_best_enc,
-};
-
 static void mtk_hdmi_hpd_event(bool hpd, struct device *dev)
 {
 	struct mtk_hdmi *hdmi = dev_get_drvdata(dev);
 
-	if (hdmi && hdmi->bridge.encoder && hdmi->bridge.encoder->dev)
+	if (hdmi && hdmi->bridge.encoder && hdmi->bridge.encoder->dev) {
+		static enum drm_connector_status status;
+
+		status = mtk_hdmi_detect(hdmi);
 		drm_helper_hpd_irq_event(hdmi->bridge.encoder->dev);
+		drm_bridge_hpd_notify(&hdmi->bridge, status);
+	}
 }
 
 /*
  * Bridge callbacks
  */
 
+static enum drm_connector_status mtk_hdmi_bridge_detect(struct drm_bridge *bridge)
+{
+	struct mtk_hdmi *hdmi = hdmi_ctx_from_bridge(bridge);
+
+	return mtk_hdmi_detect(hdmi);
+}
+
+static struct edid *mtk_hdmi_bridge_get_edid(struct drm_bridge *bridge,
+					     struct drm_connector *connector)
+{
+	struct mtk_hdmi *hdmi = hdmi_ctx_from_bridge(bridge);
+	struct edid *edid;
+
+	if (!hdmi->ddc_adpt)
+		return NULL;
+	edid = drm_get_edid(connector, hdmi->ddc_adpt);
+	if (!edid)
+		return NULL;
+	hdmi->dvi_mode = !drm_detect_monitor_audio(edid);
+	return edid;
+}
+
 static int mtk_hdmi_bridge_attach(struct drm_bridge *bridge,
 				  enum drm_bridge_attach_flags flags)
 {
 	struct mtk_hdmi *hdmi = hdmi_ctx_from_bridge(bridge);
 	int ret;
 
-	if (flags & DRM_BRIDGE_ATTACH_NO_CONNECTOR) {
-		DRM_ERROR("Fix bridge driver to make connector optional!");
+	if (!(flags & DRM_BRIDGE_ATTACH_NO_CONNECTOR)) {
+		DRM_ERROR("%s: The flag DRM_BRIDGE_ATTACH_NO_CONNECTOR must be supplied\n",
+			  __func__);
 		return -EINVAL;
 	}
 
-	ret = drm_connector_init_with_ddc(bridge->encoder->dev, &hdmi->conn,
-					  &mtk_hdmi_connector_funcs,
-					  DRM_MODE_CONNECTOR_HDMIA,
-					  hdmi->ddc_adpt);
-	if (ret) {
-		dev_err(hdmi->dev, "Failed to initialize connector: %d\n", ret);
-		return ret;
-	}
-	drm_connector_helper_add(&hdmi->conn, &mtk_hdmi_connector_helper_funcs);
-
-	hdmi->conn.polled = DRM_CONNECTOR_POLL_HPD;
-	hdmi->conn.interlace_allowed = true;
-	hdmi->conn.doublescan_allowed = false;
-
-	ret = drm_connector_attach_encoder(&hdmi->conn,
-						bridge->encoder);
-	if (ret) {
-		dev_err(hdmi->dev,
-			"Failed to attach connector to encoder: %d\n", ret);
-		return ret;
-	}
-
 	if (hdmi->next_bridge) {
 		ret = drm_bridge_attach(bridge->encoder, hdmi->next_bridge,
 					bridge, flags);
@@ -1369,6 +1315,8 @@ static void mtk_hdmi_bridge_atomic_disable(struct drm_bridge *bridge,
 	clk_disable_unprepare(hdmi->clk[MTK_HDMI_CLK_HDMI_PIXEL]);
 	clk_disable_unprepare(hdmi->clk[MTK_HDMI_CLK_HDMI_PLL]);
 
+	hdmi->curr_conn = NULL;
+
 	hdmi->enabled = false;
 }
 
@@ -1432,8 +1380,13 @@ static void mtk_hdmi_send_infoframe(struct mtk_hdmi *hdmi,
 static void mtk_hdmi_bridge_atomic_enable(struct drm_bridge *bridge,
 					  struct drm_bridge_state *old_state)
 {
+	struct drm_atomic_state *state = old_state->base.state;
 	struct mtk_hdmi *hdmi = hdmi_ctx_from_bridge(bridge);
 
+	/* Retrieve the connector through the atomic state. */
+	hdmi->curr_conn = drm_atomic_get_new_connector_for_encoder(state,
+								   bridge->encoder);
+
 	mtk_hdmi_output_set_display_mode(hdmi, &hdmi->mode);
 	clk_prepare_enable(hdmi->clk[MTK_HDMI_CLK_HDMI_PLL]);
 	clk_prepare_enable(hdmi->clk[MTK_HDMI_CLK_HDMI_PIXEL]);
@@ -1444,6 +1397,7 @@ static void mtk_hdmi_bridge_atomic_enable(struct drm_bridge *bridge,
 }
 
 static const struct drm_bridge_funcs mtk_hdmi_bridge_funcs = {
+	.mode_valid = mtk_hdmi_bridge_mode_valid,
 	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 	.atomic_reset = drm_atomic_helper_bridge_reset,
@@ -1454,6 +1408,8 @@ static const struct drm_bridge_funcs mtk_hdmi_bridge_funcs = {
 	.mode_set = mtk_hdmi_bridge_mode_set,
 	.atomic_pre_enable = mtk_hdmi_bridge_atomic_pre_enable,
 	.atomic_enable = mtk_hdmi_bridge_atomic_enable,
+	.detect = mtk_hdmi_bridge_detect,
+	.get_edid = mtk_hdmi_bridge_get_edid,
 };
 
 static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
@@ -1669,8 +1625,10 @@ static int mtk_hdmi_audio_get_eld(struct device *dev, void *data, uint8_t *buf,
 {
 	struct mtk_hdmi *hdmi = dev_get_drvdata(dev);
 
-	memcpy(buf, hdmi->conn.eld, min(sizeof(hdmi->conn.eld), len));
-
+	if (hdmi->enabled)
+		memcpy(buf, hdmi->curr_conn->eld, min(sizeof(hdmi->curr_conn->eld), len));
+	else
+		memset(buf, 0, len);
 	return 0;
 }
 
@@ -1762,6 +1720,9 @@ static int mtk_drm_hdmi_probe(struct platform_device *pdev)
 
 	hdmi->bridge.funcs = &mtk_hdmi_bridge_funcs;
 	hdmi->bridge.of_node = pdev->dev.of_node;
+	hdmi->bridge.ops = DRM_BRIDGE_OP_DETECT | DRM_BRIDGE_OP_EDID
+			 | DRM_BRIDGE_OP_HPD;
+	hdmi->bridge.type = DRM_MODE_CONNECTOR_HDMIA;
 	drm_bridge_add(&hdmi->bridge);
 
 	ret = mtk_hdmi_clk_enable_audio(hdmi);
-- 
2.30.2



