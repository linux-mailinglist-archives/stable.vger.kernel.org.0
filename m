Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0882E179C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgLWDLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:11:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbgLWCRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A481B22285;
        Wed, 23 Dec 2020 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689802;
        bh=zsc5DwIST51DCtdKAsQchb29xi3fmhWeABQJBteH70g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huEj0Y41fwvTBaIpsXXgh/wtRSG2TfzVx47uXgDhBrhSgpZ/aJ5nS2xP1lJFmuxsF
         EivbXhHLAktsKgsWE9Y+q+WvwA5UJy1XpnXPv10ETq5IC+uyaVB2Z+KFRCNi8Uh2Dx
         OETbatlB32eJu+LcCVNhw/o+zI1hvhmt6KFToEYcbvJmUHTaT4hH5APRzvVO4YU+ff
         ghr0JxOxyvYMSXYBth8U5XVanXpkJqKu7c6o2t8puZoyMdx8xzLXxkPlRMa0OazjWz
         zX0jPNteZEjzQw40qC4KgqQNYNbp2hvyK4KZz1qzEnRUr9tqLLqNjkUvYNUieXjkGm
         H7WsIRc/TXuMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 012/217] drm/amd/display: Do not silently accept DCC for multiplane formats.
Date:   Tue, 22 Dec 2020 21:13:01 -0500
Message-Id: <20201223021626.2790791-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit b35ce7b364ec80b54f48a8fdf9fb74667774d2da ]

Silently accepting it could result in corruption.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 96907707fdd94..553a241dedf5d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3825,7 +3825,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
 		return 0;
 
 	if (format >= SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)
-		return 0;
+		return -EINVAL;
 
 	if (!dc->cap_funcs.get_dcc_compression_cap)
 		return -EINVAL;
-- 
2.27.0

