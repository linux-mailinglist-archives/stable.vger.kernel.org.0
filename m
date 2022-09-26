Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05D05EA50C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238822AbiIZL43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbiIZLy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1547786CD;
        Mon, 26 Sep 2022 03:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 326FC60AD6;
        Mon, 26 Sep 2022 10:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A5AC433C1;
        Mon, 26 Sep 2022 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189326;
        bh=Nzip3Mw9RbGvjK9JI6FZQBgCbCA9OMQCLsOQWX+m7Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJtz0TBDWVZS+pyH79hpvMOFaW59PA7h9GlSsuVg51vhwhqeOIBdysW5JDhmJRyCJ
         BLUS0/qWtYsgiCPL1Qqx3dRFzcW+aR4MFQIBAhk+nF6zoMSyoowI35k3u5flQopHF8
         AiHCkP5Lp+ICo6uD/YimCFeAY2A0P/ScJI8VcsCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Hsin-Yi Wang <hsinyi@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 150/207] drm/mediatek: dsi: Move mtk_dsi_stop() call back to mtk_dsi_poweroff()
Date:   Mon, 26 Sep 2022 12:12:19 +0200
Message-Id: <20220926100813.361519555@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 90144dd8b0d137d9e78ef34b3c418e51a49299ad ]

As the comment right before the mtk_dsi_stop() call advises,
mtk_dsi_stop() should only be called after
mtk_drm_crtc_atomic_disable(). That's because that function calls
drm_crtc_wait_one_vblank(), which requires the vblank irq to be enabled.

Previously mtk_dsi_stop(), being in mtk_dsi_poweroff() and guarded by a
refcount, would only be called at the end of
mtk_drm_crtc_atomic_disable(), through the call to mtk_crtc_ddp_hw_fini().
Commit cde7e2e35c28 ("drm/mediatek: Separate poweron/poweroff from
enable/disable and define new funcs") moved the mtk_dsi_stop() call to
mtk_output_dsi_disable(), causing it to be called before
mtk_drm_crtc_atomic_disable(), and consequently generating vblank
timeout warnings during suspend.

Move the mtk_dsi_stop() call back to mtk_dsi_poweroff() so that we have
a working vblank irq during mtk_drm_crtc_atomic_disable() and stop
getting vblank timeout warnings.

Fixes: cde7e2e35c28 ("drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Link: http://lists.infradead.org/pipermail/linux-mediatek/2022-August/046713.html
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index e98b4aca2cb9..9a3b86c29b50 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -685,6 +685,16 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
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
+	mtk_dsi_switch_to_cmd_mode(dsi, VM_DONE_INT_FLAG, 500);
 	mtk_dsi_reset_engine(dsi);
 	mtk_dsi_lane0_ulp_mode_enter(dsi);
 	mtk_dsi_clk_ulp_mode_enter(dsi);
@@ -735,17 +745,6 @@ static void mtk_output_dsi_disable(struct mtk_dsi *dsi)
 	if (!dsi->enabled)
 		return;
 
-	/*
-	 * mtk_dsi_stop() and mtk_dsi_start() is asymmetric, since
-	 * mtk_dsi_stop() should be called after mtk_drm_crtc_atomic_disable(),
-	 * which needs irq for vblank, and mtk_dsi_stop() will disable irq.
-	 * mtk_dsi_start() needs to be called in mtk_output_dsi_enable(),
-	 * after dsi is fully set.
-	 */
-	mtk_dsi_stop(dsi);
-
-	mtk_dsi_switch_to_cmd_mode(dsi, VM_DONE_INT_FLAG, 500);
-
 	dsi->enabled = false;
 }
 
-- 
2.35.1



