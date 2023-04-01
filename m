Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE106D30B9
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 14:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDAMVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Apr 2023 08:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjDAMVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Apr 2023 08:21:42 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79BE191F6;
        Sat,  1 Apr 2023 05:21:37 -0700 (PDT)
Received: from smtp202.mailbox.org (unknown [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Ppbqc4zxqz9sZS;
        Sat,  1 Apr 2023 14:21:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1680351692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YB7WMT8+CRRXycg//lYm/tkD2l7BkIb1HMbLzCo/FQg=;
        b=s5ldTFDSLJjxzyqCDzjJg1mltHSlEHMFAmHD2ZBzjeacSn4aA6j1DJr/MqaAfTq8XYTRll
        TZmIQ/bhIsaIPCdPOmEPFNs3JHl+JUIpjLQMu0iCuvtparp2UXmMzC2+hKV8enB6SYRFE/
        Pmrm3VJ7y1MLaZhjdO3J5QrCN4Y3mKkYlxD8uVY2z7HdlkFMPJdh0tEQ/8kN2LvT/tQRXv
        hX1qLjfCkl3Tnh2tgEOfycAMzPd4BPGk1HW5F8KVMXx0l9UVAQ2cH1CCZNjhPVZCAbQO0F
        fs4ToYNTXluq88LYbniXWRMVmc9iARw225a+V2CPgT7ZyQrl+EK/GdDneUxtPQ==
Date:   Sat, 1 Apr 2023 14:21:29 +0200
From:   "Erhard F." <erhard_f@mailbox.org>
To:     linux-usb@vger.kernel.org
Cc:     Chris Snook <chris.snook@gmail.com>, stable@vger.kernel.org
Subject: Re: When VIA VL805/806 xHCI USB 3.0 Controller is present Atheros
 E2400 (alx) ethernet does not work: NETDEV WATCHDOG: enp5s0 (alx): transmit
 queue 2 timed out
Message-ID: <20230401142129.1a8be0ed@yea>
In-Reply-To: <29514574-295a-3144-4779-396293d50964@linux.intel.com>
References: <20230319013706.016d96b2@yea>
        <d14a6e71-d7da-db8d-f901-52d6cdf1fa1d@linux.intel.com>
        <20230326175851.6d1c7000@yea>
        <29514574-295a-3144-4779-396293d50964@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/IT3ol7I_c3AMb/QIhmgGTvH"
X-MBO-RS-ID: 5588f99dfd3de269cc5
X-MBO-RS-META: 9wbgs4g5wwkthzi3eqsnskm1soa89zhx
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--MP_/IT3ol7I_c3AMb/QIhmgGTvH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 29 Mar 2023 12:51:37 +0300
Mathias Nyman <mathias.nyman@linux.intel.com> wrote:

> There is also a IOMMU entry in the log at the same time driver starts resetting the xHC.
> There have been some other hosts that triggered IOMMU issues when host tried to access a partial
> 64 bit DMA address immediately after driver wrote first 32 bits.
> 
> Did this VIA xHC work with any older kernel, if yes, any chance you could bisect this?  

Not as long I got this machine about 3 yrs ago. But I did notice the issue at that time and my 'solution' was to put a different Renesas chipset based PCIe card in for USB 3 and disable the onboard VIA one. Now as I needed this PCIe USB-card on another machine I stumbled over this issue again...

But I can try to check out if it works on an older LTS kernel anyway and start a bisect from there on. This will take some time of course... Would there be a particularly good starting point for an older kernel? Please let me know if yes.

> Also possible that this host would work with a 32 bit DMA mask, hack:
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 6183ce8574b1..e5b7700a807f 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -5408,7 +5408,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>   
>          /* Set dma_mask and coherent_dma_mask to 64-bits,
>           * if xHC supports 64-bit addressing */
> -       if (HCC_64BIT_ADDR(xhci->hcc_params) &&
> +       if (0 && HCC_64BIT_ADDR(xhci->hcc_params) &&
>                          !dma_set_mask(dev, DMA_BIT_MASK(64))) {
>                  xhci_dbg(xhci, "Enabling 64-bit DMA addresses.\n");
>                  dma_set_coherent_mask(dev, DMA_BIT_MASK(64));  

Thanks for taking a look Mathias!

Unfortunately this 32 bit DMA mask hack does not work out either, the issue still persists. dmesg attached.

Regards,
Erhard

--MP_/IT3ol7I_c3AMb/QIhmgGTvH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg_63-rc4.txt

[    0.000000] Linux version 6.3.0-rc4-bdver2-dirty (root@outsider) (clang version 15.0.7, LLD 15.0.7) #3 SMP Sat Apr  1 13:41:10 CEST 2023
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc4-bdver2-dirty root=/dev/nvme0n1p4 ro psmouse.synaptics_intertouch=1 zswap.max_pool_percent=16 zswap.zpool=z3fold slub_debug=FZP page_poison=1 netconsole=6666@10.0.0.14/eth0,6666@10.0.0.3/70:85:C2:30:EC:01
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
[    0.000000] tsc: Detected 4018.382 MHz processor
[    0.000997] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.001021] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.001043] last_pfn = 0x82f000 max_arch_pfn = 0x400000000
[    0.001062] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.001722] e820: update [mem 0xcf800000-0xffffffff] usable ==> reserved
[    0.001729] last_pfn = 0xcf800 max_arch_pfn = 0x400000000
[    0.001748] Using GB pages for direct mapping
[    0.002484] Secure boot disabled
[    0.002487] ACPI: Early table checksum verification disabled
[    0.002490] ACPI: RSDP 0x00000000CE249000 000024 (v02 ALASKA)
[    0.002494] ACPI: XSDT 0x00000000CE249070 00005C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.002499] ACPI: FACP 0x00000000CE24E998 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.002504] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has valid Length but zero Address: 0x0000000000000000/0x1 (20221020/tbfadt-615)
[    0.002508] ACPI: DSDT 0x00000000CE249158 005839 (v02 ALASKA A M I    00000088 INTL 20051117)
[    0.002512] ACPI: FACS 0x00000000CE63BF80 000040
[    0.002514] ACPI: APIC 0x00000000CE24EA90 00009E (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.002517] ACPI: FPDT 0x00000000CE24EB30 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.002520] ACPI: MCFG 0x00000000CE24EB78 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.002523] ACPI: HPET 0x00000000CE24EBB8 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.002525] ACPI: SSDT 0x00000000CE24EBF0 001714 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.002528] ACPI: IVRS 0x00000000CE250308 0000D8 (v01 AMD    RD890S   00202031 AMD  00000000)
[    0.002531] ACPI: Reserving FACP table memory at [mem 0xce24e998-0xce24ea8b]
[    0.002532] ACPI: Reserving DSDT table memory at [mem 0xce249158-0xce24e990]
[    0.002534] ACPI: Reserving FACS table memory at [mem 0xce63bf80-0xce63bfbf]
[    0.002535] ACPI: Reserving APIC table memory at [mem 0xce24ea90-0xce24eb2d]
[    0.002536] ACPI: Reserving FPDT table memory at [mem 0xce24eb30-0xce24eb73]
[    0.002537] ACPI: Reserving MCFG table memory at [mem 0xce24eb78-0xce24ebb3]
[    0.002538] ACPI: Reserving HPET table memory at [mem 0xce24ebb8-0xce24ebef]
[    0.002539] ACPI: Reserving SSDT table memory at [mem 0xce24ebf0-0xce250303]
[    0.002540] ACPI: Reserving IVRS table memory at [mem 0xce250308-0xce2503df]
[    0.002583] Zone ranges:
[    0.002584]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.002586]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.002587]   Normal   [mem 0x0000000100000000-0x000000082effffff]
[    0.002589] Movable zone start for each node
[    0.002589] Early memory node ranges
[    0.002590]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.002592]   node   0: [mem 0x0000000000100000-0x00000000ce1fefff]
[    0.002593]   node   0: [mem 0x00000000cf156000-0x00000000cf156fff]
[    0.002594]   node   0: [mem 0x00000000cf35d000-0x00000000cf7fffff]
[    0.002595]   node   0: [mem 0x0000000100001000-0x000000082effffff]
[    0.002598] Initmem setup node 0 [mem 0x0000000000001000-0x000000082effffff]
[    0.002605] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.002651] On node 0, zone DMA: 96 pages in unavailable ranges
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
[    0.003333] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc4-bdver2-dirty root=/dev/nvme0n1p4 ro psmouse.synaptics_intertouch=1 zswap.max_pool_percent=16 zswap.zpool=z3fold slub_debug=FZP page_poison=1 netconsole=6666@10.0.0.14/eth0,6666@10.0.0.3/70:85:C2:30:EC:01
[    0.003333] Unknown kernel command line parameters "BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc4-bdver2-dirty", will be passed to user space.
[    0.003333] printk: log_buf_len individual max cpu contribution: 8192 bytes
[    0.003333] printk: log_buf_len total cpu_extra contributions: 57344 bytes
[    0.003333] printk: log_buf_len min size: 65536 bytes
[    0.003333] printk: log_buf_len: 131072 bytes
[    0.003333] printk: early log buf free: 57008(86%)
[    0.003333] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes, linear)
[    0.003333] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes, linear)
[    0.003333] mem auto-init: stack:all(pattern), heap alloc:off, heap free:off
[    0.003333] software IO TLB: area num 8.
[    0.003333] Memory: 3375148K/33511684K available (10240K kernel code, 631K rwdata, 2388K rodata, 1060K init, 1540K bss, 846536K reserved, 0K cma-reserved)
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
[    0.003333] kfence: initialized - using 2097152 bytes for 255 objects at 0xffff924e8ba00000-0xffff924e8bc00000
[    0.003333] Console: colour dummy device 80x25
[    0.003333] printk: console [tty0] enabled
[    0.003333] ACPI: Core revision 20221020
[    0.003333] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.003333] APIC: Switch to symmetric I/O mode setup
[    0.003333] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.003333] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x39ec31fcc61, max_idle_ns: 440795388079 ns
[    0.643336] Calibrating delay loop (skipped), value calculated using timer frequency.. 8039.62 BogoMIPS (lpj=13394606)
[    0.643341] pid_max: default: 32768 minimum: 301
[    0.680938] LSM: initializing lsm=capability,yama
[    0.680950] Yama: becoming mindful.
[    0.681155] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.681295] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.681741] LVT offset 1 assigned for vector 0xf9
[    0.681749] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.681752] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
[    0.681758] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.681764] Spectre V2 : Mitigation: Retpolines
[    0.681766] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.681769] Spectre V2 : Spectre v2 / SpectreRSB : Filling RSB on VMEXIT
[    0.681771] Spectre V2 : Enabling Speculation Barrier for firmware calls
[    0.681773] RETBleed: Mitigation: untrained return thunk
[    0.681777] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.681782] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.685462] Freeing SMP alternatives memory: 32K
[    0.792415] smpboot: CPU0: AMD FX-8370 Eight-Core Processor (family: 0x15, model: 0x2, stepping: 0x0)
[    0.792658] cblist_init_generic: Setting adjustable number of callback queues.
[    0.792663] cblist_init_generic: Setting shift to 3 and lim to 1.
[    0.792692] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.792713] ... version:                0
[    0.792715] ... bit width:              48
[    0.792717] ... generic registers:      6
[    0.792719] ... value mask:             0000ffffffffffff
[    0.792722] ... max period:             00007fffffffffff
[    0.792724] ... fixed-purpose events:   0
[    0.792726] ... event mask:             000000000000003f
[    0.792820] rcu: Hierarchical SRCU implementation.
[    0.792823] rcu: 	Max phase no-delay instances is 1000.
[    0.792895] MCE: In-kernel MCE decoding enabled.
[    0.792970] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.793120] smp: Bringing up secondary CPUs ...
[    0.793276] x86: Booting SMP configuration:
[    0.793278] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.855683] smp: Brought up 1 node, 8 CPUs
[    0.855683] smpboot: Max logical packages: 1
[    0.855683] smpboot: Total of 8 processors activated (64319.03 BogoMIPS)
[    4.452535] node 0 deferred pages initialised in 3594ms
[    4.469790] allocated 67108864 bytes of page_ext
[    4.470158] devtmpfs: initialized
[    4.470274] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    4.470274] futex hash table entries: 2048 (order: 5, 131072 bytes, linear)
[    4.470394] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    4.470771] thermal_sys: Registered thermal governor 'step_wise'
[    4.470772] thermal_sys: Registered thermal governor 'user_space'
[    4.470792] cpuidle: using governor menu
[    4.470819] PCI: Using configuration type 1 for base access
[    4.470819] PCI: Using configuration type 1 for extended access
[    4.470819] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    4.470819] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    4.470819] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    4.470819] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    4.526670] raid6: sse2x4   gen()  9789 MB/s
[    4.583335] raid6: sse2x2   gen()  8385 MB/s
[    4.640005] raid6: sse2x1   gen()  6903 MB/s
[    4.640008] raid6: using algorithm sse2x4 gen() 9789 MB/s
[    4.696671] raid6: .... xor() 4103 MB/s, rmw enabled
[    4.696674] raid6: using ssse3x2 recovery algorithm
[    4.696838] ACPI: Added _OSI(Module Device)
[    4.696841] ACPI: Added _OSI(Processor Device)
[    4.696843] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.696846] ACPI: Added _OSI(Processor Aggregator Device)
[    4.709361] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    4.712160] ACPI: Interpreter enabled
[    4.712171] ACPI: PM: (supports S0 S5)
[    4.712173] ACPI: Using IOAPIC for interrupt routing
[    4.712512] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    4.712516] PCI: Using E820 reservations for host bridge windows
[    4.713032] ACPI: Enabled 10 GPEs in block 00 to 1F
[    4.728316] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    4.728326] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    4.728339] acpi PNP0A08:00: _OSC: OS requested [PME AER PCIeCapability LTR]
[    4.728343] acpi PNP0A08:00: _OSC: platform willing to grant [PME AER PCIeCapability LTR]
[    4.728347] acpi PNP0A08:00: _OSC: platform retains control of PCIe features (AE_NOT_FOUND)
[    4.728825] PCI host bridge to bus 0000:00
[    4.728829] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    4.728833] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    4.728837] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    4.728841] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    4.728845] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000dffff window]
[    4.728849] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xffffffff window]
[    4.728853] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.728884] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    4.729031] pci 0000:00:00.2: [1002:5a23] type 00 class 0x080600
[    4.729180] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    4.729199] pci 0000:00:02.0: enabling Extended Tags
[    4.729228] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    4.729376] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    4.729395] pci 0000:00:04.0: enabling Extended Tags
[    4.729422] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    4.729549] pci 0000:00:06.0: [1002:5a1a] type 01 class 0x060400
[    4.729567] pci 0000:00:06.0: enabling Extended Tags
[    4.729594] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    4.729716] pci 0000:00:09.0: [1002:5a1c] type 01 class 0x060400
[    4.729734] pci 0000:00:09.0: enabling Extended Tags
[    4.729761] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    4.729901] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    4.729916] pci 0000:00:11.0: reg 0x10: [io  0xf040-0xf047]
[    4.729925] pci 0000:00:11.0: reg 0x14: [io  0xf030-0xf033]
[    4.729934] pci 0000:00:11.0: reg 0x18: [io  0xf020-0xf027]
[    4.729942] pci 0000:00:11.0: reg 0x1c: [io  0xf010-0xf013]
[    4.729951] pci 0000:00:11.0: reg 0x20: [io  0xf000-0xf00f]
[    4.729960] pci 0000:00:11.0: reg 0x24: [mem 0xfeb0b000-0xfeb0b3ff]
[    4.730102] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    4.730117] pci 0000:00:12.0: reg 0x10: [mem 0xfeb0a000-0xfeb0afff]
[    4.730278] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    4.730293] pci 0000:00:12.2: reg 0x10: [mem 0xfeb09000-0xfeb090ff]
[    4.730357] pci 0000:00:12.2: supports D1 D2
[    4.730360] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    4.730490] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    4.730505] pci 0000:00:13.0: reg 0x10: [mem 0xfeb08000-0xfeb08fff]
[    4.730663] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    4.730678] pci 0000:00:13.2: reg 0x10: [mem 0xfeb07000-0xfeb070ff]
[    4.730741] pci 0000:00:13.2: supports D1 D2
[    4.730744] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    4.730857] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    4.731022] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    4.731039] pci 0000:00:14.2: reg 0x10: [mem 0xfeb00000-0xfeb03fff 64bit]
[    4.731094] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    4.731199] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    4.731393] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    4.731527] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    4.731542] pci 0000:00:14.5: reg 0x10: [mem 0xfeb06000-0xfeb06fff]
[    4.731706] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    4.731738] pci 0000:00:15.0: enabling Extended Tags
[    4.731777] pci 0000:00:15.0: supports D1 D2
[    4.731899] pci 0000:00:15.1: [1002:43a1] type 01 class 0x060400
[    4.731930] pci 0000:00:15.1: enabling Extended Tags
[    4.731970] pci 0000:00:15.1: supports D1 D2
[    4.732106] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    4.732121] pci 0000:00:16.0: reg 0x10: [mem 0xfeb05000-0xfeb05fff]
[    4.732269] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    4.732283] pci 0000:00:16.2: reg 0x10: [mem 0xfeb04000-0xfeb040ff]
[    4.732346] pci 0000:00:16.2: supports D1 D2
[    4.732350] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    4.732470] pci 0000:00:18.0: [1022:1600] type 00 class 0x060000
[    4.732539] pci 0000:00:18.1: [1022:1601] type 00 class 0x060000
[    4.732619] pci 0000:00:18.2: [1022:1602] type 00 class 0x060000
[    4.732685] pci 0000:00:18.3: [1022:1603] type 00 class 0x060000
[    4.732764] pci 0000:00:18.4: [1022:1604] type 00 class 0x060000
[    4.732832] pci 0000:00:18.5: [1022:1605] type 00 class 0x060000
[    4.732962] pci 0000:01:00.0: [1002:6758] type 00 class 0x030000
[    4.732979] pci 0000:01:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.732992] pci 0000:01:00.0: reg 0x18: [mem 0xfea20000-0xfea3ffff 64bit]
[    4.733001] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    4.733015] pci 0000:01:00.0: reg 0x30: [mem 0xfea00000-0xfea1ffff pref]
[    4.733023] pci 0000:01:00.0: enabling Extended Tags
[    4.733044] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    4.733080] pci 0000:01:00.0: supports D1 D2
[    4.733177] pci 0000:01:00.1: [1002:aa90] type 00 class 0x040300
[    4.733195] pci 0000:01:00.1: reg 0x10: [mem 0xfea40000-0xfea43fff 64bit]
[    4.733230] pci 0000:01:00.1: enabling Extended Tags
[    4.733279] pci 0000:01:00.1: supports D1 D2
[    4.733396] pci 0000:00:02.0: PCI bridge to [bus 01]
[    4.733402] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    4.733406] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    4.733410] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.733466] pci 0000:02:00.0: [1b21:2142] type 00 class 0x0c0330
[    4.733484] pci 0000:02:00.0: reg 0x10: [mem 0xfe900000-0xfe907fff 64bit]
[    4.733522] pci 0000:02:00.0: enabling Extended Tags
[    4.733581] pci 0000:02:00.0: PME# supported from D0
[    4.733612] pci 0000:02:00.0: 8.000 Gb/s available PCIe bandwidth, limited by 5.0 GT/s PCIe x2 link at 0000:00:04.0 (capable of 15.752 Gb/s with 8.0 GT/s PCIe x2 link)
[    4.733696] pci 0000:00:04.0: PCI bridge to [bus 02]
[    4.733702] pci 0000:00:04.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    4.733764] pci 0000:03:00.0: [15b7:5009] type 00 class 0x010802
[    4.733783] pci 0000:03:00.0: reg 0x10: [mem 0xfe800000-0xfe803fff 64bit]
[    4.733807] pci 0000:03:00.0: reg 0x20: [mem 0xfe804000-0xfe8040ff 64bit]
[    4.733926] pci 0000:03:00.0: 8.000 Gb/s available PCIe bandwidth, limited by 5.0 GT/s PCIe x2 link at 0000:00:06.0 (capable of 31.504 Gb/s with 8.0 GT/s PCIe x4 link)
[    4.734030] pci 0000:00:06.0: PCI bridge to [bus 03]
[    4.734035] pci 0000:00:06.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    4.734121] pci 0000:04:00.0: [1b21:1343] type 00 class 0x0c0330
[    4.734140] pci 0000:04:00.0: reg 0x10: [mem 0xfe700000-0xfe707fff 64bit]
[    4.734178] pci 0000:04:00.0: enabling Extended Tags
[    4.734243] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    4.734422] pci 0000:00:09.0: PCI bridge to [bus 04]
[    4.734428] pci 0000:00:09.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    4.734441] pci_bus 0000:05: extended config space not accessible
[    4.734500] pci 0000:00:14.4: PCI bridge to [bus 05] (subtractive decode)
[    4.734509] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af window] (subtractive decode)
[    4.734514] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7 window] (subtractive decode)
[    4.734518] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df window] (subtractive decode)
[    4.734522] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    4.734527] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000dffff window] (subtractive decode)
[    4.734531] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xffffffff window] (subtractive decode)
[    4.734600] pci 0000:06:00.0: [1969:e0a1] type 00 class 0x020000
[    4.734627] pci 0000:06:00.0: reg 0x10: [mem 0xfe600000-0xfe63ffff 64bit]
[    4.734639] pci 0000:06:00.0: reg 0x18: [io  0xd000-0xd07f]
[    4.734698] pci 0000:06:00.0: [Firmware Bug]: disabling VPD access (can't determine size of non-standard VPD format)
[    4.734757] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.734883] pci 0000:00:15.0: PCI bridge to [bus 06]
[    4.734889] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    4.734893] pci 0000:00:15.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    4.734957] pci 0000:07:00.0: [1106:3483] type 00 class 0x0c0330
[    4.734978] pci 0000:07:00.0: reg 0x10: [mem 0xfe500000-0xfe500fff 64bit]
[    4.735069] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.735157] pci 0000:00:15.1: PCI bridge to [bus 07]
[    4.735164] pci 0000:00:15.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    4.735193] pci_bus 0000:00: on NUMA node 0
[    4.736091] ACPI: PCI: Interrupt link LNKA configured for IRQ 0
[    4.736250] ACPI: PCI: Interrupt link LNKB configured for IRQ 0
[    4.736415] ACPI: PCI: Interrupt link LNKC configured for IRQ 0
[    4.736580] ACPI: PCI: Interrupt link LNKD configured for IRQ 0
[    4.736723] ACPI: PCI: Interrupt link LNKE configured for IRQ 0
[    4.736836] ACPI: PCI: Interrupt link LNKF configured for IRQ 0
[    4.736948] ACPI: PCI: Interrupt link LNKG configured for IRQ 0
[    4.737066] ACPI: PCI: Interrupt link LNKH configured for IRQ 0
[    4.737315] iommu: Default domain type: Translated 
[    4.737318] iommu: DMA domain TLB invalidation policy: lazy mode 
[    4.737495] SCSI subsystem initialized
[    4.737525] libata version 3.00 loaded.
[    4.737558] EDAC MC: Ver: 3.0.0
[    4.737674] efivars: Registered efivars operations
[    4.737674] PCI: Using ACPI for IRQ routing
[    4.737674] PCI: pci_cache_line_size set to 64 bytes
[    4.737674] e820: reserve RAM buffer [mem 0xce1ff000-0xcfffffff]
[    4.737674] e820: reserve RAM buffer [mem 0xcf157000-0xcfffffff]
[    4.737674] e820: reserve RAM buffer [mem 0xcf800000-0xcfffffff]
[    4.737674] e820: reserve RAM buffer [mem 0x82f000000-0x82fffffff]
[    4.737674] pci 0000:01:00.0: vgaarb: setting as boot VGA device
[    4.737674] pci 0000:01:00.0: vgaarb: bridge control possible
[    4.737674] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    4.737674] vgaarb: loaded
[    4.737674] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    4.737674] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    4.740075] clocksource: Switched to clocksource tsc-early
[    4.740388] pnp: PnP ACPI init
[    4.740543] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    4.741115] system 00:01: [io  0x040b] has been reserved
[    4.741120] system 00:01: [io  0x04d6] has been reserved
[    4.741124] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    4.741128] system 00:01: [io  0x0c14] has been reserved
[    4.741132] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    4.741136] system 00:01: [io  0x0c52] has been reserved
[    4.741140] system 00:01: [io  0x0c6c] has been reserved
[    4.741144] system 00:01: [io  0x0c6f] has been reserved
[    4.741147] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    4.741151] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    4.741161] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    4.741165] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    4.741168] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    4.741172] system 00:01: [io  0x0800-0x089f] has been reserved
[    4.741176] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    4.741180] system 00:01: [io  0x0900-0x090f] has been reserved
[    4.741184] system 00:01: [io  0x0910-0x091f] has been reserved
[    4.741187] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    4.741193] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    4.741198] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    4.741206] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    4.741211] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    4.741216] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    4.741221] system 00:01: [mem 0xfed00000-0xfed00fff] could not be reserved
[    4.741226] system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
[    4.741573] system 00:02: [io  0x0220-0x0227] has been reserved
[    4.741578] system 00:02: [io  0x0228-0x0237] has been reserved
[    4.741582] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    4.742127] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    4.742453] system 00:06: [mem 0xfeb20000-0xfeb23fff] has been reserved
[    4.742677] system 00:07: [mem 0xfec20000-0xfec200ff] could not be reserved
[    4.742936] pnp: PnP ACPI: found 8 devices
[    4.750410] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    4.750470] NET: Registered PF_INET protocol family
[    4.751053] IP idents hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    4.754249] tcp_listen_portaddr_hash hash table entries: 16384 (order: 7, 524288 bytes, linear)
[    4.754354] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    4.754767] TCP established hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    4.755762] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes, linear)
[    4.756724] TCP: Hash tables configured (established 262144 bind 65536)
[    4.757240] UDP hash table entries: 16384 (order: 8, 1572864 bytes, linear)
[    4.757776] UDP-Lite hash table entries: 16384 (order: 8, 1572864 bytes, linear)
[    4.757971] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    4.758004] pci 0000:00:02.0: PCI bridge to [bus 01]
[    4.758010] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    4.758015] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    4.758019] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.758025] pci 0000:00:04.0: PCI bridge to [bus 02]
[    4.758029] pci 0000:00:04.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    4.758034] pci 0000:00:06.0: PCI bridge to [bus 03]
[    4.758038] pci 0000:00:06.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    4.758044] pci 0000:00:09.0: PCI bridge to [bus 04]
[    4.758047] pci 0000:00:09.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    4.758053] pci 0000:00:14.4: PCI bridge to [bus 05]
[    4.758063] pci 0000:00:15.0: PCI bridge to [bus 06]
[    4.758066] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    4.758071] pci 0000:00:15.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    4.758078] pci 0000:00:15.1: PCI bridge to [bus 07]
[    4.758083] pci 0000:00:15.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    4.758091] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    4.758095] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    4.758098] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    4.758101] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    4.758105] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000dffff window]
[    4.758108] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xffffffff window]
[    4.758111] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    4.758114] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    4.758117] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.758121] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    4.758124] pci_bus 0000:03: resource 1 [mem 0xfe800000-0xfe8fffff]
[    4.758128] pci_bus 0000:04: resource 1 [mem 0xfe700000-0xfe7fffff]
[    4.758131] pci_bus 0000:05: resource 4 [io  0x0000-0x03af window]
[    4.758134] pci_bus 0000:05: resource 5 [io  0x03e0-0x0cf7 window]
[    4.758137] pci_bus 0000:05: resource 6 [io  0x03b0-0x03df window]
[    4.758140] pci_bus 0000:05: resource 7 [io  0x0d00-0xffff window]
[    4.758143] pci_bus 0000:05: resource 8 [mem 0x000a0000-0x000dffff window]
[    4.758146] pci_bus 0000:05: resource 9 [mem 0xd0000000-0xffffffff window]
[    4.758150] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    4.758153] pci_bus 0000:06: resource 1 [mem 0xfe600000-0xfe6fffff]
[    4.758156] pci_bus 0000:07: resource 1 [mem 0xfe500000-0xfe5fffff]
[    4.760198] pci 0000:01:00.1: D0 power state depends on 0000:01:00.0
[    4.760208] pci 0000:02:00.0: PME# does not work under D0, disabling it
[    4.760994] PCI: CLS 64 bytes, default 64
[    4.761074] AMD-Vi: Using global IVHD EFR:0x0, EFR2:0x0
[    4.762403] pci 0000:00:00.0: Adding to iommu group 0
[    4.762429] pci 0000:00:02.0: Adding to iommu group 1
[    4.762449] pci 0000:00:04.0: Adding to iommu group 2
[    4.762469] pci 0000:00:06.0: Adding to iommu group 3
[    4.762493] pci 0000:00:09.0: Adding to iommu group 4
[    4.762513] pci 0000:00:11.0: Adding to iommu group 5
[    4.762546] pci 0000:00:12.0: Adding to iommu group 6
[    4.762567] pci 0000:00:12.2: Adding to iommu group 6
[    4.762608] pci 0000:00:13.0: Adding to iommu group 7
[    4.762626] pci 0000:00:13.2: Adding to iommu group 7
[    4.762651] pci 0000:00:14.0: Adding to iommu group 8
[    4.762676] pci 0000:00:14.2: Adding to iommu group 9
[    4.762711] pci 0000:00:14.3: Adding to iommu group 10
[    4.762731] pci 0000:00:14.4: Adding to iommu group 11
[    4.762755] pci 0000:00:14.5: Adding to iommu group 12
[    4.762788] pci 0000:00:15.0: Adding to iommu group 13
[    4.762807] pci 0000:00:15.1: Adding to iommu group 13
[    4.762840] pci 0000:00:16.0: Adding to iommu group 14
[    4.762864] pci 0000:00:16.2: Adding to iommu group 14
[    4.762908] pci 0000:01:00.0: Adding to iommu group 15
[    4.762930] pci 0000:01:00.1: Adding to iommu group 15
[    4.762950] pci 0000:02:00.0: Adding to iommu group 16
[    4.762975] pci 0000:03:00.0: Adding to iommu group 17
[    4.762996] pci 0000:04:00.0: Adding to iommu group 18
[    4.763005] pci 0000:06:00.0: Adding to iommu group 13
[    4.763014] pci 0000:07:00.0: Adding to iommu group 13
[    4.770547] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    4.770673] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.770676] software IO TLB: mapped [mem 0x00000000bf076000-0x00000000c3076000] (64MB)
[    4.770723] LVT offset 0 assigned for vector 0x400
[    4.770803] perf: AMD IBS detected (0x000000ff)
[    4.771360] Initialise system trusted keyrings
[    4.771430] workingset: timestamp_bits=46 max_order=23 bucket_order=0
[    4.771898] NET: Registered PF_ALG protocol family
[    4.771902] xor: automatically using best checksumming function   avx       
[    4.771906] Key type asymmetric registered
[    4.771909] Asymmetric key parser 'x509' registered
[    4.773312] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.773373] io scheduler kyber registered
[    4.775892] IPMI message handler: version 39.2
[    4.777360] ahci 0000:00:11.0: version 3.0
[    4.777447] nvme nvme0: pci function 0000:03:00.0
[    4.777554] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    4.777562] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    4.778010] scsi host0: ahci
[    4.778247] scsi host1: ahci
[    4.778338] ata1: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b100 irq 19
[    4.778343] ata2: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b180 irq 19
[    4.789272] alx 0000:06:00.0 eth0: Qualcomm Atheros AR816x/AR817x Ethernet [1c:1b:0d:93:c2:07]
[    4.789343] rtc_cmos 00:03: RTC can wake from S4
[    4.789613] rtc_cmos 00:03: registered as rtc0
[    4.789628] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.789731] simple-framebuffer simple-framebuffer.0: framebuffer at 0xd0000000, 0x300000 bytes
[    4.789737] simple-framebuffer simple-framebuffer.0: format=x8r8g8b8, mode=1024x768x32, linelength=4096
[    4.792051] Console: switching to colour frame buffer device 128x48
[    4.792927] nvme nvme0: allocated 32 MiB host memory buffer.
[    4.794146] nvme nvme0: 8/0/0 default/read/poll queues
[    4.794153] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
[    4.794409] NET: Registered PF_INET6 protocol family
[    4.795181] Segment Routing with IPv6
[    4.795236] In-situ OAM (IOAM) with IPv6
[    4.795298] NET: Registered PF_PACKET protocol family
[    4.796162] microcode: microcode updated early to new patch_level=0x06000852
[    4.796245] microcode: CPU0: patch_level=0x06000852
[    4.796245] microcode: CPU1: patch_level=0x06000852
[    4.796250] microcode: CPU2: patch_level=0x06000852
[    4.796250] microcode: CPU4: patch_level=0x06000852
[    4.796253] microcode: CPU7: patch_level=0x06000852
[    4.796316] microcode: CPU6: patch_level=0x06000852
[    4.796329] microcode: CPU3: patch_level=0x06000852
[    4.796337] microcode: CPU5: patch_level=0x06000852
[    4.796424] microcode: Microcode Update Driver: v2.2.
[    4.796429] IPI shorthand broadcast: enabled
[    4.799049]  nvme0n1: p1 p2 p3 p4 p5 p6
[    4.799567] sched_clock: Marking stable (4174404012, 623334757)->(4810443929, -12705160)
[    4.799759] registered taskstats version 1
[    4.800004] Loading compiled-in X.509 certificates
[    4.805919] zswap: loaded using pool zstd/z3fold
[    4.811048] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
[    5.089777] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    5.091356] ata1.00: ATA-9: HP SSD S700 Pro 1TB, R0201B, max UDMA/100
[    5.092208] ata1.00: 2000409264 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    5.093374] ata1.00: Features: Dev-Sleep
[    5.094630] ata1.00: configured for UDMA/100
[    5.095609] scsi 0:0:0:0: Direct-Access     ATA      HP SSD S700 Pro  1B   PQ: 0 ANSI: 5
[    5.097079] sd 0:0:0:0: [sda] 2000409264 512-byte logical blocks: (1.02 TB/954 GiB)
[    5.097882] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    5.098718] sd 0:0:0:0: [sda] Write Protect is off
[    5.099536] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.099551] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.100378] sd 0:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
[    5.102949]  sda: sda1
[    5.103871] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    5.196952] Btrfs loaded, crc32c=crc32c-intel, zoned=no, fsverity=no
[    5.296690] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.300749] ata2.00: ATAPI: PIONEER BD-RW   BDR-208D, 1.50, max UDMA/100
[    5.304982] ata2.00: configured for UDMA/100
[    5.316327] scsi 1:0:0:0: CD-ROM            PIONEER  BD-RW   BDR-208D 1.50 PQ: 0 ANSI: 5
[    5.378595] netpoll: netconsole: local port 6666
[    5.379405] netpoll: netconsole: local IPv4 address 10.0.0.14
[    5.380206] netpoll: netconsole: interface 'eth0'
[    5.380957] netpoll: netconsole: remote port 6666
[    5.381715] netpoll: netconsole: remote IPv4 address 10.0.0.3
[    5.382438] netpoll: netconsole: remote ethernet address 70:85:c2:30:ec:01
[    5.383188] netpoll: netconsole: device eth0 not up yet, forcing it
[    5.796676] tsc: Refined TSC clocksource calibration: 4018.616 MHz
[    5.797433] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x39ed0e5685d, max_idle_ns: 440795232051 ns
[    5.798242] clocksource: Switched to clocksource tsc
[    6.277093] alx 0000:06:00.0 eth0: NIC Up: 100 Mbps Full
[    6.278076] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    6.286821] printk: console [netcon0] enabled
[    6.292828] netconsole: network logging started
[    6.294581] BTRFS: device label bdver2_musl devid 1 transid 98267 /dev/root scanned by swapper/0 (1)
[    6.295628] BTRFS info (device nvme0n1p4): using xxhash64 (xxhash64-generic) checksum algorithm
[    6.296464] BTRFS info (device nvme0n1p4): using free space tree
[    6.303509] BTRFS info (device nvme0n1p4): enabling ssd optimizations
[    6.304331] BTRFS info (device nvme0n1p4): auto enabling async discard
[    6.305942] VFS: Mounted root (btrfs filesystem) readonly on device 0:16.
[    6.307266] devtmpfs: mounted
[    6.308469] Freeing unused kernel image (initmem) memory: 1060K
[    6.313359] Write protecting the kernel read-only data: 14336k
[    6.314756] Freeing unused kernel image (rodata/data gap) memory: 1708K
[    6.317897] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    6.318783] rodata_test: all tests were successful
[    6.319674] kallsyms_selftest: start
[    6.319678] Run /sbin/init as init process
[    6.321417]   with arguments:
[    6.321418]     /sbin/init
[    6.321419]   with environment:
[    6.321425]     HOME=/
[    6.321426]     TERM=linux
[    6.321427]     BOOT_IMAGE=/boot/vmlinuz-6.3.0-rc4-bdver2-dirty
[    7.846917] kallsyms_selftest:  ---------------------------------------------------------
[    7.847649] kallsyms_selftest: | nr_symbols | compressed size | original size | ratio(%) |
[    7.848357] kallsyms_selftest: |---------------------------------------------------------|
[    7.849106] kallsyms_selftest: |      34971 |        380964   |       655635  |  58.10   |
[    7.849869] kallsyms_selftest:  ---------------------------------------------------------
[    8.069428] kallsyms_selftest: kallsyms_lookup_name() looked up 34971 symbols
[    8.069434] kallsyms_selftest: The time spent on each symbol is (ns): min=843, max=26571, avg=6108
[    8.071632] ACPI: \_PR_.P001: Found 2 idle states
[    8.071872] ACPI: \_PR_.P002: Found 2 idle states
[    8.072081] ACPI: \_PR_.P003: Found 2 idle states
[    8.072288] ACPI: \_PR_.P004: Found 2 idle states
[    8.072526] ACPI: \_PR_.P005: Found 2 idle states
[    8.072723] ACPI: \_PR_.P006: Found 2 idle states
[    8.072932] ACPI: \_PR_.P007: Found 2 idle states
[    8.073568] kallsyms_selftest: kallsyms_on_each_symbol() traverse all: 4131594 ns
[    8.073582] kallsyms_selftest: kallsyms_on_each_match_symbol() traverse all: 8860 ns
[    8.073584] kallsyms_selftest: finish
[    8.084391] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    8.084400] ACPI: button: Power Button [PWRB]
[    8.085667] ACPI: \_PR_.P008: Found 2 idle states
[    8.086534] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    8.086577] ACPI: button: Power Button [PWRF]
[    8.092805] acpi_cpufreq: overriding BIOS provided _PSD data
[    8.096118] ACPI: bus type USB registered
[    8.098707] usbcore: registered new interface driver usbfs
[    8.101050] usbcore: registered new interface driver hub
[    8.101348] usbcore: registered new device driver usb
[    8.112804] ACPI: bus type drm_connector registered
[    8.122758] QUIRK: Enable AMD PLL fix
[    8.122790] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    8.123373] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 1
[    8.127254] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    8.127691] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 2
[    8.131044] xhci_hcd 0000:07:00.0: xHCI Host Controller
[    8.131567] xhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 3
[    8.136300] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    8.136315] piix4_smbus 0000:00:14.0: Using register 0x2c for SMBus port selection
[    8.150314] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    8.161670] alx 0000:06:00.0 enp6s0: renamed from eth0 (while UP)
[    8.177251] BTRFS info: devid 1 device path /dev/root changed to /dev/nvme0n1p4 scanned by (udev-worker) (683)
[    8.178393] xhci_hcd 0000:02:00.0: hcc params 0x0200ef80 hci version 0x110 quirks 0x0000000000800010
[    8.181334] cryptd: max_cpu_qlen set to 1000
[    8.183934] BTRFS: device label ubuntu devid 1 transid 878 /dev/nvme0n1p3 scanned by (udev-worker) (702)
[    8.186391] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    8.186409] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
[    8.186422] xhci_hcd 0000:02:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    8.186647] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[    8.186654] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.186659] usb usb1: Product: xHCI Host Controller
[    8.186664] usb usb1: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty xhci-hcd
[    8.186672] usb usb1: SerialNumber: 0000:02:00.0
[    8.186814] xhci_hcd 0000:04:00.0: hcc params 0x0200eec1 hci version 0x110 quirks 0x0000000000000010
[    8.187378] hub 1-0:1.0: USB hub found
[    8.187409] hub 1-0:1.0: 2 ports detected
[    8.187451] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    8.187965] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    8.188085] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 6.03
[    8.188091] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.188096] usb usb4: Product: xHCI Host Controller
[    8.188100] usb usb4: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty xhci-hcd
[    8.188104] usb usb4: SerialNumber: 0000:02:00.0
[    8.188778] hub 4-0:1.0: USB hub found
[    8.188825] hub 4-0:1.0: 2 ports detected
[    8.190347] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 5
[    8.190358] xhci_hcd 0000:04:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    8.190465] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[    8.190469] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.190472] usb usb2: Product: xHCI Host Controller
[    8.190474] usb usb2: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty xhci-hcd
[    8.190477] usb usb2: SerialNumber: 0000:04:00.0
[    8.190696] BTRFS: device label bisect_x86-64-v2 devid 1 transid 34534 /dev/nvme0n1p5 scanned by (udev-worker) (700)
[    8.190749] hub 2-0:1.0: USB hub found
[    8.190765] hub 2-0:1.0: 2 ports detected
[    8.190996] usb usb5: We don't know the algorithms for LPM for this host, disabling LPM.
[    8.191050] usb usb5: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 6.03
[    8.191054] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.191057] usb usb5: Product: xHCI Host Controller
[    8.191059] usb usb5: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty xhci-hcd
[    8.191062] usb usb5: SerialNumber: 0000:04:00.0
[    8.191765] hub 5-0:1.0: USB hub found
[    8.191781] hub 5-0:1.0: 2 ports detected
[    8.197871] BTRFS: device label distfiles devid 1 transid 47 /dev/nvme0n1p6 scanned by (udev-worker) (710)
[    8.304302] alx 0000:06:00.0 enp6s0: fatal interrupt 0x200, resetting
[    8.315525] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full
[   18.131598] xhci_hcd 0000:07:00.0: can't setup: -110
[   18.131617] xhci_hcd 0000:07:00.0: USB bus 3 deregistered
[   18.131645] xhci_hcd 0000:07:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000e address=0xce210880 flags=0x0000]
[   18.131740] ehci-pci 0000:00:12.2: EHCI Host Controller
[   18.131782] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 3
[   18.131813] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   18.131824] xhci_hcd 0000:07:00.0: init 0000:07:00.0 fail, -110
[   18.131832] xhci_hcd: probe of 0000:07:00.0 failed with error -110
[   18.131833] ehci-pci 0000:00:12.2: debug port 1
[   18.132018] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb09000
[   18.143400] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   18.143747] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[   18.143756] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.143761] usb usb3: Product: EHCI Host Controller
[   18.143767] usb usb3: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty ehci_hcd
[   18.143772] usb usb3: SerialNumber: 0000:00:12.2
[   18.144310] hub 3-0:1.0: USB hub found
[   18.144338] hub 3-0:1.0: 5 ports detected
[   18.145126] ehci-pci 0000:00:13.2: EHCI Host Controller
[   18.145138] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 6
[   18.145148] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   18.145159] ehci-pci 0000:00:13.2: debug port 1
[   18.145234] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb07000
[   18.160111] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   18.160359] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[   18.160368] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.160373] usb usb6: Product: EHCI Host Controller
[   18.160377] usb usb6: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty ehci_hcd
[   18.160380] usb usb6: SerialNumber: 0000:00:13.2
[   18.160738] hub 6-0:1.0: USB hub found
[   18.160769] hub 6-0:1.0: 5 ports detected
[   18.161322] ehci-pci 0000:00:16.2: EHCI Host Controller
[   18.161339] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 7
[   18.161373] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   18.161387] ehci-pci 0000:00:16.2: debug port 1
[   18.161485] ehci-pci 0000:00:16.2: irq 17, io mem 0xfeb04000
[   18.173420] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[   18.173697] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.03
[   18.173706] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.173712] usb usb7: Product: EHCI Host Controller
[   18.173717] usb usb7: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty ehci_hcd
[   18.173722] usb usb7: SerialNumber: 0000:00:16.2
[   18.174306] hub 7-0:1.0: USB hub found
[   18.174359] hub 7-0:1.0: 4 ports detected
[   18.182117] it87: Found IT8620E chip at 0x228, revision 4
[   18.182147] it87: Beeping is supported
[   18.182439] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   18.182458] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 8
[   18.182523] ohci-pci 0000:00:12.0: irq 18, io mem 0xfeb0a000
[   18.183183] AVX version of gcm_enc/dec engaged.
[   18.183272] AES CTR mode by8 optimization enabled
[   18.211744] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.212852] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   18.217007] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input2
[   18.224701] Asymmetric key parser 'pkcs8' registered
[   18.240423] [drm] radeon kernel modesetting enabled.
[   18.240809] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[   18.240817] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.240821] usb usb8: Product: OHCI PCI host controller
[   18.240824] usb usb8: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty ohci_hcd
[   18.240827] usb usb8: SerialNumber: 0000:00:12.0
[   18.241665] Console: switching to colour dummy device 80x25
[   18.242255] sr 1:0:0:0: [sr0] scsi3-mmc drive: 125x/125x writer cd/rw xa/form2 cdda tray
[   18.242262] cdrom: Uniform CD-ROM driver Revision: 3.20
[   18.242518] radeon 0000:01:00.0: vgaarb: deactivate vga console
[   18.244344] hub 8-0:1.0: USB hub found
[   18.244370] hub 8-0:1.0: 5 ports detected
[   18.246298] [drm] initializing kernel modesetting (TURKS 0x1002:0x6758 0x174B:0xE194 0x00).
[   18.246433] ATOM BIOS: TURKS
[   18.246592] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[   18.246596] radeon 0000:01:00.0: GTT: 1024M 0x0000000040000000 - 0x000000007FFFFFFF
[   18.246602] [drm] Detected VRAM RAM=1024M, BAR=256M
[   18.246604] [drm] RAM width 128bits DDR
[   18.246710] [drm] radeon: 1024M of VRAM memory ready
[   18.246713] [drm] radeon: 1024M of GTT memory ready.
[   18.246726] [drm] Loading TURKS Microcode
[   18.247419] ohci-pci 0000:00:13.0: OHCI PCI host controller
[   18.247433] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 9
[   18.247478] ohci-pci 0000:00:13.0: irq 18, io mem 0xfeb08000
[   18.247651] snd_hda_codec_realtek hdaudioC0D0: ALC1150: SKU not ready 0x00000000
[   18.248235] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC1150: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[   18.248240] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   18.248243] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   18.248247] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   18.248249] snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x11/0x1e
[   18.248251] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   18.248253] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[   18.248256] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[   18.248259] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[   18.250333] [drm] Internal thermal controller without fan control
[   18.255405] [drm] radeon: dpm initialized
[   18.257207] [drm] GART: num cpu pages 262144, num gpu pages 262144
[   18.258552] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[   18.266155] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input3
[   18.266314] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input4
[   18.266456] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[   18.266606] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input6
[   18.266879] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[   18.267174] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[   18.271788] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[   18.272376] [drm] PCIE GART of 1024M enabled (table at 0x0000000000162000).
[   18.272500] radeon 0000:01:00.0: WB enabled
[   18.272504] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00
[   18.272509] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c
[   18.273280] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000072118
[   18.274612] radeon 0000:01:00.0: radeon: MSI limited to 32-bit
[   18.279157] radeon 0000:01:00.0: radeon: using MSI.
[   18.279207] [drm] radeon: irq initialized.
[   18.288132] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   18.295842] [drm] ring test on 0 succeeded in 2 usecs
[   18.295856] [drm] ring test on 3 succeeded in 7 usecs
[   18.307525] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[   18.307532] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.307536] usb usb9: Product: OHCI PCI host controller
[   18.307539] usb usb9: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty ohci_hcd
[   18.307541] usb usb9: SerialNumber: 0000:00:13.0
[   18.307806] hub 9-0:1.0: USB hub found
[   18.307823] hub 9-0:1.0: 5 ports detected
[   18.308492] ohci-pci 0000:00:14.5: OHCI PCI host controller
[   18.308502] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 10
[   18.308546] ohci-pci 0000:00:14.5: irq 18, io mem 0xfeb06000
[   18.367603] usb usb10: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[   18.367615] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.367622] usb usb10: Product: OHCI PCI host controller
[   18.367627] usb usb10: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty ohci_hcd
[   18.367632] usb usb10: SerialNumber: 0000:00:14.5
[   18.368110] hub 10-0:1.0: USB hub found
[   18.368139] hub 10-0:1.0: 2 ports detected
[   18.369031] ohci-pci 0000:00:16.0: OHCI PCI host controller
[   18.369050] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 11
[   18.369118] ohci-pci 0000:00:16.0: irq 18, io mem 0xfeb05000
[   18.427603] usb usb11: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.03
[   18.427616] usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.427622] usb usb11: Product: OHCI PCI host controller
[   18.427628] usb usb11: Manufacturer: Linux 6.3.0-rc4-bdver2-dirty ohci_hcd
[   18.427632] usb usb11: SerialNumber: 0000:00:16.0
[   18.428093] hub 11-0:1.0: USB hub found
[   18.428122] hub 11-0:1.0: 4 ports detected
[   18.473026] [drm] ring test on 5 succeeded in 2 usecs
[   18.473037] [drm] UVD initialized successfully.
[   18.473292] snd_hda_intel 0000:01:00.1: bound 0000:01:00.0 (ops radeon_audio_component_bind_ops [radeon])
[   18.473886] [drm] ib test on ring 0 succeeded in 0 usecs
[   18.473979] [drm] ib test on ring 3 succeeded in 0 usecs
[   18.616744] usb 8-1: new low-speed USB device number 2 using ohci-pci
[   18.806821] usb 8-1: New USB device found, idVendor=046d, idProduct=c045, bcdDevice=27.30
[   18.806834] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   18.806841] usb 8-1: Product: USB-PS/2 Optical Mouse
[   18.806846] usb 8-1: Manufacturer: Logitech
[   18.847815] hid: raw HID events driver (C) Jiri Kosina
[   18.855245] usbcore: registered new interface driver usbhid
[   18.855250] usbhid: USB HID core driver
[   18.866133] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb8/8-1/8-1:1.0/0003:046D:C045.0001/input/input10
[   18.866372] hid-generic 0003:046D:C045.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-1/input0
[   19.130201] [drm] ib test on ring 5 succeeded
[   19.130217] stackdepot: allocating hash table of 1048576 entries via kvcalloc
[   19.136290] [drm] Radeon Display Connectors
[   19.136295] [drm] Connector 0:
[   19.136298] [drm]   DP-1
[   19.136301] [drm]   HPD5
[   19.136304] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[   19.136310] [drm]   Encoders:
[   19.136312] [drm]     DFP1: INTERNAL_UNIPHY1
[   19.136315] [drm] Connector 1:
[   19.136318] [drm]   HDMI-A-1
[   19.136320] [drm]   HPD1
[   19.136323] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[   19.136328] [drm]   Encoders:
[   19.136331] [drm]     DFP2: INTERNAL_UNIPHY2
[   19.136333] [drm] Connector 2:
[   19.136336] [drm]   DVI-I-1
[   19.136338] [drm]   HPD4
[   19.136341] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 0x645c
[   19.136346] [drm]   Encoders:
[   19.136348] [drm]     DFP3: INTERNAL_UNIPHY
[   19.136351] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   19.259208] [drm] fb mappable at 0xD0363000
[   19.259215] [drm] vram apper at 0xD0000000
[   19.259219] [drm] size 8294400
[   19.259222] [drm] fb depth is 24
[   19.259225] [drm]    pitch is 7680
[   19.259536] fbcon: radeondrmfb (fb0) is primary device
[   19.316752] usb 8-2: new low-speed USB device number 3 using ohci-pci
[   19.399748] Console: switching to colour frame buffer device 240x67
[   19.405185] radeon 0000:01:00.0: [drm] fb0: radeondrmfb frame buffer device
[   19.414633] [drm] Initialized radeon 2.50.0 20080528 for 0000:01:00.0 on minor 0
[   19.536815] usb 8-2: New USB device found, idVendor=1017, idProduct=1010, bcdDevice= 1.02
[   19.536829] usb 8-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[   19.536836] usb 8-2: Product: Gaming Keyboard
[   19.556691] input: Gaming Keyboard as /devices/pci0000:00/0000:00:12.0/usb8/8-2/8-2:1.0/0003:1017:1010.0002/input/input11
[   19.617012] hid-generic 0003:1017:1010.0002: input,hidraw1: USB HID v1.10 Keyboard [Gaming Keyboard] on usb-0000:00:12.0-2/input0
[   19.701011] input: Gaming Keyboard Mouse as /devices/pci0000:00/0000:00:12.0/usb8/8-2/8-2:1.1/0003:1017:1010.0003/input/input12
[   19.701361] input: Gaming Keyboard Consumer Control as /devices/pci0000:00/0000:00:12.0/usb8/8-2/8-2:1.1/0003:1017:1010.0003/input/input13
[   19.757089] input: Gaming Keyboard System Control as /devices/pci0000:00/0000:00:12.0/usb8/8-2/8-2:1.1/0003:1017:1010.0003/input/input14
[   19.757408] input: Gaming Keyboard as /devices/pci0000:00/0000:00:12.0/usb8/8-2/8-2:1.1/0003:1017:1010.0003/input/input15
[   19.758106] hid-generic 0003:1017:1010.0003: input,hiddev96,hidraw2: USB HID v1.10 Mouse [Gaming Keyboard] on usb-0000:00:12.0-2/input1
[   20.390075] random: crng init done
[   20.407735] device-mapper: uevent: version 1.0.3
[   20.407970] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28) initialised: dm-devel@redhat.com
[   23.076715] ------------[ cut here ]------------
[   23.076722] NETDEV WATCHDOG: enp6s0 (alx): transmit queue 1 timed out
[   23.076780] WARNING: CPU: 4 PID: 0 at net/sched/sch_generic.c:526 dev_watchdog+0x1a8/0x1b0
[   23.076794] Modules linked in: dm_mod joydev input_leds hid_generic usbhid hid snd_hda_codec_realtek crc32_pclmul snd_hda_codec_generic sha512_ssse3 radeon ledtrig_audio sha512_generic pkcs8_key_parser led_class drm_ttm_helper snd_hda_codec_hdmi ttm sg i2c_algo_bit drm_display_helper drm_kms_helper snd_hda_intel aesni_intel it87 sr_mod k10temp fam15h_power sysimgblt snd_intel_dspcfg ohci_pci hwmon_vid evdev libaes crypto_simd cryptd cdrom hwmon ehci_pci ohci_hcd i2c_piix4 ehci_hcd snd_hda_codec syscopyarea snd_hwdep xhci_pci sysfillrect snd_hda_core xhci_hcd drm snd_pcm acpi_cpufreq snd_timer drm_panel_orientation_quirks usbcore video wmi snd usb_common soundcore backlight button processor efivarfs
[   23.076925] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 6.3.0-rc4-bdver2-dirty #3
[   23.076932] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./970-GAMING, BIOS F2 04/06/2016
[   23.076936] RIP: 0010:dev_watchdog+0x1a8/0x1b0
[   23.076944] Code: ff ff e9 63 ff ff ff c6 05 85 91 83 00 01 4c 89 f7 e8 8c 10 fc ff 48 c7 c7 9a a0 b6 a2 4c 89 f6 48 89 c2 89 d9 e8 98 4a 9e ff <0f> 0b e9 6e ff ff ff 90 41 57 41 56 53 49 89 fe 8b 87 c8 03 00 00
[   23.076950] RSP: 0018:ffffb43d40188ea8 EFLAGS: 00010246
[   23.076956] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[   23.076961] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   23.076965] RBP: 000000007fffffff R08: 0000000000000000 R09: 0000000000000000
[   23.076969] R10: 0000000000000000 R11: 0000000000000000 R12: ffff92478673c490
[   23.076973] R13: dead000000000122 R14: ffff92478673c000 R15: ffff92478673c3e0
[   23.076977] FS:  0000000000000000(0000) GS:ffff924e8ed00000(0000) knlGS:0000000000000000
[   23.076983] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.076987] CR2: 00007f18db451000 CR3: 000000017d3ba000 CR4: 00000000000406e0
[   23.076992] Call Trace:
[   23.076996]  <IRQ>
[   23.077001]  ? dev_init_scheduler+0x80/0x80
[   23.077008]  ? dev_init_scheduler+0x80/0x80
[   23.077013]  call_timer_fn+0x1d/0xa0
[   23.077023]  __run_timers+0x178/0x1f0
[   23.077032]  run_timer_softirq+0x14/0x30
[   23.077040]  __do_softirq+0xc3/0x1d9
[   23.077048]  __irq_exit_rcu+0x74/0xa0
[   23.077056]  sysvec_apic_timer_interrupt+0x6d/0x80
[   23.077064]  </IRQ>
[   23.077067]  <TASK>
[   23.077070]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[   23.077079] RIP: 0010:cpuidle_enter_state+0x119/0x210
[   23.077087] Code: fe ff ff e8 49 d5 90 ff e8 44 f8 ff ff 48 89 c5 31 ff e8 ea 56 90 ff 45 84 ed 48 8b 5c 24 10 74 05 e8 8b b4 e7 ff fb 45 85 f6 <78> 4e 44 89 f0 48 6b d0 68 48 8b 4c 13 48 48 2b 6c 24 08 49 89 6f
[   23.077092] RSP: 0018:ffffb43d400b7e88 EFLAGS: 00000202
[   23.077098] RAX: 0000000000000000 RBX: ffffffffc026f0f0 RCX: 0000000000000000
[   23.077102] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   23.077106] RBP: 000000055f7a838f R08: 0000000000000000 R09: 0000000000000000
[   23.077110] R10: 0000000000000000 R11: ffffffffc0269ea0 R12: 0000000000000002
[   23.077114] R13: 0000000000000000 R14: 0000000000000002 R15: ffff9247fc5b9000
[   23.077119]  ? cleanup_module+0x60/0x60 [processor]
[   23.077134]  ? cpuidle_enter_state+0x106/0x210
[   23.077142]  cpuidle_enter+0x24/0x40
[   23.077150]  do_idle+0x130/0x1c0
[   23.077158]  cpu_startup_entry+0x14/0x20
[   23.077165]  start_secondary+0x8a/0x90
[   23.077174]  secondary_startup_64_no_verify+0xcf/0xdb
[   23.077181]  </TASK>
[   23.077184] ---[ end trace 0000000000000000 ]---
[   23.088094] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full
[   29.469958] BTRFS: device label gehaim devid 1 transid 53983 /dev/dm-0 scanned by (udev-worker) (1210)
[   29.772463] BTRFS info (device nvme0n1p4: state M): use zstd compression, level 2
[   29.935653] Adding 8388604k swap on /dev/nvme0n1p2.  Priority:-2 extents:1 across:8388604k SSFS
[   30.008913] BTRFS info (device dm-0): using xxhash64 (xxhash64-generic) checksum algorithm
[   30.008929] BTRFS info (device dm-0): use zstd compression, level 1
[   30.008933] BTRFS info (device dm-0): using free space tree
[   30.052195] BTRFS info (device dm-0): enabling ssd optimizations
[   30.055028] BTRFS info (device nvme0n1p6): using xxhash64 (xxhash64-generic) checksum algorithm
[   30.055041] BTRFS info (device nvme0n1p6): setting nodatasum
[   30.055045] BTRFS info (device nvme0n1p6): using free space tree
[   30.058106] BTRFS info (device nvme0n1p6): enabling ssd optimizations
[   30.058111] BTRFS info (device nvme0n1p6): auto enabling async discard
[   31.423504] alg: No test for hmac(md4) (hmac(md4-generic))
[   31.508969] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   31.529593] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   32.749156] Bluetooth: Core ver 2.22
[   32.749204] NET: Registered PF_BLUETOOTH protocol family
[   32.749206] Bluetooth: HCI device and connection manager initialized
[   32.749212] Bluetooth: HCI socket layer initialized
[   32.749215] Bluetooth: L2CAP socket layer initialized
[   32.749220] Bluetooth: SCO socket layer initialized
[   32.756632] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   32.756636] Bluetooth: BNEP filters: protocol multicast
[   32.756640] Bluetooth: BNEP socket layer initialized
[   35.399702] zram: Added device: zram0
[   35.400376] zram: Added device: zram1
[   35.401021] zram: Added device: zram2
[   35.458429] zram2: detected capacity change from 0 to 50331648
[   35.882608] BTRFS: device label var_tmp_dir devid 1 transid 6 /dev/zram2 scanned by mkfs.btrfs (2409)
[   35.885682] BTRFS info (device zram2): using crc32c (crc32c-intel) checksum algorithm
[   35.885692] BTRFS info (device zram2): setting nodatasum
[   35.885694] BTRFS info (device zram2): using free space tree
[   35.887763] BTRFS info (device zram2): enabling ssd optimizations
[   35.887767] BTRFS info (device zram2): auto enabling async discard
[   35.887843] BTRFS info (device zram2): checking UUID tree
[   38.015240] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full
[   38.494313] fuse: init (API version 7.38)
[   38.766218] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=2519 'mate-session-ch'
[   48.044445] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full
[   58.074176] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full
[   68.100954] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full
[   78.127283] alx 0000:06:00.0 enp6s0: NIC Up: 100 Mbps Full

--MP_/IT3ol7I_c3AMb/QIhmgGTvH--
