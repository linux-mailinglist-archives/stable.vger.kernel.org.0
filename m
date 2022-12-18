Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF754650005
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiLRQIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiLRQGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:06:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB159CE1B;
        Sun, 18 Dec 2022 08:04:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5717B80B4D;
        Sun, 18 Dec 2022 16:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4158AC433EF;
        Sun, 18 Dec 2022 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379460;
        bh=nUSiROIuywcjFmshTbQQuHbfp+Kk9J/uXgecjOrgqXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2iH8zTqYAU2+6r9ilHY/3YwsUl24CBp0uSfOPKd8RVa6mc5dxlZ9oAQRl+f/e9OB
         S/sS32Yae6CZ+f3dvWTb5j20gCS2yrBwiFaoqvSU7KaIGGqdmwAxeNOuwR+INwDQ1y
         4k0zMEDZYnn4mHt8lE8iCb2qYnm1ToNvufsP+svwEr5e8AYIRZQEGV03yt3R5AC54I
         UHS9p8znx2Kq7yImNQgQreq1r4Xqff/NWE4tV0mycnAnIT9HOVadIPlixqBNV8Dqzn
         rIIbQQWcLkhMts6Sj0Gh2oNXNeIr6sbqYAxv8e1o0lJX+e+WXOUYOXX+YGOM3d9JrZ
         W4dkIw0jkdAWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sandy Huang <hjc@rock-chips.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, airlied@gmail.com,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 39/85] drm/rockchip: Use drm_mode_copy()
Date:   Sun, 18 Dec 2022 11:00:56 -0500
Message-Id: <20221218160142.925394-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 518ee13b1d6f..8526dda91931 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -571,7 +571,7 @@ static void cdn_dp_encoder_mode_set(struct drm_encoder *encoder,
 	video->v_sync_polarity = !!(mode->flags & DRM_MODE_FLAG_NVSYNC);
 	video->h_sync_polarity = !!(mode->flags & DRM_MODE_FLAG_NHSYNC);
 
-	memcpy(&dp->mode, adjusted, sizeof(*mode));
+	drm_mode_copy(&dp->mode, adjusted);
 }
 
 static bool cdn_dp_check_link_status(struct cdn_dp_device *dp)
diff --git a/drivers/gpu/drm/rockchip/inno_hdmi.c b/drivers/gpu/drm/rockchip/inno_hdmi.c
index 87b2243ea23e..f51774866f41 100644
--- a/drivers/gpu/drm/rockchip/inno_hdmi.c
+++ b/drivers/gpu/drm/rockchip/inno_hdmi.c
@@ -499,7 +499,7 @@ static void inno_hdmi_encoder_mode_set(struct drm_encoder *encoder,
 	inno_hdmi_setup(hdmi, adj_mode);
 
 	/* Store the display mode for plugin/DPMS poweron events */
-	memcpy(&hdmi->previous_mode, adj_mode, sizeof(hdmi->previous_mode));
+	drm_mode_copy(&hdmi->previous_mode, adj_mode);
 }
 
 static void inno_hdmi_encoder_enable(struct drm_encoder *encoder)
diff --git a/drivers/gpu/drm/rockchip/rk3066_hdmi.c b/drivers/gpu/drm/rockchip/rk3066_hdmi.c
index cf2cf51091a3..90145ad96984 100644
--- a/drivers/gpu/drm/rockchip/rk3066_hdmi.c
+++ b/drivers/gpu/drm/rockchip/rk3066_hdmi.c
@@ -395,7 +395,7 @@ rk3066_hdmi_encoder_mode_set(struct drm_encoder *encoder,
 	struct rk3066_hdmi *hdmi = encoder_to_rk3066_hdmi(encoder);
 
 	/* Store the display mode for plugin/DPMS poweron events. */
-	memcpy(&hdmi->previous_mode, adj_mode, sizeof(hdmi->previous_mode));
+	drm_mode_copy(&hdmi->previous_mode, adj_mode);
 }
 
 static void rk3066_hdmi_encoder_enable(struct drm_encoder *encoder)
-- 
2.35.1

