Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B924C7A50
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiB1U0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiB1U0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:26:36 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714B8580D3
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:25:56 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id s1so11694436plg.12
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q/kujwU53LIHA+6qbaR6L172g+N0qfJq1momfjRWA7k=;
        b=KlXScky4uYLsmapPfYpqRVJn+v5yB8SYCNygbpuxCtT03WvcWzSV+YtFtUEn5HaIzt
         1NBkZd0i1EBpIQGZ4RLkkzn0LYHOKK5pKkTCS4S8ovW+NqUDC2vu6GfneZaLtsH1qmgc
         NX2FQnfvNIJDJjlpFBW8NnmkRbVUjVlCKLhdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/kujwU53LIHA+6qbaR6L172g+N0qfJq1momfjRWA7k=;
        b=dgFdAjyun3wUPwAQDLLeO8/kPJwLETOKhOEj8bkm3dyn2spTjJQPKMPxOQ3glLY6Io
         9oM3/GswphAc2/9YVi5DAXXYcYC8xmliwh7XpU5YJu1qoSe25bvrmHSFAjGAvkaZC9qF
         BemmpF5jmEO9IeOy6X1n5Xt1vb8LXN4b3u19QzltH2ITTmeShAjzXO1hONWP1LaHZDGd
         UlFD8qUnlaFgs1pGitMTRxMrrXd+nrymRo8ZXjW4F1yJPn+12EB6SVp50e/tYWH3sfEL
         uWsyeMJBPXfGTpByTKuR64+i6td/oJPeorIsi+HYQbRLKAleDpYkfGrUjFzS1pLboBWx
         4RPw==
X-Gm-Message-State: AOAM532taKY47NsfklAgjUIhEbGG3Gwf0rynG7qRbV1w06fZBwxVPc2T
        /IKI3pQNKpHVHEc6albGvov4ag==
X-Google-Smtp-Source: ABdhPJwfQqePqhEgyGCgn0a8sqU2kE0Lhi+C4DZ/skKSYhTytmMd1RN41W0QPxIhxRsqLvWhBTfuSQ==
X-Received: by 2002:a17:90a:1b4f:b0:1bc:2c9e:bce8 with SMTP id q73-20020a17090a1b4f00b001bc2c9ebce8mr18102438pjq.143.1646079955991;
        Mon, 28 Feb 2022 12:25:55 -0800 (PST)
Received: from localhost ([2620:15c:202:201:ba66:7507:a6af:82f1])
        by smtp.gmail.com with UTF8SMTPSA id u8-20020a056a00098800b004f36335ecf0sm14841793pfg.146.2022.02.28.12.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:25:55 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     dri-devel@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sean Paul <sean@poorly.run>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] drm/bridge: analogix_dp: Support PSR-exit to disable transition
Date:   Mon, 28 Feb 2022 12:25:31 -0800
Message-Id: <20220228122522.v2.1.I161904be17ba14526f78536ccd78b85818449b51@changeid>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
In-Reply-To: <20220228202532.869740-1-briannorris@chromium.org>
References: <20220228202532.869740-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

(no changes since v1)

 .../drm/bridge/analogix/analogix_dp_core.c    | 42 +++++++++++++++++--
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index b7d2e4449cfa..6ee0f62a7161 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1268,6 +1268,25 @@ static int analogix_dp_bridge_attach(struct drm_bridge *bridge,
 	return 0;
 }
 
+static
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
 static
 struct drm_crtc *analogix_dp_get_new_crtc(struct analogix_dp_device *dp,
 					  struct drm_atomic_state *state)
@@ -1448,14 +1467,16 @@ analogix_dp_bridge_atomic_disable(struct drm_bridge *bridge,
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
 
@@ -1464,6 +1485,19 @@ analogix_dp_bridge_atomic_disable(struct drm_bridge *bridge,
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
 
-- 
2.35.1.574.g5d30c73bfb-goog

