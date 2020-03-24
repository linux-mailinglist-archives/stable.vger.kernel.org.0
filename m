Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC50191107
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgCXNNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgCXNNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:13:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A6CB208CA;
        Tue, 24 Mar 2020 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055598;
        bh=x9iQBMLoTaDjC8I70X6gTHrIwTmxpbSkbw+3dKzEcn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dji7y76ziZRLpgm0B4tT+r9ptbR7qOVoSGRCclCNDIN72U77I/uXGx4wGuoSIHLyb
         CkImSjmGHOID0VDtfipDstJVWZ3ebscZXLAV2R9cWMy9ZnAvf84ay4GGMXKQZXrRkL
         PSpbviJUucY+HqH+p6n3JgS3xMbXzCscbzmkMAbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricky Wu <ricky_wu@realtek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 35/65] mmc: rtsx_pci: Fix support for speed-modes that relies on tuning
Date:   Tue, 24 Mar 2020 14:10:56 +0100
Message-Id: <20200324130801.651420351@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
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
@@ -369,6 +369,6 @@ static const struct pcr_ops rts522a_pcr_
 void rts522a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5227_init_params(pcr);
-
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(20, 20, 11);
 	pcr->reg_pm_ctrl3 = RTS522A_PM_CTRL3;
 }
--- a/drivers/misc/cardreader/rts5249.c
+++ b/drivers/misc/cardreader/rts5249.c
@@ -623,6 +623,7 @@ static const struct pcr_ops rts524a_pcr_
 void rts524a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
 		LTR_L1OFF_SNOOZE_SSPWRGATE_5250_DEF;
@@ -731,6 +732,7 @@ static const struct pcr_ops rts525a_pcr_
 void rts525a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(25, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
 		LTR_L1OFF_SNOOZE_SSPWRGATE_5250_DEF;
--- a/drivers/misc/cardreader/rts5260.c
+++ b/drivers/misc/cardreader/rts5260.c
@@ -712,7 +712,7 @@ void rts5260_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
-	pcr->tx_initial_phase = SET_CLOCK_PHASE(1, 29, 16);
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
 	pcr->ic_version = rts5260_get_ic_version(pcr);
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -618,19 +618,22 @@ static int sd_change_phase(struct realte
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


