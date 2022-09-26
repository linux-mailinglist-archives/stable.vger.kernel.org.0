Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238235EA3C3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiIZLcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiIZLbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:31:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7813CDC;
        Mon, 26 Sep 2022 03:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF785B802C5;
        Mon, 26 Sep 2022 10:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4DFC433C1;
        Mon, 26 Sep 2022 10:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188319;
        bh=EBOO3tdZUjavLHBkkjyibiK3Jxo7Cy1iyAXq+Pu2VzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjqPLBcyl0JWX7c0ApAaLcRY03k8UVtJDYV/mOccnUh4peqzE0VyRUVkEBm4uxu9R
         xQhEIz9RPUZ4Oqqq16cAcFBAlGb5dgwGjWJqdKcAQNkije5Po3KcqODR7ixDjYApzo
         vzm+ufZWQIGoy+c/ksB392n6VB+yHHjQZfRfFlvQ=
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
Subject: [PATCH 5.10 111/141] drm/mediatek: dsi: Move mtk_dsi_stop() call back to mtk_dsi_poweroff()
Date:   Mon, 26 Sep 2022 12:12:17 +0200
Message-Id: <20220926100758.464972362@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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
index b8c1a3c1c517..146c4d04f572 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -668,6 +668,16 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
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
@@ -718,17 +728,6 @@ static void mtk_output_dsi_disable(struct mtk_dsi *dsi)
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



