Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465F337CD9F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhELQ5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244032AbhELQm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 357BB61C63;
        Wed, 12 May 2021 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835773;
        bh=U0cgWBA0KrtKHF7SztuJ8ZQ6lfVdEPSsSwiV8lNEjrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rx2iN2D/sp1QBXr/WqUFe5UiBo/XaQTpG6gdpbtpmumlkX1EfvNTbEzkOy8s+PE7M
         NIGaBLhED0363QjeT6zWc+R6S+5gyXXyj9GkkpvQr8HJ5z25PzNj1vl9o6kMHtsUPi
         0J1nDWhdL0Cc9s5N1/TNQ2aAjjBIvU3eKGrr5Rqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 478/677] ASoC: q6afe-clocks: fix reprobing of the driver
Date:   Wed, 12 May 2021 16:48:44 +0200
Message-Id: <20210512144853.240721704@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 96fadf7e8ff49fdb74754801228942b67c3eeebd ]

Q6afe-clocks driver can get reprobed. For example if the APR services
are restarted after the firmware crash. However currently Q6afe-clocks
driver will oops because hw.init will get cleared during first _probe
call. Rewrite the driver to fill the clock data at runtime rather than
using big static array of clocks.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Fixes: 520a1c396d19 ("ASoC: q6afe-clocks: add q6afe clock controller")
Link: https://lore.kernel.org/r/20210327092857.3073879-1-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6afe-clocks.c | 209 ++++++++++++++--------------
 sound/soc/qcom/qdsp6/q6afe.c        |   2 +-
 sound/soc/qcom/qdsp6/q6afe.h        |   2 +-
 3 files changed, 108 insertions(+), 105 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6afe-clocks.c b/sound/soc/qcom/qdsp6/q6afe-clocks.c
index f0362f061652..9431656283cd 100644
--- a/sound/soc/qcom/qdsp6/q6afe-clocks.c
+++ b/sound/soc/qcom/qdsp6/q6afe-clocks.c
@@ -11,33 +11,29 @@
 #include <linux/slab.h>
 #include "q6afe.h"
 
-#define Q6AFE_CLK(id) &(struct q6afe_clk) {		\
+#define Q6AFE_CLK(id) {					\
 		.clk_id	= id,				\
 		.afe_clk_id	= Q6AFE_##id,		\
 		.name = #id,				\
-		.attributes = LPASS_CLK_ATTRIBUTE_COUPLE_NO, \
 		.rate = 19200000,			\
-		.hw.init = &(struct clk_init_data) {	\
-			.ops = &clk_q6afe_ops,		\
-			.name = #id,			\
-		},					\
 	}
 
-#define Q6AFE_VOTE_CLK(id, blkid, n) &(struct q6afe_clk) { \
+#define Q6AFE_VOTE_CLK(id, blkid, n) {			\
 		.clk_id	= id,				\
 		.afe_clk_id = blkid,			\
-		.name = #n,				\
-		.hw.init = &(struct clk_init_data) {	\
-			.ops = &clk_vote_q6afe_ops,	\
-			.name = #id,			\
-		},					\
+		.name = n,				\
 	}
 
-struct q6afe_clk {
-	struct device *dev;
+struct q6afe_clk_init {
 	int clk_id;
 	int afe_clk_id;
 	char *name;
+	int rate;
+};
+
+struct q6afe_clk {
+	struct device *dev;
+	int afe_clk_id;
 	int attributes;
 	int rate;
 	uint32_t handle;
@@ -48,8 +44,7 @@ struct q6afe_clk {
 
 struct q6afe_cc {
 	struct device *dev;
-	struct q6afe_clk **clks;
-	int num_clks;
+	struct q6afe_clk *clks[Q6AFE_MAX_CLK_ID];
 };
 
 static int clk_q6afe_prepare(struct clk_hw *hw)
@@ -105,7 +100,7 @@ static int clk_vote_q6afe_block(struct clk_hw *hw)
 	struct q6afe_clk *clk = to_q6afe_clk(hw);
 
 	return q6afe_vote_lpass_core_hw(clk->dev, clk->afe_clk_id,
-					clk->name, &clk->handle);
+					clk_hw_get_name(&clk->hw), &clk->handle);
 }
 
 static void clk_unvote_q6afe_block(struct clk_hw *hw)
@@ -120,84 +115,76 @@ static const struct clk_ops clk_vote_q6afe_ops = {
 	.unprepare	= clk_unvote_q6afe_block,
 };
 
-static struct q6afe_clk *q6afe_clks[Q6AFE_MAX_CLK_ID] = {
-	[LPASS_CLK_ID_PRI_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_IBIT),
-	[LPASS_CLK_ID_PRI_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_EBIT),
-	[LPASS_CLK_ID_SEC_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_IBIT),
-	[LPASS_CLK_ID_SEC_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_EBIT),
-	[LPASS_CLK_ID_TER_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_IBIT),
-	[LPASS_CLK_ID_TER_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_EBIT),
-	[LPASS_CLK_ID_QUAD_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_IBIT),
-	[LPASS_CLK_ID_QUAD_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_EBIT),
-	[LPASS_CLK_ID_SPEAKER_I2S_IBIT] =
-				Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_IBIT),
-	[LPASS_CLK_ID_SPEAKER_I2S_EBIT] =
-				Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_EBIT),
-	[LPASS_CLK_ID_SPEAKER_I2S_OSR] =
-				Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_OSR),
-	[LPASS_CLK_ID_QUI_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_IBIT),
-	[LPASS_CLK_ID_QUI_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_EBIT),
-	[LPASS_CLK_ID_SEN_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_IBIT),
-	[LPASS_CLK_ID_SEN_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_EBIT),
-	[LPASS_CLK_ID_INT0_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT0_MI2S_IBIT),
-	[LPASS_CLK_ID_INT1_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT1_MI2S_IBIT),
-	[LPASS_CLK_ID_INT2_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT2_MI2S_IBIT),
-	[LPASS_CLK_ID_INT3_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT3_MI2S_IBIT),
-	[LPASS_CLK_ID_INT4_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT4_MI2S_IBIT),
-	[LPASS_CLK_ID_INT5_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT5_MI2S_IBIT),
-	[LPASS_CLK_ID_INT6_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT6_MI2S_IBIT),
-	[LPASS_CLK_ID_QUI_MI2S_OSR] = Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_OSR),
-	[LPASS_CLK_ID_PRI_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_IBIT),
-	[LPASS_CLK_ID_PRI_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_EBIT),
-	[LPASS_CLK_ID_SEC_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_IBIT),
-	[LPASS_CLK_ID_SEC_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_EBIT),
-	[LPASS_CLK_ID_TER_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_IBIT),
-	[LPASS_CLK_ID_TER_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_EBIT),
-	[LPASS_CLK_ID_QUAD_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_IBIT),
-	[LPASS_CLK_ID_QUAD_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_EBIT),
-	[LPASS_CLK_ID_QUIN_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_IBIT),
-	[LPASS_CLK_ID_QUIN_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_EBIT),
-	[LPASS_CLK_ID_QUI_PCM_OSR] = Q6AFE_CLK(LPASS_CLK_ID_QUI_PCM_OSR),
-	[LPASS_CLK_ID_PRI_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_IBIT),
-	[LPASS_CLK_ID_PRI_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_EBIT),
-	[LPASS_CLK_ID_SEC_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_IBIT),
-	[LPASS_CLK_ID_SEC_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_EBIT),
-	[LPASS_CLK_ID_TER_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_IBIT),
-	[LPASS_CLK_ID_TER_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_EBIT),
-	[LPASS_CLK_ID_QUAD_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_IBIT),
-	[LPASS_CLK_ID_QUAD_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_EBIT),
-	[LPASS_CLK_ID_QUIN_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_IBIT),
-	[LPASS_CLK_ID_QUIN_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_EBIT),
-	[LPASS_CLK_ID_QUIN_TDM_OSR] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_OSR),
-	[LPASS_CLK_ID_MCLK_1] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_1),
-	[LPASS_CLK_ID_MCLK_2] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_2),
-	[LPASS_CLK_ID_MCLK_3] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_3),
-	[LPASS_CLK_ID_MCLK_4] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_4),
-	[LPASS_CLK_ID_INTERNAL_DIGITAL_CODEC_CORE] =
-		Q6AFE_CLK(LPASS_CLK_ID_INTERNAL_DIGITAL_CODEC_CORE),
-	[LPASS_CLK_ID_INT_MCLK_0] = Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_0),
-	[LPASS_CLK_ID_INT_MCLK_1] = Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_1),
-	[LPASS_CLK_ID_WSA_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_MCLK),
-	[LPASS_CLK_ID_WSA_CORE_NPL_MCLK] =
-				Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_NPL_MCLK),
-	[LPASS_CLK_ID_VA_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_MCLK),
-	[LPASS_CLK_ID_TX_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_MCLK),
-	[LPASS_CLK_ID_TX_CORE_NPL_MCLK] =
-			Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_NPL_MCLK),
-	[LPASS_CLK_ID_RX_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_MCLK),
-	[LPASS_CLK_ID_RX_CORE_NPL_MCLK] =
-				Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_NPL_MCLK),
-	[LPASS_CLK_ID_VA_CORE_2X_MCLK] =
-				Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_2X_MCLK),
-	[LPASS_HW_AVTIMER_VOTE] = Q6AFE_VOTE_CLK(LPASS_HW_AVTIMER_VOTE,
-						 Q6AFE_LPASS_CORE_AVTIMER_BLOCK,
-						 "LPASS_AVTIMER_MACRO"),
-	[LPASS_HW_MACRO_VOTE] = Q6AFE_VOTE_CLK(LPASS_HW_MACRO_VOTE,
-						Q6AFE_LPASS_CORE_HW_MACRO_BLOCK,
-						"LPASS_HW_MACRO"),
-	[LPASS_HW_DCODEC_VOTE] = Q6AFE_VOTE_CLK(LPASS_HW_DCODEC_VOTE,
-					Q6AFE_LPASS_CORE_HW_DCODEC_BLOCK,
-					"LPASS_HW_DCODEC"),
+static const struct q6afe_clk_init q6afe_clks[] = {
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT0_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT1_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT2_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT3_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT4_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT5_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT6_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_PCM_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_1),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_2),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_3),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_4),
+	Q6AFE_CLK(LPASS_CLK_ID_INTERNAL_DIGITAL_CODEC_CORE),
+	Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_0),
+	Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_1),
+	Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_NPL_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_NPL_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_NPL_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_2X_MCLK),
+	Q6AFE_VOTE_CLK(LPASS_HW_AVTIMER_VOTE,
+		       Q6AFE_LPASS_CORE_AVTIMER_BLOCK,
+		       "LPASS_AVTIMER_MACRO"),
+	Q6AFE_VOTE_CLK(LPASS_HW_MACRO_VOTE,
+		       Q6AFE_LPASS_CORE_HW_MACRO_BLOCK,
+		       "LPASS_HW_MACRO"),
+	Q6AFE_VOTE_CLK(LPASS_HW_DCODEC_VOTE,
+		       Q6AFE_LPASS_CORE_HW_DCODEC_BLOCK,
+		       "LPASS_HW_DCODEC"),
 };
 
 static struct clk_hw *q6afe_of_clk_hw_get(struct of_phandle_args *clkspec,
@@ -207,7 +194,7 @@ static struct clk_hw *q6afe_of_clk_hw_get(struct of_phandle_args *clkspec,
 	unsigned int idx = clkspec->args[0];
 	unsigned int attr = clkspec->args[1];
 
-	if (idx >= cc->num_clks || attr > LPASS_CLK_ATTRIBUTE_COUPLE_DIVISOR) {
+	if (idx >= Q6AFE_MAX_CLK_ID || attr > LPASS_CLK_ATTRIBUTE_COUPLE_DIVISOR) {
 		dev_err(cc->dev, "Invalid clk specifier (%d, %d)\n", idx, attr);
 		return ERR_PTR(-EINVAL);
 	}
@@ -230,20 +217,36 @@ static int q6afe_clock_dev_probe(struct platform_device *pdev)
 	if (!cc)
 		return -ENOMEM;
 
-	cc->clks = &q6afe_clks[0];
-	cc->num_clks = ARRAY_SIZE(q6afe_clks);
+	cc->dev = dev;
 	for (i = 0; i < ARRAY_SIZE(q6afe_clks); i++) {
-		if (!q6afe_clks[i])
-			continue;
+		unsigned int id = q6afe_clks[i].clk_id;
+		struct clk_init_data init = {
+			.name =  q6afe_clks[i].name,
+		};
+		struct q6afe_clk *clk;
+
+		clk = devm_kzalloc(dev, sizeof(*clk), GFP_KERNEL);
+		if (!clk)
+			return -ENOMEM;
+
+		clk->dev = dev;
+		clk->afe_clk_id = q6afe_clks[i].afe_clk_id;
+		clk->rate = q6afe_clks[i].rate;
+		clk->hw.init = &init;
+
+		if (clk->rate)
+			init.ops = &clk_q6afe_ops;
+		else
+			init.ops = &clk_vote_q6afe_ops;
 
-		q6afe_clks[i]->dev = dev;
+		cc->clks[id] = clk;
 
-		ret = devm_clk_hw_register(dev, &q6afe_clks[i]->hw);
+		ret = devm_clk_hw_register(dev, &clk->hw);
 		if (ret)
 			return ret;
 	}
 
-	ret = of_clk_add_hw_provider(dev->of_node, q6afe_of_clk_hw_get, cc);
+	ret = devm_of_clk_add_hw_provider(dev, q6afe_of_clk_hw_get, cc);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/qcom/qdsp6/q6afe.c b/sound/soc/qcom/qdsp6/q6afe.c
index cad1cd1bfdf0..4327b72162ec 100644
--- a/sound/soc/qcom/qdsp6/q6afe.c
+++ b/sound/soc/qcom/qdsp6/q6afe.c
@@ -1681,7 +1681,7 @@ int q6afe_unvote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 EXPORT_SYMBOL(q6afe_unvote_lpass_core_hw);
 
 int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
-			     char *client_name, uint32_t *client_handle)
+			     const char *client_name, uint32_t *client_handle)
 {
 	struct q6afe *afe = dev_get_drvdata(dev->parent);
 	struct afe_cmd_remote_lpass_core_hw_vote_request *vote_cfg;
diff --git a/sound/soc/qcom/qdsp6/q6afe.h b/sound/soc/qcom/qdsp6/q6afe.h
index 22e10269aa10..3845b56c0ed3 100644
--- a/sound/soc/qcom/qdsp6/q6afe.h
+++ b/sound/soc/qcom/qdsp6/q6afe.h
@@ -236,7 +236,7 @@ int q6afe_port_set_sysclk(struct q6afe_port *port, int clk_id,
 int q6afe_set_lpass_clock(struct device *dev, int clk_id, int clk_src,
 			  int clk_root, unsigned int freq);
 int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
-			     char *client_name, uint32_t *client_handle);
+			     const char *client_name, uint32_t *client_handle);
 int q6afe_unvote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 			       uint32_t client_handle);
 #endif /* __Q6AFE_H__ */
-- 
2.30.2



