Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441413FDC18
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344494AbhIAMqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345667AbhIAMoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC42D6113C;
        Wed,  1 Sep 2021 12:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499940;
        bh=XaVd3fd8fC8Nso5+00MSU7BHIvXqHYjAk+VwI0DIzGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cy/CnaBdHHcaitRFbtAmqI37LjgYcfT3fiAueK3OQBmJ+vintR6E9akNAy0Vse2e5
         3ACiWbF/5CSxzaJEyLcT4hfQlz9q6usf5qioiTrVUuWhhGjCeaG/cd6rUQpHrcbUbU
         4Y/1pCcLPdaKWQ/AJKDkDONYGWEkr0KHy9r6vJSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 043/113] igc: fix page fault when thunderbolt is unplugged
Date:   Wed,  1 Sep 2021 14:27:58 +0200
Message-Id: <20210901122303.423837876@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 4b79959510e6612d80f8d86022e0cb44eee6f4a2 ]

After unplug thunderbolt dock with i225, pciehp interrupt is triggered,
remove call will read/write mmio address which is already disconnected,
then cause page fault and make system hang.

Check PCI state to remove device safely.

Trace:
BUG: unable to handle page fault for address: 000000000000b604
Oops: 0000 [#1] SMP NOPTI
RIP: 0010:igc_rd32+0x1c/0x90 [igc]
Call Trace:
igc_ptp_suspend+0x6c/0xa0 [igc]
igc_ptp_stop+0x12/0x50 [igc]
igc_remove+0x7f/0x1c0 [igc]
pci_device_remove+0x3e/0xb0
__device_release_driver+0x181/0x240

Fixes: 13b5b7fd6a4a ("igc: Add support for Tx/Rx rings")
Fixes: b03c49cde61f ("igc: Save PTP time before a reset")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 32 ++++++++++++++---------
 drivers/net/ethernet/intel/igc/igc_ptp.c  |  3 ++-
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a8d5f196fdbd..3db86daf3568 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -146,6 +146,9 @@ static void igc_release_hw_control(struct igc_adapter *adapter)
 	struct igc_hw *hw = &adapter->hw;
 	u32 ctrl_ext;
 
+	if (!pci_device_is_present(adapter->pdev))
+		return;
+
 	/* Let firmware take over control of h/w */
 	ctrl_ext = rd32(IGC_CTRL_EXT);
 	wr32(IGC_CTRL_EXT,
@@ -4037,26 +4040,29 @@ void igc_down(struct igc_adapter *adapter)
 
 	igc_ptp_suspend(adapter);
 
-	/* disable receives in the hardware */
-	rctl = rd32(IGC_RCTL);
-	wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
-	/* flush and sleep below */
-
+	if (pci_device_is_present(adapter->pdev)) {
+		/* disable receives in the hardware */
+		rctl = rd32(IGC_RCTL);
+		wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
+		/* flush and sleep below */
+	}
 	/* set trans_start so we don't get spurious watchdogs during reset */
 	netif_trans_update(netdev);
 
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
 
-	/* disable transmits in the hardware */
-	tctl = rd32(IGC_TCTL);
-	tctl &= ~IGC_TCTL_EN;
-	wr32(IGC_TCTL, tctl);
-	/* flush both disables and wait for them to finish */
-	wrfl();
-	usleep_range(10000, 20000);
+	if (pci_device_is_present(adapter->pdev)) {
+		/* disable transmits in the hardware */
+		tctl = rd32(IGC_TCTL);
+		tctl &= ~IGC_TCTL_EN;
+		wr32(IGC_TCTL, tctl);
+		/* flush both disables and wait for them to finish */
+		wrfl();
+		usleep_range(10000, 20000);
 
-	igc_irq_disable(adapter);
+		igc_irq_disable(adapter);
+	}
 
 	adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 69617d2c1be2..4ae19c6a3247 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -849,7 +849,8 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	adapter->ptp_tx_skb = NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
 
-	igc_ptp_time_save(adapter);
+	if (pci_device_is_present(adapter->pdev))
+		igc_ptp_time_save(adapter);
 }
 
 /**
-- 
2.30.2



