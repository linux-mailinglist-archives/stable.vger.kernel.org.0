Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337B63C4A60
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbhGLGwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238191AbhGLGsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1598C6113C;
        Mon, 12 Jul 2021 06:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072257;
        bh=ZivRLk3vTNtAwKZL3S42TJm2A9EcTEfHPTEK+8QwizA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imu2y0UUM+eqZ3bk05pT+r1egDnCT4Nc0AjbAF6XRSksZ+lEuvLR68XC0zqShl8pe
         +jJh4G+p/QsMiEkp9hysntUnTjkovSAhc5+Ww5k6GY07TXkPx931z4l43k3wFcX034
         +SAurrYp1fspDjmLIejbxZTeG1tk0/lQKt/2PoVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 420/593] clk: actions: Fix AHPPREDIV-H-AHB clock chain on Owl S500 SoC
Date:   Mon, 12 Jul 2021 08:09:40 +0200
Message-Id: <20210712060934.400309651@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

[ Upstream commit fd90b5b9045274360b12cea0f2ce50f3bcfb25cc ]

There are a few issues with the setup of the Actions Semi Owl S500 SoC's
clock chain involving AHPPREDIV, H and AHB clocks:

* AHBPREDIV clock is defined as a muxer only, although it also acts as
  a divider.
* H clock is using a wrong divider register offset
* AHB is defined as a multi-rate factor clock, but it is actually just
  a fixed pass clock.

Let's provide the following fixes:

* Change AHBPREDIV clock to an ungated OWL_COMP_DIV definition.
* Use the correct register shift value in the OWL_DIVIDER definition
  for H clock
* Drop the unneeded 'ahb_factor_table[]' and change AHB clock to an
  ungated OWL_COMP_FIXED_FACTOR definition.

Fixes: ed6b4795ece4 ("clk: actions: Add clock driver for S500 SoC")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Link: https://lore.kernel.org/r/21c1abd19a7089b65a34852ac6513961be88cbe1.1623354574.git.cristian.ciocaltea@gmail.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-s500.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/actions/owl-s500.c b/drivers/clk/actions/owl-s500.c
index 42d6899755e6..cbeb51c804eb 100644
--- a/drivers/clk/actions/owl-s500.c
+++ b/drivers/clk/actions/owl-s500.c
@@ -153,11 +153,6 @@ static struct clk_factor_table hde_factor_table[] = {
 	{ 0, 0, 0 },
 };
 
-static struct clk_factor_table ahb_factor_table[] = {
-	{ 1, 1, 2 }, { 2, 1, 3 },
-	{ 0, 0, 0 },
-};
-
 static struct clk_div_table rmii_ref_div_table[] = {
 	{ 0, 4 }, { 1, 10 },
 	{ 0, 0 },
@@ -186,7 +181,6 @@ static struct clk_div_table nand_div_table[] = {
 
 /* mux clock */
 static OWL_MUX(dev_clk, "dev_clk", dev_clk_mux_p, CMU_DEVPLL, 12, 1, CLK_SET_RATE_PARENT);
-static OWL_MUX(ahbprediv_clk, "ahbprediv_clk", ahbprediv_clk_mux_p, CMU_BUSCLK1, 8, 3, CLK_SET_RATE_PARENT);
 
 /* gate clocks */
 static OWL_GATE(gpio_clk, "gpio_clk", "apb_clk", CMU_DEVCLKEN0, 18, 0, 0);
@@ -199,16 +193,25 @@ static OWL_GATE(timer_clk, "timer_clk", "hosc", CMU_DEVCLKEN1, 27, 0, 0);
 static OWL_GATE(hdmi_clk, "hdmi_clk", "hosc", CMU_DEVCLKEN1, 3, 0, 0);
 
 /* divider clocks */
-static OWL_DIVIDER(h_clk, "h_clk", "ahbprediv_clk", CMU_BUSCLK1, 12, 2, NULL, 0, 0);
+static OWL_DIVIDER(h_clk, "h_clk", "ahbprediv_clk", CMU_BUSCLK1, 2, 2, NULL, 0, 0);
 static OWL_DIVIDER(apb_clk, "apb_clk", "ahb_clk", CMU_BUSCLK1, 14, 2, NULL, 0, 0);
 static OWL_DIVIDER(rmii_ref_clk, "rmii_ref_clk", "ethernet_pll_clk", CMU_ETHERNETPLL, 1, 1, rmii_ref_div_table, 0, 0);
 
 /* factor clocks */
-static OWL_FACTOR(ahb_clk, "ahb_clk", "h_clk", CMU_BUSCLK1, 2, 2, ahb_factor_table, 0, 0);
 static OWL_FACTOR(de1_clk, "de_clk1", "de_clk", CMU_DECLK, 0, 4, de_factor_table, 0, 0);
 static OWL_FACTOR(de2_clk, "de_clk2", "de_clk", CMU_DECLK, 4, 4, de_factor_table, 0, 0);
 
 /* composite clocks */
+static OWL_COMP_DIV(ahbprediv_clk, "ahbprediv_clk", ahbprediv_clk_mux_p,
+			OWL_MUX_HW(CMU_BUSCLK1, 8, 3),
+			{ 0 },
+			OWL_DIVIDER_HW(CMU_BUSCLK1, 12, 2, 0, NULL),
+			CLK_SET_RATE_PARENT);
+
+static OWL_COMP_FIXED_FACTOR(ahb_clk, "ahb_clk", "h_clk",
+			{ 0 },
+			1, 1, 0);
+
 static OWL_COMP_FACTOR(vce_clk, "vce_clk", hde_clk_mux_p,
 			OWL_MUX_HW(CMU_VCECLK, 4, 2),
 			OWL_GATE_HW(CMU_DEVCLKEN0, 26, 0),
-- 
2.30.2



