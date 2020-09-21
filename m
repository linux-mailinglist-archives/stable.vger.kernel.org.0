Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A219D272F6E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIUQ46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729617AbgIUQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF3D223A04;
        Mon, 21 Sep 2020 16:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706667;
        bh=uBF2/c2bhx9oi+u3CpjY461LL7HH2GrF/2D9W+2eY/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkDDtNlgI/VjjZfG3iFCUAbopfpOqogclat2U26LnrLV95VVd45cvrQuUXiX7eWKE
         WM4j26fmmm0q45hpcw9Kj+uxfW07b/0Y7h70JcJOKlE9p2pGuo3Ao/iL1yFZEBkMD1
         lvdCzuu794cjjwwAg+Ef+IRrd8uT9NJnMTKAxHnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jitao Shi <jitao.shi@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 045/118] drm/mediatek: dsi: Fix scrolling of panel with small hfp or hbp
Date:   Mon, 21 Sep 2020 18:27:37 +0200
Message-Id: <20200921162038.407019155@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jitao Shi <jitao.shi@mediatek.com>

[ Upstream commit 35bf948f1edbf507f6e57e0879fa6ea36d2d2930 ]

horizontal_backporch_byte should be hbp * bpp - hbp extra bytes.
So remove the wrong subtraction 10.

Fixes: 7a5bc4e22ecf ("drm/mediatek: change the dsi phytiming calculate method")
Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 02ac55c13a80b..ee011a0633841 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -470,14 +470,13 @@ static void mtk_dsi_config_vdo_timing(struct mtk_dsi *dsi)
 	horizontal_sync_active_byte = (vm->hsync_len * dsi_tmp_buf_bpp - 10);
 
 	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
-		horizontal_backporch_byte =
-			(vm->hback_porch * dsi_tmp_buf_bpp - 10);
+		horizontal_backporch_byte = vm->hback_porch * dsi_tmp_buf_bpp;
 	else
-		horizontal_backporch_byte = ((vm->hback_porch + vm->hsync_len) *
-			dsi_tmp_buf_bpp - 10);
+		horizontal_backporch_byte = (vm->hback_porch + vm->hsync_len) *
+					    dsi_tmp_buf_bpp;
 
 	data_phy_cycles = timing->lpx + timing->da_hs_prepare +
-			  timing->da_hs_zero + timing->da_hs_exit + 3;
+			  timing->da_hs_zero + timing->da_hs_exit;
 
 	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_BURST) {
 		if ((vm->hfront_porch + vm->hback_porch) * dsi_tmp_buf_bpp >
-- 
2.25.1



