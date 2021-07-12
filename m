Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC3C3C537C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352471AbhGLHyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350443AbhGLHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271C4619C4;
        Mon, 12 Jul 2021 07:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075920;
        bh=nbskVuz7TMGpYfcP8knuOHbtPWW+zS/sVAug0/2Wg5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXTiUMqYKPx5yOYsVkiWIOPGep146vNJqlKjR2iyUHJFvI/y5jK9V5aFShl0LiW7D
         QsuOXoszMowhY4v7sqodicbTsry2Wy+saS8X9XzpvDis1r9NdvFbzHzlk/XomuXVOW
         vYxMVI94OTmt4Lt+QbGGSOc8dfbYonCnXgJoXb1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 419/800] drm: rockchip: set alpha_en to 0 if it is not used
Date:   Mon, 12 Jul 2021 08:07:22 +0200
Message-Id: <20210712061011.791034175@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 046e0db975695540c9d9898cdbf0b60533d28afb ]

alpha_en should be set to 0 if it is not used, i.e. to disable alpha
blending if it was enabled before and should be disabled now.

Fixes: 2aae8ed1f390 ("drm/rockchip: Add per-pixel alpha support for the PX30 VOP")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210528130554.72191-6-knaerzche@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 64469439ddf2..f5b9028a16a3 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1022,6 +1022,7 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 		VOP_WIN_SET(vop, win, alpha_en, 1);
 	} else {
 		VOP_WIN_SET(vop, win, src_alpha_ctl, SRC_ALPHA_EN(0));
+		VOP_WIN_SET(vop, win, alpha_en, 0);
 	}
 
 	VOP_WIN_SET(vop, win, enable, 1);
-- 
2.30.2



