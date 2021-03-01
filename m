Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1163291BF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243382AbhCAUcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242489AbhCAUZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEE106540F;
        Mon,  1 Mar 2021 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621974;
        bh=JUnO/GnhXr0F5Kh2N1zUw2QEMreqFEMEf1hOYK+S6yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2L7A3U5oRcuOmAJvwTchY7aaTe0HfAUc/QK/xZFxJRJ/20kpnxJeAJa76M/7HB8eZ
         NfHVYE/goqixopeEmdxTUBaVYfOwlr+z7DuNjqBvJhc1/a3zMhtNta8DlnvrErgKZn
         7Kr3zkTCKtGJvPGQaiLaNSNY8Nlt9WAFCOquiiKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirley Her <shirley.her@bayhubtech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.11 711/775] mmc: sdhci-pci-o2micro: Bug fix for SDR104 HW tuning failure
Date:   Mon,  1 Mar 2021 17:14:39 +0100
Message-Id: <20210301161236.482051595@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirley Her <shirley.her@bayhubtech.com>

commit 1ad9f88014ae1d5abccb6fe930bc4c5c311bdc05 upstream.

Force chip enter L0 power state during SDR104 HW tuning to avoid tuning failure

Signed-off-by: Shirley Her <shirley.her@bayhubtech.com>
Link: https://lore.kernel.org/r/20210206014051.3418-1-shirley.her@bayhubtech.com
Fixes: 7b7d897e8898 ("mmc: sdhci-pci-o2micro: Add HW tuning for SDR104 mode")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-o2micro.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -33,6 +33,8 @@
 #define O2_SD_ADMA2		0xE7
 #define O2_SD_INF_MOD		0xF1
 #define O2_SD_MISC_CTRL4	0xFC
+#define O2_SD_MISC_CTRL		0x1C0
+#define O2_SD_PWR_FORCE_L0	0x0002
 #define O2_SD_TUNING_CTRL	0x300
 #define O2_SD_PLL_SETTING	0x304
 #define O2_SD_MISC_SETTING	0x308
@@ -300,6 +302,8 @@ static int sdhci_o2_execute_tuning(struc
 {
 	struct sdhci_host *host = mmc_priv(mmc);
 	int current_bus_width = 0;
+	u32 scratch32 = 0;
+	u16 scratch = 0;
 
 	/*
 	 * This handler only implements the eMMC tuning that is specific to
@@ -312,6 +316,17 @@ static int sdhci_o2_execute_tuning(struc
 	if (WARN_ON((opcode != MMC_SEND_TUNING_BLOCK_HS200) &&
 			(opcode != MMC_SEND_TUNING_BLOCK)))
 		return -EINVAL;
+
+	/* Force power mode enter L0 */
+	scratch = sdhci_readw(host, O2_SD_MISC_CTRL);
+	scratch |= O2_SD_PWR_FORCE_L0;
+	sdhci_writew(host, scratch, O2_SD_MISC_CTRL);
+
+	/* wait DLL lock, timeout value 5ms */
+	if (readx_poll_timeout(sdhci_o2_pll_dll_wdt_control, host,
+		scratch32, (scratch32 & O2_DLL_LOCK_STATUS), 1, 5000))
+		pr_warn("%s: DLL can't lock in 5ms after force L0 during tuning.\n",
+				mmc_hostname(host->mmc));
 	/*
 	 * Judge the tuning reason, whether caused by dll shift
 	 * If cause by dll shift, should call sdhci_o2_dll_recovery
@@ -344,6 +359,11 @@ static int sdhci_o2_execute_tuning(struc
 		sdhci_set_bus_width(host, current_bus_width);
 	}
 
+	/* Cancel force power mode enter L0 */
+	scratch = sdhci_readw(host, O2_SD_MISC_CTRL);
+	scratch &= ~(O2_SD_PWR_FORCE_L0);
+	sdhci_writew(host, scratch, O2_SD_MISC_CTRL);
+
 	sdhci_reset(host, SDHCI_RESET_CMD);
 	sdhci_reset(host, SDHCI_RESET_DATA);
 


