Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FACC15EA7A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392159AbgBNROD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391667AbgBNQMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:12:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793F22469F;
        Fri, 14 Feb 2020 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696757;
        bh=JH7Jqxn+2yA5s6yASEVbvRqf0qXawno/wfcdV5ZkVDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBFEytFJ5AtKHqFbCjOftOsoFxc4LKexGKDpzwDHgeCZ1LXVrXo+IP27/dvIha3o6
         zg4epty9QAd7msY24Hm319RUjMgkaXRAJTg57BoMIxrA0U+JL8V5IfEBqWPO1/MjXb
         KHqopfQSI5jhejYlfTFBEM5NAOioTGyCINSRLNdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 038/252] s390/pci: Fix possible deadlock in recover_store()
Date:   Fri, 14 Feb 2020 11:08:13 -0500
Message-Id: <20200214161147.15842-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 576c75e36c689bec6a940e807bae27291ab0c0de ]

With zpci_disable() working, lockdep detected a potential deadlock
(lockdep output at the end).

The deadlock is between recovering a PCI function via the

/sys/bus/pci/devices/<dev>/recover

attribute vs powering it off via

/sys/bus/pci/slots/<slot>/power.

The fix is analogous to the changes in commit 0ee223b2e1f6 ("scsi: core:
Avoid that SCSI device removal through sysfs triggers a deadlock")
that fixed a potential deadlock on removing a SCSI device via sysfs.

[  204.830107] ======================================================
[  204.830109] WARNING: possible circular locking dependency detected
[  204.830111] 5.5.0-rc2-06072-gbc03ecc9a672 #6 Tainted: G        W
[  204.830112] ------------------------------------------------------
[  204.830113] bash/1034 is trying to acquire lock:
[  204.830115] 0000000192a1a610 (kn->count#200){++++}, at: kernfs_remove_by_name_ns+0x5c/0xa8
[  204.830122]
               but task is already holding lock:
[  204.830123] 00000000c16134a8 (pci_rescan_remove_lock){+.+.}, at: pci_stop_and_remove_bus_device_locked+0x26/0x48
[  204.830128]
               which lock already depends on the new lock.

[  204.830129]
               the existing dependency chain (in reverse order) is:
[  204.830130]
               -> #1 (pci_rescan_remove_lock){+.+.}:
[  204.830134]        validate_chain+0x93a/0xd08
[  204.830136]        __lock_acquire+0x4ae/0x9d0
[  204.830137]        lock_acquire+0x114/0x280
[  204.830140]        __mutex_lock+0xa2/0x960
[  204.830142]        mutex_lock_nested+0x32/0x40
[  204.830145]        recover_store+0x4c/0xa8
[  204.830147]        kernfs_fop_write+0xe6/0x218
[  204.830151]        vfs_write+0xb0/0x1b8
[  204.830152]        ksys_write+0x6c/0xf8
[  204.830154]        system_call+0xd8/0x2d8
[  204.830155]
               -> #0 (kn->count#200){++++}:
[  204.830187]        check_noncircular+0x1e6/0x240
[  204.830189]        check_prev_add+0xfc/0xdb0
[  204.830190]        validate_chain+0x93a/0xd08
[  204.830192]        __lock_acquire+0x4ae/0x9d0
[  204.830193]        lock_acquire+0x114/0x280
[  204.830194]        __kernfs_remove.part.0+0x2e4/0x360
[  204.830196]        kernfs_remove_by_name_ns+0x5c/0xa8
[  204.830198]        remove_files.isra.0+0x4c/0x98
[  204.830199]        sysfs_remove_group+0x66/0xc8
[  204.830201]        sysfs_remove_groups+0x46/0x68
[  204.830204]        device_remove_attrs+0x52/0x90
[  204.830207]        device_del+0x182/0x418
[  204.830208]        pci_remove_bus_device+0x8a/0x130
[  204.830210]        pci_stop_and_remove_bus_device_locked+0x3a/0x48
[  204.830212]        disable_slot+0x68/0x100
[  204.830213]        power_write_file+0x7c/0x130
[  204.830215]        kernfs_fop_write+0xe6/0x218
[  204.830217]        vfs_write+0xb0/0x1b8
[  204.830218]        ksys_write+0x6c/0xf8
[  204.830220]        system_call+0xd8/0x2d8
[  204.830221]
               other info that might help us debug this:

[  204.830223]  Possible unsafe locking scenario:

[  204.830224]        CPU0                    CPU1
[  204.830225]        ----                    ----
[  204.830226]   lock(pci_rescan_remove_lock);
[  204.830227]                                lock(kn->count#200);
[  204.830229]                                lock(pci_rescan_remove_lock);
[  204.830231]   lock(kn->count#200);
[  204.830233]
                *** DEADLOCK ***

[  204.830234] 4 locks held by bash/1034:
[  204.830235]  #0: 00000001b6fbc498 (sb_writers#4){.+.+}, at: vfs_write+0x158/0x1b8
[  204.830239]  #1: 000000018c9f5090 (&of->mutex){+.+.}, at: kernfs_fop_write+0xaa/0x218
[  204.830242]  #2: 00000001f7da0810 (kn->count#235){.+.+}, at: kernfs_fop_write+0xb6/0x218
[  204.830245]  #3: 00000000c16134a8 (pci_rescan_remove_lock){+.+.}, at: pci_stop_and_remove_bus_device_locked+0x26/0x48
[  204.830248]
               stack backtrace:
[  204.830250] CPU: 2 PID: 1034 Comm: bash Tainted: G        W         5.5.0-rc2-06072-gbc03ecc9a672 #6
[  204.830252] Hardware name: IBM 8561 T01 703 (LPAR)
[  204.830253] Call Trace:
[  204.830257]  [<00000000c05e10c0>] show_stack+0x88/0xf0
[  204.830260]  [<00000000c112dca4>] dump_stack+0xa4/0xe0
[  204.830261]  [<00000000c0694c06>] check_noncircular+0x1e6/0x240
[  204.830263]  [<00000000c0695bec>] check_prev_add+0xfc/0xdb0
[  204.830264]  [<00000000c06971da>] validate_chain+0x93a/0xd08
[  204.830266]  [<00000000c06994c6>] __lock_acquire+0x4ae/0x9d0
[  204.830267]  [<00000000c069867c>] lock_acquire+0x114/0x280
[  204.830269]  [<00000000c09ca15c>] __kernfs_remove.part.0+0x2e4/0x360
[  204.830270]  [<00000000c09cb5c4>] kernfs_remove_by_name_ns+0x5c/0xa8
[  204.830272]  [<00000000c09cee14>] remove_files.isra.0+0x4c/0x98
[  204.830274]  [<00000000c09cf2ae>] sysfs_remove_group+0x66/0xc8
[  204.830276]  [<00000000c09cf356>] sysfs_remove_groups+0x46/0x68
[  204.830278]  [<00000000c0e3dfe2>] device_remove_attrs+0x52/0x90
[  204.830280]  [<00000000c0e40382>] device_del+0x182/0x418
[  204.830281]  [<00000000c0dcfd7a>] pci_remove_bus_device+0x8a/0x130
[  204.830283]  [<00000000c0dcfe92>] pci_stop_and_remove_bus_device_locked+0x3a/0x48
[  204.830285]  [<00000000c0de7190>] disable_slot+0x68/0x100
[  204.830286]  [<00000000c0de6514>] power_write_file+0x7c/0x130
[  204.830288]  [<00000000c09cc846>] kernfs_fop_write+0xe6/0x218
[  204.830290]  [<00000000c08f3480>] vfs_write+0xb0/0x1b8
[  204.830291]  [<00000000c08f378c>] ksys_write+0x6c/0xf8
[  204.830293]  [<00000000c1154374>] system_call+0xd8/0x2d8
[  204.830294] INFO: lockdep is turned off.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_sysfs.c | 63 ++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/arch/s390/pci/pci_sysfs.c b/arch/s390/pci/pci_sysfs.c
index 430c14b006d17..0e11fc023fe78 100644
--- a/arch/s390/pci/pci_sysfs.c
+++ b/arch/s390/pci/pci_sysfs.c
@@ -13,6 +13,8 @@
 #include <linux/stat.h>
 #include <linux/pci.h>
 
+#include "../../../drivers/pci/pci.h"
+
 #include <asm/sclp.h>
 
 #define zpci_attr(name, fmt, member)					\
@@ -40,31 +42,50 @@ zpci_attr(segment3, "0x%02x\n", pfip[3]);
 static ssize_t recover_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
+	struct kernfs_node *kn;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct zpci_dev *zdev = to_zpci(pdev);
-	int ret;
-
-	if (!device_remove_file_self(dev, attr))
-		return count;
-
+	int ret = 0;
+
+	/* Can't use device_remove_self() here as that would lead us to lock
+	 * the pci_rescan_remove_lock while holding the device' kernfs lock.
+	 * This would create a possible deadlock with disable_slot() which is
+	 * not directly protected by the device' kernfs lock but takes it
+	 * during the device removal which happens under
+	 * pci_rescan_remove_lock.
+	 *
+	 * This is analogous to sdev_store_delete() in
+	 * drivers/scsi/scsi_sysfs.c
+	 */
+	kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
+	WARN_ON_ONCE(!kn);
+	/* device_remove_file() serializes concurrent calls ignoring all but
+	 * the first
+	 */
+	device_remove_file(dev, attr);
+
+	/* A concurrent call to recover_store() may slip between
+	 * sysfs_break_active_protection() and the sysfs file removal.
+	 * Once it unblocks from pci_lock_rescan_remove() the original pdev
+	 * will already be removed.
+	 */
 	pci_lock_rescan_remove();
-	pci_stop_and_remove_bus_device(pdev);
-	ret = zpci_disable_device(zdev);
-	if (ret)
-		goto error;
-
-	ret = zpci_enable_device(zdev);
-	if (ret)
-		goto error;
-
-	pci_rescan_bus(zdev->bus);
+	if (pci_dev_is_added(pdev)) {
+		pci_stop_and_remove_bus_device(pdev);
+		ret = zpci_disable_device(zdev);
+		if (ret)
+			goto out;
+
+		ret = zpci_enable_device(zdev);
+		if (ret)
+			goto out;
+		pci_rescan_bus(zdev->bus);
+	}
+out:
 	pci_unlock_rescan_remove();
-
-	return count;
-
-error:
-	pci_unlock_rescan_remove();
-	return ret;
+	if (kn)
+		sysfs_unbreak_active_protection(kn);
+	return ret ? ret : count;
 }
 static DEVICE_ATTR_WO(recover);
 
-- 
2.20.1

