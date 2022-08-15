Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C932594D2E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiHPAwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343778AbiHPAun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:50:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3482FD91E7;
        Mon, 15 Aug 2022 13:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB84EB8114A;
        Mon, 15 Aug 2022 20:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F406EC433C1;
        Mon, 15 Aug 2022 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596363;
        bh=yMOCYybvniywrLN7PduGPHDVrkOrEyAQ3fLGk+guF3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2lBuZQk2euv4dL8uGJFYGJs7iPpwxVic4v4gM/8kbC3NGBLeWJ5MEUMPkJ5BbPnA
         dmAMgRXEPhr/qw9FIeL4eXCWhQQkUGkjqajxB89URdygqtrRwgUZKidQtH5SStWPOf
         6UaswFR7ksMzItcdLaj4HkMoiPbmkoo9rTfdbr5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jitao Shi <jitao.shi@mediatek.com>,
        Xinlei Lee <xinlei.lee@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1057/1157] drm/mediatek: Keep dsi as LP00 before dcs cmds transfer
Date:   Mon, 15 Aug 2022 20:06:53 +0200
Message-Id: <20220815180522.352594118@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jitao Shi <jitao.shi@mediatek.com>

[ Upstream commit 39e8d062b03c3dc257d880d82bd55cdd9e185a3b ]

To comply with the panel sequence, hold the mipi signal to LP00 before
the dcs cmds transmission, and pull the mipi signal high from LP00 to
LP11 until the start of the dcs cmds transmission.

The normal panel timing is :
(1) pp1800 DC pull up
(2) avdd & avee AC pull high
(3) lcm_reset pull high -> pull low -> pull high
(4) Pull MIPI signal high (LP11) -> initial code -> send video data
    (HS mode)

The power-off sequence is reversed.
If dsi is not in cmd mode, then dsi will pull the mipi signal high in
the mtk_output_dsi_enable function. The delay in lane_ready func is
the reaction time of dsi_rx after pulling up the mipi signal.

Fixes: 2dd8075d2185 ("drm/mediatek: mtk_dsi: Use the drm_panel_bridge API")

Link: https://patchwork.kernel.org/project/linux-mediatek/patch/1653012007-11854-4-git-send-email-xinlei.lee@mediatek.com/
Cc: <stable@vger.kernel.org> # 5.10.x: 7f6335c6a258: drm/mediatek: Modify dsi funcs to atomic operations
Cc: <stable@vger.kernel.org> # 5.10.x: cde7e2e35c28: drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

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
@@ -661,18 +662,11 @@ static int mtk_dsi_poweron(struct mtk_ds
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
@@ -703,6 +697,23 @@ static void mtk_dsi_poweroff(struct mtk_
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
@@ -710,6 +721,7 @@ static void mtk_output_dsi_enable(struct
 	if (dsi->enabled)
 		return;
 
+	mtk_dsi_lane_ready(dsi);
 	mtk_dsi_set_mode(dsi);
 	mtk_dsi_clk_hs_mode(dsi, 1);
 
@@ -1019,6 +1031,8 @@ static ssize_t mtk_dsi_host_transfer(str
 	if (MTK_DSI_HOST_IS_READ(msg->type))
 		irq_flag |= LPRX_RD_RDY_INT_FLAG;
 
+	mtk_dsi_lane_ready(dsi);
+
 	ret = mtk_dsi_host_send_cmd(dsi, msg, irq_flag);
 	if (ret)
 		goto restore_dsi_mode;


