Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4481E2073
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388955AbgEZLEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 07:04:37 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:38185 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388953AbgEZLEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 07:04:36 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3281522FB6;
        Tue, 26 May 2020 13:04:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590491065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hegmbNizEht5gX/4HVvfHc5xq/2FyOj22cD3NJZr1dw=;
        b=DAU5fAfpEQXEPR9d4hIVvqsTQO9cwIaFwmouRNAdwTuxGiVPVNhimM6kGULX5c1UYnJWMy
        IUJ/MeclFWY9rjVKXXXe6kgqfcd8gny1OFUmqJwUbRbfbXrr7qLQDQZz/4hsF4nLY8kJPT
        i1EM0WwzQlAXtCmDyLZOZAPUdHu+PDM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 26 May 2020 13:04:25 +0200
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v1] driver core: Update device link status correctly for
 SYNC_STATE_ONLY links
In-Reply-To: <CAGETcx-b4+a8U=Qd0mKaB9JUBaj178694QshqZVrAa_x6AgcAg@mail.gmail.com>
References: <6144404cb26d1f797fd7e87b124bcaf8@walle.cc>
 <20200526070518.107333-1-saravanak@google.com>
 <CAGETcx-b4+a8U=Qd0mKaB9JUBaj178694QshqZVrAa_x6AgcAg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <dac3da8b373f131e53e18083f6fac5b0@walle.cc>
X-Sender: michael@walle.cc
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Saravana,

Am 2020-05-26 09:07, schrieb Saravana Kannan:
>> Greg,
>> 
>> I think this is the issue Michael ran into. I'd like him to test the 
>> fix
>> before it's pulled in.
>> 
>> Michael,
>> 
>> If you can test this on the branch you saw the issue in and give a
>> Tested-by if it works, that'd be great.

Unfortunately, now I'm triggering another WARN_ON() in
device_links_driver_bound():
   WARN_ON(link->status != DL_STATE_DORMANT);

I've attached two bootlog one based on linux-next-20200525 with this
patch applied and another one where your previous debug printfs are
applied, too.

Let me know, if you need any other debug outputs.

original bootlog with this patch:

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
[    0.000000] Linux version 5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e 
(mw@apollo) (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0, GNU ld (GNU 
Binutils for Debian) 2.31.1) #822 SMP PREEMPT Tue May 26 12:55:57 CEST 
2020
[    0.000000] Machine model: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier
[    0.000000] efi: UEFI not found.
[    0.000000] cma: Reserved 32 MiB at 0x00000000f9c00000
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 
0x0000000080000000-0x00000020ffffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x20ff7fe100-0x20ff7fffff]
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
[    0.000000] Memory: 3930016K/4126720K available (9532K kernel code, 
1114K rwdata, 3556K rodata, 3200K init, 398K bss, 163936K reserved, 
32768K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, 
Nodes=1
[    0.000000] ftrace: allocating 32616 entries in 128 pages
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
[    0.000107] Console: colour dummy device 80x25
[    0.000391] printk: console [tty0] enabled
[    0.000437] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 50.00 BogoMIPS (lpj=100000)
[    0.000450] pid_max: default: 32768 minimum: 301
[    0.000497] LSM: Security Framework initializing
[    0.000550] Mount-cache hash table entries: 8192 (order: 4, 65536 
bytes, linear)
[    0.000581] Mountpoint-cache hash table entries: 8192 (order: 4, 
65536 bytes, linear)
[    0.001427] rcu: Hierarchical SRCU implementation.
[    0.001578] Platform MSI: gic-its@6020000 domain created
[    0.001652] PCI/MSI: /interrupt-controller@6000000/gic-its@6020000 
domain created
[    0.001853] EFI services will not be available.
[    0.001951] smp: Bringing up secondary CPUs ...
[    0.002231] Detected PIPT I-cache on CPU1
[    0.002251] GICv3: CPU1: found redistributor 1 region 
0:0x0000000006060000
[    0.002258] GICv3: CPU1: using allocated LPI pending table 
@0x00000020fad50000
[    0.002280] CPU1: Booted secondary processor 0x0000000001 
[0x410fd083]
[    0.002331] smp: Brought up 1 node, 2 CPUs
[    0.002357] SMP: Total of 2 processors activated.
[    0.002365] CPU features: detected: 32-bit EL0 Support
[    0.002372] CPU features: detected: CRC32 instructions
[    0.010392] CPU: All CPU(s) started at EL2
[    0.010411] alternatives: patching kernel code
[    0.011015] devtmpfs: initialized
[    0.012956] KASLR disabled due to lack of seed
[    0.013109] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.013126] futex hash table entries: 512 (order: 3, 32768 bytes, 
linear)
[    0.013897] thermal_sys: Registered thermal governor 'step_wise'
[    0.014024] DMI not present or invalid.
[    0.014208] NET: Registered protocol family 16
[    0.015117] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic 
allocations
[    0.015833] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for 
atomic allocations
[    0.016544] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for 
atomic allocations
[    0.016593] audit: initializing netlink subsys (disabled)
[    0.016721] audit: type=2000 audit(0.016:1): state=initialized 
audit_enabled=0 res=1
[    0.016991] cpuidle: using governor menu
[    0.017048] hw-breakpoint: found 6 breakpoint and 4 watchpoint 
registers.
[    0.017077] ASID allocator initialised with 65536 entries
[    0.017344] Serial: AMBA PL011 UART driver
[    0.023579] Machine: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 
2.0 carrier
[    0.023592] SoC family: QorIQ LS1028A
[    0.023598] SoC ID: svr:0x870b0110, Revision: 1.0
[    0.026605] HugeTLB registered 1.00 GiB page size, pre-allocated 0 
pages
[    0.026618] HugeTLB registered 32.0 MiB page size, pre-allocated 0 
pages
[    0.026626] HugeTLB registered 2.00 MiB page size, pre-allocated 0 
pages
[    0.026634] HugeTLB registered 64.0 KiB page size, pre-allocated 0 
pages
[    0.027719] cryptd: max_cpu_qlen set to 1000
[    0.029102] iommu: Default domain type: Translated
[    0.029188] vgaarb: loaded
[    0.029333] SCSI subsystem initialized
[    0.029416] usbcore: registered new interface driver usbfs
[    0.029438] usbcore: registered new interface driver hub
[    0.029471] usbcore: registered new device driver usb
[    0.029603] imx-i2c 2000000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.029780] i2c i2c-0: IMX I2C adapter registered
[    0.029855] imx-i2c 2030000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.029920] i2c i2c-1: IMX I2C adapter registered
[    0.029989] imx-i2c 2040000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.030096] i2c i2c-2: IMX I2C adapter registered
[    0.030173] pps_core: LinuxPPS API ver. 1 registered
[    0.030180] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    0.030193] PTP clock support registered
[    0.030444] Advanced Linux Sound Architecture Driver Initialized.
[    0.030801] clocksource: Switched to clocksource arch_sys_counter
[    0.066711] VFS: Disk quotas dquot_6.6.0
[    0.066755] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    0.069354] NET: Registered protocol family 2
[    0.069591] tcp_listen_portaddr_hash hash table entries: 2048 (order: 
3, 32768 bytes, linear)
[    0.069617] TCP established hash table entries: 32768 (order: 6, 
262144 bytes, linear)
[    0.069709] TCP bind hash table entries: 32768 (order: 7, 524288 
bytes, linear)
[    0.070011] TCP: Hash tables configured (established 32768 bind 
32768)
[    0.070107] UDP hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070134] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070223] NET: Registered protocol family 1
[    0.070243] PCI: CLS 0 bytes, default 64
[    0.070580] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 
7 counters available
[    0.071067] Initialise system trusted keyrings
[    0.071197] workingset: timestamp_bits=44 max_order=20 bucket_order=0
[    0.104336] Key type asymmetric registered
[    0.104352] Asymmetric key parser 'x509' registered
[    0.104380] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 248)
[    0.104389] io scheduler mq-deadline registered
[    0.104396] io scheduler kyber registered
[    0.104830] pci-host-generic 1f0000000.pcie: host bridge 
/soc/pcie@1f0000000 ranges:
[    0.104859] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8000000..0x01f815ffff -> 0x0000000000
[    0.104880] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8160000..0x01f81cffff -> 0x0000000000
[    0.104899] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81d0000..0x01f81effff -> 0x0000000000
[    0.104918] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81f0000..0x01f820ffff -> 0x0000000000
[    0.104936] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8210000..0x01f822ffff -> 0x0000000000
[    0.104954] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8230000..0x01f824ffff -> 0x0000000000
[    0.104971] pci-host-generic 1f0000000.pcie:      MEM 
0x01fc000000..0x01fc3fffff -> 0x0000000000
[    0.105024] pci-host-generic 1f0000000.pcie: ECAM at [mem 
0x1f0000000-0x1f00fffff] for [bus 00]
[    0.105080] pci-host-generic 1f0000000.pcie: PCI host bridge to bus 
0000:00
[    0.105090] pci_bus 0000:00: root bus resource [bus 00]
[    0.105099] pci_bus 0000:00: root bus resource [mem 
0x1f8000000-0x1f815ffff] (bus address [0x00000000-0x0015ffff])
[    0.105111] pci_bus 0000:00: root bus resource [mem 
0x1f8160000-0x1f81cffff pref] (bus address [0x00000000-0x0006ffff])
[    0.105122] pci_bus 0000:00: root bus resource [mem 
0x1f81d0000-0x1f81effff] (bus address [0x00000000-0x0001ffff])
[    0.105133] pci_bus 0000:00: root bus resource [mem 
0x1f81f0000-0x1f820ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.105143] pci_bus 0000:00: root bus resource [mem 
0x1f8210000-0x1f822ffff] (bus address [0x00000000-0x0001ffff])
[    0.105154] pci_bus 0000:00: root bus resource [mem 
0x1f8230000-0x1f824ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.105164] pci_bus 0000:00: root bus resource [mem 
0x1fc000000-0x1fc3fffff] (bus address [0x00000000-0x003fffff])
[    0.105186] pci 0000:00:00.0: [1957:e100] type 00 class 0x020001
[    0.105227] pci 0000:00:00.0: BAR 0: [mem 0x1f8000000-0x1f803ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105240] pci 0000:00:00.0: BAR 2: [mem 0x1f8160000-0x1f816ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105252] pci 0000:00:00.0: VF BAR 0: [mem 0x1f81d0000-0x1f81dffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.105264] pci 0000:00:00.0: VF BAR 2: [mem 0x1f81f0000-0x1f81fffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.105288] pci 0000:00:00.0: PME# supported from D0 D3hot
[    0.105303] pci 0000:00:00.0: VF(n) BAR0 space: [mem 
0x1f81d0000-0x1f81effff 64bit] (contains BAR0 for 2 VFs)
[    0.105314] pci 0000:00:00.0: VF(n) BAR2 space: [mem 
0x1f81f0000-0x1f820ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.105428] pci 0000:00:00.1: [1957:e100] type 00 class 0x020001
[    0.105459] pci 0000:00:00.1: BAR 0: [mem 0x1f8040000-0x1f807ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105471] pci 0000:00:00.1: BAR 2: [mem 0x1f8170000-0x1f817ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105482] pci 0000:00:00.1: VF BAR 0: [mem 0x1f8210000-0x1f821ffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.105494] pci 0000:00:00.1: VF BAR 2: [mem 0x1f8230000-0x1f823ffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.105516] pci 0000:00:00.1: PME# supported from D0 D3hot
[    0.105530] pci 0000:00:00.1: VF(n) BAR0 space: [mem 
0x1f8210000-0x1f822ffff 64bit] (contains BAR0 for 2 VFs)
[    0.105540] pci 0000:00:00.1: VF(n) BAR2 space: [mem 
0x1f8230000-0x1f824ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.105632] pci 0000:00:00.2: [1957:e100] type 00 class 0x020001
[    0.105662] pci 0000:00:00.2: BAR 0: [mem 0x1f8080000-0x1f80bffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105673] pci 0000:00:00.2: BAR 2: [mem 0x1f8180000-0x1f818ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105695] pci 0000:00:00.2: PME# supported from D0 D3hot
[    0.105780] pci 0000:00:00.3: [1957:ee01] type 00 class 0x088001
[    0.105813] pci 0000:00:00.3: BAR 0: [mem 0x1f8100000-0x1f811ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105825] pci 0000:00:00.3: BAR 2: [mem 0x1f8190000-0x1f819ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105846] pci 0000:00:00.3: PME# supported from D0 D3hot
[    0.105934] pci 0000:00:00.4: [1957:ee02] type 00 class 0x088001
[    0.105965] pci 0000:00:00.4: BAR 0: [mem 0x1f8120000-0x1f813ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105976] pci 0000:00:00.4: BAR 2: [mem 0x1f81a0000-0x1f81affff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105998] pci 0000:00:00.4: PME# supported from D0 D3hot
[    0.106082] pci 0000:00:00.5: [1957:eef0] type 00 class 0x020801
[    0.106112] pci 0000:00:00.5: BAR 0: [mem 0x1f8140000-0x1f815ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106123] pci 0000:00:00.5: BAR 2: [mem 0x1f81b0000-0x1f81bffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106135] pci 0000:00:00.5: BAR 4: [mem 0x1fc000000-0x1fc3fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106156] pci 0000:00:00.5: PME# supported from D0 D3hot
[    0.106239] pci 0000:00:00.6: [1957:e100] type 00 class 0x020001
[    0.106269] pci 0000:00:00.6: BAR 0: [mem 0x1f80c0000-0x1f80fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106280] pci 0000:00:00.6: BAR 2: [mem 0x1f81c0000-0x1f81cffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106301] pci 0000:00:00.6: PME# supported from D0 D3hot
[    0.107084] pci 0000:00:1f.0: [1957:e001] type 00 class 0x080700
[    0.107131] OF: /soc/pcie@1f0000000: no msi-map translation for rid 
0xf8 on (null)
[    0.107446] layerscape-pcie 3400000.pcie: host bridge 
/soc/pcie@3400000 ranges:
[    0.107470] layerscape-pcie 3400000.pcie:       IO 
0x8000010000..0x800001ffff -> 0x0000000000
[    0.107487] layerscape-pcie 3400000.pcie:      MEM 
0x8040000000..0x807fffffff -> 0x0040000000
[    0.107573] layerscape-pcie 3400000.pcie: PCI host bridge to bus 
0001:00
[    0.107582] pci_bus 0001:00: root bus resource [bus 00-ff]
[    0.107590] pci_bus 0001:00: root bus resource [io  0x0000-0xffff]
[    0.107599] pci_bus 0001:00: root bus resource [mem 
0x8040000000-0x807fffffff] (bus address [0x40000000-0x7fffffff])
[    0.107620] pci 0001:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.107680] pci 0001:00:00.0: supports D1 D2
[    0.107687] pci 0001:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.109098] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.109112] pci 0001:00:00.0: PCI bridge to [bus 01]
[    0.109199] layerscape-pcie 3500000.pcie: host bridge 
/soc/pcie@3500000 ranges:
[    0.109222] layerscape-pcie 3500000.pcie:       IO 
0x8800010000..0x880001ffff -> 0x0000000000
[    0.109238] layerscape-pcie 3500000.pcie:      MEM 
0x8840000000..0x887fffffff -> 0x0040000000
[    0.109316] layerscape-pcie 3500000.pcie: PCI host bridge to bus 
0002:00
[    0.109325] pci_bus 0002:00: root bus resource [bus 00-ff]
[    0.109333] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff] 
(bus address [0x0000-0xffff])
[    0.109343] pci_bus 0002:00: root bus resource [mem 
0x8840000000-0x887fffffff] (bus address [0x40000000-0x7fffffff])
[    0.109364] pci 0002:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.109422] pci 0002:00:00.0: supports D1 D2
[    0.109429] pci 0002:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.110852] pci_bus 0002:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.110865] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.111131] IPMI message handler: version 39.2
[    0.111157] ipmi device interface
[    0.111183] ipmi_si: IPMI System Interface driver
[    0.111315] ipmi_si: Unable to find any System Interface(s)
[    0.112762] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.113432] 21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.693863] printk: console [ttyS0] enabled
[    1.698318] 21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.707435] 2270000.serial: ttyLP2 at MMIO 0x2270000 (irq = 17, 
base_baud = 12500000) is a FSL_LPUART
[    1.717485] arm-smmu 5000000.iommu: probing hardware configuration...
[    1.723973] arm-smmu 5000000.iommu: SMMUv2 with:
[    1.728612] arm-smmu 5000000.iommu:  stage 1 translation
[    1.733957] arm-smmu 5000000.iommu:  stage 2 translation
[    1.739292] arm-smmu 5000000.iommu:  nested translation
[    1.744539] arm-smmu 5000000.iommu:  stream matching with 128 
register groups
[    1.751708] arm-smmu 5000000.iommu:  64 context banks (0 stage-2 
only)
[    1.758270] arm-smmu 5000000.iommu:  Supported page sizes: 0x61311000
[    1.764740] arm-smmu 5000000.iommu:  Stage-1: 48-bit VA -> 48-bit IPA
[    1.771209] arm-smmu 5000000.iommu:  Stage-2: 48-bit IPA -> 48-bit PA
[    1.777926] ------------[ cut here ]------------
[    1.782566] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:885 
device_links_driver_bound+0x1d8/0x1e8
[    1.791644] Modules linked in:
[    1.794708] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 
5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e #822
[    1.804049] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    1.812346] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    1.817936] pc : device_links_driver_bound+0x1d8/0x1e8
[    1.823090] lr : device_links_driver_bound+0x80/0x1e8
[    1.828156] sp : ffff80001118bb80
[    1.831476] x29: ffff80001118bb80 x28: 0000000000000000
[    1.836805] x27: 0000000000000006 x26: ffff800010cd04e8
[    1.842134] x25: 0000000000000001 x24: ffff00207afe38c0
[    1.847462] x23: ffff800010ff9948 x22: ffff80001118bbd8
[    1.852790] x21: ffff00207afe3810 x20: ffff800011092ae8
[    1.858118] x19: ffff00207afc9080 x18: 0000000000000000
[    1.863446] x17: 0000000000000000 x16: 0000000000000001
[    1.868774] x15: ffffffffffffffff x14: ffff800010ff9948
[    1.874102] x13: ffff00207a7b191c x12: ffff00207a7b1188
[    1.879430] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
[    1.884757] x9 : ffff800010549900 x8 : 0000000040000000
[    1.890085] x7 : 0000000000210d00 x6 : 0000000000168d01
[    1.895414] x5 : ffff80001118bae8 x4 : 0000000000000000
[    1.900743] x3 : ffff800011093380 x2 : 00000000ffffffff
[    1.906072] x1 : 0000000000000001 x0 : 00000000000000c0
[    1.911401] Call trace:
[    1.913851]  device_links_driver_bound+0x1d8/0x1e8
[    1.918657]  driver_bound+0x70/0xc0
[    1.922154]  really_probe+0x110/0x318
[    1.925825]  driver_probe_device+0x40/0x90
[    1.929932]  device_driver_attach+0x7c/0x88
[    1.934126]  __driver_attach+0x60/0xe8
[    1.937884]  bus_for_each_dev+0x7c/0xd0
[    1.941730]  driver_attach+0x2c/0x38
[    1.945314]  bus_add_driver+0x194/0x1f8
[    1.949160]  driver_register+0x6c/0x128
[    1.953007]  __platform_driver_register+0x50/0x60
[    1.957727]  arm_smmu_driver_init+0x24/0x30
[    1.961922]  do_one_initcall+0x54/0x298
[    1.965770]  kernel_init_freeable+0x1ec/0x268
[    1.970141]  kernel_init+0x1c/0x118
[    1.973638]  ret_from_fork+0x10/0x1c
[    1.977223] ---[ end trace 631058e31a4c0a60 ]---
[    1.981876] ------------[ cut here ]------------
[    1.986508] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:885 
device_links_driver_bound+0x1d8/0x1e8
[    1.995588] Modules linked in:
[    1.998649] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e #822
[    2.009385] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    2.017681] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    2.023271] pc : device_links_driver_bound+0x1d8/0x1e8
[    2.028425] lr : device_links_driver_bound+0x80/0x1e8
[    2.033490] sp : ffff80001118bb80
[    2.036810] x29: ffff80001118bb80 x28: 0000000000000000
[    2.042139] x27: 0000000000000006 x26: ffff800010cd04e8
[    2.047467] x25: 0000000000000001 x24: ffff00207afe38c0
[    2.052795] x23: ffff800010ff9948 x22: ffff80001118bbd8
[    2.058123] x21: ffff00207afe3810 x20: ffff800011092ae8
[    2.063451] x19: ffff00207afc9300 x18: 0000000000000000
[    2.068779] x17: 0000000000000000 x16: 0000000000000001
[    2.074107] x15: ffffffffffffffff x14: ffff800010ff9948
[    2.079435] x13: ffff00207a7b191c x12: ffff00207a7b1188
[    2.084763] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
[    2.090091] x9 : ffff800010549900 x8 : 0000000040000000
[    2.095419] x7 : 0000000000210d00 x6 : 0000000000168d01
[    2.100747] x5 : ffff80001118bae8 x4 : 0000000000000000
[    2.106076] x3 : ffff800011093380 x2 : 00000000ffffffff
[    2.111404] x1 : 0000000000000001 x0 : 00000000000000c0
[    2.116732] Call trace:
[    2.119181]  device_links_driver_bound+0x1d8/0x1e8
[    2.123986]  driver_bound+0x70/0xc0
[    2.127483]  really_probe+0x110/0x318
[    2.131154]  driver_probe_device+0x40/0x90
[    2.135261]  device_driver_attach+0x7c/0x88
[    2.139455]  __driver_attach+0x60/0xe8
[    2.143213]  bus_for_each_dev+0x7c/0xd0
[    2.147059]  driver_attach+0x2c/0x38
[    2.150642]  bus_add_driver+0x194/0x1f8
[    2.154488]  driver_register+0x6c/0x128
[    2.158334]  __platform_driver_register+0x50/0x60
[    2.163052]  arm_smmu_driver_init+0x24/0x30
[    2.167246]  do_one_initcall+0x54/0x298
[    2.171092]  kernel_init_freeable+0x1ec/0x268
[    2.175461]  kernel_init+0x1c/0x118
[    2.178958]  ret_from_fork+0x10/0x1c
[    2.182540] ---[ end trace 631058e31a4c0a61 ]---
[    2.187466] at24 0-0050: supply vcc not found, using dummy regulator
[    2.194644] at24 0-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    2.201512] at24 1-0057: supply vcc not found, using dummy regulator
[    2.208645] at24 1-0057: 8192 byte 24c64 EEPROM, writable, 32 
bytes/write
[    2.215515] at24 2-0050: supply vcc not found, using dummy regulator
[    2.222646] at24 2-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    2.229594] mpt3sas version 34.100.00.00 loaded
[    2.235037] spi-nor spi1.0: mx25u3235f (4096 Kbytes)
[    2.243836] spi-nor spi0.0: w25q32dw (4096 Kbytes)
[    2.251312] 10 fixed-partitions partitions found on MTD device 
20c0000.spi
[    2.258233] Creating 10 MTD partitions on "20c0000.spi":
[    2.263584] 0x000000000000-0x000000010000 : "rcw"
[    2.275116] 0x000000010000-0x000000100000 : "failsafe bootloader"
[    2.291103] 0x000000100000-0x000000140000 : "failsafe DP firmware"
[    2.299141] 0x000000140000-0x0000001e0000 : "failsafe trusted 
firmware"
[    2.307132] 0x0000001e0000-0x000000200000 : "reserved"
[    2.315140] 0x000000200000-0x000000210000 : "configuration store"
[    2.323128] 0x000000210000-0x000000300000 : "bootloader"
[    2.331139] 0x000000300000-0x000000340000 : "DP firmware"
[    2.339137] 0x000000340000-0x0000003e0000 : "trusted firmware"
[    2.347128] 0x0000003e0000-0x000000400000 : "bootloader environment"
[    2.355741] libphy: Fixed MDIO Bus: probed
[    2.360044] mscc_felix 0000:00:00.5: Adding to iommu group 0
[    2.365867] mscc_felix 0000:00:00.5: device is disabled, skipping
[    2.372048] fsl_enetc 0000:00:00.0: Adding to iommu group 1
[    2.482818] fsl_enetc 0000:00:00.0: enabling device (0400 -> 0402)
[    2.489064] fsl_enetc 0000:00:00.0: no MAC address specified for SI1, 
using ea:5f:b0:65:71:f2
[    2.497631] fsl_enetc 0000:00:00.0: no MAC address specified for SI2, 
using c2:4f:33:31:4e:2e
[    2.506547] libphy: Freescale ENETC MDIO Bus: probed
[    2.513148] fsl_enetc 0000:00:00.1: Adding to iommu group 2
[    2.518873] fsl_enetc 0000:00:00.1: device is disabled, skipping
[    2.524951] fsl_enetc 0000:00:00.2: Adding to iommu group 3
[    2.530627] fsl_enetc 0000:00:00.2: device is disabled, skipping
[    2.536698] fsl_enetc 0000:00:00.6: Adding to iommu group 4
[    2.542369] fsl_enetc 0000:00:00.6: device is disabled, skipping
[    2.548475] fsl_enetc_mdio 0000:00:00.3: Adding to iommu group 5
[    2.658812] fsl_enetc_mdio 0000:00:00.3: enabling device (0400 -> 
0402)
[    2.665636] libphy: FSL PCIe IE Central MDIO Bus: probed
[    2.671008] igb: Intel(R) Gigabit Ethernet Network Driver - version 
5.6.0-k
[    2.678000] igb: Copyright (c) 2007-2014 Intel Corporation.
[    2.683703] dwc3 3100000.usb: Adding to iommu group 6
[    2.689099] dwc3 3110000.usb: Adding to iommu group 7
[    2.694547] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) 
Driver
[    2.701109] ehci-pci: EHCI PCI platform driver
[    2.705734] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.711255] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 1
[    2.719089] xhci-hcd xhci-hcd.0.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    2.728545] xhci-hcd xhci-hcd.0.auto: irq 21, io mem 0x03100000
[    2.734875] hub 1-0:1.0: USB hub found
[    2.738653] hub 1-0:1.0: 1 port detected
[    2.742694] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.748213] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 2
[    2.755912] xhci-hcd xhci-hcd.0.auto: Host supports USB 3.0 
SuperSpeed
[    2.762502] usb usb2: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    2.770847] hub 2-0:1.0: USB hub found
[    2.774623] hub 2-0:1.0: 1 port detected
[    2.778698] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    2.784219] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 3
[    2.792047] xhci-hcd xhci-hcd.1.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    2.801504] xhci-hcd xhci-hcd.1.auto: irq 22, io mem 0x03110000
[    2.807764] hub 3-0:1.0: USB hub found
[    2.811547] hub 3-0:1.0: 1 port detected
[    2.815588] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    2.821123] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 4
[    2.828820] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0 
SuperSpeed
[    2.835406] usb usb4: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    2.843845] hub 4-0:1.0: USB hub found
[    2.847630] hub 4-0:1.0: 1 port detected
[    2.851736] usbcore: registered new interface driver usb-storage
[    2.858516] rtc-rv8803 0-0032: Voltage low, temperature compensation 
stopped.
[    2.865693] rtc-rv8803 0-0032: Voltage low, data loss detected.
[    2.872709] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    2.878466] rtc-rv8803 0-0032: registered as rtc0
[    2.883865] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    2.889555] rtc-rv8803 0-0032: hctosys: unable to read the hardware 
clock
[    2.896451] i2c /dev entries driver
[    2.905867] sp805-wdt c000000.watchdog: registration successful
[    2.911899] sp805-wdt c010000.watchdog: registration successful
[    2.918436] qoriq-cpufreq qoriq-cpufreq: Freescale QorIQ CPU 
frequency scaling driver
[    2.927074] sdhci: Secure Digital Host Controller Interface driver
[    2.933332] sdhci: Copyright(c) Pierre Ossman
[    2.937744] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.944188] sdhci-esdhc 2140000.mmc: Adding to iommu group 8
[    2.977094] mmc0: SDHCI controller on 2140000.mmc [2140000.mmc] using 
ADMA
[    2.984329] sdhci-esdhc 2150000.mmc: Adding to iommu group 9
[    3.017472] mmc1: SDHCI controller on 2150000.mmc [2150000.mmc] using 
ADMA
[    3.025871] usbcore: registered new interface driver usbhid
[    3.031671] usbhid: USB HID core driver
[    3.037081] wm8904 2-001a: supply DCVDD not found, using dummy 
regulator
[    3.044067] wm8904 2-001a: supply DBVDD not found, using dummy 
regulator
[    3.051013] wm8904 2-001a: supply AVDD not found, using dummy 
regulator
[    3.057867] wm8904 2-001a: supply CPVDD not found, using dummy 
regulator
[    3.064837] wm8904 2-001a: supply MICVDD not found, using dummy 
regulator
[    3.074372] wm8904 2-001a: revision A
[    3.091532] NET: Registered protocol family 10
[    3.098136] Segment Routing with IPv6
[    3.102449] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    3.109971] NET: Registered protocol family 17
[    3.114747] Bridge firewalling registered
[    3.119249] 8021q: 802.1Q VLAN Support v1.8
[    3.123622] Key type dns_resolver registered
[    3.128676] registered taskstats version 1
[    3.132989] Loading compiled-in X.509 certificates
[    3.144145] fsl-edma 22c0000.dma-controller: Adding to iommu group 10
[    3.154732] ------------[ cut here ]------------
[    3.159415] WARNING: CPU: 0 PID: 87 at drivers/base/core.c:885 
device_links_driver_bound+0x1d8/0x1e8
[    3.166873] usb 3-1: new high-speed USB device number 2 using 
xhci-hcd
[    3.168616] Modules linked in:
[    3.178272] CPU: 0 PID: 87 Comm: kworker/0:2 Tainted: G        W      
    5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e #822
[    3.189305] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.197641] Workqueue: events deferred_probe_work_func
[    3.202826] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    3.208442] pc : device_links_driver_bound+0x1d8/0x1e8
[    3.213621] lr : device_links_driver_bound+0x80/0x1e8
[    3.218708] sp : ffff80001239bb80
[    3.222048] x29: ffff80001239bb80 x28: 0000000000000000
[    3.227405] x27: ffff002079dc9cc8 x26: ffff80001110d960
[    3.232760] x25: 0000000000000001 x24: ffff00207afe18c0
[    3.238114] x23: ffff800010ff9948 x22: ffff80001239bbd8
[    3.243468] x21: ffff00207afe1810 x20: ffff800011092ae8
[    3.248822] x19: ffff00207afc9380 x18: 0000000000000000
[    3.254176] x17: 00000000ebdd5bc8 x16: 00000000931f5686
[    3.259530] x15: ffffffffffffffff x14: ffff800010ff9948
[    3.264883] x13: ffff002079eab91c x12: 0000000000000030
[    3.270237] x11: 0101010101010101 x10: ffffffffffffffff
[    3.275591] x9 : ffff800010549900 x8 : ffff002079ec7280
[    3.280945] x7 : 0000000000000000 x6 : 000000000000003f
[    3.286299] x5 : 0000000000000040 x4 : 0000000000000000
[    3.291652] x3 : ffff800011093380 x2 : 00000000ffffffff
[    3.297005] x1 : 0000000000000001 x0 : 00000000000000c0
[    3.302359] Call trace:
[    3.304834]  device_links_driver_bound+0x1d8/0x1e8
[    3.309665]  driver_bound+0x70/0xc0
[    3.313186]  really_probe+0x110/0x318
[    3.316881]  driver_probe_device+0x40/0x90
[    3.321014]  __device_attach_driver+0x8c/0xd0
[    3.325406]  bus_for_each_drv+0x84/0xd8
[    3.329274]  __device_attach+0xd4/0x110
[    3.333143]  device_initial_probe+0x1c/0x28
[    3.337360]  bus_probe_device+0xa4/0xb0
[    3.341228]  deferred_probe_work_func+0x7c/0xb8
[    3.345801]  process_one_work+0x1f4/0x4b8
[    3.349845]  worker_thread+0x218/0x498
[    3.353628]  kthread+0x160/0x168
[    3.356887]  ret_from_fork+0x10/0x1c
[    3.360490] ---[ end trace 631058e31a4c0a63 ]---
[    3.365550] ------------[ cut here ]------------
[    3.370222] WARNING: CPU: 0 PID: 87 at drivers/base/core.c:885 
device_links_driver_bound+0x1d8/0x1e8
[    3.379416] Modules linked in:
[    3.382504] CPU: 0 PID: 87 Comm: kworker/0:2 Tainted: G        W      
    5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e #822
[    3.393535] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.401868] Workqueue: events deferred_probe_work_func
[    3.407051] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    3.412665] pc : device_links_driver_bound+0x1d8/0x1e8
[    3.417841] lr : device_links_driver_bound+0x80/0x1e8
[    3.422926] sp : ffff80001239bb80
[    3.426266] x29: ffff80001239bb80 x28: 0000000000000000
[    3.431620] x27: ffff002079dc9cc8 x26: ffff80001110d960
[    3.436974] x25: 0000000000000001 x24: ffff00207afe18c0
[    3.442328] x23: ffff800010ff9948 x22: ffff80001239bbd8
[    3.447681] x21: ffff00207afe1810 x20: ffff800011092ae8
[    3.453035] x19: ffff00207afc9400 x18: 0000000000000000
[    3.458388] x17: 00000000ebdd5bc8 x16: 00000000931f5686
[    3.463742] x15: ffffffffffffffff x14: ffff800010ff9948
[    3.469095] x13: ffff002079eab91c x12: 0000000000000030
[    3.474449] x11: 0101010101010101 x10: ffffffffffffffff
[    3.479802] x9 : ffff800010549900 x8 : ffff002079ec7280
[    3.485155] x7 : 0000000000000000 x6 : 000000000000003f
[    3.490509] x5 : 0000000000000040 x4 : 0000000000000000
[    3.495861] x3 : ffff800011093380 x2 : 00000000ffffffff
[    3.501214] x1 : 0000000000000001 x0 : 00000000000000c0
[    3.506568] Call trace:
[    3.509040]  device_links_driver_bound+0x1d8/0x1e8
[    3.513870]  driver_bound+0x70/0xc0
[    3.517392]  really_probe+0x110/0x318
[    3.521087]  driver_probe_device+0x40/0x90
[    3.525218]  __device_attach_driver+0x8c/0xd0
[    3.529609]  bus_for_each_drv+0x84/0xd8
[    3.533477]  __device_attach+0xd4/0x110
[    3.537345]  device_initial_probe+0x1c/0x28
[    3.541562]  bus_probe_device+0xa4/0xb0
[    3.545431]  deferred_probe_work_func+0x7c/0xb8
[    3.550003]  process_one_work+0x1f4/0x4b8
[    3.554047]  worker_thread+0x218/0x498
[    3.557828]  kthread+0x160/0x168
[    3.561085]  ret_from_fork+0x10/0x1c
[    3.564687] ---[ end trace 631058e31a4c0a64 ]---
[    3.570341] pcieport 0001:00:00.0: Adding to iommu group 11
[    3.578242] pcieport 0001:00:00.0: AER: enabled with IRQ 24
[    3.584664] pcieport 0002:00:00.0: Adding to iommu group 12
[    3.592136] pcieport 0002:00:00.0: AER: enabled with IRQ 26
[    3.598700] fsl-qdma 8380000.dma-controller: Adding to iommu group 13
[    3.616598] mmc1: new HS400 MMC card at address 0001
[    3.622652] mmcblk1: mmc1:0001 S0J58X 29.6 GiB
[    3.626089] asoc-simple-card sound: wm8904-hifi <-> 
f150000.audio-controller mapping ok
[    3.627823] mmcblk1boot0: mmc1:0001 S0J58X partition 1 31.5 MiB
[    3.638591] asoc-simple-card sound: wm8904-hifi <-> 
f140000.audio-controller mapping ok
[    3.641854] mmcblk1boot1: mmc1:0001 S0J58X partition 2 31.5 MiB
[    3.649580] asoc-simple-card sound: ASoC: no DMI vendor name!
[    3.655672] mmcblk1rpmb: mmc1:0001 S0J58X partition 3 4.00 MiB, 
chardev (245:0)
[    3.664543] irq: no irq domain found for sl28cpld@4a !
[    3.674045] irq: no irq domain found for sl28cpld@4a !
[    3.679595] gpio-keys buttons0: Found button without gpio or irq
[    3.685878]  mmcblk1: p1 p2
[    3.685914] gpio-keys: probe of buttons0 failed with error -22
[    3.694773] mmc0: tuning execution failed: -110
[    3.699465] random: fast init done
[    3.703320] ALSA device list:
[    3.706320]   #0: f150000.audio-controller-wm8904-hifi
[    3.711555] mmc0: error -110 whilst initialising SD card
[    3.731656] hub 3-1:1.0: USB hub found
[    3.735605] hub 3-1:1.0: 7 ports detected
[    3.799235] mmc0: Tuning failed, falling back to fixed sampling clock
[    3.806000] mmc0: tuning execution failed: -11
[    3.811608] EXT4-fs (mmcblk1p2): INFO: recovery required on readonly 
filesystem
[    3.819024] EXT4-fs (mmcblk1p2): write access will be enabled during 
recovery
[    3.853541] EXT4-fs (mmcblk1p2): recovery complete
[    3.861002] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data 
mode. Opts: (null)
[    3.869426] VFS: Mounted root (ext4 filesystem) readonly on device 
179:2.
[    3.877194] devtmpfs: mounted
[    3.888933] mmc0: new high speed SDHC card at address 1234
[    3.895546] mmcblk0: mmc0:1234 SA16G 14.4 GiB
[    3.898566] Freeing unused kernel memory: 3200K
[    3.905237] Run /sbin/init as init process
[    3.906906]  mmcblk0: p1
[    3.909447]   with arguments:
[    3.915028]     /sbin/init
[    3.917786]   with environment:
[    3.920983]     HOME=/
[    3.923386]     TERM=linux
[    3.977243] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[    4.098910] usb 3-1.6: new full-speed USB device number 3 using 
xhci-hcd
[    4.156980] udevd[128]: starting version 3.2.8
[    4.163665] random: udevd: uninitialized urandom read (16 bytes read)
[    4.171580] random: udevd: uninitialized urandom read (16 bytes read)
[    4.178254] random: udevd: uninitialized urandom read (16 bytes read)
[    4.189909] udevd[128]: specified group 'kvm' unknown
[    4.218134] udevd[129]: starting eudev-3.2.8
[    6.462302] fsl_enetc 0000:00:00.0 gbe0: renamed from eth0
[    9.253013] urandom_read: 3 callbacks suppressed
[    9.253026] random: dd: uninitialized urandom read (512 bytes read)
[    9.415994] Qualcomm Atheros AR8031/AR8033 0000:00:00.0:05: attached 
PHY driver [Qualcomm Atheros AR8031/AR8033] 
(mii_bus:phy_addr=0000:00:00.0:05, irq=POLL)
[    9.449789] fsl_enetc 0000:00:00.0 gbe0: Link is Down
[    9.504810] random: dropbear: uninitialized urandom read (32 bytes 
read)
[   15.587487] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 1Gbps/Full - 
flow control off
[   15.595290] IPv6: ADDRCONF(NETDEV_CHANGE): gbe0: link becomes ready


bootlog with this patch and your old debug prints:

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
[    0.000000] Linux version 
5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e-dirty (mw@apollo) 
(aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0, GNU ld (GNU Binutils for 
Debian) 2.31.1) #821 SMP PREEMPT Tue May 26 12:44:31 CEST 2020
[    0.000000] Machine model: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier
[    0.000000] efi: UEFI not found.
[    0.000000] cma: Reserved 32 MiB at 0x00000000f9c00000
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 
0x0000000080000000-0x00000020ffffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x20ff7fe100-0x20ff7fffff]
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
[    0.000000] Memory: 3930016K/4126720K available (9532K kernel code, 
1114K rwdata, 3556K rodata, 3200K init, 398K bss, 163936K reserved, 
32768K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, 
Nodes=1
[    0.000000] ftrace: allocating 32616 entries in 128 pages
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
[    0.000107] Console: colour dummy device 80x25
[    0.000391] printk: console [tty0] enabled
[    0.000438] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 50.00 BogoMIPS (lpj=100000)
[    0.000451] pid_max: default: 32768 minimum: 301
[    0.000497] LSM: Security Framework initializing
[    0.000548] Mount-cache hash table entries: 8192 (order: 4, 65536 
bytes, linear)
[    0.000579] Mountpoint-cache hash table entries: 8192 (order: 4, 
65536 bytes, linear)
[    0.001422] rcu: Hierarchical SRCU implementation.
[    0.001569] Platform MSI: gic-its@6020000 domain created
[    0.001643] PCI/MSI: /interrupt-controller@6000000/gic-its@6020000 
domain created
[    0.001844] EFI services will not be available.
[    0.001942] smp: Bringing up secondary CPUs ...
[    0.002213] Detected PIPT I-cache on CPU1
[    0.002233] GICv3: CPU1: found redistributor 1 region 
0:0x0000000006060000
[    0.002240] GICv3: CPU1: using allocated LPI pending table 
@0x00000020fad50000
[    0.002262] CPU1: Booted secondary processor 0x0000000001 
[0x410fd083]
[    0.002312] smp: Brought up 1 node, 2 CPUs
[    0.002338] SMP: Total of 2 processors activated.
[    0.002346] CPU features: detected: 32-bit EL0 Support
[    0.002353] CPU features: detected: CRC32 instructions
[    0.010365] CPU: All CPU(s) started at EL2
[    0.010384] alternatives: patching kernel code
[    0.010980] devtmpfs: initialized
[    0.012914] KASLR disabled due to lack of seed
[    0.013066] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.013084] futex hash table entries: 512 (order: 3, 32768 bytes, 
linear)
[    0.013852] thermal_sys: Registered thermal governor 'step_wise'
[    0.013977] DMI not present or invalid.
[    0.014161] NET: Registered protocol family 16
[    0.015062] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic 
allocations
[    0.015775] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for 
atomic allocations
[    0.016501] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for 
atomic allocations
[    0.016538] audit: initializing netlink subsys (disabled)
[    0.016662] audit: type=2000 audit(0.016:1): state=initialized 
audit_enabled=0 res=1
[    0.016964] cpuidle: using governor menu
[    0.017031] hw-breakpoint: found 6 breakpoint and 4 watchpoint 
registers.
[    0.017061] ASID allocator initialised with 65536 entries
[    0.017328] Serial: AMBA PL011 UART driver
[    0.023052] platform 2140000.mmc: Link attempted to 5000000.iommu 
0xc0
[    0.023066] platform 2140000.mmc: Link done to 5000000.iommu 0xc0 0
[    0.023090] platform 2150000.mmc: Link attempted to 5000000.iommu 
0xc0
[    0.023099] platform 2150000.mmc: Link done to 5000000.iommu 0xc0 0
[    0.023162] platform 22c0000.dma-controller: Link attempted to 
5000000.iommu 0xc0
[    0.023172] platform 22c0000.dma-controller: Link done to 
5000000.iommu 0xc0 0
[    0.023216] platform 3100000.usb: Link attempted to 5000000.iommu 
0xc0
[    0.023224] platform 3100000.usb: Link done to 5000000.iommu 0xc0 0
[    0.023240] platform 3110000.usb: Link attempted to 5000000.iommu 
0xc0
[    0.023248] platform 3110000.usb: Link done to 5000000.iommu 0xc0 0
[    0.023274] platform 3400000.pcie: Link attempted to 5000000.iommu 
0xc0
[    0.023282] platform 3400000.pcie: Link done to 5000000.iommu 0xc0 0
[    0.023306] platform 3500000.pcie: Link attempted to 5000000.iommu 
0xc0
[    0.023314] platform 3500000.pcie: Link done to 5000000.iommu 0xc0 0
[    0.023332] platform 8380000.dma-controller: Link attempted to 
5000000.iommu 0xc0
[    0.023341] platform 8380000.dma-controller: Link done to 
5000000.iommu 0xc0 0
[    0.023442] platform 1f0000000.pcie: Link attempted to 5000000.iommu 
0xc0
[    0.023450] platform 1f0000000.pcie: Link done to 5000000.iommu 0xc0 
0
[    0.023493] platform f080000.display: Link attempted to 5000000.iommu 
0xc0
[    0.023501] platform f080000.display: Link done to 5000000.iommu 0xc0 
0
[    0.023760] Machine: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 
2.0 carrier
[    0.023770] SoC family: QorIQ LS1028A
[    0.023775] SoC ID: svr:0x870b0110, Revision: 1.0
[    0.026798] HugeTLB registered 1.00 GiB page size, pre-allocated 0 
pages
[    0.026812] HugeTLB registered 32.0 MiB page size, pre-allocated 0 
pages
[    0.026821] HugeTLB registered 2.00 MiB page size, pre-allocated 0 
pages
[    0.026828] HugeTLB registered 64.0 KiB page size, pre-allocated 0 
pages
[    0.027893] cryptd: max_cpu_qlen set to 1000
[    0.029366] iommu: Default domain type: Translated
[    0.029434] vgaarb: loaded
[    0.029572] SCSI subsystem initialized
[    0.029660] usbcore: registered new interface driver usbfs
[    0.029685] usbcore: registered new interface driver hub
[    0.029718] usbcore: registered new device driver usb
[    0.029851] imx-i2c 2000000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.030028] i2c i2c-0: IMX I2C adapter registered
[    0.030102] imx-i2c 2030000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.030177] i2c i2c-1: IMX I2C adapter registered
[    0.030249] imx-i2c 2040000.i2c: can't get pinctrl, bus recovery not 
supported
[    0.030347] i2c i2c-2: IMX I2C adapter registered
[    0.030427] pps_core: LinuxPPS API ver. 1 registered
[    0.030434] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    0.030448] PTP clock support registered
[    0.030674] Advanced Linux Sound Architecture Driver Initialized.
[    0.031031] clocksource: Switched to clocksource arch_sys_counter
[    0.066872] VFS: Disk quotas dquot_6.6.0
[    0.066915] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    0.069623] NET: Registered protocol family 2
[    0.069858] tcp_listen_portaddr_hash hash table entries: 2048 (order: 
3, 32768 bytes, linear)
[    0.069883] TCP established hash table entries: 32768 (order: 6, 
262144 bytes, linear)
[    0.069975] TCP bind hash table entries: 32768 (order: 7, 524288 
bytes, linear)
[    0.070280] TCP: Hash tables configured (established 32768 bind 
32768)
[    0.070378] UDP hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070405] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, 
linear)
[    0.070491] NET: Registered protocol family 1
[    0.070512] PCI: CLS 0 bytes, default 64
[    0.070842] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 
7 counters available
[    0.071326] Initialise system trusted keyrings
[    0.071453] workingset: timestamp_bits=44 max_order=20 bucket_order=0
[    0.104530] Key type asymmetric registered
[    0.104546] Asymmetric key parser 'x509' registered
[    0.104572] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 248)
[    0.104582] io scheduler mq-deadline registered
[    0.104588] io scheduler kyber registered
[    0.105023] pci-host-generic 1f0000000.pcie: host bridge 
/soc/pcie@1f0000000 ranges:
[    0.105053] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8000000..0x01f815ffff -> 0x0000000000
[    0.105074] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8160000..0x01f81cffff -> 0x0000000000
[    0.105093] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81d0000..0x01f81effff -> 0x0000000000
[    0.105112] pci-host-generic 1f0000000.pcie:      MEM 
0x01f81f0000..0x01f820ffff -> 0x0000000000
[    0.105131] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8210000..0x01f822ffff -> 0x0000000000
[    0.105149] pci-host-generic 1f0000000.pcie:      MEM 
0x01f8230000..0x01f824ffff -> 0x0000000000
[    0.105163] pci-host-generic 1f0000000.pcie:      MEM 
0x01fc000000..0x01fc3fffff -> 0x0000000000
[    0.105213] pci-host-generic 1f0000000.pcie: ECAM at [mem 
0x1f0000000-0x1f00fffff] for [bus 00]
[    0.105273] pci-host-generic 1f0000000.pcie: PCI host bridge to bus 
0000:00
[    0.105283] pci_bus 0000:00: root bus resource [bus 00]
[    0.105292] pci_bus 0000:00: root bus resource [mem 
0x1f8000000-0x1f815ffff] (bus address [0x00000000-0x0015ffff])
[    0.105304] pci_bus 0000:00: root bus resource [mem 
0x1f8160000-0x1f81cffff pref] (bus address [0x00000000-0x0006ffff])
[    0.105314] pci_bus 0000:00: root bus resource [mem 
0x1f81d0000-0x1f81effff] (bus address [0x00000000-0x0001ffff])
[    0.105325] pci_bus 0000:00: root bus resource [mem 
0x1f81f0000-0x1f820ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.105335] pci_bus 0000:00: root bus resource [mem 
0x1f8210000-0x1f822ffff] (bus address [0x00000000-0x0001ffff])
[    0.105346] pci_bus 0000:00: root bus resource [mem 
0x1f8230000-0x1f824ffff pref] (bus address [0x00000000-0x0001ffff])
[    0.105356] pci_bus 0000:00: root bus resource [mem 
0x1fc000000-0x1fc3fffff] (bus address [0x00000000-0x003fffff])
[    0.105378] pci 0000:00:00.0: [1957:e100] type 00 class 0x020001
[    0.105420] pci 0000:00:00.0: BAR 0: [mem 0x1f8000000-0x1f803ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105433] pci 0000:00:00.0: BAR 2: [mem 0x1f8160000-0x1f816ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105445] pci 0000:00:00.0: VF BAR 0: [mem 0x1f81d0000-0x1f81dffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.105457] pci 0000:00:00.0: VF BAR 2: [mem 0x1f81f0000-0x1f81fffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.105482] pci 0000:00:00.0: PME# supported from D0 D3hot
[    0.105497] pci 0000:00:00.0: VF(n) BAR0 space: [mem 
0x1f81d0000-0x1f81effff 64bit] (contains BAR0 for 2 VFs)
[    0.105507] pci 0000:00:00.0: VF(n) BAR2 space: [mem 
0x1f81f0000-0x1f820ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.105622] pci 0000:00:00.1: [1957:e100] type 00 class 0x020001
[    0.105652] pci 0000:00:00.1: BAR 0: [mem 0x1f8040000-0x1f807ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105664] pci 0000:00:00.1: BAR 2: [mem 0x1f8170000-0x1f817ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105676] pci 0000:00:00.1: VF BAR 0: [mem 0x1f8210000-0x1f821ffff 
64bit] (from Enhanced Allocation, properties 0x4)
[    0.105687] pci 0000:00:00.1: VF BAR 2: [mem 0x1f8230000-0x1f823ffff 
64bit pref] (from Enhanced Allocation, properties 0x3)
[    0.105710] pci 0000:00:00.1: PME# supported from D0 D3hot
[    0.105723] pci 0000:00:00.1: VF(n) BAR0 space: [mem 
0x1f8210000-0x1f822ffff 64bit] (contains BAR0 for 2 VFs)
[    0.105734] pci 0000:00:00.1: VF(n) BAR2 space: [mem 
0x1f8230000-0x1f824ffff 64bit pref] (contains BAR2 for 2 VFs)
[    0.105825] pci 0000:00:00.2: [1957:e100] type 00 class 0x020001
[    0.105855] pci 0000:00:00.2: BAR 0: [mem 0x1f8080000-0x1f80bffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.105867] pci 0000:00:00.2: BAR 2: [mem 0x1f8180000-0x1f818ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.105889] pci 0000:00:00.2: PME# supported from D0 D3hot
[    0.105971] pci 0000:00:00.3: [1957:ee01] type 00 class 0x088001
[    0.106004] pci 0000:00:00.3: BAR 0: [mem 0x1f8100000-0x1f811ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106016] pci 0000:00:00.3: BAR 2: [mem 0x1f8190000-0x1f819ffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106037] pci 0000:00:00.3: PME# supported from D0 D3hot
[    0.106122] pci 0000:00:00.4: [1957:ee02] type 00 class 0x088001
[    0.106152] pci 0000:00:00.4: BAR 0: [mem 0x1f8120000-0x1f813ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106164] pci 0000:00:00.4: BAR 2: [mem 0x1f81a0000-0x1f81affff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106186] pci 0000:00:00.4: PME# supported from D0 D3hot
[    0.106275] pci 0000:00:00.5: [1957:eef0] type 00 class 0x020801
[    0.106304] pci 0000:00:00.5: BAR 0: [mem 0x1f8140000-0x1f815ffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106316] pci 0000:00:00.5: BAR 2: [mem 0x1f81b0000-0x1f81bffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106327] pci 0000:00:00.5: BAR 4: [mem 0x1fc000000-0x1fc3fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106349] pci 0000:00:00.5: PME# supported from D0 D3hot
[    0.106436] pci 0000:00:00.6: [1957:e100] type 00 class 0x020001
[    0.106465] pci 0000:00:00.6: BAR 0: [mem 0x1f80c0000-0x1f80fffff 
64bit] (from Enhanced Allocation, properties 0x0)
[    0.106477] pci 0000:00:00.6: BAR 2: [mem 0x1f81c0000-0x1f81cffff 
64bit pref] (from Enhanced Allocation, properties 0x1)
[    0.106498] pci 0000:00:00.6: PME# supported from D0 D3hot
[    0.107281] pci 0000:00:1f.0: [1957:e001] type 00 class 0x080700
[    0.107327] OF: /soc/pcie@1f0000000: no msi-map translation for rid 
0xf8 on (null)
[    0.107636] layerscape-pcie 3400000.pcie: host bridge 
/soc/pcie@3400000 ranges:
[    0.107661] layerscape-pcie 3400000.pcie:       IO 
0x8000010000..0x800001ffff -> 0x0000000000
[    0.107677] layerscape-pcie 3400000.pcie:      MEM 
0x8040000000..0x807fffffff -> 0x0040000000
[    0.107761] layerscape-pcie 3400000.pcie: PCI host bridge to bus 
0001:00
[    0.107771] pci_bus 0001:00: root bus resource [bus 00-ff]
[    0.107779] pci_bus 0001:00: root bus resource [io  0x0000-0xffff]
[    0.107787] pci_bus 0001:00: root bus resource [mem 
0x8040000000-0x807fffffff] (bus address [0x40000000-0x7fffffff])
[    0.107808] pci 0001:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.107869] pci 0001:00:00.0: supports D1 D2
[    0.107876] pci 0001:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.109286] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.109300] pci 0001:00:00.0: PCI bridge to [bus 01]
[    0.109389] layerscape-pcie 3500000.pcie: host bridge 
/soc/pcie@3500000 ranges:
[    0.109412] layerscape-pcie 3500000.pcie:       IO 
0x8800010000..0x880001ffff -> 0x0000000000
[    0.109428] layerscape-pcie 3500000.pcie:      MEM 
0x8840000000..0x887fffffff -> 0x0040000000
[    0.109504] layerscape-pcie 3500000.pcie: PCI host bridge to bus 
0002:00
[    0.109514] pci_bus 0002:00: root bus resource [bus 00-ff]
[    0.109523] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff] 
(bus address [0x0000-0xffff])
[    0.109533] pci_bus 0002:00: root bus resource [mem 
0x8840000000-0x887fffffff] (bus address [0x40000000-0x7fffffff])
[    0.109553] pci 0002:00:00.0: [1957:82c1] type 01 class 0x060400
[    0.109612] pci 0002:00:00.0: supports D1 D2
[    0.109619] pci 0002:00:00.0: PME# supported from D0 D1 D2 D3hot
[    0.111018] pci_bus 0002:01: busn_res: [bus 01-ff] end is updated to 
01
[    0.111042] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.111307] IPMI message handler: version 39.2
[    0.111334] ipmi device interface
[    0.111361] ipmi_si: IPMI System Interface driver
[    0.111483] ipmi_si: Unable to find any System Interface(s)
[    0.112924] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.113617] 21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.828331] printk: console [ttyS0] enabled
[    1.832790] 21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 16, 
base_baud = 12500000) is a 16550A
[    1.841898] 2270000.serial: ttyLP2 at MMIO 0x2270000 (irq = 17, 
base_baud = 12500000) is a FSL_LPUART
[    1.851954] arm-smmu 5000000.iommu: probing hardware configuration...
[    1.858430] arm-smmu 5000000.iommu: SMMUv2 with:
[    1.863080] arm-smmu 5000000.iommu:  stage 1 translation
[    1.868418] arm-smmu 5000000.iommu:  stage 2 translation
[    1.873761] arm-smmu 5000000.iommu:  nested translation
[    1.879012] arm-smmu 5000000.iommu:  stream matching with 128 
register groups
[    1.886182] arm-smmu 5000000.iommu:  64 context banks (0 stage-2 
only)
[    1.892743] arm-smmu 5000000.iommu:  Supported page sizes: 0x61311000
[    1.899213] arm-smmu 5000000.iommu:  Stage-1: 48-bit VA -> 48-bit IPA
[    1.905681] arm-smmu 5000000.iommu:  Stage-2: 48-bit IPA -> 48-bit PA
[    1.912398] ------------[ cut here ]------------
[    1.917037] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:894 
device_links_driver_bound+0x204/0x230
[    1.926117] Modules linked in:
[    1.929181] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 
5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e-dirty #821
[    1.939047] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    1.947344] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    1.952934] pc : device_links_driver_bound+0x204/0x230
[    1.958088] lr : device_links_driver_bound+0x84/0x230
[    1.963153] sp : ffff80001118bb70
[    1.966474] x29: ffff80001118bb70 x28: 0000000000000000
[    1.971803] x27: 0000000000000006 x26: ffff800010cd04e8
[    1.977133] x25: 0000000000000001 x24: ffff00207a421cc0
[    1.982462] x23: ffff800010ff9948 x22: ffff80001118bbd8
[    1.987790] x21: ffff00207a421c10 x20: ffff800011092ae8
[    1.993119] x19: ffff00207a401080 x18: 0000000000000000
[    1.998448] x17: 0000000000000000 x16: 0000000000000001
[    2.003776] x15: ffffffffffffffff x14: ffff800010ff9948
[    2.009105] x13: ffff00207a7a191c x12: ffff00207a7a1188
[    2.014434] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
[    2.019762] x9 : ffff800010549904 x8 : 0000000040000000
[    2.025091] x7 : 0000000000210d00 x6 : 000000000011aa01
[    2.030420] x5 : ffff80001118bae8 x4 : 0000000000000000
[    2.035748] x3 : ffff800011093380 x2 : 00000000ffffffff
[    2.041076] x1 : 0000000000000001 x0 : 00000000000000c0
[    2.046406] Call trace:
[    2.048857]  device_links_driver_bound+0x204/0x230
[    2.053663]  driver_bound+0x70/0xc0
[    2.057159]  really_probe+0x110/0x318
[    2.060831]  driver_probe_device+0x40/0x90
[    2.064938]  device_driver_attach+0x7c/0x88
[    2.069132]  __driver_attach+0x60/0xe8
[    2.072890]  bus_for_each_dev+0x7c/0xd0
[    2.076736]  driver_attach+0x2c/0x38
[    2.080319]  bus_add_driver+0x194/0x1f8
[    2.084165]  driver_register+0x6c/0x128
[    2.088013]  __platform_driver_register+0x50/0x60
[    2.092732]  arm_smmu_driver_init+0x24/0x30
[    2.096928]  do_one_initcall+0x54/0x298
[    2.100775]  kernel_init_freeable+0x1ec/0x268
[    2.105147]  kernel_init+0x1c/0x118
[    2.108643]  ret_from_fork+0x10/0x1c
[    2.112229] ---[ end trace 5f1283b865df63a7 ]---
[    2.116881] ------------[ cut here ]------------
[    2.121514] WARNING: CPU: 1 PID: 1 at drivers/base/core.c:894 
device_links_driver_bound+0x204/0x230
[    2.130593] Modules linked in:
[    2.133655] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         
5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e-dirty #821
[    2.144914] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    2.153210] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    2.158800] pc : device_links_driver_bound+0x204/0x230
[    2.163953] lr : device_links_driver_bound+0x84/0x230
[    2.169019] sp : ffff80001118bb70
[    2.172339] x29: ffff80001118bb70 x28: 0000000000000000
[    2.177667] x27: 0000000000000006 x26: ffff800010cd04e8
[    2.182995] x25: 0000000000000001 x24: ffff00207a421cc0
[    2.188323] x23: ffff800010ff9948 x22: ffff80001118bbd8
[    2.193651] x21: ffff00207a421c10 x20: ffff800011092ae8
[    2.198980] x19: ffff00207a401300 x18: 0000000000000000
[    2.204309] x17: 0000000000000000 x16: 0000000000000001
[    2.209638] x15: ffffffffffffffff x14: ffff800010ff9948
[    2.214966] x13: ffff00207a7a191c x12: ffff00207a7a1188
[    2.220295] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
[    2.225623] x9 : ffff800010549904 x8 : 0000000040000000
[    2.230952] x7 : 0000000000210d00 x6 : 000000000011aa01
[    2.236280] x5 : ffff80001118bae8 x4 : 0000000000000000
[    2.241607] x3 : ffff800011093380 x2 : 00000000ffffffff
[    2.246935] x1 : 0000000000000001 x0 : 00000000000000c0
[    2.252263] Call trace:
[    2.254713]  device_links_driver_bound+0x204/0x230
[    2.259517]  driver_bound+0x70/0xc0
[    2.263014]  really_probe+0x110/0x318
[    2.266685]  driver_probe_device+0x40/0x90
[    2.270792]  device_driver_attach+0x7c/0x88
[    2.274986]  __driver_attach+0x60/0xe8
[    2.278744]  bus_for_each_dev+0x7c/0xd0
[    2.282590]  driver_attach+0x2c/0x38
[    2.286173]  bus_add_driver+0x194/0x1f8
[    2.290019]  driver_register+0x6c/0x128
[    2.293865]  __platform_driver_register+0x50/0x60
[    2.298584]  arm_smmu_driver_init+0x24/0x30
[    2.302778]  do_one_initcall+0x54/0x298
[    2.306625]  kernel_init_freeable+0x1ec/0x268
[    2.310994]  kernel_init+0x1c/0x118
[    2.314490]  ret_from_fork+0x10/0x1c
[    2.318073] ---[ end trace 5f1283b865df63a8 ]---
[    2.322996] at24 0-0050: supply vcc not found, using dummy regulator
[    2.330166] at24 0-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    2.337038] at24 1-0057: supply vcc not found, using dummy regulator
[    2.344179] at24 1-0057: 8192 byte 24c64 EEPROM, writable, 32 
bytes/write
[    2.351054] at24 2-0050: supply vcc not found, using dummy regulator
[    2.358190] at24 2-0050: 4096 byte 24c32 EEPROM, writable, 32 
bytes/write
[    2.365140] mpt3sas version 34.100.00.00 loaded
[    2.370564] spi-nor spi1.0: mx25u3235f (4096 Kbytes)
[    2.380064] spi-nor spi0.0: w25q32dw (4096 Kbytes)
[    2.387528] 10 fixed-partitions partitions found on MTD device 
20c0000.spi
[    2.394448] Creating 10 MTD partitions on "20c0000.spi":
[    2.399799] 0x000000000000-0x000000010000 : "rcw"
[    2.411340] 0x000000010000-0x000000100000 : "failsafe bootloader"
[    2.427336] 0x000000100000-0x000000140000 : "failsafe DP firmware"
[    2.435373] 0x000000140000-0x0000001e0000 : "failsafe trusted 
firmware"
[    2.443355] 0x0000001e0000-0x000000200000 : "reserved"
[    2.451351] 0x000000200000-0x000000210000 : "configuration store"
[    2.459357] 0x000000210000-0x000000300000 : "bootloader"
[    2.467370] 0x000000300000-0x000000340000 : "DP firmware"
[    2.475357] 0x000000340000-0x0000003e0000 : "trusted firmware"
[    2.483359] 0x0000003e0000-0x000000400000 : "bootloader environment"
[    2.491959] libphy: Fixed MDIO Bus: probed
[    2.496241] mscc_felix 0000:00:00.5: Link attempted to 5000000.iommu 
0x54
[    2.503065] mscc_felix 0000:00:00.5: Link done to 5000000.iommu 0x54 
2
[    2.509653] mscc_felix 0000:00:00.5: Adding to iommu group 0
[    2.515467] mscc_felix 0000:00:00.5: device is disabled, skipping
[    2.521625] fsl_enetc 0000:00:00.0: Link attempted to 5000000.iommu 
0x54
[    2.528361] fsl_enetc 0000:00:00.0: Link done to 5000000.iommu 0x54 2
[    2.534856] fsl_enetc 0000:00:00.0: Adding to iommu group 1
[    2.647047] fsl_enetc 0000:00:00.0: enabling device (0400 -> 0402)
[    2.653291] fsl_enetc 0000:00:00.0: no MAC address specified for SI1, 
using 4a:2a:40:9e:80:bf
[    2.661857] fsl_enetc 0000:00:00.0: no MAC address specified for SI2, 
using ce:dc:7b:f3:2e:53
[    2.670767] libphy: Freescale ENETC MDIO Bus: probed
[    2.677334] fsl_enetc 0000:00:00.1: Link attempted to 5000000.iommu 
0x54
[    2.684091] fsl_enetc 0000:00:00.1: Link done to 5000000.iommu 0x54 2
[    2.690595] fsl_enetc 0000:00:00.1: Adding to iommu group 2
[    2.696284] fsl_enetc 0000:00:00.1: device is disabled, skipping
[    2.702337] fsl_enetc 0000:00:00.2: Link attempted to 5000000.iommu 
0x54
[    2.709070] fsl_enetc 0000:00:00.2: Link done to 5000000.iommu 0x54 2
[    2.715562] fsl_enetc 0000:00:00.2: Adding to iommu group 3
[    2.721231] fsl_enetc 0000:00:00.2: device is disabled, skipping
[    2.727282] fsl_enetc 0000:00:00.6: Link attempted to 5000000.iommu 
0x54
[    2.734015] fsl_enetc 0000:00:00.6: Link done to 5000000.iommu 0x54 2
[    2.740504] fsl_enetc 0000:00:00.6: Adding to iommu group 4
[    2.746174] fsl_enetc 0000:00:00.6: device is disabled, skipping
[    2.752257] fsl_enetc_mdio 0000:00:00.3: Link attempted to 
5000000.iommu 0x54
[    2.759426] fsl_enetc_mdio 0000:00:00.3: Link done to 5000000.iommu 
0x54 2
[    2.766354] fsl_enetc_mdio 0000:00:00.3: Adding to iommu group 5
[    2.879055] fsl_enetc_mdio 0000:00:00.3: enabling device (0400 -> 
0402)
[    2.885876] libphy: FSL PCIe IE Central MDIO Bus: probed
[    2.891247] igb: Intel(R) Gigabit Ethernet Network Driver - version 
5.6.0-k
[    2.898240] igb: Copyright (c) 2007-2014 Intel Corporation.
[    2.903923] dwc3 3100000.usb: Link attempted to 5000000.iommu 0x54
[    2.910134] dwc3 3100000.usb: Link done to 5000000.iommu 0x44 2
[    2.916092] dwc3 3100000.usb: Adding to iommu group 6
[    2.921460] dwc3 3110000.usb: Link attempted to 5000000.iommu 0x54
[    2.927675] dwc3 3110000.usb: Link done to 5000000.iommu 0x44 2
[    2.933638] dwc3 3110000.usb: Adding to iommu group 7
[    2.939087] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) 
Driver
[    2.945645] ehci-pci: EHCI PCI platform driver
[    2.950271] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.955793] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 1
[    2.963632] xhci-hcd xhci-hcd.0.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    2.973088] xhci-hcd xhci-hcd.0.auto: irq 21, io mem 0x03100000
[    2.979411] hub 1-0:1.0: USB hub found
[    2.983193] hub 1-0:1.0: 1 port detected
[    2.987240] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.992756] xhci-hcd xhci-hcd.0.auto: new USB bus registered, 
assigned bus number 2
[    3.000452] xhci-hcd xhci-hcd.0.auto: Host supports USB 3.0 
SuperSpeed
[    3.007048] usb usb2: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    3.015383] hub 2-0:1.0: USB hub found
[    3.019162] hub 2-0:1.0: 1 port detected
[    3.023245] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    3.028763] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 3
[    3.036593] xhci-hcd xhci-hcd.1.auto: hcc params 0x0220f66d hci 
version 0x100 quirks 0x0000000002010010
[    3.046054] xhci-hcd xhci-hcd.1.auto: irq 22, io mem 0x03110000
[    3.052317] hub 3-0:1.0: USB hub found
[    3.056097] hub 3-0:1.0: 1 port detected
[    3.060137] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    3.065654] xhci-hcd xhci-hcd.1.auto: new USB bus registered, 
assigned bus number 4
[    3.073349] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0 
SuperSpeed
[    3.079934] usb usb4: We don't know the algorithms for LPM for this 
host, disabling LPM.
[    3.088272] hub 4-0:1.0: USB hub found
[    3.092134] hub 4-0:1.0: 1 port detected
[    3.096265] usbcore: registered new interface driver usb-storage
[    3.103053] rtc-rv8803 0-0032: Voltage low, temperature compensation 
stopped.
[    3.110229] rtc-rv8803 0-0032: Voltage low, data loss detected.
[    3.117246] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    3.122999] rtc-rv8803 0-0032: registered as rtc0
[    3.128404] rtc-rv8803 0-0032: Voltage low, data is invalid.
[    3.134094] rtc-rv8803 0-0032: hctosys: unable to read the hardware 
clock
[    3.140991] i2c /dev entries driver
[    3.150393] sp805-wdt c000000.watchdog: registration successful
[    3.156428] sp805-wdt c010000.watchdog: registration successful
[    3.162924] qoriq-cpufreq qoriq-cpufreq: Freescale QorIQ CPU 
frequency scaling driver
[    3.171556] sdhci: Secure Digital Host Controller Interface driver
[    3.177814] sdhci: Copyright(c) Pierre Ossman
[    3.182239] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.188621] sdhci-esdhc 2140000.mmc: Link attempted to 5000000.iommu 
0x54
[    3.195501] sdhci-esdhc 2140000.mmc: Link done to 5000000.iommu 0x44 
2
[    3.202317] sdhci-esdhc 2140000.mmc: Adding to iommu group 8
[    3.235181] mmc0: SDHCI controller on 2140000.mmc [2140000.mmc] using 
ADMA
[    3.242331] sdhci-esdhc 2150000.mmc: Link attempted to 5000000.iommu 
0x54
[    3.249262] sdhci-esdhc 2150000.mmc: Link done to 5000000.iommu 0x44 
2
[    3.256077] sdhci-esdhc 2150000.mmc: Adding to iommu group 9
[    3.289644] mmc1: SDHCI controller on 2150000.mmc [2150000.mmc] using 
ADMA
[    3.298545] usbcore: registered new interface driver usbhid
[    3.304241] usbhid: USB HID core driver
[    3.309433] wm8904 2-001a: supply DCVDD not found, using dummy 
regulator
[    3.316591] wm8904 2-001a: supply DBVDD not found, using dummy 
regulator
[    3.323671] wm8904 2-001a: supply AVDD not found, using dummy 
regulator
[    3.330686] wm8904 2-001a: supply CPVDD not found, using dummy 
regulator
[    3.337903] wm8904 2-001a: supply MICVDD not found, using dummy 
regulator
[    3.347954] wm8904 2-001a: revision A
[    3.365119] NET: Registered protocol family 10
[    3.371599] Segment Routing with IPv6
[    3.376236] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    3.383402] NET: Registered protocol family 17
[    3.388220] Bridge firewalling registered
[    3.392748] 8021q: 802.1Q VLAN Support v1.8
[    3.397224] Key type dns_resolver registered
[    3.401986] registered taskstats version 1
[    3.406344] Loading compiled-in X.509 certificates
[    3.415093] usb 3-1: new high-speed USB device number 2 using 
xhci-hcd
[    3.417319] fsl-edma 22c0000.dma-controller: Link attempted to 
5000000.iommu 0x54
[    3.429605] fsl-edma 22c0000.dma-controller: Link done to 
5000000.iommu 0x44 2
[    3.437265] fsl-edma 22c0000.dma-controller: Adding to iommu group 10
[    3.447834] ------------[ cut here ]------------
[    3.452517] WARNING: CPU: 0 PID: 87 at drivers/base/core.c:894 
device_links_driver_bound+0x204/0x230
[    3.461712] Modules linked in:
[    3.464803] CPU: 0 PID: 87 Comm: kworker/0:2 Tainted: G        W      
    5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e-dirty #821
[    3.476360] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.484697] Workqueue: events deferred_probe_work_func
[    3.489882] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    3.495499] pc : device_links_driver_bound+0x204/0x230
[    3.500677] lr : device_links_driver_bound+0x84/0x230
[    3.505764] sp : ffff8000123ebb70
[    3.509103] x29: ffff8000123ebb70 x28: 0000000000000000
[    3.514460] x27: ffff002079d95bc8 x26: ffff80001110d960
[    3.519815] x25: 0000000000000001 x24: ffff00207a41bcc0
[    3.525168] x23: ffff800010ff9948 x22: ffff8000123ebbd8
[    3.530523] x21: ffff00207a41bc10 x20: ffff800011092ae8
[    3.535875] x19: ffff00207a401380 x18: 0000000000000000
[    3.541228] x17: 00000000d4fe143f x16: 00000000a97ea50e
[    3.546581] x15: ffffffffffffffff x14: ffff800010ff9948
[    3.551933] x13: ffff002079eeb91c x12: 0000000000000030
[    3.557286] x11: 0101010101010101 x10: ffffffffffffffff
[    3.562639] x9 : ffff800010549904 x8 : ffff002079ebc480
[    3.567992] x7 : 0000000000000000 x6 : 000000000000003f
[    3.573345] x5 : 0000000000000040 x4 : 0000000000000000
[    3.578697] x3 : ffff800011093380 x2 : 00000000ffffffff
[    3.584049] x1 : 0000000000000001 x0 : 00000000000000c0
[    3.589402] Call trace:
[    3.591876]  device_links_driver_bound+0x204/0x230
[    3.596707]  driver_bound+0x70/0xc0
[    3.600227]  really_probe+0x110/0x318
[    3.603922]  driver_probe_device+0x40/0x90
[    3.608053]  __device_attach_driver+0x8c/0xd0
[    3.612445]  bus_for_each_drv+0x84/0xd8
[    3.616313]  __device_attach+0xd4/0x110
[    3.620180]  device_initial_probe+0x1c/0x28
[    3.624397]  bus_probe_device+0xa4/0xb0
[    3.628265]  deferred_probe_work_func+0x7c/0xb8
[    3.632837]  process_one_work+0x1f4/0x4b8
[    3.636882]  worker_thread+0x218/0x498
[    3.640664]  kthread+0x160/0x168
[    3.643922]  ret_from_fork+0x10/0x1c
[    3.647525] ---[ end trace 5f1283b865df63aa ]---
[    3.652669] ------------[ cut here ]------------
[    3.657340] WARNING: CPU: 0 PID: 87 at drivers/base/core.c:894 
device_links_driver_bound+0x204/0x230
[    3.666533] Modules linked in:
[    3.669621] CPU: 0 PID: 87 Comm: kworker/0:2 Tainted: G        W      
    5.7.0-rc7-next-20200525-00001-g6f5a5abdbb5e-dirty #821
[    3.681175] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC 
Eval 2.0 carrier (DT)
[    3.689507] Workqueue: events deferred_probe_work_func
[    3.694690] pstate: a0000005 (NzCv daif -PAN -UAO BTYPE=--)
[    3.700306] pc : device_links_driver_bound+0x204/0x230
[    3.705481] lr : device_links_driver_bound+0x84/0x230
[    3.710566] sp : ffff8000123ebb70
[    3.713904] x29: ffff8000123ebb70 x28: 0000000000000000
[    3.719258] x27: ffff002079d95bc8 x26: ffff80001110d960
[    3.724610] x25: 0000000000000001 x24: ffff00207a41bcc0
[    3.729964] x23: ffff800010ff9948 x22: ffff8000123ebbd8
[    3.735317] x21: ffff00207a41bc10 x20: ffff800011092ae8
[    3.740669] x19: ffff00207a401400 x18: 0000000000000000
[    3.746022] x17: 00000000d4fe143f x16: 00000000a97ea50e
[    3.751376] x15: ffffffffffffffff x14: ffff800010ff9948
[    3.756728] x13: ffff002079eeb91c x12: 0000000000000030
[    3.762081] x11: 0101010101010101 x10: ffffffffffffffff
[    3.767434] x9 : ffff800010549904 x8 : ffff002079ebc480
[    3.772787] x7 : 0000000000000000 x6 : 000000000000003f
[    3.778139] x5 : 0000000000000040 x4 : 0000000000000000
[    3.783492] x3 : ffff800011093380 x2 : 00000000ffffffff
[    3.788844] x1 : 0000000000000001 x0 : 00000000000000c0
[    3.794197] Call trace:
[    3.796667]  device_links_driver_bound+0x204/0x230
[    3.801496]  driver_bound+0x70/0xc0
[    3.805015]  really_probe+0x110/0x318
[    3.808709]  driver_probe_device+0x40/0x90
[    3.812840]  __device_attach_driver+0x8c/0xd0
[    3.817231]  bus_for_each_drv+0x84/0xd8
[    3.821099]  __device_attach+0xd4/0x110
[    3.824968]  device_initial_probe+0x1c/0x28
[    3.829184]  bus_probe_device+0xa4/0xb0
[    3.833053]  deferred_probe_work_func+0x7c/0xb8
[    3.837623]  process_one_work+0x1f4/0x4b8
[    3.841668]  worker_thread+0x218/0x498
[    3.845449]  kthread+0x160/0x168
[    3.848707]  ret_from_fork+0x10/0x1c
[    3.852309] ---[ end trace 5f1283b865df63ab ]---
[    3.857863] pcieport 0001:00:00.0: Link attempted to 5000000.iommu 
0x54
[    3.864849] pcieport 0001:00:00.0: Link done to 5000000.iommu 0x54 2
[    3.872052] pcieport 0001:00:00.0: Adding to iommu group 11
[    3.879441] pcieport 0001:00:00.0: AER: enabled with IRQ 24
[    3.886088] pcieport 0002:00:00.0: Link attempted to 5000000.iommu 
0x54
[    3.893179] pcieport 0002:00:00.0: Link done to 5000000.iommu 0x54 2
[    3.906783] pcieport 0002:00:00.0: Adding to iommu group 12
[    3.912801] hub 3-1:1.0: USB hub found
[    3.916741] hub 3-1:1.0: 7 ports detected
[    3.919978] mmc1: new HS400 MMC card at address 0001
[    3.927272] pcieport 0002:00:00.0: AER: enabled with IRQ 26
[    3.933474] fsl-qdma 8380000.dma-controller: Link attempted to 
5000000.iommu 0x54
[    3.934112] mmc0: new ultra high speed SDR104 SDHC card at address 
1234
[    3.941585] mmcblk1: mmc1:0001 S0J58X 29.6 GiB
[    3.952953] mmcblk1boot0: mmc1:0001 S0J58X partition 1 31.5 MiB
[    3.959002] fsl-qdma 8380000.dma-controller: Link done to 
5000000.iommu 0x44 2
[    3.966795] mmcblk1boot1: mmc1:0001 S0J58X partition 2 31.5 MiB
[    3.972932] fsl-qdma 8380000.dma-controller: Adding to iommu group 13
[    3.973598] mmcblk0: mmc0:1234 SA16G 14.4 GiB
[    3.979481] random: fast init done
[    3.988099] mmcblk1rpmb: mmc1:0001 S0J58X partition 3 4.00 MiB, 
chardev (245:0)
[    3.988305]  mmcblk0: p1
[    4.004567] asoc-simple-card sound: wm8904-hifi <-> 
f150000.audio-controller mapping ok
[    4.014814] asoc-simple-card sound: wm8904-hifi <-> 
f140000.audio-controller mapping ok
[    4.023068] asoc-simple-card sound: ASoC: no DMI vendor name!
[    4.032087] irq: no irq domain found for sl28cpld@4a !
[    4.037338] irq: no irq domain found for sl28cpld@4a !
[    4.043211] gpio-keys buttons0: Found button without gpio or irq
[    4.046555]  mmcblk1: p1 p2
[    4.049385] gpio-keys: probe of buttons0 failed with error -22
[    4.058454] ALSA device list:
[    4.061488]   #0: f150000.audio-controller-wm8904-hifi
[    4.069127] EXT4-fs (mmcblk1p2): INFO: recovery required on readonly 
filesystem
[    4.076546] EXT4-fs (mmcblk1p2): write access will be enabled during 
recovery
[    4.102210] EXT4-fs (mmcblk1p2): recovery complete
[    4.109352] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data 
mode. Opts: (null)
[    4.117633] VFS: Mounted root (ext4 filesystem) readonly on device 
179:2.
[    4.125103] devtmpfs: mounted
[    4.138944] Freeing unused kernel memory: 3200K
[    4.143799] Run /sbin/init as init process
[    4.147960]   with arguments:
[    4.150952]     /sbin/init
[    4.153704]   with environment:
[    4.156896]     HOME=/
[    4.159301]     TERM=linux
[    4.212348] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[    4.283183] usb 3-1.6: new full-speed USB device number 3 using 
xhci-hcd
[    4.384124] udevd[129]: starting version 3.2.8
[    4.390756] random: udevd: uninitialized urandom read (16 bytes read)
[    4.398980] random: udevd: uninitialized urandom read (16 bytes read)
[    4.405785] random: udevd: uninitialized urandom read (16 bytes read)
[    4.417352] udevd[129]: specified group 'kvm' unknown
[    4.445095] udevd[130]: starting eudev-3.2.8
[    6.703591] fsl_enetc 0000:00:00.0 gbe0: renamed from eth0
[    9.457917] urandom_read: 3 callbacks suppressed
[    9.457930] random: dd: uninitialized urandom read (512 bytes read)
[    9.620244] Qualcomm Atheros AR8031/AR8033 0000:00:00.0:05: attached 
PHY driver [Qualcomm Atheros AR8031/AR8033] 
(mii_bus:phy_addr=0000:00:00.0:05, irq=POLL)
[    9.652363] fsl_enetc 0000:00:00.0 gbe0: Link is Down
[    9.713371] random: dropbear: uninitialized urandom read (32 bytes 
read)
[   15.811646] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 1Gbps/Full - 
flow control off
[   15.819447] IPv6: ADDRCONF(NETDEV_CHANGE): gbe0: link becomes ready
[  160.707260] random: crng init done

-michael
