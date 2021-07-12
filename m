Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0383C4DC2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbhGLHOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242170AbhGLHNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:13:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4EDF61353;
        Mon, 12 Jul 2021 07:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073831;
        bh=3OQ/sewAJ9cM2Ey67nIAVt+8eXqwufWd/zFoAb6w5rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLBFMO80Ve7p3fDzb3y1eBMTdmmlRqcFfOq8rxWeso9XLVhHuAOR/7bOZ8wpS0ymD
         c9OXqGSgGn9kSpY7bL9OYFGXrWZhvjbpQ7tGaEzb4j7NE+bLIKpAKxbZDpatdjGD/J
         DbUOgiTJeVNSIOz/bOpjSb9KKglwc4erAhwkzVrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 374/700] drm/vc4: crtc: Lookup the encoder from the register at boot
Date:   Mon, 12 Jul 2021 08:07:37 +0200
Message-Id: <20210712061016.149357046@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit b601c16b7ba8f3bb7a7e773b238da6b63657fa1d ]

At boot, we can't rely on the vc4_get_crtc_encoder since we don't have a
state yet and thus will not be able to figure out which connector is
attached to our CRTC.

However, we have a muxing bit in the CRTC register we can use to get the
encoder currently connected to the pixelvalve. We can thus read that
register, lookup the associated register through the vc4_pv_data
structure, and then pass it to vc4_crtc_disable so that we can perform
the proper operations.

Fixes: 875a4d536842 ("drm/vc4: drv: Disable the CRTC at boot time")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210507150515.257424-6-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 38 ++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 1733add20498..1f36b67cd6ce 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -430,11 +430,10 @@ static void require_hvs_enabled(struct drm_device *dev)
 }
 
 static int vc4_crtc_disable(struct drm_crtc *crtc,
+			    struct drm_encoder *encoder,
 			    struct drm_atomic_state *state,
 			    unsigned int channel)
 {
-	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc, state,
-							   drm_atomic_get_old_connector_state);
 	struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
 	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
@@ -475,10 +474,29 @@ static int vc4_crtc_disable(struct drm_crtc *crtc,
 	return 0;
 }
 
+static struct drm_encoder *vc4_crtc_get_encoder_by_type(struct drm_crtc *crtc,
+							enum vc4_encoder_type type)
+{
+	struct drm_encoder *encoder;
+
+	drm_for_each_encoder(encoder, crtc->dev) {
+		struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
+
+		if (vc4_encoder->type == type)
+			return encoder;
+	}
+
+	return NULL;
+}
+
 int vc4_crtc_disable_at_boot(struct drm_crtc *crtc)
 {
 	struct drm_device *drm = crtc->dev;
 	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
+	enum vc4_encoder_type encoder_type;
+	const struct vc4_pv_data *pv_data;
+	struct drm_encoder *encoder;
+	unsigned encoder_sel;
 	int channel;
 
 	if (!(of_device_is_compatible(vc4_crtc->pdev->dev.of_node,
@@ -497,7 +515,17 @@ int vc4_crtc_disable_at_boot(struct drm_crtc *crtc)
 	if (channel < 0)
 		return 0;
 
-	return vc4_crtc_disable(crtc, NULL, channel);
+	encoder_sel = VC4_GET_FIELD(CRTC_READ(PV_CONTROL), PV_CONTROL_CLK_SELECT);
+	if (WARN_ON(encoder_sel != 0))
+		return 0;
+
+	pv_data = vc4_crtc_to_vc4_pv_data(vc4_crtc);
+	encoder_type = pv_data->encoder_types[encoder_sel];
+	encoder = vc4_crtc_get_encoder_by_type(crtc, encoder_type);
+	if (WARN_ON(!encoder))
+		return 0;
+
+	return vc4_crtc_disable(crtc, encoder, NULL, channel);
 }
 
 static void vc4_crtc_atomic_disable(struct drm_crtc *crtc,
@@ -506,6 +534,8 @@ static void vc4_crtc_atomic_disable(struct drm_crtc *crtc,
 	struct drm_crtc_state *old_state = drm_atomic_get_old_crtc_state(state,
 									 crtc);
 	struct vc4_crtc_state *old_vc4_state = to_vc4_crtc_state(old_state);
+	struct drm_encoder *encoder = vc4_get_crtc_encoder(crtc, state,
+							   drm_atomic_get_old_connector_state);
 	struct drm_device *dev = crtc->dev;
 
 	require_hvs_enabled(dev);
@@ -513,7 +543,7 @@ static void vc4_crtc_atomic_disable(struct drm_crtc *crtc,
 	/* Disable vblank irq handling before crtc is disabled. */
 	drm_crtc_vblank_off(crtc);
 
-	vc4_crtc_disable(crtc, state, old_vc4_state->assigned_channel);
+	vc4_crtc_disable(crtc, encoder, state, old_vc4_state->assigned_channel);
 
 	/*
 	 * Make sure we issue a vblank event after disabling the CRTC if
-- 
2.30.2



