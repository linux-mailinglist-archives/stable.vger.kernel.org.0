Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F164159A9
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 09:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhIWHyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 03:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239775AbhIWHyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 03:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 361F7611C6;
        Thu, 23 Sep 2021 07:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632383570;
        bh=IyR/xYUs0d0IpIpoyPyWr/yui5Yuq2u17it8FkCnBkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpn/FpXWN1R9MJk1+QSAAQl7M3ia850vx64dTAJro1eq4rduqqhju1/kLibEPCWxk
         P6Dqq+4dlStvqKUDNrnCPIw3VeyQEDkfvTNsBlMc5SvcPVNTuk0raEFz3EoFJH6R7A
         hNsbRRcvPpuDx7jw3aiOJlfiaSWjpvEWOmXM1+60=
Date:   Thu, 23 Sep 2021 09:52:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Chen <david.chen@nutanix.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "neeraju@codeaurora.org" <neeraju@codeaurora.org>
Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Message-ID: <YUwyT5IfFU+vRxiV@kroah.com>
References: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRq81jcZIH5+/ZpB@kroah.com>
 <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRtUNtyom4DDaa5a@kroah.com>
 <CO1PR02MB848942762455555DD6C9B9D794FE9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRyu1XUkg2QyZWzS@kroah.com>
 <CO1PR02MB848977DE32D7353C4BB75C1794C09@CO1PR02MB8489.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CO1PR02MB848977DE32D7353C4BB75C1794C09@CO1PR02MB8489.namprd02.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 19, 2021 at 12:28:40AM +0000, David Chen wrote:
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Tuesday, August 17, 2021 11:55 PM
> > To: David Chen <david.chen@nutanix.com>
> > Cc: stable@vger.kernel.org; Paul E. McKenney <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
> > Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
> > 
> > On Tue, Aug 17, 2021 at 06:47:45PM +0000, David Chen wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Sent: Monday, August 16, 2021 11:16 PM
> > > > To: David Chen <david.chen@nutanix.com>
> > > > Cc: stable@vger.kernel.org; Paul E. McKenney <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
> > > > Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
> > > >
> > > > On Mon, Aug 16, 2021 at 10:02:28PM +0000, David Chen wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > Sent: Monday, August 16, 2021 12:31 PM
> > > > > > To: David Chen <david.chen@nutanix.com>
> > > > > > Cc: stable@vger.kernel.org; Paul E. McKenney
> > > > > > <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
> > > > > > Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
> > > > > >
> > > > > > On Mon, Aug 16, 2021 at 07:19:34PM +0000, David Chen wrote:
> > > > > > > Hi Greg,
> > > > > > >
> > > > > > > We recently hit a hung task timeout issue in synchronize_rcu_expedited on
> > > > > > 4.14 branch.
> > > > > > > The issue seems to be identical to the one described in `fd6bc19d7676
> > > > > > > rcu: Fix missed wakeup of exp_wq waiters` Can we backport it to 4.14 and
> > > > > > 4.19 branch?
> > > > > > > The patch doesn't apply cleanly, but it should be trivial to resolve,
> > > > > > > just do this
> > > > > > >
> > > > > > > -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp-
> > > > > > >expedited_sequence) & 0x3]);
> > > > > > > +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
> > > > > > >
> > > > > > > I don't know if we should do it for 4.9, because the handling of sequence
> > > > > > number is a bit different.
> > > > > >
> > > > > > Please provide a working backport, me hand-editing patches does not scale,
> > > > > > and this way you get the proper credit for backporting it (after testing it).
> > > > >
> > > > > Sure, appended at the end.
> > > > >
> > > > > >
> > > > > > You have tested, this, right?
> > > > >
> > > > > I don't have a good repro for the original issue, so I only ran rcutorture and
> > > > > some basic work load test to see if anything obvious went wrong.
> > > >
> > > > Ideally you would be able to also hit this without the patch on the
> > > > older kernels, is this the case?
> > > >
> > > So far we've only seen this once. I was able to figure out the issue from the vmcore,
> > > but I haven't been able to reproduce this. I think the nature of the bug makes it
> > > very difficult to hit. It requires a race with synchronize_rcu_expedited but once
> > > the thread hangs, you can't call it again, because it might rescue the hung thread.
> > 
> > I would like a bit more verification that this is really needed, and
> > some acks from the developers/maintainers involved, before accepting
> > this change.
> > 
> https://lkml.org/lkml/2019/11/18/184
> >From the original discussion, Neeraj said they hit the issue on 4.9, 4.14 and 4.19 as well.
> I also tried running with the "WARN_ON(s_low != exp_low);" mentioned above without
> the fix, and force a schedule before "mutex_lock(&rsp->exp_wake_mutex);" to simulate
> a random latency from running on VM. I was able to trigger the warning.
> 
> [  162.760480] WARNING: CPU: 2 PID: 1129 at kernel/rcu/tree_exp.h:549 rcu_exp_wait_wake+0x4a5/0x6c0
> [  162.760482] Modules linked in: rcutorture torture nls_utf8 isofs nf_log_ipv6 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_log_ipv4 nf_log_common xt_LOG xt_limit ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc32c iptable_filter sunrpc crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc ttm aesni_intel crypto_simd drm_kms_helper drm sg joydev syscopyarea sysfillrect virtio_balloon sysimgblt fb_sys_fops i2c_piix4 input_leds pcspkr qemu_fw_cfg loop binfmt_misc ip_tables ext4 mbcache jbd2 sd_mod sr_mod cdrom ata_generic pata_acpi virtio_net virtio_scsi ata_piix virtio_pci serio_raw libata virtio_ring virtio floppy dm_mirror dm_region_hash dm_log sha3_generic authenc cmac wp512 twofish_generic twofish_x86_64 twofish_common
> [  162.760509]  tea sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 serpent_avx2 serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic seed salsa20_generic rmd320 rmd256 rmd160 rmd128 michael_mic md4 khazad fcrypt dm_crypt dm_mod dax des_generic deflate cts crc32c_intel ccm cast6_avx_x86_64 cast6_generic cast_common camellia_generic ablk_helper cryptd xts lrw glue_helper blowfish_generic blowfish_common arc4 ansi_cprng fuse [last unloaded: rcu_kprobe]
> [  162.760524] CPU: 2 PID: 1129 Comm: kworker/2:3 Tainted: G        W  O    4.14.243-1.nutanix.20210810.test.el7.x86_64 #1
> [  162.760524] Hardware name: Nutanix AHV, BIOS 1.11.0-2.el7 04/01/2014
> [  162.760525] Workqueue: events wait_rcu_exp_gp
> [  162.760526] task: ffffa083e92745c0 task.stack: ffffb29442cb8000
> [  162.760527] RIP: 0010:rcu_exp_wait_wake+0x4a5/0x6c0
> [  162.760527] RSP: 0018:ffffb29442cbbde8 EFLAGS: 00010206
> [  162.760528] RAX: 0000000000000000 RBX: ffffffff932b43c0 RCX: 0000000000000000
> [  162.760529] RDX: 0000000000000000 RSI: 0000000000000286 RDI: 0000000000000286
> [  162.760529] RBP: ffffb29442cbbe58 R08: ffffffff932b43c0 R09: ffffb29442cbbd70
> [  162.760530] R10: ffffb29442cbbba0 R11: 000000000000011b R12: ffffffff932b2440
> [  162.760531] R13: 000000000000157c R14: ffffffff932b4240 R15: 0000000000000003
> [  162.760531] FS:  0000000000000000(0000) GS:ffffa083efa80000(0000) knlGS:0000000000000000
> [  162.760532] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  162.760533] CR2: 00007f6d6d5160c8 CR3: 000000002320a001 CR4: 00000000001606e0
> [  162.760535] Call Trace:
> [  162.760537]  ? cpu_needs_another_gp+0x70/0x70
> [  162.760538]  wait_rcu_exp_gp+0x2b/0x30
> [  162.760539]  process_one_work+0x18f/0x3c0
> [  162.760540]  worker_thread+0x35/0x3c0
> [  162.760541]  kthread+0x128/0x140
> [  162.760542]  ? process_one_work+0x3c0/0x3c0
> [  162.760543]  ? __kthread_cancel_work+0x50/0x50
> [  162.760544]  ret_from_fork+0x35/0x40
> [  162.760545] Code: 4c 24 30 49 8b 94 24 10 13 04 00 48 c7 c7 d0 d7 05 93 0f 95 c0 48 2b 75 a8 44 0f be 80 d8 d2 05 93 e8 99 2f 70 00 e9 ae fe ff ff <0f> 0b e9 ec fc ff ff 65 8b 05 2d 40 f1 6d 89 c0 48 0f a3 05 d3
> [  162.760570] ---[ end trace 2cc2ddd257a55220 ]---
> 
> The warning triggered mean that the waker skipped the slot it's supposed to do wake_up_all on,
> and would result in possible missed wake up issue.

Ok, now queued up, thanks.

greg k-h
