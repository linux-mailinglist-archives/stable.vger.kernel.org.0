Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8687C2C9BD1
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389961AbgLAJM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389951AbgLAJMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91587206C1;
        Tue,  1 Dec 2020 09:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813902;
        bh=2Lda2s5qRujP4rJ0QhXfwzqsZAzpkjdyz4RzNF1pkXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFGk41a1GUH4/B/WTcspvV52H+k7sRbwskYifp3VewXP4+S0NBboW2soUwkDCg/NB
         8F5nXJXlqEy2ThXH6S83Zr3RDxMiaL5hf4Y6WOTa/C1+tkUbWz5SaDvYAcYhNoZLq1
         v7ksNmfFu4ZMzj1j+g8qGfRR3TtVpgJGl+ZqfIwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, CK Hu <ck.hu@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Bilal Wasim <bilal.wasim@imgtec.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 098/152] drm/mediatek: dsi: Modify horizontal front/back porch byte formula
Date:   Tue,  1 Dec 2020 09:53:33 +0100
Message-Id: <20201201084724.700660997@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: CK Hu <ck.hu@mediatek.com>

[ Upstream commit 487778f8d22fcdebb6436f0a5f96484ffa237b0b ]

In the patch to be fixed, horizontal_backporch_byte become too large
for some panel, so roll back that patch. For small hfp or hbp panel,
using vm->hfront_porch + vm->hback_porch to calculate
horizontal_backporch_byte would make it negtive, so
use horizontal_backporch_byte itself to make it positive.

Fixes: 35bf948f1edb ("drm/mediatek: dsi: Fix scrolling of panel with small hfp or hbp")

Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Tested-by: Bilal Wasim <bilal.wasim@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 61 +++++++++++-------------------
 1 file changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 80b7a082e8740..d6e0a29ea6b28 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -444,7 +444,10 @@ static void mtk_dsi_config_vdo_timing(struct mtk_dsi *dsi)
 	u32 horizontal_sync_active_byte;
 	u32 horizontal_backporch_byte;
 	u32 horizontal_frontporch_byte;
+	u32 horizontal_front_back_byte;
+	u32 data_phy_cycles_byte;
 	u32 dsi_tmp_buf_bpp, data_phy_cycles;
+	u32 delta;
 	struct mtk_phy_timing *timing = &dsi->phy_timing;
 
 	struct videomode *vm = &dsi->vm;
@@ -466,50 +469,30 @@ static void mtk_dsi_config_vdo_timing(struct mtk_dsi *dsi)
 	horizontal_sync_active_byte = (vm->hsync_len * dsi_tmp_buf_bpp - 10);
 
 	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
-		horizontal_backporch_byte = vm->hback_porch * dsi_tmp_buf_bpp;
+		horizontal_backporch_byte = vm->hback_porch * dsi_tmp_buf_bpp - 10;
 	else
 		horizontal_backporch_byte = (vm->hback_porch + vm->hsync_len) *
-					    dsi_tmp_buf_bpp;
+					    dsi_tmp_buf_bpp - 10;
 
 	data_phy_cycles = timing->lpx + timing->da_hs_prepare +
-			  timing->da_hs_zero + timing->da_hs_exit;
-
-	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_BURST) {
-		if ((vm->hfront_porch + vm->hback_porch) * dsi_tmp_buf_bpp >
-		    data_phy_cycles * dsi->lanes + 18) {
-			horizontal_frontporch_byte =
-				vm->hfront_porch * dsi_tmp_buf_bpp -
-				(data_phy_cycles * dsi->lanes + 18) *
-				vm->hfront_porch /
-				(vm->hfront_porch + vm->hback_porch);
-
-			horizontal_backporch_byte =
-				horizontal_backporch_byte -
-				(data_phy_cycles * dsi->lanes + 18) *
-				vm->hback_porch /
-				(vm->hfront_porch + vm->hback_porch);
-		} else {
-			DRM_WARN("HFP less than d-phy, FPS will under 60Hz\n");
-			horizontal_frontporch_byte = vm->hfront_porch *
-						     dsi_tmp_buf_bpp;
-		}
+			  timing->da_hs_zero + timing->da_hs_exit + 3;
+
+	delta = dsi->mode_flags & MIPI_DSI_MODE_VIDEO_BURST ? 18 : 12;
+
+	horizontal_frontporch_byte = vm->hfront_porch * dsi_tmp_buf_bpp;
+	horizontal_front_back_byte = horizontal_frontporch_byte + horizontal_backporch_byte;
+	data_phy_cycles_byte = data_phy_cycles * dsi->lanes + delta;
+
+	if (horizontal_front_back_byte > data_phy_cycles_byte) {
+		horizontal_frontporch_byte -= data_phy_cycles_byte *
+					      horizontal_frontporch_byte /
+					      horizontal_front_back_byte;
+
+		horizontal_backporch_byte -= data_phy_cycles_byte *
+					     horizontal_backporch_byte /
+					     horizontal_front_back_byte;
 	} else {
-		if ((vm->hfront_porch + vm->hback_porch) * dsi_tmp_buf_bpp >
-		    data_phy_cycles * dsi->lanes + 12) {
-			horizontal_frontporch_byte =
-				vm->hfront_porch * dsi_tmp_buf_bpp -
-				(data_phy_cycles * dsi->lanes + 12) *
-				vm->hfront_porch /
-				(vm->hfront_porch + vm->hback_porch);
-			horizontal_backporch_byte = horizontal_backporch_byte -
-				(data_phy_cycles * dsi->lanes + 12) *
-				vm->hback_porch /
-				(vm->hfront_porch + vm->hback_porch);
-		} else {
-			DRM_WARN("HFP less than d-phy, FPS will under 60Hz\n");
-			horizontal_frontporch_byte = vm->hfront_porch *
-						     dsi_tmp_buf_bpp;
-		}
+		DRM_WARN("HFP + HBP less than d-phy, FPS will under 60Hz\n");
 	}
 
 	writel(horizontal_sync_active_byte, dsi->regs + DSI_HSA_WC);
-- 
2.27.0



