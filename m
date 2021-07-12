Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927A83C5450
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348332AbhGLH5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352188AbhGLHyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EE461179;
        Mon, 12 Jul 2021 07:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076286;
        bh=OsOr/3IL8nqaBH1NnFBdEm4Lssc0sCdxEVJttXYIdI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRFIj0gnihcBAjnpra2UQ81KnDcDYsNSQ9yR/LBteA6cnfi4zJ6L8eC6kjUORQJKx
         0QPGIR4xsUzJNg1TZlMvPWY1S6BzR3lxxr85gnSHAHkrxiNOViB9KCQBP/yjTEGls2
         0IZ1zV28BiP0deN88PoDcYxExMBBoGSsyFw4m53k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.13 579/800] clk: zynqmp: fix compile testing without ZYNQMP_FIRMWARE
Date:   Mon, 12 Jul 2021 08:10:02 +0200
Message-Id: <20210712061028.943443855@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit 6c9feabc2c6bd49abbd2130341e7cb91f42d3fa5 ]

When the firmware code is disabled, the incomplete error handling
in the clk driver causes compile-time warnings:

drivers/clk/zynqmp/pll.c: In function 'zynqmp_pll_recalc_rate':
drivers/clk/zynqmp/pll.c:147:29: error: 'fbdiv' is used uninitialized [-Werror=uninitialized]
  147 |         rate =  parent_rate * fbdiv;
      |                 ~~~~~~~~~~~~^~~~~~~
In function 'zynqmp_pll_get_mode',
    inlined from 'zynqmp_pll_recalc_rate' at drivers/clk/zynqmp/pll.c:148:6:
drivers/clk/zynqmp/pll.c:61:27: error: 'ret_payload' is used uninitialized [-Werror=uninitialized]
   61 |         return ret_payload[1];
      |                ~~~~~~~~~~~^~~
drivers/clk/zynqmp/pll.c: In function 'zynqmp_pll_recalc_rate':
drivers/clk/zynqmp/pll.c:53:13: note: 'ret_payload' declared here
   53 |         u32 ret_payload[PAYLOAD_ARG_CNT];
      |             ^~~~~~~~~~~
drivers/clk/zynqmp/clk-mux-zynqmp.c: In function 'zynqmp_clk_mux_get_parent':
drivers/clk/zynqmp/clk-mux-zynqmp.c:57:16: error: 'val' is used uninitialized [-Werror=uninitialized]
   57 |         return val;
      |                ^~~

As it was apparently intentional to support this for compile testing
purposes, change the code to have just enough error handling for the
compiler to not notice the remaining bugs.

Fixes: 21f237534661 ("clk: zynqmp: Drop dependency on ARCH_ZYNQMP")
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/f1c4e8c903fe2d5df5413421920a56890a46387a.1624356908.git.michal.simek@xilinx.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/clk-mux-zynqmp.c | 10 ++++++++--
 drivers/clk/zynqmp/pll.c            | 22 ++++++++++++++++------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/zynqmp/clk-mux-zynqmp.c b/drivers/clk/zynqmp/clk-mux-zynqmp.c
index 06194149be83..d576c900dee0 100644
--- a/drivers/clk/zynqmp/clk-mux-zynqmp.c
+++ b/drivers/clk/zynqmp/clk-mux-zynqmp.c
@@ -38,7 +38,7 @@ struct zynqmp_clk_mux {
  * zynqmp_clk_mux_get_parent() - Get parent of clock
  * @hw:		handle between common and hardware-specific interfaces
  *
- * Return: Parent index
+ * Return: Parent index on success or number of parents in case of error
  */
 static u8 zynqmp_clk_mux_get_parent(struct clk_hw *hw)
 {
@@ -50,9 +50,15 @@ static u8 zynqmp_clk_mux_get_parent(struct clk_hw *hw)
 
 	ret = zynqmp_pm_clock_getparent(clk_id, &val);
 
-	if (ret)
+	if (ret) {
 		pr_warn_once("%s() getparent failed for clock: %s, ret = %d\n",
 			     __func__, clk_name, ret);
+		/*
+		 * clk_core_get_parent_by_index() takes num_parents as incorrect
+		 * index which is exactly what I want to return here
+		 */
+		return clk_hw_get_num_parents(hw);
+	}
 
 	return val;
 }
diff --git a/drivers/clk/zynqmp/pll.c b/drivers/clk/zynqmp/pll.c
index abe6afbf3407..e025581f0d54 100644
--- a/drivers/clk/zynqmp/pll.c
+++ b/drivers/clk/zynqmp/pll.c
@@ -31,8 +31,9 @@ struct zynqmp_pll {
 #define PS_PLL_VCO_MAX 3000000000UL
 
 enum pll_mode {
-	PLL_MODE_INT,
-	PLL_MODE_FRAC,
+	PLL_MODE_INT = 0,
+	PLL_MODE_FRAC = 1,
+	PLL_MODE_ERROR = 2,
 };
 
 #define FRAC_OFFSET 0x8
@@ -54,9 +55,11 @@ static inline enum pll_mode zynqmp_pll_get_mode(struct clk_hw *hw)
 	int ret;
 
 	ret = zynqmp_pm_get_pll_frac_mode(clk_id, ret_payload);
-	if (ret)
+	if (ret) {
 		pr_warn_once("%s() PLL get frac mode failed for %s, ret = %d\n",
 			     __func__, clk_name, ret);
+		return PLL_MODE_ERROR;
+	}
 
 	return ret_payload[1];
 }
@@ -126,7 +129,7 @@ static long zynqmp_pll_round_rate(struct clk_hw *hw, unsigned long rate,
  * @hw:			Handle between common and hardware-specific interfaces
  * @parent_rate:	Clock frequency of parent clock
  *
- * Return: Current clock frequency
+ * Return: Current clock frequency or 0 in case of error
  */
 static unsigned long zynqmp_pll_recalc_rate(struct clk_hw *hw,
 					    unsigned long parent_rate)
@@ -138,14 +141,21 @@ static unsigned long zynqmp_pll_recalc_rate(struct clk_hw *hw,
 	unsigned long rate, frac;
 	u32 ret_payload[PAYLOAD_ARG_CNT];
 	int ret;
+	enum pll_mode mode;
 
 	ret = zynqmp_pm_clock_getdivider(clk_id, &fbdiv);
-	if (ret)
+	if (ret) {
 		pr_warn_once("%s() get divider failed for %s, ret = %d\n",
 			     __func__, clk_name, ret);
+		return 0ul;
+	}
+
+	mode = zynqmp_pll_get_mode(hw);
+	if (mode == PLL_MODE_ERROR)
+		return 0ul;
 
 	rate =  parent_rate * fbdiv;
-	if (zynqmp_pll_get_mode(hw) == PLL_MODE_FRAC) {
+	if (mode == PLL_MODE_FRAC) {
 		zynqmp_pm_get_pll_frac_data(clk_id, ret_payload);
 		data = ret_payload[1];
 		frac = (parent_rate * data) / FRAC_DIV;
-- 
2.30.2



