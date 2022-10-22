Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80E76089FC
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiJVIpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiJVIoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:44:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779E22EBB86;
        Sat, 22 Oct 2022 01:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6272B82E1F;
        Sat, 22 Oct 2022 07:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470B5C433C1;
        Sat, 22 Oct 2022 07:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425353;
        bh=xwQFS+0dceWteJ5a9d7UTXfY02GKVvj6lofGoSNaXtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKR031iJircWeDfJtBqkKzKFU5aiA9WrppMJ4vLsnCq8J7wmpJja4lF2JHNDSFjum
         uDIEtDfsBrokUBzF6+jyoqWU4n/V7Ps46K9yDidz9OuD2q10OcOMnGX/C3VIWk8Ugk
         gIpVDRukFhVzU1EmIgmLw0m4Dm8taxeRI2HJtHOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 474/717] clk: mediatek: clk-mt8195-mfg: Reparent mfg_bg3d and propagate rate changes
Date:   Sat, 22 Oct 2022 09:25:53 +0200
Message-Id: <20221022072519.313487111@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



