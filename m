Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A831C354C34
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 07:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243785AbhDFFU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 01:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243784AbhDFFU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 01:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA94613A7;
        Tue,  6 Apr 2021 05:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617686422;
        bh=3NcBaEoWjlVSrVBe7hD6rG6bz0CN3bQZ4ZiVM5LVJ5c=;
        h=Subject:To:From:Date:From;
        b=Yv01fuPsrnT8YNPhmO4mBln8pEjhzB2dN8STnnfvV2RMmfGHJNJdg/fHh+kkTLR+W
         rGJEQtd6oNYLZc5bcsojAWfwa8rxnsoCNaPzXCzBAByZwDTly0GNgtrMvnqPdRaaMF
         TXuddDOOMYPqTlYEJUT8aBJNxXE0DhRFjvq5fVEY=
Subject: patch "misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct" added to char-misc-next
To:     penguin-kernel@I-love.SAKURA.ne.jp, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Apr 2021 07:20:19 +0200
Message-ID: <16176864192548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 376565b9717c30cd58ad33860fa42697615fa2e4 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 2 Apr 2021 21:17:41 +0900
Subject: misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct

KMSAN complains that the vmci_use_ppn64() == false path in
vmci_dbell_register_notification_bitmap() left upper 32bits of
bitmap_set_msg.bitmap_ppn64 member uninitialized.

  =====================================================
  BUG: KMSAN: uninit-value in kmsan_check_memory+0xd/0x10
  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.11.0-rc7+ #4
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
  Call Trace:
   dump_stack+0x21c/0x280
   kmsan_report+0xfb/0x1e0
   kmsan_internal_check_memory+0x484/0x520
   kmsan_check_memory+0xd/0x10
   iowrite8_rep+0x86/0x380
   vmci_send_datagram+0x150/0x280
   vmci_dbell_register_notification_bitmap+0x133/0x1e0
   vmci_guest_probe_device+0xcab/0x1e70
   pci_device_probe+0xab3/0xe70
   really_probe+0xd16/0x24d0
   driver_probe_device+0x29d/0x3a0
   device_driver_attach+0x25a/0x490
   __driver_attach+0x78c/0x840
   bus_for_each_dev+0x210/0x340
   driver_attach+0x89/0xb0
   bus_add_driver+0x677/0xc40
   driver_register+0x485/0x8e0
   __pci_register_driver+0x1ff/0x350
   vmci_guest_init+0x3e/0x41
   vmci_drv_init+0x1d6/0x43f
   do_one_initcall+0x39c/0x9a0
   do_initcall_level+0x1d7/0x259
   do_initcalls+0x127/0x1cb
   do_basic_setup+0x33/0x36
   kernel_init_freeable+0x29a/0x3ed
   kernel_init+0x1f/0x840
   ret_from_fork+0x1f/0x30

  Local variable ----bitmap_set_msg@vmci_dbell_register_notification_bitmap created at:
   vmci_dbell_register_notification_bitmap+0x50/0x1e0
   vmci_dbell_register_notification_bitmap+0x50/0x1e0

  Bytes 28-31 of 32 are uninitialized
  Memory access of size 32 starts at ffff88810098f570
  =====================================================

Fixes: 83e2ec765be03e8a ("VMCI: doorbell implementation.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/20210402121742.3917-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_doorbell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_doorbell.c b/drivers/misc/vmw_vmci/vmci_doorbell.c
index 345addd9306d..fa8a7fce4481 100644
--- a/drivers/misc/vmw_vmci/vmci_doorbell.c
+++ b/drivers/misc/vmw_vmci/vmci_doorbell.c
@@ -326,7 +326,7 @@ int vmci_dbell_host_context_notify(u32 src_cid, struct vmci_handle handle)
 bool vmci_dbell_register_notification_bitmap(u64 bitmap_ppn)
 {
 	int result;
-	struct vmci_notify_bm_set_msg bitmap_set_msg;
+	struct vmci_notify_bm_set_msg bitmap_set_msg = { };
 
 	bitmap_set_msg.hdr.dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 						  VMCI_SET_NOTIFY_BITMAP);
-- 
2.31.1


