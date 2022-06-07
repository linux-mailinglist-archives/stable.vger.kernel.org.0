Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E10D5412E2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357120AbiFGTyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358566AbiFGTwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5590185CA3;
        Tue,  7 Jun 2022 11:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B02D1CE2439;
        Tue,  7 Jun 2022 18:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DC8C385A2;
        Tue,  7 Jun 2022 18:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626063;
        bh=aXwQzVtydkB9yWcYLkNJhXrkBnNnBNlwgcpy29iTRhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVpO+7nllAOK1j1yQmPL/wgH6t5wx7dujZzu7s9NzkdUEJTgoyvtCANNAftZh/UPR
         0vQz5hvCbNQWvGTOH+Pllt9136Fqc8OuAZbVT2SCofkOcwBEYWM+IClKDw6mtzUwt/
         ZRYDhfkD971UexABDpnSr1goFRP9lSyma1kW7qyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rex-BC Chen <rex-bc.chen@mediatek.com>,
        "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 243/772] drm/mediatek: Add vblank register/unregister callback functions
Date:   Tue,  7 Jun 2022 18:57:15 +0200
Message-Id: <20220607164956.188160947@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rex-BC Chen <rex-bc.chen@mediatek.com>

[ Upstream commit b74d921b900b6ce38c6247c0a1c86be9f3746493 ]

We encountered a kernel panic issue that callback data will be NULL when
it's using in ovl irq handler. There is a timing issue between
mtk_disp_ovl_irq_handler() and mtk_ovl_disable_vblank().

To resolve this issue, we use the flow to register/unregister vblank cb:
- Register callback function and callback data when crtc creates.
- Unregister callback function and callback data when crtc destroies.

With this solution, we can assure callback data will not be NULL when
vblank is disable.

Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20220321072320.15019-1-rex-bc.chen@mediatek.com/
Fixes: 9b0704988b15 ("drm/mediatek: Register vblank callback function")
Signed-off-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Reviewed-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_drv.h     | 16 +++++++-----
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c     | 22 ++++++++++++----
 drivers/gpu/drm/mediatek/mtk_disp_rdma.c    | 20 +++++++++-----
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c     | 14 +++++++++-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c |  4 +++
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h | 29 ++++++++++++++++-----
 6 files changed, 80 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_drv.h b/drivers/gpu/drm/mediatek/mtk_disp_drv.h
index 86c3068894b1..974462831133 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_drv.h
+++ b/drivers/gpu/drm/mediatek/mtk_disp_drv.h
@@ -76,9 +76,11 @@ void mtk_ovl_layer_off(struct device *dev, unsigned int idx,
 void mtk_ovl_start(struct device *dev);
 void mtk_ovl_stop(struct device *dev);
 unsigned int mtk_ovl_supported_rotations(struct device *dev);
-void mtk_ovl_enable_vblank(struct device *dev,
-			   void (*vblank_cb)(void *),
-			   void *vblank_cb_data);
+void mtk_ovl_register_vblank_cb(struct device *dev,
+				void (*vblank_cb)(void *),
+				void *vblank_cb_data);
+void mtk_ovl_unregister_vblank_cb(struct device *dev);
+void mtk_ovl_enable_vblank(struct device *dev);
 void mtk_ovl_disable_vblank(struct device *dev);
 
 void mtk_rdma_bypass_shadow(struct device *dev);
@@ -93,9 +95,11 @@ void mtk_rdma_layer_config(struct device *dev, unsigned int idx,
 			   struct cmdq_pkt *cmdq_pkt);
 void mtk_rdma_start(struct device *dev);
 void mtk_rdma_stop(struct device *dev);
-void mtk_rdma_enable_vblank(struct device *dev,
-			    void (*vblank_cb)(void *),
-			    void *vblank_cb_data);
+void mtk_rdma_register_vblank_cb(struct device *dev,
+				 void (*vblank_cb)(void *),
+				 void *vblank_cb_data);
+void mtk_rdma_unregister_vblank_cb(struct device *dev);
+void mtk_rdma_enable_vblank(struct device *dev);
 void mtk_rdma_disable_vblank(struct device *dev);
 
 #endif
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 2146299e5f52..1fa1bbac9f9c 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -96,14 +96,28 @@ static irqreturn_t mtk_disp_ovl_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-void mtk_ovl_enable_vblank(struct device *dev,
-			   void (*vblank_cb)(void *),
-			   void *vblank_cb_data)
+void mtk_ovl_register_vblank_cb(struct device *dev,
+				void (*vblank_cb)(void *),
+				void *vblank_cb_data)
 {
 	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
 
 	ovl->vblank_cb = vblank_cb;
 	ovl->vblank_cb_data = vblank_cb_data;
+}
+
+void mtk_ovl_unregister_vblank_cb(struct device *dev)
+{
+	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
+
+	ovl->vblank_cb = NULL;
+	ovl->vblank_cb_data = NULL;
+}
+
+void mtk_ovl_enable_vblank(struct device *dev)
+{
+	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
+
 	writel(0x0, ovl->regs + DISP_REG_OVL_INTSTA);
 	writel_relaxed(OVL_FME_CPL_INT, ovl->regs + DISP_REG_OVL_INTEN);
 }
@@ -112,8 +126,6 @@ void mtk_ovl_disable_vblank(struct device *dev)
 {
 	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
 
-	ovl->vblank_cb = NULL;
-	ovl->vblank_cb_data = NULL;
 	writel_relaxed(0x0, ovl->regs + DISP_REG_OVL_INTEN);
 }
 
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_rdma.c b/drivers/gpu/drm/mediatek/mtk_disp_rdma.c
index d41a3970b944..943780fc7bf6 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_rdma.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_rdma.c
@@ -94,24 +94,32 @@ static void rdma_update_bits(struct device *dev, unsigned int reg,
 	writel(tmp, rdma->regs + reg);
 }
 
-void mtk_rdma_enable_vblank(struct device *dev,
-			    void (*vblank_cb)(void *),
-			    void *vblank_cb_data)
+void mtk_rdma_register_vblank_cb(struct device *dev,
+				 void (*vblank_cb)(void *),
+				 void *vblank_cb_data)
 {
 	struct mtk_disp_rdma *rdma = dev_get_drvdata(dev);
 
 	rdma->vblank_cb = vblank_cb;
 	rdma->vblank_cb_data = vblank_cb_data;
-	rdma_update_bits(dev, DISP_REG_RDMA_INT_ENABLE, RDMA_FRAME_END_INT,
-			 RDMA_FRAME_END_INT);
 }
 
-void mtk_rdma_disable_vblank(struct device *dev)
+void mtk_rdma_unregister_vblank_cb(struct device *dev)
 {
 	struct mtk_disp_rdma *rdma = dev_get_drvdata(dev);
 
 	rdma->vblank_cb = NULL;
 	rdma->vblank_cb_data = NULL;
+}
+
+void mtk_rdma_enable_vblank(struct device *dev)
+{
+	rdma_update_bits(dev, DISP_REG_RDMA_INT_ENABLE, RDMA_FRAME_END_INT,
+			 RDMA_FRAME_END_INT);
+}
+
+void mtk_rdma_disable_vblank(struct device *dev)
+{
 	rdma_update_bits(dev, DISP_REG_RDMA_INT_ENABLE, RDMA_FRAME_END_INT, 0);
 }
 
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index d661edf7e0fe..e42a9bfa0ecb 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -152,6 +152,7 @@ static void mtk_drm_cmdq_pkt_destroy(struct cmdq_pkt *pkt)
 static void mtk_drm_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
+	int i;
 
 	mtk_mutex_put(mtk_crtc->mutex);
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
@@ -162,6 +163,14 @@ static void mtk_drm_crtc_destroy(struct drm_crtc *crtc)
 		mtk_crtc->cmdq_client.chan = NULL;
 	}
 #endif
+
+	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
+		struct mtk_ddp_comp *comp;
+
+		comp = mtk_crtc->ddp_comp[i];
+		mtk_ddp_comp_unregister_vblank_cb(comp);
+	}
+
 	drm_crtc_cleanup(crtc);
 }
 
@@ -616,7 +625,7 @@ static int mtk_drm_crtc_enable_vblank(struct drm_crtc *crtc)
 	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
 	struct mtk_ddp_comp *comp = mtk_crtc->ddp_comp[0];
 
-	mtk_ddp_comp_enable_vblank(comp, mtk_crtc_ddp_irq, &mtk_crtc->base);
+	mtk_ddp_comp_enable_vblank(comp);
 
 	return 0;
 }
@@ -916,6 +925,9 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 			if (comp->funcs->ctm_set)
 				has_ctm = true;
 		}
+
+		mtk_ddp_comp_register_vblank_cb(comp, mtk_crtc_ddp_irq,
+						&mtk_crtc->base);
 	}
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++)
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index b4b682bc1991..028cf76b9531 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -297,6 +297,8 @@ static const struct mtk_ddp_comp_funcs ddp_ovl = {
 	.config = mtk_ovl_config,
 	.start = mtk_ovl_start,
 	.stop = mtk_ovl_stop,
+	.register_vblank_cb = mtk_ovl_register_vblank_cb,
+	.unregister_vblank_cb = mtk_ovl_unregister_vblank_cb,
 	.enable_vblank = mtk_ovl_enable_vblank,
 	.disable_vblank = mtk_ovl_disable_vblank,
 	.supported_rotations = mtk_ovl_supported_rotations,
@@ -321,6 +323,8 @@ static const struct mtk_ddp_comp_funcs ddp_rdma = {
 	.config = mtk_rdma_config,
 	.start = mtk_rdma_start,
 	.stop = mtk_rdma_stop,
+	.register_vblank_cb = mtk_rdma_register_vblank_cb,
+	.unregister_vblank_cb = mtk_rdma_unregister_vblank_cb,
 	.enable_vblank = mtk_rdma_enable_vblank,
 	.disable_vblank = mtk_rdma_disable_vblank,
 	.layer_nr = mtk_rdma_layer_nr,
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
index 4c6a98662305..b83f24cb045f 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
@@ -48,9 +48,11 @@ struct mtk_ddp_comp_funcs {
 		       unsigned int bpc, struct cmdq_pkt *cmdq_pkt);
 	void (*start)(struct device *dev);
 	void (*stop)(struct device *dev);
-	void (*enable_vblank)(struct device *dev,
-			      void (*vblank_cb)(void *),
-			      void *vblank_cb_data);
+	void (*register_vblank_cb)(struct device *dev,
+				   void (*vblank_cb)(void *),
+				   void *vblank_cb_data);
+	void (*unregister_vblank_cb)(struct device *dev);
+	void (*enable_vblank)(struct device *dev);
 	void (*disable_vblank)(struct device *dev);
 	unsigned int (*supported_rotations)(struct device *dev);
 	unsigned int (*layer_nr)(struct device *dev);
@@ -111,12 +113,25 @@ static inline void mtk_ddp_comp_stop(struct mtk_ddp_comp *comp)
 		comp->funcs->stop(comp->dev);
 }
 
-static inline void mtk_ddp_comp_enable_vblank(struct mtk_ddp_comp *comp,
-					      void (*vblank_cb)(void *),
-					      void *vblank_cb_data)
+static inline void mtk_ddp_comp_register_vblank_cb(struct mtk_ddp_comp *comp,
+						   void (*vblank_cb)(void *),
+						   void *vblank_cb_data)
+{
+	if (comp->funcs && comp->funcs->register_vblank_cb)
+		comp->funcs->register_vblank_cb(comp->dev, vblank_cb,
+						vblank_cb_data);
+}
+
+static inline void mtk_ddp_comp_unregister_vblank_cb(struct mtk_ddp_comp *comp)
+{
+	if (comp->funcs && comp->funcs->unregister_vblank_cb)
+		comp->funcs->unregister_vblank_cb(comp->dev);
+}
+
+static inline void mtk_ddp_comp_enable_vblank(struct mtk_ddp_comp *comp)
 {
 	if (comp->funcs && comp->funcs->enable_vblank)
-		comp->funcs->enable_vblank(comp->dev, vblank_cb, vblank_cb_data);
+		comp->funcs->enable_vblank(comp->dev);
 }
 
 static inline void mtk_ddp_comp_disable_vblank(struct mtk_ddp_comp *comp)
-- 
2.35.1



