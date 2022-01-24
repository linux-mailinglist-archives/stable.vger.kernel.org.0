Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB449A388
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365518AbiAXXvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573414AbiAXVo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C487C0613DE;
        Mon, 24 Jan 2022 12:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5785061505;
        Mon, 24 Jan 2022 20:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E663C340E5;
        Mon, 24 Jan 2022 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056333;
        bh=YxXYK6Vs5YW1etJLgYJ8W5bksdi4WJjPLmiyrsJ/acs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUwsUYjaeUVrn6wyu88xDY+CYBw3PsC7bqSnSdAbEu+n3p9chScuzmVx+vpW6C/1j
         oCFvTzQM6mRXXyU4Dw06pqRifSOYRrYsNNU0PfPxEh4PjhON1AEg3GtrBrl5pw3m0a
         wn+3UwhBdVI9Ue6GgnRSVL+XXuxkPJwZ1lDyQjxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/846] ASoC: fsl_asrc: refine the check of available clock divider
Date:   Mon, 24 Jan 2022 19:39:27 +0100
Message-Id: <20220124184116.518720391@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 320386343451ab6a3577e0ee200dac56a6182944 ]

According to RM, the clock divider range is from 1 to 8, clock
prescaling ratio may be any power of 2 from 1 to 128.
So the supported divider is not all the value between
1 and 1024, just limited value in that range.

Create table for the supported divder and add function to
check the clock divider is available by comparing with
the table.

Fixes: d0250cf4f2ab ("ASoC: fsl_asrc: Add an option to select internal ratio mode")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1641380883-20709-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 69 +++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 11 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 24b41881a68f8..d7d1536a4f377 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -19,6 +19,7 @@
 #include "fsl_asrc.h"
 
 #define IDEAL_RATIO_DECIMAL_DEPTH 26
+#define DIVIDER_NUM  64
 
 #define pair_err(fmt, ...) \
 	dev_err(&asrc->pdev->dev, "Pair %c: " fmt, 'A' + index, ##__VA_ARGS__)
@@ -101,6 +102,55 @@ static unsigned char clk_map_imx8qxp[2][ASRC_CLK_MAP_LEN] = {
 	},
 };
 
+/*
+ * According to RM, the divider range is 1 ~ 8,
+ * prescaler is power of 2 from 1 ~ 128.
+ */
+static int asrc_clk_divider[DIVIDER_NUM] = {
+	1,  2,  4,  8,  16,  32,  64,  128,  /* divider = 1 */
+	2,  4,  8, 16,  32,  64, 128,  256,  /* divider = 2 */
+	3,  6, 12, 24,  48,  96, 192,  384,  /* divider = 3 */
+	4,  8, 16, 32,  64, 128, 256,  512,  /* divider = 4 */
+	5, 10, 20, 40,  80, 160, 320,  640,  /* divider = 5 */
+	6, 12, 24, 48,  96, 192, 384,  768,  /* divider = 6 */
+	7, 14, 28, 56, 112, 224, 448,  896,  /* divider = 7 */
+	8, 16, 32, 64, 128, 256, 512, 1024,  /* divider = 8 */
+};
+
+/*
+ * Check if the divider is available for internal ratio mode
+ */
+static bool fsl_asrc_divider_avail(int clk_rate, int rate, int *div)
+{
+	u32 rem, i;
+	u64 n;
+
+	if (div)
+		*div = 0;
+
+	if (clk_rate == 0 || rate == 0)
+		return false;
+
+	n = clk_rate;
+	rem = do_div(n, rate);
+
+	if (div)
+		*div = n;
+
+	if (rem != 0)
+		return false;
+
+	for (i = 0; i < DIVIDER_NUM; i++) {
+		if (n == asrc_clk_divider[i])
+			break;
+	}
+
+	if (i == DIVIDER_NUM)
+		return false;
+
+	return true;
+}
+
 /**
  * fsl_asrc_sel_proc - Select the pre-processing and post-processing options
  * @inrate: input sample rate
@@ -330,12 +380,12 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 	enum asrc_word_width input_word_width;
 	enum asrc_word_width output_word_width;
 	u32 inrate, outrate, indiv, outdiv;
-	u32 clk_index[2], div[2], rem[2];
+	u32 clk_index[2], div[2];
 	u64 clk_rate;
 	int in, out, channels;
 	int pre_proc, post_proc;
 	struct clk *clk;
-	bool ideal;
+	bool ideal, div_avail;
 
 	if (!config) {
 		pair_err("invalid pair config\n");
@@ -415,8 +465,7 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 	clk = asrc_priv->asrck_clk[clk_index[ideal ? OUT : IN]];
 
 	clk_rate = clk_get_rate(clk);
-	rem[IN] = do_div(clk_rate, inrate);
-	div[IN] = (u32)clk_rate;
+	div_avail = fsl_asrc_divider_avail(clk_rate, inrate, &div[IN]);
 
 	/*
 	 * The divider range is [1, 1024], defined by the hardware. For non-
@@ -425,7 +474,7 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 	 * only result in different converting speeds. So remainder does not
 	 * matter, as long as we keep the divider within its valid range.
 	 */
-	if (div[IN] == 0 || (!ideal && (div[IN] > 1024 || rem[IN] != 0))) {
+	if (div[IN] == 0 || (!ideal && !div_avail)) {
 		pair_err("failed to support input sample rate %dHz by asrck_%x\n",
 				inrate, clk_index[ideal ? OUT : IN]);
 		return -EINVAL;
@@ -436,13 +485,12 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 	clk = asrc_priv->asrck_clk[clk_index[OUT]];
 	clk_rate = clk_get_rate(clk);
 	if (ideal && use_ideal_rate)
-		rem[OUT] = do_div(clk_rate, IDEAL_RATIO_RATE);
+		div_avail = fsl_asrc_divider_avail(clk_rate, IDEAL_RATIO_RATE, &div[OUT]);
 	else
-		rem[OUT] = do_div(clk_rate, outrate);
-	div[OUT] = clk_rate;
+		div_avail = fsl_asrc_divider_avail(clk_rate, outrate, &div[OUT]);
 
 	/* Output divider has the same limitation as the input one */
-	if (div[OUT] == 0 || (!ideal && (div[OUT] > 1024 || rem[OUT] != 0))) {
+	if (div[OUT] == 0 || (!ideal && !div_avail)) {
 		pair_err("failed to support output sample rate %dHz by asrck_%x\n",
 				outrate, clk_index[OUT]);
 		return -EINVAL;
@@ -621,8 +669,7 @@ static void fsl_asrc_select_clk(struct fsl_asrc_priv *asrc_priv,
 			clk_index = asrc_priv->clk_map[j][i];
 			clk_rate = clk_get_rate(asrc_priv->asrck_clk[clk_index]);
 			/* Only match a perfect clock source with no remainder */
-			if (clk_rate != 0 && (clk_rate / rate[j]) <= 1024 &&
-			    (clk_rate % rate[j]) == 0)
+			if (fsl_asrc_divider_avail(clk_rate, rate[j], NULL))
 				break;
 		}
 
-- 
2.34.1



