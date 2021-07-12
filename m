Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267803C46BC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhGLG2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:28:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234872AbhGLG1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E4FA61166;
        Mon, 12 Jul 2021 06:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071037;
        bh=Kn4QgSWg5gEDLFP8lEnjGtArVXg/DN/pMWdTyqlT4Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esXRAIG2JXWHnA56oPHaMvDFrLPzbtWJmkN5BpF22kiSSYZ3GZXkH6dF5DUnyzNyZ
         XKTgURTlGIpAD9/tfqEOkwdcL5r4fE+YRsdIA6IlucRAwkGAgqhP1uREyQC/cN6PKg
         FeoK7YDcT6MBH+XFTd45TVeQdMVuTZvPmbJ68qrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/348] clk: actions: Fix bisp_factor_table based clocks on Owl S500 SoC
Date:   Mon, 12 Jul 2021 08:10:30 +0200
Message-Id: <20210712060735.285018107@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

[ Upstream commit a8f1f03caa51aa7a69c671aa87c475034db7d368 ]

The following clocks of the Actions Semi Owl S500 SoC have been defined
to use a shared clock factor table 'bisp_factor_table[]': DE[1-2], VCE,
VDE, BISP, SENSOR[0-1]

There are several issues involved in this approach:

* 'bisp_factor_table[]' describes the configuration of a regular 8-rates
  divider, so its usage is redundant. Additionally, judging by the BISP
  clock context, it is incomplete since it maps only 8 out of 12
  possible entries.

* The clocks mentioned above are not identical in terms of the available
  rates, therefore cannot rely on the same factor table. Specifically,
  BISP and SENSOR* are standard 12-rate dividers so their configuration
  should rely on a proper clock div table, while VCE and VDE require a
  factor table that is a actually a subset of the one needed for DE[1-2]
  clocks.

Let's fix this by implementing the following:

* Add new factor tables 'de_factor_table' and 'hde_factor_table' to
  properly handle DE[1-2], VCE and VDE clocks.

* Add a common div table 'std12rate_div_table' for BISP and SENSOR[0-1]
  clocks converted to OWL_COMP_DIV.

* Drop the now unused 'bisp_factor_table[]'.

Additionally, drop the CLK_IGNORE_UNUSED flag for SENSOR[0-1] since
there is no reason to always keep ON those clocks.

Fixes: ed6b4795ece4 ("clk: actions: Add clock driver for S500 SoC")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/e675820a46cd9930d8d576c6cae61d41c1a8416f.1623354574.git.cristian.ciocaltea@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-s500.c | 44 ++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/actions/owl-s500.c b/drivers/clk/actions/owl-s500.c
index d2396b2396ff..0528536ed9eb 100644
--- a/drivers/clk/actions/owl-s500.c
+++ b/drivers/clk/actions/owl-s500.c
@@ -138,9 +138,16 @@ static struct clk_factor_table sd_factor_table[] = {
 	{ 0, 0, 0 },
 };
 
-static struct clk_factor_table bisp_factor_table[] = {
-	{ 0, 1, 1 }, { 1, 1, 2 }, { 2, 1, 3 }, { 3, 1, 4 },
-	{ 4, 1, 5 }, { 5, 1, 6 }, { 6, 1, 7 }, { 7, 1, 8 },
+static struct clk_factor_table de_factor_table[] = {
+	{ 0, 1, 1 }, { 1, 2, 3 }, { 2, 1, 2 }, { 3, 2, 5 },
+	{ 4, 1, 3 }, { 5, 1, 4 }, { 6, 1, 6 }, { 7, 1, 8 },
+	{ 8, 1, 12 },
+	{ 0, 0, 0 },
+};
+
+static struct clk_factor_table hde_factor_table[] = {
+	{ 0, 1, 1 }, { 1, 2, 3 }, { 2, 1, 2 }, { 3, 2, 5 },
+	{ 4, 1, 3 }, { 5, 1, 4 }, { 6, 1, 6 }, { 7, 1, 8 },
 	{ 0, 0, 0 },
 };
 
@@ -154,6 +161,13 @@ static struct clk_div_table rmii_ref_div_table[] = {
 	{ 0, 0 },
 };
 
+static struct clk_div_table std12rate_div_table[] = {
+	{ 0, 1 }, { 1, 2 }, { 2, 3 }, { 3, 4 },
+	{ 4, 5 }, { 5, 6 }, { 6, 7 }, { 7, 8 },
+	{ 8, 9 }, { 9, 10 }, { 10, 11 }, { 11, 12 },
+	{ 0, 0 },
+};
+
 static struct clk_div_table i2s_div_table[] = {
 	{ 0, 1 }, { 1, 2 }, { 2, 3 }, { 3, 4 },
 	{ 4, 6 }, { 5, 8 }, { 6, 12 }, { 7, 16 },
@@ -186,39 +200,39 @@ static OWL_DIVIDER(rmii_ref_clk, "rmii_ref_clk", "ethernet_pll_clk", CMU_ETHERNE
 
 /* factor clocks */
 static OWL_FACTOR(ahb_clk, "ahb_clk", "h_clk", CMU_BUSCLK1, 2, 2, ahb_factor_table, 0, 0);
-static OWL_FACTOR(de1_clk, "de_clk1", "de_clk", CMU_DECLK, 0, 3, bisp_factor_table, 0, 0);
-static OWL_FACTOR(de2_clk, "de_clk2", "de_clk", CMU_DECLK, 4, 3, bisp_factor_table, 0, 0);
+static OWL_FACTOR(de1_clk, "de_clk1", "de_clk", CMU_DECLK, 0, 4, de_factor_table, 0, 0);
+static OWL_FACTOR(de2_clk, "de_clk2", "de_clk", CMU_DECLK, 4, 4, de_factor_table, 0, 0);
 
 /* composite clocks */
 static OWL_COMP_FACTOR(vce_clk, "vce_clk", hde_clk_mux_p,
 			OWL_MUX_HW(CMU_VCECLK, 4, 2),
 			OWL_GATE_HW(CMU_DEVCLKEN0, 26, 0),
-			OWL_FACTOR_HW(CMU_VCECLK, 0, 3, 0, bisp_factor_table),
+			OWL_FACTOR_HW(CMU_VCECLK, 0, 3, 0, hde_factor_table),
 			0);
 
 static OWL_COMP_FACTOR(vde_clk, "vde_clk", hde_clk_mux_p,
 			OWL_MUX_HW(CMU_VDECLK, 4, 2),
 			OWL_GATE_HW(CMU_DEVCLKEN0, 25, 0),
-			OWL_FACTOR_HW(CMU_VDECLK, 0, 3, 0, bisp_factor_table),
+			OWL_FACTOR_HW(CMU_VDECLK, 0, 3, 0, hde_factor_table),
 			0);
 
-static OWL_COMP_FACTOR(bisp_clk, "bisp_clk", bisp_clk_mux_p,
+static OWL_COMP_DIV(bisp_clk, "bisp_clk", bisp_clk_mux_p,
 			OWL_MUX_HW(CMU_BISPCLK, 4, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN0, 14, 0),
-			OWL_FACTOR_HW(CMU_BISPCLK, 0, 3, 0, bisp_factor_table),
+			OWL_DIVIDER_HW(CMU_BISPCLK, 0, 4, 0, std12rate_div_table),
 			0);
 
-static OWL_COMP_FACTOR(sensor0_clk, "sensor0_clk", sensor_clk_mux_p,
+static OWL_COMP_DIV(sensor0_clk, "sensor0_clk", sensor_clk_mux_p,
 			OWL_MUX_HW(CMU_SENSORCLK, 4, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN0, 14, 0),
-			OWL_FACTOR_HW(CMU_SENSORCLK, 0, 3, 0, bisp_factor_table),
-			CLK_IGNORE_UNUSED);
+			OWL_DIVIDER_HW(CMU_SENSORCLK, 0, 4, 0, std12rate_div_table),
+			0);
 
-static OWL_COMP_FACTOR(sensor1_clk, "sensor1_clk", sensor_clk_mux_p,
+static OWL_COMP_DIV(sensor1_clk, "sensor1_clk", sensor_clk_mux_p,
 			OWL_MUX_HW(CMU_SENSORCLK, 4, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN0, 14, 0),
-			OWL_FACTOR_HW(CMU_SENSORCLK, 8, 3, 0, bisp_factor_table),
-			CLK_IGNORE_UNUSED);
+			OWL_DIVIDER_HW(CMU_SENSORCLK, 8, 4, 0, std12rate_div_table),
+			0);
 
 static OWL_COMP_FACTOR(sd0_clk, "sd0_clk", sd_clk_mux_p,
 			OWL_MUX_HW(CMU_SD0CLK, 9, 1),
-- 
2.30.2



