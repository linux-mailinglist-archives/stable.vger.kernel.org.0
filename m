Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355781FE77E
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgFRClP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgFRBM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 611B921D7E;
        Thu, 18 Jun 2020 01:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442744;
        bh=6X4wc0pENFlgeeh7h4Fr+UX0EjJbe3dkXD4/eN8TJTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+yDMizdpPy44vV75Xs+XXo7qoVl7u9cTtdXWBAHornT1BRaQvxjrw3s91Q6MMGLf
         xRsfyT0/jLRWRNOfyNp83KKd2ZL+MCnwLc4zsm00E0bRRltU6jEmpJ66QQWA4KnNfi
         iUquDXHVG3X1OHueu2Z1PrBbUIRyyHgZc6tMZHE0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 197/388] remoteproc: qcom_q6v5_mss: Drop accesses to MPSS PERPH register space
Date:   Wed, 17 Jun 2020 21:04:54 -0400
Message-Id: <20200618010805.600873-197-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit a9fdc79d488623d36341f0f3d08f5aa1bedb9d53 ]

7C retail devices using MSA based boot will result in a fuse combination
which will prevent accesses to MSS PERPH register space where the mpss
clocks and halt-nav reside. So drop all accesses to the MPSS PERPH
register space. Issuing HALT NAV request and turning on the mss clocks
as part of SSR will no longer be required since the modem firmware will
have the necessary fixes to ensure that there are no pending NAV DMA
transactions.

Tested-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200415145110.20624-3-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 102 +++++------------------------
 1 file changed, 18 insertions(+), 84 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 22416e86a174..629abcee2c1d 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -69,13 +69,9 @@
 #define AXI_HALTREQ_REG			0x0
 #define AXI_HALTACK_REG			0x4
 #define AXI_IDLE_REG			0x8
-#define NAV_AXI_HALTREQ_BIT		BIT(0)
-#define NAV_AXI_HALTACK_BIT		BIT(1)
-#define NAV_AXI_IDLE_BIT		BIT(2)
 #define AXI_GATING_VALID_OVERRIDE	BIT(0)
 
 #define HALT_ACK_TIMEOUT_US		100000
-#define NAV_HALT_ACK_TIMEOUT_US		200
 
 /* QDSP6SS_RESET */
 #define Q6SS_STOP_CORE			BIT(0)
@@ -143,7 +139,7 @@ struct rproc_hexagon_res {
 	int version;
 	bool need_mem_protection;
 	bool has_alt_reset;
-	bool has_halt_nav;
+	bool has_spare_reg;
 };
 
 struct q6v5 {
@@ -154,13 +150,11 @@ struct q6v5 {
 	void __iomem *rmb_base;
 
 	struct regmap *halt_map;
-	struct regmap *halt_nav_map;
 	struct regmap *conn_map;
 
 	u32 halt_q6;
 	u32 halt_modem;
 	u32 halt_nc;
-	u32 halt_nav;
 	u32 conn_box;
 
 	struct reset_control *mss_restart;
@@ -206,7 +200,7 @@ struct q6v5 {
 	struct qcom_sysmon *sysmon;
 	bool need_mem_protection;
 	bool has_alt_reset;
-	bool has_halt_nav;
+	bool has_spare_reg;
 	int mpss_perm;
 	int mba_perm;
 	const char *hexagon_mdt_image;
@@ -427,21 +421,19 @@ static int q6v5_reset_assert(struct q6v5 *qproc)
 		reset_control_assert(qproc->pdc_reset);
 		ret = reset_control_reset(qproc->mss_restart);
 		reset_control_deassert(qproc->pdc_reset);
-	} else if (qproc->has_halt_nav) {
+	} else if (qproc->has_spare_reg) {
 		/*
 		 * When the AXI pipeline is being reset with the Q6 modem partly
 		 * operational there is possibility of AXI valid signal to
 		 * glitch, leading to spurious transactions and Q6 hangs. A work
 		 * around is employed by asserting the AXI_GATING_VALID_OVERRIDE
-		 * BIT before triggering Q6 MSS reset. Both the HALTREQ and
-		 * AXI_GATING_VALID_OVERRIDE are withdrawn post MSS assert
-		 * followed by a MSS deassert, while holding the PDC reset.
+		 * BIT before triggering Q6 MSS reset. AXI_GATING_VALID_OVERRIDE
+		 * is withdrawn post MSS assert followed by a MSS deassert,
+		 * while holding the PDC reset.
 		 */
 		reset_control_assert(qproc->pdc_reset);
 		regmap_update_bits(qproc->conn_map, qproc->conn_box,
 				   AXI_GATING_VALID_OVERRIDE, 1);
-		regmap_update_bits(qproc->halt_nav_map, qproc->halt_nav,
-				   NAV_AXI_HALTREQ_BIT, 0);
 		reset_control_assert(qproc->mss_restart);
 		reset_control_deassert(qproc->pdc_reset);
 		regmap_update_bits(qproc->conn_map, qproc->conn_box,
@@ -464,7 +456,7 @@ static int q6v5_reset_deassert(struct q6v5 *qproc)
 		ret = reset_control_reset(qproc->mss_restart);
 		writel(0, qproc->rmb_base + RMB_MBA_ALT_RESET);
 		reset_control_deassert(qproc->pdc_reset);
-	} else if (qproc->has_halt_nav) {
+	} else if (qproc->has_spare_reg) {
 		ret = reset_control_reset(qproc->mss_restart);
 	} else {
 		ret = reset_control_deassert(qproc->mss_restart);
@@ -761,32 +753,6 @@ static void q6v5proc_halt_axi_port(struct q6v5 *qproc,
 	regmap_write(halt_map, offset + AXI_HALTREQ_REG, 0);
 }
 
-static void q6v5proc_halt_nav_axi_port(struct q6v5 *qproc,
-				       struct regmap *halt_map,
-				       u32 offset)
-{
-	unsigned int val;
-	int ret;
-
-	/* Check if we're already idle */
-	ret = regmap_read(halt_map, offset, &val);
-	if (!ret && (val & NAV_AXI_IDLE_BIT))
-		return;
-
-	/* Assert halt request */
-	regmap_update_bits(halt_map, offset, NAV_AXI_HALTREQ_BIT,
-			   NAV_AXI_HALTREQ_BIT);
-
-	/* Wait for halt ack*/
-	regmap_read_poll_timeout(halt_map, offset, val,
-				 (val & NAV_AXI_HALTACK_BIT),
-				 5, NAV_HALT_ACK_TIMEOUT_US);
-
-	ret = regmap_read(halt_map, offset, &val);
-	if (ret || !(val & NAV_AXI_IDLE_BIT))
-		dev_err(qproc->dev, "port failed halt\n");
-}
-
 static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
 {
 	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS;
@@ -951,9 +917,6 @@ static int q6v5_mba_load(struct q6v5 *qproc)
 halt_axi_ports:
 	q6v5proc_halt_axi_port(qproc, qproc->halt_map, qproc->halt_q6);
 	q6v5proc_halt_axi_port(qproc, qproc->halt_map, qproc->halt_modem);
-	if (qproc->has_halt_nav)
-		q6v5proc_halt_nav_axi_port(qproc, qproc->halt_nav_map,
-					   qproc->halt_nav);
 	q6v5proc_halt_axi_port(qproc, qproc->halt_map, qproc->halt_nc);
 
 reclaim_mba:
@@ -1001,9 +964,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
 
 	q6v5proc_halt_axi_port(qproc, qproc->halt_map, qproc->halt_q6);
 	q6v5proc_halt_axi_port(qproc, qproc->halt_map, qproc->halt_modem);
-	if (qproc->has_halt_nav)
-		q6v5proc_halt_nav_axi_port(qproc, qproc->halt_nav_map,
-					   qproc->halt_nav);
 	q6v5proc_halt_axi_port(qproc, qproc->halt_map, qproc->halt_nc);
 	if (qproc->version == MSS_MSM8996) {
 		/*
@@ -1447,36 +1407,12 @@ static int q6v5_init_mem(struct q6v5 *qproc, struct platform_device *pdev)
 	qproc->halt_modem = args.args[1];
 	qproc->halt_nc = args.args[2];
 
-	if (qproc->has_halt_nav) {
-		struct platform_device *nav_pdev;
-
+	if (qproc->has_spare_reg) {
 		ret = of_parse_phandle_with_fixed_args(pdev->dev.of_node,
-						       "qcom,halt-nav-regs",
+						       "qcom,spare-regs",
 						       1, 0, &args);
 		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to parse halt-nav-regs\n");
-			return -EINVAL;
-		}
-
-		nav_pdev = of_find_device_by_node(args.np);
-		of_node_put(args.np);
-		if (!nav_pdev) {
-			dev_err(&pdev->dev, "failed to get mss clock device\n");
-			return -EPROBE_DEFER;
-		}
-
-		qproc->halt_nav_map = dev_get_regmap(&nav_pdev->dev, NULL);
-		if (!qproc->halt_nav_map) {
-			dev_err(&pdev->dev, "failed to get map from device\n");
-			return -EINVAL;
-		}
-		qproc->halt_nav = args.args[0];
-
-		ret = of_parse_phandle_with_fixed_args(pdev->dev.of_node,
-						       "qcom,halt-nav-regs",
-						       1, 1, &args);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to parse halt-nav-regs\n");
+			dev_err(&pdev->dev, "failed to parse spare-regs\n");
 			return -EINVAL;
 		}
 
@@ -1562,7 +1498,7 @@ static int q6v5_init_reset(struct q6v5 *qproc)
 		return PTR_ERR(qproc->mss_restart);
 	}
 
-	if (qproc->has_alt_reset || qproc->has_halt_nav) {
+	if (qproc->has_alt_reset || qproc->has_spare_reg) {
 		qproc->pdc_reset = devm_reset_control_get_exclusive(qproc->dev,
 								    "pdc_reset");
 		if (IS_ERR(qproc->pdc_reset)) {
@@ -1688,7 +1624,7 @@ static int q6v5_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, qproc);
 
-	qproc->has_halt_nav = desc->has_halt_nav;
+	qproc->has_spare_reg = desc->has_spare_reg;
 	ret = q6v5_init_mem(qproc, pdev);
 	if (ret)
 		goto free_rproc;
@@ -1837,8 +1773,6 @@ static const struct rproc_hexagon_res sc7180_mss = {
 	.active_clk_names = (char*[]){
 		"mnoc_axi",
 		"nav",
-		"mss_nav",
-		"mss_crypto",
 		NULL
 	},
 	.active_pd_names = (char*[]){
@@ -1853,7 +1787,7 @@ static const struct rproc_hexagon_res sc7180_mss = {
 	},
 	.need_mem_protection = true,
 	.has_alt_reset = false,
-	.has_halt_nav = true,
+	.has_spare_reg = true,
 	.version = MSS_SC7180,
 };
 
@@ -1888,7 +1822,7 @@ static const struct rproc_hexagon_res sdm845_mss = {
 	},
 	.need_mem_protection = true,
 	.has_alt_reset = true,
-	.has_halt_nav = false,
+	.has_spare_reg = false,
 	.version = MSS_SDM845,
 };
 
@@ -1915,7 +1849,7 @@ static const struct rproc_hexagon_res msm8998_mss = {
 	},
 	.need_mem_protection = true,
 	.has_alt_reset = false,
-	.has_halt_nav = false,
+	.has_spare_reg = false,
 	.version = MSS_MSM8998,
 };
 
@@ -1945,7 +1879,7 @@ static const struct rproc_hexagon_res msm8996_mss = {
 	},
 	.need_mem_protection = true,
 	.has_alt_reset = false,
-	.has_halt_nav = false,
+	.has_spare_reg = false,
 	.version = MSS_MSM8996,
 };
 
@@ -1978,7 +1912,7 @@ static const struct rproc_hexagon_res msm8916_mss = {
 	},
 	.need_mem_protection = false,
 	.has_alt_reset = false,
-	.has_halt_nav = false,
+	.has_spare_reg = false,
 	.version = MSS_MSM8916,
 };
 
@@ -2019,7 +1953,7 @@ static const struct rproc_hexagon_res msm8974_mss = {
 	},
 	.need_mem_protection = false,
 	.has_alt_reset = false,
-	.has_halt_nav = false,
+	.has_spare_reg = false,
 	.version = MSS_MSM8974,
 };
 
-- 
2.25.1

