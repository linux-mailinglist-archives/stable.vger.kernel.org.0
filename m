Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EBC37C332
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhELPRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234177AbhELPQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E14A36194C;
        Wed, 12 May 2021 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831937;
        bh=g3z/VwvYcWPvXsOl/h0/INg1UucPJtQvm4R8DOaBu5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sH9uiYpXF4XCnqfgTpONhUkunmO7iNst4iXV+/LSlbD6SqNzD6o7hlTOPudu2Wlhp
         9Pe3qHgYe0LmkT4eCqkil05nWvGRKOZpSfIoGMjRxfDLd1xq/Fp0qzxm5o5Y2PTG1d
         wDkWraiw7QXPGLJ2m4P4ADjum+gROFxLpZCB43bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        nicholas.kazlauskas@amd.com, amd-gfx@lists.freedesktop.org,
        alexander.deucher@amd.com, Roman.Li@amd.com, hersenxs.wu@amd.com,
        danny.wang@amd.com,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.10 068/530] drm/amd/display: Reject non-zero src_y and src_x for video planes
Date:   Wed, 12 May 2021 16:42:58 +0200
Message-Id: <20210512144821.996286372@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

commit d89f6048bdcb6a56abb396c584747d5eeae650db upstream.

[Why]
This hasn't been well tested and leads to complete system hangs on DCN1
based systems, possibly others.

The system hang can be reproduced by gesturing the video on the YouTube
Android app on ChromeOS into full screen.

[How]
Reject atomic commits with non-zero drm_plane_state.src_x or src_y values.

v2:
 - Add code comment describing the reason we're rejecting non-zero
   src_x and src_y
 - Drop gerrit Change-Id
 - Add stable CC
 - Based on amd-staging-drm-next

v3: removed trailing whitespace

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Cc: stable@vger.kernel.org
Cc: nicholas.kazlauskas@amd.com
Cc: amd-gfx@lists.freedesktop.org
Cc: alexander.deucher@amd.com
Cc: Roman.Li@amd.com
Cc: hersenxs.wu@amd.com
Cc: danny.wang@amd.com
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3685,6 +3685,23 @@ static int fill_dc_scaling_info(const st
 	scaling_info->src_rect.x = state->src_x >> 16;
 	scaling_info->src_rect.y = state->src_y >> 16;
 
+	/*
+	 * For reasons we don't (yet) fully understand a non-zero
+	 * src_y coordinate into an NV12 buffer can cause a
+	 * system hang. To avoid hangs (and maybe be overly cautious)
+	 * let's reject both non-zero src_x and src_y.
+	 *
+	 * We currently know of only one use-case to reproduce a
+	 * scenario with non-zero src_x and src_y for NV12, which
+	 * is to gesture the YouTube Android app into full screen
+	 * on ChromeOS.
+	 */
+	if (state->fb &&
+	    state->fb->format->format == DRM_FORMAT_NV12 &&
+	    (scaling_info->src_rect.x != 0 ||
+	     scaling_info->src_rect.y != 0))
+		return -EINVAL;
+
 	scaling_info->src_rect.width = state->src_w >> 16;
 	if (scaling_info->src_rect.width == 0)
 		return -EINVAL;


