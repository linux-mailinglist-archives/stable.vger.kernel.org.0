Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E383E4AC2
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhHIRYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 13:24:51 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:35382 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbhHIRYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 13:24:51 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 179HONPs024807; Tue, 10 Aug 2021 02:24:23 +0900
X-Iguazu-Qid: 2wHHa7GsNc511Z90d6
X-Iguazu-QSIG: v=2; s=0; t=1628529863; q=2wHHa7GsNc511Z90d6; m=IO4iH5NlJ0VxWh408Hnd5ijvCzFGqeycigYbbDNXyyg=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1113) id 179HOMwt020075
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Aug 2021 02:24:23 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id ABFBA1000D3;
        Tue, 10 Aug 2021 02:24:22 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 179HOMIK024596;
        Tue, 10 Aug 2021 02:24:22 +0900
Date:   Tue, 10 Aug 2021 02:24:21 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     sashal@kernel.org, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [stable-rc/4.19.y] Build fails with commit 6642eb4eb918 ("ARM: imx:
 add missing iounmap()")
X-TSB-HOP: ON
Message-ID: <20210809172421.wcrije6p7qyy55jj@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gi4teefrtfutjitb"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gi4teefrtfutjitb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Build failed commit 6642eb4eb918 ("ARM: imx: add missing iounmap()") on
stable-rc/linux-4.19.y.

````
arch/arm/mach-imx/mmdc.c: In function 'imx_mmdc_probe':
arch/arm/mach-imx/mmdc.c:568:2: error: 'err' undeclared (first use in this function)
  err = imx_mmdc_perf_init(pdev, mmdc_base);
  ^~~
arch/arm/mach-imx/mmdc.c:568:2: note: each undeclared identifier is reported only once for each function it appears in
arch/arm/mach-imx/mmdc.c:573:1: error: control reaches end of non-void function [-Werror=return-type]
 }
 ^
cc1: some warnings being treated as errors
make[1]: *** [scripts/Makefile.build:303: arch/arm/mach-imx/mmdc.o] Error 1

````

It seems that err has not been declared.
I attached a patch which revise this issue.

Best regards,
  Nobuhiro


--gi4teefrtfutjitb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ARM-imx-add-missing-iounmap.patch"

From 1409564e80bd0b769528a21b47fc13cfcd6bbb20 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 15 Jun 2021 20:52:38 +0800
Subject: [PATCH] ARM: imx: add missing iounmap()

[ Upstream commit f9613aa07f16d6042e74208d1b40a6104d72964a ]

Commit e76bdfd7403a ("ARM: imx: Added perf functionality to mmdc driver")
introduced imx_mmdc_remove(), the mmdc_base need be unmapped in it if
config PERF_EVENTS is enabled.

If imx_mmdc_perf_init() fails, the mmdc_base also need be unmapped.

Fixes: e76bdfd7403a ("ARM: imx: Added perf functionality to mmdc driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[iwamatsu: Add err variable]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 arch/arm/mach-imx/mmdc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index 04b3bf71de94ba..9c5aed9292246a 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -472,6 +472,7 @@ static int imx_mmdc_remove(struct platform_device *pdev)
 
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	perf_pmu_unregister(&pmu_mmdc->pmu);
+	iounmap(pmu_mmdc->mmdc_base);
 	kfree(pmu_mmdc);
 	return 0;
 }
@@ -547,6 +548,7 @@ static int imx_mmdc_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	void __iomem *mmdc_base, *reg;
 	u32 val;
+	int err;
 
 	mmdc_base = of_iomap(np, 0);
 	WARN_ON(!mmdc_base);
@@ -564,7 +566,11 @@ static int imx_mmdc_probe(struct platform_device *pdev)
 	val &= ~(1 << BP_MMDC_MAPSR_PSD);
 	writel_relaxed(val, reg);
 
-	return imx_mmdc_perf_init(pdev, mmdc_base);
+	err = imx_mmdc_perf_init(pdev, mmdc_base);
+	if (err)
+		iounmap(mmdc_base);
+
+	return err;
 }
 
 int imx_mmdc_get_ddr_type(void)
-- 
2.32.0


--gi4teefrtfutjitb--

