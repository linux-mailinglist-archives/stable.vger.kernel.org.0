Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884C7499A77
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573061AbiAXVoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45900 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454866AbiAXVeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:34:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E870AB8123A;
        Mon, 24 Jan 2022 21:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B60EC340E4;
        Mon, 24 Jan 2022 21:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060038;
        bh=R8/1XpnUCRmWuxRq57W415mmpgzGhzNlkkynV5S82N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONeBL5Gsat1wRL+yUfAG109shpgcP7hJC1dKEo5TaVH6BXZ34Iq22qnkggFbS53/k
         56YAn1J814O525y6s2MK4XfXDQWHqLphJS5p0xGuLt9Qi9TC7ij2+aKbniRyjw/o53
         QLi5oWqapXKdvmk4lyWexFlihdCmelatJdiBxa5I=
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
Subject: [PATCH 5.16 0818/1039] drm/atomic: Check new_crtc_state->active to determine if CRTC needs disable in self refresh mode
Date:   Mon, 24 Jan 2022 19:43:27 +0100
Message-Id: <20220124184152.800331782@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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



