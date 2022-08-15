Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7F8593C7F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346419AbiHOUGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346163AbiHOUBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FCE7C75F;
        Mon, 15 Aug 2022 11:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34BC8B810A9;
        Mon, 15 Aug 2022 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932ADC433D7;
        Mon, 15 Aug 2022 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589620;
        bh=TwC/Maq0bEmceLwEg6k3SJsZPI6n3Zfns4vrT8h+7i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mwp2C2Ft75VWzPyIjeupAzZiqG2xJiJ8Hj94DhzvIboYyYQdo5gwj0k3iqDFSDuiC
         mNmFsyY8cdufBETHDmTgfOC12d2AALIC+toqpvN3yJf1U7wt+rDfUim6yTEvI7R7FJ
         Kd3HiM1txyO4M2CKJqoS0jtSA20IZrsp2BDaNvVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxime Ripard <maxime@cerno.tech>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.15 776/779] drm/bridge: Move devm_drm_of_get_bridge to bridge/panel.c
Date:   Mon, 15 Aug 2022 20:07:00 +0200
Message-Id: <20220815180410.553384486@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

commit d4ae66f10c8b9959dce1766d9a87070e567236eb upstream.

By depending on devm_drm_panel_bridge_add(), devm_drm_of_get_bridge()
introduces a circular dependency between the modules drm (where
devm_drm_of_get_bridge() ends up) and drm_kms_helper (where
devm_drm_panel_bridge_add() is).

Fix this by moving devm_drm_of_get_bridge() to bridge/panel.c and thus
drm_kms_helper.

Fixes: 87ea95808d53 ("drm/bridge: Add a function to abstract away panels")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210917180925.2602266-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/panel.c |   37 +++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_bridge.c   |   34 ----------------------------------
 2 files changed, 37 insertions(+), 34 deletions(-)

--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -9,6 +9,7 @@
 #include <drm/drm_connector.h>
 #include <drm/drm_encoder.h>
 #include <drm/drm_modeset_helper_vtables.h>
+#include <drm/drm_of.h>
 #include <drm/drm_panel.h>
 #include <drm/drm_print.h>
 #include <drm/drm_probe_helper.h>
@@ -332,3 +333,39 @@ struct drm_connector *drm_panel_bridge_c
 	return &panel_bridge->connector;
 }
 EXPORT_SYMBOL(drm_panel_bridge_connector);
+
+#ifdef CONFIG_OF
+/**
+ * devm_drm_of_get_bridge - Return next bridge in the chain
+ * @dev: device to tie the bridge lifetime to
+ * @np: device tree node containing encoder output ports
+ * @port: port in the device tree node
+ * @endpoint: endpoint in the device tree node
+ *
+ * Given a DT node's port and endpoint number, finds the connected node
+ * and returns the associated bridge if any, or creates and returns a
+ * drm panel bridge instance if a panel is connected.
+ *
+ * Returns a pointer to the bridge if successful, or an error pointer
+ * otherwise.
+ */
+struct drm_bridge *devm_drm_of_get_bridge(struct device *dev,
+					  struct device_node *np,
+					  u32 port, u32 endpoint)
+{
+	struct drm_bridge *bridge;
+	struct drm_panel *panel;
+	int ret;
+
+	ret = drm_of_find_panel_or_bridge(np, port, endpoint,
+					  &panel, &bridge);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (panel)
+		bridge = devm_drm_panel_bridge_add(dev, panel);
+
+	return bridge;
+}
+EXPORT_SYMBOL(devm_drm_of_get_bridge);
+#endif
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -1232,40 +1232,6 @@ struct drm_bridge *of_drm_find_bridge(st
 	return NULL;
 }
 EXPORT_SYMBOL(of_drm_find_bridge);
-
-/**
- * devm_drm_of_get_bridge - Return next bridge in the chain
- * @dev: device to tie the bridge lifetime to
- * @np: device tree node containing encoder output ports
- * @port: port in the device tree node
- * @endpoint: endpoint in the device tree node
- *
- * Given a DT node's port and endpoint number, finds the connected node
- * and returns the associated bridge if any, or creates and returns a
- * drm panel bridge instance if a panel is connected.
- *
- * Returns a pointer to the bridge if successful, or an error pointer
- * otherwise.
- */
-struct drm_bridge *devm_drm_of_get_bridge(struct device *dev,
-					  struct device_node *np,
-					  u32 port, u32 endpoint)
-{
-	struct drm_bridge *bridge;
-	struct drm_panel *panel;
-	int ret;
-
-	ret = drm_of_find_panel_or_bridge(np, port, endpoint,
-					  &panel, &bridge);
-	if (ret)
-		return ERR_PTR(ret);
-
-	if (panel)
-		bridge = devm_drm_panel_bridge_add(dev, panel);
-
-	return bridge;
-}
-EXPORT_SYMBOL(devm_drm_of_get_bridge);
 #endif
 
 MODULE_AUTHOR("Ajay Kumar <ajaykumar.rs@samsung.com>");


