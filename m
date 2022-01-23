Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2B0497351
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbiAWRBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiAWRBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:01:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F872C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 09:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF00660FBB
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C28EC340E2;
        Sun, 23 Jan 2022 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642957260;
        bh=3hPrtZ4duEaAaRc5rXeOoeMild0LbhjeD7FoU3kw9AM=;
        h=Subject:To:Cc:From:Date:From;
        b=aoXGOFN42lrChpOaalrSMhlUJ7jhd4PJBbmVzMcrq2yhtE0luPw3uAwmS7n8+IvCp
         DmD/ZH7jxfrhZXa+vQPOvMVnA0DiIUSXPHQAFvd9BLzl5ix+proy43JDruZFlgdLoW
         Vcb4xMWGRXZPNgTVrOZt0Fg+C6+RuGHmIKm2P0r8=
Subject: FAILED: patch "[PATCH] PCI: pciehp: Fix infinite loop in IRQ handler upon power" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, bhelgaas@google.com, joseph.bao@intel.com,
        stuart.w.hayes@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 18:00:57 +0100
Message-ID: <16429572572420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23584c1ed3e15a6f4bfab8dc5a88d94ab929ee12 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 17 Nov 2021 23:22:09 +0100
Subject: [PATCH] PCI: pciehp: Fix infinite loop in IRQ handler upon power
 fault

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

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 83a0fa119cae..9535c61cbff3 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -642,6 +642,8 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	 */
 	if (ctrl->power_fault_detected)
 		status &= ~PCI_EXP_SLTSTA_PFD;
+	else if (status & PCI_EXP_SLTSTA_PFD)
+		ctrl->power_fault_detected = true;
 
 	events |= status;
 	if (!events) {
@@ -651,7 +653,7 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	}
 
 	if (status) {
-		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, status);
 
 		/*
 		 * In MSI mode, all event bits must be zero before the port
@@ -725,8 +727,7 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
 	}
 
 	/* Check Power Fault Detected */
-	if ((events & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
-		ctrl->power_fault_detected = 1;
+	if (events & PCI_EXP_SLTSTA_PFD) {
 		ctrl_err(ctrl, "Slot(%s): Power fault\n", slot_name(ctrl));
 		pciehp_set_indicators(ctrl, PCI_EXP_SLTCTL_PWR_IND_OFF,
 				      PCI_EXP_SLTCTL_ATTN_IND_ON);

