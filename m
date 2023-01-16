Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4866366CB61
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbjAPROf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbjAPRNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBEF4B1B3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBB5ECE1230
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1C8C433D2;
        Mon, 16 Jan 2023 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887995;
        bh=QRa0eIVbsbW9g5JpvfzL7feFfmbM1zfjhgxh46De3JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3+vBOHmOCIg5BvMH3YVHBM/JJjYFxq+X3tnofJFN5GPOh8ilDC/2Ia/Bw/5vM9ax
         iWjLkLHvurT08U6HKcpM2qOfastfBte6aTIOS52ZQlE6l5HeazJVEaEY6jOD6FlRSw
         cvfcGkhXnkvtf5hS8/r7A8zzwIlWg35d7N5OHVYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alain Volmat <alain.volmat@foss.st.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 331/521] drm/sti: Use drm_mode_copy()
Date:   Mon, 16 Jan 2023 16:49:53 +0100
Message-Id: <20230116154901.978493822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index b08376b7611b..a3f01721c552 100644
--- a/drivers/gpu/drm/sti/sti_dvo.c
+++ b/drivers/gpu/drm/sti/sti_dvo.c
@@ -288,7 +288,7 @@ static void sti_dvo_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&dvo->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&dvo->mode, mode);
 
 	/* According to the path used (main or aux), the dvo clocks should
 	 * have a different parent clock. */
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 19b9b5ed1297..33c9efa06f68 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -518,7 +518,7 @@ static void sti_hda_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&hda->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hda->mode, mode);
 
 	if (!hda_get_mode_idx(hda->mode, &mode_idx)) {
 		DRM_ERROR("Undefined mode\n");
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index ccf718404a1c..3acf044ba366 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -926,7 +926,7 @@ static void sti_hdmi_set_mode(struct drm_bridge *bridge,
 	DRM_DEBUG_DRIVER("\n");
 
 	/* Copy the drm display mode in the connector local structure */
-	memcpy(&hdmi->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hdmi->mode, mode);
 
 	/* Update clock framerate according to the selected mode */
 	ret = clk_set_rate(hdmi->clk_pix, mode->clock * 1000);
-- 
2.35.1



