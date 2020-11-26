Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634E42C4EE0
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 07:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733057AbgKZGia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 01:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732883AbgKZGi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 01:38:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 177B220DD4;
        Thu, 26 Nov 2020 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606372708;
        bh=U6J39CX85pcGhYaRt17CzLIiMgsbKLhu14q4n8RqSPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGtp+i4Qf8SJHP6djSuULcnyb2QGkzqfqtO38TZa5a/2cQalf+QdACJBNjrdbCa2d
         l/8FeaZ9DjJT26VDf3NFK8urA+B+XRsCq4Dva0ijzBTmBc9Woq8M9Clq+tNCO1DtgZ
         78VCq03JW7nV7kEKV0JOr4u7M6NIMX+O/CbyH0Vc=
Date:   Thu, 26 Nov 2020 07:39:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        x86@vger.kernel.org
Subject: Re: [stable 4.9] PANIC: double fault, error_code: 0x0 - clang boot
 failed on x86_64
Message-ID: <X79NpRIqAHEp2Lym@kroah.com>
References: <CA+G9fYt0qHxUty2qt7_9_YTOZamdtknhddbsi5gc3PDy0PvZ5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt0qHxUty2qt7_9_YTOZamdtknhddbsi5gc3PDy0PvZ5A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 10:14:43AM +0530, Naresh Kamboju wrote:
> Linaro recently started building and testing with stable branches with clang.
> Stable 4.9 branch kernel built with clang 10 boot crashed on x86 and qemu_x86.
> We do not have base line results to compare with.
> 
> steps to build and boot:
> # build kernel with tuxmake
> # sudo pip3 install -U tuxmake
> # tuxmake --runtime docker --target-arch x86 --toolchain clang-10
> --kconfig defconfig --kconfig-add
> https://builds.tuxbuild.com/1kgtX7QEDmhvj6OfbZBdlGaEple/config
> # boot qemu_x86_64
> # /usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic -net
> nic,model=virtio,macaddr=DE:AD:BE:EF:66:14 -net tap -m 1024 -monitor
> none -kernel kernel/bzImage --append "root=/dev/sda  rootwait
> console=ttyS0,115200" -hda
> rootfs/rpb-console-image-lkft-intel-corei7-64-20201022181159-3085.rootfs.ext4
> -m 4096 -smp 4 -nographic
> 
> Crash log:
> ---------------
> [   14.121499] Freeing unused kernel memory: 1896K
> [   14.126962] random: fast init done
> [   14.206005] PANIC: double fault, error_code: 0x0
> [   14.210633] CPU: 1 PID: 1 Comm: systemd Not tainted 4.9.246-rc1 #2
> [   14.216809] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [   14.224196] task: ffff88026e2c0000 task.stack: ffffc90000020000
> [   14.230105] RIP: 0010:[<ffffffff8117ec2b>]  [<ffffffff8117ec2b>]
> proc_dostring+0x13b/0x1e0
> [   14.238374] RSP: 0018:000000000000000c  EFLAGS: 00010297
> [   14.243676] RAX: 00005638939fb850 RBX: 000000000000000c RCX: 00005638939fb850
> [   14.250799] RDX: 000000000000000c RSI: 0000000000000000 RDI: 000000000000007f
> [   14.257925] RBP: ffffc90000023d98 R08: ffffc90000023ef8 R09: 00005638939fb850
> [   14.265049] R10: 0000000000000000 R11: ffffffff8117f9e0 R12: ffffffff82479cf0
> [   14.272171] R13: ffffc90000023ef8 R14: ffffc90000023dd8 R15: 000000000000007f
> [   14.279298] FS:  00007f57fbce8840(0000) GS:ffff880277880000(0000)
> knlGS:0000000000000000
> [   14.287384] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   14.293120] CR2: fffffffffffffff8 CR3: 000000026d58a000 CR4: 0000000000360670
> [   14.300243] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   14.307368] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   14.314491] Stack:
> [   14.316504] Call Trace:
> [   14.318955] Code: c3 49 8b 10 31 f6 48 01 da 49 89 10 49 83 3e 00
> 74 49 41 83 c7 ff 49 63 ff 4c 89 c9 0f 1f 40 00 48 39 fe 73 36 48 89
> c8 48 89 dc <e8> b0 9d 3a 00 85 c0 0f 85 8c 00 00 00 84 d2 74 1f 80 fa
> 0a 74
> [   14.338906] Kernel panic - not syncing: Machine halted.
> [   14.344123] CPU: 1 PID: 1 Comm: systemd Not tainted 4.9.246-rc1 #2
> [   14.350291] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [   14.357677]  ffff880277888e80 ffffffff81518ae9 ffff880277888e98
> ffffffff82971a10
> [   14.365129]  000000000000000f 0000000000000000 0000000000000086
> ffffffff820c5d57
> [   14.372584]  ffff880277888f08 ffffffff81175736 0000003000000008
> ffff880277888f18
> [   14.380038] Call Trace:
> [   14.382481]  <#DF> [   14.384406]  [<ffffffff81518ae9>] dump_stack+0xa9/0x100
> [   14.389641]  [<ffffffff81175736>] panic+0xe6/0x2a0
> [   14.394432]  [<ffffffff810c9911>] df_debug+0x31/0x40
> [   14.399389]  [<ffffffff81096312>] do_double_fault+0x102/0x140
> [   14.405128]  [<ffffffff81ccc987>] double_fault+0x27/0x30
> [   14.410440]  [<ffffffff8117f9e0>] ? proc_put_long+0xc0/0xc0
> [   14.416004]  [<ffffffff8117ec2b>] ? proc_dostring+0x13b/0x1e0
> [   14.421739]  <EOE> [   14.423703] Kernel Offset: disabled
> [   14.427209] ---[ end Kernel panic - not syncing: Machine halted.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> full test log,
> https://lkft.validation.linaro.org/scheduler/job/1978901#L916
> https://lkft.validation.linaro.org/scheduler/job/1980839#L578

Is the mainline 4.9 tree supposed to work with clang?  I didn't think
that upstream effort started until 4.19 or so.

thanks,

greg k-h
