Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D2159A393
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353873AbiHSQqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353973AbiHSQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C54A112FA1;
        Fri, 19 Aug 2022 09:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB00561838;
        Fri, 19 Aug 2022 16:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94B8C433C1;
        Fri, 19 Aug 2022 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925494;
        bh=d8wBo+QR4O8JqqkGeeFMtuP8DDWDZNs6/vactNB//FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2aQ6/dwMk1NY8T3b85J/8GejnhXvz+QXA/X5f9Q+5E+FmhsQDpJ9+BL2DEgyCZiV
         fCQ0Rymr1xxXv3996s3w7JB4nYcFD5EtZg5EisF6rijNe2qiKmssD1Yqf5SXgBCkpG
         uGk7cJ2Akiy3010GSDDCyzyMyAvX2sfBqxE3mAkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean V Kelley <sean.v.kelley@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 478/545] PCI/ERR: Use "bridge" for clarity in pcie_do_recovery()
Date:   Fri, 19 Aug 2022 17:44:08 +0200
Message-Id: <20220819153850.812193669@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean V Kelley <sean.v.kelley@intel.com>

[ Upstream commit 0791721d800790e6e533bd8467df67f0dc4f2fec ]

pcie_do_recovery() may be called with "dev" being either a bridge (Root
Port or Switch Downstream Port) or an Endpoint.  The bulk of the function
deals with the bridge, so if we start with an Endpoint, we reset "dev" to
be the bridge leading to it.

For clarity, replace "dev" in the body of the function with "bridge".  No
functional change intended.

Link: https://lore.kernel.org/r/20201121001036.8560-8-sean.v.kelley@intel.com
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # non-native/no RCEC
Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/err.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 7a5af873d8bc..46a5b84f8842 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -151,24 +151,27 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 		pci_ers_result_t (*reset_subordinates)(struct pci_dev *pdev))
 {
 	int type = pci_pcie_type(dev);
-	pci_ers_result_t status = PCI_ERS_RESULT_CAN_RECOVER;
+	struct pci_dev *bridge;
 	struct pci_bus *bus;
+	pci_ers_result_t status = PCI_ERS_RESULT_CAN_RECOVER;
 
 	/*
-	 * Error recovery runs on all subordinates of the first downstream port.
-	 * If the downstream port detected the error, it is cleared at the end.
+	 * Error recovery runs on all subordinates of the bridge.  If the
+	 * bridge detected the error, it is cleared at the end.
 	 */
 	if (!(type == PCI_EXP_TYPE_ROOT_PORT ||
 	      type == PCI_EXP_TYPE_DOWNSTREAM))
-		dev = pci_upstream_bridge(dev);
-	bus = dev->subordinate;
+		bridge = pci_upstream_bridge(dev);
+	else
+		bridge = dev;
 
-	pci_dbg(dev, "broadcast error_detected message\n");
+	bus = bridge->subordinate;
+	pci_dbg(bridge, "broadcast error_detected message\n");
 	if (state == pci_channel_io_frozen) {
 		pci_walk_bus(bus, report_frozen_detected, &status);
-		status = reset_subordinates(dev);
+		status = reset_subordinates(bridge);
 		if (status != PCI_ERS_RESULT_RECOVERED) {
-			pci_warn(dev, "subordinate device reset failed\n");
+			pci_warn(bridge, "subordinate device reset failed\n");
 			goto failed;
 		}
 	} else {
@@ -177,7 +180,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 
 	if (status == PCI_ERS_RESULT_CAN_RECOVER) {
 		status = PCI_ERS_RESULT_RECOVERED;
-		pci_dbg(dev, "broadcast mmio_enabled message\n");
+		pci_dbg(bridge, "broadcast mmio_enabled message\n");
 		pci_walk_bus(bus, report_mmio_enabled, &status);
 	}
 
@@ -188,27 +191,27 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 		 * drivers' slot_reset callbacks?
 		 */
 		status = PCI_ERS_RESULT_RECOVERED;
-		pci_dbg(dev, "broadcast slot_reset message\n");
+		pci_dbg(bridge, "broadcast slot_reset message\n");
 		pci_walk_bus(bus, report_slot_reset, &status);
 	}
 
 	if (status != PCI_ERS_RESULT_RECOVERED)
 		goto failed;
 
-	pci_dbg(dev, "broadcast resume message\n");
+	pci_dbg(bridge, "broadcast resume message\n");
 	pci_walk_bus(bus, report_resume, &status);
 
-	if (pcie_aer_is_native(dev))
-		pcie_clear_device_status(dev);
-	pci_aer_clear_nonfatal_status(dev);
-	pci_info(dev, "device recovery successful\n");
+	if (pcie_aer_is_native(bridge))
+		pcie_clear_device_status(bridge);
+	pci_aer_clear_nonfatal_status(bridge);
+	pci_info(bridge, "device recovery successful\n");
 	return status;
 
 failed:
-	pci_uevent_ers(dev, PCI_ERS_RESULT_DISCONNECT);
+	pci_uevent_ers(bridge, PCI_ERS_RESULT_DISCONNECT);
 
 	/* TODO: Should kernel panic here? */
-	pci_info(dev, "device recovery failed\n");
+	pci_info(bridge, "device recovery failed\n");
 
 	return status;
 }
-- 
2.35.1



