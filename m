Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507B149A9CF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323630AbiAYD3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349131AbiAXVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443D7C068091;
        Mon, 24 Jan 2022 12:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02655B810BD;
        Mon, 24 Jan 2022 20:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16602C340E5;
        Mon, 24 Jan 2022 20:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054680;
        bh=In9dkfJoPO9DJLb0Q0aCQlLwXEl9HC8izXvQvUn3oH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMjHn/ca4qFEkVVqwl8Mp3wzQ/ccj0q74E4KF49f3XefM14VRDUKjaVdqJIjG3S1T
         w7c35gmBTKWRabLx62noL3uuH+mmUEkEjt0X4SY0r/Lc80jgWeE14JMAMioLh8QntY
         RVOo42cdp31gAiJIy7F05Y3xa8ugXp5lfmaBUJB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.10 461/563] PCI: pciehp: Use down_read/write_nested(reset_lock) to fix lockdep errors
Date:   Mon, 24 Jan 2022 19:43:46 +0100
Message-Id: <20220124184040.408497028@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 085a9f43433f30cbe8a1ade62d9d7827c3217f4d upstream.

Use down_read_nested() and down_write_nested() when taking the
ctrl->reset_lock rw-sem, passing the number of PCIe hotplug controllers in
the path to the PCI root bus as lock subclass parameter.

This fixes the following false-positive lockdep report when unplugging a
Lenovo X1C8 from a Lenovo 2nd gen TB3 dock:

  pcieport 0000:06:01.0: pciehp: Slot(1): Link Down
  pcieport 0000:06:01.0: pciehp: Slot(1): Card not present
  ============================================
  WARNING: possible recursive locking detected
  5.16.0-rc2+ #621 Not tainted
  --------------------------------------------
  irq/124-pciehp/86 is trying to acquire lock:
  ffff8e5ac4299ef8 (&ctrl->reset_lock){.+.+}-{3:3}, at: pciehp_check_presence+0x23/0x80

  but task is already holding lock:
  ffff8e5ac4298af8 (&ctrl->reset_lock){.+.+}-{3:3}, at: pciehp_ist+0xf3/0x180

   other info that might help us debug this:
   Possible unsafe locking scenario:

	 CPU0
	 ----
    lock(&ctrl->reset_lock);
    lock(&ctrl->reset_lock);

   *** DEADLOCK ***

   May be due to missing lock nesting notation

  3 locks held by irq/124-pciehp/86:
   #0: ffff8e5ac4298af8 (&ctrl->reset_lock){.+.+}-{3:3}, at: pciehp_ist+0xf3/0x180
   #1: ffffffffa3b024e8 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pciehp_unconfigure_device+0x31/0x110
   #2: ffff8e5ac1ee2248 (&dev->mutex){....}-{3:3}, at: device_release_driver+0x1c/0x40

  stack backtrace:
  CPU: 4 PID: 86 Comm: irq/124-pciehp Not tainted 5.16.0-rc2+ #621
  Hardware name: LENOVO 20U90SIT19/20U90SIT19, BIOS N2WET30W (1.20 ) 08/26/2021
  Call Trace:
   <TASK>
   dump_stack_lvl+0x59/0x73
   __lock_acquire.cold+0xc5/0x2c6
   lock_acquire+0xb5/0x2b0
   down_read+0x3e/0x50
   pciehp_check_presence+0x23/0x80
   pciehp_runtime_resume+0x5c/0xa0
   device_for_each_child+0x45/0x70
   pcie_port_device_runtime_resume+0x20/0x30
   pci_pm_runtime_resume+0xa7/0xc0
   __rpm_callback+0x41/0x110
   rpm_callback+0x59/0x70
   rpm_resume+0x512/0x7b0
   __pm_runtime_resume+0x4a/0x90
   __device_release_driver+0x28/0x240
   device_release_driver+0x26/0x40
   pci_stop_bus_device+0x68/0x90
   pci_stop_bus_device+0x2c/0x90
   pci_stop_and_remove_bus_device+0xe/0x20
   pciehp_unconfigure_device+0x6c/0x110
   pciehp_disable_slot+0x5b/0xe0
   pciehp_handle_presence_or_link_change+0xc3/0x2f0
   pciehp_ist+0x179/0x180

This lockdep warning is triggered because with Thunderbolt, hotplug ports
are nested. When removing multiple devices in a daisy-chain, each hotplug
port's reset_lock may be acquired recursively. It's never the same lock, so
the lockdep splat is a false positive.

Because locks at the same hierarchy level are never acquired recursively, a
per-level lockdep class is sufficient to fix the lockdep warning.

The choice to use one lockdep subclass per pcie-hotplug controller in the
path to the root-bus was made to conserve class keys because their number
is limited and the complexity grows quadratically with number of keys
according to Documentation/locking/lockdep-design.rst.

Link: https://lore.kernel.org/linux-pci/20190402021933.GA2966@mit.edu/
Link: https://lore.kernel.org/linux-pci/de684a28-9038-8fc6-27ca-3f6f2f6400d7@redhat.com/
Link: https://lore.kernel.org/r/20211217141709.379663-1-hdegoede@redhat.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208855
Reported-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/pciehp.h      |    3 +++
 drivers/pci/hotplug/pciehp_core.c |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c  |   21 ++++++++++++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -72,6 +72,8 @@ extern int pciehp_poll_time;
  * @reset_lock: prevents access to the Data Link Layer Link Active bit in the
  *	Link Status register and to the Presence Detect State bit in the Slot
  *	Status register during a slot reset which may cause them to flap
+ * @depth: Number of additional hotplug ports in the path to the root bus,
+ *	used as lock subclass for @reset_lock
  * @ist_running: flag to keep user request waiting while IRQ thread is running
  * @request_result: result of last user request submitted to the IRQ thread
  * @requester: wait queue to wake up on completion of user request,
@@ -103,6 +105,7 @@ struct controller {
 
 	struct hotplug_slot hotplug_slot;	/* hotplug core interface */
 	struct rw_semaphore reset_lock;
+	unsigned int depth;
 	unsigned int ist_running;
 	int request_result;
 	wait_queue_head_t requester;
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -166,7 +166,7 @@ static void pciehp_check_presence(struct
 {
 	int occupied;
 
-	down_read(&ctrl->reset_lock);
+	down_read_nested(&ctrl->reset_lock, ctrl->depth);
 	mutex_lock(&ctrl->state_lock);
 
 	occupied = pciehp_card_present_or_link_active(ctrl);
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -583,7 +583,7 @@ static void pciehp_ignore_dpc_link_chang
 	 * the corresponding link change may have been ignored above.
 	 * Synthesize it to ensure that it is acted on.
 	 */
-	down_read(&ctrl->reset_lock);
+	down_read_nested(&ctrl->reset_lock, ctrl->depth);
 	if (!pciehp_check_link_active(ctrl))
 		pciehp_request(ctrl, PCI_EXP_SLTSTA_DLLSC);
 	up_read(&ctrl->reset_lock);
@@ -746,7 +746,7 @@ static irqreturn_t pciehp_ist(int irq, v
 	 * Disable requests have higher priority than Presence Detect Changed
 	 * or Data Link Layer State Changed events.
 	 */
-	down_read(&ctrl->reset_lock);
+	down_read_nested(&ctrl->reset_lock, ctrl->depth);
 	if (events & DISABLE_SLOT)
 		pciehp_handle_disable_request(ctrl);
 	else if (events & (PCI_EXP_SLTSTA_PDC | PCI_EXP_SLTSTA_DLLSC))
@@ -880,7 +880,7 @@ int pciehp_reset_slot(struct hotplug_slo
 	if (probe)
 		return 0;
 
-	down_write(&ctrl->reset_lock);
+	down_write_nested(&ctrl->reset_lock, ctrl->depth);
 
 	if (!ATTN_BUTTN(ctrl)) {
 		ctrl_mask |= PCI_EXP_SLTCTL_PDCE;
@@ -936,6 +936,20 @@ static inline void dbg_ctrl(struct contr
 
 #define FLAG(x, y)	(((x) & (y)) ? '+' : '-')
 
+static inline int pcie_hotplug_depth(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->bus;
+	int depth = 0;
+
+	while (bus->parent) {
+		bus = bus->parent;
+		if (bus->self && bus->self->is_hotplug_bridge)
+			depth++;
+	}
+
+	return depth;
+}
+
 struct controller *pcie_init(struct pcie_device *dev)
 {
 	struct controller *ctrl;
@@ -949,6 +963,7 @@ struct controller *pcie_init(struct pcie
 		return NULL;
 
 	ctrl->pcie = dev;
+	ctrl->depth = pcie_hotplug_depth(dev->port);
 	pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &slot_cap);
 
 	if (pdev->hotplug_user_indicators)


