Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75142C6136
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 09:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgK0IxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 03:53:07 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45524 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgK0IxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 03:53:06 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AR8qqFL058771;
        Fri, 27 Nov 2020 02:52:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606467173;
        bh=22qq5cH0rtrp1yoHTvmHzVfEHlHoqWC5Nw0TTNSpnJQ=;
        h=From:To:CC:Subject:Date;
        b=x/Td2FQnsw8Ly3YMPNOjHZl65kkDMj2WBTnJ2kcFmUrtj75IlqPej86litB0/L5Ul
         12NeEaE2U8Xl/dqKtmVqAGGeThrgCB6mjA5xz7GzHt2uo7Dr9aiNGXPn6HkitUe3TU
         E0IU/lf9RDsW4Q4Mr7GEbZNYLrNE4FeggpqiTyos=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AR8qqPH024773
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 27 Nov 2020 02:52:52 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 27
 Nov 2020 02:52:52 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 27 Nov 2020 02:52:52 -0600
Received: from deskari.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AR8qom2074793;
        Fri, 27 Nov 2020 02:52:50 -0600
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nikhil Devshatwar <nikhil.nd@ti.com>
CC:     <linux-omap@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, <stable@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH] drm/omap: sdi: fix bridge enable/disable
Date:   Fri, 27 Nov 2020 10:52:41 +0200
Message-ID: <20201127085241.848461-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the SDI output was converted to DRM bridge, the atomic versions of
enable and disable funcs were used. This was not intended, as that would
require implementing other atomic funcs too. This leads to:

WARNING: CPU: 0 PID: 18 at drivers/gpu/drm/drm_bridge.c:708 drm_atomic_helper_commit_modeset_enables+0x134/0x268

and display not working.

Fix this by using the legacy enable/disable funcs.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Fixes: 8bef8a6d5da81b909a190822b96805a47348146f ("drm/omap: sdi: Register a drm_bridge")
Cc: stable@vger.kernel.org # v5.7+
Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/gpu/drm/omapdrm/dss/sdi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/sdi.c b/drivers/gpu/drm/omapdrm/dss/sdi.c
index 033fd30074b0..282e4c837cd9 100644
--- a/drivers/gpu/drm/omapdrm/dss/sdi.c
+++ b/drivers/gpu/drm/omapdrm/dss/sdi.c
@@ -195,8 +195,7 @@ static void sdi_bridge_mode_set(struct drm_bridge *bridge,
 	sdi->pixelclock = adjusted_mode->clock * 1000;
 }
 
-static void sdi_bridge_enable(struct drm_bridge *bridge,
-			      struct drm_bridge_state *bridge_state)
+static void sdi_bridge_enable(struct drm_bridge *bridge)
 {
 	struct sdi_device *sdi = drm_bridge_to_sdi(bridge);
 	struct dispc_clock_info dispc_cinfo;
@@ -259,8 +258,7 @@ static void sdi_bridge_enable(struct drm_bridge *bridge,
 	regulator_disable(sdi->vdds_sdi_reg);
 }
 
-static void sdi_bridge_disable(struct drm_bridge *bridge,
-			       struct drm_bridge_state *bridge_state)
+static void sdi_bridge_disable(struct drm_bridge *bridge)
 {
 	struct sdi_device *sdi = drm_bridge_to_sdi(bridge);
 
@@ -278,8 +276,8 @@ static const struct drm_bridge_funcs sdi_bridge_funcs = {
 	.mode_valid = sdi_bridge_mode_valid,
 	.mode_fixup = sdi_bridge_mode_fixup,
 	.mode_set = sdi_bridge_mode_set,
-	.atomic_enable = sdi_bridge_enable,
-	.atomic_disable = sdi_bridge_disable,
+	.enable = sdi_bridge_enable,
+	.disable = sdi_bridge_disable,
 };
 
 static void sdi_bridge_init(struct sdi_device *sdi)
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

