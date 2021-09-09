Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0416404317
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhIIBre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhIIBrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:47:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E85A60187;
        Thu,  9 Sep 2021 01:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631151985;
        bh=84vvJMs9BQP/RnsgF6DIVjbTghk68ob7G2Kt8qsDxRc=;
        h=From:To:Cc:Subject:Date:From;
        b=J4YsGcIo18Ss34d7EiPTa8joXBPgUdRP/fb5RzSK40P0fMdFIFL5yOiplSWjRxIvf
         qSTBANYAZMUHStwUR0VAEUeukHDLu3q8ZH1tvx1htpqBdY49vlcrN3O8l2Fo3nRk3N
         FLtb9MoIbb/Ok+VVcYocQ52RUe7ARIR4Teks81XNMbrqWmUi4OLO1j+bKdoGEBuvf3
         uR0q5xg8b3a+PTS/7BGKLAEHj1E4Vhv3ZHWfvzRTzteuIoiKxCdChJwn5QgQG6FzNU
         UsSz1si24mdV6XXaJXpnUXqrb2ARzywGrvPJiq57N3ANlixlAq1AxLcflKpkU3eblN
         hqE6zvt0kQ8Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 001/252] drm/bridge: ti-sn65dsi86: Don't read EDID blob over DDC
Date:   Wed,  8 Sep 2021 21:42:11 -0400
Message-Id: <20210909014623.128976-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit a70e558c151043ce46a5e5999f4310e0b3551f57 ]

This is really just a revert of commit 58074b08c04a ("drm/bridge:
ti-sn65dsi86: Read EDID blob over DDC"), resolving conflicts.

The old code failed to read the EDID properly in a very important
case: before the bridge's pre_enable() was called. The way things need
to work:
1. Read the EDID.
2. Based on the EDID, decide on video settings and pixel clock.
3. Enable the bridge w/ the desired settings.

The way things were working:
1. Try to read the EDID but fail; fall back to hardcoded values.
2. Based on hardcoded values, decide on video settings and pixel clock.
3. Enable the bridge w/ the desired settings.
4. Try again to read the EDID, it works now!
5. Realize that the hardcoded settings weren't quite right.
6. Disable / reenable the bridge w/ the right settings.

The reasons for the failures were twofold:
a) Since we never ran the bridge chip's pre-enable then we never set
   the bit to ignore HPD. This meant the bridge chip didn't even _try_
   to go out on the bus and communicate with the panel.
b) Even if we fixed things to ignore HPD, the EDID still wouldn't read
   if the panel wasn't on.

Instead of reverting the code, we could fix it to set the HPD bit and
also power on the panel. However, it also works nicely to just let the
panel code read the EDID. Now that we've split the driver up we can
expose the DDC AUX channel bus to the panel node. The panel can take
charge of reading the EDID.

NOTE: in order for things to work, anyone that needs to read the EDID
will need to instantiate their panel using the new DP AUX bus (AKA by
listing their panel under the "aux-bus" node of the bridge chip in the
device tree).

In the future if we want to use the bridge chip to provide a full
external DP port (which won't have a panel) then we will have to
conditinally add EDID reading back in.

Suggested-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210611101711.v10.9.I9330684c25f65bb318eff57f0616500f83eac3cc@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 45a2969afb2b..aef850296756 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -124,7 +124,6 @@
  * @connector:    Our connector.
  * @host_node:    Remote DSI node.
  * @dsi:          Our MIPI DSI source.
- * @edid:         Detected EDID of eDP panel.
  * @refclk:       Our reference clock.
  * @panel:        Our panel.
  * @enable_gpio:  The GPIO we toggle to enable the bridge.
@@ -154,7 +153,6 @@ struct ti_sn65dsi86 {
 	struct drm_dp_aux		aux;
 	struct drm_bridge		bridge;
 	struct drm_connector		connector;
-	struct edid			*edid;
 	struct device_node		*host_node;
 	struct mipi_dsi_device		*dsi;
 	struct clk			*refclk;
@@ -403,24 +401,6 @@ connector_to_ti_sn65dsi86(struct drm_connector *connector)
 static int ti_sn_bridge_connector_get_modes(struct drm_connector *connector)
 {
 	struct ti_sn65dsi86 *pdata = connector_to_ti_sn65dsi86(connector);
-	struct edid *edid = pdata->edid;
-	int num, ret;
-
-	if (!edid) {
-		pm_runtime_get_sync(pdata->dev);
-		edid = pdata->edid = drm_get_edid(connector, &pdata->aux.ddc);
-		pm_runtime_put_autosuspend(pdata->dev);
-	}
-
-	if (edid && drm_edid_is_valid(edid)) {
-		ret = drm_connector_update_edid_property(connector, edid);
-		if (!ret) {
-			num = drm_add_edid_modes(connector, edid);
-			if (num)
-				return num;
-		}
-	}
-
 	return drm_panel_get_modes(pdata->panel, connector);
 }
 
@@ -1358,8 +1338,6 @@ static void ti_sn_bridge_remove(struct auxiliary_device *adev)
 		mipi_dsi_device_unregister(pdata->dsi);
 	}
 
-	kfree(pdata->edid);
-
 	drm_bridge_remove(&pdata->bridge);
 
 	of_node_put(pdata->host_node);
-- 
2.30.2

