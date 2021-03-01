Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BFD3285F7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhCARCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235696AbhCAQz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4402E64FCD;
        Mon,  1 Mar 2021 16:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616533;
        bh=smJ0oBMpc+/FR3INACWSa14DTOG+Y1caP9vWG3WBNac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2zxrf56O9A2S2Y8bgQ6QZ0KnPVxstsWlnM8JxDHCThVzYOiteFMPS2GqIwTaNZRL
         HQx0AuUzy5RVTMNYVPV0BAFMafTRRXRb9Pr9r5vhp8/7Q9Uf2E/qWVqnsNyy14cRJl
         fQkRByfEscGLlvh9YPOrqxx6F72v2/EzD04tpIUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Li <Frank.Li@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 158/176] mmc: sdhci-esdhc-imx: fix kernel panic when remove module
Date:   Mon,  1 Mar 2021 17:13:51 +0100
Message-Id: <20210301161028.870787430@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1354,9 +1354,10 @@ static int sdhci_esdhc_imx_remove(struct
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
-	int dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
+	int dead;
 
 	pm_runtime_get_sync(&pdev->dev);
+	dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 


