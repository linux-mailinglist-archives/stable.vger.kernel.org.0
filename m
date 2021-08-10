Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A306A3E7FB3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhHJRmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232755AbhHJRkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B840660F41;
        Tue, 10 Aug 2021 17:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617081;
        bh=/qj3ROmv9sS7iWFoTfgK8dGOGy/KKWHecO55OPEVgds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INNhdtc01Udy7IUz+Yl0G+pOGg7VMjOB1IuRNWtz29HsF6sYCiOp4kb30FmU94KwE
         WMhTvpoAIur6jLdW2FQf5P9WUw1jPriu3/QNp1cUMDn/CLmhLJKH6/NGeoUYPXcn37
         2QYil1J0yf/fgxN+qhQaAmDUYRSMpWSz7TOe70fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/135] ARM: imx: add missing iounmap()
Date:   Tue, 10 Aug 2021 19:29:00 +0200
Message-Id: <20210810172955.889629130@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

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
---
 arch/arm/mach-imx/mmdc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index 0dfd0ae7a63d..8e57691aafe2 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -462,6 +462,7 @@ static int imx_mmdc_remove(struct platform_device *pdev)
 
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	perf_pmu_unregister(&pmu_mmdc->pmu);
+	iounmap(pmu_mmdc->mmdc_base);
 	kfree(pmu_mmdc);
 	return 0;
 }
@@ -567,7 +568,11 @@ static int imx_mmdc_probe(struct platform_device *pdev)
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
2.30.2



