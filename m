Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07ED6C4DED
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 15:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjCVOia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 10:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCVOia (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 10:38:30 -0400
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA732A141;
        Wed, 22 Mar 2023 07:38:29 -0700 (PDT)
Received: from francesco-nb.toradex.int (31-10-206-125.static.upc.ch [31.10.206.125])
        by mail11.truemail.it (Postfix) with ESMTPA id 338BD209B4;
        Wed, 22 Mar 2023 15:38:27 +0100 (CET)
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Adrien Grassein <adrien.grassein@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Cc:     Matheus Castello <matheus.castello@toradex.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v2] drm/bridge: lt8912b: return EPROBE_DEFER if bridge is not found
Date:   Wed, 22 Mar 2023 15:38:21 +0100
Message-Id: <20230322143821.109744-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matheus Castello <matheus.castello@toradex.com>

Returns EPROBE_DEFER when of_drm_find_bridge() fails, this is consistent
with what all the other DRM bridge drivers are doing and this is
required since the bridge might not be there when the driver is probed
and this should not be a fatal failure.

Cc: <stable@vger.kernel.org>
Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Matheus Castello <matheus.castello@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
v2: use dev_err_probe() instead of dev_dbg() (Laurent)
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 2019a8167d69..b40baced1331 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -676,8 +676,8 @@ static int lt8912_parse_dt(struct lt8912 *lt)
 
 	lt->hdmi_port = of_drm_find_bridge(port_node);
 	if (!lt->hdmi_port) {
-		dev_err(lt->dev, "%s: Failed to get hdmi port\n", __func__);
-		ret = -ENODEV;
+		ret = -EPROBE_DEFER;
+		dev_err_probe(lt->dev, ret, "%s: Failed to get hdmi port\n", __func__);
 		goto err_free_host_node;
 	}
 
-- 
2.25.1

