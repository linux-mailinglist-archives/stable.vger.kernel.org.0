Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57955548BA6
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376608AbiFMNWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377502AbiFMNUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AF06AA7F;
        Mon, 13 Jun 2022 04:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3881A61046;
        Mon, 13 Jun 2022 11:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A754C34114;
        Mon, 13 Jun 2022 11:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119360;
        bh=E4rQH1VFVcVFFMQSB2xDZNS++oZ3MPwR5If0rkwwWrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/o882kbVoODy65h4MX7V0agq1DBX3LLh5PqaCE7HRbXJjjplNT2crBQiy2bvzbJr
         o791JO20qJjIY4DJ4yLARQ4LCskOki35g7bH2MQpt9cuRCCFOdKoDYAftWjxd04sLK
         O1vYg6v5cQc2wYGss+WZ0H+/xe26I1nhDQcbAmao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 5.15 235/247] drm/bridge: analogix_dp: Support PSR-exit to disable transition
Date:   Mon, 13 Jun 2022 12:12:17 +0200
Message-Id: <20220613094930.071901491@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit ca871659ec1606d33b1e76de8d4cf924cf627e34 upstream.

Most eDP panel functions only work correctly when the panel is not in
self-refresh. In particular, analogix_dp_bridge_disable() tends to hit
AUX channel errors if the panel is in self-refresh.

Given the above, it appears that so far, this driver assumes that we are
never in self-refresh when it comes time to fully disable the bridge.
Prior to commit 846c7dfc1193 ("drm/atomic: Try to preserve the crtc
enabled state in drm_atomic_remove_fb, v2."), this tended to be true,
because we would automatically disable the pipe when framebuffers were
removed, and so we'd typically disable the bridge shortly after the last
display activity.

However, that is not guaranteed: an idle (self-refresh) display pipe may
be disabled, e.g., when switching CRTCs. We need to exit PSR first.

Stable notes: this is definitely a bugfix, and the bug has likely
existed in some form for quite a while. It may predate the "PSR helpers"
refactor, but the code looked very different before that, and it's
probably not worth rewriting the fix.

Cc: <stable@vger.kernel.org>
Fixes: 6c836d965bad ("drm/rockchip: Use the helpers for PSR")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220228122522.v2.1.I161904be17ba14526f78536ccd78b85818449b51@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   42 +++++++++++++++++++--
 1 file changed, 38 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1269,6 +1269,25 @@ static int analogix_dp_bridge_attach(str
 }
 
 static
+struct drm_crtc *analogix_dp_get_old_crtc(struct analogix_dp_device *dp,
+					  struct drm_atomic_state *state)
+{
+	struct drm_encoder *encoder = dp->encoder;
+	struct drm_connector *connector;
+	struct drm_connector_state *conn_state;
+
+	connector = drm_atomic_get_old_connector_for_encoder(state, encoder);
+	if (!connector)
+		return NULL;
+
+	conn_state = drm_atomic_get_old_connector_state(state, connector);
+	if (!conn_state)
+		return NULL;
+
+	return conn_state->crtc;
+}
+
+static
 struct drm_crtc *analogix_dp_get_new_crtc(struct analogix_dp_device *dp,
 					  struct drm_atomic_state *state)
 {
@@ -1448,14 +1467,16 @@ analogix_dp_bridge_atomic_disable(struct
 {
 	struct drm_atomic_state *old_state = old_bridge_state->base.state;
 	struct analogix_dp_device *dp = bridge->driver_private;
-	struct drm_crtc *crtc;
+	struct drm_crtc *old_crtc, *new_crtc;
+	struct drm_crtc_state *old_crtc_state = NULL;
 	struct drm_crtc_state *new_crtc_state = NULL;
+	int ret;
 
-	crtc = analogix_dp_get_new_crtc(dp, old_state);
-	if (!crtc)
+	new_crtc = analogix_dp_get_new_crtc(dp, old_state);
+	if (!new_crtc)
 		goto out;
 
-	new_crtc_state = drm_atomic_get_new_crtc_state(old_state, crtc);
+	new_crtc_state = drm_atomic_get_new_crtc_state(old_state, new_crtc);
 	if (!new_crtc_state)
 		goto out;
 
@@ -1464,6 +1485,19 @@ analogix_dp_bridge_atomic_disable(struct
 		return;
 
 out:
+	old_crtc = analogix_dp_get_old_crtc(dp, old_state);
+	if (old_crtc) {
+		old_crtc_state = drm_atomic_get_old_crtc_state(old_state,
+							       old_crtc);
+
+		/* When moving from PSR to fully disabled, exit PSR first. */
+		if (old_crtc_state && old_crtc_state->self_refresh_active) {
+			ret = analogix_dp_disable_psr(dp);
+			if (ret)
+				DRM_ERROR("Failed to disable psr (%d)\n", ret);
+		}
+	}
+
 	analogix_dp_bridge_disable(bridge);
 }
 


