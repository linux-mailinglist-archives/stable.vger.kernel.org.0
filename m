Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DFD4F377F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353059AbiDELNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349072AbiDEJtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFAFA94FC;
        Tue,  5 Apr 2022 02:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C2F161663;
        Tue,  5 Apr 2022 09:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B90C385A1;
        Tue,  5 Apr 2022 09:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151595;
        bh=boKlnM2yflvc03R8I1ckjS0zp0DlxT6z7I1Cu1oiFnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeVWtEQw6YVPQ3FD8jYlxkgaMLuomUa6TuboGAWMhtm43DZY9WomShl8SNRrJjQNg
         hy/aRwV4Rz9kIBaCd5UHJs3lv+JT/qPoLac5Ut40DECmJ9nCfrs+ykiXst0olsGG2h
         zaiUODscy1pEfXGmklOlWED1fexTVTX58it6rQuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 472/913] drm/msm/dsi: Use "ref" fw clock instead of global name for VCO parent
Date:   Tue,  5 Apr 2022 09:25:34 +0200
Message-Id: <20220405070354.003413638@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 3a3ee71bd8e14c5e852c71f317eebfda8f88dff0 ]

All DSI PHY/PLL drivers were referencing their VCO parent clock by a
global name, most of which don't exist or have been renamed.  These
clock drivers seem to function fine without that except the 14nm driver
for sdm6xx [1].

At the same time all DTs provide a "ref" clock as per the requirements
of dsi-phy-common.yaml, but the clock is never used.  This patchset puts
that clock to use without relying on a global clock name, so that all
dependencies are explicitly defined in DT (the firmware) in the end.

Note that this patch intentionally breaks older firmware (DT) that
relies on the clock to be found globally instead.  The only affected
platform is msm8974 [2] for whose dsi_phy_28nm a .name="xo" fallback is
left in place to accommodate a more graceful transition period.  All
other platforms had the "ref" clock added to their phy node since its
inception, or in a followup patch some time after.  These patches
wrongly assumed that the "ref" clock was actively used and have hence
been listed as "Fixes:" below.
Furthermore apq8064 was providing the wrong 19.2MHz cxo instead of
27MHz pxo clock, which has been addressed in [3].

It is expected that both [2] and [3] are applied to the tree well in
advance of this patch such that any actual breakage is extremely
unlikely, but might still occur if kernel upgrades are performed without
the DT to match.  After some time the fallback for msm8974 can be
removed again as well.

[1]: https://lore.kernel.org/linux-arm-msm/386db1a6-a1cd-3c7d-a88e-dc83f8a1be96@somainline.org/
[2]: https://lore.kernel.org/linux-arm-msm/20210830175739.143401-1-marijn.suijten@somainline.org/
[3]: https://lore.kernel.org/linux-arm-msm/20210829203027.276143-2-marijn.suijten@somainline.org/

Fixes: 79e51645a1dd ("arm64: dts: qcom: msm8916: Set 'xo_board' as ref clock of the DSI PHY")
Fixes: 6969d1d9c615 ("ARM: dts: qcom-apq8064: Set 'cxo_board' as ref clock of the DSI PHY")
Fixes: 0c0e72705a33 ("arm64: dts: sdm845: Set 'bi_tcxo' as ref clock of the DSI PHYs")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210911131922.387964-2-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c      | 4 +++-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c      | 4 +++-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm.c      | 4 +++-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm_8960.c | 4 +++-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c       | 4 +++-
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
index d8128f50b0dd..0b782cc18b3f 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
@@ -562,7 +562,9 @@ static int pll_10nm_register(struct dsi_pll_10nm *pll_10nm, struct clk_hw **prov
 	char clk_name[32], parent[32], vco_name[32];
 	char parent2[32], parent3[32], parent4[32];
 	struct clk_init_data vco_init = {
-		.parent_names = (const char *[]){ "xo" },
+		.parent_data = &(const struct clk_parent_data) {
+			.fw_name = "ref",
+		},
 		.num_parents = 1,
 		.name = vco_name,
 		.flags = CLK_IGNORE_UNUSED,
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index 5b4e991f220d..1c1e9861b93f 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -804,7 +804,9 @@ static int pll_14nm_register(struct dsi_pll_14nm *pll_14nm, struct clk_hw **prov
 {
 	char clk_name[32], parent[32], vco_name[32];
 	struct clk_init_data vco_init = {
-		.parent_names = (const char *[]){ "xo" },
+		.parent_data = &(const struct clk_parent_data) {
+			.fw_name = "ref",
+		},
 		.num_parents = 1,
 		.name = vco_name,
 		.flags = CLK_IGNORE_UNUSED,
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm.c
index 2da673a2add6..48eab80b548e 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm.c
@@ -521,7 +521,9 @@ static int pll_28nm_register(struct dsi_pll_28nm *pll_28nm, struct clk_hw **prov
 {
 	char clk_name[32], parent1[32], parent2[32], vco_name[32];
 	struct clk_init_data vco_init = {
-		.parent_names = (const char *[]){ "xo" },
+		.parent_data = &(const struct clk_parent_data) {
+			.fw_name = "ref", .name = "xo",
+		},
 		.num_parents = 1,
 		.name = vco_name,
 		.flags = CLK_IGNORE_UNUSED,
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm_8960.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm_8960.c
index 71ed4aa0dc67..fc56cdcc9ad6 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm_8960.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm_8960.c
@@ -385,7 +385,9 @@ static int pll_28nm_register(struct dsi_pll_28nm *pll_28nm, struct clk_hw **prov
 {
 	char *clk_name, *parent_name, *vco_name;
 	struct clk_init_data vco_init = {
-		.parent_names = (const char *[]){ "pxo" },
+		.parent_data = &(const struct clk_parent_data) {
+			.fw_name = "ref",
+		},
 		.num_parents = 1,
 		.flags = CLK_IGNORE_UNUSED,
 		.ops = &clk_ops_dsi_pll_28nm_vco,
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index cb297b08458e..9f7c408325ba 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -590,7 +590,9 @@ static int pll_7nm_register(struct dsi_pll_7nm *pll_7nm, struct clk_hw **provide
 	char clk_name[32], parent[32], vco_name[32];
 	char parent2[32], parent3[32], parent4[32];
 	struct clk_init_data vco_init = {
-		.parent_names = (const char *[]){ "bi_tcxo" },
+		.parent_data = &(const struct clk_parent_data) {
+			.fw_name = "ref",
+		},
 		.num_parents = 1,
 		.name = vco_name,
 		.flags = CLK_IGNORE_UNUSED,
-- 
2.34.1



