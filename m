Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52F132B099
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344941AbhCCAy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:26 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:51836 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361117AbhCBXZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 18:25:43 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 122NNam5022579; Wed, 3 Mar 2021 08:23:36 +0900
X-Iguazu-Qid: 34tKUV8MjDkHI6kFWM
X-Iguazu-QSIG: v=2; s=0; t=1614727416; q=34tKUV8MjDkHI6kFWM; m=q3wjuYAuFpHwxyfcvClT74k26hY+7LW+AghKYqBB5tg=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1513) id 122NNZnA030250
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 3 Mar 2021 08:23:35 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id BD78E1000EF;
        Wed,  3 Mar 2021 08:23:35 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 122NNZhZ013528;
        Wed, 3 Mar 2021 08:23:35 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Frank Li <Frank.Li@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4] mmc: sdhci-esdhc-imx: fix kernel panic when remove module
Date:   Wed,  3 Mar 2021 08:23:21 +0900
X-TSB-HOP: ON
Message-Id: <20210302232321.854084-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Li <Frank.Li@nxp.com>

commit a56f44138a2c57047f1ea94ea121af31c595132b upstream.

In sdhci_esdhc_imx_remove() the SDHCI_INT_STATUS in read. Under some
circumstances, this may be done while the device is runtime suspended,
triggering the below splat.

Fix the problem by adding a pm_runtime_get_sync(), before reading the
register, which will turn on clocks etc making the device accessible again.

[ 1811.323148] mmc1: card aaaa removed
[ 1811.347483] Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
[ 1811.354988] Modules linked in: sdhci_esdhc_imx(-) sdhci_pltfm sdhci cqhci mmc_block mmc_core [last unloaded: mmc_core]
[ 1811.365726] CPU: 0 PID: 3464 Comm: rmmod Not tainted 5.10.1-sd-99871-g53835a2e8186 #5
[ 1811.373559] Hardware name: Freescale i.MX8DXL EVK (DT)
[ 1811.378705] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[ 1811.384723] pc : sdhci_esdhc_imx_remove+0x28/0x15c [sdhci_esdhc_imx]
[ 1811.391090] lr : platform_drv_remove+0x2c/0x50
[ 1811.395536] sp : ffff800012c7bcb0
[ 1811.398855] x29: ffff800012c7bcb0 x28: ffff00002c72b900
[ 1811.404181] x27: 0000000000000000 x26: 0000000000000000
[ 1811.409497] x25: 0000000000000000 x24: 0000000000000000
[ 1811.414814] x23: ffff0000042b3890 x22: ffff800009127120
[ 1811.420131] x21: ffff00002c4c9580 x20: ffff0000042d0810
[ 1811.425456] x19: ffff0000042d0800 x18: 0000000000000020
[ 1811.430773] x17: 0000000000000000 x16: 0000000000000000
[ 1811.436089] x15: 0000000000000004 x14: ffff000004019c10
[ 1811.441406] x13: 0000000000000000 x12: 0000000000000020
[ 1811.446723] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
[ 1811.452040] x9 : fefefeff6364626d x8 : 7f7f7f7f7f7f7f7f
[ 1811.457356] x7 : 78725e6473607372 x6 : 0000000080808080
[ 1811.462673] x5 : 0000000000000000 x4 : 0000000000000000
[ 1811.467990] x3 : ffff800011ac1cb0 x2 : 0000000000000000
[ 1811.473307] x1 : ffff8000091214d4 x0 : ffff8000133a0030
[ 1811.478624] Call trace:
[ 1811.481081]  sdhci_esdhc_imx_remove+0x28/0x15c [sdhci_esdhc_imx]
[ 1811.487098]  platform_drv_remove+0x2c/0x50
[ 1811.491198]  __device_release_driver+0x188/0x230
[ 1811.495818]  driver_detach+0xc0/0x14c
[ 1811.499487]  bus_remove_driver+0x5c/0xb0
[ 1811.503413]  driver_unregister+0x30/0x60
[ 1811.507341]  platform_driver_unregister+0x14/0x20
[ 1811.512048]  sdhci_esdhc_imx_driver_exit+0x1c/0x3a8 [sdhci_esdhc_imx]
[ 1811.518495]  __arm64_sys_delete_module+0x19c/0x230
[ 1811.523291]  el0_svc_common.constprop.0+0x78/0x1a0
[ 1811.528086]  do_el0_svc+0x24/0x90
[ 1811.531405]  el0_svc+0x14/0x20
[ 1811.534461]  el0_sync_handler+0x1a4/0x1b0
[ 1811.538474]  el0_sync+0x174/0x180
[ 1811.541801] Code: a9025bf5 f9403e95 f9400ea0 9100c000 (b9400000)
[ 1811.547902] ---[ end trace 3fb1a3bd48ff7be5 ]---

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org # v4.0+
Link: https://lore.kernel.org/r/20210210181933.29263-1-Frank.Li@nxp.com
[Ulf: Clarified the commit message a bit]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[iwamatsu: adjust context]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 8d838779fd1bcd..b95d911ef497b4 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1240,9 +1240,10 @@ static int sdhci_esdhc_imx_remove(struct platform_device *pdev)
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = pltfm_host->priv;
-	int dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
+	int dead;
 
 	pm_runtime_get_sync(&pdev->dev);
+	dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 
-- 
2.30.0

