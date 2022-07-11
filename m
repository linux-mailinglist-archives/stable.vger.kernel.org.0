Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563CA56FD5C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiGKJyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbiGKJyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:54:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C079BAF770;
        Mon, 11 Jul 2022 02:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8026BB80E6D;
        Mon, 11 Jul 2022 09:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00FFC34115;
        Mon, 11 Jul 2022 09:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531549;
        bh=AqEjWHgcoYJmR2Y2hTNYTlTBsAIkaFux81Wk/JVj7WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPokVt8jbM30eZNU3ugskrg/lFMRodmAoMMcevn+oQxd5ENIIbb6sc5jWv23vT1PY
         8W3n+uQcYG9SCfEsANp6imIKH3y+uoehpg5F0kgVMldVa+M628xnm+RHk8N0kWJO1/
         fe+xGjnpJQZGt1DhyM8/9xGXRobPHsi5UyQHw6FQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/230] drm/mediatek: Detect CMDQ execution timeout
Date:   Mon, 11 Jul 2022 11:06:42 +0200
Message-Id: <20220711090608.203578148@linuxfoundation.org>
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

[ Upstream commit eaf80126aba6fd1754837eec91e4c8bbd58ae52e ]

CMDQ is used to update display register in vblank period, so
it should be execute in next 2 vblank. One vblank interrupt
before send message (occasionally) and one vblank interrupt
after cmdq done. If it fail to execute in next 3 vblank,
tiemout happen.

Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index e23e3224ac67..dad1f85ee315 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -54,6 +54,7 @@ struct mtk_drm_crtc {
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
 	struct cmdq_client		cmdq_client;
 	u32				cmdq_event;
+	u32				cmdq_vblank_cnt;
 #endif
 
 	struct device			*mmsys_dev;
@@ -227,7 +228,10 @@ struct mtk_ddp_comp *mtk_drm_ddp_comp_for_plane(struct drm_crtc *crtc,
 static void ddp_cmdq_cb(struct mbox_client *cl, void *mssg)
 {
 	struct cmdq_cb_data *data = mssg;
+	struct cmdq_client *cmdq_cl = container_of(cl, struct cmdq_client, client);
+	struct mtk_drm_crtc *mtk_crtc = container_of(cmdq_cl, struct mtk_drm_crtc, cmdq_client);
 
+	mtk_crtc->cmdq_vblank_cnt = 0;
 	cmdq_pkt_destroy(data->pkt);
 }
 #endif
@@ -483,6 +487,15 @@ static void mtk_drm_crtc_update_config(struct mtk_drm_crtc *mtk_crtc,
 					   cmdq_handle->pa_base,
 					   cmdq_handle->cmd_buf_size,
 					   DMA_TO_DEVICE);
+		/*
+		 * CMDQ command should execute in next 3 vblank.
+		 * One vblank interrupt before send message (occasionally)
+		 * and one vblank interrupt after cmdq done,
+		 * so it's timeout after 3 vblank interrupt.
+		 * If it fail to execute in next 3 vblank, timeout happen.
+		 */
+		mtk_crtc->cmdq_vblank_cnt = 3;
+
 		mbox_send_message(mtk_crtc->cmdq_client.chan, cmdq_handle);
 		mbox_client_txdone(mtk_crtc->cmdq_client.chan, 0);
 	}
@@ -499,11 +512,14 @@ static void mtk_crtc_ddp_irq(void *data)
 
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
 	if (!priv->data->shadow_register && !mtk_crtc->cmdq_client.chan)
+		mtk_crtc_ddp_config(crtc, NULL);
+	else if (mtk_crtc->cmdq_vblank_cnt > 0 && --mtk_crtc->cmdq_vblank_cnt == 0)
+		DRM_ERROR("mtk_crtc %d CMDQ execute command timeout!\n",
+			  drm_crtc_index(&mtk_crtc->base));
 #else
 	if (!priv->data->shadow_register)
-#endif
 		mtk_crtc_ddp_config(crtc, NULL);
-
+#endif
 	mtk_drm_finish_page_flip(mtk_crtc);
 }
 
-- 
2.35.1



