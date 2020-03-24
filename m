Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016861910AB
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgCXNWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbgCXNWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:22:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16708208C3;
        Tue, 24 Mar 2020 13:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056160;
        bh=GcH41PGTf8WsMwYREVE6JKMp5hkyVBF7ZVhJsXLeEo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmZvkA1Mr1ZyPpRHpTSVSm4h6JB3N6OmdHX7/E+tOXjPQnehlYlpUiuTbzOQUeD/S
         YMoeS9e4qV5y8orMbauI1hoscMT5ybBM3NMIt6UWQEo5Oqx9J4hJOfVXKokdhOHlx7
         at1tDvXF9Cd1sOQlMVTAH5VvXv4UyhbX6yJF65eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Paul <seanpaul@chromium.org>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 005/119] drm/mediatek: Ensure the cursor plane is on top of other overlays
Date:   Tue, 24 Mar 2020 14:09:50 +0100
Message-Id: <20200324130808.529129456@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

[ Upstream commit 26d696192aa5f4fe9119d6d23f90ed535053abca ]

Currently the cursor is placed on the first overlay plane, which means
it will be at the bottom of the stack when the hw does the compositing
with anything other than primary plane. Since mtk doesn't support plane
zpos, change the cursor location to the top-most plane.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 7104504babde0..1d46fbe9e07c6 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -606,11 +606,12 @@ static int mtk_drm_crtc_num_comp_planes(struct mtk_drm_crtc *mtk_crtc,
 }
 
 static inline
-enum drm_plane_type mtk_drm_crtc_plane_type(unsigned int plane_idx)
+enum drm_plane_type mtk_drm_crtc_plane_type(unsigned int plane_idx,
+					    unsigned int num_planes)
 {
 	if (plane_idx == 0)
 		return DRM_PLANE_TYPE_PRIMARY;
-	else if (plane_idx == 1)
+	else if (plane_idx == (num_planes - 1))
 		return DRM_PLANE_TYPE_CURSOR;
 	else
 		return DRM_PLANE_TYPE_OVERLAY;
@@ -629,7 +630,8 @@ static int mtk_drm_crtc_init_comp_planes(struct drm_device *drm_dev,
 		ret = mtk_plane_init(drm_dev,
 				&mtk_crtc->planes[mtk_crtc->layer_nr],
 				BIT(pipe),
-				mtk_drm_crtc_plane_type(mtk_crtc->layer_nr),
+				mtk_drm_crtc_plane_type(mtk_crtc->layer_nr,
+							num_planes),
 				mtk_ddp_comp_supported_rotations(comp));
 		if (ret)
 			return ret;
-- 
2.20.1



