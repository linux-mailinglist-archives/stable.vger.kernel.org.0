Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61BC22F192
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbgG0OQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730972AbgG0OQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 742CD20FC3;
        Mon, 27 Jul 2020 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859417;
        bh=GQOqnqSzSP8PmRxQJU8Ag/AtG2V5L5qrXRDvzyO2dO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eh/NtgoIygz2Oz5TaB32fi5kkNVGqQv0avv6q8cCy/KSt9vmlXn3X3y7uPqEGZ9qO
         VkENZNL/pZY4+yC6RfEVD78XigushGYnMTtcG61pbe/8KnJZj6iYm28LPe9OnxnbvX
         eFiSeCsmArsvo8HritwqwI8jnG8QMgbc2L1wz9Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haifeng Wang <wang.wanghaifeng@huawei.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/138] drivers/perf: Fix kernel panic when rmmod PMU modules during perf sampling
Date:   Mon, 27 Jul 2020 16:04:53 +0200
Message-Id: <20200727134930.269668968@linuxfoundation.org>
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

[ Upstream commit bdc5c744c7b6457d18a95c26769dad0e7f480a08 ]

When users try to remove PMU modules during perf sampling, kernel panic
will happen because the pmu->read() is a NULL pointer here.

INFO on HiSilicon hip08 platform as follow:
pc : hisi_uncore_pmu_event_update+0x30/0xa4 [hisi_uncore_pmu]
lr : hisi_uncore_pmu_read+0x20/0x2c [hisi_uncore_pmu]
sp : ffff800010103e90
x29: ffff800010103e90 x28: ffff0027db0c0e40
x27: ffffa29a76f129d8 x26: ffffa29a77ceb000
x25: ffffa29a773a5000 x24: ffffa29a77392000
x23: ffffddffe5943f08 x22: ffff002784285960
x21: ffff002784285800 x20: ffff0027d2e76c80
x19: ffff0027842859e0 x18: ffff80003498bcc8
x17: ffffa29a76afe910 x16: ffffa29a7583f530
x15: 16151a1512061a1e x14: 0000000000000000
x13: ffffa29a76f1e238 x12: 0000000000000001
x11: 0000000000000400 x10: 00000000000009f0
x9 : ffff8000107b3e70 x8 : ffff0027db0c1890
x7 : ffffa29a773a7000 x6 : 00000007f5131013
x5 : 00000007f5131013 x4 : 09f257d417c00000
x3 : 00000002187bd7ce x2 : ffffa29a38f0f0d8
x1 : ffffa29a38eae268 x0 : ffff0027d2e76c80
Call trace:
hisi_uncore_pmu_event_update+0x30/0xa4 [hisi_uncore_pmu]
hisi_uncore_pmu_read+0x20/0x2c [hisi_uncore_pmu]
__perf_event_read+0x1a0/0x1f8
flush_smp_call_function_queue+0xa0/0x160
generic_smp_call_function_single_interrupt+0x18/0x20
handle_IPI+0x31c/0x4dc
gic_handle_irq+0x2c8/0x310
el1_irq+0xcc/0x180
arch_cpu_idle+0x4c/0x20c
default_idle_call+0x20/0x30
do_idle+0x1b4/0x270
cpu_startup_entry+0x28/0x30
secondary_start_kernel+0x1a4/0x1fc

To solve the above issue, current module should be registered to kernel,
so that try_module_get() can be invoked when perf sampling starts. This
adds the reference counting of module and could prevent users from removing
modules during sampling.

Reported-by: Haifeng Wang <wang.wanghaifeng@huawei.com>
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1594891165-8228-1-git-send-email-liuqi115@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_smmuv3_pmu.c                 | 1 +
 drivers/perf/fsl_imx8_ddr_perf.c              | 1 +
 drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c | 1 +
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c  | 1 +
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index 3269232ff5708..f8fc1b612119c 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -742,6 +742,7 @@ static int smmu_pmu_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, smmu_pmu);
 
 	smmu_pmu->pmu = (struct pmu) {
+		.module		= THIS_MODULE,
 		.task_ctx_nr    = perf_invalid_context,
 		.pmu_enable	= smmu_pmu_enable,
 		.pmu_disable	= smmu_pmu_disable,
diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 6eef47de8fccc..b241db6929c08 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -451,6 +451,7 @@ static int ddr_perf_init(struct ddr_pmu *pmu, void __iomem *base,
 {
 	*pmu = (struct ddr_pmu) {
 		.pmu = (struct pmu) {
+			.module	      = THIS_MODULE,
 			.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
 			.task_ctx_nr = perf_invalid_context,
 			.attr_groups = attr_groups,
diff --git a/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c b/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
index e42d4464c2cf7..64712cf2f99ad 100644
--- a/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c
@@ -381,6 +381,7 @@ static int hisi_ddrc_pmu_probe(struct platform_device *pdev)
 			      ddrc_pmu->sccl_id, ddrc_pmu->index_id);
 	ddrc_pmu->pmu = (struct pmu) {
 		.name		= name,
+		.module		= THIS_MODULE,
 		.task_ctx_nr	= perf_invalid_context,
 		.event_init	= hisi_uncore_pmu_event_init,
 		.pmu_enable	= hisi_uncore_pmu_enable,
diff --git a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
index 0d6325d6a4ec3..a4004dad6bf1c 100644
--- a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
@@ -392,6 +392,7 @@ static int hisi_hha_pmu_probe(struct platform_device *pdev)
 			      hha_pmu->sccl_id, hha_pmu->index_id);
 	hha_pmu->pmu = (struct pmu) {
 		.name		= name,
+		.module		= THIS_MODULE,
 		.task_ctx_nr	= perf_invalid_context,
 		.event_init	= hisi_uncore_pmu_event_init,
 		.pmu_enable	= hisi_uncore_pmu_enable,
diff --git a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
index c5b0950c2a7a9..2f3f291b0c2ed 100644
--- a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
@@ -382,6 +382,7 @@ static int hisi_l3c_pmu_probe(struct platform_device *pdev)
 			      l3c_pmu->sccl_id, l3c_pmu->index_id);
 	l3c_pmu->pmu = (struct pmu) {
 		.name		= name,
+		.module		= THIS_MODULE,
 		.task_ctx_nr	= perf_invalid_context,
 		.event_init	= hisi_uncore_pmu_event_init,
 		.pmu_enable	= hisi_uncore_pmu_enable,
-- 
2.25.1



