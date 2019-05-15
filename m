Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EC11F2D7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfEOLIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729150AbfEOLIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:08:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1227220843;
        Wed, 15 May 2019 11:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918527;
        bh=FSj5wUhqLaoNm7VBDzsNYpYVr3LHtanV132URKpxuks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1KmRfWFGGXfktj04R8vACPTUvbbdRgIvkqkZlS2lY77GTqRbWe2r/Wq8is7EwLlm
         JVSEYexbrSvDzks/POCnq+iOsqIfh6RYvEYOClXY1+aEXYLLeNMD6s9tLGuucoSK1W
         4nW4o+H86nAMuehkzwho3NQfO7F7TcQHxkAnDfRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <niveditas98@gmail.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 122/266] igb: Fix WARN_ONCE on runtime suspend
Date:   Wed, 15 May 2019 12:53:49 +0200
Message-Id: <20190515090726.722741014@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dabb8338be533c18f50255cf39ff4f66d4dabdbe ]

The runtime_suspend device callbacks are not supposed to save
configuration state or change the power state. Commit fb29f76cc566
("igb: Fix an issue that PME is not enabled during runtime suspend")
changed the driver to not save configuration state during runtime
suspend, however the driver callback still put the device into a
low-power state. This causes a warning in the pci pm core and results in
pci_pm_runtime_suspend not calling pci_save_state or pci_finish_runtime_suspend.

Fix this by not changing the power state either, leaving that to pci pm
core, and make the same change for suspend callback as well.

Also move a couple of defines into the appropriate header file instead
of inline in the .c file.

Fixes: fb29f76cc566 ("igb: Fix an issue that PME is not enabled during runtime suspend")
Signed-off-by: Arvind Sankar <niveditas98@gmail.com>
Reviewed-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/igb/e1000_defines.h    |  2 +
 drivers/net/ethernet/intel/igb/igb_main.c     | 57 +++----------------
 2 files changed, 10 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_defines.h b/drivers/net/ethernet/intel/igb/e1000_defines.h
index b1915043bc0c..7b9fb71137da 100644
--- a/drivers/net/ethernet/intel/igb/e1000_defines.h
+++ b/drivers/net/ethernet/intel/igb/e1000_defines.h
@@ -193,6 +193,8 @@
 /* enable link status from external LINK_0 and LINK_1 pins */
 #define E1000_CTRL_SWDPIN0  0x00040000  /* SWDPIN 0 value */
 #define E1000_CTRL_SWDPIN1  0x00080000  /* SWDPIN 1 value */
+#define E1000_CTRL_ADVD3WUC 0x00100000  /* D3 WUC */
+#define E1000_CTRL_EN_PHY_PWR_MGMT 0x00200000 /* PHY PM enable */
 #define E1000_CTRL_SDP0_DIR 0x00400000  /* SDP0 Data direction */
 #define E1000_CTRL_SDP1_DIR 0x00800000  /* SDP1 Data direction */
 #define E1000_CTRL_RST      0x04000000  /* Global reset */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index c1796aa2dde5..70ed5e5c3514 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7325,9 +7325,7 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, rctl, status;
 	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
+	bool wake;
 
 	rtnl_lock();
 	netif_device_detach(netdev);
@@ -7338,14 +7336,6 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	igb_clear_interrupt_scheme(adapter);
 	rtnl_unlock();
 
-#ifdef CONFIG_PM
-	if (!runtime) {
-		retval = pci_save_state(pdev);
-		if (retval)
-			return retval;
-	}
-#endif
-
 	status = rd32(E1000_STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -7362,10 +7352,6 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 		}
 
 		ctrl = rd32(E1000_CTRL);
-		/* advertise wake from D3Cold */
-		#define E1000_CTRL_ADVD3WUC 0x00100000
-		/* phy power management enable */
-		#define E1000_CTRL_EN_PHY_PWR_MGMT 0x00200000
 		ctrl |= E1000_CTRL_ADVD3WUC;
 		wr32(E1000_CTRL, ctrl);
 
@@ -7379,12 +7365,15 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 		wr32(E1000_WUFC, 0);
 	}
 
-	*enable_wake = wufc || adapter->en_mng_pt;
-	if (!*enable_wake)
+	wake = wufc || adapter->en_mng_pt;
+	if (!wake)
 		igb_power_down_link(adapter);
 	else
 		igb_power_up_link(adapter);
 
+	if (enable_wake)
+		*enable_wake = wake;
+
 	/* Release control of h/w to f/w.  If f/w is AMT enabled, this
 	 * would have already happened in close and is redundant.
 	 */
@@ -7399,22 +7388,7 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 #ifdef CONFIG_PM_SLEEP
 static int igb_suspend(struct device *dev)
 {
-	int retval;
-	bool wake;
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	retval = __igb_shutdown(pdev, &wake, 0);
-	if (retval)
-		return retval;
-
-	if (wake) {
-		pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		pci_set_power_state(pdev, PCI_D3hot);
-	}
-
-	return 0;
+	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
 }
 #endif /* CONFIG_PM_SLEEP */
 
@@ -7483,22 +7457,7 @@ static int igb_runtime_idle(struct device *dev)
 
 static int igb_runtime_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	int retval;
-	bool wake;
-
-	retval = __igb_shutdown(pdev, &wake, 1);
-	if (retval)
-		return retval;
-
-	if (wake) {
-		pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		pci_set_power_state(pdev, PCI_D3hot);
-	}
-
-	return 0;
+	return __igb_shutdown(to_pci_dev(dev), NULL, 1);
 }
 
 static int igb_runtime_resume(struct device *dev)
-- 
2.20.1



