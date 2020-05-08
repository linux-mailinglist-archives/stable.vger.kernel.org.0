Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806421CAB56
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgEHMmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbgEHMmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC4C20731;
        Fri,  8 May 2020 12:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941763;
        bh=N6tgcCmjKommlTOdB0+TcOZQUmd0Q+Q3VC4OrUfwSb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzTccYJvqT+YNwfH7aESKhpvrhZ2Xli64w5Cup/rSV/y/WzQfNZKC/XINP2vPqQt9
         C+0dXAwdjTXK1s4jeVIiPME9wofQliAleD/Yf2MjM1epwhEBdPBfmGG8sI+0qg3taC
         1R2OMh5Nnf0WEPVbcPIjqOCYiseUYoaRKUoAj9Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jisheng Zhang <jszhang@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 145/312] mmc: sdhci: Fix regression setting power on Trats2 board
Date:   Fri,  8 May 2020 14:32:16 +0200
Message-Id: <20200508123134.662386181@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 1dceb0415aa0c6bc11dacdab47c9ef83a3604166 upstream.

Several commits relating to setting power have been introducing
problems by putting driver-specific rules into generic SDHCI code.

Krzysztof Kozlowski reported that after commit 918f4cbd4340 ("mmc:
sdhci: restore behavior when setting VDD via external regulator")
on Trats2 board there are warnings for invalid VDD  value (2.8V):

[    3.119656] ------------[ cut here ]------------
[    3.119666] WARNING: CPU: 3 PID: 90 at
../drivers/mmc/host/sdhci.c:1234 sdhci_do_set_ios+0x4cc/0x5e0
[    3.119669] mmc0: Invalid vdd 0x10
[    3.119673] Modules linked in:
[    3.119679] CPU: 3 PID: 90 Comm: kworker/3:1 Tainted: G        W
   4.5.0-next-20160324 #23
[    3.119681] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[    3.119690] Workqueue: events_freezable mmc_rescan
[    3.119708] [<c010e0ac>] (unwind_backtrace) from [<c010ae10>]
(show_stack+0x10/0x14)
[    3.119719] [<c010ae10>] (show_stack) from [<c0323260>]
(dump_stack+0x88/0x9c)
[    3.119728] [<c0323260>] (dump_stack) from [<c011b754>] (__warn+0xe8/0x100)
[    3.119734] [<c011b754>] (__warn) from [<c011b7a4>]
(warn_slowpath_fmt+0x38/0x48)
[    3.119740] [<c011b7a4>] (warn_slowpath_fmt) from [<c0527d28>]
(sdhci_do_set_ios+0x4cc/0x5e0)
[    3.119748] [<c0527d28>] (sdhci_do_set_ios) from [<c0528018>]
(sdhci_runtime_resume_host+0x60/0x114)
[    3.119758] [<c0528018>] (sdhci_runtime_resume_host) from
[<c0402570>] (__rpm_callback+0x2c/0x60)
[    3.119767] [<c0402570>] (__rpm_callback) from [<c04025c4>]
(rpm_callback+0x20/0x80)
[    3.119773] [<c04025c4>] (rpm_callback) from [<c04034b8>]
(rpm_resume+0x36c/0x558)
[    3.119780] [<c04034b8>] (rpm_resume) from [<c04036f0>]
(__pm_runtime_resume+0x4c/0x64)
[    3.119788] [<c04036f0>] (__pm_runtime_resume) from [<c0512728>]
(__mmc_claim_host+0x170/0x1b0)
[    3.119795] [<c0512728>] (__mmc_claim_host) from [<c0514e2c>]
(mmc_rescan+0x54/0x348)
[    3.119807] [<c0514e2c>] (mmc_rescan) from [<c0130dac>]
(process_one_work+0x120/0x3f4)
[    3.119815] [<c0130dac>] (process_one_work) from [<c01310b8>]
(worker_thread+0x38/0x554)
[    3.119823] [<c01310b8>] (worker_thread) from [<c01365a4>]
(kthread+0xdc/0xf4)
[    3.119831] [<c01365a4>] (kthread) from [<c0107878>]
(ret_from_fork+0x14/0x3c)
[    3.119834] ---[ end trace a22d652aa3276886 ]---

Fix by adding a 'set_power' callback and restoring the default
behaviour prior to commit 918f4cbd4340 ("mmc: sdhci: restore
behavior when setting VDD via external regulator").  The desired
behaviour of that commit is gotten by having sdhci-pxav3 provide
its own set_power callback.

Reported-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Link: http://lkml.kernel.org/r/CAJKOXPcGDnPm-Ykh6wHqV1YxfTaov5E8iVqBoBn4OJc7BnhgEQ@mail.gmail.com
Fixes: 918f4cbd4340 ("mmc: sdhci: restore behavior when setting VDD...)
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org # v4.5+
Reviewed-by: Jisheng Zhang <jszhang@marvell.com>
Tested-by: Jisheng Zhang <jszhang@marvell.com>
Tested-by: Jaehoon Chung <jh80.chung@samsung.com>
Tested-by: Anand Moon <linux.amoon@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pxav3.c |   22 ++++++++++++++++++++++
 drivers/mmc/host/sdhci.c       |   39 ++++++++++++++++++++++++++++++---------
 drivers/mmc/host/sdhci.h       |    4 ++++
 3 files changed, 56 insertions(+), 9 deletions(-)

--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -307,8 +307,30 @@ static void pxav3_set_uhs_signaling(stru
 		__func__, uhs, ctrl_2);
 }
 
+static void pxav3_set_power(struct sdhci_host *host, unsigned char mode,
+			    unsigned short vdd)
+{
+	struct mmc_host *mmc = host->mmc;
+	u8 pwr = host->pwr;
+
+	sdhci_set_power(host, mode, vdd);
+
+	if (host->pwr == pwr)
+		return;
+
+	if (host->pwr == 0)
+		vdd = 0;
+
+	if (!IS_ERR(mmc->supply.vmmc)) {
+		spin_unlock_irq(&host->lock);
+		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
+		spin_lock_irq(&host->lock);
+	}
+}
+
 static const struct sdhci_ops pxav3_sdhci_ops = {
 	.set_clock = sdhci_set_clock,
+	.set_power = pxav3_set_power,
 	.platform_send_init_74_clocks = pxav3_gen_init_74_clocks,
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
 	.set_bus_width = sdhci_set_bus_width,
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1284,10 +1284,24 @@ clock_set:
 }
 EXPORT_SYMBOL_GPL(sdhci_set_clock);
 
-static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
-			    unsigned short vdd)
+static void sdhci_set_power_reg(struct sdhci_host *host, unsigned char mode,
+				unsigned short vdd)
 {
 	struct mmc_host *mmc = host->mmc;
+
+	spin_unlock_irq(&host->lock);
+	mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
+	spin_lock_irq(&host->lock);
+
+	if (mode != MMC_POWER_OFF)
+		sdhci_writeb(host, SDHCI_POWER_ON, SDHCI_POWER_CONTROL);
+	else
+		sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
+}
+
+void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
+		     unsigned short vdd)
+{
 	u8 pwr = 0;
 
 	if (mode != MMC_POWER_OFF) {
@@ -1319,7 +1333,6 @@ static void sdhci_set_power(struct sdhci
 		sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
 		if (host->quirks2 & SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON)
 			sdhci_runtime_pm_bus_off(host);
-		vdd = 0;
 	} else {
 		/*
 		 * Spec says that we should clear the power reg before setting
@@ -1350,12 +1363,20 @@ static void sdhci_set_power(struct sdhci
 		if (host->quirks & SDHCI_QUIRK_DELAY_AFTER_POWER)
 			mdelay(10);
 	}
+}
+EXPORT_SYMBOL_GPL(sdhci_set_power);
 
-	if (!IS_ERR(mmc->supply.vmmc)) {
-		spin_unlock_irq(&host->lock);
-		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
-		spin_lock_irq(&host->lock);
-	}
+static void __sdhci_set_power(struct sdhci_host *host, unsigned char mode,
+			      unsigned short vdd)
+{
+	struct mmc_host *mmc = host->mmc;
+
+	if (host->ops->set_power)
+		host->ops->set_power(host, mode, vdd);
+	else if (!IS_ERR(mmc->supply.vmmc))
+		sdhci_set_power_reg(host, mode, vdd);
+	else
+		sdhci_set_power(host, mode, vdd);
 }
 
 /*****************************************************************************\
@@ -1505,7 +1526,7 @@ static void sdhci_do_set_ios(struct sdhc
 		}
 	}
 
-	sdhci_set_power(host, ios->power_mode, ios->vdd);
+	__sdhci_set_power(host, ios->power_mode, ios->vdd);
 
 	if (host->ops->platform_send_init_74_clocks)
 		host->ops->platform_send_init_74_clocks(host, ios->power_mode);
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -529,6 +529,8 @@ struct sdhci_ops {
 #endif
 
 	void	(*set_clock)(struct sdhci_host *host, unsigned int clock);
+	void	(*set_power)(struct sdhci_host *host, unsigned char mode,
+			     unsigned short vdd);
 
 	int		(*enable_dma)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
@@ -660,6 +662,8 @@ static inline bool sdhci_sdio_irq_enable
 }
 
 void sdhci_set_clock(struct sdhci_host *host, unsigned int clock);
+void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
+		     unsigned short vdd);
 void sdhci_set_bus_width(struct sdhci_host *host, int width);
 void sdhci_reset(struct sdhci_host *host, u8 mask);
 void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing);


