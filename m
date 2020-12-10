Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2912D6024
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391279AbgLJOkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391259AbgLJOjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:55 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5.9 34/75] drm/omap: sdi: fix bridge enable/disable
Date:   Thu, 10 Dec 2020 15:26:59 +0100
Message-Id: <20201210142607.741521655@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit fd4e788e971ce763e50762d7b1a0048992949dd0 upstream.

When the SDI output was converted to DRM bridge, the atomic versions of
enable and disable funcs were used. This was not intended, as that would
require implementing other atomic funcs too. This leads to:

WARNING: CPU: 0 PID: 18 at drivers/gpu/drm/drm_bridge.c:708 drm_atomic_helper_commit_modeset_enables+0x134/0x268

and display not working.

Fix this by using the legacy enable/disable funcs.

Fixes: 8bef8a6d5da81b909a190822b96805a47348146f ("drm/omap: sdi: Register a drm_bridge")
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v5.7+
Link: https://patchwork.freedesktop.org/patch/msgid/20201127085241.848461-1-tomi.valkeinen@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/omapdrm/dss/sdi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/omapdrm/dss/sdi.c
+++ b/drivers/gpu/drm/omapdrm/dss/sdi.c
@@ -195,8 +195,7 @@ static void sdi_bridge_mode_set(struct d
 	sdi->pixelclock = adjusted_mode->clock * 1000;
 }
 
-static void sdi_bridge_enable(struct drm_bridge *bridge,
-			      struct drm_bridge_state *bridge_state)
+static void sdi_bridge_enable(struct drm_bridge *bridge)
 {
 	struct sdi_device *sdi = drm_bridge_to_sdi(bridge);
 	struct dispc_clock_info dispc_cinfo;
@@ -259,8 +258,7 @@ err_get_dispc:
 	regulator_disable(sdi->vdds_sdi_reg);
 }
 
-static void sdi_bridge_disable(struct drm_bridge *bridge,
-			       struct drm_bridge_state *bridge_state)
+static void sdi_bridge_disable(struct drm_bridge *bridge)
 {
 	struct sdi_device *sdi = drm_bridge_to_sdi(bridge);
 
@@ -278,8 +276,8 @@ static const struct drm_bridge_funcs sdi
 	.mode_valid = sdi_bridge_mode_valid,
 	.mode_fixup = sdi_bridge_mode_fixup,
 	.mode_set = sdi_bridge_mode_set,
-	.atomic_enable = sdi_bridge_enable,
-	.atomic_disable = sdi_bridge_disable,
+	.enable = sdi_bridge_enable,
+	.disable = sdi_bridge_disable,
 };
 
 static void sdi_bridge_init(struct sdi_device *sdi)


