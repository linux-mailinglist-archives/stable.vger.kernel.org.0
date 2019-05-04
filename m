Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07673137D4
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 08:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfEDGmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 02:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfEDGmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 02:42:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1101020675;
        Sat,  4 May 2019 06:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556952121;
        bh=PWj8sFyAxtJkWRr+uZ256EUHfOA/Dj9JYB8XWgq7XLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ib1jQJR7+JenlnIBtip2PQZpGTyaKd9ArC9k+DAm+czAMzHvWRHskE/Np7iHckuyn
         tNrQX4UfPPTpicSoQMFC/HUPwICLd0B/oxXXOsP2eGrJI2ZpQTWBKCd30cNJbxxsQ9
         LQxT5eSCo7KGqqAOTeTXMxOxfHHPIKfSSsrH5xTI=
Date:   Sat, 4 May 2019 08:41:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Commit 8c37f7c23c02f6ac020ffdc746026c2363b23a5a causes warnings
Message-ID: <20190504064159.GC26311@kroah.com>
References: <4031e343-ab11-6b58-71b7-f6f8cf69b677@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4031e343-ab11-6b58-71b7-f6f8cf69b677@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 10:17:39PM +0200, François Valenduc wrote:
> Commit 8c37f7c23c02f6ac020ffdc746026c2363b23a5a ( workqueue: Try to
> catch flush_work() without INIT_WORK().) causes the following warning
> when mounting encrypted filesystems:
> 
> May  3 21:29:33 pc-francois kernel: [   20.202934] WARNING: CPU: 1 PID:
> 1719 at kernel/workqueue.c:2911 __flush_work+0x1a4/0x1c0
> May  3 21:29:33 pc-francois kernel: [   20.205470] Modules linked in:
> uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videodev
> videobuf2_common arc4 rtl8188ee rtl_pci rtlwifi mac80211 cfg80211
> snd_hda_codec_hdmi alx mdio psmou
> se snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core
> snd_pcm snd_timer snd soundcore evdev coretemp battery nls_utf8
> nls_cp850 efivars vfat fat ac hwmon vboxpci(O) vboxnetadp(O)
> vboxnetflt(O) vboxdrv(O) nbd kvm_intel nfsd au
> th_rpcgss kvm irqbypass dm_thin_pool dm_persistent_data dm_bio_prison
> dm_round_robin dm_multipath xts cbc fuse xfs nfs lockd grace sunrpc
> btrfs xor zstd_decompress zstd_compress xxhash raid6_pq crc32c_generic
> libcrc32c zlib_inflate ext4
> mbcache jbd2 dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash
> dm_log dm_mod dax ohci_hcd sr_mod sd_mod cdrom usb_storage hid_generic
> May  3 21:29:33 pc-francois kernel: [   20.218000]  usbhid hid xhci_pci
> aesni_intel aes_x86_64 crypto_simd cryptd glue_helper ehci_pci ahci
> xhci_hcd ehci_hcd libahci usbcore usb_common
> May  3 21:29:33 pc-francois kernel: [   20.220780] CPU: 1 PID: 1719
> Comm: systemd-cryptse Tainted: G        W  O      4.19.39-rc1 #41
> May  3 21:29:33 pc-francois kernel: [   20.223587] Hardware name:
> TOSHIBA SATELLITE C70-A/Type2 - Board Product Name1, BIOS 1.00 04/30/2013
> May  3 21:29:33 pc-francois kernel: [   20.226435] RIP:
> 0010:__flush_work+0x1a4/0x1c0
> May  3 21:29:33 pc-francois kernel: [   20.229285] Code: 20 e9 f8 fe ff
> ff fb 31 c0 eb 8e 8b 4d 00 48 8b 55 08 83 e1 08 48 0f ba 6d 00 03 80 c9
> f0 e9 54 ff ff ff 0f 0b e9 6f ff ff ff <0f> 0b 31 c0 e9 66 ff ff ff e8
> 7e 8b fe ff 66 66 2e 0
> f 1f 84 00 00
> May  3 21:29:33 pc-francois kernel: [   20.235471] RSP:
> 0018:ffff956f8033fb50 EFLAGS: 00010246
> May  3 21:29:33 pc-francois kernel: [   20.238618] RAX: 0000000000000000
> RBX: ffff8ff5bce9b9d0 RCX: 0000000000000000
> May  3 21:29:33 pc-francois kernel: [   20.241801] RDX: 0000000000000001
> RSI: 0000000000000001 RDI: ffff8ff5bce9b9d0
> May  3 21:29:33 pc-francois kernel: [   20.244991] RBP: ffff8ff5bce9b9d0
> R08: 0000000000000050 R09: ffff8ff5c3019380
> May  3 21:29:33 pc-francois kernel: [   20.248178] R10: 0000000000000ab8
> R11: ffff8ff5c305e688 R12: 0000000000000000
> May  3 21:29:33 pc-francois kernel: [   20.251389] R13: ffff956f8033fbe8
> R14: ffffffff8c0609f0 R15: ffff956f8033fd08
> May  3 21:29:33 pc-francois kernel: [   20.254624] FS: 
> 00007feaa0d15840(0000) GS:ffff8ff5c3040000(0000) knlGS:0000000000000000
> May  3 21:29:33 pc-francois kernel: [   20.257908] CS:  0010 DS: 0000
> ES: 0000 CR0: 0000000080050033
> May  3 21:29:33 pc-francois kernel: [   20.261198] CR2: 00007f9316ec25a0
> CR3: 000000033cf8c003 CR4: 00000000001606a0
> May  3 21:29:33 pc-francois kernel: [   20.264520] Call Trace:
> May  3 21:29:33 pc-francois kernel: [   20.267837]  ?
> _raw_spin_unlock_irq+0xe/0x20
> May  3 21:29:33 pc-francois kernel: [   20.271173]  ?
> finish_task_switch+0x8a/0x2a0
> May  3 21:29:33 pc-francois kernel: [   20.274499]  ? __switch_to+0x2e/0x380
> May  3 21:29:33 pc-francois kernel: [   20.277820]  ?
> __switch_to_asm+0x34/0x70
> May  3 21:29:33 pc-francois kernel: [   20.281136] 
> __cancel_work_timer+0xfe/0x180
> May  3 21:29:33 pc-francois kernel: [   20.284315]  ?
> remove_all+0x30/0x30 [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.287332]  ?
> _raw_spin_unlock_irqrestore+0xf/0x30
> May  3 21:29:33 pc-francois kernel: [   20.290326]  ?
> remove_all+0x30/0x30 [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.293300]  blk_sync_queue+0x1d/0x80
> May  3 21:29:33 pc-francois kernel: [   20.296253] 
> blk_cleanup_queue+0xc0/0x140
> May  3 21:29:33 pc-francois kernel: [   20.299198] 
> cleanup_mapped_device+0xc3/0x100 [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.302158]  free_dev+0x38/0xa0
> [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.305113]  ?
> remove_all+0x30/0x30 [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.308044] 
> dev_remove+0xce/0x110 [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.310961] 
> ctl_ioctl+0x1a7/0x3a0 [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.313881] 
> dm_ctl_ioctl+0x5/0x10 [dm_mod]
> May  3 21:29:33 pc-francois kernel: [   20.316810]  do_vfs_ioctl+0xa0/0x610
> May  3 21:29:33 pc-francois kernel: [   20.319738]  ?
> ksys_semctl+0x124/0x160
> May  3 21:29:33 pc-francois kernel: [   20.322674]  ?
> preempt_count_add+0x74/0xa0
> May  3 21:29:33 pc-francois kernel: [   20.325628]  ksys_ioctl+0x35/0x70
> May  3 21:29:33 pc-francois kernel: [   20.328586] 
> __x64_sys_ioctl+0x11/0x20
> May  3 21:29:33 pc-francois kernel: [   20.331536]  do_syscall_64+0x43/0xf0
> May  3 21:29:33 pc-francois kernel: [   20.334493] 
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> May  3 21:29:33 pc-francois kernel: [   20.337478] RIP: 0033:0x7feaa2d10b17
> May  3 21:29:33 pc-francois kernel: [   20.340462] Code: 00 00 00 75 0c
> 48 c7 c0 ff ff ff ff 48 83 c4 18 c3 e8 7d e1 01 00 66 2e 0f 1f 84 00 00
> 00 00 00 0f 1f 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48
> 8b 0d 49 b3 0c 00 f7 d8 64 89 01 48
> May  3 21:29:33 pc-francois kernel: [   20.346929] RSP:
> 002b:00007ffc4e75db58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> May  3 21:29:33 pc-francois kernel: [   20.350202] RAX: ffffffffffffffda
> RBX: 00007feaa15156e0 RCX: 00007feaa2d10b17
> May  3 21:29:33 pc-francois kernel: [   20.353493] RDX: 00005585e2127a80
> RSI: 00000000c138fd04 RDI: 0000000000000004
> May  3 21:29:33 pc-francois kernel: [   20.356793] RBP: 00007feaa154f4c3
> R08: 000000000000005f R09: 00005585e2103ec0
> May  3 21:29:33 pc-francois kernel: [   20.360101] R10: 00007feaa2d9ef80
> R11: 0000000000000246 R12: 00005585e2127a80
> May  3 21:29:33 pc-francois kernel: [   20.363363] R13: 0000000000000001
> R14: 00005585e2127b30 R15: 00005585e2103650
> May  3 21:29:33 pc-francois kernel: [   20.366616] ---[ end trace
> 170b245abe91a71f ]---
> May  3 21:29:33 pc-francois kernel: [   21.000999] EXT4-fs (dm-14):
> mounted filesystem with ordered data mode. Opts: (null)
> 
> Finally If I revert this commit, the problem doesn't occur. I am using
> filesystems encrypted with luks formatted with ext4. The filesystems are
> on LVM volumes.
> Does anybody have an idea about this problem ?

Great, it did what it was trying to do :)

Do you have this problem on 5.0.y or Linus's current tree?

thanks,

greg k-h
