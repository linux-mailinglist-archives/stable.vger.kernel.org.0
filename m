Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4760D1DF1BD
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 00:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbgEVWWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 18:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731116AbgEVWWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 18:22:07 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D89CC05BD43
        for <stable@vger.kernel.org>; Fri, 22 May 2020 15:22:07 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id f18so9409310otq.11
        for <stable@vger.kernel.org>; Fri, 22 May 2020 15:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfptrvMWBtgX9tvbuyOEQo1LxSRDGF4/RoDb1PYhfGM=;
        b=bL9NU5oAyBKWR0LFG+edH8QQZpvEXSF5ThHfScGkLJMwkzZ3oAp0kawpQgqzm5d3F8
         UZIoayx63feUyzEz4t1fI1LQ+JNSonSn8L70/EGslRAa03QipHi7GJMKIHTyj+RR6wED
         N74OMEEDrkrlKTVTINDJTa42ypijBwYZFN3cEHnmc3k1cml5bfid+OPZ8hH+Hd5P5nmA
         jx6TsvlY3f/XCtgi7tMawfYsGJ9knHfnicGC+k9Wk6/lTyedTulJGtwB9JTaSWYz7myB
         tKB4KapRzBjSxGjcT+9SCWSaUoLZvRbZsZ6wboLj++7wu+EST0ioZJcF3KPr4QdSmm+O
         yhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfptrvMWBtgX9tvbuyOEQo1LxSRDGF4/RoDb1PYhfGM=;
        b=jjh94zgJz+tcV/7XHUY5h9FkY9Zd3S6W2IOPh6p2MtoaKVbLFg5JI7MIGfATVqwFwd
         8dNl45khilSHxglRcciQgMr3Ug8yfUS+2GSCnRYKdesDeWn4FYo1UvFR2rRMovpoatgy
         +xam24apZINzfVBYsxj+weyOwpGPtSdjnWeEDO7cwLBWS/07vMYJxcgykNoxJUAMXXoZ
         TZlSxh2kgghHw7bis8oZq/VnjhxSkLdB6OxTYQK5aHZram0QXw9j30S2a71pcMjVFIh2
         Ujn+fPEyF5afy19oQ65AjEOII2kGEVimKTqUkRLe1oGhtRWdfsgMmTpiT4zQLRmPoo4e
         2MlA==
X-Gm-Message-State: AOAM53327EGgIRLRkdT1TGlIMMk8ySbty8Jm7l6OW+6KhYT4C6EzRxTe
        9JxC2Xu8IFdMYfPVDPIrw7irPdUiKmCDfUz2eoh23Fy0
X-Google-Smtp-Source: ABdhPJyJ4fTsjSUFAFSueDYa7qujrybz5oxz2acmvKt2tEQ2/TSDESLz3DWx65VNEyFHkRTpHJo0miwG6fdWtWwXu8o=
X-Received: by 2002:a05:6830:18ec:: with SMTP id d12mr13285247otf.139.1590186125942;
 Fri, 22 May 2020 15:22:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200518080327.GA3126260@kroah.com> <20200519063000.128819-1-saravanak@google.com>
 <20200522204120.3b3c9ed6@apollo>
In-Reply-To: <20200522204120.3b3c9ed6@apollo>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 22 May 2020 15:21:29 -0700
Message-ID: <CAGETcx85trw=rCM1+dmemMGKstFCq=Nn7HR2fyDyV0rTTQYtEQ@mail.gmail.com>
Subject: Re: [PATCH v3] driver core: Fix SYNC_STATE_ONLY device link implementation
To:     Michael Walle <michael@walle.cc>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 11:41 AM Michael Walle <michael@walle.cc> wrote:
>
> Am Mon, 18 May 2020 23:30:00 -0700
> schrieb Saravana Kannan <saravanak@google.com>:
>
> > When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> > core: Add device link support for SYNC_STATE_ONLY flag"),
> > device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
> > device link to the supplier's and consumer's "device link" list.
> >
> > This causes multiple issues:
> > - The device link is lost forever from driver core if the caller
> >   didn't keep track of it (caller typically isn't expected to). This
> > is a memory leak.
> > - The device link is also never visible to any other code path after
> >   device_link_add() returns.
> >
> > If we fix the "device link" list handling, that exposes a bunch of
> > issues.
> >
> > 1. The device link "status" state management code rightfully doesn't
> > handle the case where a DL_FLAG_MANAGED device link exists between a
> > supplier and consumer, but the consumer manages to probe successfully
> > before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links
> > break this assumption. This causes device_links_driver_bound() to
> > throw a warning when this happens.
> >
> > Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for
> > creating proxy device links for child device dependencies and aren't
> > useful once the consumer device probes successfully, this patch just
> > deletes DL_FLAG_SYNC_STATE_ONLY device links once its consumer device
> > probes. This way, we avoid the warning, free up some memory and avoid
> > complicating the device links "status" state management code.
> >
> > 2. Creating a DL_FLAG_STATELESS device link between two devices that
> > already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
> > DL_FLAG_STATELESS flag not getting set correctly. This patch also
> > fixes this.
> >
> > Lastly, this patch also fixes minor whitespace issues.
>
> My board triggers the
>   WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
>
> Full bootlog:
>
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
> [    0.000000] Linux version 5.7.0-rc6-next-20200522-00040-g43dd7a434139 (mw@apollo) (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0, GNU ld (GNU Binutils for Debian) 2.31.1) #800 SMP PREEMPT Fri May 22 20:33:03 CEST 2020
> [    0.000000] Machine model: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier
> [    0.000000] efi: UEFI not found.
> [    0.000000] cma: Reserved 32 MiB at 0x00000000f9c00000
> [    0.000000] NUMA: No NUMA configuration found
> [    0.000000] NUMA: Faking a node at [mem 0x0000000080000000-0x00000020ffffffff]
> [    0.000000] NUMA: NODE_DATA [mem 0x20ff7ff100-0x20ff800fff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000080000000-0x00000000bfffffff]
> [    0.000000]   DMA32    [mem 0x00000000c0000000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x00000020ffffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000080000000-0x00000000fbdfffff]
> [    0.000000]   node   0: [mem 0x0000002080000000-0x00000020ffffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x00000020ffffffff]
> [    0.000000] On node 0 totalpages: 1031680
> [    0.000000]   DMA zone: 4096 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 262144 pages, LIFO batch:63
> [    0.000000]   DMA32 zone: 3832 pages used for memmap
> [    0.000000]   DMA32 zone: 245248 pages, LIFO batch:63
> [    0.000000]   Normal zone: 8192 pages used for memmap
> [    0.000000]   Normal zone: 524288 pages, LIFO batch:63
> [    0.000000] percpu: Embedded 30 pages/cpu s82776 r8192 d31912 u122880
> [    0.000000] pcpu-alloc: s82776 r8192 d31912 u122880 alloc=30*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1
> [    0.000000] Detected PIPT I-cache on CPU0
> [    0.000000] CPU features: detected: GIC system register CPU interface
> [    0.000000] CPU features: detected: EL2 vector hardening
> [    0.000000] ARM_SMCCC_ARCH_WORKAROUND_1 missing from firmware
> [    0.000000] CPU features: detected: ARM errata 1165522, 1319367, or 1530923
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1015560
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: debug root=/dev/mmcblk1p2 rootwait
> [    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
> [    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
> [    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
> [    0.000000] software IO TLB: mapped [mem 0xbbfff000-0xbffff000] (64MB)
> [    0.000000] Memory: 3929888K/4126720K available (9532K kernel code, 1116K rwdata, 3556K rodata, 3264K init, 400K bss, 164064K reserved, 32768K cma-reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] ftrace: allocating 32623 entries in 128 pages
> [    0.000000] ftrace: allocated 128 pages with 1 groups
> [    0.000000] rcu: Preemptible hierarchical RCU implementation.
> [    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
> [    0.000000]  Trampoline variant of Tasks RCU enabled.
> [    0.000000]  Rude variant of Tasks RCU enabled.
> [    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
> [    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv3: 256 SPIs implemented
> [    0.000000] GICv3: 0 Extended SPIs implemented
> [    0.000000] GICv3: Distributor has no Range Selector support
> [    0.000000] GICv3: 16 PPIs implemented
> [    0.000000] GICv3: CPU0: found redistributor 0 region 0:0x0000000006040000
> [    0.000000] ITS [mem 0x06020000-0x0603ffff]
> [    0.000000] ITS@0x0000000006020000: allocated 65536 Devices @20fad80000 (flat, esz 8, psz 64K, shr 0)
> [    0.000000] ITS: using cache flushing for cmd queue
> [    0.000000] GICv3: using LPI property table @0x00000020fad30000
> [    0.000000] GIC: using cache flushing for LPI property table
> [    0.000000] GICv3: CPU0: using allocated LPI pending table @0x00000020fad40000
> [    0.000000] random: get_random_bytes called from start_kernel+0x604/0x7cc with crng_init=0
> [    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x5c40939b5, max_idle_ns: 440795202646 ns
> [    0.000002] sched_clock: 56 bits at 25MHz, resolution 40ns, wraps every 4398046511100ns
> [    0.000109] Console: colour dummy device 80x25
> [    0.000393] printk: console [tty0] enabled
> [    0.000439] Calibrating delay loop (skipped), value calculated using timer frequency.. 50.00 BogoMIPS (lpj=100000)
> [    0.000452] pid_max: default: 32768 minimum: 301
> [    0.000501] LSM: Security Framework initializing
> [    0.000553] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
> [    0.000585] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
> [    0.001429] rcu: Hierarchical SRCU implementation.
> [    0.001574] Platform MSI: gic-its@6020000 domain created
> [    0.001649] PCI/MSI: /interrupt-controller@6000000/gic-its@6020000 domain created
> [    0.001853] EFI services will not be available.
> [    0.001951] smp: Bringing up secondary CPUs ...
> [    0.002231] Detected PIPT I-cache on CPU1
> [    0.002250] GICv3: CPU1: found redistributor 1 region 0:0x0000000006060000
> [    0.002256] GICv3: CPU1: using allocated LPI pending table @0x00000020fad50000
> [    0.002278] CPU1: Booted secondary processor 0x0000000001 [0x410fd083]
> [    0.002328] smp: Brought up 1 node, 2 CPUs
> [    0.002354] SMP: Total of 2 processors activated.
> [    0.002362] CPU features: detected: 32-bit EL0 Support
> [    0.002369] CPU features: detected: CRC32 instructions
> [    0.010381] CPU: All CPU(s) started at EL2
> [    0.010401] alternatives: patching kernel code
> [    0.010994] devtmpfs: initialized
> [    0.012904] KASLR disabled due to lack of seed
> [    0.013071] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.013088] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
> [    0.013867] thermal_sys: Registered thermal governor 'step_wise'
> [    0.013995] DMI not present or invalid.
> [    0.014177] NET: Registered protocol family 16
> [    0.015070] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic allocations
> [    0.015787] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
> [    0.016519] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
> [    0.016555] audit: initializing netlink subsys (disabled)
> [    0.016679] audit: type=2000 audit(0.016:1): state=initialized audit_enabled=0 res=1
> [    0.016973] cpuidle: using governor menu
> [    0.017044] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
> [    0.017074] ASID allocator initialised with 65536 entries
> [    0.017342] Serial: AMBA PL011 UART driver
> [    0.023544] Machine: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier
> [    0.023558] SoC family: QorIQ LS1028A
> [    0.023564] SoC ID: svr:0x870b0110, Revision: 1.0
> [    0.026581] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
> [    0.026596] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
> [    0.026604] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    0.026611] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
> [    0.027683] cryptd: max_cpu_qlen set to 1000
> [    0.029104] iommu: Default domain type: Translated
> [    0.029174] vgaarb: loaded
> [    0.029308] SCSI subsystem initialized
> [    0.029404] usbcore: registered new interface driver usbfs
> [    0.029431] usbcore: registered new interface driver hub
> [    0.029462] usbcore: registered new device driver usb
> [    0.029593] imx-i2c 2000000.i2c: can't get pinctrl, bus recovery not supported
> [    0.029652] i2c i2c-0: supply bus not found, using dummy regulator
> [    0.029829] i2c i2c-0: IMX I2C adapter registered
> [    0.029908] imx-i2c 2030000.i2c: can't get pinctrl, bus recovery not supported
> [    0.029944] i2c i2c-1: supply bus not found, using dummy regulator
> [    0.030010] i2c i2c-1: IMX I2C adapter registered
> [    0.030082] imx-i2c 2040000.i2c: can't get pinctrl, bus recovery not supported
> [    0.030122] i2c i2c-2: supply bus not found, using dummy regulator
> [    0.030227] i2c i2c-2: IMX I2C adapter registered
> [    0.030303] pps_core: LinuxPPS API ver. 1 registered
> [    0.030310] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.030324] PTP clock support registered
> [    0.030552] Advanced Linux Sound Architecture Driver Initialized.
> [    0.030904] clocksource: Switched to clocksource arch_sys_counter
> [    0.066437] VFS: Disk quotas dquot_6.6.0
> [    0.066483] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.069159] NET: Registered protocol family 2
> [    0.069389] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
> [    0.069414] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
> [    0.069506] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
> [    0.069807] TCP: Hash tables configured (established 32768 bind 32768)
> [    0.069904] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
> [    0.069931] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
> [    0.070016] NET: Registered protocol family 1
> [    0.070036] PCI: CLS 0 bytes, default 64
> [    0.070364] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 7 counters available
> [    0.070817] Initialise system trusted keyrings
> [    0.070976] workingset: timestamp_bits=44 max_order=20 bucket_order=0
> [    0.103862] Key type asymmetric registered
> [    0.103879] Asymmetric key parser 'x509' registered
> [    0.103906] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
> [    0.103915] io scheduler mq-deadline registered
> [    0.103921] io scheduler kyber registered
> [    0.104351] pci-host-generic 1f0000000.pcie: host bridge /soc/pcie@1f0000000 ranges:
> [    0.104380] pci-host-generic 1f0000000.pcie:      MEM 0x01f8000000..0x01f815ffff -> 0x0000000000
> [    0.104401] pci-host-generic 1f0000000.pcie:      MEM 0x01f8160000..0x01f81cffff -> 0x0000000000
> [    0.104423] pci-host-generic 1f0000000.pcie:      MEM 0x01f81d0000..0x01f81effff -> 0x0000000000
> [    0.104441] pci-host-generic 1f0000000.pcie:      MEM 0x01f81f0000..0x01f820ffff -> 0x0000000000
> [    0.104460] pci-host-generic 1f0000000.pcie:      MEM 0x01f8210000..0x01f822ffff -> 0x0000000000
> [    0.104478] pci-host-generic 1f0000000.pcie:      MEM 0x01f8230000..0x01f824ffff -> 0x0000000000
> [    0.104492] pci-host-generic 1f0000000.pcie:      MEM 0x01fc000000..0x01fc3fffff -> 0x0000000000
> [    0.104545] pci-host-generic 1f0000000.pcie: ECAM at [mem 0x1f0000000-0x1f00fffff] for [bus 00]
> [    0.104605] pci-host-generic 1f0000000.pcie: PCI host bridge to bus 0000:00
> [    0.104615] pci_bus 0000:00: root bus resource [bus 00]
> [    0.104624] pci_bus 0000:00: root bus resource [mem 0x1f8000000-0x1f815ffff] (bus address [0x00000000-0x0015ffff])
> [    0.104636] pci_bus 0000:00: root bus resource [mem 0x1f8160000-0x1f81cffff pref] (bus address [0x00000000-0x0006ffff])
> [    0.104647] pci_bus 0000:00: root bus resource [mem 0x1f81d0000-0x1f81effff] (bus address [0x00000000-0x0001ffff])
> [    0.104657] pci_bus 0000:00: root bus resource [mem 0x1f81f0000-0x1f820ffff pref] (bus address [0x00000000-0x0001ffff])
> [    0.104668] pci_bus 0000:00: root bus resource [mem 0x1f8210000-0x1f822ffff] (bus address [0x00000000-0x0001ffff])
> [    0.104678] pci_bus 0000:00: root bus resource [mem 0x1f8230000-0x1f824ffff pref] (bus address [0x00000000-0x0001ffff])
> [    0.104689] pci_bus 0000:00: root bus resource [mem 0x1fc000000-0x1fc3fffff] (bus address [0x00000000-0x003fffff])
> [    0.104710] pci 0000:00:00.0: [1957:e100] type 00 class 0x020001
> [    0.104750] pci 0000:00:00.0: BAR 0: [mem 0x1f8000000-0x1f803ffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.104762] pci 0000:00:00.0: BAR 2: [mem 0x1f8160000-0x1f816ffff 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.104774] pci 0000:00:00.0: VF BAR 0: [mem 0x1f81d0000-0x1f81dffff 64bit] (from Enhanced Allocation, properties 0x4)
> [    0.104786] pci 0000:00:00.0: VF BAR 2: [mem 0x1f81f0000-0x1f81fffff 64bit pref] (from Enhanced Allocation, properties 0x3)
> [    0.104810] pci 0000:00:00.0: PME# supported from D0 D3hot
> [    0.104824] pci 0000:00:00.0: VF(n) BAR0 space: [mem 0x1f81d0000-0x1f81effff 64bit] (contains BAR0 for 2 VFs)
> [    0.104834] pci 0000:00:00.0: VF(n) BAR2 space: [mem 0x1f81f0000-0x1f820ffff 64bit pref] (contains BAR2 for 2 VFs)
> [    0.104949] pci 0000:00:00.1: [1957:e100] type 00 class 0x020001
> [    0.104978] pci 0000:00:00.1: BAR 0: [mem 0x1f8040000-0x1f807ffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.104990] pci 0000:00:00.1: BAR 2: [mem 0x1f8170000-0x1f817ffff 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.105002] pci 0000:00:00.1: VF BAR 0: [mem 0x1f8210000-0x1f821ffff 64bit] (from Enhanced Allocation, properties 0x4)
> [    0.105013] pci 0000:00:00.1: VF BAR 2: [mem 0x1f8230000-0x1f823ffff 64bit pref] (from Enhanced Allocation, properties 0x3)
> [    0.105036] pci 0000:00:00.1: PME# supported from D0 D3hot
> [    0.105049] pci 0000:00:00.1: VF(n) BAR0 space: [mem 0x1f8210000-0x1f822ffff 64bit] (contains BAR0 for 2 VFs)
> [    0.105060] pci 0000:00:00.1: VF(n) BAR2 space: [mem 0x1f8230000-0x1f824ffff 64bit pref] (contains BAR2 for 2 VFs)
> [    0.105154] pci 0000:00:00.2: [1957:e100] type 00 class 0x020001
> [    0.105183] pci 0000:00:00.2: BAR 0: [mem 0x1f8080000-0x1f80bffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.105195] pci 0000:00:00.2: BAR 2: [mem 0x1f8180000-0x1f818ffff 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.105216] pci 0000:00:00.2: PME# supported from D0 D3hot
> [    0.105300] pci 0000:00:00.3: [1957:ee01] type 00 class 0x088001
> [    0.105333] pci 0000:00:00.3: BAR 0: [mem 0x1f8100000-0x1f811ffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.105344] pci 0000:00:00.3: BAR 2: [mem 0x1f8190000-0x1f819ffff 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.105365] pci 0000:00:00.3: PME# supported from D0 D3hot
> [    0.105448] pci 0000:00:00.4: [1957:ee02] type 00 class 0x088001
> [    0.105477] pci 0000:00:00.4: BAR 0: [mem 0x1f8120000-0x1f813ffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.105489] pci 0000:00:00.4: BAR 2: [mem 0x1f81a0000-0x1f81affff 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.105521] pci 0000:00:00.4: PME# supported from D0 D3hot
> [    0.105606] pci 0000:00:00.5: [1957:eef0] type 00 class 0x020801
> [    0.105635] pci 0000:00:00.5: BAR 0: [mem 0x1f8140000-0x1f815ffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.105647] pci 0000:00:00.5: BAR 2: [mem 0x1f81b0000-0x1f81bffff 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.105659] pci 0000:00:00.5: BAR 4: [mem 0x1fc000000-0x1fc3fffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.105679] pci 0000:00:00.5: PME# supported from D0 D3hot
> [    0.105765] pci 0000:00:00.6: [1957:e100] type 00 class 0x020001
> [    0.105794] pci 0000:00:00.6: BAR 0: [mem 0x1f80c0000-0x1f80fffff 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.105806] pci 0000:00:00.6: BAR 2: [mem 0x1f81c0000-0x1f81cffff 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.105827] pci 0000:00:00.6: PME# supported from D0 D3hot
> [    0.106579] pci 0000:00:1f.0: [1957:e001] type 00 class 0x080700
> [    0.106625] OF: /soc/pcie@1f0000000: no msi-map translation for rid 0xf8 on (null)
> [    0.106967] layerscape-pcie 3400000.pcie: host bridge /soc/pcie@3400000 ranges:
> [    0.106993] layerscape-pcie 3400000.pcie:       IO 0x8000010000..0x800001ffff -> 0x0000000000
> [    0.107013] layerscape-pcie 3400000.pcie:      MEM 0x8040000000..0x807fffffff -> 0x0040000000
> [    0.107104] layerscape-pcie 3400000.pcie: PCI host bridge to bus 0001:00
> [    0.107114] pci_bus 0001:00: root bus resource [bus 00-ff]
> [    0.107121] pci_bus 0001:00: root bus resource [io  0x0000-0xffff]
> [    0.107130] pci_bus 0001:00: root bus resource [mem 0x8040000000-0x807fffffff] (bus address [0x40000000-0x7fffffff])
> [    0.107150] pci 0001:00:00.0: [1957:82c1] type 01 class 0x060400
> [    0.107210] pci 0001:00:00.0: supports D1 D2
> [    0.107217] pci 0001:00:00.0: PME# supported from D0 D1 D2 D3hot
> [    0.108621] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to 01
> [    0.108634] pci 0001:00:00.0: PCI bridge to [bus 01]
> [    0.108723] layerscape-pcie 3500000.pcie: host bridge /soc/pcie@3500000 ranges:
> [    0.108747] layerscape-pcie 3500000.pcie:       IO 0x8800010000..0x880001ffff -> 0x0000000000
> [    0.108766] layerscape-pcie 3500000.pcie:      MEM 0x8840000000..0x887fffffff -> 0x0040000000
> [    0.108840] layerscape-pcie 3500000.pcie: PCI host bridge to bus 0002:00
> [    0.108849] pci_bus 0002:00: root bus resource [bus 00-ff]
> [    0.108861] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff] (bus address [0x0000-0xffff])
> [    0.108871] pci_bus 0002:00: root bus resource [mem 0x8840000000-0x887fffffff] (bus address [0x40000000-0x7fffffff])
> [    0.108891] pci 0002:00:00.0: [1957:82c1] type 01 class 0x060400
> [    0.108950] pci 0002:00:00.0: supports D1 D2
> [    0.108957] pci 0002:00:00.0: PME# supported from D0 D1 D2 D3hot
> [    0.110338] pci_bus 0002:01: busn_res: [bus 01-ff] end is updated to 01
> [    0.110349] pci 0002:00:00.0: PCI bridge to [bus 01]
> [    0.110615] IPMI message handler: version 39.2
> [    0.110641] ipmi device interface
> [    0.110669] ipmi_si: IPMI System Interface driver
> [    0.110786] ipmi_si: Unable to find any System Interface(s)
> [    0.112304] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.113001] 21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 16, base_baud = 12500000) is a 16550A
> [    1.712116] printk: console [ttyS0] enabled
> [    1.716565] 21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 16, base_baud = 12500000) is a 16550A
> [    1.725671] 2270000.serial: ttyLP2 at MMIO 0x2270000 (irq = 17, base_baud = 12500000) is a FSL_LPUART
> [    1.735738] arm-smmu 5000000.iommu: probing hardware configuration...
> [    1.742217] arm-smmu 5000000.iommu: SMMUv2 with:
> [    1.746865] arm-smmu 5000000.iommu:  stage 1 translation
> [    1.752214] arm-smmu 5000000.iommu:  stage 2 translation
> [    1.757551] arm-smmu 5000000.iommu:  nested translation
> [    1.762798] arm-smmu 5000000.iommu:  stream matching with 128 register groups
> [    1.769965] arm-smmu 5000000.iommu:  64 context banks (0 stage-2 only)
> [    1.776527] arm-smmu 5000000.iommu:  Supported page sizes: 0x61311000
> [    1.782996] arm-smmu 5000000.iommu:  Stage-1: 48-bit VA -> 48-bit IPA
> [    1.789464] arm-smmu 5000000.iommu:  Stage-2: 48-bit IPA -> 48-bit PA
> [    1.796436] at24 0-0050: supply vcc not found, using dummy regulator
> [    1.803621] at24 0-0050: 4096 byte 24c32 EEPROM, writable, 32 bytes/write
> [    1.810495] at24 1-0057: supply vcc not found, using dummy regulator
> [    1.817640] at24 1-0057: 8192 byte 24c64 EEPROM, writable, 32 bytes/write
> [    1.824509] at24 2-0050: supply vcc not found, using dummy regulator
> [    1.831649] at24 2-0050: 4096 byte 24c32 EEPROM, writable, 32 bytes/write
> [    1.838597] mpt3sas version 34.100.00.00 loaded
> [    1.843906] header.nph=2
> [    1.846447] sfdp_size=288
> [    1.849205] spi-nor spi1.0: mx25u3235f (4096 Kbytes)
> [    1.859852] header.nph=0
> [    1.862395] sfdp_size=192
> [    1.865068] spi-nor spi0.0: w25q32dw (4096 Kbytes)
> [    1.871401] 10 fixed-partitions partitions found on MTD device 20c0000.spi
> [    1.878316] Creating 10 MTD partitions on "20c0000.spi":
> [    1.883663] 0x000000000000-0x000000010000 : "rcw"
> [    1.895213] 0x000000010000-0x000000100000 : "failsafe bootloader"
> [    1.911211] 0x000000100000-0x000000140000 : "failsafe DP firmware"
> [    1.919242] 0x000000140000-0x0000001e0000 : "failsafe trusted firmware"
> [    1.927234] 0x0000001e0000-0x000000200000 : "reserved"
> [    1.935232] 0x000000200000-0x000000210000 : "configuration store"
> [    1.943244] 0x000000210000-0x000000300000 : "bootloader"
> [    1.951230] 0x000000300000-0x000000340000 : "DP firmware"
> [    1.959226] 0x000000340000-0x0000003e0000 : "trusted firmware"
> [    1.967238] 0x0000003e0000-0x000000400000 : "bootloader environment"
> [    1.975845] libphy: Fixed MDIO Bus: probed
> [    1.980150] mscc_felix 0000:00:00.5: Adding to iommu group 0
> [    1.985966] mscc_felix 0000:00:00.5: device is disabled, skipping
> [    1.992148] fsl_enetc 0000:00:00.0: Adding to iommu group 1
> [    2.102922] fsl_enetc 0000:00:00.0: enabling device (0400 -> 0402)
> [    2.109167] fsl_enetc 0000:00:00.0: no MAC address specified for SI1, using d2:e9:d1:8e:4e:1c
> [    2.117734] fsl_enetc 0000:00:00.0: no MAC address specified for SI2, using 2a:b8:1d:68:7f:ff
> [    2.126646] libphy: Freescale ENETC MDIO Bus: probed
> [    2.133222] fsl_enetc 0000:00:00.1: Adding to iommu group 2
> [    2.138948] fsl_enetc 0000:00:00.1: device is disabled, skipping
> [    2.145022] fsl_enetc 0000:00:00.2: Adding to iommu group 3
> [    2.150696] fsl_enetc 0000:00:00.2: device is disabled, skipping
> [    2.156768] fsl_enetc 0000:00:00.6: Adding to iommu group 4
> [    2.162443] fsl_enetc 0000:00:00.6: device is disabled, skipping
> [    2.168541] fsl_enetc_mdio 0000:00:00.3: Adding to iommu group 5
> [    2.278915] fsl_enetc_mdio 0000:00:00.3: enabling device (0400 -> 0402)
> [    2.285740] libphy: FSL PCIe IE Central MDIO Bus: probed
> [    2.291111] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.6.0-k
> [    2.298104] igb: Copyright (c) 2007-2014 Intel Corporation.
> [    2.303802] dwc3 3100000.usb: Adding to iommu group 6
> [    2.309161] ------------[ cut here ]------------
> [    2.313801] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:912 device_links_driver_bound+0x1c0/0x1e8
> [    2.322880] Modules linked in:
> [    2.325944] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc6-next-20200522-00040-g43dd7a434139 #800
> [    2.335285] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
> [    2.343582] pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
> [    2.349173] pc : device_links_driver_bound+0x1c0/0x1e8
> [    2.354327] lr : device_links_driver_bound+0xf8/0x1e8
> [    2.359393] sp : ffff8000111abb80
> [    2.362713] x29: ffff8000111abb80 x28: 0000000000000000
> [    2.368043] x27: 0000000000000006 x26: ffff00207a421c10
> [    2.373371] x25: 0000000000000003 x24: ffff00207a420cb0
> [    2.378699] x23: ffff800011009948 x22: ffff8000111abbd8
> [    2.384027] x21: ffff00207a420c10 x20: ffff8000110a2ae8
> [    2.389355] x19: ffff00207a420c90 x18: 0000000000000000
> [    2.394684] x17: ffffffffffff3f00 x16: 0000000000007fff
> [    2.400013] x15: ffffffffffffffff x14: ffff800011009948
> [    2.405342] x13: ffff002079cf991c x12: 0000000000000000
> [    2.410671] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
> [    2.416000] x9 : ffff800010548e68 x8 : 7f7f7f7f7f7f7f7f
> [    2.421328] x7 : ffff8000111aba40 x6 : 0000000000000000
> [    2.426657] x5 : 0000000000000000 x4 : 0000000000000000
> [    2.431985] x3 : ffff8000110a3380 x2 : 0000000000000000
> [    2.437313] x1 : 0000000000000001 x0 : ffff00207a401200
> [    2.442643] Call trace:
> [    2.445094]  device_links_driver_bound+0x1c0/0x1e8
> [    2.449900]  driver_bound+0x70/0xc0
> [    2.453396]  really_probe+0x110/0x318
> [    2.457068]  driver_probe_device+0x40/0x90
> [    2.461175]  device_driver_attach+0x7c/0x88
> [    2.465369]  __driver_attach+0x60/0xe8
> [    2.469128]  bus_for_each_dev+0x7c/0xd0
> [    2.472974]  driver_attach+0x2c/0x38
> [    2.476557]  bus_add_driver+0x194/0x1f8
> [    2.480403]  driver_register+0x6c/0x128
> [    2.484251]  __platform_driver_register+0x50/0x60
> [    2.488971]  dwc3_driver_init+0x24/0x30
> [    2.492818]  do_one_initcall+0x54/0x298
> [    2.496665]  kernel_init_freeable+0x1ec/0x268
> [    2.501036]  kernel_init+0x1c/0x118
> [    2.504532]  ret_from_fork+0x10/0x1c
> [    2.508117] ---[ end trace 119c2917ee509c34 ]---
> [    2.512811] dwc3 3110000.usb: Adding to iommu group 7
> [    2.518134] ------------[ cut here ]------------
> [    2.522770] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:912 device_links_driver_bound+0x1c0/0x1e8
> [    2.531848] Modules linked in:
> [    2.534910] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.7.0-rc6-next-20200522-00040-g43dd7a434139 #800
> [    2.545647] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
> [    2.553943] pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
> [    2.559533] pc : device_links_driver_bound+0x1c0/0x1e8
> [    2.564688] lr : device_links_driver_bound+0xf8/0x1e8
> [    2.569753] sp : ffff8000111abb80
> [    2.573075] x29: ffff8000111abb80 x28: 0000000000000000
> [    2.578403] x27: 0000000000000006 x26: ffff00207a421c10
> [    2.583731] x25: 0000000000000003 x24: ffff00207a4210b0
> [    2.589059] x23: ffff800011009948 x22: ffff8000111abbd8
> [    2.594387] x21: ffff00207a421010 x20: ffff8000110a2ae8
> [    2.599715] x19: ffff00207a421090 x18: 0000000000000000
> [    2.605043] x17: ffffffffffff3f00 x16: 0000000000007fff
> [    2.610372] x15: ffffffffffffffff x14: ffff800011009948
> [    2.615700] x13: ffff002079cf991c x12: 0000000000000000
> [    2.621029] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
> [    2.626356] x9 : ffff800010548e68 x8 : 7f7f7f7f7f7f7f7f
> [    2.631685] x7 : ffff8000111aba40 x6 : 0000000000000000
> [    2.637014] x5 : 0000000000000000 x4 : 0000000000000000
> [    2.642342] x3 : ffff8000110a3380 x2 : 0000000000000000
> [    2.647670] x1 : 0000000000000001 x0 : ffff00207a401280
> [    2.652997] Call trace:
> [    2.655448]  device_links_driver_bound+0x1c0/0x1e8
> [    2.660253]  driver_bound+0x70/0xc0
> [    2.663749]  really_probe+0x110/0x318
> [    2.667421]  driver_probe_device+0x40/0x90
> [    2.671528]  device_driver_attach+0x7c/0x88
> [    2.675722]  __driver_attach+0x60/0xe8
> [    2.679480]  bus_for_each_dev+0x7c/0xd0
> [    2.683326]  driver_attach+0x2c/0x38
> [    2.686910]  bus_add_driver+0x194/0x1f8
> [    2.690756]  driver_register+0x6c/0x128
> [    2.694603]  __platform_driver_register+0x50/0x60
> [    2.699322]  dwc3_driver_init+0x24/0x30
> [    2.703167]  do_one_initcall+0x54/0x298
> [    2.707014]  kernel_init_freeable+0x1ec/0x268
> [    2.711384]  kernel_init+0x1c/0x118
> [    2.714880]  ret_from_fork+0x10/0x1c
> [    2.718462] ---[ end trace 119c2917ee509c35 ]---
> [    2.723246] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.729804] ehci-pci: EHCI PCI platform driver
> [    2.734429] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
> [    2.739956] xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 1
> [    2.747789] xhci-hcd xhci-hcd.0.auto: hcc params 0x0220f66d hci version 0x100 quirks 0x0000000002010010
> [    2.757249] xhci-hcd xhci-hcd.0.auto: irq 21, io mem 0x03100000
> [    2.763565] hub 1-0:1.0: USB hub found
> [    2.767348] hub 1-0:1.0: 1 port detected
> [    2.771395] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
> [    2.776911] xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 2
> [    2.784605] xhci-hcd xhci-hcd.0.auto: Host supports USB 3.0 SuperSpeed
> [    2.791187] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
> [    2.799523] hub 2-0:1.0: USB hub found
> [    2.803303] hub 2-0:1.0: 1 port detected
> [    2.807381] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
> [    2.812898] xhci-hcd xhci-hcd.1.auto: new USB bus registered, assigned bus number 3
> [    2.820741] xhci-hcd xhci-hcd.1.auto: hcc params 0x0220f66d hci version 0x100 quirks 0x0000000002010010
> [    2.830207] xhci-hcd xhci-hcd.1.auto: irq 22, io mem 0x03110000
> [    2.836470] hub 3-0:1.0: USB hub found
> [    2.840251] hub 3-0:1.0: 1 port detected
> [    2.844289] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
> [    2.849804] xhci-hcd xhci-hcd.1.auto: new USB bus registered, assigned bus number 4
> [    2.857499] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0 SuperSpeed
> [    2.864080] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
> [    2.872409] hub 4-0:1.0: USB hub found
> [    2.876267] hub 4-0:1.0: 1 port detected
> [    2.880393] usbcore: registered new interface driver usb-storage
> [    2.887177] rtc-rv8803 0-0032: Voltage low, temperature compensation stopped.
> [    2.894348] rtc-rv8803 0-0032: Voltage low, data loss detected.
> [    2.901365] rtc-rv8803 0-0032: Voltage low, data is invalid.
> [    2.907117] rtc-rv8803 0-0032: registered as rtc0
> [    2.912514] rtc-rv8803 0-0032: Voltage low, data is invalid.
> [    2.918202] rtc-rv8803 0-0032: hctosys: unable to read the hardware clock
> [    2.925102] i2c /dev entries driver
> [    2.934504] sp805-wdt c000000.watchdog: registration successful
> [    2.940537] sp805-wdt c010000.watchdog: registration successful
> [    2.947196] qoriq-cpufreq qoriq-cpufreq: Freescale QorIQ CPU frequency scaling driver
> [    2.955659] sdhci: Secure Digital Host Controller Interface driver
> [    2.961918] sdhci: Copyright(c) Pierre Ossman
> [    2.966333] sdhci-pltfm: SDHCI platform and OF driver helper
> [    2.972762] sdhci-esdhc 2140000.mmc: Adding to iommu group 8
> [    3.005562] mmc0: SDHCI controller on 2140000.mmc [2140000.mmc] using ADMA
> [    3.012632] ------------[ cut here ]------------
> [    3.017310] WARNING: CPU: 0 PID: 1 at drivers/base/core.c:912 device_links_driver_bound+0x1c0/0x1e8
> [    3.026418] Modules linked in:
> [    3.029509] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.7.0-rc6-next-20200522-00040-g43dd7a434139 #800
> [    3.040279] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
> [    3.048609] pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
> [    3.054226] pc : device_links_driver_bound+0x1c0/0x1e8
> [    3.059405] lr : device_links_driver_bound+0xf8/0x1e8
> [    3.064491] sp : ffff8000111abb80
> [    3.067831] x29: ffff8000111abb80 x28: 0000000000000000
> [    3.073189] x27: 0000000000000006 x26: ffff00207a421c10
> [    3.078544] x25: 0000000000000003 x24: ffff00207a41a4b0
> [    3.083898] x23: ffff800011009948 x22: ffff8000111abbd8
> [    3.089251] x21: ffff00207a41a410 x20: ffff8000110a2ae8
> [    3.094604] x19: ffff00207a41a490 x18: 0000000000000010
> [    3.099957] x17: 0000000000000000 x16: 0000000000000000
> [    3.105310] x15: ffffffffffffffff x14: 0720072007200741
> [    3.110664] x13: 074d074407410720 x12: 0767076e07690773
> [    3.116016] x11: 07750720075d0763 x10: 00000000000009f0
> [    3.121370] x9 : ffff800010548e68 x8 : ffff00207ae50a50
> [    3.126723] x7 : 0000000000000000 x6 : 0000000000000001
> [    3.132075] x5 : 0000000000008340 x4 : 0000000000000000
> [    3.137428] x3 : ffff8000110a3380 x2 : 0000000000000000
> [    3.142780] x1 : 0000000000000001 x0 : ffff00207a401000
> [    3.148133] Call trace:
> [    3.150609]  device_links_driver_bound+0x1c0/0x1e8
> [    3.155442]  driver_bound+0x70/0xc0
> [    3.158963]  really_probe+0x110/0x318
> [    3.162660]  driver_probe_device+0x40/0x90
> [    3.166793]  device_driver_attach+0x7c/0x88
> [    3.171013]  __driver_attach+0x60/0xe8
> [    3.174794]  bus_for_each_dev+0x7c/0xd0
> [    3.178663]  driver_attach+0x2c/0x38
> [    3.182270]  bus_add_driver+0x194/0x1f8
> [    3.186139]  driver_register+0x6c/0x128
> [    3.190012]  __platform_driver_register+0x50/0x60
> [    3.194755]  sdhci_esdhc_driver_init+0x24/0x30
> [    3.199237]  do_one_initcall+0x54/0x298
> [    3.203110]  kernel_init_freeable+0x1ec/0x268
> [    3.207507]  kernel_init+0x1c/0x118
> [    3.211025]  ret_from_fork+0x10/0x1c
> [    3.214629] ---[ end trace 119c2917ee509c36 ]---
> [    3.219842] sdhci-esdhc 2150000.mmc: Adding to iommu group 9
> [    3.252837] mmc1: SDHCI controller on 2150000.mmc [2150000.mmc] using ADMA
> [    3.259902] ------------[ cut here ]------------
> [    3.264577] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:912 device_links_driver_bound+0x1c0/0x1e8
> [    3.273685] Modules linked in:
> [    3.276775] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.7.0-rc6-next-20200522-00040-g43dd7a434139 #800
> [    3.287544] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
> [    3.295873] pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
> [    3.301490] pc : device_links_driver_bound+0x1c0/0x1e8
> [    3.306669] lr : device_links_driver_bound+0xf8/0x1e8
> [    3.311754] sp : ffff8000111abb80
> [    3.315093] x29: ffff8000111abb80 x28: 0000000000000000
> [    3.320449] x27: 0000000000000006 x26: ffff00207a421c10
> [    3.325805] x25: 0000000000000003 x24: ffff00207a41a8b0
> [    3.331159] x23: ffff800011009948 x22: ffff8000111abbd8
> [    3.336511] x21: ffff00207a41a810 x20: ffff8000110a2ae8
> [    3.341864] x19: ffff00207a41a890 x18: 0000000000000010
> [    3.347217] x17: 00000000000003fb x16: 0000000000000001
> [    3.352569] x15: ffffffffffffffff x14: 0720072007200741
> [    3.357921] x13: 074d074407410720 x12: 0767076e07690773
> [    3.363273] x11: 07750720075d0763 x10: 00000000000009f0
> [    3.368627] x9 : ffff800010548e68 x8 : ffff00207ae50a50
> [    3.373980] x7 : 0000000000000001 x6 : 0000000000000001
> [    3.379333] x5 : 0000000000007670 x4 : 0000000000000000
> [    3.384686] x3 : ffff8000110a3380 x2 : 0000000000000000
> [    3.390036] x1 : 0000000000000001 x0 : ffff00207a401080
> [    3.395391] Call trace:
> [    3.397863]  device_links_driver_bound+0x1c0/0x1e8
> [    3.402694]  driver_bound+0x70/0xc0
> [    3.406216]  really_probe+0x110/0x318
> [    3.409911]  driver_probe_device+0x40/0x90
> [    3.414044]  device_driver_attach+0x7c/0x88
> [    3.418262]  __driver_attach+0x60/0xe8
> [    3.422043]  bus_for_each_dev+0x7c/0xd0
> [    3.425912]  driver_attach+0x2c/0x38
> [    3.429518]  bus_add_driver+0x194/0x1f8
> [    3.433387]  driver_register+0x6c/0x128
> [    3.434954] mmc0: new ultra high speed SDR104 SDHC card at address 1234
> [    3.437259]  __platform_driver_register+0x50/0x60
> [    3.437277]  sdhci_esdhc_driver_init+0x24/0x30
> [    3.453131]  do_one_initcall+0x54/0x298
> [    3.457004]  kernel_init_freeable+0x1ec/0x268
> [    3.461400]  kernel_init+0x1c/0x118
> [    3.464920]  ret_from_fork+0x10/0x1c
> [    3.468521] ---[ end trace 119c2917ee509c37 ]---
> [    3.474335] mmcblk0: mmc0:1234 SA16G 14.4 GiB
> [    3.474995] usbcore: registered new interface driver usbhid
> [    3.484513] usbhid: USB HID core driver
> [    3.485993]  mmcblk0: p1
> [    3.489639] wm8904 2-001a: supply DCVDD not found, using dummy regulator
> [    3.497984] wm8904 2-001a: supply DBVDD not found, using dummy regulator
> [    3.504924] wm8904 2-001a: supply AVDD not found, using dummy regulator
> [    3.511751] wm8904 2-001a: supply CPVDD not found, using dummy regulator
> [    3.518683] wm8904 2-001a: supply MICVDD not found, using dummy regulator
> [    3.527720] wm8904 2-001a: revision A
> [    3.531539] usb 3-1: new high-speed USB device number 2 using xhci-hcd
> [    3.550758] NET: Registered protocol family 10
> [    3.557190] Segment Routing with IPv6
> [    3.561484] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> [    3.568527] NET: Registered protocol family 17
> [    3.573204] Bridge firewalling registered
> [    3.577592] 8021q: 802.1Q VLAN Support v1.8
> [    3.581987] Key type dns_resolver registered
> [    3.586796] registered taskstats version 1
> [    3.590979] Loading compiled-in X.509 certificates
> [    3.601872] fsl-edma 22c0000.dma-controller: Adding to iommu group 10
> [    3.611553] ------------[ cut here ]------------
> [    3.616236] WARNING: CPU: 1 PID: 23 at drivers/base/core.c:912 device_links_driver_bound+0x1c0/0x1e8
> [    3.625431] Modules linked in:
> [    3.628522] CPU: 1 PID: 23 Comm: kworker/1:1 Tainted: G        W         5.7.0-rc6-next-20200522-00040-g43dd7a434139 #800
> [    3.639553] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
> [    3.647889] Workqueue: events deferred_probe_work_func
> [    3.653073] pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
> [    3.658688] pc : device_links_driver_bound+0x1c0/0x1e8
> [    3.663868] lr : device_links_driver_bound+0xf8/0x1e8
> [    3.668955] sp : ffff8000112dbb80
> [    3.672294] x29: ffff8000112dbb80 x28: 0000000000000000
> [    3.677650] x27: ffff00207af84848 x26: ffff00207a421c10
> [    3.683005] x25: 0000000000000003 x24: ffff00207a41bcb0
> [    3.688359] x23: ffff800011009948 x22: ffff8000112dbbd8
> [    3.693712] x21: ffff00207a41bc10 x20: ffff8000110a2ae8
> [    3.699065] x19: ffff00207a41bc90 x18: 0000000000000000
> [    3.704417] x17: 00000000040e1236 x16: 0000000065a74b1b
> [    3.709770] x15: ffffffffffffffff x14: ffff800011009948
> [    3.715123] x13: ffff002079fa291c x12: 0000000000000030
> [    3.720476] x11: 0101010101010101 x10: ffffffffffffffff
> [    3.725829] x9 : ffff800010548e68 x8 : ffff002079fb3f80
> [    3.731182] x7 : 0000000000000000 x6 : 000000000000003f
> [    3.736535] x5 : 0000000000000040 x4 : 0000000000000000
> [    3.741887] x3 : ffff8000110a3380 x2 : 0000000000000000
> [    3.747239] x1 : 0000000000000001 x0 : ffff00207a401180
> [    3.752593] Call trace:
> [    3.755065]  device_links_driver_bound+0x1c0/0x1e8
> [    3.759897]  driver_bound+0x70/0xc0
> [    3.763417]  really_probe+0x110/0x318
> [    3.767112]  driver_probe_device+0x40/0x90
> [    3.771244]  __device_attach_driver+0x8c/0xd0
> [    3.775637]  bus_for_each_drv+0x84/0xd8
> [    3.779506]  __device_attach+0xd4/0x110
> [    3.783375]  device_initial_probe+0x1c/0x28
> [    3.787592]  bus_probe_device+0xa4/0xb0
> [    3.791462]  deferred_probe_work_func+0x7c/0xb8
> [    3.796034]  process_one_work+0x1f4/0x4b8
> [    3.800080]  worker_thread+0x218/0x498
> [    3.803862]  kthread+0x160/0x168
> [    3.807121]  ret_from_fork+0x10/0x1c
> [    3.810723] ---[ end trace 119c2917ee509c39 ]---
> [    3.815842] pcieport 0001:00:00.0: Adding to iommu group 11
> [    3.822335] pcieport 0001:00:00.0: AER: enabled with IRQ 24
> [    3.828417] pcieport 0002:00:00.0: Adding to iommu group 12
> [    3.834817] pcieport 0002:00:00.0: AER: enabled with IRQ 26
> [    3.841914] fsl-qdma 8380000.dma-controller: Adding to iommu group 13
> [    3.850471] ------------[ cut here ]------------
> [    3.855153] WARNING: CPU: 1 PID: 23 at drivers/base/core.c:912 device_links_driver_bound+0x1c0/0x1e8
> [    3.864348] Modules linked in:
> [    3.867439] CPU: 1 PID: 23 Comm: kworker/1:1 Tainted: G        W         5.7.0-rc6-next-20200522-00040-g43dd7a434139 #800
> [    3.878470] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
> [    3.886807] Workqueue: events deferred_probe_work_func
> [    3.891991] pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
> [    3.897607] pc : device_links_driver_bound+0x1c0/0x1e8
> [    3.902785] lr : device_links_driver_bound+0xf8/0x1e8
> [    3.907872] sp : ffff8000112dbb80
> [    3.911211] x29: ffff8000112dbb80 x28: 0000000000000000
> [    3.916568] x27: ffff00207af84848 x26: ffff00207a421c10
> [    3.921921] x25: 0000000000000003 x24: ffff00207a4220b0
> [    3.927274] x23: ffff800011009948 x22: ffff8000112dbbd8
> [    3.932626] x21: ffff00207a422010 x20: ffff8000110a2ae8
> [    3.937979] x19: ffff00207a422090 x18: 0000000000000000
> [    3.943332] x17: 0000000000000028 x16: 0000000000000050
> [    3.948686] x15: ffffffffffffffff x14: ffff800011009948
> [    3.954038] x13: ffff002079fa391c x12: 0000000000000030
> [    3.959390] x11: 0101010101010101 x10: ffffffffffffffff
> [    3.964742] x9 : ffff800010548e68 x8 : 746e6f632d616d64
> [    3.970096] x7 : ffff8000112dba00 x6 : 0000000000000000
> [    3.975449] x5 : 0000000000000000 x4 : 0000000000000000
> [    3.980801] x3 : ffff8000110a3380 x2 : 0000000000000000
> [    3.986152] x1 : 0000000000000001 x0 : ffff00207a401400
> [    3.991505] Call trace:
> [    3.993978]  device_links_driver_bound+0x1c0/0x1e8
> [    3.998809]  driver_bound+0x70/0xc0
> [    4.002329]  really_probe+0x110/0x318
> [    4.006024]  driver_probe_device+0x40/0x90
> [    4.010155]  __device_attach_driver+0x8c/0xd0
> [    4.014547]  bus_for_each_drv+0x84/0xd8
> [    4.018416]  __device_attach+0xd4/0x110
> [    4.022285]  device_initial_probe+0x1c/0x28
> [    4.026503]  bus_probe_device+0xa4/0xb0
> [    4.030371]  deferred_probe_work_func+0x7c/0xb8
> [    4.034944]  process_one_work+0x1f4/0x4b8
> [    4.038989]  worker_thread+0x218/0x498
> [    4.042772]  kthread+0x160/0x168
> [    4.046031]  ret_from_fork+0x10/0x1c
> [    4.049634] ---[ end trace 119c2917ee509c3a ]---
> [    4.067995] asoc-simple-card sound: wm8904-hifi <-> f150000.audio-controller mapping ok
> [    4.080340] hub 3-1:1.0: USB hub found
> [    4.085394] hub 3-1:1.0: 7 ports detected
> [    4.092223] asoc-simple-card sound: wm8904-hifi <-> f140000.audio-controller mapping ok
> [    4.100866] asoc-simple-card sound: ASoC: no DMI vendor name!
> [    4.106933] random: fast init done
> [    4.110951] mmc1: new HS400 MMC card at address 0001
> [    4.117316] mmcblk1: mmc1:0001 S0J58X 29.6 GiB
> [    4.122436] mmcblk1boot0: mmc1:0001 S0J58X partition 1 31.5 MiB
> [    4.130037] mmcblk1boot1: mmc1:0001 S0J58X partition 2 31.5 MiB
> [    4.130304] irq: no irq domain found for interrupt-controller@1c !
> [    4.136289] mmcblk1rpmb: mmc1:0001 S0J58X partition 3 4.00 MiB, chardev (245:0)
> [    4.142321] irq: no irq domain found for interrupt-controller@1c !
> [    4.156366] gpio-keys buttons0: Found button without gpio or irq
> [    4.162815] gpio-keys: probe of buttons0 failed with error -22
> [    4.162821]  mmcblk1: p1 p2
> [    4.172097] ALSA device list:
> [    4.175148]   #0: f150000.audio-controller-wm8904-hifi
> [    4.182701] EXT4-fs (mmcblk1p2): INFO: recovery required on readonly filesystem
> [    4.190137] EXT4-fs (mmcblk1p2): write access will be enabled during recovery
> [    4.263821] EXT4-fs (mmcblk1p2): recovery complete
> [    4.270940] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data mode. Opts: (null)
> [    4.279327] VFS: Mounted root (ext4 filesystem) readonly on device 179:34.
> [    4.287179] devtmpfs: mounted
> [    4.301063] Freeing unused kernel memory: 3264K
> [    4.305875] Run /sbin/init as init process
> [    4.310036]   with arguments:
> [    4.313051]     /sbin/init
> [    4.315802]   with environment:
> [    4.318991]     HOME=/
> [    4.321370]     TERM=linux
> [    4.371451] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
> [    4.471037] usb 3-1.6: new full-speed USB device number 3 using xhci-hcd
> [    4.541101] udevd[127]: starting version 3.2.8
> [    4.549864] random: udevd: uninitialized urandom read (16 bytes read)
> [    4.557780] random: udevd: uninitialized urandom read (16 bytes read)
> [    4.564612] random: udevd: uninitialized urandom read (16 bytes read)
> [    4.576379] udevd[127]: specified group 'kvm' unknown
> [    4.606090] udevd[129]: starting eudev-3.2.8
> [    6.853488] fsl_enetc 0000:00:00.0 gbe0: renamed from eth0
> [    9.585282] urandom_read: 3 callbacks suppressed
> [    9.585295] random: dd: uninitialized urandom read (512 bytes read)
> [    9.748164] Qualcomm Atheros AR8031/AR8033 0000:00:00.0:05: attached PHY driver [Qualcomm Atheros AR8031/AR8033] (mii_bus:phy_addr=0000:00:00.0:05, irq=POLL)
> [    9.779903] fsl_enetc 0000:00:00.0 gbe0: Link is Down
> [    9.836673] random: dropbear: uninitialized urandom read (32 bytes read)
> [   11.843533] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 10Mbps/Full - flow control off
> [   11.851417] IPv6: ADDRCONF(NETDEV_CHANGE): gbe0: link becomes ready
> [   12.871335] fsl_enetc 0000:00:00.0 gbe0: Link is Down
> [   14.915541] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 1Gbps/Full - flow control off

Thanks for the log and report. I haven't spent too much time thinking
about this, but can you give this a shot?
https://lore.kernel.org/lkml/20200520043626.181820-1-saravanak@google.com/

-Saravana
