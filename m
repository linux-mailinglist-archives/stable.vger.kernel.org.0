Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF53ED5DC
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbhHPNPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237488AbhHPNNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F55604DC;
        Mon, 16 Aug 2021 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119462;
        bh=t5M0W33Z9fidm4K+RfV5V0u9R2V/XBTaDp/9IQYqB9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFt0fcfSmcPHjMVMnpJxIQl4lQV8k7lyH3cfb4rhI6WufetXUQtjzvBGdYpnR8NFd
         mM0OjF9xrEkAyqJTqCw7PI7wN9hUJeh5Y5F7yWs/xpAao4FcrAuSjWL4ha4pJ9OzoD
         CmHJJf5A+UwDnXVr0zyuAo4TBSM2lAq0FPQ1Gfvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 036/151] drm/amdgpu: Add preferred mode in modeset when freesync video modes enabled.
Date:   Mon, 16 Aug 2021 15:01:06 +0200
Message-Id: <20210816125445.276522814@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Solomon Chiu <solomon.chiu@amd.com>

commit 46dd2965bdd1c5a4f6499c73ff32e636fa8f9769 upstream.

[Why]
With kernel module parameter "freesync_video" is enabled, if the mode
is changed to preferred mode(the mode with highest rate), then Freesync
fails because the preferred mode is treated as one of freesync video
mode, and then be configurated as freesync video mode(fixed refresh
rate).

[How]
Skip freesync fixed rate configurating when modeset to preferred mode.

Signed-off-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9410,7 +9410,12 @@ static int dm_update_crtc_state(struct a
 		} else if (amdgpu_freesync_vid_mode && aconnector &&
 			   is_freesync_video_mode(&new_crtc_state->mode,
 						  aconnector)) {
-			set_freesync_fixed_config(dm_new_crtc_state);
+			struct drm_display_mode *high_mode;
+
+			high_mode = get_highest_refresh_rate_mode(aconnector, false);
+			if (!drm_mode_equal(&new_crtc_state->mode, high_mode)) {
+				set_freesync_fixed_config(dm_new_crtc_state);
+			}
 		}
 
 		ret = dm_atomic_get_state(state, &dm_state);


