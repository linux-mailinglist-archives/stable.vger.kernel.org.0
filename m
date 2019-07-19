Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1D06D9E5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfGSD6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbfGSD6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 188A12184E;
        Fri, 19 Jul 2019 03:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508691;
        bh=qM2zHBibiBBO03fWCDDQyTr6ziwHDkUz0cX/k5QHERA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPhgJ1SYmS/Hn5MmOhfD5/eSUN9IJr6ZZhQp1LrYUbKN72DbK6hHl16325pX8VLSe
         MJx3NiqECbyw1Wj5okGhYLC8xVPEDUcYPPiyuZ7TXzgGkx4iGXGNU+24a6Ef3nQLVC
         IGw+pR7MzatuD+HrS7Avms4Cxm2ziQxBM/Ncq1r8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 035/171] drm/amd/display: Reset planes for color management changes
Date:   Thu, 18 Jul 2019 23:54:26 -0400
Message-Id: <20190719035643.14300-35-sashal@kernel.org>
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

[ Upstream commit 7316c4ad299663a16ca9ce13e5e817b4ca760809 ]

[Why]
For commits with allow_modeset=false and CRTC degamma changes the planes
aren't reset. This results in incorrect rendering.

[How]
Reset the planes when color management has changed on the CRTC.
Technically this will include regamma changes as well, but it doesn't
really after legacy userspace since those commit with
allow_modeset=true.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Harry Wentland <Harry.Wentland@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 31530bfd002a..0e482349a5cb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6331,6 +6331,10 @@ static bool should_reset_plane(struct drm_atomic_state *state,
 	if (!new_crtc_state)
 		return true;
 
+	/* CRTC Degamma changes currently require us to recreate planes. */
+	if (new_crtc_state->color_mgmt_changed)
+		return true;
+
 	if (drm_atomic_crtc_needs_modeset(new_crtc_state))
 		return true;
 
-- 
2.20.1

