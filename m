Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477FC411EBD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351474AbhITReH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351091AbhITRb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62FF261AFB;
        Mon, 20 Sep 2021 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157487;
        bh=u3G2+wE8jvGBW5pRzEhw4L/f/tH+xhEcUtvq/o0GaEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4ax0h4ykJrH9+Cz6mjeFQZ4QTJxbg4XBabRZp5kiQKgSYXm5tUa5f8gF8ofdKFvj
         GdhtyHEXuzRKnVyKjdrUQc4jM9jwv4o3DWQjUSOZiqGXC9OwY3xVktrx3U80kwzeQF
         shPSeHsYLqavXrxcMKRB9GiHnlmZwsnBP+XhzJPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 014/293] ARM: imx: add missing clk_disable_unprepare()
Date:   Mon, 20 Sep 2021 18:39:36 +0200
Message-Id: <20210920163933.750415521@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit f07ec85365807b3939f32d0094a6dd5ce065d1b9 upstream.

clock source is prepared and enabled by clk_prepare_enable()
in probe function, but no disable or unprepare in remove and
error path.

Fixes: 9454a0caff6a ("ARM: imx: add mmdc ipg clock operation for mmdc")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-imx/mmdc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -109,6 +109,7 @@ struct mmdc_pmu {
 	struct perf_event *mmdc_events[MMDC_NUM_COUNTERS];
 	struct hlist_node node;
 	struct fsl_mmdc_devtype_data *devtype_data;
+	struct clk *mmdc_ipg_clk;
 };
 
 /*
@@ -474,11 +475,13 @@ static int imx_mmdc_remove(struct platfo
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
@@ -506,6 +509,7 @@ static int imx_mmdc_perf_init(struct pla
 	}
 
 	mmdc_num = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
+	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
 	if (mmdc_num == 0)
 		name = "mmdc";
 	else
@@ -579,9 +583,11 @@ static int imx_mmdc_probe(struct platfor
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


