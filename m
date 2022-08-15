Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150625938F1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiHOS5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244505AbiHOSyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B092F48C8F;
        Mon, 15 Aug 2022 11:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F378060F9F;
        Mon, 15 Aug 2022 18:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB17AC43470;
        Mon, 15 Aug 2022 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588204;
        bh=5p72wdtJqlGgqiGZV6Xmuba4jF0CiLY0HM63e1HbpVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYvDkl4uooiIdb4GjvSdl5KUSlChxRXMPo38e4IQhYsWaprkALn3vBFYwvaaH9EZH
         i42cTWMXq8jjq8ag8ct7RNSBDFAh5XwloZ0NR77Byzu7NaoPVIWq+EywU3yRvbZ0PE
         DcTYZg8uP98b9QIYKzpCRz6BakIiGAPk6UVACCDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/779] drm/bridge: Add a function to abstract away panels
Date:   Mon, 15 Aug 2022 19:59:00 +0200
Message-Id: <20220815180349.940425632@linuxfoundation.org>
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

[ Upstream commit 87ea95808d53e56b03e620e8f8f3add48899a88d ]

Display drivers so far need to have a lot of boilerplate to first
retrieve either the panel or bridge that they are connected to using
drm_of_find_panel_or_bridge(), and then either deal with each with ad-hoc
functions or create a drm panel bridge through drm_panel_bridge_add.

In order to reduce the boilerplate and hopefully create a path of least
resistance towards using the DRM panel bridge layer, let's create the
function devm_drm_of_get_bridge() to reduce that boilerplate.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210910130941.1740182-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 41 ++++++++++++++++++++++++++++++++----
 drivers/gpu/drm/drm_of.c     |  3 +++
 include/drm/drm_bridge.h     |  2 ++
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index a8ed66751c2d..4c68733fa660 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -28,6 +28,7 @@
 #include <drm/drm_atomic_state_helper.h>
 #include <drm/drm_bridge.h>
 #include <drm/drm_encoder.h>
+#include <drm/drm_of.h>
 #include <drm/drm_print.h>
 
 #include "drm_crtc_internal.h"
@@ -51,10 +52,8 @@
  *
  * Display drivers are responsible for linking encoders with the first bridge
  * in the chains. This is done by acquiring the appropriate bridge with
- * of_drm_find_bridge() or drm_of_find_panel_or_bridge(), or creating it for a
- * panel with drm_panel_bridge_add_typed() (or the managed version
- * devm_drm_panel_bridge_add_typed()). Once acquired, the bridge shall be
- * attached to the encoder with a call to drm_bridge_attach().
+ * devm_drm_of_get_bridge(). Once acquired, the bridge shall be attached to the
+ * encoder with a call to drm_bridge_attach().
  *
  * Bridges are responsible for linking themselves with the next bridge in the
  * chain, if any. This is done the same way as for encoders, with the call to
@@ -1233,6 +1232,40 @@ struct drm_bridge *of_drm_find_bridge(struct device_node *np)
 	return NULL;
 }
 EXPORT_SYMBOL(of_drm_find_bridge);
+
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
 #endif
 
 MODULE_AUTHOR("Ajay Kumar <ajaykumar.rs@samsung.com>");
diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index 997b8827fed2..37c34146eea8 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -231,6 +231,9 @@ EXPORT_SYMBOL_GPL(drm_of_encoder_active_endpoint);
  * return either the associated struct drm_panel or drm_bridge device. Either
  * @panel or @bridge must not be NULL.
  *
+ * This function is deprecated and should not be used in new drivers. Use
+ * devm_drm_of_get_bridge() instead.
+ *
  * Returns zero if successful, or one of the standard error codes if it fails.
  */
 int drm_of_find_panel_or_bridge(const struct device_node *np,
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 46bdfa48c413..9cdbd209388e 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -911,6 +911,8 @@ struct drm_bridge *devm_drm_panel_bridge_add(struct device *dev,
 struct drm_bridge *devm_drm_panel_bridge_add_typed(struct device *dev,
 						   struct drm_panel *panel,
 						   u32 connector_type);
+struct drm_bridge *devm_drm_of_get_bridge(struct device *dev, struct device_node *node,
+					  u32 port, u32 endpoint);
 struct drm_connector *drm_panel_bridge_connector(struct drm_bridge *bridge);
 #endif
 
-- 
2.35.1



