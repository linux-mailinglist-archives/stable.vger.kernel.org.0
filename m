Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2DF56FD67
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbiGKJzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiGKJyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5B1AEF73;
        Mon, 11 Jul 2022 02:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D0E5B80E7E;
        Mon, 11 Jul 2022 09:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E226C34115;
        Mon, 11 Jul 2022 09:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531543;
        bh=0OYdaRbdLWNZ8z/6ur+Zqcb5Wq5UHeldQUWNjF/45oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgxpaJq9rYp2SDJr9BErdngy26ItLhQwe1AqayuhAefL5CnT3qNU4bpM7tSUEs0tE
         M6DY44lR9aFNaODwPHcoo8GQazMpKXmsGjWLhgsUOak+KvRFZBR9FHIwtdOVfR5YtU
         ea6hqlpPXcqBGhsJSXPNt/Nr/RPKWndDeOUdPIjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/230] drm/mediatek: Use mailbox rx_callback instead of cmdq_task_cb
Date:   Mon, 11 Jul 2022 11:06:40 +0200
Message-Id: <20220711090608.147755342@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chun-Kuang Hu <chunkuang.hu@kernel.org>

[ Upstream commit 1ee07a683b7e4e6ad9ad4f77fce4751741bc8ceb ]

rx_callback is a standard mailbox callback mechanism and could cover the
function of proprietary cmdq_task_cb, so use the standard one instead of
the proprietary one.

Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index a4e80e499674..369d3e68c0b6 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -4,6 +4,8 @@
  */
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/mailbox_controller.h>
 #include <linux/pm_runtime.h>
 #include <linux/soc/mediatek/mtk-cmdq.h>
 #include <linux/soc/mediatek/mtk-mmsys.h>
@@ -222,9 +224,11 @@ struct mtk_ddp_comp *mtk_drm_ddp_comp_for_plane(struct drm_crtc *crtc,
 }
 
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-static void ddp_cmdq_cb(struct cmdq_cb_data data)
+static void ddp_cmdq_cb(struct mbox_client *cl, void *mssg)
 {
-	cmdq_pkt_destroy(data.data);
+	struct cmdq_cb_data *data = mssg;
+
+	cmdq_pkt_destroy(data->pkt);
 }
 #endif
 
@@ -475,7 +479,12 @@ static void mtk_drm_crtc_update_config(struct mtk_drm_crtc *mtk_crtc,
 		cmdq_pkt_wfe(cmdq_handle, mtk_crtc->cmdq_event, false);
 		mtk_crtc_ddp_config(crtc, cmdq_handle);
 		cmdq_pkt_finalize(cmdq_handle);
-		cmdq_pkt_flush_async(cmdq_handle, ddp_cmdq_cb, cmdq_handle);
+		dma_sync_single_for_device(mtk_crtc->cmdq_client->chan->mbox->dev,
+					   cmdq_handle->pa_base,
+					   cmdq_handle->cmd_buf_size,
+					   DMA_TO_DEVICE);
+		mbox_send_message(mtk_crtc->cmdq_client->chan, cmdq_handle);
+		mbox_client_txdone(mtk_crtc->cmdq_client->chan, 0);
 	}
 #endif
 	mtk_crtc->config_updating = false;
@@ -839,6 +848,7 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 	}
 
 	if (mtk_crtc->cmdq_client) {
+		mtk_crtc->cmdq_client->client.rx_callback = ddp_cmdq_cb;
 		ret = of_property_read_u32_index(priv->mutex_node,
 						 "mediatek,gce-events",
 						 drm_crtc_index(&mtk_crtc->base),
-- 
2.35.1



