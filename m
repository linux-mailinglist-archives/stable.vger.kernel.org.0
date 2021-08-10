Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D6E3E80D7
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhHJRxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234919AbhHJRux (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99FDE6128B;
        Tue, 10 Aug 2021 17:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617374;
        bh=Fag6D66siujgCk6NxA1m/fyPbXy77UlF9MvHbsDywGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cn5aorpuQFA9Cn/wzCyt67HNsKHmY2qaH/Wze19liXpd/UWsebekD681kMmbtmwPU
         oOC5ZDQ8ctaUfTwfygc9isHXzy/AXhz3xjhJIIvXL0lBBKM1pv5CoLa8XwlX1loIYx
         yFo35uL0hO9piDal0Ybj6TNIotbX7iCpIRR8usYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 009/175] ARM: imx: add missing clk_disable_unprepare()
Date:   Tue, 10 Aug 2021 19:28:37 +0200
Message-Id: <20210810173001.250667602@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f07ec85365807b3939f32d0094a6dd5ce065d1b9 ]

clock source is prepared and enabled by clk_prepare_enable()
in probe function, but no disable or unprepare in remove and
error path.

Fixes: 9454a0caff6a ("ARM: imx: add mmdc ipg clock operation for mmdc")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mmdc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index 8e57691aafe2..4a6f1359e1e9 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -103,6 +103,7 @@ struct mmdc_pmu {
 	struct perf_event *mmdc_events[MMDC_NUM_COUNTERS];
 	struct hlist_node node;
 	struct fsl_mmdc_devtype_data *devtype_data;
+	struct clk *mmdc_ipg_clk;
 };
 
 /*
@@ -463,11 +464,13 @@ static int imx_mmdc_remove(struct platform_device *pdev)
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	perf_pmu_unregister(&pmu_mmdc->pmu);
 	iounmap(pmu_mmdc->mmdc_base);
+	clk_disable_unprepare(pmu_mmdc->mmdc_ipg_clk);
 	kfree(pmu_mmdc);
 	return 0;
 }
 
-static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_base)
+static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_base,
+			      struct clk *mmdc_ipg_clk)
 {
 	struct mmdc_pmu *pmu_mmdc;
 	char *name;
@@ -495,6 +498,7 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 	}
 
 	mmdc_num = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
+	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
 	if (mmdc_num == 0)
 		name = "mmdc";
 	else
@@ -568,9 +572,11 @@ static int imx_mmdc_probe(struct platform_device *pdev)
 	val &= ~(1 << BP_MMDC_MAPSR_PSD);
 	writel_relaxed(val, reg);
 
-	err = imx_mmdc_perf_init(pdev, mmdc_base);
-	if (err)
+	err = imx_mmdc_perf_init(pdev, mmdc_base, mmdc_ipg_clk);
+	if (err) {
 		iounmap(mmdc_base);
+		clk_disable_unprepare(mmdc_ipg_clk);
+	}
 
 	return err;
 }
-- 
2.30.2



