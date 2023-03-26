Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A96C967C
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 18:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjCZQAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 12:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjCZQAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 12:00:01 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ABA49D1;
        Sun, 26 Mar 2023 08:59:24 -0700 (PDT)
Received: from smtp102.mailbox.org (unknown [10.196.197.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Pl0xC6cNkz9sS1;
        Sun, 26 Mar 2023 17:58:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1679846335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NAILna7q4YTo+rocXjRItg7a2wy+rzulM2DgZzBRbaI=;
        b=O88XKTVWrjJeRa3fa4EDMNGFkWq8t9zqJRaauD08+fSZ9r7X8RK8loiap2bDIA4c5g14w5
        5peEET4FUMnBJc5QSBoanW/5RGWdFWzOQs/5/PyNqw9Y0NM+4PaOyEsRga6Y0fYHS9kQI+
        uvfN4uv9ekCAFvPN/69XIK3y9YSoMV+hh6BVwq3syTCK3WG+1AqVpR881NugK3arPKDJLw
        LYOgwEeBNkFRjXEhn0jsn15e7Y+Tq/NwrO62fZCgZnC2TOx/5cnY43bo6GR5KwHRysNFfo
        j0UfcI1YougYtR04xSRqSxhRRGL1rjWACZH4T9PxAJg27ppjhSjqsWkZKtihJQ==
Date:   Sun, 26 Mar 2023 17:58:51 +0200
From:   "Erhard Furtner" <erhard_f@mailbox.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, Chris Snook <chris.snook@gmail.com>,
        stable@vger.kernel.org
Subject: Re: When VIA VL805/806 xHCI USB 3.0 Controller is present Atheros
 E2400 (alx) ethernet does not work: NETDEV WATCHDOG: enp5s0 (alx): transmit
 queue 2 timed out
Message-ID: <20230326175851.6d1c7000@yea>
In-Reply-To: <d14a6e71-d7da-db8d-f901-52d6cdf1fa1d@linux.intel.com>
References: <20230319013706.016d96b2@yea>
        <d14a6e71-d7da-db8d-f901-52d6cdf1fa1d@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/qGsmkL08Pmg2IKPTTFi04pT"
X-MBO-RS-ID: 7b4212d68faecb1c8b7
X-MBO-RS-META: y69jfkpmjg58haqte9prwx8mjka3awgx
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--MP_/qGsmkL08Pmg2IKPTTFi04pT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 20 Mar 2023 11:26:39 +0200
Mathias Nyman <mathias.nyman@linux.intel.com> wrote:

> This could be related to another case with two xHC controllers, but different vendors.
> Bus numbers were interleaved there as well. Removing the asynch probe helped:
> 
> https://lore.kernel.org/linux-usb/d5ff9480-57bd-2c39-8b10-988ad0d14a7e@linux.intel.com/
> 
> Does reverting:
> 4c2604a9a689 usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS
> help for you?

Ok, reverted 4c2604a9a689 usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS now but unfortunately didn't work out. New dmesg with the reverted commit attached.

Regards,
Erhard

--MP_/qGsmkL08Pmg2IKPTTFi04pT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg_63-rc3.txt

[    0.000000] Linux version 6.3.0-rc3-bdver2-dirty (root@outsider) (clang version 15.0.7, LLD 15.0.7) #2 SMP Sun Mar 26 17:39:00 CEST 2023
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc3-bdver2-dirty root=/dev/nvme0n1p4 ro psmouse.synaptics_intertouch=1 zswap.max_pool_percent=16 zswap.zpool=z3fold slub_debug=FZP page_poison=1 netconsole=6666@10.0.0.14/eth0,6666@10.0.0.3/70:85:C2:30:EC:01
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] signal: max sigframe size: 1776
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ce1fefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ce1ff000-0x00000000ce240fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ce241000-0x00000000ce250fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ce251000-0x00000000ce640fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ce641000-0x00000000cf0f1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf0f2000-0x00000000cf155fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000cf156000-0x00000000cf156fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf157000-0x00000000cf35cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf35d000-0x00000000cf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000082effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.3.1 by American Megatrends
[    0.000000] efi: ACPI=0xce249000 ACPI 2.0=0xce249000 SMBIOS=0xf04c0 
[    0.000000] efi: Remove mem44: MMIO range=[0xf8000000-0xfbffffff] (64MB) from e820 map
[    0.000000] e820: remove [mem 0xf8000000-0xfbffffff] reserved
[    0.000000] efi: Not removing mem45: MMIO range=[0xfec00000-0xfec00fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem46: MMIO range=[0xfec10000-0xfec10fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem47: MMIO range=[0xfec20000-0xfec20fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem48: MMIO range=[0xfed00000-0xfed00fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem49: MMIO range=[0xfed61000-0xfed70fff] (64KB) from e820 map
[    0.000000] efi: Not removing mem50: MMIO range=[0xfed80000-0xfed8ffff] (64KB) from e820 map
[    0.000000] efi: Remove mem51: MMIO range=[0xfef00000-0xffffffff] (17MB) from e820 map
[    0.000000] e820: remove [mem 0xfef00000-0xffffffff] reserved
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by O.E.M./970-GAMING, BIOS F2 04/06/2016
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 4018.800 MHz processor
[    0.001013] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.001037] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.001059] last_pfn = 0x82f000 max_arch_pfn = 0x400000000
[    0.001079] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.001734] e820: update [mem 0xcf800000-0xffffffff] usable ==> reserved
[    0.001741] last_pfn = 0xcf800 max_arch_pfn = 0x400000000
[    0.001759] Using GB pages for direct mapping
[    0.002304] Secure boot disabled
[    0.002306] ACPI: Early table checksum verification disabled
[    0.002310] ACPI: RSDP 0x00000000CE249000 000024 (v02 ALASKA)
[    0.002314] ACPI: XSDT 0x00000000CE249070 00005C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.002319] ACPI: FACP 0x00000000CE24E998 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.002323] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has valid Length but zero Address: 0x0000000000000000/0x1 (20221020/tbfadt-615)
[    0.002327] ACPI: DSDT 0x00000000CE249158 005839 (v02 ALASKA A M I    00000088 INTL 20051117)
[    0.002330] ACPI: FACS 0x00000000CE63BF80 000040
[    0.002333] ACPI: APIC 0x00000000CE24EA90 00009E (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.002336] ACPI: FPDT 0x00000000CE24EB30 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.002338] ACPI: MCFG 0x00000000CE24EB78 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.002341] ACPI: HPET 0x00000000CE24EBB8 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.002344] ACPI: SSDT 0x00000000CE24EBF0 001714 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.002347] ACPI: IVRS 0x00000000CE250308 0000D8 (v01 AMD    RD890S   00202031 AMD  00000000)
[    0.002349] ACPI: Reserving FACP table memory at [mem 0xce24e998-0xce24ea8b]
[    0.002351] ACPI: Reserving DSDT table memory at [mem 0xce249158-0xce24e990]
[    0.002352] ACPI: Reserving FACS table memory at [mem 0xce63bf80-0xce63bfbf]
[    0.002353] ACPI: Reserving APIC table memory at [mem 0xce24ea90-0xce24eb2d]
[    0.002354] ACPI: Reserving FPDT table memory at [mem 0xce24eb30-0xce24eb73]
[    0.002355] ACPI: Reserving MCFG table memory at [mem 0xce24eb78-0xce24ebb3]
[    0.002356] ACPI: Reserving HPET table memory at [mem 0xce24ebb8-0xce24ebef]
[    0.002357] ACPI: Reserving SSDT table memory at [mem 0xce24ebf0-0xce250303]
[    0.002358] ACPI: Reserving IVRS table memory at [mem 0xce250308-0xce2503df]
[    0.002401] Zone ranges:
[    0.002402]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.002404]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.002406]   Normal   [mem 0x0000000100000000-0x000000082effffff]
[    0.002407] Movable zone start for each node
[    0.002408] Early memory node ranges
[    0.002408]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.002410]   node   0: [mem 0x0000000000100000-0x00000000ce1fefff]
[    0.002411]   node   0: [mem 0x00000000cf156000-0x00000000cf156fff]
[    0.002412]   node   0: [mem 0x00000000cf35d000-0x00000000cf7fffff]
[    0.002413]   node   0: [mem 0x0000000100001000-0x000000082effffff]
[    0.002417] Initmem setup node 0 [mem 0x0000000000001000-0x000000082effffff]
[    0.002423] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.002464] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.003333] On node 0, zone DMA32: 3927 pages in unavailable ranges
[    0.003333] On node 0, zone DMA32: 518 pages in unavailable ranges
[    0.003333] On node 0, zone Normal: 2049 pages in unavailable ranges
[    0.003333] On node 0, zone Normal: 4096 pages in unavailable ranges
[    0.003333] ACPI: PM-Timer IO Port: 0x808
[    0.003333] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.003333] IOAPIC[0]: apic_id 9, version 33, address 0xfec00000, GSI 0-23
[    0.003333] IOAPIC[1]: apic_id 10, version 33, address 0xfec20000, GSI 24-55
[    0.003333] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.003333] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.003333] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.003333] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.003333] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.003333] [mem 0xcf800000-0xfebfffff] available for PCI devices
[    0.003333] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370452778343963 ns
[    0.003333] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.003333] percpu: Embedded 41 pages/cpu s128760 r8192 d30984 u262144
[    0.003333] pcpu-alloc: s128760 r8192 d30984 u262144 alloc=1*2097152
[    0.003333] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.003333] Built 1 zonelists, mobility grouping on.  Total pages: 8246855
[    0.003333] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc3-bdver2-dirty root=/dev/nvme0n1p4 ro psmouse.synaptics_intertouch=1 zswap.max_pool_percent=16 zswap.zpool=z3fold slub_debug=FZP page_poison=1 netconsole=6666@10.0.0.14/eth0,6666@10.0.0.3/70:85:C2:30:EC:01
[    0.003333] Unknown kernel command line parameters "BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc3-bdver2-dirty", will be passed to user space.
[    0.003333] printk: log_buf_len individual max cpu contribution: 8192 bytes
[    0.003333] printk: log_buf_len total cpu_extra contributions: 57344 bytes
[    0.003333] printk: log_buf_len min size: 65536 bytes
[    0.003333] printk: log_buf_len: 131072 bytes
[    0.003333] printk: early log buf free: 57008(86%)
[    0.003333] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes, linear)
[    0.003333] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes, linear)
[    0.003333] mem auto-init: stack:all(pattern), heap alloc:off, heap free:off
[    0.003333] software IO TLB: area num 8.
[    0.003333] Memory: 3395680K/33511684K available (10240K kernel code, 631K rwdata, 2388K rodata, 1060K init, 1540K bss, 846536K reserved, 0K cma-reserved)
[    0.003333] **********************************************************
[    0.003333] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.003333] **                                                      **
[    0.003333] ** This system shows unhashed kernel memory addresses   **
[    0.003333] ** via the console, logs, and other interfaces. This    **
[    0.003333] ** might reduce the security of your system.            **
[    0.003333] **                                                      **
[    0.003333] ** If you see this message and you are not debugging    **
[    0.003333] ** the kernel, report this immediately to your system   **
[    0.003333] ** administrator!                                       **
[    0.003333] **                                                      **
[    0.003333] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.003333] **********************************************************
[    0.003333] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.003333] rcu: Hierarchical RCU implementation.
[    0.003333] 	Tracing variant of Tasks RCU enabled.
[    0.003333] rcu: RCU calculated value of scheduler-enlistment delay is 30 jiffies.
[    0.003333] NR_IRQS: 4352, nr_irqs: 1032, preallocated irqs: 16
[    0.003333] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.003333] kfence: initialized - using 2097152 bytes for 255 objects at 0xffff8c588ba00000-0xffff8c588bc00000
[    0.003333] Console: colour dummy device 80x25
[    0.003333] printk: console [tty0] enabled
[    0.003333] ACPI: Core revision 20221020
[    0.003333] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.003333] APIC: Switch to symmetric I/O mode setup
[    0.003333] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.003333] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x39edbc03e43, max_idle_ns: 440795229915 ns
[    0.643338] Calibrating delay loop (skipped), value calculated using timer frequency.. 8040.50 BogoMIPS (lpj=13396000)
[    0.643343] pid_max: default: 32768 minimum: 301
[    0.679751] LSM: initializing lsm=capability,yama
[    0.679764] Yama: becoming mindful.
[    0.679970] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.680113] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.680554] LVT offset 1 assigned for vector 0xf9
[    0.680562] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.680565] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
[    0.680572] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.680577] Spectre V2 : Mitigation: Retpolines
[    0.680580] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.680583] Spectre V2 : Spectre v2 / SpectreRSB : Filling RSB on VMEXIT
[    0.680585] Spectre V2 : Enabling Speculation Barrier for firmware calls
[    0.680587] RETBleed: Mitigation: untrained return thunk
[    0.680591] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.680596] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.684174] Freeing SMP alternatives memory: 32K
[    0.791133] smpboot: CPU0: AMD FX-8370 Eight-Core Processor (family: 0x15, model: 0x2, stepping: 0x0)
[    0.791381] cblist_init_generic: Setting adjustable number of callback queues.
[    0.791386] cblist_init_generic: Setting shift to 3 and lim to 1.
[    0.791416] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.791436] ... version:                0
[    0.791438] ... bit width:              48
[    0.791441] ... generic registers:      6
[    0.791443] ... value mask:             0000ffffffffffff
[    0.791445] ... max period:             00007fffffffffff
[    0.791448] ... fixed-purpose events:   0
[    0.791450] ... event mask:             000000000000003f
[    0.791543] rcu: Hierarchical SRCU implementation.
[    0.791546] rcu: 	Max phase no-delay instances is 1000.
[    0.791617] MCE: In-kernel MCE decoding enabled.
[    0.791695] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.791847] smp: Bringing up secondary CPUs ...
[    0.792000] x86: Booting SMP configuration:
[    0.792003] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.852306] smp: Brought up 1 node, 8 CPUs
[    0.852306] smpboot: Max logical packages: 1
[    0.852306] smpboot: Total of 8 processors activated (64326.00 BogoMIPS)
[    4.441562] node 0 deferred pages initialised in 3587ms
[    4.458451] allocated 67108864 bytes of page_ext
[    4.458823] devtmpfs: initialized
[    4.458823] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    4.458823] futex hash table entries: 2048 (order: 5, 131072 bytes, linear)
[    4.458823] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    4.460067] thermal_sys: Registered thermal governor 'step_wise'
[    4.460068] thermal_sys: Registered thermal governor 'user_space'
[    4.460089] cpuidle: using governor menu
[    4.460116] PCI: Using configuration type 1 for base access
[    4.460116] PCI: Using configuration type 1 for extended access
[    4.460509] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    4.460509] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    4.460509] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    4.460509] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    4.516670] raid6: sse2x4   gen()  9928 MB/s
[    4.573336] raid6: sse2x2   gen()  8383 MB/s
[    4.630003] raid6: sse2x1   gen()  6911 MB/s
[    4.630006] raid6: using algorithm sse2x4 gen() 9928 MB/s
[    4.686671] raid6: .... xor() 4163 MB/s, rmw enabled
[    4.686674] raid6: using ssse3x2 recovery algorithm
[    4.686843] ACPI: Added _OSI(Module Device)
[    4.686846] ACPI: Added _OSI(Processor Device)
[    4.686849] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.686852] ACPI: Added _OSI(Processor Aggregator Device)
[    4.699470] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    4.702271] ACPI: Interpreter enabled
[    4.702282] ACPI: PM: (supports S0 S5)
[    4.702285] ACPI: Using IOAPIC for interrupt routing
[    4.702624] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    4.702628] PCI: Using E820 reservations for host bridge windows
[    4.703147] ACPI: Enabled 10 GPEs in block 00 to 1F
[    4.718592] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    4.718601] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    4.718615] acpi PNP0A08:00: _OSC: OS requested [PME AER PCIeCapability LTR]
[    4.718619] acpi PNP0A08:00: _OSC: platform willing to grant [PME AER PCIeCapability LTR]
[    4.718623] acpi PNP0A08:00: _OSC: platform retains control of PCIe features (AE_NOT_FOUND)
[    4.719105] PCI host bridge to bus 0000:00
[    4.719109] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    4.719114] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    4.719118] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    4.719121] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    4.719125] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000dffff window]
[    4.719130] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xffffffff window]
[    4.719134] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.719166] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    4.719312] pci 0000:00:00.2: [1002:5a23] type 00 class 0x080600
[    4.719464] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    4.719512] pci 0000:00:02.0: enabling Extended Tags
[    4.719541] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    4.719673] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    4.719691] pci 0000:00:04.0: enabling Extended Tags
[    4.719719] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    4.719846] pci 0000:00:06.0: [1002:5a1a] type 01 class 0x060400
[    4.719865] pci 0000:00:06.0: enabling Extended Tags
[    4.719892] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    4.720013] pci 0000:00:09.0: [1002:5a1c] type 01 class 0x060400
[    4.720032] pci 0000:00:09.0: enabling Extended Tags
[    4.720059] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    4.720200] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    4.720214] pci 0000:00:11.0: reg 0x10: [io  0xf040-0xf047]
[    4.720223] pci 0000:00:11.0: reg 0x14: [io  0xf030-0xf033]
[    4.720232] pci 0000:00:11.0: reg 0x18: [io  0xf020-0xf027]
[    4.720241] pci 0000:00:11.0: reg 0x1c: [io  0xf010-0xf013]
[    4.720250] pci 0000:00:11.0: reg 0x20: [io  0xf000-0xf00f]
[    4.720259] pci 0000:00:11.0: reg 0x24: [mem 0xfeb0b000-0xfeb0b3ff]
[    4.720399] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    4.720414] pci 0000:00:12.0: reg 0x10: [mem 0xfeb0a000-0xfeb0afff]
[    4.720578] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    4.720592] pci 0000:00:12.2: reg 0x10: [mem 0xfeb09000-0xfeb090ff]
[    4.720656] pci 0000:00:12.2: supports D1 D2
[    4.720659] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    4.720774] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    4.720788] pci 0000:00:13.0: reg 0x10: [mem 0xfeb08000-0xfeb08fff]
[    4.720943] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    4.720958] pci 0000:00:13.2: reg 0x10: [mem 0xfeb07000-0xfeb070ff]
[    4.721022] pci 0000:00:13.2: supports D1 D2
[    4.721025] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    4.721140] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    4.721306] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    4.721324] pci 0000:00:14.2: reg 0x10: [mem 0xfeb00000-0xfeb03fff 64bit]
[    4.721378] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    4.721490] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    4.721681] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    4.721816] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    4.721831] pci 0000:00:14.5: reg 0x10: [mem 0xfeb06000-0xfeb06fff]
[    4.721987] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    4.722019] pci 0000:00:15.0: enabling Extended Tags
[    4.722059] pci 0000:00:15.0: supports D1 D2
[    4.722184] pci 0000:00:15.1: [1002:43a1] type 01 class 0x060400
[    4.722215] pci 0000:00:15.1: enabling Extended Tags
[    4.722254] pci 0000:00:15.1: supports D1 D2
[    4.722390] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    4.722405] pci 0000:00:16.0: reg 0x10: [mem 0xfeb05000-0xfeb05fff]
[    4.722550] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    4.722565] pci 0000:00:16.2: reg 0x10: [mem 0xfeb04000-0xfeb040ff]
[    4.722629] pci 0000:00:16.2: supports D1 D2
[    4.722632] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    4.722750] pci 0000:00:18.0: [1022:1600] type 00 class 0x060000
[    4.722819] pci 0000:00:18.1: [1022:1601] type 00 class 0x060000
[    4.722899] pci 0000:00:18.2: [1022:1602] type 00 class 0x060000
[    4.722965] pci 0000:00:18.3: [1022:1603] type 00 class 0x060000
[    4.723044] pci 0000:00:18.4: [1022:1604] type 00 class 0x060000
[    4.723113] pci 0000:00:18.5: [1022:1605] type 00 class 0x060000
[    4.723243] pci 0000:01:00.0: [1002:6758] type 00 class 0x030000
[    4.723261] pci 0000:01:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.723274] pci 0000:01:00.0: reg 0x18: [mem 0xfea20000-0xfea3ffff 64bit]
[    4.723283] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    4.723297] pci 0000:01:00.0: reg 0x30: [mem 0xfea00000-0xfea1ffff pref]
[    4.723305] pci 0000:01:00.0: enabling Extended Tags
[    4.723325] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    4.723363] pci 0000:01:00.0: supports D1 D2
[    4.723462] pci 0000:01:00.1: [1002:aa90] type 00 class 0x040300
[    4.723480] pci 0000:01:00.1: reg 0x10: [mem 0xfea40000-0xfea43fff 64bit]
[    4.723515] pci 0000:01:00.1: enabling Extended Tags
[    4.723564] pci 0000:01:00.1: supports D1 D2
[    4.723675] pci 0000:00:02.0: PCI bridge to [bus 01]
[    4.723680] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    4.723684] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    4.723689] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.723744] pci 0000:02:00.0: [1b21:2142] type 00 class 0x0c0330
[    4.723762] pci 0000:02:00.0: reg 0x10: [mem 0xfe900000-0xfe907fff 64bit]
[    4.723801] pci 0000:02:00.0: enabling Extended Tags
[    4.723860] pci 0000:02:00.0: PME# supported from D0
[    4.723892] pci 0000:02:00.0: 8.000 Gb/s available PCIe bandwidth, limited by 5.0 GT/s PCIe x2 link at 0000:00:04.0 (capable of 15.752 Gb/s with 8.0 GT/s PCIe x2 link)
[    4.723975] pci 0000:00:04.0: PCI bridge to [bus 02]
[    4.723981] pci 0000:00:04.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    4.724043] pci 0000:03:00.0: [15b7:5009] type 00 class 0x010802
[    4.724061] pci 0000:03:00.0: reg 0x10: [mem 0xfe800000-0xfe803fff 64bit]
[    4.724085] pci 0000:03:00.0: reg 0x20: [mem 0xfe804000-0xfe8040ff 64bit]
[    4.724202] pci 0000:03:00.0: 8.000 Gb/s available PCIe bandwidth, limited by 5.0 GT/s PCIe x2 link at 0000:00:06.0 (capable of 31.504 Gb/s with 8.0 GT/s PCIe x4 link)
[    4.724306] pci 0000:00:06.0: PCI bridge to [bus 03]
[    4.724311] pci 0000:00:06.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    4.724393] pci 0000:04:00.0: [1b21:1343] type 00 class 0x0c0330
[    4.724411] pci 0000:04:00.0: reg 0x10: [mem 0xfe700000-0xfe707fff 64bit]
[    4.724450] pci 0000:04:00.0: enabling Extended Tags
[    4.724514] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    4.724694] pci 0000:00:09.0: PCI bridge to [bus 04]
[    4.724699] pci 0000:00:09.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    4.724712] pci_bus 0000:05: extended config space not accessible
[    4.724771] pci 0000:00:14.4: PCI bridge to [bus 05] (subtractive decode)
[    4.724779] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af window] (subtractive decode)
[    4.724784] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7 window] (subtractive decode)
[    4.724788] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df window] (subtractive decode)
[    4.724792] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    4.724796] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000dffff window] (subtractive decode)
[    4.724801] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xffffffff window] (subtractive decode)
[    4.724870] pci 0000:06:00.0: [1969:e0a1] type 00 class 0x020000
[    4.724897] pci 0000:06:00.0: reg 0x10: [mem 0xfe600000-0xfe63ffff 64bit]
[    4.724909] pci 0000:06:00.0: reg 0x18: [io  0xd000-0xd07f]
[    4.724968] pci 0000:06:00.0: [Firmware Bug]: disabling VPD access (can't determine size of non-standard VPD format)
[    4.725028] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.725152] pci 0000:00:15.0: PCI bridge to [bus 06]
[    4.725158] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    4.725163] pci 0000:00:15.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    4.725225] pci 0000:07:00.0: [1106:3483] type 00 class 0x0c0330
[    4.725246] pci 0000:07:00.0: reg 0x10: [mem 0xfe500000-0xfe500fff 64bit]
[    4.725337] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.725425] pci 0000:00:15.1: PCI bridge to [bus 07]
[    4.725432] pci 0000:00:15.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    4.725461] pci_bus 0000:00: on NUMA node 0
[    4.726359] ACPI: PCI: Interrupt link LNKA configured for IRQ 0
[    4.726518] ACPI: PCI: Interrupt link LNKB configured for IRQ 0
[    4.726686] ACPI: PCI: Interrupt link LNKC configured for IRQ 0
[    4.726876] ACPI: PCI: Interrupt link LNKD configured for IRQ 0
[    4.727018] ACPI: PCI: Interrupt link LNKE configured for IRQ 0
[    4.727130] ACPI: PCI: Interrupt link LNKF configured for IRQ 0
[    4.727241] ACPI: PCI: Interrupt link LNKG configured for IRQ 0
[    4.727359] ACPI: PCI: Interrupt link LNKH configured for IRQ 0
[    4.727611] iommu: Default domain type: Translated 
[    4.727614] iommu: DMA domain TLB invalidation policy: lazy mode 
[    4.727792] SCSI subsystem initialized
[    4.727824] libata version 3.00 loaded.
[    4.727861] EDAC MC: Ver: 3.0.0
[    4.727971] efivars: Registered efivars operations
[    4.727971] PCI: Using ACPI for IRQ routing
[    4.727971] PCI: pci_cache_line_size set to 64 bytes
[    4.727971] e820: reserve RAM buffer [mem 0xce1ff000-0xcfffffff]
[    4.727971] e820: reserve RAM buffer [mem 0xcf157000-0xcfffffff]
[    4.727971] e820: reserve RAM buffer [mem 0xcf800000-0xcfffffff]
[    4.727971] e820: reserve RAM buffer [mem 0x82f000000-0x82fffffff]
[    4.727971] pci 0000:01:00.0: vgaarb: setting as boot VGA device
[    4.727971] pci 0000:01:00.0: vgaarb: bridge control possible
[    4.727971] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    4.727971] vgaarb: loaded
[    4.727971] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    4.727971] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    4.730091] clocksource: Switched to clocksource tsc-early
[    4.730423] pnp: PnP ACPI init
[    4.730590] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    4.731195] system 00:01: [io  0x040b] has been reserved
[    4.731200] system 00:01: [io  0x04d6] has been reserved
[    4.731204] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    4.731208] system 00:01: [io  0x0c14] has been reserved
[    4.731212] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    4.731216] system 00:01: [io  0x0c52] has been reserved
[    4.731220] system 00:01: [io  0x0c6c] has been reserved
[    4.731224] system 00:01: [io  0x0c6f] has been reserved
[    4.731228] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    4.731231] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    4.731241] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    4.731245] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    4.731249] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    4.731252] system 00:01: [io  0x0800-0x089f] has been reserved
[    4.731256] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    4.731260] system 00:01: [io  0x0900-0x090f] has been reserved
[    4.731264] system 00:01: [io  0x0910-0x091f] has been reserved
[    4.731267] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    4.731273] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    4.731278] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    4.731286] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    4.731291] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    4.731296] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    4.731301] system 00:01: [mem 0xfed00000-0xfed00fff] could not be reserved
[    4.731306] system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
[    4.731660] system 00:02: [io  0x0220-0x0227] has been reserved
[    4.731665] system 00:02: [io  0x0228-0x0237] has been reserved
[    4.731672] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    4.732201] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    4.732530] system 00:06: [mem 0xfeb20000-0xfeb23fff] has been reserved
[    4.732704] system 00:07: [mem 0xfec20000-0xfec200ff] could not be reserved
[    4.732965] pnp: PnP ACPI: found 8 devices
[    4.740543] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    4.740601] NET: Registered PF_INET protocol family
[    4.741172] IP idents hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    4.744368] tcp_listen_portaddr_hash hash table entries: 16384 (order: 7, 524288 bytes, linear)
[    4.744468] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    4.744872] TCP established hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    4.745842] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes, linear)
[    4.746792] TCP: Hash tables configured (established 262144 bind 65536)
[    4.747306] UDP hash table entries: 16384 (order: 8, 1572864 bytes, linear)
[    4.747855] UDP-Lite hash table entries: 16384 (order: 8, 1572864 bytes, linear)
[    4.748051] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    4.748084] pci 0000:00:02.0: PCI bridge to [bus 01]
[    4.748090] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    4.748095] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    4.748099] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.748104] pci 0000:00:04.0: PCI bridge to [bus 02]
[    4.748108] pci 0000:00:04.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    4.748113] pci 0000:00:06.0: PCI bridge to [bus 03]
[    4.748117] pci 0000:00:06.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    4.748122] pci 0000:00:09.0: PCI bridge to [bus 04]
[    4.748126] pci 0000:00:09.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    4.748132] pci 0000:00:14.4: PCI bridge to [bus 05]
[    4.748142] pci 0000:00:15.0: PCI bridge to [bus 06]
[    4.748145] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    4.748150] pci 0000:00:15.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    4.748157] pci 0000:00:15.1: PCI bridge to [bus 07]
[    4.748162] pci 0000:00:15.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    4.748170] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    4.748174] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    4.748177] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    4.748180] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    4.748183] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000dffff window]
[    4.748186] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xffffffff window]
[    4.748190] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    4.748193] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    4.748196] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.748199] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    4.748203] pci_bus 0000:03: resource 1 [mem 0xfe800000-0xfe8fffff]
[    4.748206] pci_bus 0000:04: resource 1 [mem 0xfe700000-0xfe7fffff]
[    4.748210] pci_bus 0000:05: resource 4 [io  0x0000-0x03af window]
[    4.748213] pci_bus 0000:05: resource 5 [io  0x03e0-0x0cf7 window]
[    4.748216] pci_bus 0000:05: resource 6 [io  0x03b0-0x03df window]
[    4.748219] pci_bus 0000:05: resource 7 [io  0x0d00-0xffff window]
[    4.748222] pci_bus 0000:05: resource 8 [mem 0x000a0000-0x000dffff window]
[    4.748225] pci_bus 0000:05: resource 9 [mem 0xd0000000-0xffffffff window]
[    4.748229] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    4.748232] pci_bus 0000:06: resource 1 [mem 0xfe600000-0xfe6fffff]
[    4.748235] pci_bus 0000:07: resource 1 [mem 0xfe500000-0xfe5fffff]
[    4.750292] pci 0000:01:00.1: D0 power state depends on 0000:01:00.0
[    4.750302] pci 0000:02:00.0: PME# does not work under D0, disabling it
[    4.751093] PCI: CLS 64 bytes, default 64
[    4.751175] AMD-Vi: Using global IVHD EFR:0x0, EFR2:0x0
[    4.752506] pci 0000:00:00.0: Adding to iommu group 0
[    4.752533] pci 0000:00:02.0: Adding to iommu group 1
[    4.752554] pci 0000:00:04.0: Adding to iommu group 2
[    4.752575] pci 0000:00:06.0: Adding to iommu group 3
[    4.752599] pci 0000:00:09.0: Adding to iommu group 4
[    4.752620] pci 0000:00:11.0: Adding to iommu group 5
[    4.752655] pci 0000:00:12.0: Adding to iommu group 6
[    4.752677] pci 0000:00:12.2: Adding to iommu group 6
[    4.752720] pci 0000:00:13.0: Adding to iommu group 7
[    4.752739] pci 0000:00:13.2: Adding to iommu group 7
[    4.752765] pci 0000:00:14.0: Adding to iommu group 8
[    4.752790] pci 0000:00:14.2: Adding to iommu group 9
[    4.752823] pci 0000:00:14.3: Adding to iommu group 10
[    4.752843] pci 0000:00:14.4: Adding to iommu group 11
[    4.752872] pci 0000:00:14.5: Adding to iommu group 12
[    4.752906] pci 0000:00:15.0: Adding to iommu group 13
[    4.752927] pci 0000:00:15.1: Adding to iommu group 13
[    4.752961] pci 0000:00:16.0: Adding to iommu group 14
[    4.752986] pci 0000:00:16.2: Adding to iommu group 14
[    4.753032] pci 0000:01:00.0: Adding to iommu group 15
[    4.753055] pci 0000:01:00.1: Adding to iommu group 15
[    4.753076] pci 0000:02:00.0: Adding to iommu group 16
[    4.753101] pci 0000:03:00.0: Adding to iommu group 17
[    4.753123] pci 0000:04:00.0: Adding to iommu group 18
[    4.753132] pci 0000:06:00.0: Adding to iommu group 13
[    4.753141] pci 0000:07:00.0: Adding to iommu group 13
[    4.760961] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    4.761089] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.761092] software IO TLB: mapped [mem 0x00000000bf076000-0x00000000c3076000] (64MB)
[    4.761134] LVT offset 0 assigned for vector 0x400
[    4.761218] perf: AMD IBS detected (0x000000ff)
[    4.761796] Initialise system trusted keyrings
[    4.761866] workingset: timestamp_bits=46 max_order=23 bucket_order=0
[    4.762335] NET: Registered PF_ALG protocol family
[    4.762339] xor: automatically using best checksumming function   avx       
[    4.762343] Key type asymmetric registered
[    4.762346] Asymmetric key parser 'x509' registered
[    4.763681] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.763720] io scheduler kyber registered
[    4.766263] IPMI message handler: version 39.2
[    4.767716] ahci 0000:00:11.0: version 3.0
[    4.767812] nvme nvme0: pci function 0000:03:00.0
[    4.767915] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    4.767923] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    4.768361] scsi host0: ahci
[    4.768572] scsi host1: ahci
[    4.768673] ata1: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b100 irq 19
[    4.768678] ata2: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b180 irq 19
[    4.779178] alx 0000:06:00.0 eth0: Qualcomm Atheros AR816x/AR817x Ethernet [1c:1b:0d:93:c2:07]
[    4.779212] rtc_cmos 00:03: RTC can wake from S4
[    4.779426] rtc_cmos 00:03: registered as rtc0
[    4.779439] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.779510] simple-framebuffer simple-framebuffer.0: framebuffer at 0xd0000000, 0x300000 bytes
[    4.779514] simple-framebuffer simple-framebuffer.0: format=x8r8g8b8, mode=1024x768x32, linelength=4096
[    4.781709] Console: switching to colour frame buffer device 128x48
[    4.783215] nvme nvme0: allocated 32 MiB host memory buffer.
[    4.783805] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
[    4.783969] NET: Registered PF_INET6 protocol family
[    4.784287] nvme nvme0: 8/0/0 default/read/poll queues
[    4.784500] Segment Routing with IPv6
[    4.784554] In-situ OAM (IOAM) with IPv6
[    4.784595] NET: Registered PF_PACKET protocol family
[    4.785414] microcode: microcode updated early to new patch_level=0x06000852
[    4.785484] microcode: CPU1: patch_level=0x06000852
[    4.785490] microcode: CPU0: patch_level=0x06000852
[    4.785490] microcode: CPU3: patch_level=0x06000852
[    4.785493] microcode: CPU5: patch_level=0x06000852
[    4.785494] microcode: CPU6: patch_level=0x06000852
[    4.785502] microcode: CPU2: patch_level=0x06000852
[    4.785572] microcode: CPU4: patch_level=0x06000852
[    4.785579] microcode: CPU7: patch_level=0x06000852
[    4.785674] microcode: Microcode Update Driver: v2.2.
[    4.785678] IPI shorthand broadcast: enabled
[    4.788826] sched_clock: Marking stable (4163339239, 623336192)->(4798354889, -11679458)
[    4.789017] registered taskstats version 1
[    4.789131]  nvme0n1: p1 p2 p3 p4 p5 p6
[    4.789309] Loading compiled-in X.509 certificates
[    4.795458] zswap: loaded using pool zstd/z3fold
[    4.801843] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
[    5.079810] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.080669] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    5.082255] ata1.00: ATA-9: HP SSD S700 Pro 1TB, R0201B, max UDMA/100
[    5.083065] ata1.00: 2000409264 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    5.083896] ata2.00: ATAPI: PIONEER BD-RW   BDR-208D, 1.50, max UDMA/100
[    5.084990] ata1.00: Features: Dev-Sleep
[    5.086247] ata1.00: configured for UDMA/100
[    5.087241] scsi 0:0:0:0: Direct-Access     ATA      HP SSD S700 Pro  1B   PQ: 0 ANSI: 5
[    5.088151] ata2.00: configured for UDMA/100
[    5.088583] sd 0:0:0:0: [sda] 2000409264 512-byte logical blocks: (1.02 TB/954 GiB)
[    5.089760] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    5.090576] sd 0:0:0:0: [sda] Write Protect is off
[    5.091340] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.091356] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.092177] sd 0:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
[    5.094683]  sda: sda1
[    5.095560] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    5.100218] scsi 1:0:0:0: CD-ROM            PIONEER  BD-RW   BDR-208D 1.50 PQ: 0 ANSI: 5
[    5.185414] Btrfs loaded, crc32c=crc32c-intel, zoned=no, fsverity=no
[    5.367361] netpoll: netconsole: local port 6666
[    5.368157] netpoll: netconsole: local IPv4 address 10.0.0.14
[    5.368938] netpoll: netconsole: interface 'eth0'
[    5.369673] netpoll: netconsole: remote port 6666
[    5.370420] netpoll: netconsole: remote IPv4 address 10.0.0.3
[    5.371155] netpoll: netconsole: remote ethernet address 70:85:c2:30:ec:01
[    5.371863] netpoll: netconsole: device eth0 not up yet, forcing it
[    5.770008] tsc: Refined TSC clocksource calibration: 4018.625 MHz
[    5.770716] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x39ed1687aa7, max_idle_ns: 440795234189 ns
[    5.771505] clocksource: Switched to clocksource tsc
[    6.252194] alx 0000:06:00.0 eth0: NIC Up: 100 Mbps Full
[    6.253141] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    6.254161] printk: console [netcon0] enabled
[    6.260155] netconsole: network logging started
[    6.261996] BTRFS: device label bdver2_musl devid 1 transid 98056 /dev/root scanned by swapper/0 (1)
[    6.262980] BTRFS info (device nvme0n1p4): using xxhash64 (xxhash64-generic) checksum algorithm
[    6.263777] BTRFS info (device nvme0n1p4): using free space tree
[    6.270280] BTRFS info (device nvme0n1p4): enabling ssd optimizations
[    6.271082] BTRFS info (device nvme0n1p4): auto enabling async discard
[    6.272649] VFS: Mounted root (btrfs filesystem) readonly on device 0:16.
[    6.274175] devtmpfs: mounted
[    6.275380] Freeing unused kernel image (initmem) memory: 1060K
[    6.286698] Write protecting the kernel read-only data: 14336k
[    6.288114] Freeing unused kernel image (rodata/data gap) memory: 1708K
[    6.291248] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    6.292124] rodata_test: all tests were successful
[    6.292970] kallsyms_selftest: start
[    6.292974] Run /sbin/init as init process
[    6.294706]   with arguments:
[    6.294707]     /sbin/init
[    6.294708]   with environment:
[    6.294710]     HOME=/
[    6.294711]     TERM=linux
[    6.294712]     BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc3-bdver2-dirty
[    7.826610] kallsyms_selftest:  ---------------------------------------------------------
[    7.827325] kallsyms_selftest: | nr_symbols | compressed size | original size | ratio(%) |
[    7.828068] kallsyms_selftest: |---------------------------------------------------------|
[    7.828822] kallsyms_selftest: |      34969 |        380937   |       655579  |  58.10   |
[    7.828828] kallsyms_selftest:  ---------------------------------------------------------
[    8.060246] kallsyms_selftest: kallsyms_lookup_name() looked up 34969 symbols
[    8.060250] kallsyms_selftest: The time spent on each symbol is (ns): min=1059, max=25595, avg=6460
[    8.064434] kallsyms_selftest: kallsyms_on_each_symbol() traverse all: 4180780 ns
[    8.064443] kallsyms_selftest: kallsyms_on_each_match_symbol() traverse all: 6817 ns
[    8.064445] kallsyms_selftest: finish
[    8.084090] ACPI: \_PR_.P001: Found 2 idle states
[    8.085559] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    8.085566] ACPI: button: Power Button [PWRB]
[    8.087626] ACPI: \_PR_.P002: Found 2 idle states
[    8.088036] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    8.088042] ACPI: button: Power Button [PWRF]
[    8.089926] ACPI: bus type USB registered
[    8.090001] usbcore: registered new interface driver usbfs
[    8.090040] usbcore: registered new interface driver hub
[    8.090077] usbcore: registered new device driver usb
[    8.093854] ACPI: \_PR_.P003: Found 2 idle states
[    8.097176] ACPI: \_PR_.P004: Found 2 idle states
[    8.099415] QUIRK: Enable AMD PLL fix
[    8.099440] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    8.099561] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 1
[    8.102182] ACPI: \_PR_.P005: Found 2 idle states
[    8.103855] ACPI: \_PR_.P006: Found 2 idle states
[    8.104691] ACPI: \_PR_.P007: Found 2 idle states
[    8.108897] ACPI: \_PR_.P008: Found 2 idle states
[    8.111716] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    8.111757] piix4_smbus 0000:00:14.0: Using register 0x2c for SMBus port selection
[    8.116422] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    8.136032] alx 0000:06:00.0 enp6s0: renamed from eth0 (while UP)
[    8.141671] cryptd: max_cpu_qlen set to 1000
[    8.154520] xhci_hcd 0000:02:00.0: hcc params 0x0200ef80 hci version 0x110 quirks 0x0000000000800010
[    8.154926] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    8.154933] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
[    8.154939] ehci-pci 0000:00:13.2: EHCI Host Controller
[    8.154941] xhci_hcd 0000:02:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    8.154955] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 3
[    8.154964] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    8.154973] ehci-pci 0000:00:13.2: debug port 1
[    8.155034] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[    8.155038] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.155041] usb usb1: Product: xHCI Host Controller
[    8.155042] usb usb1: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty xhci-hcd
[    8.155044] usb usb1: SerialNumber: 0000:02:00.0
[    8.155064] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb07000
[    8.155274] hub 1-0:1.0: USB hub found
[    8.155290] hub 1-0:1.0: 2 ports detected
[    8.155494] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    8.155552] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 6.03
[    8.155555] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.155557] usb usb2: Product: xHCI Host Controller
[    8.155559] usb usb2: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty xhci-hcd
[    8.155560] usb usb2: SerialNumber: 0000:02:00.0
[    8.155755] hub 2-0:1.0: USB hub found
[    8.155769] hub 2-0:1.0: 2 ports detected
[    8.157912] BTRFS: device label ubuntu devid 1 transid 869 /dev/nvme0n1p3 scanned by (udev-worker) (699)
[    8.162604] BTRFS info: devid 1 device path /dev/root changed to /dev/nvme0n1p4 scanned by (udev-worker) (689)
[    8.170294] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    8.170409] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[    8.170412] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.170415] usb usb3: Product: EHCI Host Controller
[    8.170416] usb usb3: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty ehci_hcd
[    8.170418] usb usb3: SerialNumber: 0000:00:13.2
[    8.170682] hub 3-0:1.0: USB hub found
[    8.170703] hub 3-0:1.0: 5 ports detected
[    8.171087] ehci-pci 0000:00:16.2: EHCI Host Controller
[    8.171109] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 4
[    8.171117] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    8.171126] ehci-pci 0000:00:16.2: debug port 1
[    8.171177] ehci-pci 0000:00:16.2: irq 17, io mem 0xfeb04000
[    8.171927] BTRFS: device label bisect_x86-64-v2 devid 1 transid 34531 /dev/nvme0n1p5 scanned by (udev-worker) (699)
[    8.176471] BTRFS: device label distfiles devid 1 transid 30 /dev/nvme0n1p6 scanned by (udev-worker) (689)
[    8.186692] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    8.186821] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[    8.186834] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.186838] usb usb4: Product: EHCI Host Controller
[    8.186840] usb usb4: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty ehci_hcd
[    8.186843] usb usb4: SerialNumber: 0000:00:16.2
[    8.187131] hub 4-0:1.0: USB hub found
[    8.187163] hub 4-0:1.0: 4 ports detected
[    8.187558] ehci-pci 0000:00:12.2: EHCI Host Controller
[    8.187568] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 5
[    8.187576] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    8.187585] ehci-pci 0000:00:12.2: debug port 1
[    8.187642] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb09000
[    8.189106] AVX version of gcm_enc/dec engaged.
[    8.189148] AES CTR mode by8 optimization enabled
[    8.203356] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    8.203496] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[    8.203501] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.203503] usb usb5: Product: EHCI Host Controller
[    8.203505] usb usb5: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty ehci_hcd
[    8.203507] usb usb5: SerialNumber: 0000:00:12.2
[    8.203724] hub 5-0:1.0: USB hub found
[    8.203742] hub 5-0:1.0: 5 ports detected
[    8.204103] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    8.204104] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    8.204117] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 6
[    8.204136] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 7
[    8.204175] ohci-pci 0000:00:12.0: irq 18, io mem 0xfeb0a000
[    8.209979] acpi_cpufreq: overriding BIOS provided _PSD data
[    8.222852] ACPI: bus type drm_connector registered
[    8.263726] xhci_hcd 0000:04:00.0: hcc params 0x0200eec1 hci version 0x110 quirks 0x0000000000000010
[    8.264149] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[    8.264157] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.264161] usb usb6: Product: OHCI PCI host controller
[    8.264166] usb usb6: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty ohci_hcd
[    8.264169] usb usb6: SerialNumber: 0000:00:12.0
[    8.272362] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    8.278263] hub 6-0:1.0: USB hub found
[    8.278292] hub 6-0:1.0: 5 ports detected
[    8.285610] snd_hda_codec_realtek hdaudioC0D0: ALC1150: SKU not ready 0x00000000
[    8.285641] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input2
[    8.286260] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC1150: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    8.286274] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    8.286279] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    8.286284] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[    8.286287] snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x11/0x1e
[    8.286291] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    8.286294] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[    8.286298] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[    8.286302] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[    8.291025] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    8.291038] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 8
[    8.291091] ohci-pci 0000:00:13.0: irq 18, io mem 0xfeb08000
[    8.291201] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 9
[    8.291241] xhci_hcd 0000:04:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    8.291358] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[    8.291363] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.291368] usb usb7: Product: xHCI Host Controller
[    8.291372] usb usb7: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty xhci-hcd
[    8.291375] usb usb7: SerialNumber: 0000:04:00.0
[    8.298127] hub 7-0:1.0: USB hub found
[    8.298151] hub 7-0:1.0: 2 ports detected
[    8.300975] usb usb9: We don't know the algorithms for LPM for this host, disabling LPM.
[    8.301051] usb usb9: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 6.03
[    8.301056] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.301059] usb usb9: Product: xHCI Host Controller
[    8.301062] usb usb9: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty xhci-hcd
[    8.301065] usb usb9: SerialNumber: 0000:04:00.0
[    8.306357] hub 9-0:1.0: USB hub found
[    8.306374] hub 9-0:1.0: 2 ports detected
[    8.306783] xhci_hcd 0000:07:00.0: xHCI Host Controller
[    8.306791] xhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 10
[    8.311622] xhci_hcd 0000:07:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000e address=0xce210880 flags=0x0000]
[    8.312461] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input3
[    8.313216] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input4
[    8.313508] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    8.314085] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    8.314375] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    8.315274] sr 1:0:0:0: [sr0] scsi3-mmc drive: 125x/125x writer cd/rw xa/form2 cdda tray
[    8.315283] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.316142] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    8.316342] it87: Found IT8620E chip at 0x228, revision 4
[    8.316380] it87: Beeping is supported
[    8.316381] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    8.317382] [drm] radeon kernel modesetting enabled.
[    8.320190] Console: switching to colour dummy device 80x25
[    8.321181] radeon 0000:01:00.0: vgaarb: deactivate vga console
[    8.327287] [drm] initializing kernel modesetting (TURKS 0x1002:0x6758 0x174B:0xE194 0x00).
[    8.327418] ATOM BIOS: TURKS
[    8.327624] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    8.327628] radeon 0000:01:00.0: GTT: 1024M 0x0000000040000000 - 0x000000007FFFFFFF
[    8.327634] [drm] Detected VRAM RAM=1024M, BAR=256M
[    8.327636] [drm] RAM width 128bits DDR
[    8.327722] [drm] radeon: 1024M of VRAM memory ready
[    8.327725] [drm] radeon: 1024M of GTT memory ready.
[    8.327737] [drm] Loading TURKS Microcode
[    8.329160] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.329270] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    8.333123] [drm] Internal thermal controller without fan control
[    8.337065] Asymmetric key parser 'pkcs8' registered
[    8.338317] [drm] radeon: dpm initialized
[    8.340102] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    8.341441] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    8.347562] [drm] PCIE GART of 1024M enabled (table at 0x0000000000162000).
[    8.347676] radeon 0000:01:00.0: WB enabled
[    8.347679] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00
[    8.347681] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c
[    8.348424] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000072118
[    8.348785] radeon 0000:01:00.0: radeon: MSI limited to 32-bit
[    8.348888] radeon 0000:01:00.0: radeon: using MSI.
[    8.348951] [drm] radeon: irq initialized.
[    8.350832] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[    8.350841] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.350845] usb usb8: Product: OHCI PCI host controller
[    8.350849] usb usb8: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty ohci_hcd
[    8.350852] usb usb8: SerialNumber: 0000:00:13.0
[    8.351182] hub 8-0:1.0: USB hub found
[    8.351196] hub 8-0:1.0: 5 ports detected
[    8.351705] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    8.351714] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 11
[    8.351753] ohci-pci 0000:00:14.5: irq 18, io mem 0xfeb06000
[    8.365702] [drm] ring test on 0 succeeded in 2 usecs
[    8.365717] [drm] ring test on 3 succeeded in 5 usecs
[    8.410986] usb usb11: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[    8.410993] usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.410996] usb usb11: Product: OHCI PCI host controller
[    8.410999] usb usb11: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty ohci_hcd
[    8.411001] usb usb11: SerialNumber: 0000:00:14.5
[    8.411362] hub 11-0:1.0: USB hub found
[    8.411381] hub 11-0:1.0: 2 ports detected
[    8.411916] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    8.411926] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 12
[    8.411966] ohci-pci 0000:00:16.0: irq 18, io mem 0xfeb05000
[    8.470953] usb usb12: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[    8.470965] usb usb12: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.470971] usb usb12: Product: OHCI PCI host controller
[    8.470977] usb usb12: Manufacturer: Linux 6.3.0-rc3-bdver2-dirty ohci_hcd
[    8.470981] usb usb12: SerialNumber: 0000:00:16.0
[    8.471553] hub 12-0:1.0: USB hub found
[    8.471592] hub 12-0:1.0: 4 ports detected
[    8.543019] [drm] ring test on 5 succeeded in 1 usecs
[    8.543039] [drm] UVD initialized successfully.
[    8.543531] snd_hda_intel 0000:01:00.1: bound 0000:01:00.0 (ops radeon_audio_component_bind_ops [radeon])
[    8.543807] [drm] ib test on ring 0 succeeded in 0 usecs
[    8.543937] [drm] ib test on ring 3 succeeded in 0 usecs
[    8.866690] usb 6-1: new low-speed USB device number 2 using ohci-pci
[    9.062999] usb 6-1: New USB device found, idVendor=046d, idProduct=c045, bcdDevice=27.30
[    9.063005] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.063011] usb 6-1: Product: USB-PS/2 Optical Mouse
[    9.063015] usb 6-1: Manufacturer: Logitech
[    9.077723] alx 0000:06:00.0 enp6s0: fatal interrupt 0x200, resetting
[    9.083211] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full
[    9.103720] hid: raw HID events driver (C) Jiri Kosina
[    9.111441] usbcore: registered new interface driver usbhid
[    9.111446] usbhid: USB HID core driver
[    9.121162] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb6/6-1/6-1:1.0/0003:046D:C045.0001/input/input10
[    9.121374] hid-generic 0003:046D:C045.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-1/input0
[    9.210155] [drm] ib test on ring 5 succeeded
[    9.210172] stackdepot: allocating hash table of 1048576 entries via kvcalloc
[    9.216533] [drm] Radeon Display Connectors
[    9.216540] [drm] Connector 0:
[    9.216545] [drm]   DP-1
[    9.216549] [drm]   HPD5
[    9.216553] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[    9.216562] [drm]   Encoders:
[    9.216565] [drm]     DFP1: INTERNAL_UNIPHY1
[    9.216569] [drm] Connector 1:
[    9.216572] [drm]   HDMI-A-1
[    9.216576] [drm]   HPD1
[    9.216579] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[    9.216587] [drm]   Encoders:
[    9.216590] [drm]     DFP2: INTERNAL_UNIPHY2
[    9.216594] [drm] Connector 2:
[    9.216597] [drm]   DVI-I-1
[    9.216600] [drm]   HPD4
[    9.216603] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 0x645c
[    9.216611] [drm]   Encoders:
[    9.216614] [drm]     DFP3: INTERNAL_UNIPHY
[    9.216617] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    9.342523] [drm] fb mappable at 0xD0363000
[    9.342528] [drm] vram apper at 0xD0000000
[    9.342530] [drm] size 8294400
[    9.342532] [drm] fb depth is 24
[    9.342534] [drm]    pitch is 7680
[    9.342761] fbcon: radeondrmfb (fb0) is primary device
[    9.483359] Console: switching to colour frame buffer device 240x67
[    9.489400] radeon 0000:01:00.0: [drm] fb0: radeondrmfb frame buffer device
[    9.489590] [drm] Initialized radeon 2.50.0 20080528 for 0000:01:00.0 on minor 0
[   18.306812] xhci_hcd 0000:07:00.0: can't setup: -110
[   18.306830] xhci_hcd 0000:07:00.0: USB bus 10 deregistered
[   18.307005] xhci_hcd 0000:07:00.0: init 0000:07:00.0 fail, -110
[   18.307010] xhci_hcd: probe of 0000:07:00.0 failed with error -110
[   18.361810] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   18.593445] usb 6-2: new low-speed USB device number 3 using ohci-pci
[   18.807032] usb 6-2: New USB device found, idVendor=1017, idProduct=1010, bcdDevice= 1.02
[   18.807044] usb 6-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[   18.807050] usb 6-2: Product: Gaming Keyboard
[   18.826095] input: Gaming Keyboard as /devices/pci0000:00/0000:00:12.0/usb6/6-2/6-2:1.0/0003:1017:1010.0002/input/input11
[   18.880526] hid-generic 0003:1017:1010.0002: input,hidraw1: USB HID v1.10 Keyboard [Gaming Keyboard] on usb-0000:00:12.0-2/input0
[   18.965164] input: Gaming Keyboard Mouse as /devices/pci0000:00/0000:00:12.0/usb6/6-2/6-2:1.1/0003:1017:1010.0003/input/input12
[   18.965585] input: Gaming Keyboard Consumer Control as /devices/pci0000:00/0000:00:12.0/usb6/6-2/6-2:1.1/0003:1017:1010.0003/input/input13
[   19.020426] input: Gaming Keyboard System Control as /devices/pci0000:00/0000:00:12.0/usb6/6-2/6-2:1.1/0003:1017:1010.0003/input/input14
[   19.020733] input: Gaming Keyboard as /devices/pci0000:00/0000:00:12.0/usb6/6-2/6-2:1.1/0003:1017:1010.0003/input/input15
[   19.022068] hid-generic 0003:1017:1010.0003: input,hiddev96,hidraw2: USB HID v1.10 Mouse [Gaming Keyboard] on usb-0000:00:12.0-2/input1
[   19.846739] random: crng init done
[   19.864178] device-mapper: uevent: version 1.0.3
[   19.864452] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28) initialised: dm-devel@redhat.com
[   29.144482] BTRFS: device label gehaim devid 1 transid 53810 /dev/dm-0 scanned by (udev-worker) (1213)
[   29.399621] BTRFS info (device nvme0n1p4: state M): use zstd compression, level 2
[   29.699898] Adding 8388604k swap on /dev/nvme0n1p2.  Priority:-2 extents:1 across:8388604k SSFS
[   29.782336] BTRFS info (device dm-0): using xxhash64 (xxhash64-generic) checksum algorithm
[   29.782353] BTRFS info (device dm-0): use zstd compression, level 1
[   29.782359] BTRFS info (device dm-0): using free space tree
[   29.823600] BTRFS info (device dm-0): enabling ssd optimizations
[   29.826478] BTRFS info (device nvme0n1p6): using xxhash64 (xxhash64-generic) checksum algorithm
[   29.826503] BTRFS info (device nvme0n1p6): setting nodatasum
[   29.826508] BTRFS info (device nvme0n1p6): using free space tree
[   29.830089] BTRFS info (device nvme0n1p6): enabling ssd optimizations
[   29.830098] BTRFS info (device nvme0n1p6): auto enabling async discard
[   31.125509] alg: No test for hmac(md4) (hmac(md4-generic))
[   31.219719] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   31.235652] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   32.484444] Bluetooth: Core ver 2.22
[   32.484484] NET: Registered PF_BLUETOOTH protocol family
[   32.484486] Bluetooth: HCI device and connection manager initialized
[   32.484491] Bluetooth: HCI socket layer initialized
[   32.484494] Bluetooth: L2CAP socket layer initialized
[   32.484498] Bluetooth: SCO socket layer initialized
[   32.491299] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   32.491303] Bluetooth: BNEP filters: protocol multicast
[   32.491308] Bluetooth: BNEP socket layer initialized
[   35.055941] zram: Added device: zram0
[   35.056346] zram: Added device: zram1
[   35.056751] zram: Added device: zram2
[   35.116831] zram2: detected capacity change from 0 to 50331648
[   35.538839] BTRFS: device label var_tmp_dir devid 1 transid 6 /dev/zram2 scanned by mkfs.btrfs (2413)
[   35.542437] BTRFS info (device zram2): using crc32c (crc32c-intel) checksum algorithm
[   35.542446] BTRFS info (device zram2): setting nodatasum
[   35.542449] BTRFS info (device zram2): using free space tree
[   35.544429] BTRFS info (device zram2): enabling ssd optimizations
[   35.544439] BTRFS info (device zram2): auto enabling async discard
[   35.544581] BTRFS info (device zram2): checking UUID tree
[   38.569662] fuse: init (API version 7.38)
[   38.843722] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=2526 'mate-session-ch'
[   39.076695] ------------[ cut here ]------------
[   39.076713] NETDEV WATCHDOG: enp6s0 (alx): transmit queue 1 timed out
[   39.076781] WARNING: CPU: 4 PID: 0 at net/sched/sch_generic.c:526 dev_watchdog+0x1a8/0x1b0

--MP_/qGsmkL08Pmg2IKPTTFi04pT--
