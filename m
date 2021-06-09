Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C611B3A1B8A
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 19:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFIRM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 13:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhFIRM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 13:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCDFE613D4;
        Wed,  9 Jun 2021 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623258632;
        bh=lq9IdEYFGwDmr/SRTN9Fy6j4btEzJVOiasoXLeQ0QK4=;
        h=Subject:To:From:Date:From;
        b=EkDynvFyQOtTj1ZQ04dqBzt7Jyc4Z14t7EH2KjnnYGER5a6ID1QyZmcGPggp3nXp0
         5ewrDFn5qP9VBUQ06DToACoJLb8yIH3hOaUvKyk0vQ5/oOt+yc0z1WJzmXD6OQ2W5C
         jov8YLC1JDHRWwirYRHEa/8KF5FrMUDgcq0gIWxk=
Subject: patch "misc: rtsx: separate aspm mode into MODE_REG and MODE_CFG" added to char-misc-linus
To:     ricky_wu@realtek.com, chris.chiu@canonical.com,
        gordon.lack@dsl.pipex.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 19:10:30 +0200
Message-ID: <1623258630163193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: rtsx: separate aspm mode into MODE_REG and MODE_CFG

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3df4fce739e2b263120f528c5e0fe6b2f8937b5b Mon Sep 17 00:00:00 2001
From: Ricky Wu <ricky_wu@realtek.com>
Date: Mon, 7 Jun 2021 18:16:34 +0800
Subject: misc: rtsx: separate aspm mode into MODE_REG and MODE_CFG

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
 drivers/misc/cardreader/rtl8411.c  |  1 +
 drivers/misc/cardreader/rts5209.c  |  1 +
 drivers/misc/cardreader/rts5227.c  |  2 ++
 drivers/misc/cardreader/rts5228.c  |  1 +
 drivers/misc/cardreader/rts5229.c  |  1 +
 drivers/misc/cardreader/rts5249.c  |  3 ++
 drivers/misc/cardreader/rts5260.c  |  1 +
 drivers/misc/cardreader/rts5261.c  |  1 +
 drivers/misc/cardreader/rtsx_pcr.c | 44 +++++++++++++++++++++---------
 include/linux/rtsx_pci.h           |  2 ++
 10 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/cardreader/rtl8411.c b/drivers/misc/cardreader/rtl8411.c
index a07674ed0596..4c5621b17a6f 100644
--- a/drivers/misc/cardreader/rtl8411.c
+++ b/drivers/misc/cardreader/rtl8411.c
@@ -468,6 +468,7 @@ static void rtl8411_init_common_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
diff --git a/drivers/misc/cardreader/rts5209.c b/drivers/misc/cardreader/rts5209.c
index 39a6a7ecc32e..29f5414072bf 100644
--- a/drivers/misc/cardreader/rts5209.c
+++ b/drivers/misc/cardreader/rts5209.c
@@ -255,6 +255,7 @@ void rts5209_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 16);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
diff --git a/drivers/misc/cardreader/rts5227.c b/drivers/misc/cardreader/rts5227.c
index 8200af22b529..4bcfbc9afbac 100644
--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -358,6 +358,7 @@ void rts5227_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 15);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(30, 7, 7);
 
@@ -483,6 +484,7 @@ void rts522a_init_params(struct rtsx_pcr *pcr)
 
 	rts5227_init_params(pcr);
 	pcr->ops = &rts522a_pcr_ops;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(20, 20, 11);
 	pcr->reg_pm_ctrl3 = RTS522A_PM_CTRL3;
 
diff --git a/drivers/misc/cardreader/rts5228.c b/drivers/misc/cardreader/rts5228.c
index 781a86def59a..ffc128278613 100644
--- a/drivers/misc/cardreader/rts5228.c
+++ b/drivers/misc/cardreader/rts5228.c
@@ -718,6 +718,7 @@ void rts5228_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(28, 27, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
diff --git a/drivers/misc/cardreader/rts5229.c b/drivers/misc/cardreader/rts5229.c
index 89e6f124ca5c..c748eaf1ec1f 100644
--- a/drivers/misc/cardreader/rts5229.c
+++ b/drivers/misc/cardreader/rts5229.c
@@ -246,6 +246,7 @@ void rts5229_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 15);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(30, 6, 6);
 
diff --git a/drivers/misc/cardreader/rts5249.c b/drivers/misc/cardreader/rts5249.c
index b2676e7f5027..53f3a1f45c4a 100644
--- a/drivers/misc/cardreader/rts5249.c
+++ b/drivers/misc/cardreader/rts5249.c
@@ -566,6 +566,7 @@ void rts5249_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_CFG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(1, 29, 16);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
@@ -729,6 +730,7 @@ static const struct pcr_ops rts524a_pcr_ops = {
 void rts524a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
@@ -845,6 +847,7 @@ static const struct pcr_ops rts525a_pcr_ops = {
 void rts525a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5249_init_params(pcr);
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(25, 29, 11);
 	pcr->option.ltr_l1off_sspwrgate = LTR_L1OFF_SSPWRGATE_5250_DEF;
 	pcr->option.ltr_l1off_snooze_sspwrgate =
diff --git a/drivers/misc/cardreader/rts5260.c b/drivers/misc/cardreader/rts5260.c
index 080a7d67a8e1..9b42b20a3e5a 100644
--- a/drivers/misc/cardreader/rts5260.c
+++ b/drivers/misc/cardreader/rts5260.c
@@ -628,6 +628,7 @@ void rts5260_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 29, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
diff --git a/drivers/misc/cardreader/rts5261.c b/drivers/misc/cardreader/rts5261.c
index 6c64dade8e1a..1fd4e0e50730 100644
--- a/drivers/misc/cardreader/rts5261.c
+++ b/drivers/misc/cardreader/rts5261.c
@@ -783,6 +783,7 @@ void rts5261_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = 0x00;
 	pcr->sd30_drive_sel_3v3 = 0x00;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->aspm_mode = ASPM_MODE_REG;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 11);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 273311184669..baf83594a01d 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -85,12 +85,18 @@ static void rtsx_comm_set_aspm(struct rtsx_pcr *pcr, bool enable)
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
@@ -1394,7 +1400,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 			return err;
 	}
 
-	rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0x30, 0x30);
+	if (pcr->aspm_mode == ASPM_MODE_REG)
+		rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0x30, 0x30);
 
 	/* No CD interrupt if probing driver with card inserted.
 	 * So we need to initialize pcr->card_exist here.
@@ -1410,6 +1417,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 {
 	int err;
+	u16 cfg_val;
+	u8 val;
 
 	spin_lock_init(&pcr->lock);
 	mutex_init(&pcr->pcr_mutex);
@@ -1477,6 +1486,21 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
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
 
@@ -1506,7 +1530,6 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	struct pcr_handle *handle;
 	u32 base, len;
 	int ret, i, bar = 0;
-	u8 val;
 
 	dev_dbg(&(pcidev->dev),
 		": Realtek PCI-E Card Reader found at %s [%04x:%04x] (rev %x)\n",
@@ -1572,11 +1595,6 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
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
diff --git a/include/linux/rtsx_pci.h b/include/linux/rtsx_pci.h
index 6f155f99aa16..4ab7bfc675f1 100644
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
-- 
2.32.0


