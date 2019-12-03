Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC6D111FF8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfLCWlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfLCWlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756D52073C;
        Tue,  3 Dec 2019 22:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412859;
        bh=7h6ndB6QypJdFtbDKJjriaCER95owTAXaqIlv2NDRvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0U5HFKhF1AWmNVoo7dvG1z/kU8353wTWze8WwOUvTavy7wyZ8knfPCNJrRNm5/fWx
         TPtQIuFWPCSHdu4FtpBFitdmz93vBDbZ+6476UJa4IxDmy/4mamciaAec46QVwYfGf
         DzT8GbpzzhzklbWh9OQI6MnX070jcKWyrh+H739A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 008/135] thunderbolt: Fix lockdep circular locking depedency warning
Date:   Tue,  3 Dec 2019 23:34:08 +0100
Message-Id: <20191203213007.242619036@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 6f6709734274aef75058356e029d5e8f86d0d53b ]

When lockdep is enabled, plugging Thunderbolt dock on Dominik's laptop
triggers following splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.3.0-rc6+ #1 Tainted: G                T
  ------------------------------------------------------
  pool-/usr/lib/b/1258 is trying to acquire lock:
  000000005ab0ad43 (pci_rescan_remove_lock){+.+.}, at: authorized_store+0xe8/0x210

  but task is already holding lock:
  00000000bfb796b5 (&tb->lock){+.+.}, at: authorized_store+0x7c/0x210

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (&tb->lock){+.+.}:
         __mutex_lock+0xac/0x9a0
         tb_domain_add+0x2d/0x130
         nhi_probe+0x1dd/0x330
         pci_device_probe+0xd2/0x150
         really_probe+0xee/0x280
         driver_probe_device+0x50/0xc0
         bus_for_each_drv+0x84/0xd0
         __device_attach+0xe4/0x150
         pci_bus_add_device+0x4e/0x70
         pci_bus_add_devices+0x2e/0x66
         pci_bus_add_devices+0x59/0x66
         pci_bus_add_devices+0x59/0x66
         enable_slot+0x344/0x450
         acpiphp_check_bridge.part.0+0x119/0x150
         acpiphp_hotplug_notify+0xaa/0x140
         acpi_device_hotplug+0xa2/0x3f0
         acpi_hotplug_work_fn+0x1a/0x30
         process_one_work+0x234/0x580
         worker_thread+0x50/0x3b0
         kthread+0x10a/0x140
         ret_from_fork+0x3a/0x50

  -> #0 (pci_rescan_remove_lock){+.+.}:
         __lock_acquire+0xe54/0x1ac0
         lock_acquire+0xb8/0x1b0
         __mutex_lock+0xac/0x9a0
         authorized_store+0xe8/0x210
         kernfs_fop_write+0x125/0x1b0
         vfs_write+0xc2/0x1d0
         ksys_write+0x6c/0xf0
         do_syscall_64+0x50/0x180
         entry_SYSCALL_64_after_hwframe+0x49/0xbe

  other info that might help us debug this:
   Possible unsafe locking scenario:
         CPU0                    CPU1
         ----                    ----
    lock(&tb->lock);
                                 lock(pci_rescan_remove_lock);
                                 lock(&tb->lock);
    lock(pci_rescan_remove_lock);

   *** DEADLOCK ***
  5 locks held by pool-/usr/lib/b/1258:
   #0: 000000003df1a1ad (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x4d/0x60
   #1: 0000000095a40b02 (sb_writers#6){.+.+}, at: vfs_write+0x185/0x1d0
   #2: 0000000017a7d714 (&of->mutex){+.+.}, at: kernfs_fop_write+0xf2/0x1b0
   #3: 000000004f262981 (kn->count#208){.+.+}, at: kernfs_fop_write+0xfa/0x1b0
   #4: 00000000bfb796b5 (&tb->lock){+.+.}, at: authorized_store+0x7c/0x210

  stack backtrace:
  CPU: 0 PID: 1258 Comm: pool-/usr/lib/b Tainted: G                T 5.3.0-rc6+ #1

On an system using ACPI hotplug the host router gets hotplugged first and then
the firmware starts sending notifications about connected devices so the above
scenario should not happen in reality. However, after taking a second
look at commit a03e828915c0 ("thunderbolt: Serialize PCIe tunnel
creation with PCI rescan") that introduced the locking, I don't think it
is actually correct. It may have cured the symptom but probably the real
root cause was somewhere closer to PCI stack and possibly is already
fixed with recent kernels. I also tried to reproduce the original issue
with the commit reverted but could not.

So to keep lockdep happy and the code bit less complex drop calls to
pci_lock_rescan_remove()/pci_unlock_rescan_remove() in
tb_switch_set_authorized() effectively reverting a03e828915c0.

Link: https://lkml.org/lkml/2019/8/30/513
Fixes: a03e828915c0 ("thunderbolt: Serialize PCIe tunnel creation with PCI rescan")
Reported-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 00daf5a7f46a5..28395c3dcfed5 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1025,13 +1025,6 @@ static int tb_switch_set_authorized(struct tb_switch *sw, unsigned int val)
 	if (sw->authorized)
 		goto unlock;
 
-	/*
-	 * Make sure there is no PCIe rescan ongoing when a new PCIe
-	 * tunnel is created. Otherwise the PCIe rescan code might find
-	 * the new tunnel too early.
-	 */
-	pci_lock_rescan_remove();
-
 	switch (val) {
 	/* Approve switch */
 	case 1:
@@ -1051,8 +1044,6 @@ static int tb_switch_set_authorized(struct tb_switch *sw, unsigned int val)
 		break;
 	}
 
-	pci_unlock_rescan_remove();
-
 	if (!ret) {
 		sw->authorized = val;
 		/* Notify status change to the userspace */
-- 
2.20.1



