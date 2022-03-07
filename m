Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077074CF6BD
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbiCGJmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241011AbiCGJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810D46D393;
        Mon,  7 Mar 2022 01:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCF6B810B2;
        Mon,  7 Mar 2022 09:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8F9C340E9;
        Mon,  7 Mar 2022 09:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645944;
        bh=R8/1XpnUCRmWuxRq57W415mmpgzGhzNlkkynV5S82N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgSkcnEPNH2k5aHF0wwmZwIftXBSAnjFUbvTvr0DjSEX7TvZrTQInTnKwdyTVvT/L
         ZC+kqJqWTveqs3elVwe538HmuJi2EaFbDSA0jlepmbo4hriFojvWYFhmKUf2YDyYfA
         +mcloMJ/iva1vHr712DHWAS6xmgqUXswhhnbD8ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/262] drm/atomic: Check new_crtc_state->active to determine if CRTC needs disable in self refresh mode
Date:   Mon,  7 Mar 2022 10:17:07 +0100
Message-Id: <20220307091704.827402975@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 69e630016ef4e4a1745310c446f204dc6243e907 ]

Actual hardware state of CRTC is controlled by the member 'active' in
struct drm_crtc_state instead of the member 'enable', according to the
kernel doc of the member 'enable'.  In fact, the drm client modeset
and atomic helpers are using the member 'active' to do the control.

Referencing the member 'enable' of new_crtc_state, the function
crtc_needs_disable() may fail to reflect if CRTC needs disable in
self refresh mode, e.g., when the framebuffer emulation will be blanked
through the client modeset helper with the next commit, the member
'enable' of new_crtc_state is still true while the member 'active' is
false, hence the relevant potential encoder and bridges won't be disabled.

So, let's check new_crtc_state->active to determine if CRTC needs disable
in self refresh mode instead of new_crtc_state->enable.

Fixes: 1452c25b0e60 ("drm: Add helpers to kick off self refresh mode in drivers")
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Rob Clark <robdclark@chromium.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211230040626.646807-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 2c0c6ec928200..ff2bc9a118011 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1001,7 +1001,7 @@ crtc_needs_disable(struct drm_crtc_state *old_state,
 	 * it's in self refresh mode and needs to be fully disabled.
 	 */
 	return old_state->active ||
-	       (old_state->self_refresh_active && !new_state->enable) ||
+	       (old_state->self_refresh_active && !new_state->active) ||
 	       new_state->self_refresh_active;
 }
 
-- 
2.34.1



