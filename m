Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7471603E9A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiJSJQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiJSJOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:14:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291481CFC0;
        Wed, 19 Oct 2022 02:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C801A61802;
        Wed, 19 Oct 2022 09:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCB5C433D6;
        Wed, 19 Oct 2022 09:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170246;
        bh=xwQFS+0dceWteJ5a9d7UTXfY02GKVvj6lofGoSNaXtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzBUzrQcJs8Rk3fLPisGvDwW2+2JKP4FVQUkDM+qjxopMVlsWyMztmCSJt3Yi9KdA
         3PxGzbKd7KTI7MFkosvUUz0AanrD2foVlr3NfyQ7Ut1qBiPWJOT9y8EOee9rYxOT4R
         pJoMyKLBH8HLEpzWyxOVsIxS5CvF/UqT3m25u8Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 582/862] clk: mediatek: clk-mt8195-mfg: Reparent mfg_bg3d and propagate rate changes
Date:   Wed, 19 Oct 2022 10:31:09 +0200
Message-Id: <20221019083315.682505160@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit a5f7bf5458c2cf6730106e16a6373638a0e5ed1e ]

The MFG_BG3D is a gate to enable/disable clock output to the GPU,
but the actual output is decided by multiple muxes; in particular:
mfg_ck_fast_ref muxes between "slow" (top_mfg_core_tmp) and
"fast" (MFGPLL) clock, while top_mfg_core_tmp muxes between the
26MHz clock and various system PLLs.

The clock gate comes after all the muxes, so its parent is
mfg_ck_fast_reg, not top_mfg_core_tmp.
Reparent MFG_BG3D to the latter to match the hardware and add the
CLK_SET_RATE_PARENT flag to it: this way we ensure propagating
rate changes that are requested on MFG_BG3D along its entire clock
tree.

Fixes: 35016f10c0e5 ("clk: mediatek: Add MT8195 mfgcfg clock support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20220927101128.44758-6-angelogioacchino.delregno@collabora.com
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8195-mfg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt8195-mfg.c b/drivers/clk/mediatek/clk-mt8195-mfg.c
index 9411c556a5a9..c94cb71bd9b9 100644
--- a/drivers/clk/mediatek/clk-mt8195-mfg.c
+++ b/drivers/clk/mediatek/clk-mt8195-mfg.c
@@ -17,10 +17,12 @@ static const struct mtk_gate_regs mfg_cg_regs = {
 };
 
 #define GATE_MFG(_id, _name, _parent, _shift)			\
-	GATE_MTK(_id, _name, _parent, &mfg_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
+	GATE_MTK_FLAGS(_id, _name, _parent, &mfg_cg_regs,	\
+		       _shift, &mtk_clk_gate_ops_setclr,	\
+		       CLK_SET_RATE_PARENT)
 
 static const struct mtk_gate mfg_clks[] = {
-	GATE_MFG(CLK_MFG_BG3D, "mfg_bg3d", "top_mfg_core_tmp", 0),
+	GATE_MFG(CLK_MFG_BG3D, "mfg_bg3d", "mfg_ck_fast_ref", 0),
 };
 
 static const struct mtk_clk_desc mfg_desc = {
-- 
2.35.1



