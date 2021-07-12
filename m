Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0623C5386
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347947AbhGLHzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350433AbhGLHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E512616EA;
        Mon, 12 Jul 2021 07:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075913;
        bh=Zm90f/uoWZTXOY8epm/7gbhy/aUd5DY2r0s+gfdl/04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCzMMgcEcrrAGt4In6Wb/2i+YRs44+wCs2GLM3ljr3uadHfJJH2ApdY0vaGRkseb3
         VDNsAe89PCvbdy39jb747ktFRGG32s2uM+stOf/dd34ZDufRvp0phPduxVBU8F1bCk
         vEeMuyb8g1aPJ35l13Ht5ry4Vx5PB6I/S5XcZaJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 417/800] drm/vc4: crtc: Fix vc4_get_crtc_encoder logic
Date:   Mon, 12 Jul 2021 08:07:20 +0200
Message-Id: <20210712061011.563686927@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 5a184d959d5a5a66b377cb5cd4c95a80388e0c88 ]

The vc4_get_crtc_encoder function currently only works when the
connector->state->crtc pointer is set, which is only true when the
connector is currently enabled.

However, we use it as part of the disable path as well, and our lookup
will fail in that case, resulting in it returning a null pointer we
can't act on.

We can access the connector that used to be connected to that crtc
though using the old connector state in the disable path.

Since we want to support both the enable and disable path, we can
support it by passing the state accessor variant as a function pointer,
together with the atomic state.

Fixes: 792c3132bc1b ("drm/vc4: encoder: Add finer-grained encoder callbacks")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210507150515.257424-5-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index d079303cc426..1733add20498 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -279,14 +279,22 @@ static u32 vc4_crtc_get_fifo_full_level_bits(struct vc4_crtc *vc4_crtc,
  * allows drivers to push pixels to more than one encoder from the
  * same CRTC.
  */
-static struct drm_encoder *vc4_get_crtc_encoder(struct drm_crtc *crtc)
+static struct drm_encoder *vc4_get_crtc_encoder(struct drm_crtc *crtc,
+						struct drm_atomic_state *state,
+						struct drm_connector_state *(*get_state)(struct drm_atomic_state *state,
+											 struct drm_connector *connector))
 {
 	struct drm_connector *connector;
 	struct drm_connector_list_iter conn_iter;
 
 	drm_connector_list_iter_begin(crtc->dev, &conn_iter);
 	drm_for_each_connector_iter(connector, &conn_iter) {
-		if (connector->state->crtc == crtc) {
+		struct drm_connector_state *conn_state = get_state(state, connector);
+
+		if (!conn_state)
+			continue;
+
+		if (conn_state->crtc == crtc) {
 			drm_connector_list_iter_end(&conn_iter);
 			return connector->encoder;
 		}
@@ -309,7 +317,8 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_atomic_state *s
 {
 	struct drm_device *dev = crtc->dev;
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
-	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc);
+	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc, state,
+							   drm_atomic_get_new_connector_state);
 	struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
 	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
 	const struct vc4_pv_data *pv_data = vc4_crtc_to_vc4_pv_data(vc4_crtc);
@@ -424,7 +433,8 @@ static int vc4_crtc_disable(struct drm_crtc *crtc,
 			    struct drm_atomic_state *state,
 			    unsigned int channel)
 {
-	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc);
+	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc, state,
+							   drm_atomic_get_old_connector_state);
 	struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
 	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
@@ -524,7 +534,8 @@ static void vc4_crtc_atomic_enable(struct drm_crtc *crtc,
 {
 	struct drm_device *dev = crtc->dev;
 	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
-	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc);
+	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc, state,
+							   drm_atomic_get_new_connector_state);
 	struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
 
 	require_hvs_enabled(dev);
-- 
2.30.2



