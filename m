Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C76608AA7
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiJVJET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbiJVJDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D052FACD1;
        Sat, 22 Oct 2022 01:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 001A960B27;
        Sat, 22 Oct 2022 07:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA873C433D6;
        Sat, 22 Oct 2022 07:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425149;
        bh=V8S7SxBGkVwHx+dCHsBMJlF/8c04H0jASveOhijYiOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCUDfcxJSUQhf4D9cMTOoOGjRNPmPIqYLUxQJPRyfQlrpePI/fb8KUaZ+d63c5kRk
         aTcMuQZACZyOchXc1kmXXH+AD/3/bB/4r3FbM5Dz5uJVT6RW+0amPid2huOL2QUlUL
         vvi40sSzunW7aIJahqMrEnKJPj9c6Ldsj1sN0Oyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Bo-Chen Chen <rex-bc.chen@mediatek.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 407/717] clk: mediatek: clk-mt8195-vdo1: Reparent and set rate on vdo1_dpintfs parent
Date:   Sat, 22 Oct 2022 09:24:46 +0200
Message-Id: <20221022072516.020571043@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit f24d71feb206631116ff9adaa6d43650c5dd8849 ]

Like it was done for the vdo0_dp_intf0_dp_intf clock (used for eDP),
add the CLK_SET_RATE_PARENT flag to CLK_VDO1_DPINTF (used for DP)
and also fix its parent clock name as it has to be "top_dp" for two
reasons:
 - This is its real parent!
 - Likewise to eDP/VDO0 counterpart, we need clock source
   selection on CLK_TOP_DP.

Fixes: 269987505ba9 ("clk: mediatek: Add MT8195 vdosys1 clock support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Bo-Chen Chen <rex-bc.chen@mediatek.com>
Reviewed-by: Bo-Chen Chen <rex-bc.chen@mediatek.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20220816193257.658487-3-nfraprado@collabora.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8195-vdo1.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt8195-vdo1.c b/drivers/clk/mediatek/clk-mt8195-vdo1.c
index 3378487d2c90..d54d7726d186 100644
--- a/drivers/clk/mediatek/clk-mt8195-vdo1.c
+++ b/drivers/clk/mediatek/clk-mt8195-vdo1.c
@@ -43,6 +43,10 @@ static const struct mtk_gate_regs vdo1_3_cg_regs = {
 #define GATE_VDO1_2(_id, _name, _parent, _shift)			\
 	GATE_MTK(_id, _name, _parent, &vdo1_2_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
 
+#define GATE_VDO1_2_FLAGS(_id, _name, _parent, _shift, _flags)		\
+	GATE_MTK_FLAGS(_id, _name, _parent, &vdo1_2_cg_regs, _shift,	\
+		       &mtk_clk_gate_ops_setclr, _flags)
+
 #define GATE_VDO1_3(_id, _name, _parent, _shift)			\
 	GATE_MTK(_id, _name, _parent, &vdo1_3_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
 
@@ -99,7 +103,7 @@ static const struct mtk_gate vdo1_clks[] = {
 	GATE_VDO1_2(CLK_VDO1_DISP_MONITOR_DPI0, "vdo1_disp_monitor_dpi0", "top_vpp", 1),
 	GATE_VDO1_2(CLK_VDO1_DPI1, "vdo1_dpi1", "top_vpp", 8),
 	GATE_VDO1_2(CLK_VDO1_DISP_MONITOR_DPI1, "vdo1_disp_monitor_dpi1", "top_vpp", 9),
-	GATE_VDO1_2(CLK_VDO1_DPINTF, "vdo1_dpintf", "top_vpp", 16),
+	GATE_VDO1_2_FLAGS(CLK_VDO1_DPINTF, "vdo1_dpintf", "top_dp", 16, CLK_SET_RATE_PARENT),
 	GATE_VDO1_2(CLK_VDO1_DISP_MONITOR_DPINTF, "vdo1_disp_monitor_dpintf", "top_vpp", 17),
 	/* VDO1_3 */
 	GATE_VDO1_3(CLK_VDO1_26M_SLOW, "vdo1_26m_slow", "clk26m", 8),
-- 
2.35.1



