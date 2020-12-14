Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9406A2D9F05
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408806AbgLNS3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502296AbgLNRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenbin Mei <wenbin.mei@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 078/105] mmc: mediatek: Fix system suspend/resume support for CQHCI
Date:   Mon, 14 Dec 2020 18:28:52 +0100
Message-Id: <20201214172559.026817819@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenbin Mei <wenbin.mei@mediatek.com>

commit c0a2074ac575fff2848c8ef804bdc8590466c36c upstream.

Before we got these errors on MT8192 platform:
[   59.153891] Restarting tasks ...
[   59.154540] done.
[   59.159175] PM: suspend exit
[   59.218724] mtk-msdc 11f60000.mmc: phase: [map:fffffffe] [maxlen:31]
[final:16]
[  119.776083] mmc0: cqhci: timeout for tag 9
[  119.780196] mmc0: cqhci: ============ CQHCI REGISTER DUMP ===========
[  119.786709] mmc0: cqhci: Caps:      0x100020b6 | Version:  0x00000510
[  119.793225] mmc0: cqhci: Config:    0x00000101 | Control:  0x00000000
[  119.799706] mmc0: cqhci: Int stat:  0x00000000 | Int enab: 0x00000000
[  119.806177] mmc0: cqhci: Int sig:   0x00000000 | Int Coal: 0x00000000
[  119.812670] mmc0: cqhci: TDL base:  0x00000000 | TDL up32: 0x00000000
[  119.819149] mmc0: cqhci: Doorbell:  0x003ffc00 | TCN:      0x00000200
[  119.825656] mmc0: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x00000000
[  119.832155] mmc0: cqhci: Task clr:  0x00000000 | SSC1:     0x00001000
[  119.838627] mmc0: cqhci: SSC2:      0x00000000 | DCMD rsp: 0x00000000
[  119.845174] mmc0: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x0000891c
[  119.851654] mmc0: cqhci: Resp idx:  0x00000000 | Resp arg: 0x00000000
[  119.865773] mmc0: cqhci: : ===========================================
[  119.872358] mmc0: running CQE recovery
>From these logs, we found TDL base was back to the default value.

After suspend, the mmc host is powered off by HW, and bring CQE register
to the default value, so we add system suspend/resume interface, then bring
CQE to deactivated state before suspend, it will be enabled by CQE first
request after resume.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Link: https://lore.kernel.org/r/20201118063405.24906-1-wenbin.mei@mediatek.com
Fixes: 88bd652b3c74 ("mmc: mediatek: command queue support")
Cc: stable@vger.kernel.org
[Ulf: Renamed functions]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mtk-sd.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2654,11 +2654,29 @@ static int msdc_runtime_resume(struct de
 	msdc_restore_reg(host);
 	return 0;
 }
+
+static int msdc_suspend(struct device *dev)
+{
+	struct mmc_host *mmc = dev_get_drvdata(dev);
+	int ret;
+
+	if (mmc->caps2 & MMC_CAP2_CQE) {
+		ret = cqhci_suspend(mmc);
+		if (ret)
+			return ret;
+	}
+
+	return pm_runtime_force_suspend(dev);
+}
+
+static int msdc_resume(struct device *dev)
+{
+	return pm_runtime_force_resume(dev);
+}
 #endif
 
 static const struct dev_pm_ops msdc_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(msdc_suspend, msdc_resume)
 	SET_RUNTIME_PM_OPS(msdc_runtime_suspend, msdc_runtime_resume, NULL)
 };
 


