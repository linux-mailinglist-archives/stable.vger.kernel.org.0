Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11E1797CD
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390058AbfG2TqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390051AbfG2TqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 866742171F;
        Mon, 29 Jul 2019 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429563;
        bh=DWUUnzFNgLaVE7J8zIwm2jy31/hoonbPAzRNCUQY77g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfMzFzir/ImPrnD7Ck+FlElRZayVvHZk66VrwDaGD/xPffsatJT92euq45zX6S8ay
         ZkfjmUz3jkv+tvY5usEEuIXNGxj6/i01+dxFfzz+5UaO0JNDwgTu0mBYXRb6V/hBhJ
         /xptiSzqQsUQc/0pB2PqRzU+Ou9YOUR1AlE2sTAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sun peng Li <Sunpeng.Li@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 023/215] drm/amd/display: Disable cursor when offscreen in negative direction
Date:   Mon, 29 Jul 2019 21:20:19 +0200
Message-Id: <20190729190743.902352878@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e371e19c10a264bd72c2ff1d21e2167b994710d1 ]

[Why]
When x or y is negative we set the x and y values to 0 and compensate
with a positive cursor hotspot in DM since DC expects positive cursor
values.

When x or y is less than or equal to the maximum cursor width or height
the cursor hotspot is clamped so the hotspot doesn't exceed the
cursor size:

if (x < 0) {
        xorigin = min(-x, amdgpu_crtc->max_cursor_width - 1);
        x = 0;
}

if (y < 0) {
        yorigin = min(-y, amdgpu_crtc->max_cursor_height - 1);
        y = 0;
}

This incorrectly forces the cursor to be at least 1 pixel on the screen
in either direction when x or y is sufficiently negative.

[How]
Just disable the cursor when it goes far enough off the screen in one
of these directions.

This fixes kms_cursor_crc@cursor-256x256-offscreen.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Sun peng Li <Sunpeng.Li@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ab7c5c3004ee..fa268dd736f4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4952,12 +4952,12 @@ static int get_cursor_position(struct drm_plane *plane, struct drm_crtc *crtc,
 	int x, y;
 	int xorigin = 0, yorigin = 0;
 
-	if (!crtc || !plane->state->fb) {
-		position->enable = false;
-		position->x = 0;
-		position->y = 0;
+	position->enable = false;
+	position->x = 0;
+	position->y = 0;
+
+	if (!crtc || !plane->state->fb)
 		return 0;
-	}
 
 	if ((plane->state->crtc_w > amdgpu_crtc->max_cursor_width) ||
 	    (plane->state->crtc_h > amdgpu_crtc->max_cursor_height)) {
@@ -4971,6 +4971,10 @@ static int get_cursor_position(struct drm_plane *plane, struct drm_crtc *crtc,
 	x = plane->state->crtc_x;
 	y = plane->state->crtc_y;
 
+	if (x <= -amdgpu_crtc->max_cursor_width ||
+	    y <= -amdgpu_crtc->max_cursor_height)
+		return 0;
+
 	if (crtc->primary->state) {
 		/* avivo cursor are offset into the total surface */
 		x += crtc->primary->state->src_x >> 16;
-- 
2.20.1



