Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9DC4C999C
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 01:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiCBACT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 19:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiCBACT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 19:02:19 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A24308EB46;
        Tue,  1 Mar 2022 16:01:33 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id BE80592009C; Wed,  2 Mar 2022 01:01:32 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id B728192009B;
        Wed,  2 Mar 2022 00:01:32 +0000 (GMT)
Date:   Wed, 2 Mar 2022 00:01:32 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <helgaas@kernel.org>
cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] PCI: Sanitise firmware BAR assignments behind
 a PCI-PCI bridge
In-Reply-To: <20220301231547.GA663097@bhelgaas>
Message-ID: <alpine.DEB.2.21.2203012338460.46819@angie.orcam.me.uk>
References: <20220301231547.GA663097@bhelgaas>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Mar 2022, Bjorn Helgaas wrote:

> > Fix an issue with the Tyan Tomcat IV S1564D system, the BIOS of which 
> > does not assign PCI buses beyond #2, where our resource reallocation 
> > code preserves the reset default of an I/O BAR assignment outside its 
> > upstream PCI-to-PCI bridge's I/O forwarding range for device 06:08.0 in 
> > this log:
> 
> Would you mind collecting the complete dmesg log before your patch?
> It's hard to get the entire picture from snippets.

 Sure, here's the original log from at the time when I made the patch.  I 
think it's as verbose as you can get; there's no way I could have used it 
for the change description.

 Also I doubt it should matter, but if you need a fresh log instead from 
5.17, then I can make one too, but that will take a bit.  Let me know if 
you need me to try anything else too.

 Thanks,

  Maciej

LILO 22.8 boot: bisect
Loading bisect...........................................................
BIOS data check successful
Linux version 5.13.0-rc6-00229-g15279ebe99d7-dirty (macro@angie) (i386-linux-gnu-gcc (GCC) 11.0.0 20200919 (experimental), GNU ld (GNU Binutils) 2.35.50.20201006) #21 SMP Tue Jul 6 14:36:41 CEST 2021
KERNEL supported cpus:
  Intel GenuineIntel
x86/fpu: x87 FPU will use FSAVE
BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ffff0000-0x00000000ffffffff] reserved
Notice: NX (Execute Disable) protection missing in CPU!
Legacy DMI 2.0 present.
DMI: Tyan Computer Corp i430HX, BIOS 4.51 PG 05/13/98
tsc: Fast TSC calibration using PIT
tsc: Detected 232.671 MHz processor
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
last_pfn = 0x20000 max_arch_pfn = 0x100000
x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC  
found SMP MP-table at [mem 0x000f5db0-0x000f5dbf]
initial memory mapped: [mem 0x00000000-0x00bfffff]
512MB LOWMEM available.
  mapped low ram: 0 - 20000000
  low ram: 0 - 20000000
Zone ranges:
  DMA      [mem 0x0000000000001000-0x0000000000ffffff]
  Normal   [mem 0x0000000001000000-0x000000001fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000000001000-0x000000000009efff]
  node   0: [mem 0x0000000000100000-0x000000001fffffff]
Initmem setup node 0 [mem 0x0000000000001000-0x000000001fffffff]
On node 0 totalpages: 130974
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3998 pages, LIFO batch:0
  Normal zone: 992 pages used for memmap
  Normal zone: 126976 pages, LIFO batch:31
Using APIC driver default
Intel MultiProcessor Specification v1.1
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
BIOS bug: APIC version mismatch, boot CPU: 10, CPU 0: version 11
Processor #1
BIOS bug: APIC version mismatch, boot CPU: 10, CPU 1: version 11
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Processors: 2
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[mem 0x20000000-0xfebfffff] available for PCI devices
clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
percpu: Embedded 27 pages/cpu s88300 r0 d22292 u110592
pcpu-alloc: s88300 r0 d22292 u110592 alloc=27*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists, mobility grouping on.  Total pages: 129950
Kernel command line: BOOT_IMAGE=bisect ro root=802 console=tty0 console=ttyS0,9600n8 parport=0x378,7 mce noapic debug panic=60 emergency pci=assign-busses,realloc
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes, linear)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes, linear)
mem auto-init: stack:off, heap alloc:off, heap free:off
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Memory: 510624K/523896K available (5346K kernel code, 578K rwdata, 1208K rodata, 424K init, 272K bss, 13272K reserved, 0K cma-reserved)
rcu: Hierarchical RCU implementation.
	Tracing variant of Tasks RCU enabled.
rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
NR_IRQS: 2304, nr_irqs: 56, preallocated irqs: 16
Console: colour VGA+ 80x25
printk: console [tty0] enabled
printk: console [ttyS0] enabled
APIC: Switch to symmetric I/O mode setup
Enabling APIC mode:  Flat.  Using 1 I/O APICs
clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x6b52767c30, max_idle_ns: 881590452765 ns
Calibrating delay loop (skipped), value calculated using timer frequency.. 465.34 BogoMIPS (lpj=2326710)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
Intel Pentium with F0 0F bug - workaround enabled.
mce: Intel old style machine check architecture supported.
mce: Intel old style machine check reporting enabled on CPU#0.
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
Freeing SMP alternatives memory: 24K
smpboot: CPU0: Intel Pentium MMX (family: 0x5, model: 0x4, stepping: 0x3)
Performance Events: no PMU driver, software events only.
rcu: Hierarchical SRCU implementation.
smp: Bringing up secondary CPUs ...
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
mce: Intel old style machine check architecture supported.
mce: Intel old style machine check reporting enabled on CPU#1.
[Firmware Bug]: CPU1: APIC id mismatch. Firmware: 1 APIC: 0
smp: Brought up 1 node, 2 CPUs
smpboot: Max logical packages: 2
smpboot: Total of 2 processors activated (930.79 BogoMIPS)
random: get_random_u32 called from bucket_table_alloc.isra.0+0x5b/0x130 with crng_init=0
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
futex hash table entries: 512 (order: 2, 16384 bytes, linear)
NET: Registered protocol family 16
PCI: Using configuration type 1 for base access
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI: Probing PCI hardware
PCI: root bus 00: using default resources
PCI: Probing PCI hardware (bus 00)
PCI host bridge to bus 0000:00
clocksource: timekeeping watchdog on CPU0: Marking clocksource 'tsc-early' as unstable because the skew is too large:
clocksource:                       'refined-jiffies' wd_now: ffff8b39 wd_last: ffff8b07 mask: ffffffff
clocksource:                       'tsc-early' cs_now: 50fdc058d cs_last: 4ff05ffb9 mask: ffffffffffffffff
tsc: Marking TSC unstable due to clocksource watchdog
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
pci_bus 0000:00: scanning bus
pci 0000:00:00.0: [8086:1250] type 00 class 0x060000
pci 0000:00:07.0: [8086:7000] type 00 class 0x060100
pci 0000:00:07.1: [8086:7010] type 00 class 0x010180
pci 0000:00:07.1: reg 0x20: [io  0xf000-0xf00f]
pci 0000:00:07.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
pci 0000:00:07.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
pci 0000:00:07.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
pci 0000:00:07.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
pci 0000:00:07.2: [8086:7020] type 00 class 0x0c0300
pci 0000:00:07.2: reg 0x20: [io  0x6000-0x601f]
pci 0000:00:11.0: [12d8:e111] type 01 class 0x060400
pci 0000:00:11.0: enabling Extended Tags
pci 0000:00:11.0: Enable PCIe Retrain Link quirk
pci 0000:00:12.0: [1011:000f] type 00 class 0x020200
pci 0000:00:12.0: reg 0x10: [mem 0xe0010000-0xe001007f]
pci 0000:00:12.0: reg 0x14: [io  0x6400-0x647f]
pci 0000:00:12.0: reg 0x18: [mem 0xe0000000-0xe000ffff]
pci 0000:00:13.0: [104b:1040] type 00 class 0x010000
pci 0000:00:13.0: reg 0x10: [io  0x6800-0x6803]
pci 0000:00:13.0: reg 0x14: [mem 0xe0011000-0xe0011fff]
pci 0000:00:13.0: reg 0x30: [mem 0x00000000-0x00007fff pref]
pci 0000:00:14.0: [10b7:9200] type 00 class 0x020000
pci 0000:00:14.0: reg 0x10: [io  0x6c00-0x6c7f]
pci 0000:00:14.0: reg 0x14: [mem 0xe0012000-0xe001207f]
pci 0000:00:14.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
pci 0000:00:14.0: supports D1 D2
pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:14.0: PME# disabled
pci_bus 0000:00: fixups for bus
pci 0000:00:11.0: scanning [bus 01-01] behind bridge, pass 0
pci 0000:00:11.0: scanning [bus 00-00] behind bridge, pass 1
pci_bus 0000:01: extended config space not accessible
pci_bus 0000:01: scanning bus
pci 0000:01:00.0: [104c:8232] type 01 class 0x060400
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci_bus 0000:01: fixups for bus
pci 0000:00:11.0: PCI bridge to [bus 01-ff]
pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
pci 0000:01:00.0: scanning [bus 00-00] behind bridge, pass 0
pci 0000:01:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
pci 0000:01:00.0: scanning [bus 00-00] behind bridge, pass 1
pci_bus 0000:02: extended config space not accessible
pci_bus 0000:02: scanning bus
pci 0000:02:00.0: [104c:8233] type 01 class 0x060400
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:01.0: [104c:8233] type 01 class 0x060400
pci 0000:02:01.0: supports D1 D2
pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:02:02.0: [104c:8233] type 01 class 0x060400
pci 0000:02:02.0: supports D1 D2
pci 0000:02:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:02.0: PME# disabled
pci_bus 0000:02: fixups for bus
pci 0000:01:00.0: PCI bridge to [bus 02-ff]
pci 0000:01:00.0:   bridge window [io  0x0000-0x0fff]
pci 0000:01:00.0:   bridge window [mem 0x00000000-0x000fffff]
pci 0000:01:00.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
pci 0000:02:00.0: scanning [bus 00-00] behind bridge, pass 0
pci 0000:02:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
pci 0000:02:01.0: scanning [bus 00-00] behind bridge, pass 0
pci 0000:02:01.0: bridge configuration invalid ([bus 00-00]), reconfiguring
pci 0000:02:02.0: scanning [bus 00-00] behind bridge, pass 0
pci 0000:02:02.0: bridge configuration invalid ([bus 00-00]), reconfiguring
pci 0000:02:00.0: scanning [bus 00-00] behind bridge, pass 1
pci_bus 0000:03: extended config space not accessible
pci_bus 0000:03: scanning bus
pci_bus 0000:03: fixups for bus
pci 0000:02:00.0: PCI bridge to [bus 03-ff]
pci 0000:02:00.0:   bridge window [io  0x0000-0x0fff]
pci 0000:02:00.0:   bridge window [mem 0x00000000-0x000fffff]
pci 0000:02:00.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
pci_bus 0000:03: bus scan returning with max=03
pci_bus 0000:03: busn_res: [bus 03-ff] end is updated to 03
pci 0000:02:01.0: scanning [bus 00-00] behind bridge, pass 1
pci_bus 0000:04: extended config space not accessible
pci_bus 0000:04: scanning bus
pci 0000:04:00.0: [1415:c118] type 00 class 0x070102
pci 0000:04:00.0: reg 0x10: [io  0x0000-0x0007]
pci 0000:04:00.0: reg 0x14: [io  0x0000-0x0003]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.3: [1415:c11b] type 00 class 0x070002
pci 0000:04:00.3: reg 0x10: [mem 0x00000000-0x00003fff]
pci 0000:04:00.3: reg 0x14: [mem 0x00000000-0x001fffff]
pci 0000:04:00.3: reg 0x18: [mem 0x00000000-0x001fffff]
pci 0000:04:00.3: supports D1 D2
pci 0000:04:00.3: PME# supported from D1 D2 D3hot D3cold
pci 0000:04:00.3: PME# disabled
pci_bus 0000:04: fixups for bus
pci 0000:02:01.0: PCI bridge to [bus 04-ff]
pci 0000:02:01.0:   bridge window [io  0x0000-0x0fff]
pci 0000:02:01.0:   bridge window [mem 0x00000000-0x000fffff]
pci 0000:02:01.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
pci_bus 0000:04: bus scan returning with max=04
pci_bus 0000:04: busn_res: [bus 04-ff] end is updated to 04
pci 0000:02:02.0: scanning [bus 00-00] behind bridge, pass 1
pci_bus 0000:05: extended config space not accessible
pci_bus 0000:05: scanning bus
pci 0000:05:00.0: [104c:8231] type 01 class 0x060400
pci 0000:05:00.0: supports D1 D2
pci_bus 0000:05: fixups for bus
pci 0000:02:02.0: PCI bridge to [bus 05-ff]
pci 0000:02:02.0:   bridge window [io  0x0000-0x0fff]
pci 0000:02:02.0:   bridge window [mem 0x00000000-0x000fffff]
pci 0000:02:02.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
pci 0000:05:00.0: scanning [bus 00-00] behind bridge, pass 0
pci 0000:05:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
pci 0000:05:00.0: scanning [bus 00-00] behind bridge, pass 1
pci_bus 0000:06: extended config space not accessible
pci_bus 0000:06: scanning bus
pci 0000:06:05.0: [111a:0002] type 00 class 0x020300
pci 0000:06:05.0: reg 0x10: [mem 0x00000000-0x003fffff]
pci 0000:06:05.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
pci 0000:06:08.0: [1106:3038] type 00 class 0x0c0300
pci 0000:06:08.0: reg 0x20: [io  0xfce0-0xfcff]
pci 0000:06:08.0: supports D1 D2
pci 0000:06:08.0: PME# supported from D0 D1 D2 D3hot
pci 0000:06:08.0: PME# disabled
pci 0000:06:08.1: [1106:3038] type 00 class 0x0c0300
pci 0000:06:08.1: reg 0x20: [io  0xfce0-0xfcff]
pci 0000:06:08.1: supports D1 D2
pci 0000:06:08.1: PME# supported from D0 D1 D2 D3hot
pci 0000:06:08.1: PME# disabled
pci 0000:06:08.2: [1106:3104] type 00 class 0x0c0320
pci 0000:06:08.2: reg 0x10: [mem 0x00000000-0x000000ff]
pci 0000:06:08.2: supports D1 D2
pci 0000:06:08.2: PME# supported from D0 D1 D2 D3hot
pci 0000:06:08.2: PME# disabled
pci_bus 0000:06: fixups for bus
pci 0000:05:00.0: PCI bridge to [bus 06-ff]
pci 0000:05:00.0:   bridge window [io  0x0000-0x0fff]
pci 0000:05:00.0:   bridge window [mem 0x00000000-0x000fffff]
pci 0000:05:00.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
pci_bus 0000:06: bus scan returning with max=06
pci_bus 0000:06: busn_res: [bus 06-ff] end is updated to 06
pci_bus 0000:05: bus scan returning with max=06
pci_bus 0000:05: busn_res: [bus 05-ff] end is updated to 06
pci_bus 0000:02: bus scan returning with max=06
pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 06
pci_bus 0000:01: bus scan returning with max=06
pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 06
pci_bus 0000:00: bus scan returning with max=06
pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 06
PCI: IRQ init
PCI: Interrupt Routing Table found at 0xfde10
00:14.0 slot=01
 0:60/deb8
 1:61/deb8
 2:62/deb8
 3:63/deb8

00:13.0 slot=02
 0:61/deb8
 1:62/deb8
 2:63/deb8
 3:60/deb8

00:12.0 slot=03
 0:62/deb8
 1:63/deb8
 2:60/deb8
 3:61/deb8

00:11.0 slot=04
 0:63/deb8
 1:60/deb8
 2:61/deb8
 3:62/deb8

00:07.1 slot=00
 0:00/deb8
 1:00/deb8
 2:00/deb8
 3:00/deb8

00:07.2 slot=00
 0:00/deb8
 1:00/deb8
 2:00/deb8
 3:63/deb8

PCI: Attempting to find IRQ router for [8086:7000]
PCI: Trying IRQ router for [8086:7000]
pci 0000:00:07.0: SIO/PIIX/ICH IRQ router [8086:7000]
PCI: IRQ fixup
pci 0000:02:00.0: ignoring bogus IRQ 255
pci 0000:02:01.0: ignoring bogus IRQ 255
pci 0000:02:02.0: ignoring bogus IRQ 255
pci 0000:04:00.0: ignoring bogus IRQ 255
pci 0000:04:00.3: ignoring bogus IRQ 255
pci 0000:00:11.0: PCI INT A -> PIRQ 63, mask deb8, excl 0c20
pci 0000:00:11.0: PCI INT A -> newirq 0
PCI: setting IRQ 11 as level-triggered
pci 0000:00:11.0: found PCI INT A -> IRQ 11
pci 0000:00:11.0: sharing IRQ 11 with 0000:00:07.2
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:11.0: sharing IRQ 11 with 0000:02:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:11.0: sharing IRQ 11 with 0000:04:00.3
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:11.0: sharing IRQ 11 with 0000:06:08.2
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:02:01.0: PCI INT A -> PIRQ 60, mask deb8, excl 0c20
pci 0000:02:01.0: PCI INT A -> newirq 0
PCI: setting IRQ 10 as level-triggered
pci 0000:02:01.0: found PCI INT A -> IRQ 10
pci 0000:02:01.0: sharing IRQ 10 with 0000:00:14.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:02:01.0: sharing IRQ 10 with 0000:04:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:02:02.0: PCI INT A -> PIRQ 61, mask deb8, excl 0c20
pci 0000:02:02.0: PCI INT A -> newirq 0
PCI: setting IRQ 5 as level-triggered
pci 0000:02:02.0: found PCI INT A -> IRQ 5
pci 0000:02:02.0: sharing IRQ 5 with 0000:00:13.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:02:02.0: sharing IRQ 5 with 0000:06:08.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:06:05.0: PCI INT A -> PIRQ 62, mask deb8, excl 0c20
pci 0000:06:05.0: PCI INT A -> newirq 0
pci 0000:06:05.0: found PCI INT A -> IRQ 5
pci 0000:06:05.0: sharing IRQ 5 with 0000:00:12.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:06:05.0: sharing IRQ 5 with 0000:06:08.1
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
PCI: pci_cache_line_size set to 32 bytes
PCI: Allocating resources
pci 0000:00:07.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
pci 0000:00:07.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
pci 0000:00:07.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
pci 0000:00:07.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
pci 0000:00:07.1: BAR 4: reserving [io  0xf000-0xf00f flags 0x40101] (d=0, p=0)
pci 0000:00:07.2: BAR 4: reserving [io  0x6000-0x601f flags 0x40101] (d=0, p=0)
pci 0000:00:12.0: BAR 0: reserving [mem 0xe0010000-0xe001007f flags 0x40200] (d=0, p=0)
pci 0000:00:12.0: BAR 1: reserving [io  0x6400-0x647f flags 0x40101] (d=0, p=0)
pci 0000:00:12.0: BAR 2: reserving [mem 0xe0000000-0xe000ffff flags 0x40200] (d=0, p=0)
pci 0000:00:13.0: BAR 0: reserving [io  0x6800-0x6803 flags 0x40101] (d=0, p=0)
pci 0000:00:13.0: BAR 1: reserving [mem 0xe0011000-0xe0011fff flags 0x40200] (d=0, p=0)
pci 0000:00:14.0: BAR 0: reserving [io  0x6c00-0x6c7f flags 0x40101] (d=0, p=0)
pci 0000:00:14.0: BAR 1: reserving [mem 0xe0012000-0xe001207f flags 0x40200] (d=0, p=0)
pci 0000:06:08.0: BAR 4: reserving [io  0xfce0-0xfcff flags 0x40101] (d=1, p=1)
pci 0000:06:08.0: can't claim BAR 4 [io  0xfce0-0xfcff]: no compatible bridge window
pci 0000:06:08.1: BAR 4: reserving [io  0xfce0-0xfcff flags 0x40101] (d=1, p=1)
pci 0000:06:08.1: can't claim BAR 4 [io  0xfce0-0xfcff]: no compatible bridge window
e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
clocksource: Switched to clocksource refined-jiffies
NET: Registered protocol family 2
IP idents hash table entries: 8192 (order: 4, 65536 bytes, linear)
tcp_listen_portaddr_hash hash table entries: 512 (order: 0, 6144 bytes, linear)
TCP established hash table entries: 4096 (order: 2, 16384 bytes, linear)
TCP bind hash table entries: 4096 (order: 3, 32768 bytes, linear)
TCP: Hash tables configured (established 4096 bind 4096)
UDP hash table entries: 256 (order: 1, 8192 bytes, linear)
UDP-Lite hash table entries: 256 (order: 1, 8192 bytes, linear)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci_bus 0000:00: max bus depth: 4 pci_try_num: 5
pci 0000:00:14.0: BAR 6: assigned [mem 0x20000000-0x2001ffff pref]
pci 0000:00:13.0: BAR 6: assigned [mem 0x20020000-0x20027fff pref]
pci 0000:01:00.0: BAR 8: assigned [mem 0xd8000000-0xd8bfffff]
pci 0000:01:00.0: BAR 7: no space for [io  size 0x2000]
pci 0000:01:00.0: BAR 7: failed to assign [io  size 0x2000]
pci 0000:02:02.0: BAR 8: assigned [mem 0xd8000000-0xd85fffff]
pci 0000:02:01.0: BAR 8: assigned [mem 0xd8600000-0xd8afffff]
pci 0000:02:01.0: BAR 7: no space for [io  size 0x1000]
pci 0000:02:01.0: BAR 7: failed to assign [io  size 0x1000]
pci 0000:02:02.0: BAR 7: no space for [io  size 0x1000]
pci 0000:02:02.0: BAR 7: failed to assign [io  size 0x1000]
pci 0000:02:00.0: PCI bridge to [bus 03]
pci 0000:04:00.3: BAR 1: assigned [mem 0xd8600000-0xd87fffff]
pci 0000:04:00.3: BAR 2: assigned [mem 0xd8800000-0xd89fffff]
pci 0000:04:00.3: BAR 0: assigned [mem 0xd8a00000-0xd8a03fff]
pci 0000:04:00.0: BAR 0: no space for [io  size 0x0008]
pci 0000:04:00.0: BAR 0: failed to assign [io  size 0x0008]
pci 0000:04:00.0: BAR 1: no space for [io  size 0x0004]
pci 0000:04:00.0: BAR 1: failed to assign [io  size 0x0004]
pci 0000:02:01.0: PCI bridge to [bus 04]
pci 0000:02:01.0:   bridge window [mem 0xd8600000-0xd8afffff]
pci 0000:05:00.0: BAR 8: assigned [mem 0xd8000000-0xd85fffff]
pci 0000:05:00.0: BAR 7: no space for [io  size 0x1000]
pci 0000:05:00.0: BAR 7: failed to assign [io  size 0x1000]
pci 0000:06:05.0: BAR 0: assigned [mem 0xd8000000-0xd83fffff]
pci 0000:06:05.0: BAR 6: assigned [mem 0xd8400000-0xd841ffff pref]
pci 0000:06:08.2: BAR 0: assigned [mem 0xd8420000-0xd84200ff]
pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.0: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
pci 0000:06:08.0: BAR 4: assigned [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.1: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff] conflicts with 0000:06:08.0 [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: failed to assign [io  size 0x0020]
pci 0000:05:00.0: PCI bridge to [bus 06]
pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
pci 0000:02:02.0: PCI bridge to [bus 05-06]
pci 0000:02:02.0:   bridge window [mem 0xd8000000-0xd85fffff]
pci 0000:01:00.0: PCI bridge to [bus 02-06]
pci 0000:01:00.0:   bridge window [mem 0xd8000000-0xd8bfffff]
pci 0000:00:11.0: PCI bridge to [bus 01-06]
pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:00: No. 2 try to assign unassigned res
pci 0000:01:00.0: BAR 7: no space for [io  size 0x2000]
pci 0000:01:00.0: BAR 7: failed to assign [io  size 0x2000]
pci 0000:02:01.0: BAR 7: no space for [io  size 0x1000]
pci 0000:02:01.0: BAR 7: failed to assign [io  size 0x1000]
pci 0000:02:02.0: BAR 7: no space for [io  size 0x1000]
pci 0000:02:02.0: BAR 7: failed to assign [io  size 0x1000]
pci 0000:02:00.0: PCI bridge to [bus 03]
pci 0000:04:00.0: BAR 0: no space for [io  size 0x0008]
pci 0000:04:00.0: BAR 0: failed to assign [io  size 0x0008]
pci 0000:04:00.0: BAR 1: no space for [io  size 0x0004]
pci 0000:04:00.0: BAR 1: failed to assign [io  size 0x0004]
pci 0000:02:01.0: PCI bridge to [bus 04]
pci 0000:02:01.0:   bridge window [mem 0xd8600000-0xd8afffff]
pci 0000:05:00.0: BAR 7: no space for [io  size 0x1000]
pci 0000:05:00.0: BAR 7: failed to assign [io  size 0x1000]
pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.1: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff] conflicts with 0000:06:08.0 [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: failed to assign [io  size 0x0020]
pci 0000:05:00.0: PCI bridge to [bus 06]
pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
pci 0000:02:02.0: PCI bridge to [bus 05-06]
pci 0000:02:02.0:   bridge window [mem 0xd8000000-0xd85fffff]
pci 0000:01:00.0: PCI bridge to [bus 02-06]
pci 0000:01:00.0:   bridge window [mem 0xd8000000-0xd8bfffff]
pci 0000:00:11.0: PCI bridge to [bus 01-06]
pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:00: No. 3 try to assign unassigned res
pci 0000:00:11.0: resource 7 [io  0xe000-0xefff] released
pci 0000:00:11.0: PCI bridge to [bus 01-06]
pci 0000:00:11.0: BAR 7: assigned [io  0x1000-0x2fff]
pci 0000:01:00.0: BAR 7: assigned [io  0x1000-0x2fff]
pci 0000:02:01.0: BAR 7: assigned [io  0x1000-0x1fff]
pci 0000:02:02.0: BAR 7: assigned [io  0x2000-0x2fff]
pci 0000:02:00.0: PCI bridge to [bus 03]
pci 0000:04:00.0: BAR 0: assigned [io  0x1000-0x1007]
pci 0000:04:00.0: BAR 1: assigned [io  0x1008-0x100b]
pci 0000:02:01.0: PCI bridge to [bus 04]
pci 0000:02:01.0:   bridge window [io  0x1000-0x1fff]
pci 0000:02:01.0:   bridge window [mem 0xd8600000-0xd8afffff]
pci 0000:05:00.0: BAR 7: assigned [io  0x2000-0x2fff]
pci 0000:06:08.1: BAR 4: assigned [io  0x2000-0x201f]
pci 0000:05:00.0: PCI bridge to [bus 06]
pci 0000:05:00.0:   bridge window [io  0x2000-0x2fff]
pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
pci 0000:02:02.0: PCI bridge to [bus 05-06]
pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
pci 0000:02:02.0:   bridge window [mem 0xd8000000-0xd85fffff]
pci 0000:01:00.0: PCI bridge to [bus 02-06]
pci 0000:01:00.0:   bridge window [io  0x1000-0x2fff]
pci 0000:01:00.0:   bridge window [mem 0xd8000000-0xd8bfffff]
pci 0000:00:11.0: PCI bridge to [bus 01-06]
pci 0000:00:11.0:   bridge window [io  0x1000-0x2fff]
pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0xd8000000-0xdfffffff]
pci_bus 0000:01: resource 2 [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x1000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xd8000000-0xd8bfffff]
pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:04: resource 1 [mem 0xd8600000-0xd8afffff]
pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:05: resource 1 [mem 0xd8000000-0xd85fffff]
pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:06: resource 1 [mem 0xd8000000-0xd85fffff]
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:07.0: Activating ISA DMA hang workarounds
pci 0000:00:07.2: PCI INT D -> PIRQ 63, mask deb8, excl 0c20
pci 0000:00:07.2: PCI INT D -> newirq 11
pci 0000:00:07.2: found PCI INT D -> IRQ 11
pci 0000:00:07.2: sharing IRQ 11 with 0000:00:11.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:07.2: sharing IRQ 11 with 0000:02:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:07.2: sharing IRQ 11 with 0000:04:00.3
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:07.2: sharing IRQ 11 with 0000:06:08.2
pci 0000:00:07.2: quirk_usb_early_handoff+0x0/0x6c0 took 156250 usecs
pci 0000:05:00.0: TI XIO2000a quirk detected; secondary bus fast back-to-back transfers disabled
pci 0000:00:11.0: PCI INT A -> PIRQ 63, mask deb8, excl 0c20
pci 0000:00:11.0: PCI INT A -> newirq 11
pci 0000:00:11.0: found PCI INT A -> IRQ 11
pci 0000:00:11.0: sharing IRQ 11 with 0000:00:07.2
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:11.0: sharing IRQ 11 with 0000:02:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:11.0: sharing IRQ 11 with 0000:04:00.3
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:00:11.0: sharing IRQ 11 with 0000:06:08.2
pci 0000:01:00.0: enabling device (0000 -> 0003)
pci 0000:01:00.0: enabling bus mastering
pci 0000:02:02.0: enabling device (0000 -> 0003)
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:02:02.0: PCI INT A -> PIRQ 61, mask deb8, excl 0c20
pci 0000:02:02.0: PCI INT A -> newirq 5
pci 0000:02:02.0: found PCI INT A -> IRQ 5
pci 0000:02:02.0: sharing IRQ 5 with 0000:00:13.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:02:02.0: sharing IRQ 5 with 0000:06:08.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:02:02.0: enabling bus mastering
pci 0000:05:00.0: enabling device (0000 -> 0003)
pci 0000:05:00.0: enabling bus mastering
pci 0000:06:08.0: enabling device (0000 -> 0001)
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:06:08.0: PCI INT A -> PIRQ 61, mask deb8, excl 0c20
pci 0000:06:08.0: PCI INT A -> newirq 5
pci 0000:06:08.0: found PCI INT A -> IRQ 5
pci 0000:06:08.0: sharing IRQ 5 with 0000:00:13.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:06:08.0: sharing IRQ 5 with 0000:02:02.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:06:08.0: HCRESET not completed yet!
pci 0000:06:08.0: quirk_usb_early_handoff+0x0/0x6c0 took 537109 usecs
pci 0000:06:08.1: enabling device (0000 -> 0001)
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:06:08.1: PCI INT B -> PIRQ 62, mask deb8, excl 0c20
pci 0000:06:08.1: PCI INT B -> newirq 5
pci 0000:06:08.1: found PCI INT B -> IRQ 5
pci 0000:06:08.1: sharing IRQ 5 with 0000:00:12.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:06:08.1: sharing IRQ 5 with 0000:06:05.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:06:08.1: quirk_usb_early_handoff+0x0/0x6c0 took 156250 usecs
pci 0000:06:08.2: enabling device (0000 -> 0002)
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:06:08.2: PCI INT C -> PIRQ 63, mask deb8, excl 0c20
pci 0000:06:08.2: PCI INT C -> newirq 11
pci 0000:06:08.2: found PCI INT C -> IRQ 11
pci 0000:06:08.2: sharing IRQ 11 with 0000:00:07.2
pci 0000:06:08.2: sharing IRQ 11 with 0000:00:11.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:06:08.2: sharing IRQ 11 with 0000:02:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:06:08.2: sharing IRQ 11 with 0000:04:00.3
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:06:08.2: quirk_usb_early_handoff+0x0/0x6c0 took 175781 usecs
PCI: CLS 32 bytes, default 32
platform rtc_cmos: registered platform RTC device (no PNP device found)
workingset: timestamp_bits=30 max_order=17 bucket_order=0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
test_div64: Starting 64bit/32bit division and modulo test
test_div64: Completed 64bit/32bit division and modulo test, 0.070000000s elapsed
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
serial 0000:04:00.3: runtime IRQ mapping not provided by arch
pci 0000:02:01.0: enabling device (0000 -> 0003)
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:02:01.0: PCI INT A -> PIRQ 60, mask deb8, excl 0c20
pci 0000:02:01.0: PCI INT A -> newirq 10
pci 0000:02:01.0: found PCI INT A -> IRQ 10
pci 0000:02:01.0: sharing IRQ 10 with 0000:00:14.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:02:01.0: sharing IRQ 10 with 0000:04:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:02:01.0: enabling bus mastering
serial 0000:04:00.3: enabling device (0000 -> 0002)
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
serial 0000:04:00.3: PCI INT D -> PIRQ 63, mask deb8, excl 0c20
serial 0000:04:00.3: PCI INT D -> newirq 11
serial 0000:04:00.3: found PCI INT D -> IRQ 11
serial 0000:04:00.3: sharing IRQ 11 with 0000:00:07.2
serial 0000:04:00.3: sharing IRQ 11 with 0000:00:11.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
serial 0000:04:00.3: sharing IRQ 11 with 0000:02:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
serial 0000:04:00.3: sharing IRQ 11 with 0000:06:08.2
serial 0000:04:00.3: saving config space at offset 0x0 (reading 0xc11b1415)
serial 0000:04:00.3: saving config space at offset 0x4 (reading 0x100002)
serial 0000:04:00.3: saving config space at offset 0x8 (reading 0x7000200)
serial 0000:04:00.3: saving config space at offset 0xc (reading 0x800000)
serial 0000:04:00.3: saving config space at offset 0x10 (reading 0xd8a00000)
serial 0000:04:00.3: saving config space at offset 0x14 (reading 0xd8600000)
serial 0000:04:00.3: saving config space at offset 0x18 (reading 0xd8800000)
serial 0000:04:00.3: saving config space at offset 0x1c (reading 0x0)
serial 0000:04:00.3: saving config space at offset 0x20 (reading 0x0)
serial 0000:04:00.3: saving config space at offset 0x24 (reading 0x0)
serial 0000:04:00.3: saving config space at offset 0x28 (reading 0x0)
serial 0000:04:00.3: saving config space at offset 0x2c (reading 0xc11b1415)
serial 0000:04:00.3: saving config space at offset 0x30 (reading 0x0)
serial 0000:04:00.3: saving config space at offset 0x34 (reading 0x40)
serial 0000:04:00.3: saving config space at offset 0x38 (reading 0x0)
serial 0000:04:00.3: saving config space at offset 0x3c (reading 0x4ff)
serial 0000:04:00.3: detected caps 00000700 should be 00000500
0000:04:00.3: ttyS2 at MMIO 0xd8a01000 (irq = 11, base_baud = 15625000) is a 16C950/954
lp: driver loaded but no devices found
Non-volatile memory driver v1.3
ppdev: user-space parallel port driver
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
lp0: using parport0 (interrupt-driven).
Floppy drive(s): fd0 is 1.44M, fd1 is 1.2M
loop: module loaded
Uniform Multi-Platform E-IDE driver
pci 0000:00:07.1: runtime IRQ mapping not provided by arch
piix 0000:00:07.1: IDE controller (0x8086:0x7010 rev 0x00)
FDC 0 is a post-1991 82077
piix 0000:00:07.1: not 100% native mode: will probe irqs later
legacy IDE will be removed in 2021, please switch to libata
Report any missing HW support to linux-ide@vger.kernel.org
    ide0: BM-DMA at 0xf000-0xf007
    ide1: BM-DMA at 0xf008-0xf00f
Probing IDE interface ide0...
hda: Maxtor 7245 AT, ATA DISK drive
hda: is on PIO blacklist
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO1
hda: SWDMA2 mode selected
Probing IDE interface ide1...
hdc: MEMOREX CD-MAXX52, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
PIIX_IDE 0000:00:07.1: runtime IRQ mapping not provided by arch
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 479632 sectors (245 MB) w/64KiB Cache, CHS=967/16/31
 hda: hda1 hda2
ide-cd driver 5.00
ide-cd: hdc: ATAPI 52X CD-ROM drive, 128kB Cache
cdrom: Uniform CD-ROM driver Revision: 3.20
pci 0000:00:13.0: PCI INT A -> PIRQ 61, mask deb8, excl 0c20
pci 0000:00:13.0: PCI INT A -> newirq 5
pci 0000:00:13.0: found PCI INT A -> IRQ 5
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:00:13.0: sharing IRQ 5 with 0000:02:02.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:00:13.0: sharing IRQ 5 with 0000:06:08.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
scsi: ***** BusLogic SCSI Driver Version 2.1.17 of 12 September 2013 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x6800, IRQ Channel: 5/Level
scsi0:   PCI Bus: 0, Device: 19, Address: 0xE0011000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi0:   SCSI Bus Termination: Both Disabled, SCAM: Disabled
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi host0: BusLogic BT-958
scsi 0:0:0:0: Direct-Access     IBM      DDYS-T18350M     SA5A PQ: 0 ANSI: 3
scsi 0:0:1:0: Direct-Access     SEAGATE  ST336607LW       0006 PQ: 0 ANSI: 3
scsi 0:0:4:0: Sequential-Access HP       C5683A           C908 PQ: 0 ANSI: 2
scsi 0:0:5:0: Direct-Access     IOMEGA   ZIP 100          E.08 PQ: 0 ANSI: 2
st: Version 20160209, fixed bufsize 32768, s/g segs 256
st 0:0:4:0: Attached scsi tape st0
st 0:0:4:0: st0: try direct i/o: yes (alignment 4 B)
scsi 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 35843670 512-byte logical blocks: (18.4 GB/17.1 GiB)
scsi 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:0:0:0: [sda] Write Protect is off
st 0:0:4:0: Attached scsi generic sg2 type 1
sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
scsi 0:0:5:0: Attached scsi generic sg3 type 0
sd 0:0:1:0: [sdb] 71687372 512-byte logical blocks: (36.7 GB/34.2 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
3c59x 0000:00:14.0: runtime IRQ mapping not provided by arch
sd 0:0:1:0: [sdb] Mode Sense: ab 00 10 08
3c59x 0000:00:14.0: PCI INT A -> PIRQ 60, mask deb8, excl 0c20
sd 0:0:5:0: [sdc] Attached SCSI removable disk
3c59x 0000:00:14.0: PCI INT A -> newirq 10
3c59x 0000:00:14.0: found PCI INT A -> IRQ 10
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
3c59x 0000:00:14.0: sharing IRQ 10 with 0000:02:01.0
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
 sdb: sdb1 sdb2
3c59x 0000:00:14.0: sharing IRQ 10 with 0000:04:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
sd 0:0:1:0: [sdb] Attached SCSI disk
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
3c59x: Donald Becker and others.
sd 0:0:0:0: [sda] Attached SCSI disk
0000:00:14.0: 3Com PCI 3c905C Tornado at (ptrval).
3c59x 0000:00:14.0: saving config space at offset 0x0 (reading 0x920010b7)
3c59x 0000:00:14.0: saving config space at offset 0x4 (reading 0x2100007)
3c59x 0000:00:14.0: saving config space at offset 0x8 (reading 0x2000074)
3c59x 0000:00:14.0: saving config space at offset 0xc (reading 0x4008)
3c59x 0000:00:14.0: saving config space at offset 0x10 (reading 0x6c01)
3c59x 0000:00:14.0: saving config space at offset 0x14 (reading 0xe0012000)
3c59x 0000:00:14.0: saving config space at offset 0x18 (reading 0x0)
3c59x 0000:00:14.0: saving config space at offset 0x1c (reading 0x0)
3c59x 0000:00:14.0: saving config space at offset 0x20 (reading 0x0)
3c59x 0000:00:14.0: saving config space at offset 0x24 (reading 0x0)
3c59x 0000:00:14.0: saving config space at offset 0x28 (reading 0x0)
3c59x 0000:00:14.0: saving config space at offset 0x2c (reading 0x100010b7)
3c59x 0000:00:14.0: saving config space at offset 0x30 (reading 0x0)
3c59x 0000:00:14.0: saving config space at offset 0x34 (reading 0xdc)
3c59x 0000:00:14.0: saving config space at offset 0x38 (reading 0x0)
3c59x 0000:00:14.0: saving config space at offset 0x3c (reading 0xa0a010a)
defxx 0000:00:12.0: runtime IRQ mapping not provided by arch
defxx: v1.12 2021/03/10  Lawrence V. Stefani and others
defxx 0000:00:12.0: PCI INT A -> PIRQ 62, mask deb8, excl 0c20
defxx 0000:00:12.0: PCI INT A -> newirq 5
defxx 0000:00:12.0: found PCI INT A -> IRQ 5
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
defxx 0000:00:12.0: sharing IRQ 5 with 0000:06:05.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
defxx 0000:00:12.0: sharing IRQ 5 with 0000:06:08.1
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
0000:00:12.0: DEFPA at MMIO addr = 0xe0010000, IRQ = 5, Hardware addr = 00-00-f8-e7-82-24
0000:00:12.0: registered as fddi0
eni 0000:06:05.0: runtime IRQ mapping not provided by arch
eni 0000:06:05.0: enabling device (0000 -> 0002)
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
eni 0000:06:05.0: PCI INT A -> PIRQ 62, mask deb8, excl 0c20
eni 0000:06:05.0: PCI INT A -> newirq 5
eni 0000:06:05.0: found PCI INT A -> IRQ 5
eni 0000:06:05.0: sharing IRQ 5 with 0000:00:12.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
eni 0000:06:05.0: sharing IRQ 5 with 0000:06:08.1
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
eni(itf 0): rev.0,base=0xd8000000,irq=5,
mem=2048kB (
00
-20
-EA
-00
-7A
-04
)
eni(itf 0): ASIC,MMF
eni 0000:06:05.0: enabling bus mastering
eni(itf 0): no signal
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:06:08.2: runtime IRQ mapping not provided by arch
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
ehci-pci 0000:06:08.2: PCI INT C -> PIRQ 63, mask deb8, excl 0c20
ehci-pci 0000:06:08.2: PCI INT C -> newirq 11
ehci-pci 0000:06:08.2: found PCI INT C -> IRQ 11
ehci-pci 0000:06:08.2: sharing IRQ 11 with 0000:00:07.2
ehci-pci 0000:06:08.2: sharing IRQ 11 with 0000:00:11.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
ehci-pci 0000:06:08.2: sharing IRQ 11 with 0000:02:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
ehci-pci 0000:06:08.2: sharing IRQ 11 with 0000:04:00.3
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
ehci-pci 0000:06:08.2: enabling bus mastering
ehci-pci 0000:06:08.2: EHCI Host Controller
ehci-pci 0000:06:08.2: new USB bus registered, assigned bus number 1
ehci-pci 0000:06:08.2: enabling Mem-Wr-Inval
ehci-pci 0000:06:08.2: irq 11, io mem 0xd8420000
ehci-pci 0000:06:08.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 5.13.0-rc6-00229-g15279ebe99d7-dirty ehci_hcd
usb usb1: SerialNumber: 0000:06:08.2
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:07.2: runtime IRQ mapping not provided by arch
uhci_hcd 0000:00:07.2: PCI INT D -> PIRQ 63, mask deb8, excl 0c20
uhci_hcd 0000:00:07.2: PCI INT D -> newirq 11
uhci_hcd 0000:00:07.2: found PCI INT D -> IRQ 11
uhci_hcd 0000:00:07.2: sharing IRQ 11 with 0000:00:11.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
uhci_hcd 0000:00:07.2: sharing IRQ 11 with 0000:02:00.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
uhci_hcd 0000:00:07.2: sharing IRQ 11 with 0000:04:00.3
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
uhci_hcd 0000:00:07.2: sharing IRQ 11 with 0000:06:08.2
uhci_hcd 0000:00:07.2: enabling bus mastering
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.2: irq 11, io base 0x00006000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.13
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 5.13.0-rc6-00229-g15279ebe99d7-dirty uhci_hcd
usb usb2: SerialNumber: 0000:00:07.2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:06:08.0: runtime IRQ mapping not provided by arch
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
uhci_hcd 0000:06:08.0: PCI INT A -> PIRQ 61, mask deb8, excl 0c20
uhci_hcd 0000:06:08.0: PCI INT A -> newirq 5
uhci_hcd 0000:06:08.0: found PCI INT A -> IRQ 5
uhci_hcd 0000:06:08.0: sharing IRQ 5 with 0000:00:13.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
uhci_hcd 0000:06:08.0: sharing IRQ 5 with 0000:02:02.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
uhci_hcd 0000:06:08.0: enabling bus mastering
uhci_hcd 0000:06:08.0: UHCI Host Controller
uhci_hcd 0000:06:08.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:06:08.0: HCRESET not completed yet!
uhci_hcd 0000:06:08.0: irq 5, io base 0x0000fce0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.13
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 5.13.0-rc6-00229-g15279ebe99d7-dirty uhci_hcd
usb usb3: SerialNumber: 0000:06:08.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: config failed, hub doesn't have any ports! (err -19)
uhci_hcd 0000:06:08.1: runtime IRQ mapping not provided by arch
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
uhci_hcd 0000:06:08.1: PCI INT B -> PIRQ 62, mask deb8, excl 0c20
uhci_hcd 0000:06:08.1: PCI INT B -> newirq 5
uhci_hcd 0000:06:08.1: found PCI INT B -> IRQ 5
uhci_hcd 0000:06:08.1: sharing IRQ 5 with 0000:00:12.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT B to get INT B
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
uhci_hcd 0000:06:08.1: sharing IRQ 5 with 0000:06:05.0
pci 0000:01:00.0: using bridge 0000:00:11.0 INT C to get INT C
pci 0000:01:00.0: using bridge 0000:00:11.0 INT D to get INT D
pci 0000:01:00.0: using bridge 0000:00:11.0 INT A to get INT A
uhci_hcd 0000:06:08.1: enabling bus mastering
uhci_hcd 0000:06:08.1: UHCI Host Controller
uhci_hcd 0000:06:08.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:06:08.1: irq 5, io base 0x00002000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.13
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 5.13.0-rc6-00229-g15279ebe99d7-dirty uhci_hcd
usb usb4: SerialNumber: 0000:06:08.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver uas
usbcore: registered new interface driver usb-storage
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
NET: Registered protocol family 10
Segment Routing with IPv6
NET: Registered protocol family 17
lec:lane_module_init: lec.c: initialized
mpoa:atm_mpoa_init: mpc.c: initialized
mce: Unable to init MCE device (rc: -5)
IPI shorthand broadcast: enabled
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
EXT4-fs (sda2): mounting ext2 file system using the ext4 subsystem
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
EXT4-fs (sda2): mounted filesystem without journal. Opts: (null). Quota mode: disabled.
VFS: Mounted root (ext2 filesystem) readonly on device 8:2.
Freeing unused kernel image (initmem) memory: 424K
Write protecting kernel text and read-only data: 6556k
Run /sbin/init as init process
  with arguments:
    /sbin/init
    emergency
  with environment:
    HOME=/
    TERM=linux
    BOOT_IMAGE=bisect
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
process '/sbin/init' started with executable stack
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
random: fast init done
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
INIT: input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input2
version 2.85 booting
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
Give root password for maintenance
(or type Control-D for normal startup): uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!

Login incorrect.
Give root password for maintenance
(or type Control-D for normal startup): sysrq: HELP : loglevel(0-9) reboot(b) crash(c) terminate-all-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-tasks(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show-task-states(t) unmount(u) show-blocked-tasks(w) 

Login incorrect.
Give root password for maintenance
(or type Control-D for normal startup): sysrq: Resetting
