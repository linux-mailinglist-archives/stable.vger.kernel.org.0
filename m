Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89D662445
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733297AbfGHPlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388907AbfGHP0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917DE2166E;
        Mon,  8 Jul 2019 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599609;
        bh=RFVm29ryirTG0QEkrh8ZtTBCZywLkITGid4jBQ3+04s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvLzFKDQJgxG2OE0wUQ/ceXg7pcVSaovfCaBsI19Fc24let90SaGeVeucqR7IzrBM
         yhIjKi9uJW5r+NY4qRbAyBZ4hfstRzRwHu4qTq/Gu7XotVH0D9GlB0L0+CtGUXRVz5
         KWknxCHXg9vxrvIbs2WQyS3yDld8mMpyaHp54UT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/90] drm/mediatek: call mtk_dsi_stop() after mtk_drm_crtc_atomic_disable()
Date:   Mon,  8 Jul 2019 17:12:44 +0200
Message-Id: <20190708150523.489858370@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2458d9d6d94be982b917e93c61a89b4426f32e31 ]

mtk_dsi_stop() should be called after mtk_drm_crtc_atomic_disable(), which
needs ovl irq for drm_crtc_wait_one_vblank(), since after mtk_dsi_stop() is
called, ovl irq will be disabled. If drm_crtc_wait_one_vblank() is called
after last irq, it will timeout with this message: "vblank wait timed out
on crtc 0". This happens sometimes when turning off the screen.

In drm_atomic_helper.c#disable_outputs(),
the calling sequence when turning off the screen is:

1. mtk_dsi_encoder_disable()
     --> mtk_output_dsi_disable()
       --> mtk_dsi_stop();  /* sometimes make vblank timeout in
                               atomic_disable */
       --> mtk_dsi_poweroff();
2. mtk_drm_crtc_atomic_disable()
     --> drm_crtc_wait_one_vblank();
     ...
       --> mtk_dsi_ddp_stop()
         --> mtk_dsi_poweroff();

mtk_dsi_poweroff() has reference count design, change to make
mtk_dsi_stop() called in mtk_dsi_poweroff() when refcount is 0.

Fixes: 0707632b5bac ("drm/mediatek: update DSI sub driver flow for sending commands to panel")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 84bb66866631..0dd317ac5fe5 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -630,6 +630,15 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 	if (--dsi->refcount != 0)
 		return;
 
+	/*
+	 * mtk_dsi_stop() and mtk_dsi_start() is asymmetric, since
+	 * mtk_dsi_stop() should be called after mtk_drm_crtc_atomic_disable(),
+	 * which needs irq for vblank, and mtk_dsi_stop() will disable irq.
+	 * mtk_dsi_start() needs to be called in mtk_output_dsi_enable(),
+	 * after dsi is fully set.
+	 */
+	mtk_dsi_stop(dsi);
+
 	if (!mtk_dsi_switch_to_cmd_mode(dsi, VM_DONE_INT_FLAG, 500)) {
 		if (dsi->panel) {
 			if (drm_panel_unprepare(dsi->panel)) {
@@ -696,7 +705,6 @@ static void mtk_output_dsi_disable(struct mtk_dsi *dsi)
 		}
 	}
 
-	mtk_dsi_stop(dsi);
 	mtk_dsi_poweroff(dsi);
 
 	dsi->enabled = false;
-- 
2.20.1



