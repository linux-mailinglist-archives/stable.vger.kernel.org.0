Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C991DB9329
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbfITOiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:38:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35694 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728899AbfITOY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:24:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0004wa-Sk; Fri, 20 Sep 2019 15:24:56 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007pr-FY; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "=?UTF-8?q?Noralf=20Tr=C3=B8nnes?=" <noralf@tronnes.org>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.173739634@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 016/132] drm/fb-helper: dpms_legacy(): Only set on
 connectors in use
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Noralf Trønnes <noralf@tronnes.org>

commit 65a102f68005891d7f39354cfd79099908df6d51 upstream.

For each enabled crtc the functions sets dpms on all registered connectors.
Limit this to only doing it once and on the connectors actually in use.

Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Fixes: 023eb571a1d0 ("drm: correctly update connector DPMS status in drm_fb_helper")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20190326175546.18126-3-noralf@tronnes.org
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_fb_helper.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -453,8 +453,8 @@ static void drm_fb_helper_dpms(struct fb
 {
 	struct drm_fb_helper *fb_helper = info->par;
 	struct drm_device *dev = fb_helper->dev;
-	struct drm_crtc *crtc;
 	struct drm_connector *connector;
+	struct drm_mode_set *modeset;
 	int i, j;
 
 	/*
@@ -475,14 +475,13 @@ static void drm_fb_helper_dpms(struct fb
 	}
 
 	for (i = 0; i < fb_helper->crtc_count; i++) {
-		crtc = fb_helper->crtc_info[i].mode_set.crtc;
+		modeset = &fb_helper->crtc_info[i].mode_set;
 
-		if (!crtc->enabled)
+		if (!modeset->crtc->enabled)
 			continue;
 
-		/* Walk the connectors & encoders on this fb turning them on/off */
-		for (j = 0; j < fb_helper->connector_count; j++) {
-			connector = fb_helper->connector_info[j]->connector;
+		for (j = 0; j < modeset->num_connectors; j++) {
+			connector = modeset->connectors[j];
 			connector->funcs->dpms(connector, dpms_mode);
 			drm_object_property_set_value(&connector->base,
 				dev->mode_config.dpms_property, dpms_mode);

