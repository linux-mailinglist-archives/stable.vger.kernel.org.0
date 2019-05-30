Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DD82F48E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbfE3Eje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbfE3DMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:38 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B7C23E29;
        Thu, 30 May 2019 03:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185957;
        bh=PYS5Datf5pZZIG36tQdTDk0Mop6H0RA4WAcw/qUerck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYSFVCwfXlzpGlEVtOaurLignNk9B51tcsR2EK3g5QqLBUwrRQVosRb7vcfH9m7Bp
         DQc1BTJSUTsyR7yb5yGrVViEtiLNnAqv1G1mIiGT1CGeCEci9rN4NXMLp9gFnTKj/c
         Jd0bTlA4BQGk7dlujsHpElMpARk13G3g9FnDYkBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 374/405] drm/omap: dsi: Fix PM for display blank with paired dss_pll calls
Date:   Wed, 29 May 2019 20:06:12 -0700
Message-Id: <20190530030559.655544763@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 64fb788b66474..f0fe975ed46c7 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -1342,12 +1342,9 @@ static int dsi_pll_enable(struct dss_pll *pll)
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
@@ -1372,36 +1369,25 @@ static int dsi_pll_enable(struct dss_pll *pll)
 
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
 
 static int dsi_dump_dsi_clocks(struct seq_file *s, void *p)
@@ -4096,11 +4082,11 @@ static int dsi_display_init_dsi(struct dsi_data *dsi)
 
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
@@ -4108,6 +4094,14 @@ static int dsi_display_init_dsi(struct dsi_data *dsi)
 
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
@@ -4136,10 +4130,13 @@ static int dsi_display_init_dsi(struct dsi_data *dsi)
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
 
@@ -4158,7 +4155,12 @@ static void dsi_display_uninit_dsi(struct dsi_data *dsi, bool disconnect_lanes,
 
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



