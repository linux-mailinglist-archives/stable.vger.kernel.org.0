Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249706E02D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfGSD5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbfGSD5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0914A21852;
        Fri, 19 Jul 2019 03:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508663;
        bh=fnhJtHhZ7psncufqizd+johqm8CCDOQCcGb61BQAxMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRqbRgIf84hL8vDyIJkdhQECnhmt84w9FjXKgcYDw8dAZktKWlox09LVdr+FWX4zU
         fkZ3QnsUq5DfHCDTExcfkLlQmR8G+5Bfhuq18/TTm+Yv5GXKqHipuzYQTPUrGRJkpV
         dqURjNRGLLsRgZPSKFsXAlduSr3AKhWBr3/RzxMs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sun peng Li <Sunpeng.Li@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 021/171] drm/amd/display: Disable cursor when offscreen in negative direction
Date:   Thu, 18 Jul 2019 23:54:12 -0400
Message-Id: <20190719035643.14300-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

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

