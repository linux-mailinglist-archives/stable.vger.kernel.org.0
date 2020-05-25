Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00E41E1499
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 21:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389588AbgEYTFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 15:05:11 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:53655 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389437AbgEYTFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 15:05:10 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7C6D522F2E;
        Mon, 25 May 2020 21:04:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590433498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yy3E/lWSv5krEE0HtyLyqwtRkPrtcZKoxiSYx7Hx2LM=;
        b=dL0WAEwfD3Lx6uR3gCImqbB9PfZ+7Iu6S3MLC0kqabSSR6ZFT73Nx4yLWBBcnjw/aCZYux
        RGzQZkrqM5rBJWgV0Y61qi9D9rX1A5fn4h11UyIBX3aAkEJSEflCrFeTVnhrSwkk3DDwjf
        lW5/Oy5SZwJGg9y8L2XHy20NegnVLOk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 May 2020 21:04:58 +0200
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] driver core: Fix SYNC_STATE_ONLY device link
 implementation
In-Reply-To: <CAGETcx-MbMXz-vw_1+EPKQMdeWXNFvhiP2UAJN=-563Y25VJDw@mail.gmail.com>
References: <20200518080327.GA3126260@kroah.com>
 <20200519063000.128819-1-saravanak@google.com>
 <20200522204120.3b3c9ed6@apollo>
 <CAGETcx85trw=rCM1+dmemMGKstFCq=Nn7HR2fyDyV0rTTQYtEQ@mail.gmail.com>
 <41760105c011f9382f4d5fdc9feed017@walle.cc>
 <86f3036b44941870d12e432948a7cbb6@walle.cc>
 <CAGETcx-MbMXz-vw_1+EPKQMdeWXNFvhiP2UAJN=-563Y25VJDw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <670bc1695b7bd45c19af1e5bb39fe896@walle.cc>
X-Sender: michael@walle.cc
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2020-05-25 20:39, schrieb Saravana Kannan:
> On Mon, May 25, 2020 at 4:31 AM Michael Walle <michael@walle.cc> wrote:
>> 
>> Am 2020-05-23 00:47, schrieb Michael Walle:
>> > Am 2020-05-23 00:21, schrieb Saravana Kannan:
>> >> On Fri, May 22, 2020 at 11:41 AM Michael Walle <michael@walle.cc>
>> >> wrote:
>> >>>
>> >>> Am Mon, 18 May 2020 23:30:00 -0700
>> >>> schrieb Saravana Kannan <saravanak@google.com>:
>> >>>
>> >>> > When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
>> >>> > core: Add device link support for SYNC_STATE_ONLY flag"),
>> >>> > device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
>> >>> > device link to the supplier's and consumer's "device link" list.
>> >>> >
>> >>> > This causes multiple issues:
>> >>> > - The device link is lost forever from driver core if the caller
>> >>> >   didn't keep track of it (caller typically isn't expected to). This
>> >>> > is a memory leak.
>> >>> > - The device link is also never visible to any other code path after
>> >>> >   device_link_add() returns.
>> >>> >
>> >>> > If we fix the "device link" list handling, that exposes a bunch of
>> >>> > issues.
>> >>> >
>> >>> > 1. The device link "status" state management code rightfully doesn't
>> >>> > handle the case where a DL_FLAG_MANAGED device link exists between a
>> >>> > supplier and consumer, but the consumer manages to probe successfully
>> >>> > before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links
>> >>> > break this assumption. This causes device_links_driver_bound() to
>> >>> > throw a warning when this happens.
>> >>> >
>> >>> > Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for
>> >>> > creating proxy device links for child device dependencies and aren't
>> >>> > useful once the consumer device probes successfully, this patch just
>> >>> > deletes DL_FLAG_SYNC_STATE_ONLY device links once its consumer device
>> >>> > probes. This way, we avoid the warning, free up some memory and avoid
>> >>> > complicating the device links "status" state management code.
>> >>> >
>> >>> > 2. Creating a DL_FLAG_STATELESS device link between two devices that
>> >>> > already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
>> >>> > DL_FLAG_STATELESS flag not getting set correctly. This patch also
>> >>> > fixes this.
>> >>> >
>> >>> > Lastly, this patch also fixes minor whitespace issues.
>> >>>
>> >>> My board triggers the
>> >>>   WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
>> >>>
>> >>> Full bootlog:
>> > [..]
>> >
>> >> Thanks for the log and report. I haven't spent too much time thinking
>> >> about this, but can you give this a shot?
>> >> https://lore.kernel.org/lkml/20200520043626.181820-1-saravanak@google.com/
>> >
>> > I've already tried that, as this is already in linux-next. Doesn't fix
>> > it,
>> > though.
>> 
>> btw. this only happens on linux-next (tested with next-20200522), not 
>> on
>> 5.7-rc7 (which has the same two patches of yours)
> 
> I wouldn't be surprised if the difference is due to
> fw_devlink_pause/resume() calls in driver/of/property.c. It chops off
> ~1s in boot time by changing the order in which device links are
> created from DT. So, I think it's just masking the issue.
> 
> On linux-next where you see the issue, can you get the logs with this 
> change:
> +++ b/drivers/base/core.c
> @@ -907,7 +907,10 @@ void device_links_driver_bound(struct device *dev)
>                          */
>                         device_link_drop_managed(link);
>                 } else {
> -                       WARN_ON(link->status != 
> DL_STATE_CONSUMER_PROBE);
> +                       WARN(link->status != DL_STATE_CONSUMER_PROBE,
> +                               "sup:%s - con:%s f:%d s:%d\n",
> +                               dev_name(supplier), 
> dev_name(link->consumer),
> +                               link->flags, link->status);
>                         WRITE_ONCE(link->status, DL_STATE_ACTIVE);
>                 }
> 
> My goal is to figure out the order in which the device links between
> the supplier and consumers devices are created and how that's changing
> the flag and status. Then I can come up with a fix.

Here we go (hopefully, my mail client won't screw up the line wrapping):

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
[    0.000000] Linux version 
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty (mw@apollo) 
(aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0, GNU ld (GNU Binutils for 
Debian) 2.31.1) #815 SMP PREEMPT Mon May 25 20:58:11 CEST 2020
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
[    0.000109] Console: colour dummy device 80x25
[    0.000394] printk: console [tty0] enabled
[    0.000442] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 50.00 BogoMIPS (lpj=100000)
[    0.000455] pid_max: default: 32768 minimum: 301
[    0.000503] LSM: Security Framework initializing
[    0.000556] Mount-cache hash table entries: 8192 (order: 4, 65536 
bytes, linear)
[    0.000587] Mountpoint-cache hash table entries: 8192 (order: 4, 
65536 bytes, linear)
[    0.001429] rcu: Hierarchical SRCU implementation.
[    0.001576] Platform MSI: gic-its@6020000 domain created
[    0.001649] PCI/MSI: /interrupt-controller@6000000/gic-its@6020000 
domain created
[    0.001853] EFI services will not be available.
[    0.001951] smp: Bringing up secondary CPUs ...
[    0.002233] Detected PIPT I-cache on CPU1
[    0.002254] GICv3: CPU1: found redistributor 1 region 
0:0x0000000006060000
[    0.002261] GICv3: CPU1: using allocated LPI pending table 
@0x00000020fad50000
[    0.002282] CPU1: Booted secondary processor 0x0000000001 
[0x410fd083]
[    0.002333] smp: Brought up 1 node, 2 CPUs
[    0.002360] SMP: Total of 2 processors activated.
[    0.002367] CPU features: detected: 32-bit EL0 Support
[    0.002374] CPU features: detected: CRC32 instructions
[    0.010409] CPU: All CPU(s) started at EL2
[    0.010429] alternatives: patching kernel code
[    0.011032] devtmpfs: initialized
[    0.012924] KASLR disabled due to lack of seed
[    0.013080] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.013097] futex hash table entries: 512 (order: 3, 32768 bytes, 
linear)
[    0.013866] thermal_sys: Registered thermal governor 'step_wise'
[    0.013992] DMI not present or invalid.
[    0.014177] NET: Registered protocol family 16
[    0.015070] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic 
allocations
[    0.015781] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for 
atomic allocations
[    0.016510] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for 
atomic allocations
[    0.016545] audit: initializing netlink subsys (disabled)
[    0.016668] audit: type=2000 audit(0.016:1): state=initialized 
audit_enabled=0 res=1
[    0.016968] cpuidle: using governor menu
[    0.017039] hw-breakpoint: found 6 breakpoint and 4 watchpoint 
registers.
[    0.017069] ASID allocator initialised with 65536 entries
[    0.017337] Serial: AMBA PL011 UART driver
[    0.023506] Machine: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 
2.0 carrier
[    0.023520] SoC family: QorIQ LS1028A
[    0.023526] SoC ID: svr:0x870b0110, Revision: 1.0
[    0.026552] HugeTLB registered 1.00 GiB page size, pre-allocated 0 
pages
[    0.026567] HugeTLB registered 32.0 MiB page size, pre-allocated 0 
pages
[    0.026576] HugeTLB registered 2.00 MiB page size, pre-allocated 0 
pages
[    0.026583] HugeTLB registered 64.0 KiB page size, pre-allocated 0 
pages
[    0.027645] cryptd: max_cpu_qlen set to 1000
[    0.029118] iommu: Default domain type: Translated
[    0.029186] vgaarb: loaded
[    0.029328] SCSI subsystem initialized
[    0.029417] usbcore: registered new interface driver usbfs
[    0.029442] usbcore: registered new interface driver hub
[    0.029474] usbcore: registered new device driver usb
[    0.029610] imx-i2c 2000000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.029788] i2c i2c-0: IMX I2C adapter registered
[    0.029861] imx-i2c 2030000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.029932] i2c i2c-1: IMX I2C adapter registered
[    0.030004] imx-i2c 2040000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.030101] i2c i2c-2: IMX I2C adapter registered
[    0.030179] pps_core: LinuxPPS API ver. 1 registered
[    0.030186] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    0.030199] PTP clock support registered
[    0.030427] Advanced Linux Sound Architecture Driver Initialized.
[    0.030779] clocksource: Switched to clocksource arch_sys_counter
[    0.067056] VFS: Disk quotas dquot_6.6.0
[    0.067099] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    0.069799] NET: Registered protocol family 2
[    0.070030] tcp_listen_portaddr_hash hash table entries: 2048 (order: 
3, 32768 bytes, linear)
[    0.070055] TCP established hash table entries: 32768 (order: 6, 
262144 bytes, linear)
[    0.070147] TCP bind hash table entries: 32768 (order: 7, 524288 
bytes, linear)
[    0.070444] TCP: Hash tables configured (established 32768 bind 
32768)
[    0.070542] UDP hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070569] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070654] NET: Registered protocol family 1
[    0.070674] PCI: CLS 0 bytes, default 64
[    0.071038] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 
7 counters available
[    0.071494] Initialise system trusted keyrings
[    0.071617] workingset: timestamp_bits=44 max_order=20 bucket_order=0
[    0.105039] Key type asymmetric registered
[    0.105053] Asymmetric key parser 'x509' registered
[    0.105080] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 248)
[    0.105090] io scheduler mq-deadline registered
[    0.105097] io scheduler kyber registered
[    0.105625] pci-host-generic 1f0000000.pcie: host bridge 
/soc/pcie@1f0000000 ranges:
[    0.105654] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8000000..0x01f815ffff -> 0x0000000000
[    0.105675] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8160000..0x01f81cffff -> 0x0000000000
[    0.105694] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81d0000..0x01f81effff -> 0x0000000000
[    0.105713] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81f0000..0x01f820ffff -> 0x0000000000
[    0.105731] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8210000..0x01f822ffff -> 0x0000000000
[    0.105749] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8230000..0x01f824ffff -> 0x0000000000
[    0.105763] pci-host-generic 1f0000000.pcie:      MEM 
0x01fc000000..0x01fc3fffff -> 0x0000000000
[    0.105816] pci-host-generic 1f0000000.pcie: ECAM at [mem 
0x1f0000000-0x1f00fffff] for [bus 00]
[    0.105871] pci-host-generic 1f0000000.pcie: PCI host bridge to bus 
0000:00
[    0.105880] pci_bus 0000:00: root bus resource [bus 00]
[    0.105889] pci_bus 0000:00: root bus resource [mem 
0x1f8000000-0x1f815ffff] (bus address [0x00000000-0x0015ffff])
[    0.105901] pci_bus 0000:00: root bus resource [mem 
0x1f8160000-0x1f81cffff pref] (bus address [0x00000000-0x0006ffff])
[    0.105912] pci_bus 0000:00: root bus resource [mem 
0x1f81d0000-0x1f81effff] (bus address [0x00000000-0x0001ffff])
[    0.105923] pci_bus 0000:00: root bus resource [mem 
0x1f81f0000-0x1f820ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.105934] pci_bus 0000:00: root bus resource [mem 
0x1f8210000-0x1f822ffff] (bus address [0x00000000-0x0001ffff])
[    0.105944] pci_bus 0000:00: root bus resource [mem 
0x1f8230000-0x1f824ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.105955] pci_bus 0000:00: root bus resource [mem 
0x1fc000000-0x1fc3fffff] (bus address [0x00000000-0x003fffff])
[    0.105977] pci 0000:00:00.0: [1957:e100] type 00 class 0x020001
[    0.106018] pci 0000:00:00.0: BAR 0: [mem 0x1f8000000-0x1f803ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106031] pci 0000:00:00.0: BAR 2: [mem 0x1f8160000-0x1f816ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106044] pci 0000:00:00.0: VF BAR 0: [mem 0x1f81d0000-0x1f81dffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.106056] pci 0000:00:00.0: VF BAR 2: [mem 0x1f81f0000-0x1f81fffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.106080] pci 0000:00:00.0: PME# supported from D0 D3hot
[    0.106095] pci 0000:00:00.0: VF(n) BAR0 space: [mem 
0x1f81d0000-0x1f81effff 64bit] (contains BAR0 for 2 VFs)
[    0.106106] pci 0000:00:00.0: VF(n) BAR2 space: [mem 
0x1f81f0000-0x1f820ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.106220] pci 0000:00:00.1: [1957:e100] type 00 class 0x020001
[    0.106250] pci 0000:00:00.1: BAR 0: [mem 0x1f8040000-0x1f807ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106263] pci 0000:00:00.1: BAR 2: [mem 0x1f8170000-0x1f817ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106275] pci 0000:00:00.1: VF BAR 0: [mem 0x1f8210000-0x1f821ffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.106287] pci 0000:00:00.1: VF BAR 2: [mem 0x1f8230000-0x1f823ffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.106309] pci 0000:00:00.1: PME# supported from D0 D3hot
[    0.106323] pci 0000:00:00.1: VF(n) BAR0 space: [mem 
0x1f8210000-0x1f822ffff 64bit] (contains BAR0 for 2 VFs)
[    0.106334] pci 0000:00:00.1: VF(n) BAR2 space: [mem 
0x1f8230000-0x1f824ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.106428] pci 0000:00:00.2: [1957:e100] type 00 class 0x020001
[    0.106458] pci 0000:00:00.2: BAR 0: [mem 0x1f8080000-0x1f80bffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106470] pci 0000:00:00.2: BAR 2: [mem 0x1f8180000-0x1f818ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106491] pci 0000:00:00.2: PME# supported from D0 D3hot
[    0.106576] pci 0000:00:00.3: [1957:ee01] type 00 class 0x088001
[    0.106609] pci 0000:00:00.3: BAR 0: [mem 0x1f8100000-0x1f811ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106621] pci 0000:00:00.3: BAR 2: [mem 0x1f8190000-0x1f819ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106642] pci 0000:00:00.3: PME# supported from D0 D3hot
[    0.106727] pci 0000:00:00.4: [1957:ee02] type 00 class 0x088001
[    0.106756] pci 0000:00:00.4: BAR 0: [mem 0x1f8120000-0x1f813ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106768] pci 0000:00:00.4: BAR 2: [mem 0x1f81a0000-0x1f81affff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106805] pci 0000:00:00.4: PME# supported from D0 D3hot
[    0.106891] pci 0000:00:00.5: [1957:eef0] type 00 class 0x020801
[    0.106921] pci 0000:00:00.5: BAR 0: [mem 0x1f8140000-0x1f815ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106933] pci 0000:00:00.5: BAR 2: [mem 0x1f81b0000-0x1f81bffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106944] pci 0000:00:00.5: BAR 4: [mem 0x1fc000000-0x1fc3fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106965] pci 0000:00:00.5: PME# supported from D0 D3hot
[    0.107054] pci 0000:00:00.6: [1957:e100] type 00 class 0x020001
[    0.107083] pci 0000:00:00.6: BAR 0: [mem 0x1f80c0000-0x1f80fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.107095] pci 0000:00:00.6: BAR 2: [mem 0x1f81c0000-0x1f81cffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.107116] pci 0000:00:00.6: PME# supported from D0 D3hot
[    0.107877] pci 0000:00:1f.0: [1957:e001] type 00 class 0x080700
[    0.107923] OF: /soc/pcie@1f0000000: no msi-map translation for rid 
0xf8 on (null)
[    0.108232] layerscape-pcie 3400000.pcie: host bridge 
/soc/pcie@3400000 ranges:
[    0.108257] layerscape-pcie 3400000.pcie:       IO 
0x8000010000..0x800001ffff -> 0x0000000000
[    0.108274] layerscape-pcie 3400000.pcie:      MEM 
0x8040000000..0x807fffffff -> 0x0040000000
[    0.108361] layerscape-pcie 3400000.pcie: PCI host bridge to bus 
0001:00
[    0.108370] pci_bus 0001:00: root bus resource [bus 00-ff]
[    0.108378] pci_bus 0001:00: root bus resource [io  0x0000-0xffff]
[    0.108387] pci_bus 0001:00: root bus resource [mem 
0x8040000000-0x807fffffff] (bus address [0x40000000-0x7fffffff])
[    0.108408] pci 0001:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.108468] pci 0001:00:00.0: supports D1 D2
[    0.108475] pci 0001:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.109903] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.109917] pci 0001:00:00.0: PCI bridge to [bus 01]
[    0.110006] layerscape-pcie 3500000.pcie: host bridge 
/soc/pcie@3500000 ranges:
[    0.110029] layerscape-pcie 3500000.pcie:       IO 
0x8800010000..0x880001ffff -> 0x0000000000
[    0.110045] layerscape-pcie 3500000.pcie:      MEM 
0x8840000000..0x887fffffff -> 0x0040000000
[    0.110123] layerscape-pcie 3500000.pcie: PCI host bridge to bus 
0002:00
[    0.110132] pci_bus 0002:00: root bus resource [bus 00-ff]
[    0.110140] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff] 
(bus address [0x0000-0xffff])
[    0.110151] pci_bus 0002:00: root bus resource [mem 
0x8840000000-0x887fffffff] (bus address [0x40000000-0x7fffffff])
[    0.110171] pci 0002:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.110230] pci 0002:00:00.0: supports D1 D2
[    0.110237] pci 0002:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.111677] pci_bus 0002:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.111690] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.111962] IPMI message handler: version 39.2
[    0.111989] ipmi device interface
[    0.112014] ipmi_si: IPMI System Interface driver
[    0.112131] ipmi_si: Unable to find any System Interface(s)
[    0.113571] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.114271] 21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.695285] printk: console [ttyS0] enabled
[    1.699735] 21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.708845] 2270000.serial: ttyLP2 at MMIO 0x2270000 (irq = 17, 
base_baud = 12500000) is a FSL_LPUART
[    1.718915] arm-smmu 5000000.iommu: probing hardware configuration...
[    1.725399] arm-smmu 5000000.iommu: SMMUv2 with:
[    1.730041] arm-smmu 5000000.iommu:  stage 1 translation
[    1.735387] arm-smmu 5000000.iommu:  stage 2 translation
[    1.740726] arm-smmu 5000000.iommu:  nested translation
[    1.745977] arm-smmu 5000000.iommu:  stream matching with 128 
register groups
[    1.753146] arm-smmu 5000000.iommu:  64 context banks (0 stage-2 
only)
[    1.759709] arm-smmu 5000000.iommu:  Supported page sizes: 0x61311000
[    1.766177] arm-smmu 5000000.iommu:  Stage-1: 48-bit VA -> 48-bit IPA
[    1.772644] arm-smmu 5000000.iommu:  Stage-2: 48-bit IPA -> 48-bit PA
[    1.779620] at24 0-0050: supply vcc not found, using dummy regulator
[    1.786797] at24 0-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    1.793667] at24 1-0057: supply vcc not found, using dummy regulator
[    1.800812] at24 1-0057: 8192 byte 24c64 EEPROM, writable, 32 
bytes/write
[    1.807680] at24 2-0050: supply vcc not found, using dummy regulator
[    1.814812] at24 2-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    1.822379] sl28cpld 0-004a: successfully probed. CPLD version 18
[    1.829631] gpio_sl28cpld sl28cpld-gpio: registered IRQ 108
[    1.840850] gpio_sl28cpld sl28cpld-gpio.0: registered IRQ 108
[    1.852473] irq_sl28cpld sl28cpld-intc: registered IRQ 108
[    1.858081] mpt3sas version 34.100.00.00 loaded
[    1.863428] header.nph=2
[    1.865969] sfdp_size=288
[    1.868743] spi-nor spi1.0: mx25u3235f (4096 Kbytes)
[    1.875737] header.nph=0
[    1.878280] sfdp_size=192
[    1.880953] spi-nor spi0.0: w25q32dw (4096 Kbytes)
[    1.887272] 10 fixed-partitions partitions found on MTD device 
20c0000.spi
[    1.894187] Creating 10 MTD partitions on "20c0000.spi":
[    1.899536] 0x000000000000-0x000000010000 : "rcw"
[    1.911091] 0x000000010000-0x000000100000 : "failsafe bootloader"
[    1.927079] 0x000000100000-0x000000140000 : "failsafe DP firmware"
[    1.935127] 0x000000140000-0x0000001e0000 : "failsafe trusted 
firmware"
[    1.943100] 0x0000001e0000-0x000000200000 : "reserved"
[    1.951111] 0x000000200000-0x000000210000 : "configuration store"
[    1.959097] 0x000000210000-0x000000300000 : "bootloader"
[    1.967111] 0x000000300000-0x000000340000 : "DP firmware"
[    1.975107] 0x000000340000-0x0000003e0000 : "trusted firmware"
[    1.983108] 0x0000003e0000-0x000000400000 : "bootloader environment"
[    1.991731] libphy: Fixed MDIO Bus: probed
[    1.996040] mscc_felix 0000:00:00.5: Adding to iommu group 0
[    2.001862] mscc_felix 0000:00:00.5: device is disabled, skipping
[    2.008040] fsl_enetc 0000:00:00.0: Adding to iommu group 1
[    2.118796] fsl_enetc 0000:00:00.0: enabling device (0400 -> 0402)
[    2.125042] fsl_enetc 0000:00:00.0: no MAC address specified for SI1, 
using ae:56:33:78:dd:46
[    2.133609] fsl_enetc 0000:00:00.0: no MAC address specified for SI2, 
using 56:54:55:fc:0f:b6
[    2.142520] libphy: Freescale ENETC MDIO Bus: probed
[    2.149117] fsl_enetc 0000:00:00.1: Adding to iommu group 2
[    2.154838] fsl_enetc 0000:00:00.1: device is disabled, skipping
[    2.160912] fsl_enetc 0000:00:00.2: Adding to iommu group 3
[    2.166586] fsl_enetc 0000:00:00.2: device is disabled, skipping
[    2.172656] fsl_enetc 0000:00:00.6: Adding to iommu group 4
[    2.178326] fsl_enetc 0000:00:00.6: device is disabled, skipping
[    2.184426] fsl_enetc_mdio 0000:00:00.3: Adding to iommu group 5
[    2.294790] fsl_enetc_mdio 0000:00:00.3: enabling device (0400 -> 
0402)
[    2.301615] libphy: FSL PCIe IE Central MDIO Bus: probed
[    2.306989] igb: Intel(R) Gigabit Ethernet Network Driver - version 
5.6.0-k
[    2.313983] igb: Copyright (c) 2007-2014 Intel Corporation.
[    2.319682] dwc3 3100000.usb: Adding to iommu group 6
[    2.325036] ------------[ cut here ]------------
[    2.329678] sup:5000000.iommu - con:3100000.usb f:68 s:1
[    2.335039] WARNING: CPU: 0 PID: 1 at drivers/base/core.c:915 
device_links_driver_bound+0x1ec/0x230
[    2.344119] Modules linked in:
[    2.347182] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #815
[    2.357048] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    2.365345] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    2.370935] pc : device_links_driver_bound+0x1ec/0x230
[    2.376090] lr : device_links_driver_bound+0x1ec/0x230
[    2.381242] sp : ffff8000111dbb70
[    2.384564] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    2.389893] x27: ffff00207a420c90 x26: ffff800010be8130
[    2.395223] x25: 0000000000000003 x24: ffff00207a420cb0
[    2.400552] x23: ffff800011039948 x22: ffff8000111dbbd8
[    2.405880] x21: ffff00207a420c10 x20: ffff8000110d2d80
[    2.411208] x19: ffff00207a401100 x18: 0000000000000010
[    2.416536] x17: ffffffffffff3f00 x16: 0000000000007fff
[    2.421864] x15: ffffffffffffffff x14: 0720072007200720
[    2.427192] x13: 0720072007200720 x12: 0720072007200720
[    2.432521] x11: 0720072007200720 x10: 0720072007200720
[    2.437849] x9 : ffff800010091f64 x8 : 072007380736073a
[    2.443177] x7 : 000000000000012c x6 : ffff00207ac21f00
[    2.448505] x5 : 0000000000000000 x4 : 0000000000000000
[    2.453833] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    2.459161] x1 : c4bf1185730d5000 x0 : 0000000000000000
[    2.464490] Call trace:
[    2.466941]  device_links_driver_bound+0x1ec/0x230
[    2.471748]  driver_bound+0x70/0xc0
[    2.475246]  really_probe+0x110/0x318
[    2.478917]  driver_probe_device+0x40/0x90
[    2.483025]  device_driver_attach+0x7c/0x88
[    2.487220]  __driver_attach+0x60/0xe8
[    2.490978]  bus_for_each_dev+0x7c/0xd0
[    2.494824]  driver_attach+0x2c/0x38
[    2.498408]  bus_add_driver+0x194/0x1f8
[    2.502254]  driver_register+0x6c/0x128
[    2.506100]  __platform_driver_register+0x50/0x60
[    2.510820]  dwc3_driver_init+0x24/0x30
[    2.514668]  do_one_initcall+0x54/0x298
[    2.518515]  kernel_init_freeable+0x1ec/0x268
[    2.522885]  kernel_init+0x1c/0x118
[    2.526382]  ret_from_fork+0x10/0x1c
[    2.529967] ---[ end trace 1dedfde488772a9f ]---
[    2.534662] dwc3 3110000.usb: Adding to iommu group 7
[    2.539966] ------------[ cut here ]------------
[    2.544606] sup:5000000.iommu - con:3110000.usb f:68 s:1
[    2.549954] WARNING: CPU: 0 PID: 1 at drivers/base/core.c:915 
device_links_driver_bound+0x1ec/0x230
[    2.559034] Modules linked in:
[    2.562096] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #815
[    2.573356] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    2.581652] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    2.587243] pc : device_links_driver_bound+0x1ec/0x230
[    2.592397] lr : device_links_driver_bound+0x1ec/0x230
[    2.597550] sp : ffff8000111dbb70
[    2.600870] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    2.606199] x27: ffff00207a421090 x26: ffff800010be8130
[    2.611528] x25: 0000000000000003 x24: ffff00207a4210b0
[    2.616856] x23: ffff800011039948 x22: ffff8000111dbbd8
[    2.622184] x21: ffff00207a421010 x20: ffff8000110d2d80
[    2.627512] x19: ffff00207a401180 x18: 0000000000000010
[    2.632840] x17: ffffffffffff3f00 x16: 0000000000007fff
[    2.638168] x15: ffffffffffffffff x14: 0720072007200720
[    2.643496] x13: 0720072007200720 x12: 0720072007200720
[    2.648824] x11: 0720072007200720 x10: 0720072007200720
[    2.654153] x9 : ffff800010091f64 x8 : 072007380736073a
[    2.659481] x7 : 0000000000000158 x6 : ffff00207ac21f00
[    2.664809] x5 : 0000000000000000 x4 : 0000000000000000
[    2.670137] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    2.675466] x1 : c4bf1185730d5000 x0 : 0000000000000000
[    2.680794] Call trace:
[    2.683244]  device_links_driver_bound+0x1ec/0x230
[    2.688049]  driver_bound+0x70/0xc0
[    2.691545]  really_probe+0x110/0x318
[    2.695217]  driver_probe_device+0x40/0x90
[    2.699324]  device_driver_attach+0x7c/0x88
[    2.703519]  __driver_attach+0x60/0xe8
[    2.707277]  bus_for_each_dev+0x7c/0xd0
[    2.711123]  driver_attach+0x2c/0x38
[    2.714707]  bus_add_driver+0x194/0x1f8
[    2.718553]  driver_register+0x6c/0x128
[    2.722399]  __platform_driver_register+0x50/0x60
[    2.727117]  dwc3_driver_init+0x24/0x30
[    2.730963]  do_one_initcall+0x54/0x298
[    2.734810]  kernel_init_freeable+0x1ec/0x268
[    2.739179]  kernel_init+0x1c/0x118
[    2.742676]  ret_from_fork+0x10/0x1c
[    2.746259] ---[ end trace 1dedfde488772aa0 ]---
[    2.751063] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) 
Driver
[    2.757621] ehci-pci: EHCI PCI platform driver
[    2.762269] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.767791] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 1
[    2.775619] xhci-hcd xhci-hcd.0.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    2.785077] xhci-hcd xhci-hcd.0.auto: irq 21, io mem 0x03100000
[    2.791398] hub 1-0:1.0: USB hub found
[    2.795180] hub 1-0:1.0: 1 port detected
[    2.799226] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.804742] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 2
[    2.812437] xhci-hcd xhci-hcd.0.auto: Host supports USB 3.0 
SuperSpeed
[    2.819034] usb usb2: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    2.827373] hub 2-0:1.0: USB hub found
[    2.831156] hub 2-0:1.0: 1 port detected
[    2.835232] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    2.840754] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 3
[    2.848592] xhci-hcd xhci-hcd.1.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    2.858072] xhci-hcd xhci-hcd.1.auto: irq 22, io mem 0x03110000
[    2.864341] hub 3-0:1.0: USB hub found
[    2.868123] hub 3-0:1.0: 1 port detected
[    2.872161] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    2.877676] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 4
[    2.885372] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0 
SuperSpeed
[    2.891965] usb usb4: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    2.900305] hub 4-0:1.0: USB hub found
[    2.904166] hub 4-0:1.0: 1 port detected
[    2.908296] usbcore: registered new interface driver usb-storage
[    2.914499] input: buttons1 as 
/devices/platform/buttons1/input/input0
[    2.922390] rtc-rv8803 0-0032: Voltage low, temperature compensation 
stopped.
[    2.929561] rtc-rv8803 0-0032: Voltage low, data loss detected.
[    2.936566] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    2.942408] rtc-rv8803 0-0032: registered as rtc0
[    2.947738] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    2.953426] rtc-rv8803 0-0032: hctosys: unable to read the hardware 
clock
[    2.960324] i2c /dev entries driver
[    2.969874] sp805-wdt c000000.watchdog: registration successful
[    2.975903] sp805-wdt c010000.watchdog: registration successful
[    2.983636] sl28cpld_wdt sl28cpld-wdt: initial timeout 6 sec
[    2.989890] qoriq-cpufreq qoriq-cpufreq: Freescale QorIQ CPU 
frequency scaling driver
[    2.998408] sdhci: Secure Digital Host Controller Interface driver
[    3.004669] sdhci: Copyright(c) Pierre Ossman
[    3.009082] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.015604] sdhci-esdhc 2140000.mmc: Adding to iommu group 8
[    3.048548] mmc0: SDHCI controller on 2140000.mmc [2140000.mmc] using 
ADMA
[    3.055568] ------------[ cut here ]------------
[    3.060295] sup:5000000.iommu - con:2140000.mmc f:68 s:1
[    3.065824] WARNING: CPU: 0 PID: 1 at drivers/base/core.c:915 
device_links_driver_bound+0x1ec/0x230
[    3.074940] Modules linked in:
[    3.078032] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #815
[    3.089325] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.097654] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    3.103272] pc : device_links_driver_bound+0x1ec/0x230
[    3.108451] lr : device_links_driver_bound+0x1ec/0x230
[    3.113624] sp : ffff8000111dbb70
[    3.116964] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    3.122320] x27: ffff00207a41a490 x26: ffff800010be8130
[    3.127676] x25: 0000000000000003 x24: ffff00207a41a4b0
[    3.133030] x23: ffff800011039948 x22: ffff8000111dbbd8
[    3.138384] x21: ffff00207a41a410 x20: ffff8000110d2d80
[    3.143737] x19: ffff00207affdf00 x18: 0000000000000000
[    3.149090] x17: 0000000000000002 x16: 0000000000000001
[    3.154443] x15: 0000000000000000 x14: 00000000000004c4
[    3.159797] x13: 0000000000000003 x12: 0000000000000000
[    3.165150] x11: 00000000000003fe x10: 00000000000009f0
[    3.170503] x9 : ffff800010091f64 x8 : ffff00207ae50a50
[    3.175857] x7 : ffff80206e9df000 x6 : 0000000000000001
[    3.181209] x5 : 0000000000000000 x4 : 0000000000000000
[    3.186562] x3 : ffff80206e9df000 x2 : ffff80001105b6c8
[    3.191915] x1 : c4bf1185730d5000 x0 : 0000000000000000
[    3.197268] Call trace:
[    3.199742]  device_links_driver_bound+0x1ec/0x230
[    3.204574]  driver_bound+0x70/0xc0
[    3.208095]  really_probe+0x110/0x318
[    3.211791]  driver_probe_device+0x40/0x90
[    3.215925]  device_driver_attach+0x7c/0x88
[    3.220144]  __driver_attach+0x60/0xe8
[    3.223926]  bus_for_each_dev+0x7c/0xd0
[    3.227794]  driver_attach+0x2c/0x38
[    3.231402]  bus_add_driver+0x194/0x1f8
[    3.235272]  driver_register+0x6c/0x128
[    3.239140]  __platform_driver_register+0x50/0x60
[    3.243883]  sdhci_esdhc_driver_init+0x24/0x30
[    3.248364]  do_one_initcall+0x54/0x298
[    3.252237]  kernel_init_freeable+0x1ec/0x268
[    3.256630]  kernel_init+0x1c/0x118
[    3.260150]  ret_from_fork+0x10/0x1c
[    3.263753] ---[ end trace 1dedfde488772aa1 ]---
[    3.269383] sdhci-esdhc 2150000.mmc: Adding to iommu group 9
[    3.302631] mmc1: SDHCI controller on 2150000.mmc [2150000.mmc] using 
ADMA
[    3.309672] ------------[ cut here ]------------
[    3.314415] sup:5000000.iommu - con:2150000.mmc f:68 s:1
[    3.319907] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:915 
device_links_driver_bound+0x1ec/0x230
[    3.329018] Modules linked in:
[    3.332109] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #815
[    3.343403] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.351733] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    3.357351] pc : device_links_driver_bound+0x1ec/0x230
[    3.362530] lr : device_links_driver_bound+0x1ec/0x230
[    3.367703] sp : ffff8000111dbb70
[    3.371043] x29: ffff8000111dbb70 x28: ffff00207a421c10
[    3.376402] x27: ffff00207a41a890 x26: ffff800010be8130
[    3.381759] x25: 0000000000000003 x24: ffff00207a41a8b0
[    3.387114] x23: ffff800011039948 x22: ffff8000111dbbd8
[    3.392468] x21: ffff00207a41a810 x20: ffff8000110d2d80
[    3.394852] usb 3-1: new high-speed USB device number 2 using 
xhci-hcd
[    3.397820] x19: ffff00207affdf80 x18: 0000000000000010
[    3.409742] x17: 0000000000000000 x16: 0000000000000003
[    3.415096] x15: ffffffffffffffff x14: 0720072007200720
[    3.420450] x13: 0720072007200720 x12: 0720072007200720
[    3.425804] x11: 0720072007200720 x10: 00000000000009f0
[    3.431158] x9 : ffff800010091f64 x8 : ffff00207ae50a50
[    3.436511] x7 : 00000000ffffffff x6 : 0000000000000001
[    3.441865] x5 : 0000000000007af8 x4 : 0000000000000000
[    3.447218] x3 : ffff80206e9fd000 x2 : ffff80001105b6c8
[    3.452571] x1 : c4bf1185730d5000 x0 : 0000000000000000
[    3.457925] Call trace:
[    3.460400]  device_links_driver_bound+0x1ec/0x230
[    3.465234]  driver_bound+0x70/0xc0
[    3.468755]  really_probe+0x110/0x318
[    3.472451]  driver_probe_device+0x40/0x90
[    3.476584]  device_driver_attach+0x7c/0x88
[    3.480805]  __driver_attach+0x60/0xe8
[    3.484586]  bus_for_each_dev+0x7c/0xd0
[    3.488455]  driver_attach+0x2c/0x38
[    3.492062]  bus_add_driver+0x194/0x1f8
[    3.495932]  driver_register+0x6c/0x128
[    3.499800]  __platform_driver_register+0x50/0x60
[    3.504543]  sdhci_esdhc_driver_init+0x24/0x30
[    3.509022]  do_one_initcall+0x54/0x298
[    3.512895]  kernel_init_freeable+0x1ec/0x268
[    3.517289]  kernel_init+0x1c/0x118
[    3.520808]  ret_from_fork+0x10/0x1c
[    3.524411] ---[ end trace 1dedfde488772aa2 ]---
[    3.531059] usbcore: registered new interface driver usbhid
[    3.536930] usbhid: USB HID core driver
[    3.542739] wm8904 2-001a: supply DCVDD not found, using dummy 
regulator
[    3.551906] wm8904 2-001a: supply DBVDD not found, using dummy 
regulator
[    3.558984] wm8904 2-001a: supply AVDD not found, using dummy 
regulator
[    3.568758] wm8904 2-001a: supply CPVDD not found, using dummy 
regulator
[    3.575809] wm8904 2-001a: supply MICVDD not found, using dummy 
regulator
[    3.585270] wm8904 2-001a: revision A
[    3.592667] random: fast init done
[    3.596550] hub 3-1:1.0: USB hub found
[    3.600618] hub 3-1:1.0: 7 ports detected
[    3.607057] mmc0: new ultra high speed SDR104 SDHC card at address 
1234
[    3.614693] NET: Registered protocol family 10
[    3.614811] mmcblk0: mmc0:1234 SA16G 14.4 GiB
[    3.620859] Segment Routing with IPv6
[    3.628371]  mmcblk0: p1
[    3.629054] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    3.638317] NET: Registered protocol family 17
[    3.643004] Bridge firewalling registered
[    3.647331] 8021q: 802.1Q VLAN Support v1.8
[    3.651847] Key type dns_resolver registered
[    3.656831] registered taskstats version 1
[    3.662880] Loading compiled-in X.509 certificates
[    3.674933] fsl-edma 22c0000.dma-controller: Adding to iommu group 10
[    3.684717] ------------[ cut here ]------------
[    3.689545] sup:5000000.iommu - con:22c0000.dma-controller f:68 s:1
[    3.696078] WARNING: CPU: 0 PID: 82 at drivers/base/core.c:915 
device_links_driver_bound+0x1ec/0x230
[    3.705275] Modules linked in:
[    3.708368] CPU: 0 PID: 82 Comm: kworker/0:3 Tainted: G        W      
    5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #815
[    3.719924] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.728262] Workqueue: events deferred_probe_work_func
[    3.733448] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    3.739065] pc : device_links_driver_bound+0x1ec/0x230
[    3.744244] lr : device_links_driver_bound+0x1ec/0x230
[    3.749417] sp : ffff8000123d3b70
[    3.752757] x29: ffff8000123d3b70 x28: ffff00207a421c10
[    3.758116] x27: ffff00207a41bc90 x26: ffff800010be8130
[    3.763473] x25: 0000000000000003 x24: ffff00207a41bcb0
[    3.768827] x23: ffff800011039948 x22: ffff8000123d3bd8
[    3.774181] x21: ffff00207a41bc10 x20: ffff8000110d2d80
[    3.779535] x19: ffff00207a401080 x18: 0000000000000010
[    3.784890] x17: 000000000f459d73 x16: 00000000f67948ef
[    3.790244] x15: ffffffffffffffff x14: 0720072007200720
[    3.795598] x13: 0720072007200720 x12: 072007200731073a
[    3.800951] x11: 0773072007380736 x10: 073a076607200772
[    3.806305] x9 : ffff800010091f64 x8 : 07720774076e076f
[    3.811658] x7 : 0000000000000220 x6 : ffff00207ac21f00
[    3.817012] x5 : 0000000000000000 x4 : 0000000000000000
[    3.822365] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    3.827718] x1 : c4bf1185730d5000 x0 : 0000000000000000
[    3.833073] Call trace:
[    3.835548]  device_links_driver_bound+0x1ec/0x230
[    3.840381]  driver_bound+0x70/0xc0
[    3.843902]  really_probe+0x110/0x318
[    3.847599]  driver_probe_device+0x40/0x90
[    3.851732]  __device_attach_driver+0x8c/0xd0
[    3.856124]  bus_for_each_drv+0x84/0xd8
[    3.859994]  __device_attach+0xd4/0x110
[    3.863863]  device_initial_probe+0x1c/0x28
[    3.868082]  bus_probe_device+0xa4/0xb0
[    3.871952]  deferred_probe_work_func+0x7c/0xb8
[    3.876525]  process_one_work+0x1f4/0x4b8
[    3.880571]  worker_thread+0x218/0x498
[    3.884355]  kthread+0x160/0x168
[    3.887613]  ret_from_fork+0x10/0x1c
[    3.891218] ---[ end trace 1dedfde488772aa4 ]---
[    3.896564] pcieport 0001:00:00.0: Adding to iommu group 11
[    3.903497] mmc1: new HS400 MMC card at address 0001
[    3.908759] pcieport 0001:00:00.0: AER: enabled with IRQ 24
[    3.909534] mmcblk1: mmc1:0001 S0J58X 29.6 GiB
[    3.914825] pcieport 0002:00:00.0: Adding to iommu group 12
[    3.919508] mmcblk1boot0: mmc1:0001 S0J58X partition 1 31.5 MiB
[    3.930861] pcieport 0002:00:00.0: AER: enabled with IRQ 26
[    3.931274] mmcblk1boot1: mmc1:0001 S0J58X partition 2 31.5 MiB
[    3.936999] fsl-qdma 8380000.dma-controller: Adding to iommu group 13
[    3.942697] mmcblk1rpmb: mmc1:0001 S0J58X partition 3 4.00 MiB, 
chardev (245:0)
[    3.950312] ------------[ cut here ]------------
[    3.961397] sup:5000000.iommu - con:8380000.dma-controller f:68 s:1
[    3.961424]  mmcblk1: p1 p2
[    3.967817] WARNING: CPU: 0 PID: 82 at drivers/base/core.c:915 
device_links_driver_bound+0x1ec/0x230
[    3.979759] Modules linked in:
[    3.982851] CPU: 0 PID: 82 Comm: kworker/0:3 Tainted: G        W      
    5.7.0-rc7-next-20200525-00039-gfb6df8136807-dirty #815
[    3.994405] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    4.002743] Workqueue: events deferred_probe_work_func
[    4.007928] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    4.013545] pc : device_links_driver_bound+0x1ec/0x230
[    4.018723] lr : device_links_driver_bound+0x1ec/0x230
[    4.023897] sp : ffff8000123d3b70
[    4.027236] x29: ffff8000123d3b70 x28: ffff00207a421c10
[    4.032592] x27: ffff00207a422090 x26: ffff800010be8130
[    4.037947] x25: 0000000000000003 x24: ffff00207a4220b0
[    4.043301] x23: ffff800011039948 x22: ffff8000123d3bd8
[    4.048655] x21: ffff00207a422010 x20: ffff8000110d2d80
[    4.054009] x19: ffff00207a401300 x18: 0000000000000010
[    4.059363] x17: 0000000000000002 x16: 0000000000000003
[    4.064717] x15: ffffffffffffffff x14: 0720072007200720
[    4.070070] x13: 0720072007200720 x12: 072007200731073a
[    4.075423] x11: 0773072007380736 x10: 073a076607200772
[    4.080776] x9 : ffff800010091f64 x8 : 07720774076e076f
[    4.086130] x7 : 0763072d0761076d x6 : ffff00207ac21f00
[    4.091483] x5 : 0000000000000000 x4 : 0000000000000000
[    4.096837] x3 : 00000000ffffffff x2 : ffff80001105b6c8
[    4.102191] x1 : c4bf1185730d5000 x0 : 0000000000000000
[    4.107545] Call trace:
[    4.110018]  device_links_driver_bound+0x1ec/0x230
[    4.114850]  driver_bound+0x70/0xc0
[    4.118371]  really_probe+0x110/0x318
[    4.122066]  driver_probe_device+0x40/0x90
[    4.126200]  __device_attach_driver+0x8c/0xd0
[    4.130593]  bus_for_each_drv+0x84/0xd8
[    4.134463]  __device_attach+0xd4/0x110
[    4.138333]  device_initial_probe+0x1c/0x28
[    4.142552]  bus_probe_device+0xa4/0xb0
[    4.146422]  deferred_probe_work_func+0x7c/0xb8
[    4.150994]  process_one_work+0x1f4/0x4b8
[    4.155040]  worker_thread+0x218/0x498
[    4.158824]  kthread+0x160/0x168
[    4.162083]  ret_from_fork+0x10/0x1c
[    4.165686] ---[ end trace 1dedfde488772aa5 ]---
[    4.177076] asoc-simple-card sound: wm8904-hifi <-> 
f150000.audio-controller mapping ok
[    4.187367] asoc-simple-card sound: wm8904-hifi <-> 
f140000.audio-controller mapping ok
[    4.195570] asoc-simple-card sound: ASoC: no DMI vendor name!
[    4.207494] input: buttons0 as 
/devices/platform/buttons0/input/input1
[    4.214771] ALSA device list:
[    4.217820]   #0: f150000.audio-controller-wm8904-hifi
[    4.227909] EXT4-fs (mmcblk1p2): INFO: recovery required on readonly 
filesystem
[    4.235322] EXT4-fs (mmcblk1p2): write access will be enabled during 
recovery
[    4.274456] EXT4-fs (mmcblk1p2): recovery complete
[    4.281568] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data 
mode. Opts: (null)
[    4.282852] usb 3-1.6: new full-speed USB device number 3 using 
xhci-hcd
[    4.289831] VFS: Mounted root (ext4 filesystem) readonly on device 
179:34.
[    4.304060] devtmpfs: mounted
[    4.318148] Freeing unused kernel memory: 3328K
[    4.322986] Run /sbin/init as init process
[    4.327143]   with arguments:
[    4.330136]     /sbin/init
[    4.332884]   with environment:
[    4.336071]     HOME=/
[    4.338451]     TERM=linux
[    4.390182] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[    4.565675] udevd[130]: starting version 3.2.8
[    4.572326] random: udevd: uninitialized urandom read (16 bytes read)
[    4.580164] random: udevd: uninitialized urandom read (16 bytes read)
[    4.586913] random: udevd: uninitialized urandom read (16 bytes read)
[    4.598510] udevd[130]: specified group 'kvm' unknown
[    4.626307] udevd[131]: starting eudev-3.2.8
[    6.878045] fsl_enetc 0000:00:00.0 gbe0: renamed from eth0
[    9.740520] urandom_read: 3 callbacks suppressed
[    9.740534] random: dd: uninitialized urandom read (512 bytes read)
[    9.903952] Qualcomm Atheros AR8031/AR8033 0000:00:00.0:05: attached 
PHY driver [Qualcomm Atheros AR8031/AR8033] 
(mii_bus:phy_addr=0000:00:00.0:05, irq=POLL)
[    9.936327] fsl_enetc 0000:00:00.0 gbe0: Link is Down
[    9.992936] random: dropbear: uninitialized urandom read (32 bytes 
read)
[   11.971438] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 10Mbps/Full - 
flow control off
[   11.979324] IPv6: ADDRCONF(NETDEV_CHANGE): gbe0: link becomes ready
[   12.995161] fsl_enetc 0000:00:00.0 gbe0: Link is Down
[   15.043470] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 1Gbps/Full - 
flow control off

-michael
