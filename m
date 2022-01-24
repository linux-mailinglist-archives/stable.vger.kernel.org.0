Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3A499DA0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585821AbiAXWZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582623AbiAXWPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:15:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF6FC04A2C6;
        Mon, 24 Jan 2022 12:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A7656090B;
        Mon, 24 Jan 2022 20:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED58AC340E5;
        Mon, 24 Jan 2022 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057102;
        bh=4KnP9f2BG2N0gQWpClCCaBlbp1tyU3Pjw2Z1LPrgmQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1ifqwSsvDfwybRjcENN3ZiV17Adc7KfhKKP0ujE2arw4KM1jsh7N5lhbP1z0d1H4
         ASdGiVMEsGmtFO4WRPZeQZWQAArB7FVLVevR12MkPypNXV1wYh3sniCB66JaQYvBNL
         4TOcIgm/fZiO/wZ4E7OBWqMrduB21LRRWauzHD28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Bao <joseph.bao@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH 5.15 702/846] PCI: pciehp: Fix infinite loop in IRQ handler upon power fault
Date:   Mon, 24 Jan 2022 19:43:39 +0100
Message-Id: <20220124184125.262745168@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 23584c1ed3e15a6f4bfab8dc5a88d94ab929ee12 upstream.

The Power Fault Detected bit in the Slot Status register differs from
all other hotplug events in that it is sticky:  It can only be cleared
after turning off slot power.  Per PCIe r5.0, sec. 6.7.1.8:

  If a power controller detects a main power fault on the hot-plug slot,
  it must automatically set its internal main power fault latch [...].
  The main power fault latch is cleared when software turns off power to
  the hot-plug slot.

The stickiness used to cause interrupt storms and infinite loops which
were fixed in 2009 by commits 5651c48cfafe ("PCI pciehp: fix power fault
interrupt storm problem") and 99f0169c17f3 ("PCI: pciehp: enable
software notification on empty slots").

Unfortunately in 2020 the infinite loop issue was inadvertently
reintroduced by commit 8edf5332c393 ("PCI: pciehp: Fix MSI interrupt
race"):  The hardirq handler pciehp_isr() clears the PFD bit until
pciehp's power_fault_detected flag is set.  That happens in the IRQ
thread pciehp_ist(), which never learns of the event because the hardirq
handler is stuck in an infinite loop.  Fix by setting the
power_fault_detected flag already in the hardirq handler.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214989
Link: https://lore.kernel.org/linux-pci/DM8PR11MB5702255A6A92F735D90A4446868B9@DM8PR11MB5702.namprd11.prod.outlook.com
Fixes: 8edf5332c393 ("PCI: pciehp: Fix MSI interrupt race")
Link: https://lore.kernel.org/r/66eaeef31d4997ceea357ad93259f290ededecfd.1637187226.git.lukas@wunner.de
Reported-by: Joseph Bao <joseph.bao@intel.com>
Tested-by: Joseph Bao <joseph.bao@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v4.19+
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/pciehp_hpc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -642,6 +642,8 @@ read_status:
 	 */
 	if (ctrl->power_fault_detected)
 		status &= ~PCI_EXP_SLTSTA_PFD;
+	else if (status & PCI_EXP_SLTSTA_PFD)
+		ctrl->power_fault_detected = true;
 
 	events |= status;
 	if (!events) {
@@ -651,7 +653,7 @@ read_status:
 	}
 
 	if (status) {
-		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, status);
 
 		/*
 		 * In MSI mode, all event bits must be zero before the port
@@ -725,8 +727,7 @@ static irqreturn_t pciehp_ist(int irq, v
 	}
 
 	/* Check Power Fault Detected */
-	if ((events & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
-		ctrl->power_fault_detected = 1;
+	if (events & PCI_EXP_SLTSTA_PFD) {
 		ctrl_err(ctrl, "Slot(%s): Power fault\n", slot_name(ctrl));
 		pciehp_set_indicators(ctrl, PCI_EXP_SLTCTL_PWR_IND_OFF,
 				      PCI_EXP_SLTCTL_ATTN_IND_ON);


