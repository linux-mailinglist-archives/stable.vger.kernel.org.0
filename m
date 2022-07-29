Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967E2585248
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbiG2PUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiG2PUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:20:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A4D2E9E2;
        Fri, 29 Jul 2022 08:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2526661BB2;
        Fri, 29 Jul 2022 15:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4EAC433D6;
        Fri, 29 Jul 2022 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659108038;
        bh=SfY750hyXWFY3RGckwARiIKlaZaed6n5HE3zjphwTgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GER6ROLSEKzl1Gi7RvYrGk6XvxtEeVMjoDX9DGmLNCihV730EQJeftByQhOUw4mTT
         PsrFLPuoQEQl11zULwethb4vJg+Skd2QgKiSd1CGsmeBAjeYIoJUOK+OgUQT/fU6oz
         Q426y1uZzGh1p1w8+T4V0AaMUj0YnjJ+SmCye9ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.290
Date:   Fri, 29 Jul 2022 17:20:28 +0200
Message-Id: <165910802821238@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165910802795200@kroah.com>
References: <165910802795200@kroah.com>
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
index fad6bf5e3c69..49aa7e0433f1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 289
+SUBLEVEL = 290
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 5da0aec8ce90..89fdd7c6daf0 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -59,7 +59,7 @@ srmcons_do_receive_chars(struct tty_port *port)
 	} while((result.bits.status & 1) && (++loops < 10));
 
 	if (count)
-		tty_schedule_flip(port);
+		tty_flip_buffer_push(port);
 
 	return count;
 }
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9efa197364a6..261ec2a1dcf4 100644
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
index 06d6e785c920..7b11908d992a 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -707,9 +707,6 @@ static bool tilcdc_crtc_mode_fixup(struct drm_crtc *crtc,
 static int tilcdc_crtc_atomic_check(struct drm_crtc *crtc,
 				    struct drm_crtc_state *state)
 {
-	struct drm_display_mode *mode = &state->mode;
-	int ret;
-
 	/* If we are not active we don't care */
 	if (!state->active)
 		return 0;
@@ -721,12 +718,6 @@ static int tilcdc_crtc_atomic_check(struct drm_crtc *crtc,
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
 
@@ -750,13 +741,6 @@ static const struct drm_crtc_funcs tilcdc_crtc_funcs = {
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
@@ -771,7 +755,9 @@ int tilcdc_crtc_max_width(struct drm_crtc *crtc)
 	return max_width;
 }
 
-int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode)
+static enum drm_mode_status
+tilcdc_crtc_mode_valid(struct drm_crtc *crtc,
+		       const struct drm_display_mode *mode)
 {
 	struct tilcdc_drm_private *priv = crtc->dev->dev_private;
 	unsigned int bandwidth;
@@ -859,6 +845,14 @@ int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode)
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
index 56039897607c..d42e1f9f2949 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -208,7 +208,6 @@ static void tilcdc_fini(struct drm_device *dev)
 
 	drm_irq_uninstall(dev);
 	drm_mode_config_cleanup(dev);
-	tilcdc_remove_external_device(dev);
 
 	if (priv->clk)
 		clk_put(priv->clk);
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.h b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
index 8caa11bc7aec..c0ab69c79a93 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
@@ -91,7 +91,6 @@ struct tilcdc_drm_private {
 
 	struct drm_encoder *external_encoder;
 	struct drm_connector *external_connector;
-	const struct drm_connector_helper_funcs *connector_funcs;
 
 	bool is_registered;
 	bool is_componentized;
@@ -173,7 +172,6 @@ void tilcdc_crtc_set_panel_info(struct drm_crtc *crtc,
 		const struct tilcdc_panel_info *info);
 void tilcdc_crtc_set_simulate_vesa_sync(struct drm_crtc *crtc,
 					bool simulate_vesa_sync);
-int tilcdc_crtc_mode_valid(struct drm_crtc *crtc, struct drm_display_mode *mode);
 int tilcdc_crtc_max_width(struct drm_crtc *crtc);
 void tilcdc_crtc_shutdown(struct drm_crtc *crtc);
 int tilcdc_crtc_update_fb(struct drm_crtc *crtc,
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.c b/drivers/gpu/drm/tilcdc/tilcdc_external.c
index 711c7b3289d3..511e178012cd 100644
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
@@ -119,40 +61,30 @@ struct drm_connector *tilcdc_encoder_find_connector(struct drm_device *ddev,
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
@@ -163,7 +95,6 @@ static
 int tilcdc_attach_bridge(struct drm_device *ddev, struct drm_bridge *bridge)
 {
 	struct tilcdc_drm_private *priv = ddev->dev_private;
-	struct drm_connector *connector;
 	int ret;
 
 	priv->external_encoder->possible_crtcs = BIT(0);
@@ -176,13 +107,12 @@ int tilcdc_attach_bridge(struct drm_device *ddev, struct drm_bridge *bridge)
 
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
index 0484b2cf0e2b..f67a6194fd65 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -176,14 +176,6 @@ static int panel_connector_get_modes(struct drm_connector *connector)
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
@@ -201,7 +193,6 @@ static const struct drm_connector_funcs panel_connector_funcs = {
 
 static const struct drm_connector_helper_funcs panel_connector_helper_funcs = {
 	.get_modes          = panel_connector_get_modes,
-	.mode_valid         = panel_connector_mode_valid,
 	.best_encoder       = panel_connector_best_encoder,
 };
 
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index 1e2dfb1b1d6b..68c7bbba24e9 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -185,14 +185,6 @@ static int tfp410_connector_get_modes(struct drm_connector *connector)
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
@@ -211,7 +203,6 @@ static const struct drm_connector_funcs tfp410_connector_funcs = {
 
 static const struct drm_connector_helper_funcs tfp410_connector_helper_funcs = {
 	.get_modes          = tfp410_connector_get_modes,
-	.mode_valid         = tfp410_connector_mode_valid,
 	.best_encoder       = tfp410_connector_best_encoder,
 };
 
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
index 1589a568bfe0..7ea2e5dbacd5 100644
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
index 09da2d82c2f0..8af11a5e49fe 100644
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
index f66b246acaea..d0d96fa71084 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1340,7 +1340,7 @@ static int be_get_module_info(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		if (!page_data[SFP_PLUS_SFF_8472_COMP]) {
 			modinfo->type = ETH_MODULE_SFF_8079;
@@ -1358,25 +1358,32 @@ static int be_get_module_eeprom(struct net_device *netdev,
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
index e5566c121525..9b12bb3b7781 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -217,6 +217,9 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
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
index 8a48df80b59a..6d68f9799ada 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1707,7 +1707,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1720,7 +1720,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1733,7 +1733,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1746,7 +1746,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1759,7 +1759,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1772,7 +1772,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1785,7 +1785,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1798,7 +1798,7 @@ static const struct driver_info belkin_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index 70825689e5a0..7c872f71459c 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -846,6 +846,11 @@ static void hv_int_desc_free(struct hv_pci_dev *hpdev,
 		u8 buffer[sizeof(struct pci_delete_interrupt)];
 	} ctxt;
 
+	if (!int_desc->vector_count) {
+		kfree(int_desc);
+		return;
+	}
+
 	memset(&ctxt, 0, sizeof(ctxt));
 	int_pkt = (struct pci_delete_interrupt *)&ctxt.pkt.message;
 	int_pkt->message_type.type =
@@ -908,6 +913,28 @@ static void hv_irq_mask(struct irq_data *data)
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
+	 if (info->type == X86_IRQ_ALLOC_TYPE_MSI)
+		info->flags &= ~X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
+
+	return ret;
+}
+
 /**
  * hv_irq_unmask() - "Unmask" the IRQ by setting its current
  * affinity.
@@ -923,6 +950,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	struct msi_desc *msi_desc = irq_data_get_msi_desc(data);
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct retarget_msi_interrupt *params;
+	struct tran_int_desc *int_desc;
 	struct hv_pcibus_device *hbus;
 	struct cpumask *dest;
 	struct pci_bus *pbus;
@@ -937,6 +965,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	pdev = msi_desc_to_pci_dev(msi_desc);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
+	int_desc = data->chip_data;
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -944,8 +973,8 @@ static void hv_irq_unmask(struct irq_data *data)
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
@@ -1033,12 +1062,12 @@ static void hv_pci_compose_compl(void *context, struct pci_response *resp,
 
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
 	int_pkt->int_desc.delivery_mode =
 		(apic->irq_delivery_mode == dest_LowestPrio) ?
 			dest_LowestPrio : dest_Fixed;
@@ -1054,14 +1083,14 @@ static u32 hv_compose_msi_req_v1(
 
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
 	int_pkt->int_desc.delivery_mode =
 		(apic->irq_delivery_mode == dest_LowestPrio) ?
 			dest_LowestPrio : dest_Fixed;
@@ -1091,7 +1120,6 @@ static u32 hv_compose_msi_req_v2(
  */
 static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_pcibus_device *hbus;
 	struct hv_pci_dev *hpdev;
 	struct pci_bus *pbus;
@@ -1100,6 +1128,8 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	unsigned long flags;
 	struct compose_comp_ctxt comp;
 	struct tran_int_desc *int_desc;
+	struct msi_desc *msi_desc;
+	u8 vector, vector_count;
 	struct {
 		struct pci_packet pci_pkt;
 		union {
@@ -1111,7 +1141,17 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
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
+	msi_desc = irq_data_get_msi_desc(data);
+	pdev = msi_desc_to_pci_dev(msi_desc);
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
@@ -1119,17 +1159,40 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
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
+			put_pcichild(hpdev, hv_pcidev_ref_by_slot);
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
@@ -1140,14 +1203,16 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
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
@@ -1259,7 +1324,7 @@ static irq_hw_number_t hv_msi_domain_ops_get_hwirq(struct msi_domain_info *info,
 
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
index a074d9711628..9b16eae28486 100644
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -45,7 +45,7 @@ static inline void
 kbd_put_queue(struct tty_port *port, int ch)
 {
 	tty_insert_flip_char(port, ch, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static inline void
@@ -53,5 +53,5 @@ kbd_puts_queue(struct tty_port *port, char *cp)
 {
 	while (*cp)
 		tty_insert_flip_char(port, *cp++, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
diff --git a/drivers/staging/speakup/spk_ttyio.c b/drivers/staging/speakup/spk_ttyio.c
index 5aae06bc6fe3..653f7a716181 100644
--- a/drivers/staging/speakup/spk_ttyio.c
+++ b/drivers/staging/speakup/spk_ttyio.c
@@ -87,7 +87,7 @@ static int spk_ttyio_receive_buf2(struct tty_struct *tty,
 	}
 
 	if (!ldisc_data->buf_free)
-		/* ttyio_in will tty_schedule_flip */
+		/* ttyio_in will tty_flip_buffer_push */
 		return 0;
 
 	/* Make sure the consumer has read buf before we have seen
@@ -299,7 +299,7 @@ static unsigned char ttyio_in(int timeout)
 	mb();
 	ldisc_data->buf_free = true;
 	/* Let TTY push more characters */
-	tty_schedule_flip(speakup_tty->port);
+	tty_flip_buffer_push(speakup_tty->port);
 
 	return rv;
 }
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index d272bc4e7fb5..d84214bd7176 100644
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
@@ -998,7 +998,7 @@ static void cyz_handle_rx(struct cyclades_port *info)
 				jiffies + 1);
 #endif
 	info->idle_stats.recv_idle = jiffies;
-	tty_schedule_flip(&info->port);
+	tty_flip_buffer_push(&info->port);
 
 	/* Update rx_get */
 	cy_writel(&buf_ctrl->rx_get, new_rx_get);
@@ -1174,7 +1174,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 		if (delta_count)
 			wake_up_interruptible(&info->port.delta_msr_wait);
 		if (special_count)
-			tty_schedule_flip(&info->port);
+			tty_flip_buffer_push(&info->port);
 	}
 }
 
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 9f0b6b185be7..d160df73d9fd 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -159,7 +159,7 @@ static irqreturn_t goldfish_tty_interrupt(int irq, void *dev_id)
 	address = (unsigned long)(void *)buf;
 	goldfish_tty_rw(qtty, address, count, 0);
 
-	tty_schedule_flip(&qtty->port);
+	tty_flip_buffer_push(&qtty->port);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 7f3d4cb0341b..e69494e5361c 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1397,7 +1397,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		if (inited && !tty_throttled(tty) &&
 				MoxaPortRxQueue(p) > 0) { /* RX */
 			MoxaPortReadData(p);
-			tty_schedule_flip(&p->port);
+			tty_flip_buffer_push(&p->port);
 		}
 	} else {
 		clear_bit(EMPTYWAIT, &p->statusflags);
@@ -1422,7 +1422,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
 		tty_insert_flip_char(&p->port, 0, TTY_BREAK);
-		tty_schedule_flip(&p->port);
+		tty_flip_buffer_push(&p->port);
 	}
 
 	if (intr & IntrLine)
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index bca47176db4c..467f401abd29 100644
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
index cea57ff32c33..9bbe2d093a6c 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -350,7 +350,7 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 		       LPC32XX_HSUART_IIR(port->membase));
 		port->icount.overrun++;
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
-		tty_schedule_flip(tport);
+		tty_flip_buffer_push(tport);
 	}
 
 	/* Data received? */
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 608769f6a564..979dfea8041d 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -388,27 +388,6 @@ int __tty_insert_flip_char(struct tty_port *port, unsigned char ch, char flag)
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
@@ -538,6 +517,15 @@ static void flush_to_ldisc(struct work_struct *work)
 
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
@@ -551,10 +539,44 @@ static void flush_to_ldisc(struct work_struct *work)
 
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
index aff07929e8e6..20befbbdda3b 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -309,7 +309,7 @@ int kbd_rate(struct kbd_repeat *rpt)
 static void put_queue(struct vc_data *vc, int ch)
 {
 	tty_insert_flip_char(&vc->port, ch, 0);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void puts_queue(struct vc_data *vc, char *cp)
@@ -318,7 +318,7 @@ static void puts_queue(struct vc_data *vc, char *cp)
 		tty_insert_flip_char(&vc->port, *cp, 0);
 		cp++;
 	}
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -563,7 +563,7 @@ static void fn_inc_console(struct vc_data *vc)
 static void fn_send_intr(struct vc_data *vc)
 {
 	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index cd4947a72a6c..8ac775852b82 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1482,7 +1482,7 @@ static void respond_string(const char *p, struct tty_port *port)
 		tty_insert_flip_char(port, *p, 0);
 		p++;
 	}
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static void cursor_report(struct vc_data *vc, struct tty_struct *tty)
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 2827015604fb..799173755b78 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -393,7 +393,8 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset+i].status &&
+			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
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
index 2e1d36b33db7..8e694cb464c1 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -367,6 +367,71 @@ static inline struct sk_buff *bt_skb_send_alloc(struct sock *sk,
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
index 16a1492a5bd3..f279d72273f6 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -110,7 +110,8 @@ static inline struct inet_request_sock *inet_rsk(const struct request_sock *sk)
 
 static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 {
-	if (!sk->sk_mark && sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept)
+	if (!sk->sk_mark &&
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept))
 		return skb->mark;
 
 	return sk->sk_mark;
diff --git a/include/net/ip.h b/include/net/ip.h
index 4aff48d6ba91..2a92a5f4f9b3 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -305,7 +305,7 @@ void ipfrag_init(void);
 void ip_static_sysctl_init(void);
 
 #define IP4_REPLY_MARK(net, mark) \
-	((net)->ipv4.sysctl_fwmark_reflect ? (mark) : 0)
+	(READ_ONCE((net)->ipv4.sysctl_fwmark_reflect) ? (mark) : 0)
 
 static inline bool ip_is_fragment(const struct iphdr *iph)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 181db7dab176..5e719f9d60fd 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1882,7 +1882,7 @@ void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
 static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
-	return tp->notsent_lowat ?: net->ipv4.sysctl_tcp_notsent_lowat;
+	return tp->notsent_lowat ?: READ_ONCE(net->ipv4.sysctl_tcp_notsent_lowat);
 }
 
 static inline bool tcp_stream_memory_free(const struct sock *sk)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 220c43a085e4..5d649983de07 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -64,11 +64,13 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
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
index 93e21e319d70..2ad8acff03db 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5429,10 +5429,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
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
@@ -9859,14 +9859,25 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
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
@@ -9904,8 +9915,15 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
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
@@ -9915,6 +9933,12 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
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
@@ -9922,20 +9946,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
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
index 5a6bfadef40e..aa2a88c09621 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -347,7 +347,7 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
  */
 static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
 {
-	if (!pol)
+	if (!pol || pol->mode == MPOL_LOCAL)
 		return;
 	if (!mpol_store_user_nodemask(pol) && !(pol->flags & MPOL_F_LOCAL) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 4a0b41d75c84..3f7d042a09b4 100644
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
index 8fcd9130439d..eeff89e8ad4c 100644
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
index 22761a404e0d..b3dd396ca649 100644
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
@@ -716,7 +709,7 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len)
 {
 	struct sock *sk = sock->sk;
-	void *buf;
+	struct sk_buff *skb;
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -728,24 +721,21 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
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
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 16255dd0abf4..fd2c634eeee4 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -474,7 +474,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ip_mc_list *pmc,
 
 	if (pmc->multiaddr == IGMP_ALL_HOSTS)
 		return skb;
-	if (ipv4_is_local_multicast(pmc->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(pmc->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -600,7 +601,7 @@ static int igmpv3_send_report(struct in_device *in_dev, struct ip_mc_list *pmc)
 			if (pmc->multiaddr == IGMP_ALL_HOSTS)
 				continue;
 			if (ipv4_is_local_multicast(pmc->multiaddr) &&
-			     !net->ipv4.sysctl_igmp_llm_reports)
+			    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 				continue;
 			spin_lock_bh(&pmc->lock);
 			if (pmc->sfcount[MCAST_EXCLUDE])
@@ -743,7 +744,8 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	if (type == IGMPV3_HOST_MEMBERSHIP_REPORT)
 		return igmpv3_send_report(in_dev, pmc);
 
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return 0;
 
 	if (type == IGMP_HOST_LEAVE_MESSAGE)
@@ -921,7 +923,8 @@ static bool igmp_heard_report(struct in_device *in_dev, __be32 group)
 
 	if (group == IGMP_ALL_HOSTS)
 		return false;
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return false;
 
 	rcu_read_lock();
@@ -1031,7 +1034,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 		spin_lock_bh(&im->lock);
 		if (im->tm_running)
@@ -1280,7 +1283,8 @@ static void igmp_group_dropped(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	reporter = im->reporter;
@@ -1317,7 +1321,8 @@ static void igmp_group_added(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	if (in_dev->dead)
@@ -1629,7 +1634,7 @@ static void ip_mc_rejoin_groups(struct in_device *in_dev)
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 
 		/* a failover is happening and switches
@@ -2174,7 +2179,7 @@ int ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr)
 		count++;
 	}
 	err = -ENOBUFS;
-	if (count >= net->ipv4.sysctl_igmp_max_memberships)
+	if (count >= READ_ONCE(net->ipv4.sysctl_igmp_max_memberships))
 		goto done;
 	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL);
 	if (!iml)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a231993c81c4..5e9b7dfd9d2d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2005,7 +2005,7 @@ static inline void tcp_mtu_check_reprobe(struct sock *sk)
 	u32 interval;
 	s32 delta;
 
-	interval = net->ipv4.sysctl_tcp_probe_interval;
+	interval = READ_ONCE(net->ipv4.sysctl_tcp_probe_interval);
 	delta = tcp_jiffies32 - icsk->icsk_mtup.probe_timestamp;
 	if (unlikely(delta >= interval * HZ)) {
 		int mss = tcp_current_mss(sk);
@@ -2087,7 +2087,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	 * probing process by not resetting search range to its orignal.
 	 */
 	if (probe_size > tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_high) ||
-		interval < net->ipv4.sysctl_tcp_probe_threshold) {
+	    interval < READ_ONCE(net->ipv4.sysctl_tcp_probe_threshold)) {
 		/* Check whether enough time has elaplased for
 		 * another round of probing.
 		 */
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d87121d61a2b..e1840f70c0ff 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1673,8 +1673,10 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		*num_xfrms = 0;
 		return 0;
 	}
-	if (IS_ERR(pols[0]))
+	if (IS_ERR(pols[0])) {
+		*num_pols = 0;
 		return PTR_ERR(pols[0]);
+	}
 
 	*num_xfrms = pols[0]->xfrm_nr;
 
@@ -1688,6 +1690,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				xfrm_pols_put(pols, *num_pols);
+				*num_pols = 0;
 				return PTR_ERR(pols[1]);
 			}
 			(*num_pols)++;
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
