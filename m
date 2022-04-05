Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABAE4F28E1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiDEIXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiDEIRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BC6B1890;
        Tue,  5 Apr 2022 01:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 413F3617ED;
        Tue,  5 Apr 2022 08:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1CAC385A2;
        Tue,  5 Apr 2022 08:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145933;
        bh=nn9xz3BbiAg4us4RXtlG1XhnDlzd4HrU92Bb6ZrePGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZkP+Wn4j2aH9oFt8UjSZ5/UQHK8C47fhOlolGUxG8CwjoTZlNzhOl943tTB0x2mP
         8iR4tNEn1sP3qSUc6pxrAWTI7r/0wP2kZvYWgxCjii9TeaC5gl8PxX02A+JamilntU
         /cuWvV76O1OH+e2BJuEvWI6nxTULCUbbjTIm5X4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <abhsahu@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0581/1126] vfio/pci: wake-up devices around reset functions
Date:   Tue,  5 Apr 2022 09:22:08 +0200
Message-Id: <20220405070424.686772738@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Abhishek Sahu <abhsahu@nvidia.com>

[ Upstream commit 26a17b12d7f3dd8a7aa45a290e5b46e9cc775ddf ]

If 'vfio_pci_core_device::needs_pm_restore' is set (PCI device does
not have No_Soft_Reset bit set in its PMCSR config register), then the
current PCI state will be saved locally in
'vfio_pci_core_device::pm_save' during D0->D3hot transition and same
will be restored back during D3hot->D0 transition. For reset-related
functionalities, vfio driver uses PCI reset API's. These
API's internally change the PCI power state back to D0 first if
the device power state is non-D0. This state change to D0 will happen
without the involvement of vfio driver.

Let's consider the following example:

1. The device is in D3hot.
2. User invokes VFIO_DEVICE_RESET ioctl.
3. pci_try_reset_function() will be called which internally
   invokes pci_dev_save_and_disable().
4. pci_set_power_state(dev, PCI_D0) will be called first.
5. pci_save_state() will happen then.

Now, for the devices which has NoSoftRst-, the pci_set_power_state()
can trigger soft reset and the original PCI config state will be lost
at step (4) and this state cannot be restored again. This original PCI
state can include any setting which is performed by SBIOS or host
linux kernel (for example LTR, ASPM L1 substates, etc.). When this
soft reset will be triggered, then all these settings will be reset,
and the device state saved at step (5) will also have this setting
cleared so it cannot be restored. Since the vfio driver only exposes
limited PCI capabilities to its user, so the vfio driver user also
won't have the option to save and restore these capabilities state
either and these original settings will be permanently lost.

For pci_reset_bus() also, we can have the above situation.
The other functions/devices can be in D3hot and the reset will change
the power state of all devices to D0 without the involvement of vfio
driver.

So, before calling any reset-related API's, we need to make sure that
the device state is D0. This is mainly to preserve the state around
soft reset.

For vfio_pci_core_disable(), we use __pci_reset_function_locked()
which internally can use pci_pm_reset() for the function reset.
pci_pm_reset() requires the device power state to be in D0, otherwise
it returns error.

This patch changes the device power state to D0 by invoking
vfio_pci_set_power_state() explicitly before calling any reset related
API's.

Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
Link: https://lore.kernel.org/r/20220217122107.22434-3-abhsahu@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 48 ++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 87b288affc13..2e6409cc11ad 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -335,6 +335,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	/* For needs_reset */
 	lockdep_assert_held(&vdev->vdev.dev_set->lock);
 
+	/*
+	 * This function can be invoked while the power state is non-D0.
+	 * This function calls __pci_reset_function_locked() which internally
+	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
+	 * fail if the power state is non-D0. Also, for the devices which
+	 * have NoSoftRst-, the reset function can cause the PCI config space
+	 * reset without restoring the original state (saved locally in
+	 * 'vdev->pm_save').
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
 
@@ -934,6 +945,19 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return -EINVAL;
 
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
+
+		/*
+		 * This function can be invoked while the power state is non-D0.
+		 * If pci_try_reset_function() has been called while the power
+		 * state is non-D0, then pci_try_reset_function() will
+		 * internally set the power state to D0 without vfio driver
+		 * involvement. For the devices which have NoSoftRst-, the
+		 * reset function can cause the PCI config space reset without
+		 * restoring the original state (saved locally in
+		 * 'vdev->pm_save').
+		 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
+
 		ret = pci_try_reset_function(vdev->pdev);
 		up_write(&vdev->memory_lock);
 
@@ -2068,6 +2092,18 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	}
 	cur_mem = NULL;
 
+	/*
+	 * The pci_reset_bus() will reset all the devices in the bus.
+	 * The power state can be non-D0 for some of the devices in the bus.
+	 * For these devices, the pci_reset_bus() will internally set
+	 * the power state to D0 without vfio driver involvement.
+	 * For the devices which have NoSoftRst-, the reset function can
+	 * cause the PCI config space reset without restoring the original
+	 * state (saved locally in 'vdev->pm_save').
+	 */
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+		vfio_pci_set_power_state(cur, PCI_D0);
+
 	ret = pci_reset_bus(pdev);
 
 err_undo:
@@ -2121,6 +2157,18 @@ static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 	if (!pdev)
 		return false;
 
+	/*
+	 * The pci_reset_bus() will reset all the devices in the bus.
+	 * The power state can be non-D0 for some of the devices in the bus.
+	 * For these devices, the pci_reset_bus() will internally set
+	 * the power state to D0 without vfio driver involvement.
+	 * For the devices which have NoSoftRst-, the reset function can
+	 * cause the PCI config space reset without restoring the original
+	 * state (saved locally in 'vdev->pm_save').
+	 */
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+		vfio_pci_set_power_state(cur, PCI_D0);
+
 	ret = pci_reset_bus(pdev);
 	if (ret)
 		return false;
-- 
2.34.1



