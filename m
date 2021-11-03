Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A26443E35
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 09:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhKCIQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 04:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230352AbhKCIQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 04:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE50C6109F;
        Wed,  3 Nov 2021 08:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635927240;
        bh=cvnO3VXO3eEGiZjcVHRPmpCT0NgPoK7q7TLN7iveUuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jNj5W+lqDaQY9imi2Xoyab595Ln4rEhlp9Gr5215r0pz33TbmYf19xHeREceDdJZU
         u8seREOoHbBiMsr/sOSZr/2YiNAX/mMia7yeFkIORb9sGtjMvIzO90CFCZoB03o6df
         kP57VHCQOPdc8RpwUlw7P8jdZtquwieyYH6j6nq0=
Date:   Wed, 3 Nov 2021 09:13:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [bug report] kernel null pointer observed with blktests srp/006
 on 5.14.15
Message-ID: <YYJExddmf7FQiM/h@kroah.com>
References: <CAHj4cs-QxAmz=pM=cd1UJEg+HRUH_yMf5jDnBbirgW1oq1CaKw@mail.gmail.com>
 <YYH80vbE8DnCG94r@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYH80vbE8DnCG94r@T590>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 11:06:58AM +0800, Ming Lei wrote:
> On Tue, Nov 02, 2021 at 03:31:43PM +0800, Yi Zhang wrote:
> > Hello
> > 
> > Below null pointer was triggered with blktests srp/006 on aarch64, pls
> > help check it, thanks.
> 
> ...
> 
> > [  491.786766] Unable to handle kernel paging request at virtual
> > address ffff8000096f9438
> > [  491.794676] Mem abort info:
> > [  491.797480]   ESR = 0x96000007
> > [  491.800527]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [  491.805833]   SET = 0, FnV = 0
> > [  491.808896]   EA = 0, S1PTW = 0
> > [  491.812028]   FSC = 0x07: level 3 translation fault
> > [  491.816901] Data abort info:
> > [  491.819769]   ISV = 0, ISS = 0x00000007
> > [  491.823593]   CM = 0, WnR = 0
> > [  491.826553] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000f82320000
> > [  491.833243] [ffff8000096f9438] pgd=1000000fff0ff003,
> > p4d=1000000fff0ff003, pud=1000000fff0fe003, pmd=100000010c48a003,
> > pte=0000000000000000
> > [  491.845768] Internal error: Oops: 96000007 [#1] SMP
> > [  491.850636] Modules linked in: target_core_user uio
> > target_core_pscsi target_core_file ib_srpt target_core_iblock
> > target_core_mod rdma_cm iw_cm ib_cm scsi_debug rdma_rxe ib_uverbs
> > ip6_udp_tunnel udp_tunnel null_blk dm_service_time ib_umad
> > crc32_generic scsi_dh_rdac scsi_dh_emc scsi_dh_alua dm_multipath
> > ib_core rfkill sunrpc vfat fat joydev be2net nicvf cavium_ptp
> > mdio_thunder cavium_rng_vf nicpf thunderx_edac mdio_cavium thunder_bgx
> > thunder_xcv cavium_rng ipmi_ssif ipmi_devintf ipmi_msghandler fuse
> > zram ip_tables xfs ast i2c_algo_bit drm_vram_helper drm_kms_helper
> > syscopyarea sysfillrect sysimgblt fb_sys_fops crct10dif_ce cec
> > ghash_ce drm_ttm_helper ttm drm i2c_thunderx thunderx_mmc aes_neon_bs
> > [last unloaded: scsi_transport_srp]
> > [  491.915381] CPU: 6 PID: 11622 Comm: multipathd Not tainted 5.14.15 #1
> > [  491.921812] Hardware name: GIGABYTE R120-T34-00/MT30-GS2-00, BIOS
> > F02 08/06/2019
> > [  491.929196] pstate: 20400005 (nzCv daif +PAN -UAO -TCO BTYPE=--)
> > [  491.935192] pc : scsi_mq_exit_request+0x28/0x60
> > [  491.939721] lr : blk_mq_free_rqs+0x7c/0x1ec
> > [  491.943897] sp : ffff800016a536c0
> > [  491.947200] x29: ffff800016a536c0 x28: ffff0001375b8000 x27: 0000000000000131
> > [  491.954330] x26: ffff000102bb5c28 x25: ffff0001333d1000 x24: ffff0001333d1200
> > [  491.961460] x23: 0000000000000000 x22: ffff0001386870a8 x21: 0000000000000000
> > [  491.968589] x20: 0000000000000001 x19: ffff00010d878128 x18: ffffffffffffffff
> > [  491.975719] x17: 5342555300355f66 x16: 6d745f697363732f x15: 0000000000000000
> > [  491.982848] x14: 0000000000000000 x13: 0000000000000030 x12: 0101010101010101
> > [  491.989977] x11: ffff8000114a1298 x10: 0000000000001c90 x9 : ffff800010764030
> > [  491.997109] x8 : ffff0001375b9cf0 x7 : 0000000000000004 x6 : 00000002a7f08498
> > [  492.004242] x5 : 0000000000000001 x4 : ffff000130092128 x3 : ffff800010b1e7e0
> > [  492.011371] x2 : 0000000000000000 x1 : ffff8000096f93f0 x0 : ffff000138687000
> > [  492.018501] Call trace:
> > [  492.020937]  scsi_mq_exit_request+0x28/0x60
> > [  492.025112]  blk_mq_free_rqs+0x7c/0x1ec
> > [  492.028939]  blk_mq_free_tag_set+0x58/0x100
> > [  492.033113]  scsi_mq_destroy_tags+0x20/0x30
> > [  492.037286]  scsi_host_dev_release+0x9c/0x100
> > [  492.041633]  device_release+0x40/0xa0
> > [  492.045286]  kobject_cleanup+0x4c/0x180
> > [  492.049115]  kobject_put+0x50/0xd0
> > [  492.052510]  put_device+0x20/0x30
> > [  492.055819]  scsi_target_dev_release+0x34/0x44
> > [  492.060253]  device_release+0x40/0xa0
> > [  492.063905]  kobject_cleanup+0x4c/0x180
> > [  492.067732]  kobject_put+0x50/0xd0
> > [  492.071124]  put_device+0x20/0x30
> > [  492.074428]  scsi_device_dev_release_usercontext+0x228/0x244
> > [  492.080079]  execute_in_process_context+0x50/0xa0
> > [  492.084775]  scsi_device_dev_release+0x28/0x3c
> > [  492.089208]  device_release+0x40/0xa0
> > [  492.092860]  kobject_cleanup+0x4c/0x180
> > [  492.096686]  kobject_put+0x50/0xd0
> > [  492.100081]  put_device+0x20/0x30
> > [  492.103396]  scsi_device_put+0x38/0x50
> > [  492.107140]  sd_release151]  free_multipath+0x80/0xc0 [dm_multipath]
> > [  492.132109]  multipath_dtr+0x38/0x50 [dm_multipath]
> > [  492.136980]  dm_table_destroy+0x68/0x150
> > [  492.140892]  __dm_destroy+0x138/0x204
> > [  492.144548]  dm_destroy+0x20/0x30
> > [  492.147859]  dev_remove+0x144/0x1e0
> > [  492.151339]  ctl_ioctl+0x278/0x4d0
> > [  492.154731]  dm_ctl_ioctl+0x1c/0x30
> > [  492.158210]  __arm64_sys_ioctl+0xb4/0x100
> > [  492.162212]  invoke_syscall+0x50/0x120
> > [  492.165955]  el0_svc_common+0x48/0x100
> > [  492.169694]  do_el0_svc+0x34/0xa0
> > [  492.173000]  el0_svc+0x2c/0x54
> > [  492.176048]  el0t_64_sync_handler+0xa4/0x130
> > [  492.180307]  el0t_64_sync+0x19c/0x1a0
> > [  492.183962] Code: f9000bf3 9104a033 f9403000 f9404c01 (f9402422)
> > [  492.190068] ---[ end trace dbfeac019a702ce7 ]---
> > [  492.194678] Kernel panic - not syncing: Oops: Fatal exception
> > [  492.200431] SMP: stopping secondary CPUs
> > [  492.204354] Kernel Offset: 0x80000 from 0xffff800010000000
> > [  492.209828] PHYS_OFFSET: 0x0
> > [  492.212697] CPU features: 0x00180051,20800a40
> > [  492.217043] Memory Limit: none
> > [  492.220102] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
> 
> Hi Yi,
> 
> It was fixed by f2b85040acec ("scsi: core: Put LLD module refcnt after SCSI device
> is released"), look not ported to 5.14.y yet.

Did anyone ask for it to be backported to stable kernels yet?  I don't
see a request, nor was stable@vger cc:ed on the signed-off-by: line, so
how were we to know to pick this up?

Anyway, I've now done so...

thanks,

greg k-h
