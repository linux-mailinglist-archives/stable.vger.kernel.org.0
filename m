Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977015245CF
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 08:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350360AbiELGac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 02:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350369AbiELGab (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 02:30:31 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9AE2265E5;
        Wed, 11 May 2022 23:30:29 -0700 (PDT)
X-UUID: bb50aaf9df4f419e81653bb2f5c9839b-20220512
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:14435cb8-9d12-401c-af31-07654cd9a6d2,OB:10,L
        OB:0,IP:0,URL:0,TC:0,Content:-20,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham
        ,ACTION:release,TS:80
X-CID-INFO: VERSION:1.1.4,REQID:14435cb8-9d12-401c-af31-07654cd9a6d2,OB:10,LOB
        :0,IP:0,URL:0,TC:0,Content:-20,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D
        ,ACTION:quarantine,TS:80
X-CID-META: VersionHash:faefae9,CLOUDID:6f39eff1-ab23-4aed-a67b-f96514452486,C
        OID:7cf80d172d12,Recheck:0,SF:28|16|19|48,TC:nil,Content:0,EDM:-3,File:nil
        ,QS:0,BEC:nil
X-UUID: bb50aaf9df4f419e81653bb2f5c9839b-20220512
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <xinlei.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1162432509; Thu, 12 May 2022 14:30:24 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 12 May 2022 14:30:22 +0800
Received: from mszsdaap41.gcn.mediatek.inc (10.16.6.141) by
 mtkcas11.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 12 May 2022 14:30:21 +0800
From:   <xinlei.lee@mediatek.com>
To:     <chunkuang.hu@kernel.org>, <p.zabel@pengutronix.de>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <matthias.bgg@gmail.com>
CC:     <dri-devel@lists.freedesktop.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        <rex-bc.chen@mediatek.com>, <jitao.shi@mediatek.com>,
        "# 6 . 6 . x : b255d51e3967 : sched : Modify dsi funcs to atomic
        operations" <stable@vger.kernel.org>,
        Xinlei Lee <xinlei.lee@mediatek.com>
Subject: [PATCH v6,3/4] drm/mediatek: keep dsi as LP00 before dcs cmds transfer
Date:   Thu, 12 May 2022 14:30:11 +0800
Message-ID: <1652337012-9053-4-git-send-email-xinlei.lee@mediatek.com>
X-Mailer: git-send-email 2.6.4
In-Reply-To: <1652337012-9053-1-git-send-email-xinlei.lee@mediatek.com>
References: <1652337012-9053-1-git-send-email-xinlei.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jitao Shi <jitao.shi@mediatek.com>

To comply with the panel sequence, hold the mipi signal to LP00 before the dcs cmds transmission,
and pull the mipi signal high from LP00 to LP11 until the start of the dcs cmds transmission.
The normal panel timing is :
(1) pp1800 DC pull up
(2) avdd & avee AC pull high
(3) lcm_reset pull high -> pull low -> pull high
(4) Pull MIPI signal high (LP11) -> initial code -> send video data(HS mode)
The power-off sequence is reversed.
If dsi is not in cmd mode, then dsi will pull the mipi signal high in the mtk_output_dsi_enable function.
The delay in lane_ready func is the reaction time of dsi_rx after pulling up the mipi signal.

Fixes: 2dd8075d2185 ("drm/mediatek: mtk_dsi: Use the drm_panel_bridge API")

Cc: <stable@vger.kernel.org> # 6.6.x: b255d51e3967: sched: Modify dsi funcs to atomic operations
Cc: <stable@vger.kernel.org> # 6.6.x: 72c69c977502: sched: Separate poweron/poweroff from enable/disable and define new funcs
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index d9a6b928dba8..25e84d9426bf 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -203,6 +203,7 @@ struct mtk_dsi {
 	struct mtk_phy_timing phy_timing;
 	int refcount;
 	bool enabled;
+	bool lanes_ready;
 	u32 irq_data;
 	wait_queue_head_t irq_wait_queue;
 	const struct mtk_dsi_driver_data *driver_data;
@@ -661,18 +662,11 @@ static int mtk_dsi_poweron(struct mtk_dsi *dsi)
 	mtk_dsi_reset_engine(dsi);
 	mtk_dsi_phy_timconfig(dsi);
 
-	mtk_dsi_rxtx_control(dsi);
-	usleep_range(30, 100);
-	mtk_dsi_reset_dphy(dsi);
 	mtk_dsi_ps_control_vact(dsi);
 	mtk_dsi_set_vm_cmd(dsi);
 	mtk_dsi_config_vdo_timing(dsi);
 	mtk_dsi_set_interrupt_enable(dsi);
 
-	mtk_dsi_clk_ulp_mode_leave(dsi);
-	mtk_dsi_lane0_ulp_mode_leave(dsi);
-	mtk_dsi_clk_hs_mode(dsi, 0);
-
 	return 0;
 err_disable_engine_clk:
 	clk_disable_unprepare(dsi->engine_clk);
@@ -701,6 +695,23 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 	clk_disable_unprepare(dsi->digital_clk);
 
 	phy_power_off(dsi->phy);
+
+	dsi->lanes_ready = false;
+}
+
+static void mtk_dsi_lane_ready(struct mtk_dsi *dsi)
+{
+	if (!dsi->lanes_ready) {
+		dsi->lanes_ready = true;
+		mtk_dsi_rxtx_control(dsi);
+		usleep_range(30, 100);
+		mtk_dsi_reset_dphy(dsi);
+		mtk_dsi_clk_ulp_mode_leave(dsi);
+		mtk_dsi_lane0_ulp_mode_leave(dsi);
+		mtk_dsi_clk_hs_mode(dsi, 0);
+		msleep(20);
+		/* The reaction time after pulling up the mipi signal for dsi_rx */
+	}
 }
 
 static void mtk_output_dsi_enable(struct mtk_dsi *dsi)
@@ -708,6 +719,7 @@ static void mtk_output_dsi_enable(struct mtk_dsi *dsi)
 	if (dsi->enabled)
 		return;
 
+	mtk_dsi_lane_ready(dsi);
 	mtk_dsi_set_mode(dsi);
 	mtk_dsi_clk_hs_mode(dsi, 1);
 
@@ -1017,6 +1029,8 @@ static ssize_t mtk_dsi_host_transfer(struct mipi_dsi_host *host,
 	if (MTK_DSI_HOST_IS_READ(msg->type))
 		irq_flag |= LPRX_RD_RDY_INT_FLAG;
 
+	mtk_dsi_lane_ready(dsi);
+
 	ret = mtk_dsi_host_send_cmd(dsi, msg, irq_flag);
 	if (ret)
 		goto restore_dsi_mode;
-- 
2.18.0

