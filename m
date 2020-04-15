Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9909C1AA2A9
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505672AbgDOM70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:59:26 -0400
Received: from mail.archive.org ([207.241.224.6]:45922 "EHLO mail.archive.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505573AbgDOM7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 08:59:22 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Apr 2020 08:59:21 EDT
Received: from mail.archive.org (localhost [127.0.0.1])
        by mail.archive.org (Postfix) with ESMTP id 2ABAE213EA;
        Wed, 15 Apr 2020 12:50:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.archive.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        autolearn=disabled version=3.4.2
Received: from [0.0.0.0] (a82-161-36-93.adsl.xs4all.nl [82.161.36.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: merlijn@archive.org)
        by mail.archive.org (Postfix) with ESMTPSA id 112B5215C6;
        Wed, 15 Apr 2020 12:49:58 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] scsi: sr: Fix sr_block_release()" failed
 to apply to 5.6-stable tree
To:     gregkh@linuxfoundation.org, bvanassche@acm.org, arnd@arndb.de,
        martin.petersen@oracle.com, stable@kernel.org
Cc:     stable@vger.kernel.org
References: <1586949568154118@kroah.com>
From:   "Merlijn B.W. Wajer" <merlijn@archive.org>
Message-ID: <d16dfd1f-6b30-04e4-0e01-461b6c00e965@archive.org>
Date:   Wed, 15 Apr 2020 14:51:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1586949568154118@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Envelope-From: <merlijn@archive.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 15/04/2020 13:19, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This patch should apply fine on top of commit
51a858817dcdbbdee22cb54b0b2b26eb145ca5b6 [1].

Which wasn't mailed to stable@, but should have been. So if
51a858817dcdbbdee22cb54b0b2b26eb145ca5b6 is included, then this patch
should apply fine as well.

Cheers,
Merlijn

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/drivers/scsi/sr.c?id=51a858817dcdbbdee22cb54b0b2b26eb145ca5b6

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 72655c0ebd1d941d80f47bf614b02d563a1e61ae Mon Sep 17 00:00:00 2001
> From: Bart Van Assche <bvanassche@acm.org>
> Date: Sun, 29 Mar 2020 19:51:51 -0700
> Subject: [PATCH] scsi: sr: Fix sr_block_release()
> 
> This patch fixes the following two complaints:
> 
> WARNING: CPU: 3 PID: 1326 at kernel/locking/mutex-debug.c:103 mutex_destroy+0x74/0x80
> Modules linked in: scsi_debug sd_mod t10_pi brd scsi_transport_iscsi af_packet crct10dif_pclmul sg aesni_intel glue_helper virtio_balloon button crypto_simd cryptd intel_agp intel_gtt agpgart ip_tables x_tables ipv6 nf_defrag_ipv6 autofs4 ext4 crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom ata_generic pata_acpi virtio_blk virtio_net net_failover failover ata_piix xhci_pci ahci libahci xhci_hcd i2c_piix4 libata virtio_pci usbcore i2c_core virtio_ring scsi_mod usb_common virtio [last unloaded: scsi_debug]
> CPU: 3 PID: 1326 Comm: systemd-udevd Not tainted 5.6.0-rc1-dbg+ #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> RIP: 0010:mutex_destroy+0x74/0x80
> Call Trace:
>  sr_kref_release+0xb9/0xd0 [sr_mod]
>  scsi_cd_put+0x79/0x90 [sr_mod]
>  sr_block_release+0x54/0x70 [sr_mod]
>  __blkdev_put+0x2ce/0x3c0
>  blkdev_put+0x68/0x220
>  blkdev_close+0x4d/0x60
>  __fput+0x170/0x3b0
>  ____fput+0x12/0x20
>  task_work_run+0xa2/0xf0
>  exit_to_usermode_loop+0xeb/0xf0
>  do_syscall_64+0x2be/0x300
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7fa16d40aab7
> 
> BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0x98/0x420
> Read of size 8 at addr ffff8881c6e4f4b0 by task systemd-udevd/1326
> 
> CPU: 3 PID: 1326 Comm: systemd-udevd Tainted: G        W         5.6.0-rc1-dbg+ #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
>  dump_stack+0xa5/0xe6
>  print_address_description.constprop.0+0x46/0x60
>  __kasan_report.cold+0x7b/0x94
>  kasan_report+0x16/0x20
>  check_memory_region+0x140/0x1b0
>  __kasan_check_read+0x15/0x20
>  __mutex_unlock_slowpath+0x98/0x420
>  mutex_unlock+0x16/0x20
>  sr_block_release+0x5c/0x70 [sr_mod]
>  __blkdev_put+0x2ce/0x3c0
> hardirqs last  enabled at (1875522): [<ffffffff81bb0696>] _raw_spin_unlock_irqrestore+0x56/0x70
>  blkdev_put+0x68/0x220
>  blkdev_close+0x4d/0x60
>  __fput+0x170/0x3b0
>  ____fput+0x12/0x20
>  task_work_run+0xa2/0xf0
>  exit_to_usermode_loop+0xeb/0xf0
>  do_syscall_64+0x2be/0x300
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7fa16d40aab7
> 
> Allocated by task 3201:
>  save_stack+0x23/0x90
>  __kasan_kmalloc.constprop.0+0xcf/0xe0
>  kasan_kmalloc+0xd/0x10
>  kmem_cache_alloc_trace+0x161/0x3c0
>  sr_probe+0x12f/0xb60 [sr_mod]
>  really_probe+0x183/0x5d0
>  driver_probe_device+0x13f/0x1a0
>  __device_attach_driver+0xe6/0x150
>  bus_for_each_drv+0x101/0x160
>  __device_attach+0x183/0x230
>  device_initial_probe+0x17/0x20
>  bus_probe_device+0x110/0x130
>  device_add+0xb7b/0xd40
>  scsi_sysfs_add_sdev+0xe8/0x360 [scsi_mod]
>  scsi_probe_and_add_lun+0xdc4/0x14c0 [scsi_mod]
>  __scsi_scan_target+0x12d/0x850 [scsi_mod]
>  scsi_scan_channel+0xcd/0xe0 [scsi_mod]
>  scsi_scan_host_selected+0x182/0x190 [scsi_mod]
>  store_scan+0x1e9/0x200 [scsi_mod]
>  dev_attr_store+0x42/0x60
>  sysfs_kf_write+0x8b/0xb0
>  kernfs_fop_write+0x158/0x250
>  __vfs_write+0x4c/0x90
>  vfs_write+0x145/0x2c0
>  ksys_write+0xd7/0x180
>  __x64_sys_write+0x47/0x50
>  do_syscall_64+0x6f/0x300
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 1326:
>  save_stack+0x23/0x90
>  __kasan_slab_free+0x13a/0x190
>  kasan_slab_free+0x12/0x20
>  kfree+0x109/0x410
>  sr_kref_release+0xc1/0xd0 [sr_mod]
>  scsi_cd_put+0x79/0x90 [sr_mod]
>  sr_block_release+0x54/0x70 [sr_mod]
>  __blkdev_put+0x2ce/0x3c0
>  blkdev_put+0x68/0x220
>  blkdev_close+0x4d/0x60
>  __fput+0x170/0x3b0
>  ____fput+0x12/0x20
>  task_work_run+0xa2/0xf0
>  exit_to_usermode_loop+0xeb/0xf0
>  do_syscall_64+0x2be/0x300
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Link: https://lore.kernel.org/r/20200330025151.10535-1-bvanassche@acm.org
> Fixes: 51a858817dcd ("scsi: sr: get rid of sr global mutex")
> Cc: Merlijn Wajer <merlijn@archive.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: <stable@kernel.org>
> Acked-by: Merlijn Wajer <merlijn@archive.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index fe0e1c721a99..2483100dc144 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -550,10 +550,12 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
>  static void sr_block_release(struct gendisk *disk, fmode_t mode)
>  {
>  	struct scsi_cd *cd = scsi_cd(disk);
> +
>  	mutex_lock(&cd->lock);
>  	cdrom_release(&cd->cdi, mode);
> -	scsi_cd_put(cd);
>  	mutex_unlock(&cd->lock);
> +
> +	scsi_cd_put(cd);
>  }
>  
>  static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
> 
