Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC593650308
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiLRQ5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiLRQ4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:56:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32F81C428;
        Sun, 18 Dec 2022 08:19:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B4DDB80BD1;
        Sun, 18 Dec 2022 16:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797E8C433D2;
        Sun, 18 Dec 2022 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380364;
        bh=W+IcFTVx0VkQg4HKtFx5uc2tChB3WMlWjwn4LlfMPpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgBQPkfF94bzDjTqBXDOv4NQfYvKt9DnItDpjU/T2YEGSxd7iuY9H7yZcqyF9TkGe
         IWmpGOsp7p/RpR+OaLNITCAQHdHnqYZV97FRX05kRjDbBO5rTfvhUf3fvCTLlNQArB
         RWpbzdHSDsGfmQQ7nOlDP4uG/71vDJ6RiDOcv3uwBB/8e6ck356zJCuwkVYFpe/O41
         i9T1s25hQ9jNOSUFnVSfKsbT8uq0K63OHrlKb9ikmgIJSr9DfbZbpGGmaqxughD+Je
         tVXSc2Pnd8/dAdtkyV5pUECmDGZ9AuPNC5sstfoTr3HBxE3bihX82pa3MmfPP3FCLB
         6vIO/La3MTK0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Alain Volmat <alain.volmat@foss.st.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, airlied@gmail.com,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 16/30] drm/sti: Use drm_mode_copy()
Date:   Sun, 18 Dec 2022 11:18:21 -0500
Message-Id: <20221218161836.933697-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161836.933697-1-sashal@kernel.org>
References: <20221218161836.933697-1-sashal@kernel.org>
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

[ Upstream commit 442cf8e22ba25a77cb9092d78733fdbac9844e50 ]

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

Cc: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221107192545.9896-8-ville.syrjala@linux.intel.com
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_dvo.c  | 2 +-
 drivers/gpu/drm/sti/sti_hda.c  | 2 +-
 drivers/gpu/drm/sti/sti_hdmi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_dvo.c b/drivers/gpu/drm/sti/sti_dvo.c
index e55870190bf5..3c65c73aa854 100644
--- a/drivers/gpu/drm/sti/sti_dvo.c
+++ b/drivers/gpu/drm/sti/sti_dvo.c
@@ -287,7 +287,7 @@ static void sti_dvo_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&dvo->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&dvo->mode, mode);
 
 	/* According to the path used (main or aux), the dvo clocks should
 	 * have a different parent clock. */
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 94e404f13234..158192680bea 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -522,7 +522,7 @@ static void sti_hda_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&hda->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hda->mode, mode);
 
 	if (!hda_get_mode_idx(hda->mode, &mode_idx)) {
 		DRM_ERROR("Undefined mode\n");
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 9862c322f0c4..c91ce51836ca 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -933,7 +933,7 @@ static void sti_hdmi_set_mode(struct drm_bridge *bridge,
 	DRM_DEBUG_DRIVER("\n");
 
 	/* Copy the drm display mode in the connector local structure */
-	memcpy(&hdmi->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hdmi->mode, mode);
 
 	/* Update clock framerate according to the selected mode */
 	ret = clk_set_rate(hdmi->clk_pix, mode->clock * 1000);
-- 
2.35.1

