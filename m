Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58EB3C4DC3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbhGLHOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239732AbhGLHNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:13:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5062B610D1;
        Mon, 12 Jul 2021 07:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073833;
        bh=kiDqqcUuVbI4FtfzcNZsh21VHyWzYeAUKV4DhKar0QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFDd75SMPUOA5Br0pJ8WbLGo3f8BOHXNuu35q8rWtdJ6F38t9LV2ABlYtOzA3weuv
         dy5xPCUSGADlusviFG0uFS9NFP4vQHbuvEsoNJItGyLIr4OT5p9aOdB2ZPMRk/S72+
         SxtADsc45hJMjBR6xqap96sCMYujyqRGEO+idD2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 375/700] drm: rockchip: set alpha_en to 0 if it is not used
Date:   Mon, 12 Jul 2021 08:07:38 +0200
Message-Id: <20210712061016.251238257@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 8d15cabdcb02..2d10198044c2 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1013,6 +1013,7 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 		VOP_WIN_SET(vop, win, alpha_en, 1);
 	} else {
 		VOP_WIN_SET(vop, win, src_alpha_ctl, SRC_ALPHA_EN(0));
+		VOP_WIN_SET(vop, win, alpha_en, 0);
 	}
 
 	VOP_WIN_SET(vop, win, enable, 1);
-- 
2.30.2



