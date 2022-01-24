Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31FD498EEC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357219AbiAXTth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58796 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347814AbiAXThj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:37:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E84F3B80FA1;
        Mon, 24 Jan 2022 19:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259BCC340E5;
        Mon, 24 Jan 2022 19:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053052;
        bh=rkWayZZC0RqM6hI7nNtYbd4ASzlnGge0fvI4FQpwk0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYoheFsO34MuS7+mv9OZFCG+sXXUmpSlrtIMW0yFyu68J9XNQHIegFvXmjhGnE817
         vNwiO9taRJkwkdSBau8mJi8gFfc8/luvOSe/BOmMpWA4SoZa5Qso+XrO+ZnyukwyVd
         0g35wseyLl4B/NNQJkT+1SKfnWwb37LOAWTydHVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Bao <joseph.bao@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH 5.4 260/320] PCI: pciehp: Fix infinite loop in IRQ handler upon power fault
Date:   Mon, 24 Jan 2022 19:44:04 +0100
Message-Id: <20220124184002.827563143@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -577,6 +577,8 @@ read_status:
 	 */
 	if (ctrl->power_fault_detected)
 		status &= ~PCI_EXP_SLTSTA_PFD;
+	else if (status & PCI_EXP_SLTSTA_PFD)
+		ctrl->power_fault_detected = true;
 
 	events |= status;
 	if (!events) {
@@ -586,7 +588,7 @@ read_status:
 	}
 
 	if (status) {
-		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, status);
 
 		/*
 		 * In MSI mode, all event bits must be zero before the port
@@ -660,8 +662,7 @@ static irqreturn_t pciehp_ist(int irq, v
 	}
 
 	/* Check Power Fault Detected */
-	if ((events & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
-		ctrl->power_fault_detected = 1;
+	if (events & PCI_EXP_SLTSTA_PFD) {
 		ctrl_err(ctrl, "Slot(%s): Power fault\n", slot_name(ctrl));
 		pciehp_set_indicators(ctrl, PCI_EXP_SLTCTL_PWR_IND_OFF,
 				      PCI_EXP_SLTCTL_ATTN_IND_ON);


