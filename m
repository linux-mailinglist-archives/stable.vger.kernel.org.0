Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F591910EC
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgCXNSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbgCXNSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44C1B208CA;
        Tue, 24 Mar 2020 13:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055909;
        bh=1x7vDx1172FE2OYIBcvAkwUtPgmvf7mRCanQDUU3EI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRS9TYJW/r4X5XPb/QyFgP7zIH60lupIrPH0ZY5sl/0e/R3ckEW3WaXHiUolp7Mx6
         TptTfqfL9u2KEwikFEZf5hsHpNV4tTCwKNHRLIICkxP8r//s4PmCoJy+FvJbY3+JMh
         gJ1Lje6X2/5um3sXICTkB38bVq52yWA38nhvzWbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricky Wu <ricky_wu@realtek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 065/102] mmc: rtsx_pci: Fix support for speed-modes that relies on tuning
Date:   Tue, 24 Mar 2020 14:10:57 +0100
Message-Id: <20200324130813.218773951@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricky Wu <ricky_wu@realtek.com>

commit 4686392c32361c97e8434adf9cc77ad7991bfa81 upstream.

The TX/RX register should not be treated the same way to allow for better
support of tuning. Fix this by using a default initial value for TX.

Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200316025232.1167-1-ricky_wu@realtek.com
[Ulf: Updated changelog]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/cardreader/rts5227.c |    2 +-
 drivers/misc/cardreader/rts5249.c |    2 ++
 drivers/misc/cardreader/rts5260.c |    2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c |   13 ++++++++-----
 4 files changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -394,7 +394,7 @@ static const struct pcr_ops rts522a_pcr_
 void rts522a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5227_init_params(pcr);
-
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(20, 20, 11);
 	pcr->reg_pm_ctrl3 = RTS522A_PM_CTRL3;
 
 	pcr->option.ocp_en = 1;
--- a/drivers/misc/cardreader/rts5249.c
+++ b/drivers/misc/cardreader/rts5249.c
@@ -618,6 +618,7 @@ static const struct pcr_ops rts524a_pcr_
 void rts524a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
 		LTR_L1OFF_SNOOZE_SSPWRGATE_5250_DEF;
@@ -733,6 +734,7 @@ static const struct pcr_ops rts525a_pcr_
 void rts525a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(25, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
 		LTR_L1OFF_SNOOZE_SSPWRGATE_5250_DEF;
--- a/drivers/misc/cardreader/rts5260.c
+++ b/drivers/misc/cardreader/rts5260.c
@@ -663,7 +663,7 @@ void rts5260_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
-	pcr->tx_initial_phase = SET_CLOCK_PHASE(1, 29, 16);
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
 	pcr->ic_version = rts5260_get_ic_version(pcr);
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -606,19 +606,22 @@ static int sd_change_phase(struct realte
 		u8 sample_point, bool rx)
 {
 	struct rtsx_pcr *pcr = host->pcr;
-
+	u16 SD_VP_CTL = 0;
 	dev_dbg(sdmmc_dev(host), "%s(%s): sample_point = %d\n",
 			__func__, rx ? "RX" : "TX", sample_point);
 
 	rtsx_pci_write_register(pcr, CLK_CTL, CHANGE_CLK, CHANGE_CLK);
-	if (rx)
+	if (rx) {
+		SD_VP_CTL = SD_VPRX_CTL;
 		rtsx_pci_write_register(pcr, SD_VPRX_CTL,
 			PHASE_SELECT_MASK, sample_point);
-	else
+	} else {
+		SD_VP_CTL = SD_VPTX_CTL;
 		rtsx_pci_write_register(pcr, SD_VPTX_CTL,
 			PHASE_SELECT_MASK, sample_point);
-	rtsx_pci_write_register(pcr, SD_VPCLK0_CTL, PHASE_NOT_RESET, 0);
-	rtsx_pci_write_register(pcr, SD_VPCLK0_CTL, PHASE_NOT_RESET,
+	}
+	rtsx_pci_write_register(pcr, SD_VP_CTL, PHASE_NOT_RESET, 0);
+	rtsx_pci_write_register(pcr, SD_VP_CTL, PHASE_NOT_RESET,
 				PHASE_NOT_RESET);
 	rtsx_pci_write_register(pcr, CLK_CTL, CHANGE_CLK, 0);
 	rtsx_pci_write_register(pcr, SD_CFG1, SD_ASYNC_FIFO_NOT_RST, 0);


