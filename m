Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73224227196
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGTViE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727949AbgGTViD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CF122CAF;
        Mon, 20 Jul 2020 21:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281082;
        bh=n4T85vKu6U7O9nXJo9g5DTcybApjszNsDHc7XO0HUnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSulGq+hfAeV3SVnTwM3+uMKjaXcVAJ3i63Jq9NEeYAArdl2kwv/H0apU24EyUccq
         u4wgTGPVRV5qvYuAsduxQq9NOWNOEssdgm1jy9iwoaknxNvwn+aoyLFDsrH36xenVY
         9bHhpyH8pywRQJRwdYlvJJgeyAFfvhqsBNn1qH3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qi Liu <liuqi115@huawei.com>, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 37/40] drivers/perf: Prevent forced unbinding of PMU drivers
Date:   Mon, 20 Jul 2020 17:37:12 -0400
Message-Id: <20200720213715.406997-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Liu <liuqi115@huawei.com>

[ Upstream commit f32ed8eb0e3f0d0ef4ddb854554d60ca5863a9f9 ]

Forcefully unbinding PMU drivers during perf sampling will lead to
a kernel panic, because the perf upper-layer framework call a NULL
pointer in this situation.

To solve this issue, "suppress_bind_attrs" should be set to true, so
that bind/unbind can be disabled via sysfs and prevent unbinding PMU
drivers during perf sampling.

Signed-off-by: Qi Liu <liuqi115@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1594975763-32966-1-git-send-email-liuqi115@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cci.c                        | 1 +
 drivers/perf/arm-ccn.c                        | 1 +
 drivers/perf/arm_dsu_pmu.c                    | 1 +
 drivers/perf/arm_smmuv3_pmu.c                 | 1 +
 drivers/perf/arm_spe_pmu.c                    | 1 +
 drivers/perf/fsl_imx8_ddr_perf.c              | 1 +
 drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c | 1 +
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c  | 1 +
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c  | 1 +
 drivers/perf/qcom_l2_pmu.c                    | 1 +
 drivers/perf/qcom_l3_pmu.c                    | 1 +
 drivers/perf/thunderx2_pmu.c                  | 1 +
 drivers/perf/xgene_pmu.c                      | 1 +
 13 files changed, 13 insertions(+)

diff --git a/drivers/perf/arm-cci.c b/drivers/perf/arm-cci.c
index 1b8e337a29cac..87c4be9dd4125 100644
--- a/drivers/perf/arm-cci.c
+++ b/drivers/perf/arm-cci.c
@@ -1718,6 +1718,7 @@ static struct platform_driver cci_pmu_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .of_match_table = arm_cci_pmu_matches,
+		   .suppress_bind_attrs = true,
 		  },
 	.probe = cci_pmu_probe,
 	.remove = cci_pmu_remove,
diff --git a/drivers/perf/arm-ccn.c b/drivers/perf/arm-ccn.c
index d50edef91f59b..7b7d23f257139 100644
--- a/drivers/perf/arm-ccn.c
+++ b/drivers/perf/arm-ccn.c
@@ -1545,6 +1545,7 @@ static struct platform_driver arm_ccn_driver = {
 	.driver = {
 		.name = "arm-ccn",
 		.of_match_table = arm_ccn_match,
+		.suppress_bind_attrs = true,
 	},
 	.probe = arm_ccn_probe,
 	.remove = arm_ccn_remove,
diff --git a/drivers/perf/arm_dsu_pmu.c b/drivers/perf/arm_dsu_pmu.c
index 70968c8c09d7f..4594e2ed13d59 100644
--- a/drivers/perf/arm_dsu_pmu.c
+++ b/drivers/perf/arm_dsu_pmu.c
@@ -759,6 +759,7 @@ static struct platform_driver dsu_pmu_driver = {
 	.driver = {
 		.name	= DRVNAME,
 		.of_match_table = of_match_ptr(dsu_pmu_of_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = dsu_pmu_device_probe,
 	.remove = dsu_pmu_device_remove,
diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index 90caba56dfbc1..4cdb35d166acc 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -860,6 +860,7 @@ static void smmu_pmu_shutdown(struct platform_device *pdev)
 static struct platform_driver smmu_pmu_driver = {
 	.driver = {
 		.name = "arm-smmu-v3-pmcg",
+		.suppress_bind_attrs = true,
 	},
 	.probe = smmu_pmu_probe,
 	.remove = smmu_pmu_remove,
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index b72c048525990..c5418fd3122c2 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1228,6 +1228,7 @@ static struct platform_driver arm_spe_pmu_driver = {
 	.driver	= {
 		.name		= DRVNAME,
 		.of_match_table	= of_match_ptr(arm_spe_pmu_of_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe	= arm_spe_pmu_device_probe,
 	.remove	= arm_spe_pmu_device_remove,
diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 2aed2d96f8ae7..397540a4b799c 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -707,6 +707,7 @@ static struct platform_driver imx_ddr_pmu_driver = {
 	.driver         = {
 		.name   = "imx-ddr-pmu",
 		.of_match_table = imx_ddr_pmu_dt_ids,
+		.suppress_bind_attrs = true,
 	},
 	.probe          = ddr_perf_probe,
 	.remove         = ddr_perf_remove,
diff --git a/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c b/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
index c65da06abb041..3418527366408 100644
--- a/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
@@ -417,6 +417,7 @@ static struct platform_driver hisi_ddrc_pmu_driver = {
 	.driver = {
 		.name = "hisi_ddrc_pmu",
 		.acpi_match_table = ACPI_PTR(hisi_ddrc_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = hisi_ddrc_pmu_probe,
 	.remove = hisi_ddrc_pmu_remove,
diff --git a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
index ee6e6a1c390a0..375c4737a088a 100644
--- a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
@@ -429,6 +429,7 @@ static struct platform_driver hisi_hha_pmu_driver = {
 	.driver = {
 		.name = "hisi_hha_pmu",
 		.acpi_match_table = ACPI_PTR(hisi_hha_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = hisi_hha_pmu_probe,
 	.remove = hisi_hha_pmu_remove,
diff --git a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
index c8b98d3a8432a..44e8a660c5f52 100644
--- a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
@@ -419,6 +419,7 @@ static struct platform_driver hisi_l3c_pmu_driver = {
 	.driver = {
 		.name = "hisi_l3c_pmu",
 		.acpi_match_table = ACPI_PTR(hisi_l3c_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = hisi_l3c_pmu_probe,
 	.remove = hisi_l3c_pmu_remove,
diff --git a/drivers/perf/qcom_l2_pmu.c b/drivers/perf/qcom_l2_pmu.c
index 21d6991dbe0ba..4da37f650f983 100644
--- a/drivers/perf/qcom_l2_pmu.c
+++ b/drivers/perf/qcom_l2_pmu.c
@@ -1028,6 +1028,7 @@ static struct platform_driver l2_cache_pmu_driver = {
 	.driver = {
 		.name = "qcom-l2cache-pmu",
 		.acpi_match_table = ACPI_PTR(l2_cache_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = l2_cache_pmu_probe,
 	.remove = l2_cache_pmu_remove,
diff --git a/drivers/perf/qcom_l3_pmu.c b/drivers/perf/qcom_l3_pmu.c
index 656e830798d9e..9ddb577c542b5 100644
--- a/drivers/perf/qcom_l3_pmu.c
+++ b/drivers/perf/qcom_l3_pmu.c
@@ -814,6 +814,7 @@ static struct platform_driver qcom_l3_cache_pmu_driver = {
 	.driver = {
 		.name = "qcom-l3cache-pmu",
 		.acpi_match_table = ACPI_PTR(qcom_l3_cache_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = qcom_l3_cache_pmu_probe,
 };
diff --git a/drivers/perf/thunderx2_pmu.c b/drivers/perf/thunderx2_pmu.c
index 51b31d6ff2c4c..aac9823b0c6bb 100644
--- a/drivers/perf/thunderx2_pmu.c
+++ b/drivers/perf/thunderx2_pmu.c
@@ -1017,6 +1017,7 @@ static struct platform_driver tx2_uncore_driver = {
 	.driver = {
 		.name		= "tx2-uncore-pmu",
 		.acpi_match_table = ACPI_PTR(tx2_uncore_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = tx2_uncore_probe,
 	.remove = tx2_uncore_remove,
diff --git a/drivers/perf/xgene_pmu.c b/drivers/perf/xgene_pmu.c
index 46ee6807d533a..edac28cd25ddc 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1975,6 +1975,7 @@ static struct platform_driver xgene_pmu_driver = {
 		.name		= "xgene-pmu",
 		.of_match_table = xgene_pmu_of_match,
 		.acpi_match_table = ACPI_PTR(xgene_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 };
 
-- 
2.25.1

