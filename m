Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13732EC1A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbfE3DSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbfE3DSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FBA247AD;
        Thu, 30 May 2019 03:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186300;
        bh=vadiD9nOAC2sEEEAsCaxI1oHCY6Dqzonpd/E1Ic6hHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pmd9SeoHDiBQjJ3sGo1mpvpD5R/xOqwgRqWfXYuRLoETAm0I4EWrW9pExIzxnJd2E
         Q1aluEmLEcUvsc3lq+V98PCiiiqvRYsU/w0tZ4U3w7lfKgSCPRep+vbb0+y4siw9UV
         TrdoCMAcjHb56ZHqSxi7TuNi7grBe5i6cjR4lWW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 265/276] drm/omap: dsi: Fix PM for display blank with paired dss_pll calls
Date:   Wed, 29 May 2019 20:07:03 -0700
Message-Id: <20190530030541.777974877@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fe4ed1b457943113ee1138c939fbdeede4af6cf3 ]

Currently dsi_display_init_dsi() calls dss_pll_enable() but it is not
paired with dss_pll_disable() in dsi_display_uninit_dsi(). This leaves
the DSS clocks enabled when the display is blanked wasting about extra
5mW of power while idle.

The clock that is left on by not calling dss_pll_disable() is
DSS_CLKCTRL bit 10 OPTFCLKEN_SYS_CLK that is the source clock for
DSI PLL.

We can fix this issue by by making the current dsi_pll_uninit() into
dsi_pll_disable(). This way we can just call dss_pll_disable() from
dsi_display_uninit_dsi() and the code becomes a bit easier to follow.

However, we need to also consider that DSI PLL can be muxed for DVI too
as pointed out by Tomi Valkeinen <tomi.valkeinen@ti.com>. In the DVI
case, we want to unconditionally disable the clocks. To get around this
issue, we separate out the DSI lane handling from dsi_pll_enable() and
dsi_pll_disable() as suggested by Tomi in an earlier experimental patch.

So we must only toggle the DSI regulator based on the vdds_dsi_enabled
flag from dsi_display_init_dsi() and dsi_display_uninit_dsi().

We need to make these two changes together to avoid breaking things
for DVI when fixing the DSI clock handling. And this all causes a
slight renumbering of the error path for dsi_display_init_dsi().

Suggested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dsi.c | 60 ++++++++++++++++---------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index 74467b3087218..8160954ebc257 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -1386,12 +1386,9 @@ static int dsi_pll_enable(struct dss_pll *pll)
 	 */
 	dsi_enable_scp_clk(dsi);
 
-	if (!dsi->vdds_dsi_enabled) {
-		r = regulator_enable(dsi->vdds_dsi_reg);
-		if (r)
-			goto err0;
-		dsi->vdds_dsi_enabled = true;
-	}
+	r = regulator_enable(dsi->vdds_dsi_reg);
+	if (r)
+		goto err0;
 
 	/* XXX PLL does not come out of reset without this... */
 	dispc_pck_free_enable(dsi->dss->dispc, 1);
@@ -1416,36 +1413,25 @@ static int dsi_pll_enable(struct dss_pll *pll)
 
 	return 0;
 err1:
-	if (dsi->vdds_dsi_enabled) {
-		regulator_disable(dsi->vdds_dsi_reg);
-		dsi->vdds_dsi_enabled = false;
-	}
+	regulator_disable(dsi->vdds_dsi_reg);
 err0:
 	dsi_disable_scp_clk(dsi);
 	dsi_runtime_put(dsi);
 	return r;
 }
 
-static void dsi_pll_uninit(struct dsi_data *dsi, bool disconnect_lanes)
+static void dsi_pll_disable(struct dss_pll *pll)
 {
+	struct dsi_data *dsi = container_of(pll, struct dsi_data, pll);
+
 	dsi_pll_power(dsi, DSI_PLL_POWER_OFF);
-	if (disconnect_lanes) {
-		WARN_ON(!dsi->vdds_dsi_enabled);
-		regulator_disable(dsi->vdds_dsi_reg);
-		dsi->vdds_dsi_enabled = false;
-	}
+
+	regulator_disable(dsi->vdds_dsi_reg);
 
 	dsi_disable_scp_clk(dsi);
 	dsi_runtime_put(dsi);
 
-	DSSDBG("PLL uninit done\n");
-}
-
-static void dsi_pll_disable(struct dss_pll *pll)
-{
-	struct dsi_data *dsi = container_of(pll, struct dsi_data, pll);
-
-	dsi_pll_uninit(dsi, true);
+	DSSDBG("PLL disable done\n");
 }
 
 static void dsi_dump_dsi_clocks(struct dsi_data *dsi, struct seq_file *s)
@@ -4195,11 +4181,11 @@ static int dsi_display_init_dsi(struct dsi_data *dsi)
 
 	r = dss_pll_enable(&dsi->pll);
 	if (r)
-		goto err0;
+		return r;
 
 	r = dsi_configure_dsi_clocks(dsi);
 	if (r)
-		goto err1;
+		goto err0;
 
 	dss_select_dsi_clk_source(dsi->dss, dsi->module_id,
 				  dsi->module_id == 0 ?
@@ -4207,6 +4193,14 @@ static int dsi_display_init_dsi(struct dsi_data *dsi)
 
 	DSSDBG("PLL OK\n");
 
+	if (!dsi->vdds_dsi_enabled) {
+		r = regulator_enable(dsi->vdds_dsi_reg);
+		if (r)
+			goto err1;
+
+		dsi->vdds_dsi_enabled = true;
+	}
+
 	r = dsi_cio_init(dsi);
 	if (r)
 		goto err2;
@@ -4235,10 +4229,13 @@ static int dsi_display_init_dsi(struct dsi_data *dsi)
 err3:
 	dsi_cio_uninit(dsi);
 err2:
-	dss_select_dsi_clk_source(dsi->dss, dsi->module_id, DSS_CLK_SRC_FCK);
+	regulator_disable(dsi->vdds_dsi_reg);
+	dsi->vdds_dsi_enabled = false;
 err1:
-	dss_pll_disable(&dsi->pll);
+	dss_select_dsi_clk_source(dsi->dss, dsi->module_id, DSS_CLK_SRC_FCK);
 err0:
+	dss_pll_disable(&dsi->pll);
+
 	return r;
 }
 
@@ -4257,7 +4254,12 @@ static void dsi_display_uninit_dsi(struct dsi_data *dsi, bool disconnect_lanes,
 
 	dss_select_dsi_clk_source(dsi->dss, dsi->module_id, DSS_CLK_SRC_FCK);
 	dsi_cio_uninit(dsi);
-	dsi_pll_uninit(dsi, disconnect_lanes);
+	dss_pll_disable(&dsi->pll);
+
+	if (disconnect_lanes) {
+		regulator_disable(dsi->vdds_dsi_reg);
+		dsi->vdds_dsi_enabled = false;
+	}
 }
 
 static int dsi_display_enable(struct omap_dss_device *dssdev)
-- 
2.20.1



