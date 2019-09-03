Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5D3A67FE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 14:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbfICMB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 08:01:56 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35720 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfICMB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 08:01:56 -0400
Received: by mail-lf1-f68.google.com with SMTP id w6so7277587lfl.2
        for <stable@vger.kernel.org>; Tue, 03 Sep 2019 05:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WcJkzoqVIeqhcVcKeCETlNbFdDbtyDea5ojJ2WpNTYo=;
        b=le8UbfxGJnfylfgl8KsGqktaxTjdHEGjE/jTwWoi455vdCCe4fel5u3sxmHwfUZUtn
         ftMpP54EOrlwaYtkgiwrUR01huPerSgMhuT/jOUoTaWi4rxQ2h26jdWoM7EPH43dMxjJ
         cf7CFy9iCYSPH+yrrKdOGREyTLhp4yoU2iZTEBSJlbqNXLZ7hsTz0ZdiixiNeOx/KJ33
         YV97L13aHN3m/eeaqSkdfBCuUB6PB4hffPtbX8oOPZ0uPfwjVTAfztTwPvSYjoi1Hz9V
         FycEfz+0E3J+FJ0prMKIiKSC6Kn0aqx1qLm1MY8WQPto1wnPBz/MCcZgg+PHcULNCrs7
         M5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WcJkzoqVIeqhcVcKeCETlNbFdDbtyDea5ojJ2WpNTYo=;
        b=T8ZTr8ibEJHDIGGRo94WV9XHVD5lrk58u4CnZm2SJVKa43SZ36301it7/0Lym2yloj
         C8A2voYmpm2/TnpOigxMjU40PYJGhyz0/8LcOpsPoBNspD8A4f0TvXNjeZ0sF1h0T25q
         BHa7AB7WFtZAkNU/i4GzcGHOLQ8FCFkg12uumy76ry+Cm1Q8dfh3BaWyj6HoP16yyVkW
         dd0NeUXKDxXuZTtloj3pwL1yhfd4qRrjaaaWZNSsn2634C71//hyLQpey9IRkP1TI+d4
         o7kz+j4onqXsOpTmYSxQ4za9wnfTX8LWvt/25kuc4D12O6lA33iky4jQJwjQAa3jMq//
         kkbA==
X-Gm-Message-State: APjAAAX1vwJl4P/3DhQsYcc0YtjaIAqih8bQavWPepenNVDnxDlaVmqi
        Vf2JEi0ks2jlri+UuSeLs3CP48jOJa0=
X-Google-Smtp-Source: APXvYqynoQRxqToJSu7HYbTOO+eWUB7HaPiMstKyifREyAtHMY6f8osaUXLpd7AenymxZblFkFXliQ==
X-Received: by 2002:a19:117:: with SMTP id 23mr14091054lfb.115.1567512110138;
        Tue, 03 Sep 2019 05:01:50 -0700 (PDT)
Received: from [84.217.173.115] (c-8caed954.51034-0-757473696b74.bbcust.telenor.se. [84.217.173.115])
        by smtp.gmail.com with ESMTPSA id r22sm1177129ljr.43.2019.09.03.05.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 05:01:49 -0700 (PDT)
Subject: Re: [BUG] Early OOM and kernel NULL pointer dereference in 4.19.69
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-mm@kvack.org, stable@vger.kernel.org
References: <31131c2d-a936-8bbf-e58d-a3baaa457340@gmail.com>
 <20190902071617.GC14028@dhcp22.suse.cz>
 <a07da432-1fc1-67de-ae35-93f157bf9a7d@gmail.com>
 <20190903074132.GM14028@dhcp22.suse.cz>
From:   Thomas Lindroth <thomas.lindroth@gmail.com>
Message-ID: <38bf326e-fc0a-31b7-5c90-7f3b6c4f740d@gmail.com>
Date:   Tue, 3 Sep 2019 14:01:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903074132.GM14028@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/3/19 9:41 AM, Michal Hocko wrote:
> On Mon 02-09-19 21:34:29, Thomas Lindroth wrote:
>> On 9/2/19 9:16 AM, Michal Hocko wrote:
>>> On Sun 01-09-19 22:43:05, Thomas Lindroth wrote:
>>>> After upgrading to the 4.19 series I've started getting problems with
>>>> early OOM.
>>>
>>> What is the kenrel you have updated from? Would it be possible to try
>>> the current Linus' tree?
>>
>> I did some more testing and it turns out this is not a regression after all.
>>
>> I followed up on my hunch and monitored memory.kmem.max_usage_in_bytes while
>> running cgexec -g memory:12G bash -c 'find / -xdev -type f -print0 | \
>>          xargs -0 -n 1 -P 8 stat > /dev/null'
>>
>> Just as memory.kmem.max_usage_in_bytes = memory.kmem.limit_in_bytes the OOM
>> killer kicked in and killed my X server.
>>
>> Using the find|stat approach it was easy to test the problem in a testing VM.
>> I was able to reproduce the problem in all these kernels:
>>    4.9.0
>>    4.14.0
>>    4.14.115
>>    4.19.0
>>    5.2.11
>>
>> 5.3-rc6 didn't build in the VM. The build environment is too old probably.
>>
>> I was curious why I initially couldn't reproduce the problem in 4.14 by
>> building chromium. I was again able to successfully build chromium using
>> 4.14.115. Turns out memory.kmem.max_usage_in_bytes was 1015689216 after
>> building and my limit is set to 1073741824. I guess some unrelated change in
>> memory management raised that slightly for 4.19 triggering the problem.
>>
>> If you want to reproduce for yourself here are the steps:
>> 1. build any kernel above 4.9 using something like my .config
>> 2. setup a v1 memory cgroup with memory.kmem.limit_in_bytes lower than
>>     memory.limit_in_bytes. I used 100M in my testing VM.
>> 3. Run "find / -xdev -type f -print0 | xargs -0 -n 1 -P 8 stat > /dev/null"
>>     in the cgroup.
>> 4. Assuming there is enough inodes on the rootfs the global OOM killer
>>     should kick in when memory.kmem.max_usage_in_bytes =
>>     memory.kmem.limit_in_bytes and kill something outside the cgroup.
> 
> This is certainly a bug. Is this still an OOM triggered from
> pagefault_out_of_memory? Since 4.19 (29ef680ae7c21) the memcg charge
> path should invoke the memcg oom killer directly from the charge path.
> If that doesn't happen then the failing charge is either GFP_NOFS or a
> large allocation.
> 
> The former has been fixed just recently by http://lkml.kernel.org/r/cbe54ed1-b6ba-a056-8899-2dc42526371d@i-love.sakura.ne.jp
> and I suspect this is a fix you are looking for. Although it is curious
> that you can see a global oom even before because the charge path would
> mark an oom situation even for NOFS context and it should trigger the
> memcg oom killer on the way out from the page fault path. So essentially
> the same call trace except the oom killer should be constrained to the
> memcg context.
> 
> Could you try the above patch please?

I tried the patch in my testing VM on top of 5.2.11. The VM got 8G ram and
these cgroup settings:
   memory.kmem.limit_in_bytes:107374182
   memory.kmem.tcp.limit_in_bytes:1073741824
   memory.limit_in_bytes:1073741824
   memory.memsw.limit_in_bytes:12884901888

As kmem.limit_in_bytes was hit the OOM killer killed Xorg. Here is the
full dmesg:

[    0.000000] Linux version 5.2.11+ (root@debian) (gcc version 4.7.2 (Debian 4.7.2-5)) #5 SMP Tue Sep 3 08:33:32 EDT 2019
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.2.11+ root=UUID=d51ad2bd-595d-4dad-abf3-21cddbb2aee5 ro quiet
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffddfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffde000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b0000000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000027fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.11.0-1.fc28 04/01/2014
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 4000.128 MHz processor
[    0.001244] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.001245] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.001247] last_pfn = 0x280000 max_arch_pfn = 0x400000000
[    0.001266] MTRR default type: write-back
[    0.001267] MTRR fixed ranges enabled:
[    0.001268]   00000-9FFFF write-back
[    0.001268]   A0000-BFFFF uncachable
[    0.001268]   C0000-FFFFF write-protect
[    0.001269] MTRR variable ranges enabled:
[    0.001269]   0 base 00C0000000 mask FFC0000000 uncachable
[    0.001270]   1 disabled
[    0.001270]   2 disabled
[    0.001270]   3 disabled
[    0.001271]   4 disabled
[    0.001271]   5 disabled
[    0.001271]   6 disabled
[    0.001271]   7 disabled
[    0.001278] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.001282] last_pfn = 0x7ffde max_arch_pfn = 0x400000000
[    0.006102] found SMP MP-table at [mem 0x000f5d10-0x000f5d1f]
[    0.006309] Using GB pages for direct mapping
[    0.006311] BRK [0x3b201000, 0x3b201fff] PGTABLE
[    0.006312] BRK [0x3b202000, 0x3b202fff] PGTABLE
[    0.006313] BRK [0x3b203000, 0x3b203fff] PGTABLE
[    0.006326] BRK [0x3b204000, 0x3b204fff] PGTABLE
[    0.006377] RAMDISK: [mem 0x246fa000-0x2e374fff]
[    0.006385] ACPI: Early table checksum verification disabled
[    0.006417] ACPI: RSDP 0x00000000000F5B40 000014 (v00 BOCHS )
[    0.006419] ACPI: RSDT 0x000000007FFE21CF 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.006423] ACPI: FACP 0x000000007FFE1FD7 0000F4 (v03 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.006426] ACPI: DSDT 0x000000007FFE0040 001F97 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.006429] ACPI: FACS 0x000000007FFE0000 000040
[    0.006430] ACPI: APIC 0x000000007FFE20CB 000090 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.006432] ACPI: HPET 0x000000007FFE215B 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.006435] ACPI: MCFG 0x000000007FFE2193 00003C (v01 BOCHS  BXPCMCFG 00000001 BXPC 00000001)
[    0.006440] ACPI: Local APIC address 0xfee00000
[    0.006610] No NUMA configuration found
[    0.006611] Faking a node at [mem 0x0000000000000000-0x000000027fffffff]
[    0.006613] NODE_DATA(0) allocated [mem 0x27fffa000-0x27fffdfff]
[    0.006629] Zone ranges:
[    0.006630]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.006631]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.006631]   Normal   [mem 0x0000000100000000-0x000000027fffffff]
[    0.006632] Movable zone start for each node
[    0.006632] Early memory node ranges
[    0.006633]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.006633]   node   0: [mem 0x0000000000100000-0x000000007ffddfff]
[    0.006633]   node   0: [mem 0x0000000100000000-0x000000027fffffff]
[    0.006641] Zeroed struct page in unavailable ranges: 132 pages
[    0.006642] Initmem setup node 0 [mem 0x0000000000001000-0x000000027fffffff]
[    0.006643] On node 0 totalpages: 2097020
[    0.006643]   DMA zone: 64 pages used for memmap
[    0.006643]   DMA zone: 21 pages reserved
[    0.006644]   DMA zone: 3998 pages, LIFO batch:0
[    0.006677]   DMA32 zone: 8128 pages used for memmap
[    0.006678]   DMA32 zone: 520158 pages, LIFO batch:63
[    0.012564]   Normal zone: 24576 pages used for memmap
[    0.012565]   Normal zone: 1572864 pages, LIFO batch:63
[    0.025222] ACPI: PM-Timer IO Port: 0x608
[    0.025224] ACPI: Local APIC address 0xfee00000
[    0.025231] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.025837] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.025840] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.025841] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.025841] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.025842] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.025843] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.025844] ACPI: IRQ0 used by override.
[    0.025844] ACPI: IRQ5 used by override.
[    0.025845] ACPI: IRQ9 used by override.
[    0.025845] ACPI: IRQ10 used by override.
[    0.025845] ACPI: IRQ11 used by override.
[    0.025847] Using ACPI (MADT) for SMP configuration information
[    0.025848] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.025855] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.025863] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.025864] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.025864] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.025864] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.025865] PM: Registered nosave memory: [mem 0x7ffde000-0x7fffffff]
[    0.025865] PM: Registered nosave memory: [mem 0x80000000-0xafffffff]
[    0.025866] PM: Registered nosave memory: [mem 0xb0000000-0xbfffffff]
[    0.025866] PM: Registered nosave memory: [mem 0xc0000000-0xfed1bfff]
[    0.025866] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.025867] PM: Registered nosave memory: [mem 0xfed20000-0xfeffbfff]
[    0.025867] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.025867] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.025868] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.025869] [mem 0xc0000000-0xfed1bfff] available for PCI devices
[    0.025871] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.025875] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.025993] percpu: Embedded 51 pages/cpu s168088 r8192 d32616 u524288
[    0.025996] pcpu-alloc: s168088 r8192 d32616 u524288 alloc=1*2097152
[    0.025997] pcpu-alloc: [0] 0 1 2 3
[    0.026008] Built 1 zonelists, mobility grouping on.  Total pages: 2064231
[    0.026008] Policy zone: Normal
[    0.026009] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-5.2.11+ root=UUID=d51ad2bd-595d-4dad-abf3-21cddbb2aee5 ro quiet
[    0.028738] Calgary: detecting Calgary via BIOS EBDA area
[    0.028739] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.047644] Memory: 8011344K/8388080K available (8194K kernel code, 823K rwdata, 2088K rodata, 1148K init, 2048K bss, 376736K reserved, 0K cma-reserved)
[    0.047707] Kernel/User page tables isolation: enabled
[    0.047759] rcu: Hierarchical RCU implementation.
[    0.047760] rcu:     RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.047761] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.047761] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.047849] NR_IRQS: 33024, nr_irqs: 456, preallocated irqs: 16
[    0.048065] random: get_random_bytes called from start_kernel+0x2e9/0x4b3 with crng_init=0
[    0.060768] Console: colour VGA+ 80x25
[    0.060772] printk: console [tty0] enabled
[    0.060783] ACPI: Core revision 20190509
[    0.060925] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
[    0.060966] hpet clockevent registered
[    0.060974] APIC: Switch to symmetric I/O mode setup
[    0.062688] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.070234] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.089009] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x39a8d58b854, max_idle_ns: 440795351064 ns
[    0.089011] Calibrating delay loop (skipped), value calculated using timer frequency.. 8000.25 BogoMIPS (lpj=16000512)
[    0.089012] pid_max: default: 32768 minimum: 301
[    0.089040] LSM: Security Framework initializing
[    0.089883] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.090314] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.090336] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.090349] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.090531] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    0.090565] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.090565] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.090567] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.090568] Spectre V2 : Spectre mitigation: kernel not compiled with retpoline; no mitigation available!
[    0.090568] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
[    0.090773] MDS: Mitigation: Clear CPU buffers
[    0.090880] Freeing SMP alternatives memory: 16K
[    0.090954] TSC deadline timer enabled
[    0.090963] smpboot: CPU0: Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz (family: 0x6, model: 0x3c, stepping: 0x3)
[    0.091020] Performance Events: Haswell events, Intel PMU driver.
[    0.091039] ... version:                2
[    0.091039] ... bit width:              48
[    0.091040] ... generic registers:      4
[    0.091040] ... value mask:             0000ffffffffffff
[    0.091041] ... max period:             000000007fffffff
[    0.091041] ... fixed-purpose events:   3
[    0.091041] ... event mask:             000000070000000f
[    0.091065] rcu: Hierarchical SRCU implementation.
[    0.091114] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.093010] smp: Bringing up secondary CPUs ...
[    0.093010] x86: Booting SMP configuration:
[    0.093010] .... node  #0, CPUs:      #1 #2 #3
[    0.093329] smp: Brought up 1 node, 4 CPUs
[    0.093329] smpboot: Max logical packages: 1
[    0.093329] smpboot: Total of 4 processors activated (32001.02 BogoMIPS)
[    0.093345] devtmpfs: initialized
[    0.093345] x86/mm: Memory block size: 128MB
[    0.093538] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.093538] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.093538] NET: Registered protocol family 16
[    0.093538] audit: initializing netlink subsys (disabled)
[    0.093538] audit: type=2000 audit(1567514293.032:1): state=initialized audit_enabled=0 res=1
[    0.093538] cpuidle: using governor ladder
[    0.093538] cpuidle: using governor menu
[    0.093538] ACPI: bus type PCI registered
[    0.093538] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.093538] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xb0000000-0xbfffffff] (base 0xb0000000)
[    0.093538] PCI: MMCONFIG at [mem 0xb0000000-0xbfffffff] reserved in E820
[    0.093538] PCI: Using configuration type 1 for base access
[    0.093538] core: PMU erratum BJ122, BV98, HSD29 workaround disabled, HT off
[    0.093918] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.093918] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.245109] ACPI: Added _OSI(Module Device)
[    0.245110] ACPI: Added _OSI(Processor Device)
[    0.245111] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.245111] ACPI: Added _OSI(Processor Aggregator Device)
[    0.245113] ACPI: Added _OSI(Linux-Dell-Video)
[    0.245113] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.245114] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.245894] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.246706] ACPI: Interpreter enabled
[    0.246714] ACPI: (supports S0 S3 S4 S5)
[    0.246715] ACPI: Using IOAPIC for interrupt routing
[    0.246730] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.246782] ACPI: Enabled 1 GPEs in block 00 to 3F
[    0.248024] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.248027] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    0.248074] acpi PNP0A08:00: _OSC: platform does not support [LTR]
[    0.248113] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.248168] PCI host bridge to bus 0000:00
[    0.248169] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.248170] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.248171] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.248172] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff window]
[    0.248172] pci_bus 0000:00: root bus resource [mem 0x280000000-0xa7fffffff window]
[    0.248173] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.248191] pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
[    0.248413] pci 0000:00:01.0: [1b36:0100] type 00 class 0x030000
[    0.250024] pci 0000:00:01.0: reg 0x10: [mem 0xf4000000-0xf7ffffff]
[    0.251636] pci 0000:00:01.0: reg 0x14: [mem 0xf8000000-0xfbffffff]
[    0.253062] pci 0000:00:01.0: reg 0x18: [mem 0xfc094000-0xfc095fff]
[    0.254713] pci 0000:00:01.0: reg 0x1c: [io  0xc040-0xc05f]
[    0.260010] pci 0000:00:01.0: reg 0x30: [mem 0xfc080000-0xfc08ffff pref]
[    0.260274] pci 0000:00:02.0: [8086:10d3] type 00 class 0x020000
[    0.261010] pci 0000:00:02.0: reg 0x10: [mem 0xfc040000-0xfc05ffff]
[    0.261353] pci 0000:00:02.0: reg 0x14: [mem 0xfc060000-0xfc07ffff]
[    0.262094] pci 0000:00:02.0: reg 0x18: [io  0xc060-0xc07f]
[    0.262757] pci 0000:00:02.0: reg 0x1c: [mem 0xfc090000-0xfc093fff]
[    0.265016] pci 0000:00:02.0: reg 0x30: [mem 0xfc000000-0xfc03ffff pref]
[    0.265498] pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100
[    0.265732] pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by ICH6 ACPI/GPIO/TCO
[    0.265841] pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601
[    0.269007] pci 0000:00:1f.2: reg 0x20: [io  0xc080-0xc09f]
[    0.269470] pci 0000:00:1f.2: reg 0x24: [mem 0xfc096000-0xfc096fff]
[    0.270038] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
[    0.271177] pci 0000:00:1f.3: reg 0x20: [io  0x0700-0x073f]
[    0.271942] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.271989] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.272031] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.272072] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.272114] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 *10 11)
[    0.272155] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 *10 11)
[    0.272260] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 10 *11)
[    0.272304] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 10 *11)
[    0.272320] ACPI: PCI Interrupt Link [GSIA] (IRQs *16)
[    0.272326] ACPI: PCI Interrupt Link [GSIB] (IRQs *17)
[    0.272331] ACPI: PCI Interrupt Link [GSIC] (IRQs *18)
[    0.272337] ACPI: PCI Interrupt Link [GSID] (IRQs *19)
[    0.272341] ACPI: PCI Interrupt Link [GSIE] (IRQs *20)
[    0.272346] ACPI: PCI Interrupt Link [GSIF] (IRQs *21)
[    0.272355] ACPI: PCI Interrupt Link [GSIG] (IRQs *22)
[    0.272360] ACPI: PCI Interrupt Link [GSIH] (IRQs *23)
[    0.272646] pci 0000:00:01.0: vgaarb: setting as boot VGA device
[    0.272646] pci 0000:00:01.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.272646] pci 0000:00:01.0: vgaarb: bridge control possible
[    0.272646] vgaarb: loaded
[    0.272646] pps_core: LinuxPPS API ver. 1 registered
[    0.272646] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.272646] PTP clock support registered
[    0.272646] EDAC MC: Ver: 3.0.0
[    0.272646] PCI: Using ACPI for IRQ routing
[    0.303863] PCI: pci_cache_line_size set to 64 bytes
[    0.303921] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.303924] e820: reserve RAM buffer [mem 0x7ffde000-0x7fffffff]
[    0.304074] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.304074] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.305026] clocksource: Switched to clocksource tsc-early
[    0.309208] VFS: Disk quotas dquot_6.6.0
[    0.309223] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.309262] pnp: PnP ACPI init
[    0.309303] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.309324] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.309340] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.309373] pnp 00:03: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.309400] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.309542] pnp: PnP ACPI: found 5 devices
[    0.315938] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.315947] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.315948] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.315948] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.315949] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff window]
[    0.315950] pci_bus 0000:00: resource 8 [mem 0x280000000-0xa7fffffff window]
[    0.315988] NET: Registered protocol family 2
[    0.316139] tcp_listen_portaddr_hash hash table entries: 4096 (order: 4, 65536 bytes)
[    0.316157] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.316223] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316317] TCP: Hash tables configured (established 65536 bind 65536)
[    0.316349] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.316364] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.316408] NET: Registered protocol family 1
[    0.316445] pci 0000:00:01.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.316472] PCI: CLS 0 bytes, default 64
[    0.316504] Trying to unpack rootfs image as initramfs...
[    1.807053] Freeing initrd memory: 160236K
[    1.807076] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.807077] software IO TLB: mapped [mem 0x7bfde000-0x7ffde000] (64MB)
[    1.807295] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 10737418240 ms ovfl timer
[    1.807296] RAPL PMU: hw unit of domain pp0-core 2^-0 Joules
[    1.807296] RAPL PMU: hw unit of domain package 2^-0 Joules
[    1.807297] RAPL PMU: hw unit of domain dram 2^-0 Joules
[    1.807297] RAPL PMU: hw unit of domain pp1-gpu 2^-0 Joules
[    1.807819] workingset: timestamp_bits=40 max_order=21 bucket_order=0
[    1.807988] Key type asymmetric registered
[    1.807990] Asymmetric key parser 'x509' registered
[    1.807995] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    1.807996] io scheduler mq-deadline registered
[    1.807996] io scheduler kyber registered
[    1.808138] intel_idle: Please enable MWAIT in BIOS SETUP
[    1.808316] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.830738] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.831156] Linux agpgart interface v0.103
[    1.831488] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.833069] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.833073] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.833231] mousedev: PS/2 mouse device common for all mice
[    1.833306] rtc_cmos 00:00: RTC can wake from S4
[    1.833979] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.834109] rtc_cmos 00:00: registered as rtc0
[    1.834124] rtc_cmos 00:00: alarms up to one day, y3k, 114 bytes nvram, hpet irqs
[    1.834130] intel_pstate: CPU model not supported
[    1.834158] drop_monitor: Initializing network drop monitor service
[    1.834231] NET: Registered protocol family 10
[    1.834423] Segment Routing with IPv6
[    1.834435] mip6: Mobile IPv6
[    1.834436] NET: Registered protocol family 17
[    1.834445] Key type dns_resolver registered
[    1.834652] mce: Using 10 MCE banks
[    1.834666] sched_clock: Marking stable (1821634086, 12978712)->(1842031235, -7418437)
[    1.834795] registered taskstats version 1
[    1.835220] rtc_cmos 00:00: setting system clock to 2019-09-03T12:38:15 UTC (1567514295)
[    1.835531] Freeing unused kernel image memory: 1148K
[    1.849072] Write protecting the kernel read-only data: 14336k
[    1.849927] Freeing unused kernel image memory: 2028K
[    1.850647] Freeing unused kernel image memory: 2008K
[    1.850679] Run /init as init process
[    1.858108] udevd[91]: starting version 175
[    1.874277] SCSI subsystem initialized
[    1.882016] libata version 3.00 loaded.
[    1.882917] ahci 0000:00:1f.2: version 3.0
[    1.883133] PCI Interrupt Link [GSIA] enabled at IRQ 16
[    1.883483] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 6 ports 1.5 Gbps 0x3f impl SATA mode
[    1.883485] ahci 0000:00:1f.2: flags: 64bit ncq only
[    1.890825] scsi host0: ahci
[    1.891020] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    1.891020] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.891330] PCI Interrupt Link [GSIG] enabled at IRQ 22
[    1.891870] e1000e 0000:00:02.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.895622] scsi host1: ahci
[    1.896917] scsi host2: ahci
[    1.897483] scsi host3: ahci
[    1.899133] scsi host4: ahci
[    1.901667] scsi host5: ahci
[    1.901762] ata1: SATA max UDMA/133 abar m4096@0xfc096000 port 0xfc096100 irq 24
[    1.901769] ata2: SATA max UDMA/133 abar m4096@0xfc096000 port 0xfc096180 irq 24
[    1.901774] ata3: SATA max UDMA/133 abar m4096@0xfc096000 port 0xfc096200 irq 24
[    1.901778] ata4: SATA max UDMA/133 abar m4096@0xfc096000 port 0xfc096280 irq 24
[    1.901782] ata5: SATA max UDMA/133 abar m4096@0xfc096000 port 0xfc096300 irq 24
[    1.901785] ata6: SATA max UDMA/133 abar m4096@0xfc096000 port 0xfc096380 irq 24
[    1.957727] e1000e 0000:00:02.0 0000:00:02.0 (uninitialized): registered PHC clock
[    2.020118] e1000e 0000:00:02.0 eth0: (PCI Express:2.5GT/s:Width x1) 52:54:00:12:34:56
[    2.020119] e1000e 0000:00:02.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.020138] e1000e 0000:00:02.0 eth0: MAC: 3, PHY: 8, PBA No: 000000-000
[    2.216698] ata6: SATA link down (SStatus 0 SControl 300)
[    2.216796] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.216943] ata5: SATA link down (SStatus 0 SControl 300)
[    2.217049] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.217184] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.217303] ata4: SATA link down (SStatus 0 SControl 300)
[    2.217340] ata1.00: ATA-7: QEMU HARDDISK, 2.5+, max UDMA/100
[    2.217341] ata1.00: 31457280 sectors, multi 16: LBA48 NCQ (depth 32)
[    2.217343] ata1.00: applying bridge limits
[    2.217392] ata3.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[    2.217394] ata3.00: applying bridge limits
[    2.217434] ata2.00: ATA-7: QEMU HARDDISK, 2.5+, max UDMA/100
[    2.217434] ata2.00: 104857600 sectors, multi 16: LBA48 NCQ (depth 32)
[    2.217436] ata2.00: applying bridge limits
[    2.217576] ata2.00: configured for UDMA/100
[    2.217625] ata1.00: configured for UDMA/100
[    2.217638] ata3.00: configured for UDMA/100
[    2.217817] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
[    2.218168] scsi 1:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
[    2.218434] scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.5+ PQ: 0 ANSI: 5
[    2.221788] sd 0:0:0:0: [sda] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
[    2.221793] sd 0:0:0:0: [sda] Write Protect is off
[    2.221793] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.221798] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.222009] sd 1:0:0:0: [sdb] 104857600 512-byte logical blocks: (53.7 GB/50.0 GiB)
[    2.222013] sd 1:0:0:0: [sdb] Write Protect is off
[    2.222014] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.222019] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.222384]  sda: sda1 sda2 < sda5 >
[    2.222422]  sdb: sdb1
[    2.222741] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.222838] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.223977] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.224010] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.224037] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    2.241692] random: fast init done
[    2.257275] sr 2:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    2.257277] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.257450] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.484802] PM: Image not found (code -22)
[    2.500786] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    2.809075] tsc: Refined TSC clocksource calibration: 4000.021 MHz
[    2.809088] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x39a87016a1f, max_idle_ns: 440795206381 ns
[    2.809128] clocksource: Switched to clocksource tsc
[    3.598106] udevd[437]: starting version 175
[    4.166877] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    4.167943] parport_pc 00:03: reported by Plug and Play ACPI
[    4.168032] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    4.188464] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    4.189832] lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized
[    4.207278] iTCO_vendor_support: vendor-support=0
[    4.207682] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    4.207723] iTCO_wdt: Found a ICH9 TCO device (Version=2, TCOBASE=0x0660)
[    4.207852] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.241841] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    4.241919] ACPI: Power Button [PWRF]
[    4.448579] random: crng init done
[    5.045981] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    5.649077] Adding 688124k swap on /dev/sda5.  Priority:-2 extents:1 across:688124k
[    5.657555] EXT4-fs (sda1): re-mounted. Opts: (null)
[    5.821773] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    5.931729] loop: module loaded
[    6.589006] RPC: Registered named UNIX socket transport module.
[    6.589007] RPC: Registered udp transport module.
[    6.589007] RPC: Registered tcp transport module.
[    6.589008] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.592778] FS-Cache: Loaded
[    6.604859] FS-Cache: Netfs 'nfs' registered for caching
[    6.614700] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    9.281335] Bluetooth: Core ver 2.22
[    9.281351] NET: Registered protocol family 31
[    9.281352] Bluetooth: HCI device and connection manager initialized
[    9.281354] Bluetooth: HCI socket layer initialized
[    9.281355] Bluetooth: L2CAP socket layer initialized
[    9.281357] Bluetooth: SCO socket layer initialized
[    9.283691] Bluetooth: RFCOMM TTY layer initialized
[    9.283695] Bluetooth: RFCOMM socket layer initialized
[    9.283699] Bluetooth: RFCOMM ver 1.11
[    9.284992] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.284993] Bluetooth: BNEP filters: protocol multicast
[    9.284995] Bluetooth: BNEP socket layer initialized
[   12.058154] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   12.058575] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   96.893773] perf: interrupt took too long (2513 > 2500), lowering kernel.perf_event_max_sample_rate to 79500
[   99.136902] stat invoked oom-killer: gfp_mask=0x0(), order=0, oom_score_adj=0
[   99.136904] CPU: 2 PID: 20281 Comm: stat Not tainted 5.2.11+ #5
[   99.136905] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.11.0-1.fc28 04/01/2014
[   99.136905] Call Trace:
[   99.136925]  dump_stack+0x4d/0x64
[   99.136934]  dump_header+0x54/0x2f5
[   99.136937]  ? do_raw_spin_trylock+0x1f/0x28
[   99.136938]  ? ___ratelimit+0xc3/0xe4
[   99.136939]  ? task_will_free_mem+0x25/0xa0
[   99.136940]  oom_kill_process+0x7a/0xec
[   99.136942]  out_of_memory+0x3dd/0x3f8
[   99.136943]  ? __mutex_trylock_or_owner+0x4b/0x63
[   99.136944]  pagefault_out_of_memory+0x3c/0x4b
[   99.136947]  mm_fault_error+0x66/0x150
[   99.136948]  do_user_addr_fault+0x29f/0x3a4
[   99.136954]  ? fpregs_assert_state_consistent+0x16/0x43
[   99.136955]  __do_page_fault+0x44/0x46
[   99.136955]  do_page_fault+0x9c/0xdf
[   99.136957]  ? page_fault+0x8/0x30
[   99.136958]  page_fault+0x1e/0x30
[   99.136959] RIP: 0033:0x7f6c27463f84
[   99.136960] Code: 10 4d 89 4b 18 5b 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 48 8b 87 98 02 00 00 48 85 c0 74 5f 48 8b 40 08 <8b> 08 89 8f ec 02 00 00 8b 50 08 44 8b 40 04 8d 72 ff 85 d6 75 72
[   99.136961] RSP: 002b:00007ffc57285840 EFLAGS: 00010206
[   99.136962] RAX: 00007f6c26473280 RBX: 00000000026161b0 RCX: 00007f6c274711d7
[   99.136962] RDX: 00007f6c2667de48 RSI: 0000000000000030 RDI: 00000000026161b0
[   99.136962] RBP: 00007ffc572859b0 R08: 0000000070000029 R09: 000000006ffffdff
[   99.136964] R10: 000000006ffffeff R11: 0000000000000246 R12: 00007ffc57285a98
[   99.136964] R13: 000000006fffff48 R14: 00007ffc57285730 R15: 00007ffc572856d0
[   99.136965] Mem-Info:
[   99.136968] active_anon:24008 inactive_anon:391 isolated_anon:0
[   99.136968]  active_file:22836 inactive_file:33264 isolated_file:0
[   99.136968]  unevictable:0 dirty:13 writeback:0 unstable:0
[   99.136968]  slab_reclaimable:28549 slab_unreclaimable:4068
[   99.136968]  mapped:16364 shmem:498 pagetables:2551 bounce:0
[   99.136968]  free:1918966 free_pcp:1781 free_cma:0
[   99.136970] Node 0 active_anon:96032kB inactive_anon:1564kB active_file:91344kB inactive_file:133056kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:65456kB dirty:52kB writeback:0kB shmem:1992kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[   99.136970] Node 0 DMA free:15908kB min:132kB low:164kB high:196kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:15908kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[   99.136972] lowmem_reserve[]: 0 1793 7808 7808
[   99.136973] Node 0 DMA32 free:1998916kB min:15488kB low:19360kB high:23232kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:2080632kB managed:2001812kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:2896kB local_pcp:0kB free_cma:0kB
[   99.136975] lowmem_reserve[]: 0 0 6014 6014
[   99.136976] Node 0 Normal free:5661040kB min:51956kB low:64944kB high:77932kB active_anon:96032kB inactive_anon:1564kB active_file:91344kB inactive_file:133056kB unevictable:0kB writepending:52kB present:6291456kB managed:6159060kB mlocked:0kB kernel_stack:3920kB pagetables:10204kB bounce:0kB free_pcp:4220kB local_pcp:468kB free_cma:0kB
[   99.136978] lowmem_reserve[]: 0 0 0 0
[   99.136978] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15908kB
[   99.136982] Node 0 DMA32: 5*4kB (M) 6*8kB (M) 4*16kB (M) 4*32kB (M) 5*64kB (M) 6*128kB (M) 5*256kB (M) 5*512kB (M) 3*1024kB (M) 2*2048kB (M) 485*4096kB (M) = 1998916kB
[   99.136985] Node 0 Normal: 19*4kB (ME) 11*8kB (ME) 35*16kB (UME) 11*32kB (UME) 4*64kB (UE) 2*128kB (UE) 1*256kB (E) 1*512kB (E) 8*1024kB (UME) 5*2048kB (UME) 1377*4096kB (UM) = 5660980kB
[   99.136989] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[   99.136989] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[   99.136990] 56617 total pagecache pages
[   99.136990] 0 pages in swap cache
[   99.136991] Swap cache stats: add 0, delete 0, find 0/0
[   99.136991] Free swap  = 688124kB
[   99.136992] Total swap = 688124kB
[   99.136992] 2097020 pages RAM
[   99.136992] 0 pages HighMem/MovableOnly
[   99.136992] 52825 pages reserved
[   99.136993] 0 pages hwpoisoned
[   99.136993] Tasks state (memory values in pages):
[   99.136993] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[   99.136995] [    437]     0   437     5428      690    90112        0         -1000 udevd
[   99.136996] [    565]     0   565     5427      614    86016        0         -1000 udevd
[   99.136997] [    567]     0   567     5427      615    86016        0         -1000 udevd
[   99.136998] [   1800]     0  1800     4747      513    86016        0             0 rpcbind
[   99.136999] [   1833]   105  1833     5840      617    90112        0             0 rpc.statd
[   99.137000] [   1849]     0  1849     6328       55    94208        0             0 rpc.idmapd
[   99.137000] [   2193]     0  2193    13198      690   110592        0             0 rsyslogd
[   99.137001] [   2260]     7  2260     3147      357    65536        0             0 lpd
[   99.137002] [   2320]     0  2320     4172       38    73728        0             0 atd
[   99.137003] [   2566]     0  2566     5106      538    86016        0             0 cron
[   99.137005] [   2584]     0  2584     1033      395    57344        0             0 acpid
[   99.137005] [   2611]   104  2611    12736      758   143360        0             0 exim4
[   99.137006] [   2632]   101  2632     7567      659   106496        0             0 dbus-daemon
[   99.137007] [   2682]     0  2682    35396     1326   167936        0             0 lightdm
[   99.137008] [   2700]     0  2700     5255      680    81920        0             0 bluetoothd
[   99.137009] [   2752]     0  2752    41044     1935   221184        0             0 NetworkManager
[   99.137009] [   2782]     0  2782    47228     9503   368640        0             0 Xorg
[   99.137011] [   2787]     0  2787    33036     1542   159744        0             0 polkitd
[   99.137024] [   2814]     0  2814     4068      464    77824        0             0 getty
[   99.137025] [   2815]     0  2815     4068      462    77824        0             0 getty
[   99.137026] [   2816]     0  2816     4068      488    73728        0             0 getty
[   99.137027] [   2817]     0  2817     4068      486    77824        0             0 getty
[   99.137027] [   2818]     0  2818     4068      485    77824        0             0 getty
[   99.137028] [   2819]     0  2819     4068      489    69632        0             0 getty
[   99.137029] [   2823]     0  2823    20217     1297   200704        0             0 modem-manager
[   99.137030] [   2842]     0  2842    31895     1439   151552        0             0 console-kit-dae
[   99.137030] [   2916]     0  2916     2494     1229    69632        0             0 dhclient
[   99.137031] [   2922]     0  2922    39491     1693   192512        0             0 upowerd
[   99.137032] [   3016]     0  3016    39659     1450   229376        0             0 lightdm
[   99.137032] [   3096]     0  3096    17323      732   159744        0             0 gnome-keyring-d
[   99.137033] [   3107]     0  3107     1049      358    53248        0             0 sh
[   99.137034] [   3123]     0  3123     3122       83    65536        0             0 ssh-agent
[   99.137035] [   3126]     0  3126     6051      504    90112        0             0 dbus-launch
[   99.137035] [   3127]     0  3127     7554      609   102400        0             0 dbus-daemon
[   99.137036] [   3135]     0  3135    12370     1172   143360        0             0 xfconfd
[   99.137037] [   3140]     0  3140    38776     2956   323584        0             0 xfce4-session
[   99.137038] [   3145]     0  3145    37828     3832   344064        0             0 xfwm4
[   99.137038] [   3147]     0  3147    31422     2231   286720        0             0 xfsettingsd
[   99.137039] [   3148]     0  3148    39021     3116   360448        0             0 Thunar
[   99.137040] [   3150]     0  3150    15479     1242   159744        0             0 gvfsd
[   99.137040] [   3153]     0  3153    72257     5559   466944        0             0 xfce4-panel
[   99.137041] [   3154]     0  3154    91757     6682   487424        0             0 xfdesktop
[   99.137042] [   3157]     0  3157    38106     1856   323584        0             0 xfce4-settings-
[   99.137043] [   3158]     0  3158    53548     2101   315392        0             0 xfce4-power-man
[   99.137044] [   3165]     0  3165    46647     2774   266240        0             0 polkit-gnome-au
[   99.137044] [   3167]     0  3167    17743     1675   180224        0             0 gvfs-gdu-volume
[   99.137045] [   3170]     0  3170    30373     1444   147456        0             0 udisks-daemon
[   99.137046] [   3172]     0  3172   120880     5112   434176        0             0 nm-applet
[   99.137046] [   3173]     0  3173    11857      705   131072        0             0 udisks-daemon
[   99.137047] [   3176]     0  3176    15095     1259   167936        0             0 gvfs-gphoto2-vo
[   99.137048] [   3179]     0  3179    35081     1389   303104        0             0 xfce4-power-man
[   99.137050] [   3181]     0  3181    58995     8092   507904        0             0 system-config-p
[   99.137051] [   3182]     0  3182    57804     3624   356352        0             0 xfce4-volumed
[   99.137051] [   3184]     0  3184    64742     5974   471040        0             0 xfce4-terminal
[   99.137052] [   3187]     0  3187    34538     2410   311296        0             0 xfce4-notifyd
[   99.137053] [   3189]     0  3189    13290     1180   143360        0             0 gconfd-2
[   99.137054] [   3192]     0  3192    19734      864   176128        0             0 gvfs-afc-volume
[   99.137054] [   3195]     0  3195    16606     1567   176128        0             0 gvfsd-trash
[   99.137055] [   3199]     0  3199    36763     3111   331776        0             0 panel-6-systray
[   99.137056] [   3201]     0  3201     3642      419    73728        0             0 gnome-pty-helpe
[   99.137056] [   3202]     0  3202     4869      880    81920        0             0 bash
[   99.137057] [   3206]     0  3206     4869      897    77824        0             0 bash
[   99.137058] [   3207]     0  3207     3655      668    73728        0             0 watch
[   99.137058] [   3223]     0  3223     3183      615    69632        0             0 find
[   99.137059] [   3224]     0  3224     1473      437    57344        0             0 xargs
[   99.137060] [  20281]     0 20281     4602      561    77824        0             0 stat
[   99.137060] [  20282]     0 20282     4078      583    69632        0             0 stat
[   99.137061] [  20283]     0 20283     3019      526    65536        0             0 stat
[   99.137062] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/,task=Xorg,pid=2782,uid=0
[   99.137077] Out of memory: Killed process 2782 (Xorg) total-vm:188912kB, anon-rss:24884kB, file-rss:11664kB, shmem-rss:1464kB
[   99.137873] oom_reaper: reaped process 2782 (Xorg), now anon-rss:0kB, file-rss:0kB, shmem-rss:1468kB
[  192.530507] perf: interrupt took too long (3155 > 3141), lowering kernel.perf_event_max_sample_rate to 63250

All I'm doing is running
"find / -xdev -type f -print0 | xargs -0 -n 1 -P 8 stat > /dev/null"
inside the memory cgroup. Find, xargs and stat only use a tiny amount of ram
by themselves so most of the ram usage in the cgroup is ext4 inode cache.
That should never trigger the OOM killer (outside or inside the cgroup).
Instead old cache data should be evicted.
