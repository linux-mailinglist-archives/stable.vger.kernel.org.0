Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DFE6B4614
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjCJOj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjCJOjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:39:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B4FEBDAA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C1661771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A861C4339C;
        Fri, 10 Mar 2023 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459187;
        bh=HjBw23Wn71jMunDDuuOaUqGou28/iO2o5DBk8VKUm8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/HVEsyGkmQ+HEWnbB24eDXOzwG+zXMbaGquAzw587//ftZOjeoDLatkd9bPEsIyU
         Zj4JMVXlv/vmfimr9p2x7lyb42dsQun2w/0JsZehQ7X0TI9nssTaNrWSbsHy/FHnvO
         x5A+2x1GFB4U1mdNMIANcHoxPvXOlNS5Vbgmdt9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Anatoli Antonovitch <anatoli.antonovitch@amd.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.4 277/357] PCI: hotplug: Allow marking devices as disconnected during bind/unbind
Date:   Fri, 10 Mar 2023 14:39:26 +0100
Message-Id: <20230310133746.978472679@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 74ff8864cc842be994853095dba6db48e716400a upstream.

On surprise removal, pciehp_unconfigure_device() and acpiphp's
trim_stale_devices() call pci_dev_set_disconnected() to mark removed
devices as permanently offline.  Thereby, the PCI core and drivers know
to skip device accesses.

However pci_dev_set_disconnected() takes the device_lock and thus waits for
a concurrent driver bind or unbind to complete.  As a result, the driver's
->probe and ->remove hooks have no chance to learn that the device is gone.

That doesn't make any sense, so drop the device_lock and instead use atomic
xchg() and cmpxchg() operations to update the device state.

As a byproduct, an AB-BA deadlock reported by Anatoli is fixed which occurs
on surprise removal with AER concurrently performing a bus reset.

AER bus reset:

  INFO: task irq/26-aerdrv:95 blocked for more than 120 seconds.
  Tainted: G        W          6.2.0-rc3-custom-norework-jan11+
  schedule
  rwsem_down_write_slowpath
  down_write_nested
  pciehp_reset_slot                      # acquires reset_lock
  pci_reset_hotplug_slot
  pci_slot_reset                         # acquires device_lock
  pci_bus_error_reset
  aer_root_reset
  pcie_do_recovery
  aer_process_err_devices
  aer_isr

pciehp surprise removal:

  INFO: task irq/26-pciehp:96 blocked for more than 120 seconds.
  Tainted: G        W          6.2.0-rc3-custom-norework-jan11+
  schedule_preempt_disabled
  __mutex_lock
  mutex_lock_nested
  pci_dev_set_disconnected               # acquires device_lock
  pci_walk_bus
  pciehp_unconfigure_device
  pciehp_disable_slot
  pciehp_handle_presence_or_link_change
  pciehp_ist                             # acquires reset_lock

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215590
Fixes: a6bd101b8f84 ("PCI: Unify device inaccessible")
Link: https://lore.kernel.org/r/3dc88ea82bdc0e37d9000e413d5ebce481cbd629.1674205689.git.lukas@wunner.de
Reported-by: Anatoli Antonovitch <anatoli.antonovitch@amd.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v4.20+
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.h |   43 +++++++++++++------------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -346,53 +346,36 @@ struct pci_sriov {
  * @dev - pci device to set new error_state
  * @new - the state we want dev to be in
  *
- * Must be called with device_lock held.
+ * If the device is experiencing perm_failure, it has to remain in that state.
+ * Any other transition is allowed.
  *
  * Returns true if state has been changed to the requested state.
  */
 static inline bool pci_dev_set_io_state(struct pci_dev *dev,
 					pci_channel_state_t new)
 {
-	bool changed = false;
+	pci_channel_state_t old;
 
-	device_lock_assert(&dev->dev);
 	switch (new) {
 	case pci_channel_io_perm_failure:
-		switch (dev->error_state) {
-		case pci_channel_io_frozen:
-		case pci_channel_io_normal:
-		case pci_channel_io_perm_failure:
-			changed = true;
-			break;
-		}
-		break;
+		xchg(&dev->error_state, pci_channel_io_perm_failure);
+		return true;
 	case pci_channel_io_frozen:
-		switch (dev->error_state) {
-		case pci_channel_io_frozen:
-		case pci_channel_io_normal:
-			changed = true;
-			break;
-		}
-		break;
+		old = cmpxchg(&dev->error_state, pci_channel_io_normal,
+			      pci_channel_io_frozen);
+		return old != pci_channel_io_perm_failure;
 	case pci_channel_io_normal:
-		switch (dev->error_state) {
-		case pci_channel_io_frozen:
-		case pci_channel_io_normal:
-			changed = true;
-			break;
-		}
-		break;
+		old = cmpxchg(&dev->error_state, pci_channel_io_frozen,
+			      pci_channel_io_normal);
+		return old != pci_channel_io_perm_failure;
+	default:
+		return false;
 	}
-	if (changed)
-		dev->error_state = new;
-	return changed;
 }
 
 static inline int pci_dev_set_disconnected(struct pci_dev *dev, void *unused)
 {
-	device_lock(&dev->dev);
 	pci_dev_set_io_state(dev, pci_channel_io_perm_failure);
-	device_unlock(&dev->dev);
 
 	return 0;
 }


