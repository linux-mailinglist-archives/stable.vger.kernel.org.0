Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59D11AC48E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409163AbgDPOB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392781AbgDPOBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FBA02078B;
        Thu, 16 Apr 2020 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045682;
        bh=Iwl6awxdRbAvKfpnCdlRwyJRvcV93T9QGbmlTbocIjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3vJlVhkGkOEIvbVAFPIqs9cTVGm6+ZXNit9p700LOKE7eom3vWT2jKcFKcDAYRhd
         ZCY1ZHReRIbefWsilyxSWfs1hrnXEyao4Dx+u4PGLKyCbDF+rc6ek6fkppwlIF2oSU
         Plzl7xcNI5uYPb9ImghiGUWtXNFy3RMjafKp+gPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.6 235/254] scsi: sr: Fix sr_block_release()
Date:   Thu, 16 Apr 2020 15:25:24 +0200
Message-Id: <20200416131354.949805390@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 72655c0ebd1d941d80f47bf614b02d563a1e61ae upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -550,10 +550,12 @@ out:
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


