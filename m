Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D13266C854
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbjAPQiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbjAPQh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:37:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC292BED7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 975AFB8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD49C433EF;
        Mon, 16 Jan 2023 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886385;
        bh=HCLQb5do4JIKc7tx7gSvpeCjPAm+kvzfoLaPPIroch8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4Aai8HBUwMsKhS2AFfNWBmoiaAy1pJpmLslJ50QiXoWc6MeLGiBw1SVs17RB5cVk
         XstT9lV1JoFA7i2czYBRRCxVjhC8UCmaxASOCJ3RxuXcdVOtaGa1hCgEtS2Pff6wb+
         h3TR+buBozlbTVXF+EXSV/Ly/REAgwToifgTySOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sandy Huang <hjc@rock-chips.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 409/658] drm/rockchip: Use drm_mode_copy()
Date:   Mon, 16 Jan 2023 16:48:17 +0100
Message-Id: <20230116154928.314613447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 2bfaa28000d2830d3209161a4541cce0660e1b84 ]

struct drm_display_mode embeds a list head, so overwriting
the full struct with another one will corrupt the list
(if the destination mode is on a list). Use drm_mode_copy()
instead which explicitly preserves the list head of
the destination mode.

Even if we know the destination mode is not on any list
using drm_mode_copy() seems decent as it sets a good
example. Bad examples of not using it might eventually
get copied into code where preserving the list head
actually matters.

Obviously one case not covered here is when the mode
itself is embedded in a larger structure and the whole
structure is copied. But if we are careful when copying
into modes embedded in structures I think we can be a
little more reassured that bogus list heads haven't been
propagated in.

@is_mode_copy@
@@
drm_mode_copy(...)
{
...
}

@depends on !is_mode_copy@
struct drm_display_mode *mode;
expression E, S;
@@
(
- *mode = E
+ drm_mode_copy(mode, &E)
|
- memcpy(mode, E, S)
+ drm_mode_copy(mode, E)
)

@depends on !is_mode_copy@
struct drm_display_mode mode;
expression E;
@@
(
- mode = E
+ drm_mode_copy(&mode, &E)
|
- memcpy(&mode, E, S)
+ drm_mode_copy(&mode, E)
)

@@
struct drm_display_mode *mode;
@@
- &*mode
+ mode

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Sandy Huang <hjc@rock-chips.com>
Cc: "Heiko Stübner" <heiko@sntech.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Link: https://patchwork.freedesktop.org/patch/msgid/20221107192545.9896-7-ville.syrjala@linux.intel.com
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-core.c | 2 +-
 drivers/gpu/drm/rockchip/inno_hdmi.c   | 2 +-
 drivers/gpu/drm/rockchip/rk3066_hdmi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index 67dae1354aa6..2ea672f4420d 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -563,7 +563,7 @@ static void cdn_dp_encoder_mode_set(struct drm_encoder *encoder,
 	video->v_sync_polarity = !!(mode->flags & DRM_MODE_FLAG_NVSYNC);
 	video->h_sync_polarity = !!(mode->flags & DRM_MODE_FLAG_NHSYNC);
 
-	memcpy(&dp->mode, adjusted, sizeof(*mode));
+	drm_mode_copy(&dp->mode, adjusted);
 }
 
 static bool cdn_dp_check_link_status(struct cdn_dp_device *dp)
diff --git a/drivers/gpu/drm/rockchip/inno_hdmi.c b/drivers/gpu/drm/rockchip/inno_hdmi.c
index ed344a795b4d..f2e2cc66f489 100644
--- a/drivers/gpu/drm/rockchip/inno_hdmi.c
+++ b/drivers/gpu/drm/rockchip/inno_hdmi.c
@@ -487,7 +487,7 @@ static void inno_hdmi_encoder_mode_set(struct drm_encoder *encoder,
 	inno_hdmi_setup(hdmi, adj_mode);
 
 	/* Store the display mode for plugin/DPMS poweron events */
-	memcpy(&hdmi->previous_mode, adj_mode, sizeof(hdmi->previous_mode));
+	drm_mode_copy(&hdmi->previous_mode, adj_mode);
 }
 
 static void inno_hdmi_encoder_enable(struct drm_encoder *encoder)
diff --git a/drivers/gpu/drm/rockchip/rk3066_hdmi.c b/drivers/gpu/drm/rockchip/rk3066_hdmi.c
index 85fc5f01f761..4a81c5c8a550 100644
--- a/drivers/gpu/drm/rockchip/rk3066_hdmi.c
+++ b/drivers/gpu/drm/rockchip/rk3066_hdmi.c
@@ -382,7 +382,7 @@ rk3066_hdmi_encoder_mode_set(struct drm_encoder *encoder,
 	struct rk3066_hdmi *hdmi = to_rk3066_hdmi(encoder);
 
 	/* Store the display mode for plugin/DPMS poweron events. */
-	memcpy(&hdmi->previous_mode, adj_mode, sizeof(hdmi->previous_mode));
+	drm_mode_copy(&hdmi->previous_mode, adj_mode);
 }
 
 static void rk3066_hdmi_encoder_enable(struct drm_encoder *encoder)
-- 
2.35.1



