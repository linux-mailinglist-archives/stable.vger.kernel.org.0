Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F41A9C05
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896875AbgDOLTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:19:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36353 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896868AbgDOLTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:19:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 948B65C01C4;
        Wed, 15 Apr 2020 07:19:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=McoPY7
        DoeWYeSP/HXtXlOtlLcp0o91UASelKm8upAy0=; b=lVEqVRZOP5aB/oexYAI9W5
        DksS45+DCOIfj7Cx6gE5pW0pEVJSxs/UV2BvyrBVdRAenSFLcac1bSVn0blmVIKh
        Ndw01UIKKL18u65rAVi/7BNkX0uGjKL9xuZDHFfOo78XiQuNZ7KyYypnA43qzjC2
        wPjGQay7b9TvCPM3HyNC+hKcbLC2YKDZOD/HILcDzge0R5eAdHJtTlPhRsj27KXn
        hQ5Xv/XGZbValobXimRdSJGEA6s/ftmrrFoHRIH2fTz812qcR1jpRbwgfja5+Y2c
        XeRIoAX/fYlWrrkxzsgrisc/WJR8nSq3Yz5POmC8fwhJdP0MhzeP38tFGtz0dQuw
        ==
X-ME-Sender: <xms:wu2WXgK9K0mSCe-gC9B3S1HGNtulcoiUxYIzvCdZEdgT3O-6_e_3oA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wu2WXrqPFqJcLGiO2rkWnTQ0ocLpe4Kee9cLQ9gFNcpam3ZgA4f1sA>
    <xmx:wu2WXnuRCGSYscJLCTAFVRqhvcGxez7XQICW7v1ApLmM60argXLaPg>
    <xmx:wu2WXmV5k4oUjSjS2tBb3pKJLaltnrvt7lEj7LjC_dSgs_sMIae8cg>
    <xmx:w-2WXjUJtEd1OtaH4fB5aguwo4rEO1AvWA4jH1QpvkjDzpjtnInLbA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21FBE306005C;
        Wed, 15 Apr 2020 07:19:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: sr: Fix sr_block_release()" failed to apply to 5.6-stable tree
To:     bvanassche@acm.org, arnd@arndb.de, martin.petersen@oracle.com,
        merlijn@archive.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:19:28 +0200
Message-ID: <1586949568154118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 72655c0ebd1d941d80f47bf614b02d563a1e61ae Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 29 Mar 2020 19:51:51 -0700
Subject: [PATCH] scsi: sr: Fix sr_block_release()

This patch fixes the following two complaints:

WARNING: CPU: 3 PID: 1326 at kernel/locking/mutex-debug.c:103 mutex_destroy+0x74/0x80
Modules linked in: scsi_debug sd_mod t10_pi brd scsi_transport_iscsi af_packet crct10dif_pclmul sg aesni_intel glue_helper virtio_balloon button crypto_simd cryptd intel_agp intel_gtt agpgart ip_tables x_tables ipv6 nf_defrag_ipv6 autofs4 ext4 crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom ata_generic pata_acpi virtio_blk virtio_net net_failover failover ata_piix xhci_pci ahci libahci xhci_hcd i2c_piix4 libata virtio_pci usbcore i2c_core virtio_ring scsi_mod usb_common virtio [last unloaded: scsi_debug]
CPU: 3 PID: 1326 Comm: systemd-udevd Not tainted 5.6.0-rc1-dbg+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
RIP: 0010:mutex_destroy+0x74/0x80
Call Trace:
 sr_kref_release+0xb9/0xd0 [sr_mod]
 scsi_cd_put+0x79/0x90 [sr_mod]
 sr_block_release+0x54/0x70 [sr_mod]
 __blkdev_put+0x2ce/0x3c0
 blkdev_put+0x68/0x220
 blkdev_close+0x4d/0x60
 __fput+0x170/0x3b0
 ____fput+0x12/0x20
 task_work_run+0xa2/0xf0
 exit_to_usermode_loop+0xeb/0xf0
 do_syscall_64+0x2be/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fa16d40aab7

BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0x98/0x420
Read of size 8 at addr ffff8881c6e4f4b0 by task systemd-udevd/1326

CPU: 3 PID: 1326 Comm: systemd-udevd Tainted: G        W         5.6.0-rc1-dbg+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0xa5/0xe6
 print_address_description.constprop.0+0x46/0x60
 __kasan_report.cold+0x7b/0x94
 kasan_report+0x16/0x20
 check_memory_region+0x140/0x1b0
 __kasan_check_read+0x15/0x20
 __mutex_unlock_slowpath+0x98/0x420
 mutex_unlock+0x16/0x20
 sr_block_release+0x5c/0x70 [sr_mod]
 __blkdev_put+0x2ce/0x3c0
hardirqs last  enabled at (1875522): [<ffffffff81bb0696>] _raw_spin_unlock_irqrestore+0x56/0x70
 blkdev_put+0x68/0x220
 blkdev_close+0x4d/0x60
 __fput+0x170/0x3b0
 ____fput+0x12/0x20
 task_work_run+0xa2/0xf0
 exit_to_usermode_loop+0xeb/0xf0
 do_syscall_64+0x2be/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fa16d40aab7

Allocated by task 3201:
 save_stack+0x23/0x90
 __kasan_kmalloc.constprop.0+0xcf/0xe0
 kasan_kmalloc+0xd/0x10
 kmem_cache_alloc_trace+0x161/0x3c0
 sr_probe+0x12f/0xb60 [sr_mod]
 really_probe+0x183/0x5d0
 driver_probe_device+0x13f/0x1a0
 __device_attach_driver+0xe6/0x150
 bus_for_each_drv+0x101/0x160
 __device_attach+0x183/0x230
 device_initial_probe+0x17/0x20
 bus_probe_device+0x110/0x130
 device_add+0xb7b/0xd40
 scsi_sysfs_add_sdev+0xe8/0x360 [scsi_mod]
 scsi_probe_and_add_lun+0xdc4/0x14c0 [scsi_mod]
 __scsi_scan_target+0x12d/0x850 [scsi_mod]
 scsi_scan_channel+0xcd/0xe0 [scsi_mod]
 scsi_scan_host_selected+0x182/0x190 [scsi_mod]
 store_scan+0x1e9/0x200 [scsi_mod]
 dev_attr_store+0x42/0x60
 sysfs_kf_write+0x8b/0xb0
 kernfs_fop_write+0x158/0x250
 __vfs_write+0x4c/0x90
 vfs_write+0x145/0x2c0
 ksys_write+0xd7/0x180
 __x64_sys_write+0x47/0x50
 do_syscall_64+0x6f/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 1326:
 save_stack+0x23/0x90
 __kasan_slab_free+0x13a/0x190
 kasan_slab_free+0x12/0x20
 kfree+0x109/0x410
 sr_kref_release+0xc1/0xd0 [sr_mod]
 scsi_cd_put+0x79/0x90 [sr_mod]
 sr_block_release+0x54/0x70 [sr_mod]
 __blkdev_put+0x2ce/0x3c0
 blkdev_put+0x68/0x220
 blkdev_close+0x4d/0x60
 __fput+0x170/0x3b0
 ____fput+0x12/0x20
 task_work_run+0xa2/0xf0
 exit_to_usermode_loop+0xeb/0xf0
 do_syscall_64+0x2be/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Link: https://lore.kernel.org/r/20200330025151.10535-1-bvanassche@acm.org
Fixes: 51a858817dcd ("scsi: sr: get rid of sr global mutex")
Cc: Merlijn Wajer <merlijn@archive.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@kernel.org>
Acked-by: Merlijn Wajer <merlijn@archive.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fe0e1c721a99..2483100dc144 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -550,10 +550,12 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 static void sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
+
 	mutex_lock(&cd->lock);
 	cdrom_release(&cd->cdi, mode);
-	scsi_cd_put(cd);
 	mutex_unlock(&cd->lock);
+
+	scsi_cd_put(cd);
 }
 
 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,

