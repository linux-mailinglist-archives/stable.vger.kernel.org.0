Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2F422EF93
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgG0ORY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbgG0ORW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:17:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7015120775;
        Mon, 27 Jul 2020 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859441;
        bh=rrYPwgY0lFW5PL5+vQ9DBmbkKCuq18MghKUF6N2ntoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEgdbfGTIkdQWG+EmNu0Pr+GmxwMw4shs3XKGj1Wd/x5IpxhwupfCJui2ipT7VUWW
         pHpsVjbJkR2ZRAghGG1XgSJ81H2xoO5bd+eHYz4RnaLaRn/AaY+zmp0Pyt7rmGmJMZ
         9saGX2TwrI1O9ymVXCaNosLIJ0W/cgWtCudPa7m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/138] drivers/perf: Prevent forced unbinding of PMU drivers
Date:   Mon, 27 Jul 2020 16:04:57 +0200
Message-Id: <20200727134930.567598549@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8f8606b9bc9ee..aca4570f78a86 100644
--- a/drivers/perf/arm-cci.c
+++ b/drivers/perf/arm-cci.c
@@ -1720,6 +1720,7 @@ static struct platform_driver cci_pmu_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .of_match_table = arm_cci_pmu_matches,
+		   .suppress_bind_attrs = true,
 		  },
 	.probe = cci_pmu_probe,
 	.remove = cci_pmu_remove,
diff --git a/drivers/perf/arm-ccn.c b/drivers/perf/arm-ccn.c
index 6fc0273b6129d..336948b41bd16 100644
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
index f8fc1b612119c..9cdd89b29334e 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -861,6 +861,7 @@ static void smmu_pmu_shutdown(struct platform_device *pdev)
 static struct platform_driver smmu_pmu_driver = {
 	.driver = {
 		.name = "arm-smmu-v3-pmcg",
+		.suppress_bind_attrs = true,
 	},
 	.probe = smmu_pmu_probe,
 	.remove = smmu_pmu_remove,
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 4e4984a55cd1b..079701e8de186 100644
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
index b241db6929c08..09f44c6e2eaf6 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -646,6 +646,7 @@ static struct platform_driver imx_ddr_pmu_driver = {
 	.driver         = {
 		.name   = "imx-ddr-pmu",
 		.of_match_table = imx_ddr_pmu_dt_ids,
+		.suppress_bind_attrs = true,
 	},
 	.probe          = ddr_perf_probe,
 	.remove         = ddr_perf_remove,
diff --git a/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c b/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
index 64712cf2f99ad..b79c96b14328b 100644
--- a/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
@@ -420,6 +420,7 @@ static struct platform_driver hisi_ddrc_pmu_driver = {
 	.driver = {
 		.name = "hisi_ddrc_pmu",
 		.acpi_match_table = ACPI_PTR(hisi_ddrc_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = hisi_ddrc_pmu_probe,
 	.remove = hisi_ddrc_pmu_remove,
diff --git a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
index a4004dad6bf1c..78865b4ac4a6f 100644
--- a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
@@ -431,6 +431,7 @@ static struct platform_driver hisi_hha_pmu_driver = {
 	.driver = {
 		.name = "hisi_hha_pmu",
 		.acpi_match_table = ACPI_PTR(hisi_hha_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = hisi_hha_pmu_probe,
 	.remove = hisi_hha_pmu_remove,
diff --git a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
index 2f3f291b0c2ed..9dd50c3bc74ec 100644
--- a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
@@ -421,6 +421,7 @@ static struct platform_driver hisi_l3c_pmu_driver = {
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
index 43d76c85da56b..9e1c3c7eeba9b 100644
--- a/drivers/perf/thunderx2_pmu.c
+++ b/drivers/perf/thunderx2_pmu.c
@@ -816,6 +816,7 @@ static struct platform_driver tx2_uncore_driver = {
 	.driver = {
 		.name		= "tx2-uncore-pmu",
 		.acpi_match_table = ACPI_PTR(tx2_uncore_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = tx2_uncore_probe,
 	.remove = tx2_uncore_remove,
diff --git a/drivers/perf/xgene_pmu.c b/drivers/perf/xgene_pmu.c
index 7e328d6385c37..328aea9f6be32 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1981,6 +1981,7 @@ static struct platform_driver xgene_pmu_driver = {
 		.name		= "xgene-pmu",
 		.of_match_table = xgene_pmu_of_match,
 		.acpi_match_table = ACPI_PTR(xgene_pmu_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 };
 
-- 
2.25.1



