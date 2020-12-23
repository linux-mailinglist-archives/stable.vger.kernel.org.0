Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097EC2E171A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgLWDFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbgLWCTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76E8322AAF;
        Wed, 23 Dec 2020 02:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689901;
        bh=k+KP1tuGcuhlVuyY6CcMcv0749L9TvC6cHzejnZqKPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wh5Ri9XgweVubyXZJ5HqCVqWk2n7L8zMSfHEqBf+fGUyqXAxAlDaBc0Oe8JEH25xG
         SfGveqxPlrqos2LyC9lW5xo/FVS16cPyHV5QiDExhyQrq/IITXEG5Oy54XcrnbEEVE
         XaSRT4juz1br3UE0+q0MtRJfE4LmvMLfnX449BXEJfE3kmw4jbs2mn7p7qiongg4Fz
         U00WpRml9aMzz0P2BU5jTWX46fzpPtYWBWHQw00yp7jNHLWe2WAhuZkyhVqFDwfG+J
         5duht/47wARel9elprbGT0RnlrnsIC581cd/IkvGQCi1U5dTPGECLYZThNeO/UZWzo
         GYJpBmqc7eqdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 006/130] drm/amd/display: Do not silently accept DCC for multiplane formats.
Date:   Tue, 22 Dec 2020 21:16:09 -0500
Message-Id: <20201223021813.2791612-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index d2dd387c95d86..ce70c42a2c3ec 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2734,7 +2734,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
 		return 0;
 
 	if (format >= SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)
-		return 0;
+		return -EINVAL;
 
 	if (!dc->cap_funcs.get_dcc_compression_cap)
 		return -EINVAL;
-- 
2.27.0

