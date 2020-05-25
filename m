Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64811E1738
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 23:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbgEYVie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 17:38:34 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:41069 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731385AbgEYVie (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 17:38:34 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 13EAD22FF5;
        Mon, 25 May 2020 23:38:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590442707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7P1EztiBqUplJWKfzPocF/g8xN3LpT+g4UANDeZTKkU=;
        b=Xcw17DcacWnXO1a8F3VKmpxaKiURHtsYjFfiOqEWnnPAC4058cVnxpdv/HUKrArtZJ9mr8
        J0GWK/ei620bbyqS/Mgnzt5EqAhI/eo4JY1fa838bFmKyzk96E20WXsS+jnD9tH5LtXP8v
        9FszbIUnc1pRZNA0tmHRzsOqCBjYvNg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 May 2020 23:38:26 +0200
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] driver core: Fix SYNC_STATE_ONLY device link
 implementation
In-Reply-To: <CAGETcx-4NURYve-cTy3GTExiKJ_QR1uRTqhDEYLmCuiXy8X5tg@mail.gmail.com>
References: <20200518080327.GA3126260@kroah.com>
 <20200519063000.128819-1-saravanak@google.com>
 <20200522204120.3b3c9ed6@apollo>
 <CAGETcx85trw=rCM1+dmemMGKstFCq=Nn7HR2fyDyV0rTTQYtEQ@mail.gmail.com>
 <41760105c011f9382f4d5fdc9feed017@walle.cc>
 <86f3036b44941870d12e432948a7cbb6@walle.cc>
 <CAGETcx-MbMXz-vw_1+EPKQMdeWXNFvhiP2UAJN=-563Y25VJDw@mail.gmail.com>
 <670bc1695b7bd45c19af1e5bb39fe896@walle.cc>
 <CAGETcx-4NURYve-cTy3GTExiKJ_QR1uRTqhDEYLmCuiXy8X5tg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <6144404cb26d1f797fd7e87b124bcaf8@walle.cc>
X-Sender: michael@walle.cc
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2020-05-25 23:24, schrieb Saravana Kannan:
> On Mon, May 25, 2020 at 12:05 PM Michael Walle <michael@walle.cc> 
> wrote:
>> 
>> Am 2020-05-25 20:39, schrieb Saravana Kannan:
>> > On Mon, May 25, 2020 at 4:31 AM Michael Walle <michael@walle.cc> wrote:
>> >>
>> >> Am 2020-05-23 00:47, schrieb Michael Walle:
>> >> > Am 2020-05-23 00:21, schrieb Saravana Kannan:
>> >> >> On Fri, May 22, 2020 at 11:41 AM Michael Walle <michael@walle.cc>
>> >> >> wrote:
>> >> >>>
>> >> >>> Am Mon, 18 May 2020 23:30:00 -0700
>> >> >>> schrieb Saravana Kannan <saravanak@google.com>:
>> >> >>>
>> >> >>> > When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
>> >> >>> > core: Add device link support for SYNC_STATE_ONLY flag"),
>> >> >>> > device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
>> >> >>> > device link to the supplier's and consumer's "device link" list.
>> >> >>> >
>> >> >>> > This causes multiple issues:
>> >> >>> > - The device link is lost forever from driver core if the caller
>> >> >>> >   didn't keep track of it (caller typically isn't expected to). This
>> >> >>> > is a memory leak.
>> >> >>> > - The device link is also never visible to any other code path after
>> >> >>> >   device_link_add() returns.
>> >> >>> >
>> >> >>> > If we fix the "device link" list handling, that exposes a bunch of
>> >> >>> > issues.
>> >> >>> >
>> >> >>> > 1. The device link "status" state management code rightfully doesn't
>> >> >>> > handle the case where a DL_FLAG_MANAGED device link exists between a
>> >> >>> > supplier and consumer, but the consumer manages to probe successfully
>> >> >>> > before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links
>> >> >>> > break this assumption. This causes device_links_driver_bound() to
>> >> >>> > throw a warning when this happens.
>> >> >>> >
>> >> >>> > Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for
>> >> >>> > creating proxy device links for child device dependencies and aren't
>> >> >>> > useful once the consumer device probes successfully, this patch just
>> >> >>> > deletes DL_FLAG_SYNC_STATE_ONLY device links once its consumer device
>> >> >>> > probes. This way, we avoid the warning, free up some memory and avoid
>> >> >>> > complicating the device links "status" state management code.
>> >> >>> >
>> >> >>> > 2. Creating a DL_FLAG_STATELESS device link between two devices that
>> >> >>> > already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
>> >> >>> > DL_FLAG_STATELESS flag not getting set correctly. This patch also
>> >> >>> > fixes this.
>> >> >>> >
>> >> >>> > Lastly, this patch also fixes minor whitespace issues.
>> >> >>>
>> >> >>> My board triggers the
>> >> >>>   WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
>> >> >>>
>> >> >>> Full bootlog:
>> >> > [..]
>> >> >
>> >> >> Thanks for the log and report. I haven't spent too much time thinking
>> >> >> about this, but can you give this a shot?
>> >> >> https://lore.kernel.org/lkml/20200520043626.181820-1-saravanak@google.com/
>> >> >
>> >> > I've already tried that, as this is already in linux-next. Doesn't fix
>> >> > it,
>> >> > though.
>> >>
>> >> btw. this only happens on linux-next (tested with next-20200522), not
>> >> on
>> >> 5.7-rc7 (which has the same two patches of yours)
>> >
>> > I wouldn't be surprised if the difference is due to
>> > fw_devlink_pause/resume() calls in driver/of/property.c. It chops off
>> > ~1s in boot time by changing the order in which device links are
>> > created from DT. So, I think it's just masking the issue.
>> >
>> > On linux-next where you see the issue, can you get the logs with this
>> > change:
>> > +++ b/drivers/base/core.c
>> > @@ -907,7 +907,10 @@ void device_links_driver_bound(struct device *dev)
>> >                          */
>> >                         device_link_drop_managed(link);
>> >                 } else {
>> > -                       WARN_ON(link->status !=
>> > DL_STATE_CONSUMER_PROBE);
>> > +                       WARN(link->status != DL_STATE_CONSUMER_PROBE,
>> > +                               "sup:%s - con:%s f:%d s:%d\n",
>> > +                               dev_name(supplier),
>> > dev_name(link->consumer),
>> > +                               link->flags, link->status);
>> >                         WRITE_ONCE(link->status, DL_STATE_ACTIVE);
>> >                 }
>> >
>> > My goal is to figure out the order in which the device links between
>> > the supplier and consumers devices are created and how that's changing
>> > the flag and status. Then I can come up with a fix.
>> 
>> Here we go (hopefully, my mail client won't screw up the line 
>> wrapping):
> 
> Thanks for the logs!
> 
> Ok, that definitely gave me some more info.
> 1. It's happening only for this iommu which in some cases can create
> device links before fw_devlink through the use of
> BUS_NOTIFY_ADD_DEVICE.
> 2. The issue doesn't seem to be between STATELESS and SYNC_STATE_ONLY
> flags (because STATELESS flag is not set).
> 3. There seems to be a MANAGED link created by arm-smmu.c before/after
> the SYNC_STATE_ONLY link is created.
> 
> In which case, the SYNC_STATE_ONLY link is supposed to be a NOP, but
> that doesn't seem to be the case for some reason.
> 
> Can you add these debug messages and give me the logs? Hopefully
> this'll be my last log request. I tried reproducing this in hardware I
> have, but I couldn't reproduce it.

sure no problem:

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
[    0.000000] Linux version 
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty (mw@apollo) 
(aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0, GNU ld (GNU Binutils for 
Debian) 2.31.1) #816 SMP PREEMPT Mon May 25 23:34:22 CEST 2020
[    0.000000] Machine model: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier
[    0.000000] efi: UEFI not found.
[    0.000000] cma: Reserved 32 MiB at 0x00000000f9c00000
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 
0x0000000080000000-0x00000020ffffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x20ff7ff100-0x20ff800fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000080000000-0x00000000bfffffff]
[    0.000000]   DMA32    [mem 0x00000000c0000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x00000020ffffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080000000-0x00000000fbdfffff]
[    0.000000]   node   0: [mem 0x0000002080000000-0x00000020ffffffff]
[    0.000000] Initmem setup node 0 [mem 
0x0000000080000000-0x00000020ffffffff]
[    0.000000] On node 0 totalpages: 1031680
[    0.000000]   DMA zone: 4096 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 262144 pages, LIFO batch:63
[    0.000000]   DMA32 zone: 3832 pages used for memmap
[    0.000000]   DMA32 zone: 245248 pages, LIFO batch:63
[    0.000000]   Normal zone: 8192 pages used for memmap
[    0.000000]   Normal zone: 524288 pages, LIFO batch:63
[    0.000000] percpu: Embedded 30 pages/cpu s82904 r8192 d31784 u122880
[    0.000000] pcpu-alloc: s82904 r8192 d31784 u122880 alloc=30*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Detected PIPT I-cache on CPU0
[    0.000000] CPU features: detected: GIC system register CPU interface
[    0.000000] CPU features: detected: EL2 vector hardening
[    0.000000] ARM_SMCCC_ARCH_WORKAROUND_1 missing from firmware
[    0.000000] CPU features: detected: ARM errata 1165522, 1319367, or 
1530923
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 
1015560
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: debug root=/dev/mmcblk1p2 rootwait
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 
4194304 bytes, linear)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] software IO TLB: mapped [mem 0xbbfff000-0xbffff000] 
(64MB)
[    0.000000] Memory: 3929700K/4126720K available (9596K kernel code, 
1116K rwdata, 3576K rodata, 3328K init, 400K bss, 164252K reserved, 
32768K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, 
Nodes=1
[    0.000000] ftrace: allocating 32709 entries in 128 pages
[    0.000000] ftrace: allocated 128 pages with 1 groups
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=256 to 
nr_cpu_ids=2.
[    0.000000]  Trampoline variant of Tasks RCU enabled.
[    0.000000]  Rude variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay 
is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, 
nr_cpu_ids=2
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
[    0.000000] GICv3: 256 SPIs implemented
[    0.000000] GICv3: 0 Extended SPIs implemented
[    0.000000] GICv3: Distributor has no Range Selector support
[    0.000000] GICv3: 16 PPIs implemented
[    0.000000] GICv3: CPU0: found redistributor 0 region 
0:0x0000000006040000
[    0.000000] ITS [mem 0x06020000-0x0603ffff]
[    0.000000] ITS@0x0000000006020000: allocated 65536 Devices 
@20fad80000 (flat, esz 8, psz 64K, shr 0)
[    0.000000] ITS: using cache flushing for cmd queue
[    0.000000] GICv3: using LPI property table @0x00000020fad30000
[    0.000000] GIC: using cache flushing for LPI property table
[    0.000000] GICv3: CPU0: using allocated LPI pending table 
@0x00000020fad40000
[    0.000000] random: get_random_bytes called from 
start_kernel+0x604/0x7cc with crng_init=0
[    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff 
max_cycles: 0x5c40939b5, max_idle_ns: 440795202646 ns
[    0.000002] sched_clock: 56 bits at 25MHz, resolution 40ns, wraps 
every 4398046511100ns
[    0.000106] Console: colour dummy device 80x25
[    0.000393] printk: console [tty0] enabled
[    0.000440] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 50.00 BogoMIPS (lpj=100000)
[    0.000453] pid_max: default: 32768 minimum: 301
[    0.000500] LSM: Security Framework initializing
[    0.000554] Mount-cache hash table entries: 8192 (order: 4, 65536 
bytes, linear)
[    0.000585] Mountpoint-cache hash table entries: 8192 (order: 4, 
65536 bytes, linear)
[    0.001424] rcu: Hierarchical SRCU implementation.
[    0.001573] Platform MSI: gic-its@6020000 domain created
[    0.001642] PCI/MSI: /interrupt-controller@6000000/gic-its@6020000 
domain created
[    0.001844] EFI services will not be available.
[    0.001943] smp: Bringing up secondary CPUs ...
[    0.002216] Detected PIPT I-cache on CPU1
[    0.002236] GICv3: CPU1: found redistributor 1 region 
0:0x0000000006060000
[    0.002243] GICv3: CPU1: using allocated LPI pending table 
@0x00000020fad50000
[    0.002265] CPU1: Booted secondary processor 0x0000000001 
[0x410fd083]
[    0.002316] smp: Brought up 1 node, 2 CPUs
[    0.002342] SMP: Total of 2 processors activated.
[    0.002350] CPU features: detected: 32-bit EL0 Support
[    0.002356] CPU features: detected: CRC32 instructions
[    0.010374] CPU: All CPU(s) started at EL2
[    0.010394] alternatives: patching kernel code
[    0.010997] devtmpfs: initialized
[    0.012905] KASLR disabled due to lack of seed
[    0.013057] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.013073] futex hash table entries: 512 (order: 3, 32768 bytes, 
linear)
[    0.013842] thermal_sys: Registered thermal governor 'step_wise'
[    0.013967] DMI not present or invalid.
[    0.014149] NET: Registered protocol family 16
[    0.015044] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic 
allocations
[    0.015756] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for 
atomic allocations
[    0.016483] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for 
atomic allocations
[    0.016519] audit: initializing netlink subsys (disabled)
[    0.016641] audit: type=2000 audit(0.016:1): state=initialized 
audit_enabled=0 res=1
[    0.016942] cpuidle: using governor menu
[    0.017011] hw-breakpoint: found 6 breakpoint and 4 watchpoint 
registers.
[    0.017040] ASID allocator initialised with 65536 entries
[    0.017304] Serial: AMBA PL011 UART driver
[    0.022963] platform 2140000.mmc: Link attempted to 5000000.iommu 
0xc0
[    0.022977] platform 2140000.mmc: Link done to 5000000.iommu 0xc0 0
[    0.023000] platform 2150000.mmc: Link attempted to 5000000.iommu 
0xc0
[    0.023009] platform 2150000.mmc: Link done to 5000000.iommu 0xc0 0
[    0.023072] platform 22c0000.dma-controller: Link attempted to 
5000000.iommu 0xc0
[    0.023082] platform 22c0000.dma-controller: Link done to 
5000000.iommu 0xc0 0
[    0.023123] platform 3100000.usb: Link attempted to 5000000.iommu 
0xc0
[    0.023132] platform 3100000.usb: Link done to 5000000.iommu 0xc0 0
[    0.023148] platform 3110000.usb: Link attempted to 5000000.iommu 
0xc0
[    0.023156] platform 3110000.usb: Link done to 5000000.iommu 0xc0 0
[    0.023181] platform 3400000.pcie: Link attempted to 5000000.iommu 
0xc0
[    0.023190] platform 3400000.pcie: Link done to 5000000.iommu 0xc0 0
[    0.023212] platform 3500000.pcie: Link attempted to 5000000.iommu 
0xc0
[    0.023221] platform 3500000.pcie: Link done to 5000000.iommu 0xc0 0
[    0.023238] platform 8380000.dma-controller: Link attempted to 
5000000.iommu 0xc0
[    0.023248] platform 8380000.dma-controller: Link done to 
5000000.iommu 0xc0 0
[    0.023347] platform 1f0000000.pcie: Link attempted to 5000000.iommu 
0xc0
[    0.023355] platform 1f0000000.pcie: Link done to 5000000.iommu 0xc0 
0
[    0.023398] platform f080000.display: Link attempted to 5000000.iommu 
0xc0
[    0.023406] platform f080000.display: Link done to 5000000.iommu 0xc0 
0
[    0.023657] Machine: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 
2.0 carrier
[    0.023666] SoC family: QorIQ LS1028A
[    0.023672] SoC ID: svr:0x870b0110, Revision: 1.0
[    0.026698] HugeTLB registered 1.00 GiB page size, pre-allocated 0 
pages
[    0.026713] HugeTLB registered 32.0 MiB page size, pre-allocated 0 
pages
[    0.026721] HugeTLB registered 2.00 MiB page size, pre-allocated 0 
pages
[    0.026729] HugeTLB registered 64.0 KiB page size, pre-allocated 0 
pages
[    0.027791] cryptd: max_cpu_qlen set to 1000
[    0.029257] iommu: Default domain type: Translated
[    0.029325] vgaarb: loaded
[    0.029467] SCSI subsystem initialized
[    0.029554] usbcore: registered new interface driver usbfs
[    0.029580] usbcore: registered new interface driver hub
[    0.029612] usbcore: registered new device driver usb
[    0.029748] imx-i2c 2000000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.029925] i2c i2c-0: IMX I2C adapter registered
[    0.029998] imx-i2c 2030000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.030068] i2c i2c-1: IMX I2C adapter registered
[    0.030142] imx-i2c 2040000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.030240] i2c i2c-2: IMX I2C adapter registered
[    0.030319] pps_core: LinuxPPS API ver. 1 registered
[    0.030327] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    0.030341] PTP clock support registered
[    0.030562] Advanced Linux Sound Architecture Driver Initialized.
[    0.030909] clocksource: Switched to clocksource arch_sys_counter
[    0.067146] VFS: Disk quotas dquot_6.6.0
[    0.067188] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    0.069879] NET: Registered protocol family 2
[    0.070111] tcp_listen_portaddr_hash hash table entries: 2048 (order: 
3, 32768 bytes, linear)
[    0.070136] TCP established hash table entries: 32768 (order: 6, 
262144 bytes, linear)
[    0.070229] TCP bind hash table entries: 32768 (order: 7, 524288 
bytes, linear)
[    0.070529] TCP: Hash tables configured (established 32768 bind 
32768)
[    0.070628] UDP hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070655] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070740] NET: Registered protocol family 1
[    0.070760] PCI: CLS 0 bytes, default 64
[    0.071123] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 
7 counters available
[    0.071580] Initialise system trusted keyrings
[    0.071703] workingset: timestamp_bits=44 max_order=20 bucket_order=0
[    0.105131] Key type asymmetric registered
[    0.105147] Asymmetric key parser 'x509' registered
[    0.105173] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 248)
[    0.105182] io scheduler mq-deadline registered
[    0.105189] io scheduler kyber registered
[    0.105719] pci-host-generic 1f0000000.pcie: host bridge 
/soc/pcie@1f0000000 ranges:
[    0.105749] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8000000..0x01f815ffff -> 0x0000000000
[    0.105769] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8160000..0x01f81cffff -> 0x0000000000
[    0.105789] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81d0000..0x01f81effff -> 0x0000000000
[    0.105808] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81f0000..0x01f820ffff -> 0x0000000000
[    0.105826] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8210000..0x01f822ffff -> 0x0000000000
[    0.105845] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8230000..0x01f824ffff -> 0x0000000000
[    0.105859] pci-host-generic 1f0000000.pcie:      MEM 
0x01fc000000..0x01fc3fffff -> 0x0000000000
[    0.105910] pci-host-generic 1f0000000.pcie: ECAM at [mem 
0x1f0000000-0x1f00fffff] for [bus 00]
[    0.105965] pci-host-generic 1f0000000.pcie: PCI host bridge to bus 
0000:00
[    0.105975] pci_bus 0000:00: root bus resource [bus 00]
[    0.105985] pci_bus 0000:00: root bus resource [mem 
0x1f8000000-0x1f815ffff] (bus address [0x00000000-0x0015ffff])
[    0.105996] pci_bus 0000:00: root bus resource [mem 
0x1f8160000-0x1f81cffff pref] (bus address [0x00000000-0x0006ffff])
[    0.106007] pci_bus 0000:00: root bus resource [mem 
0x1f81d0000-0x1f81effff] (bus address [0x00000000-0x0001ffff])
[    0.106018] pci_bus 0000:00: root bus resource [mem 
0x1f81f0000-0x1f820ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.106028] pci_bus 0000:00: root bus resource [mem 
0x1f8210000-0x1f822ffff] (bus address [0x00000000-0x0001ffff])
[    0.106039] pci_bus 0000:00: root bus resource [mem 
0x1f8230000-0x1f824ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.106050] pci_bus 0000:00: root bus resource [mem 
0x1fc000000-0x1fc3fffff] (bus address [0x00000000-0x003fffff])
[    0.106072] pci 0000:00:00.0: [1957:e100] type 00 class 0x020001
[    0.106113] pci 0000:00:00.0: BAR 0: [mem 0x1f8000000-0x1f803ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106125] pci 0000:00:00.0: BAR 2: [mem 0x1f8160000-0x1f816ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106138] pci 0000:00:00.0: VF BAR 0: [mem 0x1f81d0000-0x1f81dffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.106150] pci 0000:00:00.0: VF BAR 2: [mem 0x1f81f0000-0x1f81fffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.106174] pci 0000:00:00.0: PME# supported from D0 D3hot
[    0.106189] pci 0000:00:00.0: VF(n) BAR0 space: [mem 
0x1f81d0000-0x1f81effff 64bit] (contains BAR0 for 2 VFs)
[    0.106200] pci 0000:00:00.0: VF(n) BAR2 space: [mem 
0x1f81f0000-0x1f820ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.106314] pci 0000:00:00.1: [1957:e100] type 00 class 0x020001
[    0.106345] pci 0000:00:00.1: BAR 0: [mem 0x1f8040000-0x1f807ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106357] pci 0000:00:00.1: BAR 2: [mem 0x1f8170000-0x1f817ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106369] pci 0000:00:00.1: VF BAR 0: [mem 0x1f8210000-0x1f821ffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.106381] pci 0000:00:00.1: VF BAR 2: [mem 0x1f8230000-0x1f823ffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.106404] pci 0000:00:00.1: PME# supported from D0 D3hot
[    0.106418] pci 0000:00:00.1: VF(n) BAR0 space: [mem 
0x1f8210000-0x1f822ffff 64bit] (contains BAR0 for 2 VFs)
[    0.106429] pci 0000:00:00.1: VF(n) BAR2 space: [mem 
0x1f8230000-0x1f824ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.106524] pci 0000:00:00.2: [1957:e100] type 00 class 0x020001
[    0.106554] pci 0000:00:00.2: BAR 0: [mem 0x1f8080000-0x1f80bffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106566] pci 0000:00:00.2: BAR 2: [mem 0x1f8180000-0x1f818ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106587] pci 0000:00:00.2: PME# supported from D0 D3hot
[    0.106672] pci 0000:00:00.3: [1957:ee01] type 00 class 0x088001
[    0.106705] pci 0000:00:00.3: BAR 0: [mem 0x1f8100000-0x1f811ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106717] pci 0000:00:00.3: BAR 2: [mem 0x1f8190000-0x1f819ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106741] pci 0000:00:00.3: PME# supported from D0 D3hot
[    0.106826] pci 0000:00:00.4: [1957:ee02] type 00 class 0x088001
[    0.106856] pci 0000:00:00.4: BAR 0: [mem 0x1f8120000-0x1f813ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106868] pci 0000:00:00.4: BAR 2: [mem 0x1f81a0000-0x1f81affff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106889] pci 0000:00:00.4: PME# supported from D0 D3hot
[    0.107006] pci 0000:00:00.5: [1957:eef0] type 00 class 0x020801
[    0.107037] pci 0000:00:00.5: BAR 0: [mem 0x1f8140000-0x1f815ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.107049] pci 0000:00:00.5: BAR 2: [mem 0x1f81b0000-0x1f81bffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.107061] pci 0000:00:00.5: BAR 4: [mem 0x1fc000000-0x1fc3fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.107082] pci 0000:00:00.5: PME# supported from D0 D3hot
[    0.107172] pci 0000:00:00.6: [1957:e100] type 00 class 0x020001
[    0.107202] pci 0000:00:00.6: BAR 0: [mem 0x1f80c0000-0x1f80fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.107214] pci 0000:00:00.6: BAR 2: [mem 0x1f81c0000-0x1f81cffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.107235] pci 0000:00:00.6: PME# supported from D0 D3hot
[    0.107991] pci 0000:00:1f.0: [1957:e001] type 00 class 0x080700
[    0.108036] OF: /soc/pcie@1f0000000: no msi-map translation for rid 
0xf8 on (null)
[    0.108347] layerscape-pcie 3400000.pcie: host bridge 
/soc/pcie@3400000 ranges:
[    0.108373] layerscape-pcie 3400000.pcie:       IO 
0x8000010000..0x800001ffff -> 0x0000000000
[    0.108390] layerscape-pcie 3400000.pcie:      MEM 
0x8040000000..0x807fffffff -> 0x0040000000
[    0.108476] layerscape-pcie 3400000.pcie: PCI host bridge to bus 
0001:00
[    0.108485] pci_bus 0001:00: root bus resource [bus 00-ff]
[    0.108493] pci_bus 0001:00: root bus resource [io  0x0000-0xffff]
[    0.108502] pci_bus 0001:00: root bus resource [mem 
0x8040000000-0x807fffffff] (bus address [0x40000000-0x7fffffff])
[    0.108523] pci 0001:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.108583] pci 0001:00:00.0: supports D1 D2
[    0.108590] pci 0001:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.110007] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.110020] pci 0001:00:00.0: PCI bridge to [bus 01]
[    0.110111] layerscape-pcie 3500000.pcie: host bridge 
/soc/pcie@3500000 ranges:
[    0.110135] layerscape-pcie 3500000.pcie:       IO 
0x8800010000..0x880001ffff -> 0x0000000000
[    0.110151] layerscape-pcie 3500000.pcie:      MEM 
0x8840000000..0x887fffffff -> 0x0040000000
[    0.110229] layerscape-pcie 3500000.pcie: PCI host bridge to bus 
0002:00
[    0.110239] pci_bus 0002:00: root bus resource [bus 00-ff]
[    0.110248] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff] 
(bus address [0x0000-0xffff])
[    0.110259] pci_bus 0002:00: root bus resource [mem 
0x8840000000-0x887fffffff] (bus address [0x40000000-0x7fffffff])
[    0.110279] pci 0002:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.110337] pci 0002:00:00.0: supports D1 D2
[    0.110344] pci 0002:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.111771] pci_bus 0002:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.111783] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.112057] IPMI message handler: version 39.2
[    0.112083] ipmi device interface
[    0.112109] ipmi_si: IPMI System Interface driver
[    0.112228] ipmi_si: Unable to find any System Interface(s)
[    0.113662] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.114356] 21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.829114] printk: console [ttyS0] enabled
[    1.833561] 21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.842671] 2270000.serial: ttyLP2 at MMIO 0x2270000 (irq = 17, 
base_baud = 12500000) is a FSL_LPUART
[    1.852732] arm-smmu 5000000.iommu: probing hardware configuration...
[    1.859220] arm-smmu 5000000.iommu: SMMUv2 with:
[    1.863864] arm-smmu 5000000.iommu:  stage 1 translation
[    1.869208] arm-smmu 5000000.iommu:  stage 2 translation
[    1.874546] arm-smmu 5000000.iommu:  nested translation
[    1.879796] arm-smmu 5000000.iommu:  stream matching with 128 
register groups
[    1.886965] arm-smmu 5000000.iommu:  64 context banks (0 stage-2 
only)
[    1.893528] arm-smmu 5000000.iommu:  Supported page sizes: 0x61311000
[    1.899998] arm-smmu 5000000.iommu:  Stage-1: 48-bit VA -> 48-bit IPA
[    1.906465] arm-smmu 5000000.iommu:  Stage-2: 48-bit IPA -> 48-bit PA
[    1.913437] at24 0-0050: supply vcc not found, using dummy regulator
[    1.920610] at24 0-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    1.927482] at24 1-0057: supply vcc not found, using dummy regulator
[    1.934628] at24 1-0057: 8192 byte 24c64 EEPROM, writable, 32 
bytes/write
[    1.941497] at24 2-0050: supply vcc not found, using dummy regulator
[    1.948627] at24 2-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    1.956186] sl28cpld 0-004a: successfully probed. CPLD version 18
[    1.963442] gpio_sl28cpld sl28cpld-gpio: registered IRQ 108
[    1.974650] gpio_sl28cpld sl28cpld-gpio.0: registered IRQ 108
[    1.986259] irq_sl28cpld sl28cpld-intc: registered IRQ 108
[    1.991868] mpt3sas version 34.100.00.00 loaded
[    1.997205] header.nph=2
[    1.999759] sfdp_size=288
[    2.002520] spi-nor spi1.0: mx25u3235f (4096 Kbytes)
[    2.011867] header.nph=0
[    2.014411] sfdp_size=192
[    2.017084] spi-nor spi0.0: w25q32dw (4096 Kbytes)
[    2.023388] 10 fixed-partitions partitions found on MTD device 
20c0000.spi
[    2.030304] Creating 10 MTD partitions on "20c0000.spi":
[    2.035651] 0x000000000000-0x000000010000 : "rcw"
[    2.047220] 0x000000010000-0x000000100000 : "failsafe bootloader"
[    2.063208] 0x000000100000-0x000000140000 : "failsafe DP firmware"
[    2.071251] 0x000000140000-0x0000001e0000 : "failsafe trusted 
firmware"
[    2.079232] 0x0000001e0000-0x000000200000 : "reserved"
[    2.087241] 0x000000200000-0x000000210000 : "configuration store"
[    2.095230] 0x000000210000-0x000000300000 : "bootloader"
[    2.103241] 0x000000300000-0x000000340000 : "DP firmware"
[    2.111231] 0x000000340000-0x0000003e0000 : "trusted firmware"
[    2.119237] 0x0000003e0000-0x000000400000 : "bootloader environment"
[    2.127850] libphy: Fixed MDIO Bus: probed
[    2.132127] mscc_felix 0000:00:00.5: Link attempted to 5000000.iommu 
0x54
[    2.138951] mscc_felix 0000:00:00.5: Link done to 5000000.iommu 0x54 
2
[    2.145540] mscc_felix 0000:00:00.5: Adding to iommu group 0
[    2.151355] mscc_felix 0000:00:00.5: device is disabled, skipping
[    2.157513] fsl_enetc 0000:00:00.0: Link attempted to 5000000.iommu 
0x54
[    2.164251] fsl_enetc 0000:00:00.0: Link done to 5000000.iommu 0x54 2
[    2.170741] fsl_enetc 0000:00:00.0: Adding to iommu group 1
[    2.282925] fsl_enetc 0000:00:00.0: enabling device (0400 -> 0402)
[    2.289171] fsl_enetc 0000:00:00.0: no MAC address specified for SI1, 
using 66:04:52:2b:95:04
[    2.297738] fsl_enetc 0000:00:00.0: no MAC address specified for SI2, 
using ce:b6:68:6e:fe:21
[    2.306652] libphy: Freescale ENETC MDIO Bus: probed
[    2.313225] fsl_enetc 0000:00:00.1: Link attempted to 5000000.iommu 
0x54
[    2.319982] fsl_enetc 0000:00:00.1: Link done to 5000000.iommu 0x54 2
[    2.326486] fsl_enetc 0000:00:00.1: Adding to iommu group 2
[    2.332170] fsl_enetc 0000:00:00.1: device is disabled, skipping
[    2.338224] fsl_enetc 0000:00:00.2: Link attempted to 5000000.iommu 
0x54
[    2.344957] fsl_enetc 0000:00:00.2: Link done to 5000000.iommu 0x54 2
[    2.351448] fsl_enetc 0000:00:00.2: Adding to iommu group 3
[    2.357120] fsl_enetc 0000:00:00.2: device is disabled, skipping
[    2.363170] fsl_enetc 0000:00:00.6: Link attempted to 5000000.iommu 
0x54
[    2.369904] fsl_enetc 0000:00:00.6: Link done to 5000000.iommu 0x54 2
[    2.376394] fsl_enetc 0000:00:00.6: Adding to iommu group 4
[    2.382065] fsl_enetc 0000:00:00.6: device is disabled, skipping
[    2.388147] fsl_enetc_mdio 0000:00:00.3: Link attempted to 
5000000.iommu 0x54
[    2.395318] fsl_enetc_mdio 0000:00:00.3: Link done to 5000000.iommu 
0x54 2
[    2.402243] fsl_enetc_mdio 0000:00:00.3: Adding to iommu group 5
[    2.514920] fsl_enetc_mdio 0000:00:00.3: enabling device (0400 -> 
0402)
[    2.521748] libphy: FSL PCIe IE Central MDIO Bus: probed
[    2.527121] igb: Intel(R) Gigabit Ethernet Network Driver - version 
5.6.0-k
[    2.534115] igb: Copyright (c) 2007-2014 Intel Corporation.
[    2.539802] dwc3 3100000.usb: Link attempted to 5000000.iommu 0x54
[    2.546013] dwc3 3100000.usb: Link done to 5000000.iommu 0x44 1
[    2.551971] dwc3 3100000.usb: Adding to iommu group 6
[    2.557322] ------------[ cut here ]------------
[    2.561963] sup:5000000.iommu - con:3100000.usb f:68 s:1
[    2.567323] WARNING: CPU: 0 PID: 1 at drivers/base/core.c:923 
device_links_driver_bound+0x1ec/0x230
[    2.576404] Modules linked in:
[    2.579467] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #816
[    2.589332] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    2.597629] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    2.603220] pc : device_links_driver_bound+0x1ec/0x230
[    2.608375] lr : device_links_driver_bound+0x1ec/0x230
[    2.613527] sp : ffff8000111dbb70
[    2.616847] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    2.622177] x27: ffff00207a420c90 x26: ffff800010be8100
[    2.627506] x25: 0000000000000003 x24: ffff00207a420cb0
[    2.632834] x23: ffff800011039948 x22: ffff8000111dbbd8
[    2.638164] x21: ffff00207a420c10 x20: ffff8000110d2d80
[    2.643492] x19: ffff00207a401100 x18: 0000000000000010
[    2.648820] x17: ffffffffffff3f00 x16: 0000000000007fff
[    2.654148] x15: ffffffffffffffff x14: 0720072007200720
[    2.659476] x13: 0720072007200720 x12: 0720072007200720
[    2.664806] x11: 0720072007200720 x10: 0720072007200720
[    2.670134] x9 : ffff800010091f64 x8 : 072007380736073a
[    2.675463] x7 : 000000000000014e x6 : ffff00207ac21f00
[    2.680791] x5 : 0000000000000000 x4 : 0000000000000000
[    2.686119] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    2.691448] x1 : 1ab261fc7f167400 x0 : 0000000000000000
[    2.696777] Call trace:
[    2.699228]  device_links_driver_bound+0x1ec/0x230
[    2.704034]  driver_bound+0x70/0xc0
[    2.707530]  really_probe+0x110/0x318
[    2.711202]  driver_probe_device+0x40/0x90
[    2.715309]  device_driver_attach+0x7c/0x88
[    2.719504]  __driver_attach+0x60/0xe8
[    2.723262]  bus_for_each_dev+0x7c/0xd0
[    2.727108]  driver_attach+0x2c/0x38
[    2.730692]  bus_add_driver+0x194/0x1f8
[    2.734538]  driver_register+0x6c/0x128
[    2.738384]  __platform_driver_register+0x50/0x60
[    2.743104]  dwc3_driver_init+0x24/0x30
[    2.746951]  do_one_initcall+0x54/0x298
[    2.750798]  kernel_init_freeable+0x1ec/0x268
[    2.755169]  kernel_init+0x1c/0x118
[    2.758665]  ret_from_fork+0x10/0x1c
[    2.762251] ---[ end trace 66805623080b2741 ]---
[    2.766934] dwc3 3110000.usb: Link attempted to 5000000.iommu 0x54
[    2.773145] dwc3 3110000.usb: Link done to 5000000.iommu 0x44 1
[    2.779109] dwc3 3110000.usb: Adding to iommu group 7
[    2.784414] ------------[ cut here ]------------
[    2.789055] sup:5000000.iommu - con:3110000.usb f:68 s:1
[    2.794403] WARNING: CPU: 0 PID: 1 at drivers/base/core.c:923 
device_links_driver_bound+0x1ec/0x230
[    2.803483] Modules linked in:
[    2.806545] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #816
[    2.817805] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    2.826101] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    2.831691] pc : device_links_driver_bound+0x1ec/0x230
[    2.836845] lr : device_links_driver_bound+0x1ec/0x230
[    2.841999] sp : ffff8000111dbb70
[    2.845320] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    2.850648] x27: ffff00207a421090 x26: ffff800010be8100
[    2.855977] x25: 0000000000000003 x24: ffff00207a4210b0
[    2.861306] x23: ffff800011039948 x22: ffff8000111dbbd8
[    2.866634] x21: ffff00207a421010 x20: ffff8000110d2d80
[    2.871962] x19: ffff00207a401180 x18: 0000000000000010
[    2.877291] x17: ffffffffffff3f00 x16: 0000000000007fff
[    2.882619] x15: ffffffffffffffff x14: 0720072007200720
[    2.887947] x13: 0720072007200720 x12: 0720072007200720
[    2.893275] x11: 0720072007200720 x10: 0720072007200720
[    2.898603] x9 : ffff800010091f64 x8 : 072007380736073a
[    2.903931] x7 : 000000000000017c x6 : ffff00207ac21f00
[    2.909260] x5 : 0000000000000000 x4 : 0000000000000000
[    2.914589] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    2.919918] x1 : 1ab261fc7f167400 x0 : 0000000000000000
[    2.925246] Call trace:
[    2.927696]  device_links_driver_bound+0x1ec/0x230
[    2.932501]  driver_bound+0x70/0xc0
[    2.935998]  really_probe+0x110/0x318
[    2.939669]  driver_probe_device+0x40/0x90
[    2.943777]  device_driver_attach+0x7c/0x88
[    2.947971]  __driver_attach+0x60/0xe8
[    2.951730]  bus_for_each_dev+0x7c/0xd0
[    2.955576]  driver_attach+0x2c/0x38
[    2.959160]  bus_add_driver+0x194/0x1f8
[    2.963006]  driver_register+0x6c/0x128
[    2.966852]  __platform_driver_register+0x50/0x60
[    2.971570]  dwc3_driver_init+0x24/0x30
[    2.975415]  do_one_initcall+0x54/0x298
[    2.979262]  kernel_init_freeable+0x1ec/0x268
[    2.983631]  kernel_init+0x1c/0x118
[    2.987128]  ret_from_fork+0x10/0x1c
[    2.990711] ---[ end trace 66805623080b2742 ]---
[    2.995547] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) 
Driver
[    3.002107] ehci-pci: EHCI PCI platform driver
[    3.006755] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    3.012277] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 1
[    3.020107] xhci-hcd xhci-hcd.0.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    3.029566] xhci-hcd xhci-hcd.0.auto: irq 21, io mem 0x03100000
[    3.035880] hub 1-0:1.0: USB hub found
[    3.039664] hub 1-0:1.0: 1 port detected
[    3.043707] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    3.049223] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 2
[    3.056919] xhci-hcd xhci-hcd.0.auto: Host supports USB 3.0 
SuperSpeed
[    3.063516] usb usb2: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    3.071852] hub 2-0:1.0: USB hub found
[    3.075632] hub 2-0:1.0: 1 port detected
[    3.079706] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    3.085229] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 3
[    3.093068] xhci-hcd xhci-hcd.1.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    3.102528] xhci-hcd xhci-hcd.1.auto: irq 22, io mem 0x03110000
[    3.108793] hub 3-0:1.0: USB hub found
[    3.112575] hub 3-0:1.0: 1 port detected
[    3.116614] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    3.122130] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 4
[    3.129825] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0 
SuperSpeed
[    3.136418] usb usb4: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    3.144757] hub 4-0:1.0: USB hub found
[    3.148618] hub 4-0:1.0: 1 port detected
[    3.152749] usbcore: registered new interface driver usb-storage
[    3.158957] input: buttons1 as 
/devices/platform/buttons1/input/input0
[    3.166848] rtc-rv8803 0-0032: Voltage low, temperature compensation 
stopped.
[    3.174018] rtc-rv8803 0-0032: Voltage low, data loss detected.
[    3.181022] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    3.186864] rtc-rv8803 0-0032: registered as rtc0
[    3.192191] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    3.197879] rtc-rv8803 0-0032: hctosys: unable to read the hardware 
clock
[    3.204782] i2c /dev entries driver
[    3.214327] sp805-wdt c000000.watchdog: registration successful
[    3.220407] sp805-wdt c010000.watchdog: registration successful
[    3.228138] sl28cpld_wdt sl28cpld-wdt: initial timeout 6 sec
[    3.234397] qoriq-cpufreq qoriq-cpufreq: Freescale QorIQ CPU 
frequency scaling driver
[    3.242965] sdhci: Secure Digital Host Controller Interface driver
[    3.249219] sdhci: Copyright(c) Pierre Ossman
[    3.253631] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.260243] sdhci-esdhc 2140000.mmc: Link attempted to 5000000.iommu 
0x54
[    3.267129] sdhci-esdhc 2140000.mmc: Link done to 5000000.iommu 0x44 
1
[    3.273785] sdhci-esdhc 2140000.mmc: Adding to iommu group 8
[    3.306689] mmc0: SDHCI controller on 2140000.mmc [2140000.mmc] using 
ADMA
[    3.313896] ------------[ cut here ]------------
[    3.318800] sup:5000000.iommu - con:2140000.mmc f:68 s:1
[    3.324925] WARNING: CPU: 0 PID: 1 at drivers/base/core.c:923 
device_links_driver_bound+0x1ec/0x230
[    3.334038] Modules linked in:
[    3.337128] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #816
[    3.348423] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.356753] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    3.362371] pc : device_links_driver_bound+0x1ec/0x230
[    3.367551] lr : device_links_driver_bound+0x1ec/0x230
[    3.372725] sp : ffff8000111dbb70
[    3.376064] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    3.381422] x27: ffff00207a41a490 x26: ffff800010be8100
[    3.386779] x25: 0000000000000003 x24: ffff00207a41a4b0
[    3.392133] x23: ffff800011039948 x22: ffff8000111dbbd8
[    3.397487] x21: ffff00207a41a410 x20: ffff8000110d2d80
[    3.402840] x19: ffff00207affdf00 x18: 0000000000000001
[    3.408194] x17: 0000000000000000 x16: 0000000000000003
[    3.413548] x15: ffffffffffffffff x14: ffff800011039948
[    3.418902] x13: ffff002079dd2084 x12: ffff002079dd2080
[    3.424255] x11: 0000000000000000 x10: 00000000000009f0
[    3.429609] x9 : ffff800010091f64 x8 : ffff00207ae50a50
[    3.434962] x7 : 00000000ffffffff x6 : 0000000000000001
[    3.440315] x5 : 0000000000099b88 x4 : 0000000000000000
[    3.445668] x3 : ffff80206e9df000 x2 : ffff80001105b6c8
[    3.451021] x1 : 1ab261fc7f167400 x0 : 0000000000000000
[    3.456375] Call trace:
[    3.458851]  device_links_driver_bound+0x1ec/0x230
[    3.463683]  driver_bound+0x70/0xc0
[    3.467203]  really_probe+0x110/0x318
[    3.470900]  driver_probe_device+0x40/0x90
[    3.475032]  device_driver_attach+0x7c/0x88
[    3.479252]  __driver_attach+0x60/0xe8
[    3.483034]  bus_for_each_dev+0x7c/0xd0
[    3.486903]  driver_attach+0x2c/0x38
[    3.490510]  bus_add_driver+0x194/0x1f8
[    3.494381]  driver_register+0x6c/0x128
[    3.498249]  __platform_driver_register+0x50/0x60
[    3.502992]  sdhci_esdhc_driver_init+0x24/0x30
[    3.507472]  do_one_initcall+0x54/0x298
[    3.511345]  kernel_init_freeable+0x1ec/0x268
[    3.515738]  kernel_init+0x1c/0x118
[    3.519259]  ret_from_fork+0x10/0x1c
[    3.522862] ---[ end trace 66805623080b2743 ]---
[    3.527989] sdhci-esdhc 2150000.mmc: Link attempted to 5000000.iommu 
0x54
[    3.534939] sdhci-esdhc 2150000.mmc: Link done to 5000000.iommu 0x44 
1
[    3.541787] sdhci-esdhc 2150000.mmc: Adding to iommu group 9
[    3.574704] mmc1: SDHCI controller on 2150000.mmc [2150000.mmc] using 
ADMA
[    3.581851] ------------[ cut here ]------------
[    3.586858] sup:5000000.iommu - con:2150000.mmc f:68 s:1
[    3.592435] usb 3-1: new high-speed USB device number 2 using 
xhci-hcd
[    3.599148] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:923 
device_links_driver_bound+0x1ec/0x230
[    3.608262] Modules linked in:
[    3.611355] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #816
[    3.622650] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.630981] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    3.636600] pc : device_links_driver_bound+0x1ec/0x230
[    3.641779] lr : device_links_driver_bound+0x1ec/0x230
[    3.646953] sp : ffff8000111dbb70
[    3.650292] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    3.655651] x27: ffff00207a41a890 x26: ffff800010be8100
[    3.661007] x25: 0000000000000003 x24: ffff00207a41a8b0
[    3.666362] x23: ffff800011039948 x22: ffff8000111dbbd8
[    3.671716] x21: ffff00207a41a810 x20: ffff8000110d2d80
[    3.677071] x19: ffff00207affdf80 x18: 0000000000000001
[    3.682426] x17: 0000000000000001 x16: 0000000000000003
[    3.687780] x15: 0000000000000000 x14: 0000000000000051
[    3.693133] x13: 0000000000000002 x12: 0000000000000038
[    3.697688] mmc1: new HS400 MMC card at address 0001
[    3.698486] x11: 0000000000000040 x10: 00000000000009f0
[    3.704340] random: fast init done
[    3.708834] x9 : ffff800010091f64 x8 : ffff00207ae50a50
[    3.717608] x7 : ffff80206e9fd000 x6 : 0000000000000001
[    3.722962] x5 : 0000000000000000 x4 : 0000000000000000
[    3.728317] x3 : ffff80206e9fd000 x2 : ffff80001105b6c8
[    3.733671] x1 : 1ab261fc7f167400 x0 : 0000000000000000
[    3.739024] Call trace:
[    3.741500]  device_links_driver_bound+0x1ec/0x230
[    3.746332]  driver_bound+0x70/0xc0
[    3.748938] mmc0: new ultra high speed SDR104 SDHC card at address 
1234
[    3.749852]  really_probe+0x110/0x318
[    3.749871]  driver_probe_device+0x40/0x90
[    3.764329]  device_driver_attach+0x7c/0x88
[    3.768549]  __driver_attach+0x60/0xe8
[    3.772330]  bus_for_each_dev+0x7c/0xd0
[    3.776199]  driver_attach+0x2c/0x38
[    3.779807]  bus_add_driver+0x194/0x1f8
[    3.783677]  driver_register+0x6c/0x128
[    3.787544]  __platform_driver_register+0x50/0x60
[    3.792287]  sdhci_esdhc_driver_init+0x24/0x30
[    3.796768]  do_one_initcall+0x54/0x298
[    3.800641]  kernel_init_freeable+0x1ec/0x268
[    3.805035]  kernel_init+0x1c/0x118
[    3.808553]  ret_from_fork+0x10/0x1c
[    3.812157] ---[ end trace 66805623080b2744 ]---
[    3.818250] mmcblk0: mmc0:1234 SA16G 14.4 GiB
[    3.818559] usbcore: registered new interface driver usbhid
[    3.828515] usbhid: USB HID core driver
[    3.829035] mmcblk1: mmc1:0001 S0J58X 29.6 GiB
[    3.833593] wm8904 2-001a: supply DCVDD not found, using dummy 
regulator
[    3.837947] mmcblk1boot0: mmc1:0001 S0J58X partition 1 31.5 MiB
[    3.843995] wm8904 2-001a: supply DBVDD not found, using dummy 
regulator
[    3.850718] mmcblk1boot1: mmc1:0001 S0J58X partition 2 31.5 MiB
[    3.856797] wm8904 2-001a: supply AVDD not found, using dummy 
regulator
[    3.862959]  mmcblk0: p1
[    3.869617] wm8904 2-001a: supply CPVDD not found, using dummy 
regulator
[    3.872910] hub 3-1:1.0: USB hub found
[    3.879123] wm8904 2-001a: supply MICVDD not found, using dummy 
regulator
[    3.883857] mmcblk1rpmb: mmc1:0001 S0J58X partition 3 4.00 MiB, 
chardev (245:0)
[    3.897058] hub 3-1:1.0: 7 ports detected
[    3.902234] wm8904 2-001a: revision A
[    3.907845]  mmcblk1: p1 p2
[    3.921676] NET: Registered protocol family 10
[    3.927906] Segment Routing with IPv6
[    3.932235] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    3.939199] NET: Registered protocol family 17
[    3.943821] Bridge firewalling registered
[    3.948171] 8021q: 802.1Q VLAN Support v1.8
[    3.952510] Key type dns_resolver registered
[    3.957237] registered taskstats version 1
[    3.961422] Loading compiled-in X.509 certificates
[    3.972179] fsl-edma 22c0000.dma-controller: Link attempted to 
5000000.iommu 0x54
[    3.979821] fsl-edma 22c0000.dma-controller: Link done to 
5000000.iommu 0x44 1
[    3.987203] fsl-edma 22c0000.dma-controller: Adding to iommu group 10
[    3.996584] ------------[ cut here ]------------
[    4.001284] sup:5000000.iommu - con:22c0000.dma-controller f:68 s:1
[    4.007691] WARNING: CPU: 1 PID: 23 at drivers/base/core.c:923 
device_links_driver_bound+0x1ec/0x230
[    4.016888] Modules linked in:
[    4.019983] CPU: 1 PID: 23 Comm: kworker/1:1 Tainted: G        W      
    5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #816
[    4.031540] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    4.039877] Workqueue: events deferred_probe_work_func
[    4.045062] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    4.050680] pc : device_links_driver_bound+0x1ec/0x230
[    4.055860] lr : device_links_driver_bound+0x1ec/0x230
[    4.061033] sp : ffff800011fb3b70
[    4.064373] x29: ffff800011fb3b70 x28: ffff00207a421c10
[    4.069731] x27: ffff00207a41bc90 x26: ffff800010be8100
[    4.075087] x25: 0000000000000003 x24: ffff00207a41bcb0
[    4.080442] x23: ffff800011039948 x22: ffff800011fb3bd8
[    4.085797] x21: ffff00207a41bc10 x20: ffff8000110d2d80
[    4.091151] x19: ffff00207a401080 x18: 0000000000000010
[    4.096506] x17: 000000003b471451 x16: 00000000c282b760
[    4.101861] x15: ffffffffffffffff x14: 0720072007200720
[    4.107215] x13: 0720072007200720 x12: 072007200731073a
[    4.112570] x11: 0773072007380736 x10: 073a076607200772
[    4.117924] x9 : ffff800010091f64 x8 : 07720774076e076f
[    4.123279] x7 : 0000000000000250 x6 : ffff00207ac21f00
[    4.128633] x5 : 0000000000000000 x4 : 0000000000000000
[    4.133987] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    4.139340] x1 : 1ab261fc7f167400 x0 : 0000000000000000
[    4.144694] Call trace:
[    4.147170]  device_links_driver_bound+0x1ec/0x230
[    4.152003]  driver_bound+0x70/0xc0
[    4.155524]  really_probe+0x110/0x318
[    4.159221]  driver_probe_device+0x40/0x90
[    4.163355]  __device_attach_driver+0x8c/0xd0
[    4.167748]  bus_for_each_drv+0x84/0xd8
[    4.171617]  __device_attach+0xd4/0x110
[    4.175487]  device_initial_probe+0x1c/0x28
[    4.179706]  bus_probe_device+0xa4/0xb0
[    4.183576]  deferred_probe_work_func+0x7c/0xb8
[    4.188148]  process_one_work+0x1f4/0x4b8
[    4.192194]  worker_thread+0x218/0x498
[    4.195978]  kthread+0x160/0x168
[    4.199237]  ret_from_fork+0x10/0x1c
[    4.202841] ---[ end trace 66805623080b2746 ]---
[    4.207699] pcieport 0001:00:00.0: Link attempted to 5000000.iommu 
0x54
[    4.214416] pcieport 0001:00:00.0: Link done to 5000000.iommu 0x54 2
[    4.220935] pcieport 0001:00:00.0: Adding to iommu group 11
[    4.227403] pcieport 0001:00:00.0: AER: enabled with IRQ 24
[    4.233376] pcieport 0002:00:00.0: Link attempted to 5000000.iommu 
0x54
[    4.240093] pcieport 0002:00:00.0: Link done to 5000000.iommu 0x54 2
[    4.246616] pcieport 0002:00:00.0: Adding to iommu group 12
[    4.253011] pcieport 0002:00:00.0: AER: enabled with IRQ 26
[    4.259133] fsl-qdma 8380000.dma-controller: Link attempted to 
5000000.iommu 0x54
[    4.266717] fsl-qdma 8380000.dma-controller: Link done to 
5000000.iommu 0x44 1
[    4.266986] usb 3-1.6: new full-speed USB device number 3 using 
xhci-hcd
[    4.274077] fsl-qdma 8380000.dma-controller: Adding to iommu group 13
[    4.288640] ------------[ cut here ]------------
[    4.293339] sup:5000000.iommu - con:8380000.dma-controller f:68 s:1
[    4.299740] WARNING: CPU: 1 PID: 23 at drivers/base/core.c:923 
device_links_driver_bound+0x1ec/0x230
[    4.308937] Modules linked in:
[    4.312029] CPU: 1 PID: 23 Comm: kworker/1:1 Tainted: G        W      
    5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #816
[    4.323583] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    4.331920] Workqueue: events deferred_probe_work_func
[    4.337105] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    4.342722] pc : device_links_driver_bound+0x1ec/0x230
[    4.347900] lr : device_links_driver_bound+0x1ec/0x230
[    4.353074] sp : ffff800011fb3b70
[    4.356413] x29: ffff800011fb3b70 x28: ffff00207a421c10
[    4.361769] x27: ffff00207a422090 x26: ffff800010be8100
[    4.367123] x25: 0000000000000003 x24: ffff00207a4220b0
[    4.372477] x23: ffff800011039948 x22: ffff800011fb3bd8
[    4.377831] x21: ffff00207a422010 x20: ffff8000110d2d80
[    4.383185] x19: ffff00207a401300 x18: 0000000000000010
[    4.388540] x17: 000000003b471451 x16: 00000000c282b760
[    4.393893] x15: ffffffffffffffff x14: 0720072007200720
[    4.399247] x13: 0720072007200720 x12: 072007200731073a
[    4.404601] x11: 0773072007380736 x10: 073a076607200772
[    4.409953] x9 : ffff800010091f64 x8 : 07720774076e076f
[    4.415307] x7 : 0000000000000286 x6 : ffff00207ac21f00
[    4.420661] x5 : 0000000000000000 x4 : 0000000000000000
[    4.426014] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    4.431368] x1 : 1ab261fc7f167400 x0 : 0000000000000000
[    4.436720] Call trace:
[    4.439194]  device_links_driver_bound+0x1ec/0x230
[    4.444025]  driver_bound+0x70/0xc0
[    4.447546]  really_probe+0x110/0x318
[    4.451241]  driver_probe_device+0x40/0x90
[    4.455374]  __device_attach_driver+0x8c/0xd0
[    4.459767]  bus_for_each_drv+0x84/0xd8
[    4.463637]  __device_attach+0xd4/0x110
[    4.467508]  device_initial_probe+0x1c/0x28
[    4.471727]  bus_probe_device+0xa4/0xb0
[    4.475598]  deferred_probe_work_func+0x7c/0xb8
[    4.480171]  process_one_work+0x1f4/0x4b8
[    4.484217]  worker_thread+0x218/0x498
[    4.488000]  kthread+0x160/0x168
[    4.491258]  ret_from_fork+0x10/0x1c
[    4.494860] ---[ end trace 66805623080b2747 ]---
[    4.506099] asoc-simple-card sound: wm8904-hifi <-> 
f150000.audio-controller mapping ok
[    4.516423] asoc-simple-card sound: wm8904-hifi <-> 
f140000.audio-controller mapping ok
[    4.524640] asoc-simple-card sound: ASoC: no DMI vendor name!
[    4.536154] input: buttons0 as 
/devices/platform/buttons0/input/input1
[    4.543482] ALSA device list:
[    4.546485]   #0: f150000.audio-controller-wm8904-hifi
[    4.556559] EXT4-fs (mmcblk1p2): INFO: recovery required on readonly 
filesystem
[    4.563980] EXT4-fs (mmcblk1p2): write access will be enabled during 
recovery
[    4.593873] EXT4-fs (mmcblk1p2): recovery complete
[    4.600997] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data 
mode. Opts: (null)
[    4.609274] VFS: Mounted root (ext4 filesystem) readonly on device 
179:34.
[    4.616849] devtmpfs: mounted
[    4.630806] Freeing unused kernel memory: 3328K
[    4.635633] Run /sbin/init as init process
[    4.639794]   with arguments:
[    4.642787]     /sbin/init
[    4.645540]   with environment:
[    4.648732]     HOME=/
[    4.651137]     TERM=linux
[    4.703603] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[    4.870886] udevd[131]: starting version 3.2.8
[    4.877666] random: udevd: uninitialized urandom read (16 bytes read)
[    4.885558] random: udevd: uninitialized urandom read (16 bytes read)
[    4.892231] random: udevd: uninitialized urandom read (16 bytes read)
[    4.903984] udevd[131]: specified group 'kvm' unknown
[    4.931812] udevd[132]: starting eudev-3.2.8
[    7.218596] fsl_enetc 0000:00:00.0 gbe0: renamed from eth0
[   10.127116] urandom_read: 3 callbacks suppressed
[   10.127128] random: dd: uninitialized urandom read (512 bytes read)
[   10.288166] Qualcomm Atheros AR8031/AR8033 0000:00:00.0:05: attached 
PHY driver [Qualcomm Atheros AR8031/AR8033] 
(mii_bus:phy_addr=0000:00:00.0:05, irq=POLL)
[   10.323322] fsl_enetc 0000:00:00.0 gbe0: Link is Down
[   10.384814] random: dropbear: uninitialized urandom read (32 bytes 
read)
[   16.451528] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 1Gbps/Full - 
flow control off
[   16.459327] IPv6: ADDRCONF(NETDEV_CHANGE): gbe0: link becomes ready

-michael
