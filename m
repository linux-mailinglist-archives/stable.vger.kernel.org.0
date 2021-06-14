Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4403A641D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhFNLU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235021AbhFNLSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0442261981;
        Mon, 14 Jun 2021 10:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667857;
        bh=9OgVfgo+79mWlKeNsC/brSMWqBTKmtyvCpa/I0il7Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJwX1adpadUN0uA6axsqRd+L8kfRoWcAPXKSy6eatnpRLCy4S6AT12UuhGlOOcqOz
         Sl3tRi+kIvvGR3UeyCoPt12T8A/l4/bK5D0B6tnf2+PKA2X9AGF0smIZz39p328Frj
         6yfLEUrlf2dW/HB58GNfRJKBVnFYthgrBLHag41Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>,
        Gordon Lack <gordon.lack@dsl.pipex.com>,
        Ricky Wu <ricky_wu@realtek.com>
Subject: [PATCH 5.12 068/173] misc: rtsx: separate aspm mode into MODE_REG and MODE_CFG
Date:   Mon, 14 Jun 2021 12:26:40 +0200
Message-Id: <20210614102700.424381507@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricky Wu <ricky_wu@realtek.com>

commit 3df4fce739e2b263120f528c5e0fe6b2f8937b5b upstream.

aspm (Active State Power Management)
rtsx_comm_set_aspm: this function is for driver to make sure
not enter power saving when processing of init and card_detcct
ASPM_MODE_CFG: 8411 5209 5227 5229 5249 5250
Change back to use original way to control aspm
ASPM_MODE_REG: 5227A 524A 5250A 5260 5261 5228
Keep the new way to control aspm

Fixes: 121e9c6b5c4c ("misc: rtsx: modify and fix init_hw function")
Reported-by: Chris Chiu <chris.chiu@canonical.com>
Tested-by: Gordon Lack <gordon.lack@dsl.pipex.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Link: https://lore.kernel.org/r/20210607101634.4948-1-ricky_wu@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtl8411.c  |    1 
 drivers/misc/cardreader/rts5209.c  |    1 
 drivers/misc/cardreader/rts5227.c  |    2 +
 drivers/misc/cardreader/rts5228.c  |    1 
 drivers/misc/cardreader/rts5229.c  |    1 
 drivers/misc/cardreader/rts5249.c  |    3 ++
 drivers/misc/cardreader/rts5260.c  |    1 
 drivers/misc/cardreader/rts5261.c  |    1 
 drivers/misc/cardreader/rtsx_pcr.c |   44 ++++++++++++++++++++++++++-----------
 include/linux/rtsx_pci.h           |    2 +
 10 files changed, 44 insertions(+), 13 deletions(-)

--- a/drivers/misc/cardreader/rtl8411.c
+++ b/drivers/misc/cardreader/rtl8411.c
@@ -468,6 +468,7 @@ static void rtl8411_init_common_params(s
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
--- a/drivers/misc/cardreader/rts5209.c
+++ b/drivers/misc/cardreader/rts5209.c
@@ -255,6 +255,7 @@ void rts5209_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 16);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -358,6 +358,7 @@ void rts5227_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 15);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(30, 7, 7);
 
@@ -483,6 +484,7 @@ void rts522a_init_params(struct rtsx_pcr
 
 	rts5227_init_params(pcr);
 	pcr->ops = &rts522a_pcr_ops;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(20, 20, 11);
 	pcr->reg_pm_ctrl3 = RTS522A_PM_CTRL3;
 
--- a/drivers/misc/cardreader/rts5228.c
+++ b/drivers/misc/cardreader/rts5228.c
@@ -718,6 +718,7 @@ void rts5228_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(28, 27, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
--- a/drivers/misc/cardreader/rts5229.c
+++ b/drivers/misc/cardreader/rts5229.c
@@ -246,6 +246,7 @@ void rts5229_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 15);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(30, 6, 6);
 
--- a/drivers/misc/cardreader/rts5249.c
+++ b/drivers/misc/cardreader/rts5249.c
@@ -566,6 +566,7 @@ void rts5249_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(1, 29, 16);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
@@ -729,6 +730,7 @@ static const struct pcr_ops rts524a_pcr_
 void rts524a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
@@ -845,6 +847,7 @@ static const struct pcr_ops rts525a_pcr_
 void rts525a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(25, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
--- a/drivers/misc/cardreader/rts5260.c
+++ b/drivers/misc/cardreader/rts5260.c
@@ -628,6 +628,7 @@ void rts5260_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
--- a/drivers/misc/cardreader/rts5261.c
+++ b/drivers/misc/cardreader/rts5261.c
@@ -783,6 +783,7 @@ void rts5261_init_params(struct rtsx_pcr
 	pcr->sd30_drive_sel_1v8 = 0x00;
 	pcr->sd30_drive_sel_3v3 = 0x00;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -85,12 +85,18 @@ static void rtsx_comm_set_aspm(struct rt
 	if (pcr->aspm_enabled == enable)
 		return;
 
-	if (pcr->aspm_en & 0x02)
-		rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, FORCE_ASPM_CTL0 |
-			FORCE_ASPM_CTL1, enable ? 0 : FORCE_ASPM_CTL0 | FORCE_ASPM_CTL1);
-	else
-		rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, FORCE_ASPM_CTL0 |
-			FORCE_ASPM_CTL1, FORCE_ASPM_CTL0 | FORCE_ASPM_CTL1);
+	if (pcr->aspm_mode == ASPM_MODE_CFG) {
+		pcie_capability_clear_and_set_word(pcr->pci, PCI_EXP_LNKCTL,
+						PCI_EXP_LNKCTL_ASPMC,
+						enable ? pcr->aspm_en : 0);
+	} else if (pcr->aspm_mode == ASPM_MODE_REG) {
+		if (pcr->aspm_en & 0x02)
+			rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, FORCE_ASPM_CTL0 |
+				FORCE_ASPM_CTL1, enable ? 0 : FORCE_ASPM_CTL0 | FORCE_ASPM_CTL1);
+		else
+			rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, FORCE_ASPM_CTL0 |
+				FORCE_ASPM_CTL1, FORCE_ASPM_CTL0 | FORCE_ASPM_CTL1);
+	}
 
 	if (!enable && (pcr->aspm_en & 0x02))
 		mdelay(10);
@@ -1394,7 +1400,8 @@ static int rtsx_pci_init_hw(struct rtsx_
 			return err;
 	}
 
-	rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0x30, 0x30);
+	if (pcr->aspm_mode == ASPM_MODE_REG)
+		rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0x30, 0x30);
 
 	/* No CD interrupt if probing driver with card inserted.
 	 * So we need to initialize pcr->card_exist here.
@@ -1410,6 +1417,8 @@ static int rtsx_pci_init_hw(struct rtsx_
 static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 {
 	int err;
+	u16 cfg_val;
+	u8 val;
 
 	spin_lock_init(&pcr->lock);
 	mutex_init(&pcr->pcr_mutex);
@@ -1477,6 +1486,21 @@ static int rtsx_pci_init_chip(struct rts
 	if (!pcr->slots)
 		return -ENOMEM;
 
+	if (pcr->aspm_mode == ASPM_MODE_CFG) {
+		pcie_capability_read_word(pcr->pci, PCI_EXP_LNKCTL, &cfg_val);
+		if (cfg_val & PCI_EXP_LNKCTL_ASPM_L1)
+			pcr->aspm_enabled = true;
+		else
+			pcr->aspm_enabled = false;
+
+	} else if (pcr->aspm_mode == ASPM_MODE_REG) {
+		rtsx_pci_read_register(pcr, ASPM_FORCE_CTL, &val);
+		if (val & FORCE_ASPM_CTL0 && val & FORCE_ASPM_CTL1)
+			pcr->aspm_enabled = false;
+		else
+			pcr->aspm_enabled = true;
+	}
+
 	if (pcr->ops->fetch_vendor_settings)
 		pcr->ops->fetch_vendor_settings(pcr);
 
@@ -1506,7 +1530,6 @@ static int rtsx_pci_probe(struct pci_dev
 	struct pcr_handle *handle;
 	u32 base, len;
 	int ret, i, bar = 0;
-	u8 val;
 
 	dev_dbg(&(pcidev->dev),
 		": Realtek PCI-E Card Reader found at %s [%04x:%04x] (rev %x)\n",
@@ -1572,11 +1595,6 @@ static int rtsx_pci_probe(struct pci_dev
 	pcr->host_cmds_addr = pcr->rtsx_resv_buf_addr;
 	pcr->host_sg_tbl_ptr = pcr->rtsx_resv_buf + HOST_CMDS_BUF_LEN;
 	pcr->host_sg_tbl_addr = pcr->rtsx_resv_buf_addr + HOST_CMDS_BUF_LEN;
-	rtsx_pci_read_register(pcr, ASPM_FORCE_CTL, &val);
-	if (val & FORCE_ASPM_CTL0 && val & FORCE_ASPM_CTL1)
-		pcr->aspm_enabled = false;
-	else
-		pcr->aspm_enabled = true;
 	pcr->card_inserted = 0;
 	pcr->card_removed = 0;
 	INIT_DELAYED_WORK(&pcr->carddet_work, rtsx_pci_card_detect);
--- a/include/linux/rtsx_pci.h
+++ b/include/linux/rtsx_pci.h
@@ -1109,6 +1109,7 @@ struct pcr_ops {
 };
 
 enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
+enum ASPM_MODE  {ASPM_MODE_CFG, ASPM_MODE_REG};
 
 #define ASPM_L1_1_EN			BIT(0)
 #define ASPM_L1_2_EN			BIT(1)
@@ -1234,6 +1235,7 @@ struct rtsx_pcr {
 	u8				card_drive_sel;
 #define ASPM_L1_EN			0x02
 	u8				aspm_en;
+	enum ASPM_MODE			aspm_mode;
 	bool				aspm_enabled;
 
 #define PCR_MS_PMOS			(1 << 0)


