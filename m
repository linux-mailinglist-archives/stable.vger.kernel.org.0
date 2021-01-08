Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54F2EEA83
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 01:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbhAHAp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 19:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbhAHApO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 19:45:14 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91510C0612F5
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 16:44:33 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id k78so7814507ybf.12
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 16:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lQkPELLMuWIdZ7R4G/NyBJ5PxseZjJfaRY/veXfWXrg=;
        b=CVp+LDZLflS2OkUp1B7xr0HxrQ6vCOWUc5efC5CLjKpZ7Ev56Abe6dXvZ298tRLL9h
         3bsg4jv/QPPn8KCcJuuwKrkIPACzv6cKvOUnyl0dCxzNbC3Bx1QD4vAtFzrl8DLoSARu
         lUdykgm1pMpDiAQb+/nSEgd2pE7bRUsLgR0KrarEEjS/WIe5IIpTaa9Tvy2Rnzcegj+1
         EmLkTOYCd1OXFILNV++vS+9wFeku0r7pRYCgnSqTOU+iktVplsWNGKknje7v0CPUyOSc
         r1acfFRvWIzMjvpqW9gx7IcToN/5TZrmSfH2AULHinqHBM9Kdx37TN7RfTPewPnCdamz
         oDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lQkPELLMuWIdZ7R4G/NyBJ5PxseZjJfaRY/veXfWXrg=;
        b=lBPH5ZXBcG5JJfM+a2JEDPbYQPvpJ+cMadudBfQ97AehbOsVvtjEWxUXExsMZaB9EW
         qgIwHpiEtBzL36g0eA+5/07giDRSY+SuBCU9B/YMODyxN5RgnUadoLtMEJoOMb6Nh/cl
         9+X95AbLaVH9+Badk553uzE1lnG8J+Eo4cOgFIVX4DYCDsFiLe4R5RBJdfFP3DEb1YMt
         Frc62PdbC4DoynZlRf5uuGgNM7Soewb0kd7y5sXg1mDG0n0faTXQNqPCqrux0gq0DSNb
         OjR7KMIfQfAtm2CreOx+87Zc8Lv+0ku1aTzXJICig+WU3P+XkjZ0yKk/byNYVToGYnfD
         EsDw==
X-Gm-Message-State: AOAM532Tx68bODWj4gBHlN8vwtoLVCdXmWdiREKdC+3f5Hg3P2Z1iDQq
        29y8FThfEuPAWAD0/7g+B2c627OSHqI4DHTWR0slvw==
X-Google-Smtp-Source: ABdhPJyoIKY/0jQqT2pTBeBC3eJxRAz/10nu236A+IoWtweM3U3qBxkbZYCeVe86yoRdWGwlyZsYJuz8X0tXmCfSJFY=
X-Received: by 2002:a25:4f55:: with SMTP id d82mr2172182ybb.466.1610066671250;
 Thu, 07 Jan 2021 16:44:31 -0800 (PST)
MIME-Version: 1.0
References: <20210107234136.740371-1-saravanak@google.com> <b3cda25a3e3911a12a8766f141c9e300@walle.cc>
In-Reply-To: <b3cda25a3e3911a12a8766f141c9e300@walle.cc>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 7 Jan 2021 16:43:54 -0800
Message-ID: <CAGETcx-q04E0TW6LMoyoRC64xH25Uogk7twSNEbT411ciZPfUw@mail.gmail.com>
Subject: Re: [PATCH v2] driver core: Fix device link device name collision
To:     Michael Walle <michael@walle.cc>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 7, 2021 at 4:14 PM Michael Walle <michael@walle.cc> wrote:
>
> Am 2021-01-08 00:41, schrieb Saravana Kannan:
> > The device link device's name was of the form:
> > <supplier-dev-name>--<consumer-dev-name>
> >
> > This can cause name collision as reported here [1] as device names are
> > not globally unique. Since device names have to be unique within the
> > bus/class, add the bus/class name as a prefix to the device names used
> > to
> > construct the device link device name.
> >
> > So the devuce link device's name will be of the form:
> > <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> >
> > [1] -
> > https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 287905e68dd2 ("driver core: Expose device link details in
> > sysfs")
> > Reported-by: Michael Walle <michael@walle.cc>
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > ---
>
> This makes it even worse. Please see below for a full bootlog with the
> dev_dbg() converted to dev_info() and initcall_debug enabled.

Sorry if I'm missing something obvious (been a long day), but how is
it worse? I don't see any warnings in this log. I'll reply to your
other emails separately.

-Saravana

>
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
> [    0.000000] Linux version
> 5.11.0-rc2-next-20210107-00018-g832f4343aa38-dirty (mwalle@mwalle01)
> (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0, GNU ld (GNU Binutils for
> Debian) 2.31.1) #307 SMP PREEMPT Fri Jan 8 01:03:51 CET 2021
> [    0.000000] Machine model: Kontron KBox A-230-LS
> [    0.000000] efi: UEFI not found.
> [    0.000000] cma: Reserved 32 MiB at 0x00000000fcc00000
> [    0.000000] NUMA: No NUMA configuration found
> [    0.000000] NUMA: Faking a node at [mem
> 0x0000000080000000-0x00000020ffffffff]
> [    0.000000] NUMA: NODE_DATA [mem 0x20ff7db200-0x20ff7dcfff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000080000000-0x00000000ffffffff]
> [    0.000000]   DMA32    empty
> [    0.000000]   Normal   [mem 0x0000000100000000-0x00000020ffffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000080000000-0x00000000ffffffff]
> [    0.000000]   node   0: [mem 0x0000002080000000-0x00000020ffffffff]
> [    0.000000] Initmem setup node 0 [mem
> 0x0000000080000000-0x00000020ffffffff]
> [    0.000000] On node 0 totalpages: 1048576
> [    0.000000]   DMA zone: 8192 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 524288 pages, LIFO batch:63
> [    0.000000]   Normal zone: 8192 pages used for memmap
> [    0.000000]   Normal zone: 524288 pages, LIFO batch:63
> [    0.000000] percpu: Embedded 31 pages/cpu s89752 r8192 d29032 u126976
> [    0.000000] pcpu-alloc: s89752 r8192 d29032 u126976 alloc=31*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1
> [    0.000000] Detected PIPT I-cache on CPU0
> [    0.000000] CPU features: detected: GIC system register CPU interface
> [    0.000000] CPU features: detected: Spectre-v3a
> [    0.000000] CPU features: detected: Spectre-v2
> [    0.000000] CPU features: detected: Spectre-v4
> [    0.000000] CPU features: detected: ARM errata 1165522, 1319367, or
> 1530923
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages:
> 1032192
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: debug root=/dev/mmcblk0p2 rootwait
> initcall_debug
> [    0.000000] Dentry cache hash table entries: 524288 (order: 10,
> 4194304 bytes, linear)
> [    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152
> bytes, linear)
> [    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
> [    0.000000] software IO TLB: mapped [mem
> 0x00000000f8c00000-0x00000000fcc00000] (64MB)
> [    0.000000] Memory: 3987084K/4194304K available (14656K kernel code,
> 2024K rwdata, 5752K rodata, 4800K init, 850K bss, 174452K reserved,
> 32768K cma-reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2,
> Nodes=1
> [    0.000000] ftrace: allocating 51338 entries in 201 pages
> [    0.000000] ftrace: allocated 201 pages with 4 groups
> [    0.000000] rcu: Preemptible hierarchical RCU implementation.
> [    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=256 to
> nr_cpu_ids=2.
> [    0.000000]  Trampoline variant of Tasks RCU enabled.
> [    0.000000]  Rude variant of Tasks RCU enabled.
> [    0.000000] rcu: RCU calculated value of scheduler-enlistment delay
> is 25 jiffies.
> [    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16,
> nr_cpu_ids=2
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv3: 256 SPIs implemented
> [    0.000000] GICv3: 0 Extended SPIs implemented
> [    0.000000] GICv3: Distributor has no Range Selector support
> [    0.000000] GICv3: 16 PPIs implemented
> [    0.000000] GICv3: CPU0: found redistributor 0 region
> 0:0x0000000006040000
> [    0.000000] ITS [mem 0x06020000-0x0603ffff]
> [    0.000000] ITS@0x0000000006020000: allocated 65536 Devices
> @2080180000 (flat, esz 8, psz 64K, shr 0)
> [    0.000000] ITS: using cache flushing for cmd queue
> [    0.000000] GICv3: using LPI property table @0x0000002080200000
> [    0.000000] GIC: using cache flushing for LPI property table
> [    0.000000] GICv3: CPU0: using allocated LPI pending table
> @0x0000002080210000
> [    0.000000] random: get_random_bytes called from
> start_kernel+0x668/0x830 with crng_init=0
> [    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff
> max_cycles: 0x5c40939b5, max_idle_ns: 440795202646 ns
> [    0.000000] sched_clock: 56 bits at 25MHz, resolution 40ns, wraps
> every 4398046511100ns
> [    0.000091] calling  con_init+0x0/0x220 @ 0
> [    0.000129] Console: colour dummy device 80x25
> [    0.000402] printk: console [tty0] enabled
> [    0.000409] initcall con_init+0x0/0x220 returned 0 after 0 usecs
> [    0.000420] calling  hvc_console_init+0x0/0x34 @ 0
> [    0.000429] initcall hvc_console_init+0x0/0x34 returned 0 after 0
> usecs
> [    0.000439] calling  xen_cons_init+0x0/0x88 @ 0
> [    0.000450] initcall xen_cons_init+0x0/0x88 returned 0 after 0 usecs
> [    0.000459] calling  univ8250_console_init+0x0/0x50 @ 0
> [    0.000471] initcall univ8250_console_init+0x0/0x50 returned 0 after
> 0 usecs
> [    0.000516] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 50.00 BogoMIPS (lpj=100000)
> [    0.000532] pid_max: default: 32768 minimum: 301
> [    0.000577] LSM: Security Framework initializing
> [    0.000629] Mount-cache hash table entries: 8192 (order: 4, 65536
> bytes, linear)
> [    0.000664] Mountpoint-cache hash table entries: 8192 (order: 4,
> 65536 bytes, linear)
> [    0.001530] calling  trace_init_flags_sys_enter+0x0/0x2c @ 1
> [    0.001552] initcall trace_init_flags_sys_enter+0x0/0x2c returned 0
> after 0 usecs
> [    0.001565] calling  trace_init_flags_sys_exit+0x0/0x2c @ 1
> [    0.001575] initcall trace_init_flags_sys_exit+0x0/0x2c returned 0
> after 0 usecs
> [    0.001587] calling  cpu_suspend_init+0x0/0x58 @ 1
> [    0.001598] initcall cpu_suspend_init+0x0/0x58 returned 0 after 0
> usecs
> [    0.001610] calling  asids_init+0x0/0xc8 @ 1
> [    0.001628] initcall asids_init+0x0/0xc8 returned 0 after 0 usecs
> [    0.001638] calling  xen_guest_init+0x0/0x34c @ 1
> [    0.001650] initcall xen_guest_init+0x0/0x34c returned 0 after 0
> usecs
> [    0.001661] calling  spawn_ksoftirqd+0x0/0x58 @ 1
> [    0.001718] initcall spawn_ksoftirqd+0x0/0x58 returned 0 after 0
> usecs
> [    0.001731] calling  migration_init+0x0/0x64 @ 1
> [    0.001740] initcall migration_init+0x0/0x64 returned 0 after 0 usecs
> [    0.001749] calling  srcu_bootup_announce+0x0/0x50 @ 1
> [    0.001759] rcu: Hierarchical SRCU implementation.
> [    0.001766] initcall srcu_bootup_announce+0x0/0x50 returned 0 after 0
> usecs
> [    0.001777] calling  rcu_spawn_core_kthreads+0x0/0xcc @ 1
> [    0.001787] initcall rcu_spawn_core_kthreads+0x0/0xcc returned 0
> after 0 usecs
> [    0.001799] calling  rcu_spawn_gp_kthread+0x0/0x16c @ 1
> [    0.001854] initcall rcu_spawn_gp_kthread+0x0/0x16c returned 0 after
> 0 usecs
> [    0.001868] calling  check_cpu_stall_init+0x0/0x3c @ 1
> [    0.001878] initcall check_cpu_stall_init+0x0/0x3c returned 0 after 0
> usecs
> [    0.001889] calling  rcu_sysrq_init+0x0/0x48 @ 1
> [    0.001898] initcall rcu_sysrq_init+0x0/0x48 returned 0 after 0 usecs
> [    0.001909] calling  cpu_stop_init+0x0/0xd8 @ 1
> [    0.001972] initcall cpu_stop_init+0x0/0xd8 returned 0 after 0 usecs
> [    0.001986] calling  init_events+0x0/0x68 @ 1
> [    0.002014] initcall init_events+0x0/0x68 returned 0 after 0 usecs
> [    0.002026] calling  init_trace_printk+0x0/0x28 @ 1
> [    0.002037] initcall init_trace_printk+0x0/0x28 returned 0 after 0
> usecs
> [    0.002049] calling  event_trace_enable_again+0x0/0x38 @ 1
> [    0.002061] initcall event_trace_enable_again+0x0/0x38 returned 0
> after 0 usecs
> [    0.002074] calling  jump_label_init_module+0x0/0x2c @ 1
> [    0.002083] initcall jump_label_init_module+0x0/0x2c returned 0 after
> 0 usecs
> [    0.002092] calling  initialize_ptr_random+0x0/0x70 @ 1
> [    0.002105] initcall initialize_ptr_random+0x0/0x70 returned 0 after
> 0 usecs
> [    0.002116] calling  its_pmsi_init+0x0/0xb8 @ 1
> [    0.002158] Platform MSI: gic-its@6020000 domain created
> [    0.002224] initcall its_pmsi_init+0x0/0xb8 returned 0 after 0 usecs
> [    0.002236] calling  its_pci_msi_init+0x0/0xd4 @ 1
> [    0.002263] PCI/MSI: /interrupt-controller@6000000/gic-its@6020000
> domain created
> [    0.002304] initcall its_pci_msi_init+0x0/0xd4 returned 0 after 0
> usecs
> [    0.002316] calling  brcmstb_soc_device_early_init+0x0/0xb0 @ 1
> [    0.002493] initcall brcmstb_soc_device_early_init+0x0/0xb0 returned
> 0 after 0 usecs
> [    0.002506] calling  brcmstb_biuctrl_init+0x0/0x468 @ 1
> [    0.002546] initcall brcmstb_biuctrl_init+0x0/0x468 returned 0 after
> 0 usecs
> [    0.002558] calling  efi_memreserve_root_init+0x0/0x48 @ 1
> [    0.002571] initcall efi_memreserve_root_init+0x0/0x48 returned 0
> after 0 usecs
> [    0.002582] calling  arm_enable_runtime_services+0x0/0x1fc @ 1
> [    0.002593] EFI services will not be available.
> [    0.002600] initcall arm_enable_runtime_services+0x0/0x1fc returned 0
> after 0 usecs
> [    0.002612] calling  efi_earlycon_remap_fb+0x0/0x84 @ 1
> [    0.002623] initcall efi_earlycon_remap_fb+0x0/0x84 returned 0 after
> 0 usecs
> [    0.002634] calling  dummy_timer_register+0x0/0x44 @ 1
> [    0.002647] initcall dummy_timer_register+0x0/0x44 returned 0 after 0
> usecs
> [    0.002744] smp: Bringing up secondary CPUs ...
> [    0.003018] Detected PIPT I-cache on CPU1
> [    0.003039] GICv3: CPU1: found redistributor 1 region
> 0:0x0000000006060000
> [    0.003048] GICv3: CPU1: using allocated LPI pending table
> @0x0000002080220000
> [    0.003078] CPU1: Booted secondary processor 0x0000000001
> [0x410fd083]
> [    0.003145] smp: Brought up 1 node, 2 CPUs
> [    0.003174] SMP: Total of 2 processors activated.
> [    0.003182] CPU features: detected: 32-bit EL0 Support
> [    0.003190] CPU features: detected: CRC32 instructions
> [    0.003198] CPU features: detected: 32-bit EL1 Support
> [    0.012521] CPU: All CPU(s) started at EL2
> [    0.012548] alternatives: patching kernel code
> [    0.013286] devtmpfs: initialized
> [    0.015387] calling  bpf_jit_charge_init+0x0/0x4c @ 1
> [    0.015411] initcall bpf_jit_charge_init+0x0/0x4c returned 0 after 0
> usecs
> [    0.015422] calling  ipc_ns_init+0x0/0x4c @ 1
> [    0.015438] initcall ipc_ns_init+0x0/0x4c returned 0 after 0 usecs
> [    0.015448] calling  init_mmap_min_addr+0x0/0x28 @ 1
> [    0.015458] initcall init_mmap_min_addr+0x0/0x28 returned 0 after 0
> usecs
> [    0.015468] calling  pci_realloc_setup_params+0x0/0x54 @ 1
> [    0.015478] initcall pci_realloc_setup_params+0x0/0x54 returned 0
> after 0 usecs
> [    0.015488] calling  net_ns_init+0x0/0x164 @ 1
> [    0.015649] initcall net_ns_init+0x0/0x164 returned 0 after 0 usecs
> [    0.015666] calling  inet_frag_wq_init+0x0/0x5c @ 1
> [    0.015735] initcall inet_frag_wq_init+0x0/0x5c returned 0 after 0
> usecs
> [    0.015784] calling  fpsimd_init+0x0/0xd4 @ 1
> [    0.015800] initcall fpsimd_init+0x0/0xd4 returned 0 after 0 usecs
> [    0.015810] calling  tagged_addr_init+0x0/0x40 @ 1
> [    0.015827] initcall tagged_addr_init+0x0/0x40 returned 0 after 0
> usecs
> [    0.015837] calling  enable_mrs_emulation+0x0/0x34 @ 1
> [    0.015848] initcall enable_mrs_emulation+0x0/0x34 returned 0 after 0
> usecs
> [    0.015859] calling  kaslr_init+0x0/0x84 @ 1
> [    0.015870] KASLR disabled due to lack of seed
> [    0.015876] initcall kaslr_init+0x0/0x84 returned 0 after 0 usecs
> [    0.015886] calling  map_entry_trampoline+0x0/0x118 @ 1
> [    0.015910] initcall map_entry_trampoline+0x0/0x118 returned 0 after
> 0 usecs
> [    0.015922] calling  alloc_frozen_cpus+0x0/0x18 @ 1
> [    0.015932] initcall alloc_frozen_cpus+0x0/0x18 returned 0 after 0
> usecs
> [    0.015941] calling  cpu_hotplug_pm_sync_init+0x0/0x34 @ 1
> [    0.015951] initcall cpu_hotplug_pm_sync_init+0x0/0x34 returned 0
> after 0 usecs
> [    0.015961] calling  wq_sysfs_init+0x0/0x50 @ 1
> [    0.016003] initcall wq_sysfs_init+0x0/0x50 returned 0 after 3906
> usecs
> [    0.016015] calling  ksysfs_init+0x0/0xc8 @ 1
> [    0.016036] initcall ksysfs_init+0x0/0xc8 returned 0 after 0 usecs
> [    0.016046] calling  schedutil_gov_init+0x0/0x2c @ 1
> [    0.016056] initcall schedutil_gov_init+0x0/0x2c returned 0 after 0
> usecs
> [    0.016066] calling  pm_init+0x0/0x88 @ 1
> [    0.016105] initcall pm_init+0x0/0x88 returned 0 after 0 usecs
> [    0.016116] calling  pm_disk_init+0x0/0x34 @ 1
> [    0.016130] initcall pm_disk_init+0x0/0x34 returned 0 after 0 usecs
> [    0.016140] calling  swsusp_header_init+0x0/0x48 @ 1
> [    0.016150] initcall swsusp_header_init+0x0/0x48 returned 0 after 0
> usecs
> [    0.016160] calling  rcu_set_runtime_mode+0x0/0x34 @ 1
> [    0.016171] initcall rcu_set_runtime_mode+0x0/0x34 returned 0 after 0
> usecs
> [    0.016182] calling  dma_init_reserved_memory+0x0/0x74 @ 1
> [    0.016192] initcall dma_init_reserved_memory+0x0/0x74 returned -12
> after 0 usecs
> [    0.016204] calling  dma_debug_init+0x0/0x220 @ 1
> [    0.021946] DMA-API: preallocated 65536 debug entries
> [    0.021969] DMA-API: debugging enabled by kernel config
> [    0.021977] initcall dma_debug_init+0x0/0x220 returned 0 after 3906
> usecs
> [    0.021997] calling  init_jiffies_clocksource+0x0/0x34 @ 1
> [    0.022011] clocksource: jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.022025] initcall init_jiffies_clocksource+0x0/0x34 returned 0
> after 0 usecs
> [    0.022037] calling  futex_init+0x0/0x114 @ 1
> [    0.022052] futex hash table entries: 512 (order: 3, 32768 bytes,
> linear)
> [    0.022085] initcall futex_init+0x0/0x114 returned 0 after 0 usecs
> [    0.022096] calling  cgroup_wq_init+0x0/0x48 @ 1
> [    0.022121] initcall cgroup_wq_init+0x0/0x48 returned 0 after 0 usecs
> [    0.022132] calling  cgroup1_wq_init+0x0/0x48 @ 1
> [    0.022146] initcall cgroup1_wq_init+0x0/0x48 returned 0 after 0
> usecs
> [    0.022158] calling  ftrace_mod_cmd_init+0x0/0x28 @ 1
> [    0.022170] initcall ftrace_mod_cmd_init+0x0/0x28 returned 0 after 0
> usecs
> [    0.022181] calling  init_graph_trace+0x0/0x88 @ 1
> [    0.022201] initcall init_graph_trace+0x0/0x88 returned 0 after 0
> usecs
> [    0.022213] calling  cpu_pm_init+0x0/0x30 @ 1
> [    0.022226] initcall cpu_pm_init+0x0/0x30 returned 0 after 0 usecs
> [    0.022236] calling  init_zero_pfn+0x0/0x38 @ 1
> [    0.022245] initcall init_zero_pfn+0x0/0x38 returned 0 after 0 usecs
> [    0.022254] calling  mem_cgroup_swap_init+0x0/0x80 @ 1
> [    0.022276] initcall mem_cgroup_swap_init+0x0/0x80 returned 0 after 0
> usecs
> [    0.022286] calling  memory_failure_init+0x0/0xb0 @ 1
> [    0.022297] initcall memory_failure_init+0x0/0xb0 returned 0 after 0
> usecs
> [    0.022307] calling  cma_init_reserved_areas+0x0/0x194 @ 1
> [    0.022790] initcall cma_init_reserved_areas+0x0/0x194 returned 0
> after 0 usecs
> [    0.022804] calling  fsnotify_init+0x0/0x64 @ 1
> [    0.022841] initcall fsnotify_init+0x0/0x64 returned 0 after 0 usecs
> [    0.022854] calling  filelock_init+0x0/0xdc @ 1
> [    0.022876] initcall filelock_init+0x0/0xdc returned 0 after 0 usecs
> [    0.022888] calling  init_script_binfmt+0x0/0x34 @ 1
> [    0.022899] initcall init_script_binfmt+0x0/0x34 returned 0 after 0
> usecs
> [    0.022910] calling  init_elf_binfmt+0x0/0x34 @ 1
> [    0.022920] initcall init_elf_binfmt+0x0/0x34 returned 0 after 0
> usecs
> [    0.022931] calling  init_compat_elf_binfmt+0x0/0x34 @ 1
> [    0.022942] initcall init_compat_elf_binfmt+0x0/0x34 returned 0 after
> 0 usecs
> [    0.022953] calling  configfs_init+0x0/0xc4 @ 1
> [    0.022975] initcall configfs_init+0x0/0xc4 returned 0 after 0 usecs
> [    0.022987] calling  debugfs_init+0x0/0x98 @ 1
> [    0.022998] initcall debugfs_init+0x0/0x98 returned 0 after 0 usecs
> [    0.023008] calling  tracefs_init+0x0/0x5c @ 1
> [    0.023018] initcall tracefs_init+0x0/0x5c returned 0 after 0 usecs
> [    0.023028] calling  securityfs_init+0x0/0xa0 @ 1
> [    0.023096] initcall securityfs_init+0x0/0xa0 returned 0 after 0
> usecs
> [    0.023130] calling  prandom_init_early+0x0/0x12c @ 1
> [    0.023142] initcall prandom_init_early+0x0/0x12c returned 0 after 0
> usecs
> [    0.023152] calling  pinctrl_init+0x0/0xd0 @ 1
> [    0.023163] pinctrl core: initialized pinctrl subsystem
> [    0.023194] initcall pinctrl_init+0x0/0xd0 returned 0 after 0 usecs
> [    0.023206] calling  gpiolib_dev_init+0x0/0x11c @ 1
> [    0.023244] initcall gpiolib_dev_init+0x0/0x11c returned 0 after 0
> usecs
> [    0.023257] calling  fsl_guts_init+0x0/0x30 @ 1
> [    0.023282] initcall fsl_guts_init+0x0/0x30 returned 0 after 0 usecs
> [    0.023295] calling  virtio_init+0x0/0x40 @ 1
> [    0.023320] initcall virtio_init+0x0/0x40 returned 0 after 0 usecs
> [    0.023332] calling  regulator_init+0x0/0xc4 @ 1
> [    0.023492] initcall regulator_init+0x0/0xc4 returned 0 after 0 usecs
> [    0.023506] calling  iommu_init+0x0/0x50 @ 1
> [    0.023522]
> [    0.023527]
> *************************************************************
> [    0.023534] **     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
>   **
> [    0.023541] **
>   **
> [    0.023548] **  IOMMU DebugFS SUPPORT HAS BEEN ENABLED IN THIS KERNEL
>   **
> [    0.023555] **
>   **
> [    0.023561] ** This means that this kernel is built to expose
> internal **
> [    0.023567] ** IOMMU data structures, which may compromise security
> on **
> [    0.023574] ** your system.
>   **
> [    0.023581] **
>   **
> [    0.023587] ** If you see this message and you are not debugging the
>   **
> [    0.023594] ** kernel, report this immediately to your vendor!
>   **
> [    0.023600] **
>   **
> [    0.023606] **     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
>   **
> [    0.023613]
> *************************************************************
> [    0.023619] initcall iommu_init+0x0/0x50 returned 0 after 0 usecs
> [    0.023630] calling  component_debug_init+0x0/0x3c @ 1
> [    0.023643] initcall component_debug_init+0x0/0x3c returned 0 after 0
> usecs
> [    0.023654] calling  genpd_bus_init+0x0/0x30 @ 1
> [    0.023675] initcall genpd_bus_init+0x0/0x30 returned 0 after 0 usecs
> [    0.023686] calling  soc_bus_register+0x0/0x64 @ 1
> [    0.023707] initcall soc_bus_register+0x0/0x64 returned 0 after 0
> usecs
> [    0.023718] calling  register_cpufreq_notifier+0x0/0x70 @ 1
> [    0.023728] initcall register_cpufreq_notifier+0x0/0x70 returned -22
> after 0 usecs
> [    0.023740] calling  opp_debug_init+0x0/0x3c @ 1
> [    0.023761] initcall opp_debug_init+0x0/0x3c returned 0 after 0 usecs
> [    0.023772] calling  cpufreq_core_init+0x0/0x88 @ 1
> [    0.023786] initcall cpufreq_core_init+0x0/0x88 returned 0 after 0
> usecs
> [    0.023796] calling  cpufreq_gov_performance_init+0x0/0x2c @ 1
> [    0.023807] initcall cpufreq_gov_performance_init+0x0/0x2c returned 0
> after 0 usecs
> [    0.023819] calling  cpufreq_gov_userspace_init+0x0/0x2c @ 1
> [    0.023829] initcall cpufreq_gov_userspace_init+0x0/0x2c returned 0
> after 0 usecs
> [    0.023840] calling  CPU_FREQ_GOV_ONDEMAND_init+0x0/0x30 @ 1
> [    0.023850] initcall CPU_FREQ_GOV_ONDEMAND_init+0x0/0x30 returned 0
> after 0 usecs
> [    0.023861] calling  cpufreq_dt_platdev_init+0x0/0x150 @ 1
> [    0.023896] initcall cpufreq_dt_platdev_init+0x0/0x150 returned -19
> after 0 usecs
> [    0.023908] calling  cpuidle_init+0x0/0x40 @ 1
> [    0.023924] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
> [    0.023935] calling  capsule_reboot_register+0x0/0x30 @ 1
> [    0.023947] initcall capsule_reboot_register+0x0/0x30 returned 0
> after 0 usecs
> [    0.023959] calling  arm_dmi_init+0x0/0x28 @ 1
> [    0.023970] DMI not present or invalid.
> [    0.023976] initcall arm_dmi_init+0x0/0x28 returned 0 after 0 usecs
> [    0.023987] calling  sock_init+0x0/0xc4 @ 1
> [    0.024216] initcall sock_init+0x0/0xc4 returned 0 after 0 usecs
> [    0.024230] calling  net_inuse_init+0x0/0x40 @ 1
> [    0.024244] initcall net_inuse_init+0x0/0x40 returned 0 after 0 usecs
> [    0.024255] calling  net_defaults_init+0x0/0x40 @ 1
> [    0.024264] initcall net_defaults_init+0x0/0x40 returned 0 after 0
> usecs
> [    0.024274] calling  init_default_flow_dissectors+0x0/0x6c @ 1
> [    0.024286] initcall init_default_flow_dissectors+0x0/0x6c returned 0
> after 0 usecs
> [    0.024297] calling  netlink_proto_init+0x0/0x178 @ 1
> [    0.024356] NET: Registered protocol family 16
> [    0.024384] initcall netlink_proto_init+0x0/0x178 returned 0 after 0
> usecs
> [    0.024396] calling  genl_init+0x0/0x5c @ 1
> [    0.024413] initcall genl_init+0x0/0x5c returned 0 after 0 usecs
> [    0.024424] calling  trace_boot_init+0x0/0xf0 @ 1
> [    0.024434] initcall trace_boot_init+0x0/0xf0 returned 0 after 0
> usecs
> [    0.024443] calling  __gnttab_init+0x0/0x48 @ 1
> [    0.024454] initcall __gnttab_init+0x0/0x48 returned -19 after 0
> usecs
> [    0.024529] calling  debug_monitors_init+0x0/0x44 @ 1
> [    0.024581] initcall debug_monitors_init+0x0/0x44 returned 0 after 0
> usecs
> [    0.024593] calling  irq_sysfs_init+0x0/0xc0 @ 1
> [    0.024715] initcall irq_sysfs_init+0x0/0xc0 returned 0 after 0 usecs
> [    0.024726] calling  dma_atomic_pool_init+0x0/0x154 @ 1
> [    0.025299] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic
> allocations
> [    0.025408] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA pool for
> atomic allocations
> [    0.025580] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for
> atomic allocations
> [    0.025608] initcall dma_atomic_pool_init+0x0/0x154 returned 0 after
> 0 usecs
> [    0.025621] calling  audit_init+0x0/0x154 @ 1
> [    0.025636] audit: initializing netlink subsys (disabled)
> [    0.025758] initcall audit_init+0x0/0x154 returned 0 after 0 usecs
> [    0.025761] audit: type=2000 audit(0.024:1): state=initialized
> audit_enabled=0 res=1
> [    0.025767] calling  release_early_probes+0x0/0x64 @ 1
> [    0.025784] initcall release_early_probes+0x0/0x64 returned 0 after 0
> usecs
> [    0.025796] calling  bdi_class_init+0x0/0x88 @ 1
> [    0.025820] initcall bdi_class_init+0x0/0x88 returned 0 after 0 usecs
> [    0.025830] calling  mm_sysfs_init+0x0/0x4c @ 1
> [    0.025842] initcall mm_sysfs_init+0x0/0x4c returned 0 after 0 usecs
> [    0.025852] calling  init_per_zone_wmark_min+0x0/0x90 @ 1
> [    0.025870] initcall init_per_zone_wmark_min+0x0/0x90 returned 0
> after 0 usecs
> [    0.025882] calling  mpi_init+0x0/0x8c @ 1
> [    0.025894] initcall mpi_init+0x0/0x8c returned 0 after 0 usecs
> [    0.025904] calling  kobject_uevent_init+0x0/0x24 @ 1
> [    0.025919] initcall kobject_uevent_init+0x0/0x24 returned 0 after 0
> usecs
> [    0.025931] calling  acpi_gpio_setup_params+0x0/0x80 @ 1
> [    0.025944] initcall acpi_gpio_setup_params+0x0/0x80 returned 0 after
> 0 usecs
> [    0.025956] calling  pcibus_class_init+0x0/0x34 @ 1
> [    0.025975] initcall pcibus_class_init+0x0/0x34 returned 0 after 0
> usecs
> [    0.025988] calling  pci_driver_init+0x0/0x5c @ 1
> [    0.026021] initcall pci_driver_init+0x0/0x5c returned 0 after 0
> usecs
> [    0.026031] calling  backlight_class_init+0x0/0xcc @ 1
> [    0.026046] initcall backlight_class_init+0x0/0xcc returned 0 after 0
> usecs
> [    0.026056] calling  amba_init+0x0/0x2c @ 1
> [    0.026077] initcall amba_init+0x0/0x2c returned 0 after 0 usecs
> [    0.026088] calling  xenbus_init+0x0/0x29c @ 1
> [    0.026097] initcall xenbus_init+0x0/0x29c returned -19 after 0 usecs
> [    0.026106] calling  tty_class_init+0x0/0x68 @ 1
> [    0.026120] initcall tty_class_init+0x0/0x68 returned 0 after 0 usecs
> [    0.026130] calling  vtconsole_class_init+0x0/0x104 @ 1
> [    0.026176] initcall vtconsole_class_init+0x0/0x104 returned 0 after
> 0 usecs
> [    0.026187] calling  serdev_init+0x0/0x3c @ 1
> [    0.026210] initcall serdev_init+0x0/0x3c returned 0 after 0 usecs
> [    0.026221] calling  iommu_dev_init+0x0/0x34 @ 1
> [    0.026237] initcall iommu_dev_init+0x0/0x34 returned 0 after 0 usecs
> [    0.026248] calling  mipi_dsi_bus_init+0x0/0x2c @ 1
> [    0.026267] initcall mipi_dsi_bus_init+0x0/0x2c returned 0 after 0
> usecs
> [    0.026278] calling  devlink_class_init+0x0/0x70 @ 1
> [    0.026293] initcall devlink_class_init+0x0/0x70 returned 0 after 0
> usecs
> [    0.026304] calling  software_node_init+0x0/0x50 @ 1
> [    0.026316] initcall software_node_init+0x0/0x50 returned 0 after 0
> usecs
> [    0.026327] calling  wakeup_sources_debugfs_init+0x0/0x44 @ 1
> [    0.026341] initcall wakeup_sources_debugfs_init+0x0/0x44 returned 0
> after 0 usecs
> [    0.026354] calling  wakeup_sources_sysfs_init+0x0/0x50 @ 1
> [    0.026370] initcall wakeup_sources_sysfs_init+0x0/0x50 returned 0
> after 0 usecs
> [    0.026382] calling  register_node_type+0x0/0x30 @ 1
> [    0.026424] initcall register_node_type+0x0/0x30 returned 0 after 0
> usecs
> [    0.026436] calling  regmap_initcall+0x0/0x28 @ 1
> [    0.026449] initcall regmap_initcall+0x0/0x28 returned 0 after 0
> usecs
> [    0.026461] calling  sram_init+0x0/0x30 @ 1
> [    0.026483] initcall sram_init+0x0/0x30 returned 0 after 0 usecs
> [    0.026495] calling  syscon_init+0x0/0x34 @ 1
> [    0.026513] initcall syscon_init+0x0/0x34 returned 0 after 0 usecs
> [    0.026525] calling  spi_init+0x0/0xd4 @ 1
> [    0.026551] initcall spi_init+0x0/0xd4 returned 0 after 0 usecs
> [    0.026563] calling  spmi_init+0x0/0x40 @ 1
> [    0.026585] initcall spmi_init+0x0/0x40 returned 0 after 0 usecs
> [    0.026597] calling  i2c_init+0x0/0x10c @ 1
> [    0.026629] initcall i2c_init+0x0/0x10c returned 0 after 0 usecs
> [    0.026640] calling  thermal_init+0x0/0x15c @ 1
> [    0.026666] thermal_sys: Registered thermal governor 'step_wise'
> [    0.026818] initcall thermal_init+0x0/0x15c returned 0 after 0 usecs
> [    0.026835] calling  init_menu+0x0/0x2c @ 1
> [    0.026932] cpuidle: using governor menu
> [    0.026941] initcall init_menu+0x0/0x2c returned 0 after 0 usecs
> [    0.026953] calling  pcc_init+0x0/0x74 @ 1
> [    0.026962] initcall pcc_init+0x0/0x74 returned -19 after 0 usecs
> [    0.026971] calling  rpmsg_init+0x0/0x5c @ 1
> [    0.026997] initcall rpmsg_init+0x0/0x5c returned 0 after 0 usecs
> [    0.027057] calling  reserve_memblock_reserved_regions+0x0/0x16c @ 1
> [    0.027088] initcall reserve_memblock_reserved_regions+0x0/0x16c
> returned 0 after 0 usecs
> [    0.027101] calling  aarch32_alloc_vdso_pages+0x0/0xd8 @ 1
> [    0.027118] initcall aarch32_alloc_vdso_pages+0x0/0xd8 returned 0
> after 0 usecs
> [    0.027129] calling  vdso_init+0x0/0xf8 @ 1
> [    0.027139] initcall vdso_init+0x0/0xf8 returned 0 after 0 usecs
> [    0.027149] calling  arch_hw_breakpoint_init+0x0/0x100 @ 1
> [    0.027162] hw-breakpoint: found 6 breakpoint and 4 watchpoint
> registers.
> [    0.027196] initcall arch_hw_breakpoint_init+0x0/0x100 returned 0
> after 0 usecs
> [    0.027210] calling  asids_update_limit+0x0/0xe8 @ 1
> [    0.027221] ASID allocator initialised with 65536 entries
> [    0.027229] initcall asids_update_limit+0x0/0xe8 returned 0 after 0
> usecs
> [    0.027239] calling  hugetlbpage_init+0x0/0x44 @ 1
> [    0.027252] initcall hugetlbpage_init+0x0/0x44 returned 0 after 0
> usecs
> [    0.027264] calling  p2m_init+0x0/0x20 @ 1
> [    0.027276] initcall p2m_init+0x0/0x20 returned 0 after 0 usecs
> [    0.027287] calling  xen_mm_init+0x0/0x9c @ 1
> [    0.027298] initcall xen_mm_init+0x0/0x9c returned 0 after 0 usecs
> [    0.027309] calling  cryptomgr_init+0x0/0x2c @ 1
> [    0.027319] initcall cryptomgr_init+0x0/0x2c returned 0 after 0 usecs
> [    0.027329] calling  mpc8xxx_init+0x0/0x30 @ 1
> [    0.027353] initcall mpc8xxx_init+0x0/0x30 returned 0 after 0 usecs
> [    0.027365] calling  acpi_pci_init+0x0/0x8c @ 1
> [    0.027374] initcall acpi_pci_init+0x0/0x8c returned 0 after 0 usecs
> [    0.027383] calling  dma_channel_table_init+0x0/0x110 @ 1
> [    0.027412] initcall dma_channel_table_init+0x0/0x110 returned 0
> after 0 usecs
> [    0.027426] calling  dma_bus_init+0x0/0x144 @ 1
> [    0.027489] initcall dma_bus_init+0x0/0x144 returned 0 after 0 usecs
> [    0.027503] calling  brcmstb_soc_device_init+0x0/0x144 @ 1
> [    0.027702] initcall brcmstb_soc_device_init+0x0/0x144 returned 0
> after 0 usecs
> [    0.027716] calling  register_xen_platform_notifier+0x0/0x60 @ 1
> [    0.027725] initcall register_xen_platform_notifier+0x0/0x60 returned
> 0 after 0 usecs
> [    0.027736] calling  register_xen_amba_notifier+0x0/0x64 @ 1
> [    0.027745] initcall register_xen_amba_notifier+0x0/0x64 returned 0
> after 0 usecs
> [    0.027755] calling  register_xen_pci_notifier+0x0/0x54 @ 1
> [    0.027763] initcall register_xen_pci_notifier+0x0/0x54 returned 0
> after 0 usecs
> [    0.027773] calling  pl011_init+0x0/0x60 @ 1
> [    0.027782] Serial: AMBA PL011 UART driver
> [    0.027805] initcall pl011_init+0x0/0x60 returned 0 after 0 usecs
> [    0.027815] calling  cdns_uart_init+0x0/0x30 @ 1
> [    0.027834] initcall cdns_uart_init+0x0/0x30 returned 0 after 0 usecs
> [    0.027845] calling  iommu_dma_init+0x0/0x28 @ 1
> [    0.027859] initcall iommu_dma_init+0x0/0x28 returned 0 after 0 usecs
> [    0.027869] calling  dmi_id_init+0x0/0x2ec @ 1
> [    0.027879] initcall dmi_id_init+0x0/0x2ec returned -19 after 0 usecs
> [    0.027890] calling  of_platform_default_populate_init+0x0/0xdc @ 1
> [    0.029562] Machine: Kontron KBox A-230-LS
> [    0.029572] SoC family: QorIQ LS1028A
> [    0.029578] SoC ID: svr:0x870b0110, Revision: 1.0
> [    0.030276] platform 20c0000.spi: Linked as a sync state only
> consumer to 1e00900.clock-controller
> [    0.031139] platform 2270000.serial: Linked as a sync state only
> consumer to 22c0000.dma-controller
> [    0.031174] platform 2120000.spi: Linked as a sync state only
> consumer to 22c0000.dma-controller
> [    0.031599] platform 2000000.i2c: Linked as a sync state only
> consumer to 2310000.gpio
> [    0.034347] platform 3500000.pcie: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034392] platform 3400000.pcie: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034425] platform 3200000.sata: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034459] platform 3110000.usb: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034491] platform 3100000.usb: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034527] platform 22c0000.dma-controller: Linked as a sync state
> only consumer to 5000000.iommu
> [    0.034562] platform 2150000.mmc: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034594] platform 2140000.mmc: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034732] platform 8000000.crypto: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.034997] platform 8380000.dma-controller: Linked as a sync state
> only consumer to 5000000.iommu
> [    0.035422] platform 1f0000000.pcie: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.035799] platform f080000.display: Linked as a sync state only
> consumer to f1f0000.clock-controller
> [    0.035835] platform f080000.display: Linked as a sync state only
> consumer to 5000000.iommu
> [    0.036059] initcall of_platform_default_populate_init+0x0/0xdc
> returned 0 after 11718 usecs
> [    0.036136] calling  topology_init+0x0/0x130 @ 1
> [    0.036275] initcall topology_init+0x0/0x130 returned 0 after 0 usecs
> [    0.036288] calling  uid_cache_init+0x0/0xac @ 1
> [    0.036307] initcall uid_cache_init+0x0/0xac returned 0 after 0 usecs
> [    0.036318] calling  param_sysfs_init+0x0/0x1e8 @ 1
> [    0.041132] initcall param_sysfs_init+0x0/0x1e8 returned 0 after 3906
> usecs
> [    0.041148] calling  user_namespace_sysctl_init+0x0/0x5c @ 1
> [    0.041177] initcall user_namespace_sysctl_init+0x0/0x5c returned 0
> after 0 usecs
> [    0.041189] calling  pm_sysrq_init+0x0/0x34 @ 1
> [    0.041321] initcall pm_sysrq_init+0x0/0x34 returned 0 after 0 usecs
> [    0.041336] calling  create_proc_profile+0x0/0x118 @ 1
> [    0.041350] initcall create_proc_profile+0x0/0x118 returned 0 after 0
> usecs
> [    0.041362] calling  time_ns_init+0x0/0x18 @ 1
> [    0.041373] initcall time_ns_init+0x0/0x18 returned 0 after 0 usecs
> [    0.041383] calling  crash_save_vmcoreinfo_init+0x0/0x694 @ 1
> [    0.041466] initcall crash_save_vmcoreinfo_init+0x0/0x694 returned 0
> after 0 usecs
> [    0.041480] calling  crash_notes_memory_init+0x0/0x50 @ 1
> [    0.041497] initcall crash_notes_memory_init+0x0/0x50 returned 0
> after 0 usecs
> [    0.041510] calling  cgroup_sysfs_init+0x0/0x38 @ 1
> [    0.041528] initcall cgroup_sysfs_init+0x0/0x38 returned 0 after 0
> usecs
> [    0.041539] calling  cgroup_namespaces_init+0x0/0x18 @ 1
> [    0.041550] initcall cgroup_namespaces_init+0x0/0x18 returned 0 after
> 0 usecs
> [    0.041562] calling  user_namespaces_init+0x0/0x48 @ 1
> [    0.041585] initcall user_namespaces_init+0x0/0x48 returned 0 after 0
> usecs
> [    0.041597] calling  oom_init+0x0/0x4c @ 1
> [    0.041661] initcall oom_init+0x0/0x4c returned 0 after 0 usecs
> [    0.041675] calling  default_bdi_init+0x0/0xa8 @ 1
> [    0.041796] initcall default_bdi_init+0x0/0xa8 returned 0 after 0
> usecs
> [    0.041809] calling  cgwb_init+0x0/0x4c @ 1
> [    0.041822] initcall cgwb_init+0x0/0x4c returned 0 after 0 usecs
> [    0.041832] calling  percpu_enable_async+0x0/0x24 @ 1
> [    0.041841] initcall percpu_enable_async+0x0/0x24 returned 0 after 0
> usecs
> [    0.041850] calling  kcompactd_init+0x0/0xcc @ 1
> [    0.041912] initcall kcompactd_init+0x0/0xcc returned 0 after 0 usecs
> [    0.041925] calling  init_user_reserve+0x0/0x40 @ 1
> [    0.041936] initcall init_user_reserve+0x0/0x40 returned 0 after 0
> usecs
> [    0.041946] calling  init_admin_reserve+0x0/0x40 @ 1
> [    0.041954] initcall init_admin_reserve+0x0/0x40 returned 0 after 0
> usecs
> [    0.041963] calling  init_reserve_notifier+0x0/0x10 @ 1
> [    0.041976] initcall init_reserve_notifier+0x0/0x10 returned 0 after
> 0 usecs
> [    0.041987] calling  swap_init_sysfs+0x0/0x84 @ 1
> [    0.042002] initcall swap_init_sysfs+0x0/0x84 returned 0 after 0
> usecs
> [    0.042013] calling  swapfile_init+0x0/0xd0 @ 1
> [    0.042023] initcall swapfile_init+0x0/0xd0 returned 0 after 0 usecs
> [    0.042033] calling  hugetlb_init+0x0/0x4bc @ 1
> [    0.042046] HugeTLB registered 1.00 GiB page size, pre-allocated 0
> pages
> [    0.042055] HugeTLB registered 32.0 MiB page size, pre-allocated 0
> pages
> [    0.042064] HugeTLB registered 2.00 MiB page size, pre-allocated 0
> pages
> [    0.042072] HugeTLB registered 64.0 KiB page size, pre-allocated 0
> pages
> [    0.042164] initcall hugetlb_init+0x0/0x4bc returned 0 after 0 usecs
> [    0.042177] calling  ksm_init+0x0/0x198 @ 1
> [    0.042261] initcall ksm_init+0x0/0x198 returned 0 after 0 usecs
> [    0.042275] calling  hugepage_init+0x0/0x168 @ 1
> [    0.042364] initcall hugepage_init+0x0/0x168 returned 0 after 0 usecs
> [    0.042378] calling  mem_cgroup_init+0x0/0x178 @ 1
> [    0.042390] initcall mem_cgroup_init+0x0/0x178 returned 0 after 0
> usecs
> [    0.042400] calling  io_wq_init+0x0/0x54 @ 1
> [    0.042411] initcall io_wq_init+0x0/0x54 returned 0 after 0 usecs
> [    0.042422] calling  echainiv_module_init+0x0/0x2c @ 1
> [    0.042432] initcall echainiv_module_init+0x0/0x2c returned 0 after 0
> usecs
> [    0.042442] calling  rsa_init+0x0/0x68 @ 1
> [    0.042515] initcall rsa_init+0x0/0x68 returned 0 after 0 usecs
> [    0.042529] calling  hmac_module_init+0x0/0x2c @ 1
> [    0.042539] initcall hmac_module_init+0x0/0x2c returned 0 after 0
> usecs
> [    0.042549] calling  crypto_null_mod_init+0x0/0x90 @ 1
> [    0.042765] initcall crypto_null_mod_init+0x0/0x90 returned 0 after 0
> usecs
> [    0.042780] calling  md5_mod_init+0x0/0x2c @ 1
> [    0.042836] initcall md5_mod_init+0x0/0x2c returned 0 after 0 usecs
> [    0.042851] calling  sha1_generic_mod_init+0x0/0x2c @ 1
> [    0.042906] initcall sha1_generic_mod_init+0x0/0x2c returned 0 after
> 0 usecs
> [    0.042921] calling  sha256_generic_mod_init+0x0/0x30 @ 1
> [    0.043023] initcall sha256_generic_mod_init+0x0/0x30 returned 0
> after 0 usecs
> [    0.043038] calling  crypto_ecb_module_init+0x0/0x2c @ 1
> [    0.043048] initcall crypto_ecb_module_init+0x0/0x2c returned 0 after
> 0 usecs
> [    0.043058] calling  crypto_cbc_module_init+0x0/0x2c @ 1
> [    0.043068] initcall crypto_cbc_module_init+0x0/0x2c returned 0 after
> 0 usecs
> [    0.043078] calling  cryptd_init+0x0/0x138 @ 1
> [    0.043132] cryptd: max_cpu_qlen set to 1000
> [    0.043142] initcall cryptd_init+0x0/0x138 returned 0 after 0 usecs
> [    0.043154] calling  aes_init+0x0/0x2c @ 1
> [    0.043216] initcall aes_init+0x0/0x2c returned 0 after 0 usecs
> [    0.043229] calling  deflate_mod_init+0x0/0x60 @ 1
> [    0.043385] initcall deflate_mod_init+0x0/0x60 returned 0 after 0
> usecs
> [    0.043399] calling  crc32c_mod_init+0x0/0x2c @ 1
> [    0.043454] initcall crc32c_mod_init+0x0/0x2c returned 0 after 0
> usecs
> [    0.043468] calling  crct10dif_mod_init+0x0/0x2c @ 1
> [    0.043522] initcall crct10dif_mod_init+0x0/0x2c returned 0 after 0
> usecs
> [    0.043536] calling  prng_mod_init+0x0/0x30 @ 1
> [    0.043589] initcall prng_mod_init+0x0/0x30 returned 0 after 0 usecs
> [    0.043603] calling  drbg_init+0x0/0xfc @ 1
> [    0.044048] initcall drbg_init+0x0/0xfc returned 0 after 3906 usecs
> [    0.044064] calling  init_bio+0x0/0xfc @ 1
> [    0.044154] initcall init_bio+0x0/0xfc returned 0 after 0 usecs
> [    0.044168] calling  blk_settings_init+0x0/0x40 @ 1
> [    0.044178] initcall blk_settings_init+0x0/0x40 returned 0 after 0
> usecs
> [    0.044188] calling  blk_ioc_init+0x0/0x48 @ 1
> [    0.044198] initcall blk_ioc_init+0x0/0x48 returned 0 after 0 usecs
> [    0.044208] calling  blk_mq_init+0x0/0x104 @ 1
> [    0.044219] initcall blk_mq_init+0x0/0x104 returned 0 after 0 usecs
> [    0.044229] calling  genhd_device_init+0x0/0x8c @ 1
> [    0.044339] initcall genhd_device_init+0x0/0x8c returned 0 after 0
> usecs
> [    0.044354] calling  blkcg_init+0x0/0x4c @ 1
> [    0.044443] initcall blkcg_init+0x0/0x4c returned 0 after 0 usecs
> [    0.044457] calling  irq_poll_setup+0x0/0xb0 @ 1
> [    0.044468] initcall irq_poll_setup+0x0/0xb0 returned 0 after 0 usecs
> [    0.044478] calling  gpiolib_debugfs_init+0x0/0x48 @ 1
> [    0.044497] initcall gpiolib_debugfs_init+0x0/0x48 returned 0 after 0
> usecs
> [    0.044509] calling  max732x_init+0x0/0x30 @ 1
> [    0.044534] initcall max732x_init+0x0/0x30 returned 0 after 0 usecs
> [    0.044546] calling  pca953x_init+0x0/0x30 @ 1
> [    0.044566] initcall pca953x_init+0x0/0x30 returned 0 after 0 usecs
> [    0.044578] calling  pwm_debugfs_init+0x0/0x44 @ 1
> [    0.044592] initcall pwm_debugfs_init+0x0/0x44 returned 0 after 0
> usecs
> [    0.044604] calling  pwm_sysfs_init+0x0/0x34 @ 1
> [    0.044621] initcall pwm_sysfs_init+0x0/0x34 returned 0 after 0 usecs
> [    0.044634] calling  pci_slot_init+0x0/0x68 @ 1
> [    0.044648] initcall pci_slot_init+0x0/0x68 returned 0 after 0 usecs
> [    0.044659] calling  xgene_pcie_msi_init+0x0/0x30 @ 1
> [    0.044759] initcall xgene_pcie_msi_init+0x0/0x30 returned 0 after 0
> usecs
> [    0.044769] calling  altera_msi_init+0x0/0x30 @ 1
> [    0.044816] initcall altera_msi_init+0x0/0x30 returned 0 after 0
> usecs
> [    0.044827] calling  fbmem_init+0x0/0x108 @ 1
> [    0.044874] initcall fbmem_init+0x0/0x108 returned 0 after 0 usecs
> [    0.044884] calling  scan_for_dmi_ipmi+0x0/0x288 @ 1
> [    0.044894] initcall scan_for_dmi_ipmi+0x0/0x288 returned 0 after 0
> usecs
> [    0.044904] calling  acpi_init+0x0/0x328 @ 1
> [    0.044913] ACPI: Interpreter disabled.
> [    0.044919] initcall acpi_init+0x0/0x328 returned -19 after 0 usecs
> [    0.044929] calling  pnp_init+0x0/0x2c @ 1
> [    0.044953] initcall pnp_init+0x0/0x2c returned 0 after 0 usecs
> [    0.044965] calling  fsl_edma_init+0x0/0x30 @ 1
> [    0.045063] initcall fsl_edma_init+0x0/0x30 returned 0 after 0 usecs
> [    0.045077] calling  balloon_init+0x0/0xec @ 1
> [    0.045087] initcall balloon_init+0x0/0xec returned -19 after 0 usecs
> [    0.045099] calling  xen_setup_shutdown_event+0x0/0x58 @ 1
> [    0.045111] initcall xen_setup_shutdown_event+0x0/0x58 returned -19
> after 0 usecs
> [    0.045123] calling  xenbus_probe_backend_init+0x0/0x64 @ 1
> [    0.045148] initcall xenbus_probe_backend_init+0x0/0x64 returned 0
> after 0 usecs
> [    0.045159] calling  xenbus_probe_frontend_init+0x0/0x4c @ 1
> [    0.045180] initcall xenbus_probe_frontend_init+0x0/0x4c returned 0
> after 0 usecs
> [    0.045191] calling  regulator_fixed_voltage_init+0x0/0x30 @ 1
> [    0.045247] initcall regulator_fixed_voltage_init+0x0/0x30 returned 0
> after 0 usecs
> [    0.045259] calling  gpio_regulator_init+0x0/0x30 @ 1
> [    0.045303] initcall gpio_regulator_init+0x0/0x30 returned 0 after 0
> usecs
> [    0.045313] calling  max8973_init+0x0/0x30 @ 1
> [    0.045330] initcall max8973_init+0x0/0x30 returned 0 after 0 usecs
> [    0.045340] calling  misc_init+0x0/0xec @ 1
> [    0.045358] initcall misc_init+0x0/0xec returned 0 after 0 usecs
> [    0.045368] calling  tpm_init+0x0/0x128 @ 1
> [    0.045448] initcall tpm_init+0x0/0x128 returned 0 after 0 usecs
> [    0.045461] calling  iommu_subsys_init+0x0/0x88 @ 1
> [    0.045471] iommu: Default domain type: Translated
> [    0.045478] initcall iommu_subsys_init+0x0/0x88 returned 0 after 0
> usecs
> [    0.045488] calling  vga_arb_device_init+0x0/0x1c8 @ 1
> [    0.045565] vgaarb: loaded
> [    0.045572] initcall vga_arb_device_init+0x0/0x1c8 returned 0 after 0
> usecs
> [    0.045583] calling  register_cpu_capacity_sysctl+0x0/0xa8 @ 1
> [    0.045603] initcall register_cpu_capacity_sysctl+0x0/0xa8 returned 0
> after 0 usecs
> [    0.045616] calling  sec_pmic_init+0x0/0x30 @ 1
> [    0.045636] initcall sec_pmic_init+0x0/0x30 returned 0 after 0 usecs
> [    0.045647] calling  bd718xx_i2c_init+0x0/0x30 @ 1
> [    0.045666] initcall bd718xx_i2c_init+0x0/0x30 returned 0 after 0
> usecs
> [    0.045677] calling  dma_buf_init+0x0/0xc8 @ 1
> [    0.045726] initcall dma_buf_init+0x0/0xc8 returned 0 after 0 usecs
> [    0.045739] calling  init_scsi+0x0/0x94 @ 1
> [    0.045843] SCSI subsystem initialized
> [    0.045850] initcall init_scsi+0x0/0x94 returned 0 after 0 usecs
> [    0.045862] calling  ata_init+0x0/0x360 @ 1
> [    0.045955] libata version 3.00 loaded.
> [    0.045964] initcall ata_init+0x0/0x360 returned 0 after 0 usecs
> [    0.045977] calling  pl022_init+0x0/0x2c @ 1
> [    0.046000] initcall pl022_init+0x0/0x2c returned 0 after 0 usecs
> [    0.046011] calling  phy_init+0x0/0x470 @ 1
> [    0.046056] initcall phy_init+0x0/0x470 returned 0 after 0 usecs
> [    0.046068] calling  hnae_init+0x0/0x50 @ 1
> [    0.046084] initcall hnae_init+0x0/0x50 returned 0 after 0 usecs
> [    0.046095] calling  usb_common_init+0x0/0x3c @ 1
> [    0.046111] initcall usb_common_init+0x0/0x3c returned 0 after 0
> usecs
> [    0.046123] calling  ulpi_init+0x0/0x2c @ 1
> [    0.046144] initcall ulpi_init+0x0/0x2c returned 0 after 0 usecs
> [    0.046156] calling  usb_init+0x0/0x160 @ 1
> [    0.046217] usbcore: registered new interface driver usbfs
> [    0.046242] usbcore: registered new interface driver hub
> [    0.046263] usbcore: registered new device driver usb
> [    0.046270] initcall usb_init+0x0/0x160 returned 0 after 0 usecs
> [    0.046282] calling  usb_phy_generic_init+0x0/0x30 @ 1
> [    0.046353] initcall usb_phy_generic_init+0x0/0x30 returned 0 after 0
> usecs
> [    0.046366] calling  usb_udc_init+0x0/0x74 @ 1
> [    0.046382] initcall usb_udc_init+0x0/0x74 returned 0 after 0 usecs
> [    0.046392] calling  typec_init+0x0/0xb0 @ 1
> [    0.046418] initcall typec_init+0x0/0xb0 returned 0 after 0 usecs
> [    0.046429] calling  usb_roles_init+0x0/0x50 @ 1
> [    0.046442] initcall usb_roles_init+0x0/0x50 returned 0 after 0 usecs
> [    0.046452] calling  serio_init+0x0/0x54 @ 1
> [    0.046472] initcall serio_init+0x0/0x54 returned 0 after 0 usecs
> [    0.046482] calling  input_init+0x0/0x130 @ 1
> [    0.046502] initcall input_init+0x0/0x130 returned 0 after 0 usecs
> [    0.046512] calling  rtc_init+0x0/0x74 @ 1
> [    0.046526] initcall rtc_init+0x0/0x74 returned 0 after 0 usecs
> [    0.046536] calling  dw_i2c_init_driver+0x0/0x30 @ 1
> [    0.046593] initcall dw_i2c_init_driver+0x0/0x30 returned 0 after 0
> usecs
> [    0.046604] calling  i2c_adap_imx_init+0x0/0x30 @ 1
> [    0.046726] imx-i2c 2000000.i2c: can't get pinctrl, bus recovery not
> supported
> [    0.046925] i2c 0-004a: Linked as a sync state only consumer to
> 2310000.gpio
> [    0.047013] i2c i2c-0: IMX I2C adapter registered
> [    0.047173] imx-i2c 2030000.i2c: can't get pinctrl, bus recovery not
> supported
> [    0.047279] i2c i2c-1: IMX I2C adapter registered
> [    0.047380] imx-i2c 2040000.i2c: can't get pinctrl, bus recovery not
> supported
> [    0.047489] i2c i2c-2: IMX I2C adapter registered
> [    0.047565] initcall i2c_adap_imx_init+0x0/0x30 returned 0 after 0
> usecs
> [    0.047579] calling  media_devnode_init+0x0/0xa0 @ 1
> [    0.047589] mc: Linux media interface: v0.10
> [    0.047609] initcall media_devnode_init+0x0/0xa0 returned 0 after 0
> usecs
> [    0.047621] calling  videodev_init+0x0/0xa8 @ 1
> [    0.047630] videodev: Linux video capture interface: v2.00
> [    0.047643] initcall videodev_init+0x0/0xa8 returned 0 after 0 usecs
> [    0.047653] calling  init_dvbdev+0x0/0x100 @ 1
> [    0.047669] initcall init_dvbdev+0x0/0x100 returned 0 after 0 usecs
> [    0.047679] calling  pps_init+0x0/0xdc @ 1
> [    0.047696] pps_core: LinuxPPS API ver. 1 registered
> [    0.047703] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
> Rodolfo Giometti <giometti@linux.it>
> [    0.047713] initcall pps_init+0x0/0xdc returned 0 after 0 usecs
> [    0.047722] calling  ptp_init+0x0/0xc0 @ 1
> [    0.047736] PTP clock support registered
> [    0.047742] initcall ptp_init+0x0/0xc0 returned 0 after 0 usecs
> [    0.047752] calling  brcmstb_reboot_init+0x0/0x38 @ 1
> [    0.047812] initcall brcmstb_reboot_init+0x0/0x38 returned -19 after
> 0 usecs
> [    0.047823] calling  power_supply_class_init+0x0/0x6c @ 1
> [    0.047846] initcall power_supply_class_init+0x0/0x6c returned 0
> after 0 usecs
> [    0.047858] calling  hwmon_init+0x0/0x58 @ 1
> [    0.047872] initcall hwmon_init+0x0/0x58 returned 0 after 0 usecs
> [    0.047883] calling  edac_init+0x0/0x98 @ 1
> [    0.047892] EDAC MC: Ver: 3.0.0
> [    0.048015] initcall edac_init+0x0/0x98 returned 0 after 0 usecs
> [    0.048028] calling  psci_idle_init_domains+0x0/0x30 @ 1
> [    0.048104] initcall psci_idle_init_domains+0x0/0x30 returned 0 after
> 3906 usecs
> [    0.048118] calling  mmc_init+0x0/0x58 @ 1
> [    0.048157] initcall mmc_init+0x0/0x58 returned 0 after 0 usecs
> [    0.048168] calling  leds_init+0x0/0x78 @ 1
> [    0.048183] initcall leds_init+0x0/0x78 returned 0 after 0 usecs
> [    0.048193] calling  dmi_init+0x0/0x124 @ 1
> [    0.048203] initcall dmi_init+0x0/0x124 returned 0 after 0 usecs
> [    0.048213] calling  efisubsys_init+0x0/0x4f4 @ 1
> [    0.048223] initcall efisubsys_init+0x0/0x4f4 returned 0 after 0
> usecs
> [    0.048234] calling  register_gop_device+0x0/0xac @ 1
> [    0.048244] initcall register_gop_device+0x0/0xac returned 0 after 0
> usecs
> [    0.048255] calling  remoteproc_init+0x0/0x4c @ 1
> [    0.048282] initcall remoteproc_init+0x0/0x4c returned 0 after 0
> usecs
> [    0.048293] calling  glink_rpm_init+0x0/0x30 @ 1
> [    0.048339] initcall glink_rpm_init+0x0/0x30 returned 0 after 0 usecs
> [    0.048350] calling  devfreq_init+0x0/0x10c @ 1
> [    0.048439] initcall devfreq_init+0x0/0x10c returned 0 after 0 usecs
> [    0.048453] calling  devfreq_event_init+0x0/0x80 @ 1
> [    0.048470] initcall devfreq_event_init+0x0/0x80 returned 0 after 0
> usecs
> [    0.048481] calling  devfreq_simple_ondemand_init+0x0/0x2c @ 1
> [    0.048491] initcall devfreq_simple_ondemand_init+0x0/0x2c returned 0
> after 0 usecs
> [    0.048503] calling  iio_init+0x0/0xb4 @ 1
> [    0.048530] initcall iio_init+0x0/0xb4 returned 0 after 0 usecs
> [    0.048541] calling  arm_pmu_hp_init+0x0/0x70 @ 1
> [    0.048553] initcall arm_pmu_hp_init+0x0/0x70 returned 0 after 0
> usecs
> [    0.048563] calling  arm_pmu_acpi_init+0x0/0x1f0 @ 1
> [    0.048573] initcall arm_pmu_acpi_init+0x0/0x1f0 returned 0 after 0
> usecs
> [    0.048583] calling  ras_init+0x0/0x28 @ 1
> [    0.048598] initcall ras_init+0x0/0x28 returned 0 after 0 usecs
> [    0.048609] calling  nvmem_init+0x0/0x30 @ 1
> [    0.048628] initcall nvmem_init+0x0/0x30 returned 0 after 0 usecs
> [    0.048639] calling  fpga_mgr_class_init+0x0/0x88 @ 1
> [    0.048648] FPGA manager framework
> [    0.048659] initcall fpga_mgr_class_init+0x0/0x88 returned 0 after 0
> usecs
> [    0.048670] calling  tee_init+0x0/0xf4 @ 1
> [    0.048693] initcall tee_init+0x0/0xf4 returned 0 after 0 usecs
> [    0.048703] calling  init_soundcore+0x0/0x6c @ 1
> [    0.048718] initcall init_soundcore+0x0/0x6c returned 0 after 0 usecs
> [    0.048728] calling  alsa_sound_init+0x0/0xc8 @ 1
> [    0.048749] Advanced Linux Sound Architecture Driver Initialized.
> [    0.048756] initcall alsa_sound_init+0x0/0xc8 returned 0 after 0
> usecs
> [    0.048766] calling  proto_init+0x0/0x2c @ 1
> [    0.048778] initcall proto_init+0x0/0x2c returned 0 after 0 usecs
> [    0.048788] calling  net_dev_init+0x0/0x210 @ 1
> [    0.048969] initcall net_dev_init+0x0/0x210 returned 0 after 0 usecs
> [    0.048983] calling  neigh_init+0x0/0xb4 @ 1
> [    0.048994] initcall neigh_init+0x0/0xb4 returned 0 after 0 usecs
> [    0.049004] calling  fib_notifier_init+0x0/0x2c @ 1
> [    0.049016] initcall fib_notifier_init+0x0/0x2c returned 0 after 0
> usecs
> [    0.049027] calling  devlink_init+0x0/0x48 @ 1
> [    0.049085] initcall devlink_init+0x0/0x48 returned 0 after 0 usecs
> [    0.049097] calling  ethnl_init+0x0/0x84 @ 1
> [    0.049126] initcall ethnl_init+0x0/0x84 returned 0 after 0 usecs
> [    0.049137] calling  nexthop_init+0x0/0x104 @ 1
> [    0.049152] initcall nexthop_init+0x0/0x104 returned 0 after 0 usecs
> [    0.049163] calling  watchdog_init+0x0/0xa0 @ 1
> [    0.049246] initcall watchdog_init+0x0/0xa0 returned 0 after 0 usecs
> [    0.049317] calling  create_debug_debugfs_entry+0x0/0x40 @ 1
> [    0.049337] initcall create_debug_debugfs_entry+0x0/0x40 returned 0
> after 0 usecs
> [    0.049349] calling  clocksource_done_booting+0x0/0x68 @ 1
> [    0.049381] clocksource: Switched to clocksource arch_sys_counter
> [    0.049389] initcall clocksource_done_booting+0x0/0x68 returned 0
> after 15 usecs
> [    0.049402] calling  tracer_init_tracefs+0x0/0x2d4 @ 1
> [    0.072028] initcall tracer_init_tracefs+0x0/0x2d4 returned 0 after
> 22082 usecs
> [    0.072079] calling  init_trace_printk_function_export+0x0/0x44 @ 1
> [    0.072099] initcall init_trace_printk_function_export+0x0/0x44
> returned 0 after 5 usecs
> [    0.072114] calling  init_graph_tracefs+0x0/0x44 @ 1
> [    0.072129] initcall init_graph_tracefs+0x0/0x44 returned 0 after 3
> usecs
> [    0.072142] calling  init_dynamic_event+0x0/0x54 @ 1
> [    0.072154] initcall init_dynamic_event+0x0/0x54 returned 0 after 3
> usecs
> [    0.072164] calling  init_uprobe_trace+0x0/0x80 @ 1
> [    0.072179] initcall init_uprobe_trace+0x0/0x80 returned 0 after 6
> usecs
> [    0.072188] calling  secretmem_init+0x0/0x40 @ 1
> [    0.072238] initcall secretmem_init+0x0/0x40 returned 0 after 38
> usecs
> [    0.072250] calling  init_pipe_fs+0x0/0x68 @ 1
> [    0.072280] initcall init_pipe_fs+0x0/0x68 returned 0 after 18 usecs
> [    0.072292] calling  cgroup_writeback_init+0x0/0x4c @ 1
> [    0.072307] initcall cgroup_writeback_init+0x0/0x4c returned 0 after
> 4 usecs
> [    0.072319] calling  inotify_user_setup+0x0/0xd8 @ 1
> [    0.072343] initcall inotify_user_setup+0x0/0xd8 returned 0 after 13
> usecs
> [    0.072355] calling  eventpoll_init+0x0/0xf4 @ 1
> [    0.072376] initcall eventpoll_init+0x0/0xf4 returned 0 after 11
> usecs
> [    0.072389] calling  anon_inode_init+0x0/0x78 @ 1
> [    0.072420] initcall anon_inode_init+0x0/0x78 returned 0 after 20
> usecs
> [    0.072434] calling  proc_locks_init+0x0/0x4c @ 1
> [    0.072450] initcall proc_locks_init+0x0/0x4c returned 0 after 5
> usecs
> [    0.072461] calling  iomap_init+0x0/0x38 @ 1
> [    0.072495] initcall iomap_init+0x0/0x38 returned 0 after 23 usecs
> [    0.072507] calling  dquot_init+0x0/0x13c @ 1
> [    0.072517] VFS: Disk quotas dquot_6.6.0
> [    0.072552] VFS: Dquot-cache hash table entries: 512 (order 0, 4096
> bytes)
> [    0.072562] initcall dquot_init+0x0/0x13c returned 0 after 44 usecs
> [    0.072575] calling  proc_cmdline_init+0x0/0x44 @ 1
> [    0.072588] initcall proc_cmdline_init+0x0/0x44 returned 0 after 2
> usecs
> [    0.072600] calling  proc_consoles_init+0x0/0x48 @ 1
> [    0.072612] initcall proc_consoles_init+0x0/0x48 returned 0 after 1
> usecs
> [    0.072623] calling  proc_cpuinfo_init+0x0/0x40 @ 1
> [    0.072635] initcall proc_cpuinfo_init+0x0/0x40 returned 0 after 1
> usecs
> [    0.072647] calling  proc_devices_init+0x0/0x48 @ 1
> [    0.072658] initcall proc_devices_init+0x0/0x48 returned 0 after 1
> usecs
> [    0.072670] calling  proc_interrupts_init+0x0/0x48 @ 1
> [    0.072684] initcall proc_interrupts_init+0x0/0x48 returned 0 after 3
> usecs
> [    0.072696] calling  proc_loadavg_init+0x0/0x44 @ 1
> [    0.072708] initcall proc_loadavg_init+0x0/0x44 returned 0 after 1
> usecs
> [    0.072719] calling  proc_meminfo_init+0x0/0x44 @ 1
> [    0.072731] initcall proc_meminfo_init+0x0/0x44 returned 0 after 1
> usecs
> [    0.072742] calling  proc_stat_init+0x0/0x40 @ 1
> [    0.072755] initcall proc_stat_init+0x0/0x40 returned 0 after 1 usecs
> [    0.072766] calling  proc_uptime_init+0x0/0x44 @ 1
> [    0.072777] initcall proc_uptime_init+0x0/0x44 returned 0 after 1
> usecs
> [    0.072789] calling  proc_version_init+0x0/0x44 @ 1
> [    0.072800] initcall proc_version_init+0x0/0x44 returned 0 after 1
> usecs
> [    0.072812] calling  proc_softirqs_init+0x0/0x44 @ 1
> [    0.072823] initcall proc_softirqs_init+0x0/0x44 returned 0 after 1
> usecs
> [    0.072835] calling  vmcore_init+0x0/0x558 @ 1
> [    0.072846] initcall vmcore_init+0x0/0x558 returned 0 after 0 usecs
> [    0.072857] calling  proc_kmsg_init+0x0/0x40 @ 1
> [    0.072869] initcall proc_kmsg_init+0x0/0x40 returned 0 after 1 usecs
> [    0.072880] calling  proc_page_init+0x0/0x7c @ 1
> [    0.072894] initcall proc_page_init+0x0/0x7c returned 0 after 3 usecs
> [    0.072905] calling  proc_boot_config_init+0x0/0xb0 @ 1
> [    0.072918] initcall proc_boot_config_init+0x0/0xb0 returned 0 after
> 2 usecs
> [    0.072930] calling  init_ramfs_fs+0x0/0x2c @ 1
> [    0.072939] initcall init_ramfs_fs+0x0/0x2c returned 0 after 1 usecs
> [    0.072949] calling  init_hugetlbfs_fs+0x0/0x13c @ 1
> [    0.073028] initcall init_hugetlbfs_fs+0x0/0x13c returned 0 after 69
> usecs
> [    0.073040] calling  blk_scsi_ioctl_init+0x0/0xb0 @ 1
> [    0.073051] initcall blk_scsi_ioctl_init+0x0/0xb0 returned 0 after 0
> usecs
> [    0.073061] calling  acpi_event_init+0x0/0x54 @ 1
> [    0.073071] initcall acpi_event_init+0x0/0x54 returned 0 after 0
> usecs
> [    0.073081] calling  pnp_system_init+0x0/0x2c @ 1
> [    0.073118] initcall pnp_system_init+0x0/0x2c returned 0 after 25
> usecs
> [    0.073130] calling  pnpacpi_init+0x0/0x9c @ 1
> [    0.073140] pnp: PnP ACPI: disabled
> [    0.073146] initcall pnpacpi_init+0x0/0x9c returned 0 after 5 usecs
> [    0.073157] calling  chr_dev_init+0x0/0x178 @ 1
> [    0.080545] initcall chr_dev_init+0x0/0x178 returned 0 after 7204
> usecs
> [    0.080567] calling  firmware_class_init+0x0/0xe8 @ 1
> [    0.080590] initcall firmware_class_init+0x0/0xe8 returned 0 after 11
> usecs
> [    0.080602] calling  sysctl_core_init+0x0/0x50 @ 1
> [    0.080639] initcall sysctl_core_init+0x0/0x50 returned 0 after 25
> usecs
> [    0.080650] calling  eth_offload_init+0x0/0x30 @ 1
> [    0.080660] initcall eth_offload_init+0x0/0x30 returned 0 after 0
> usecs
> [    0.080670] calling  ipv4_offload_init+0x0/0x90 @ 1
> [    0.080682] initcall ipv4_offload_init+0x0/0x90 returned 0 after 1
> usecs
> [    0.080693] calling  inet_init+0x0/0x258 @ 1
> [    0.080735] NET: Registered protocol family 2
> [    0.081047] tcp_listen_portaddr_hash hash table entries: 2048 (order:
> 3, 32768 bytes, linear)
> [    0.081075] TCP established hash table entries: 32768 (order: 6,
> 262144 bytes, linear)
> [    0.081170] TCP bind hash table entries: 32768 (order: 7, 524288
> bytes, linear)
> [    0.081516] TCP: Hash tables configured (established 32768 bind
> 32768)
> [    0.081623] UDP hash table entries: 2048 (order: 4, 65536 bytes,
> linear)
> [    0.081653] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes,
> linear)
> [    0.081748] initcall inet_init+0x0/0x258 returned 0 after 1021 usecs
> [    0.081769] calling  af_unix_init+0x0/0x74 @ 1
> [    0.081787] NET: Registered protocol family 1
> [    0.081802] initcall af_unix_init+0x0/0x74 returned 0 after 21 usecs
> [    0.081814] calling  ipv6_offload_init+0x0/0x94 @ 1
> [    0.081828] initcall ipv6_offload_init+0x0/0x94 returned 0 after 2
> usecs
> [    0.081839] calling  init_sunrpc+0x0/0x8c @ 1
> [    0.082114] RPC: Registered named UNIX socket transport module.
> [    0.082126] RPC: Registered udp transport module.
> [    0.082132] RPC: Registered tcp transport module.
> [    0.082139] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.082146] initcall init_sunrpc+0x0/0x8c returned 0 after 289 usecs
> [    0.082159] calling  vlan_offload_init+0x0/0x44 @ 1
> [    0.082171] initcall vlan_offload_init+0x0/0x44 returned 0 after 0
> usecs
> [    0.082182] calling  pci_apply_final_quirks+0x0/0x170 @ 1
> [    0.082195] PCI: CLS 0 bytes, default 64
> [    0.082202] initcall pci_apply_final_quirks+0x0/0x170 returned 0
> after 9 usecs
> [    0.082212] calling  acpi_reserve_resources+0x0/0x104 @ 1
> [    0.082222] initcall acpi_reserve_resources+0x0/0x104 returned 0
> after 0 usecs
> [    0.082233] calling  populate_rootfs+0x0/0x13c @ 1
> [    0.082338] initcall populate_rootfs+0x0/0x13c returned 0 after 91
> usecs
> [    0.082417] calling  register_arm64_panic_block+0x0/0x38 @ 1
> [    0.082430] initcall register_arm64_panic_block+0x0/0x38 returned 0
> after 1 usecs
> [    0.082441] calling  cpuinfo_regs_init+0x0/0xe0 @ 1
> [    0.082504] initcall cpuinfo_regs_init+0x0/0xe0 returned 0 after 51
> usecs
> [    0.082517] calling  armv8_pmu_driver_init+0x0/0x68 @ 1
> [    0.082672] hw perfevents: enabled with armv8_cortex_a72 PMU driver,
> 7 counters available
> [    0.082848] initcall armv8_pmu_driver_init+0x0/0x68 returned 0 after
> 312 usecs
> [    0.082864] calling  arch_init_uprobes+0x0/0x44 @ 1
> [    0.082875] initcall arch_init_uprobes+0x0/0x44 returned 0 after 0
> usecs
> [    0.082887] calling  arm_init+0x0/0x38 @ 1
> [    0.082904] kvm [1]: IPA Size Limit: 44 bits
> [    0.083445] kvm [1]: GICv3: no GICV resource entry
> [    0.083455] kvm [1]: disabling GICv2 emulation
> [    0.083474] kvm [1]: GIC system register CPU interface enabled
> [    0.083513] kvm [1]: vgic interrupt IRQ9
> [    0.083576] kvm [1]: Hyp mode initialized successfully
> [    0.083724] initcall arm_init+0x0/0x38 returned 0 after 806 usecs
> [    0.083739] calling  cpu_feature_match_SHA1_init+0x0/0x4c @ 1
> [    0.083752] initcall cpu_feature_match_SHA1_init+0x0/0x4c returned
> -19 after 0 usecs
> [    0.083765] calling  cpu_feature_match_SHA2_init+0x0/0x50 @ 1
> [    0.083776] initcall cpu_feature_match_SHA2_init+0x0/0x50 returned
> -19 after 0 usecs
> [    0.083789] calling  ghash_ce_mod_init+0x0/0x60 @ 1
> [    0.083899] initcall ghash_ce_mod_init+0x0/0x60 returned 0 after 96
> usecs
> [    0.083913] calling  cpu_feature_match_AES_init+0x0/0x4c @ 1
> [    0.083924] initcall cpu_feature_match_AES_init+0x0/0x4c returned -19
> after 0 usecs
> [    0.083937] calling  aes_mod_init+0x0/0x44 @ 1
> [    0.083947] initcall aes_mod_init+0x0/0x44 returned -19 after 0 usecs
> [    0.083958] calling  cpu_feature_match_AES_init+0x0/0xd8 @ 1
> [    0.083969] initcall cpu_feature_match_AES_init+0x0/0xd8 returned -19
> after 0 usecs
> [    0.083982] calling  sha256_mod_init+0x0/0x84 @ 1
> [    0.084218] initcall sha256_mod_init+0x0/0x84 returned 0 after 219
> usecs
> [    0.084234] calling  aes_init+0x0/0x2c @ 1
> [    0.084293] initcall aes_init+0x0/0x2c returned 0 after 47 usecs
> [    0.084308] calling  proc_execdomains_init+0x0/0x44 @ 1
> [    0.084322] initcall proc_execdomains_init+0x0/0x44 returned 0 after
> 4 usecs
> [    0.084331] calling  register_warn_debugfs+0x0/0x44 @ 1
> [    0.084347] initcall register_warn_debugfs+0x0/0x44 returned 0 after
> 6 usecs
> [    0.084358] calling  cpuhp_sysfs_init+0x0/0xc8 @ 1
> [    0.084386] initcall cpuhp_sysfs_init+0x0/0xc8 returned 0 after 19
> usecs
> [    0.084396] calling  ioresources_init+0x0/0x7c @ 1
> [    0.084409] initcall ioresources_init+0x0/0x7c returned 0 after 3
> usecs
> [    0.084418] calling  snapshot_device_init+0x0/0x2c @ 1
> [    0.084492] initcall snapshot_device_init+0x0/0x2c returned 0 after
> 62 usecs
> [    0.084505] calling  irq_pm_init_ops+0x0/0x30 @ 1
> [    0.084515] initcall irq_pm_init_ops+0x0/0x30 returned 0 after 0
> usecs
> [    0.084525] calling  irq_debugfs_init+0x0/0xa8 @ 1
> [    0.084970] initcall irq_debugfs_init+0x0/0xa8 returned 0 after 425
> usecs
> [    0.084983] calling  timekeeping_init_ops+0x0/0x34 @ 1
> [    0.084994] initcall timekeeping_init_ops+0x0/0x34 returned 0 after 0
> usecs
> [    0.085005] calling  init_clocksource_sysfs+0x0/0x48 @ 1
> [    0.085071] initcall init_clocksource_sysfs+0x0/0x48 returned 0 after
> 53 usecs
> [    0.085085] calling  init_timer_list_procfs+0x0/0x50 @ 1
> [    0.085098] initcall init_timer_list_procfs+0x0/0x50 returned 0 after
> 2 usecs
> [    0.085109] calling  alarmtimer_init+0x0/0xc8 @ 1
> [    0.085171] initcall alarmtimer_init+0x0/0xc8 returned 0 after 50
> usecs
> [    0.085183] calling  init_posix_timers+0x0/0x48 @ 1
> [    0.085199] initcall init_posix_timers+0x0/0x48 returned 0 after 6
> usecs
> [    0.085210] calling  clockevents_init_sysfs+0x0/0xfc @ 1
> [    0.085298] initcall clockevents_init_sysfs+0x0/0xfc returned 0 after
> 75 usecs
> [    0.085312] calling  sched_clock_syscore_init+0x0/0x34 @ 1
> [    0.085323] initcall sched_clock_syscore_init+0x0/0x34 returned 0
> after 0 usecs
> [    0.085335] calling  proc_modules_init+0x0/0x44 @ 1
> [    0.085348] initcall proc_modules_init+0x0/0x44 returned 0 after 2
> usecs
> [    0.085359] calling  kallsyms_init+0x0/0x40 @ 1
> [    0.085371] initcall kallsyms_init+0x0/0x40 returned 0 after 1 usecs
> [    0.085408] calling  pid_namespaces_init+0x0/0x48 @ 1
> [    0.085458] initcall pid_namespaces_init+0x0/0x48 returned 0 after 36
> usecs
> [    0.085472] calling  ikconfig_init+0x0/0x64 @ 1
> [    0.085485] initcall ikconfig_init+0x0/0x64 returned 0 after 2 usecs
> [    0.085497] calling  audit_watch_init+0x0/0x54 @ 1
> [    0.085508] initcall audit_watch_init+0x0/0x54 returned 0 after 0
> usecs
> [    0.085520] calling  audit_fsnotify_init+0x0/0x54 @ 1
> [    0.085533] initcall audit_fsnotify_init+0x0/0x54 returned 0 after 2
> usecs
> [    0.085545] calling  audit_tree_init+0x0/0x9c @ 1
> [    0.085558] initcall audit_tree_init+0x0/0x9c returned 0 after 3
> usecs
> [    0.085570] calling  seccomp_sysctl_init+0x0/0x44 @ 1
> [    0.085590] initcall seccomp_sysctl_init+0x0/0x44 returned 0 after 8
> usecs
> [    0.085602] calling  utsname_sysctl_init+0x0/0x30 @ 1
> [    0.085621] initcall utsname_sysctl_init+0x0/0x30 returned 0 after 8
> usecs
> [    0.085633] calling  init_tracepoints+0x0/0x50 @ 1
> [    0.085645] initcall init_tracepoints+0x0/0x50 returned 0 after 1
> usecs
> [    0.085657] calling  perf_event_sysfs_init+0x0/0xb8 @ 1
> [    0.085807] initcall perf_event_sysfs_init+0x0/0xb8 returned 0 after
> 137 usecs
> [    0.085819] calling  system_trusted_keyring_init+0x0/0x78 @ 1
> [    0.085828] Initialise system trusted keyrings
> [    0.085843] initcall system_trusted_keyring_init+0x0/0x78 returned 0
> after 14 usecs
> [    0.085854] calling  kswapd_init+0x0/0x90 @ 1
> [    0.085926] initcall kswapd_init+0x0/0x90 returned 0 after 62 usecs
> [    0.085938] calling  extfrag_debug_init+0x0/0x80 @ 1
> [    0.085960] initcall extfrag_debug_init+0x0/0x80 returned 0 after 13
> usecs
> [    0.085970] calling  mm_compute_batch_init+0x0/0x30 @ 1
> [    0.085980] initcall mm_compute_batch_init+0x0/0x30 returned 0 after
> 0 usecs
> [    0.085989] calling  slab_proc_init+0x0/0x44 @ 1
> [    0.086000] initcall slab_proc_init+0x0/0x44 returned 0 after 2 usecs
> [    0.086010] calling  workingset_init+0x0/0xc4 @ 1
> [    0.086019] workingset: timestamp_bits=44 max_order=20 bucket_order=0
> [    0.086032] initcall workingset_init+0x0/0xc4 returned 0 after 12
> usecs
> [    0.086042] calling  proc_vmalloc_init+0x0/0x50 @ 1
> [    0.086052] initcall proc_vmalloc_init+0x0/0x50 returned 0 after 1
> usecs
> [    0.086062] calling  memblock_init_debugfs+0x0/0x90 @ 1
> [    0.086081] initcall memblock_init_debugfs+0x0/0x90 returned 0 after
> 9 usecs
> [    0.086092] calling  procswaps_init+0x0/0x44 @ 1
> [    0.086104] initcall procswaps_init+0x0/0x44 returned 0 after 2 usecs
> [    0.086114] calling  slab_sysfs_init+0x0/0x128 @ 1
> [    0.088769] initcall slab_sysfs_init+0x0/0x128 returned 0 after 2583
> usecs
> [    0.088786] calling  fcntl_init+0x0/0x48 @ 1
> [    0.088801] initcall fcntl_init+0x0/0x48 returned 0 after 4 usecs
> [    0.088812] calling  proc_filesystems_init+0x0/0x44 @ 1
> [    0.088825] initcall proc_filesystems_init+0x0/0x44 returned 0 after
> 2 usecs
> [    0.088836] calling  start_dirtytime_writeback+0x0/0x4c @ 1
> [    0.088849] initcall start_dirtytime_writeback+0x0/0x4c returned 0
> after 2 usecs
> [    0.088862] calling  blkdev_init+0x0/0x38 @ 1
> [    0.088884] initcall blkdev_init+0x0/0x38 returned 0 after 11 usecs
> [    0.088896] calling  dio_init+0x0/0x48 @ 1
> [    0.088950] initcall dio_init+0x0/0x48 returned 0 after 42 usecs
> [    0.088963] calling  dnotify_init+0x0/0x98 @ 1
> [    0.089018] initcall dnotify_init+0x0/0x98 returned 0 after 43 usecs
> [    0.089031] calling  fanotify_user_setup+0x0/0xb4 @ 1
> [    0.089089] initcall fanotify_user_setup+0x0/0xb4 returned 0 after 46
> usecs
> [    0.089103] calling  aio_setup+0x0/0xa0 @ 1
> [    0.089187] initcall aio_setup+0x0/0xa0 returned 0 after 72 usecs
> [    0.089201] calling  io_uring_init+0x0/0x4c @ 1
> [    0.089215] initcall io_uring_init+0x0/0x4c returned 0 after 3 usecs
> [    0.089226] calling  mbcache_init+0x0/0x54 @ 1
> [    0.089277] initcall mbcache_init+0x0/0x54 returned 0 after 39 usecs
> [    0.089291] calling  init_grace+0x0/0x2c @ 1
> [    0.089304] initcall init_grace+0x0/0x2c returned 0 after 2 usecs
> [    0.089315] calling  init_devpts_fs+0x0/0x4c @ 1
> [    0.089340] initcall init_devpts_fs+0x0/0x4c returned 0 after 14
> usecs
> [    0.089352] calling  ext4_init_fs+0x0/0x1a8 @ 1
> [    0.089699] initcall ext4_init_fs+0x0/0x1a8 returned 0 after 330
> usecs
> [    0.089712] calling  init_ext2_fs+0x0/0x88 @ 1
> [    0.089754] initcall init_ext2_fs+0x0/0x88 returned 0 after 32 usecs
> [    0.089765] calling  journal_init+0x0/0x13c @ 1
> [    0.089859] initcall journal_init+0x0/0x13c returned 0 after 83 usecs
> [    0.089871] calling  init_squashfs_fs+0x0/0x94 @ 1
> [    0.089913] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    0.089920] initcall init_squashfs_fs+0x0/0x94 returned 0 after 40
> usecs
> [    0.089930] calling  init_fat_fs+0x0/0x6c @ 1
> [    0.090002] initcall init_fat_fs+0x0/0x6c returned 0 after 61 usecs
> [    0.090013] calling  init_vfat_fs+0x0/0x2c @ 1
> [    0.090023] initcall init_vfat_fs+0x0/0x2c returned 0 after 1 usecs
> [    0.090032] calling  init_nfs_fs+0x0/0x168 @ 1
> [    0.090365] initcall init_nfs_fs+0x0/0x168 returned 0 after 317 usecs
> [    0.090378] calling  init_nfs_v2+0x0/0x30 @ 1
> [    0.090387] initcall init_nfs_v2+0x0/0x30 returned 0 after 0 usecs
> [    0.090397] calling  init_nfs_v3+0x0/0x30 @ 1
> [    0.090405] initcall init_nfs_v3+0x0/0x30 returned 0 after 0 usecs
> [    0.090414] calling  init_nfs_v4+0x0/0x6c @ 1
> [    0.090422] NFS: Registering the id_resolver key type
> [    0.090440] Key type id_resolver registered
> [    0.090447] Key type id_legacy registered
> [    0.090500] initcall init_nfs_v4+0x0/0x6c returned 0 after 76 usecs
> [    0.090512] calling  nfs4filelayout_init+0x0/0x44 @ 1
> [    0.090520] nfs4filelayout_init: NFSv4 File Layout Driver
> Registering...
> [    0.090528] initcall nfs4filelayout_init+0x0/0x44 returned 0 after 7
> usecs
> [    0.090538] calling  init_nlm+0x0/0x8c @ 1
> [    0.090556] initcall init_nlm+0x0/0x8c returned 0 after 9 usecs
> [    0.090566] calling  init_nls_cp437+0x0/0x30 @ 1
> [    0.090575] initcall init_nls_cp437+0x0/0x30 returned 0 after 0 usecs
> [    0.090584] calling  init_nls_iso8859_1+0x0/0x30 @ 1
> [    0.090593] initcall init_nls_iso8859_1+0x0/0x30 returned 0 after 0
> usecs
> [    0.090602] calling  init_autofs_fs+0x0/0x48 @ 1
> [    0.090696] initcall init_autofs_fs+0x0/0x48 returned 0 after 83
> usecs
> [    0.090708] calling  init_v9fs+0x0/0x10c @ 1
> [    0.090717] 9p: Installing v9fs 9p2000 file system support
> [    0.090761] initcall init_v9fs+0x0/0x10c returned 0 after 43 usecs
> [    0.090772] calling  efivarfs_init+0x0/0x3c @ 1
> [    0.090782] initcall efivarfs_init+0x0/0x3c returned -19 after 0
> usecs
> [    0.090791] calling  ipc_init+0x0/0x40 @ 1
> [    0.090810] initcall ipc_init+0x0/0x40 returned 0 after 10 usecs
> [    0.090819] calling  ipc_sysctl_init+0x0/0x30 @ 1
> [    0.090840] initcall ipc_sysctl_init+0x0/0x30 returned 0 after 11
> usecs
> [    0.090851] calling  init_mqueue_fs+0x0/0x104 @ 1
> [    0.090935] initcall init_mqueue_fs+0x0/0x104 returned 0 after 73
> usecs
> [    0.090947] calling  key_proc_init+0x0/0x94 @ 1
> [    0.090960] initcall key_proc_init+0x0/0x94 returned 0 after 3 usecs
> [    0.090970] calling  crypto_algapi_init+0x0/0x28 @ 1
> [    0.090981] initcall crypto_algapi_init+0x0/0x28 returned 0 after 1
> usecs
> [    0.090991] calling  jent_mod_init+0x0/0x4c @ 1
> [    0.120799] initcall jent_mod_init+0x0/0x4c returned 0 after 29100
> usecs
> [    0.120814] calling  asymmetric_key_init+0x0/0x2c @ 1
> [    0.120824] Key type asymmetric registered
> [    0.120831] initcall asymmetric_key_init+0x0/0x2c returned 0 after 7
> usecs
> [    0.120841] calling  x509_key_init+0x0/0x2c @ 1
> [    0.120851] Asymmetric key parser 'x509' registered
> [    0.120857] initcall x509_key_init+0x0/0x2c returned 0 after 7 usecs
> [    0.120867] calling  proc_genhd_init+0x0/0x74 @ 1
> [    0.120881] initcall proc_genhd_init+0x0/0x74 returned 0 after 3
> usecs
> [    0.120891] calling  bsg_init+0x0/0x134 @ 1
> [    0.120914] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 245)
> [    0.120923] initcall bsg_init+0x0/0x134 returned 0 after 22 usecs
> [    0.120934] calling  deadline_init+0x0/0x2c @ 1
> [    0.120944] io scheduler mq-deadline registered
> [    0.120950] initcall deadline_init+0x0/0x2c returned 0 after 7 usecs
> [    0.120960] calling  kyber_init+0x0/0x2c @ 1
> [    0.120970] io scheduler kyber registered
> [    0.120976] initcall kyber_init+0x0/0x2c returned 0 after 6 usecs
> [    0.120986] calling  crc_t10dif_mod_init+0x0/0x5c @ 1
> [    0.121007] initcall crc_t10dif_mod_init+0x0/0x5c returned 0 after 11
> usecs
> [    0.121018] calling  percpu_counter_startup+0x0/0x74 @ 1
> [    0.121053] initcall percpu_counter_startup+0x0/0x74 returned 0 after
> 24 usecs
> [    0.121073] calling  audit_classes_init+0x0/0xb8 @ 1
> [    0.121092] initcall audit_classes_init+0x0/0xb8 returned 0 after 7
> usecs
> [    0.121104] calling  sg_pool_init+0x0/0xf4 @ 1
> [    0.121202] initcall sg_pool_init+0x0/0xf4 returned 0 after 86 usecs
> [    0.121216] calling  ls_scfg_msi_driver_init+0x0/0x34 @ 1
> [    0.121362] initcall ls_scfg_msi_driver_init+0x0/0x34 returned 0
> after 131 usecs
> [    0.121388] calling  sl28cpld_intc_driver_init+0x0/0x30 @ 1
> [    0.121439] initcall sl28cpld_intc_driver_init+0x0/0x30 returned 0
> after 37 usecs
> [    0.121453] calling  brcm_gisb_driver_init+0x0/0x38 @ 1
> [    0.121533] initcall brcm_gisb_driver_init+0x0/0x38 returned -19
> after 67 usecs
> [    0.121547] calling  simple_pm_bus_driver_init+0x0/0x30 @ 1
> [    0.121595] initcall simple_pm_bus_driver_init+0x0/0x30 returned 0
> after 35 usecs
> [    0.121609] calling  vexpress_syscfg_driver_init+0x0/0x30 @ 1
> [    0.121643] initcall vexpress_syscfg_driver_init+0x0/0x30 returned 0
> after 21 usecs
> [    0.121656] calling  phy_core_init+0x0/0x78 @ 1
> [    0.121673] initcall phy_core_init+0x0/0x78 returned 0 after 6 usecs
> [    0.121685] calling  xgene_phy_driver_init+0x0/0x30 @ 1
> [    0.121735] initcall xgene_phy_driver_init+0x0/0x30 returned 0 after
> 38 usecs
> [    0.121749] calling  imx8mq_usb_phy_driver_init+0x0/0x30 @ 1
> [    0.121805] initcall imx8mq_usb_phy_driver_init+0x0/0x30 returned 0
> after 43 usecs
> [    0.121819] calling  qcom_usb_hs_phy_driver_init+0x0/0x30 @ 1
> [    0.121840] initcall qcom_usb_hs_phy_driver_init+0x0/0x30 returned 0
> after 9 usecs
> [    0.121853] calling  samsung_usb2_phy_driver_init+0x0/0x30 @ 1
> [    0.121892] initcall samsung_usb2_phy_driver_init+0x0/0x30 returned 0
> after 26 usecs
> [    0.121905] calling  max77620_pinctrl_driver_init+0x0/0x30 @ 1
> [    0.121939] initcall max77620_pinctrl_driver_init+0x0/0x30 returned 0
> after 22 usecs
> [    0.121953] calling  pcs_driver_init+0x0/0x30 @ 1
> [    0.122028] initcall pcs_driver_init+0x0/0x30 returned 0 after 62
> usecs
> [    0.122041] calling  bgpio_driver_init+0x0/0x30 @ 1
> [    0.122100] initcall bgpio_driver_init+0x0/0x30 returned 0 after 47
> usecs
> [    0.122113] calling  dwapb_gpio_driver_init+0x0/0x30 @ 1
> [    0.122166] initcall dwapb_gpio_driver_init+0x0/0x30 returned 0 after
> 40 usecs
> [    0.122180] calling  max77620_gpio_driver_init+0x0/0x30 @ 1
> [    0.122215] initcall max77620_gpio_driver_init+0x0/0x30 returned 0
> after 23 usecs
> [    0.122229] calling  mb86s70_gpio_driver_init+0x0/0x30 @ 1
> [    0.122277] initcall mb86s70_gpio_driver_init+0x0/0x30 returned 0
> after 36 usecs
> [    0.122291] calling  pl061_gpio_driver_init+0x0/0x2c @ 1
> [    0.122315] initcall pl061_gpio_driver_init+0x0/0x2c returned 0 after
> 12 usecs
> [    0.122329] calling  sl28cpld_gpio_driver_init+0x0/0x30 @ 1
> [    0.122386] initcall sl28cpld_gpio_driver_init+0x0/0x30 returned 0
> after 45 usecs
> [    0.122400] calling  xgene_gpio_driver_init+0x0/0x30 @ 1
> [    0.122446] initcall xgene_gpio_driver_init+0x0/0x30 returned 0 after
> 34 usecs
> [    0.122460] calling  sl28cpld_pwm_driver_init+0x0/0x30 @ 1
> [    0.122507] initcall sl28cpld_pwm_driver_init+0x0/0x30 returned 0
> after 34 usecs
> [    0.122520] calling  pcie_portdrv_init+0x0/0x60 @ 1
> [    0.122580] initcall pcie_portdrv_init+0x0/0x60 returned 0 after 49
> usecs
> [    0.122590] calling  aer_inject_init+0x0/0x30 @ 1
> [    0.122674] initcall aer_inject_init+0x0/0x30 returned 0 after 73
> usecs
> [    0.122686] calling  pci_proc_init+0x0/0xa0 @ 1
> [    0.122701] initcall pci_proc_init+0x0/0xa0 returned 0 after 5 usecs
> [    0.122710] calling  pci_hotplug_init+0x0/0x18 @ 1
> [    0.122719] initcall pci_hotplug_init+0x0/0x18 returned 0 after 0
> usecs
> [    0.122728] calling  gen_pci_driver_init+0x0/0x30 @ 1
> [    0.122815] pci-host-generic 1f0000000.pcie: host bridge
> /soc/pcie@1f0000000 ranges:
> [    0.122852] pci-host-generic 1f0000000.pcie:      MEM
> 0x01f8000000..0x01f815ffff -> 0x0000000000
> [    0.122879] pci-host-generic 1f0000000.pcie:      MEM
> 0x01f8160000..0x01f81cffff -> 0x0000000000
> [    0.122903] pci-host-generic 1f0000000.pcie:      MEM
> 0x01f81d0000..0x01f81effff -> 0x0000000000
> [    0.122924] pci-host-generic 1f0000000.pcie:      MEM
> 0x01f81f0000..0x01f820ffff -> 0x0000000000
> [    0.122944] pci-host-generic 1f0000000.pcie:      MEM
> 0x01f8210000..0x01f822ffff -> 0x0000000000
> [    0.122964] pci-host-generic 1f0000000.pcie:      MEM
> 0x01f8230000..0x01f824ffff -> 0x0000000000
> [    0.122980] pci-host-generic 1f0000000.pcie:      MEM
> 0x01fc000000..0x01fc3fffff -> 0x0000000000
> [    0.123037] pci-host-generic 1f0000000.pcie: ECAM at [mem
> 0x1f0000000-0x1f00fffff] for [bus 00]
> [    0.123112] pci-host-generic 1f0000000.pcie: PCI host bridge to bus
> 0000:00
> [    0.123123] pci_bus 0000:00: root bus resource [bus 00]
> [    0.123132] pci_bus 0000:00: root bus resource [mem
> 0x1f8000000-0x1f815ffff] (bus address [0x00000000-0x0015ffff])
> [    0.123144] pci_bus 0000:00: root bus resource [mem
> 0x1f8160000-0x1f81cffff pref] (bus address [0x00000000-0x0006ffff])
> [    0.123156] pci_bus 0000:00: root bus resource [mem
> 0x1f81d0000-0x1f81effff] (bus address [0x00000000-0x0001ffff])
> [    0.123168] pci_bus 0000:00: root bus resource [mem
> 0x1f81f0000-0x1f820ffff pref] (bus address [0x00000000-0x0001ffff])
> [    0.123179] pci_bus 0000:00: root bus resource [mem
> 0x1f8210000-0x1f822ffff] (bus address [0x00000000-0x0001ffff])
> [    0.123190] pci_bus 0000:00: root bus resource [mem
> 0x1f8230000-0x1f824ffff pref] (bus address [0x00000000-0x0001ffff])
> [    0.123202] pci_bus 0000:00: root bus resource [mem
> 0x1fc000000-0x1fc3fffff] (bus address [0x00000000-0x003fffff])
> [    0.123229] pci 0000:00:00.0: [1957:e100] type 00 class 0x020001
> [    0.123266] pci 0000:00:00.0: BAR 0: [mem 0x1f8000000-0x1f803ffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.123280] pci 0000:00:00.0: BAR 2: [mem 0x1f8160000-0x1f816ffff
> 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.123294] pci 0000:00:00.0: VF BAR 0: [mem 0x1f81d0000-0x1f81dffff
> 64bit] (from Enhanced Allocation, properties 0x4)
> [    0.123307] pci 0000:00:00.0: VF BAR 2: [mem 0x1f81f0000-0x1f81fffff
> 64bit pref] (from Enhanced Allocation, properties 0x3)
> [    0.123335] pci 0000:00:00.0: PME# supported from D0 D3hot
> [    0.123350] pci 0000:00:00.0: VF(n) BAR0 space: [mem
> 0x1f81d0000-0x1f81effff 64bit] (contains BAR0 for 2 VFs)
> [    0.123363] pci 0000:00:00.0: VF(n) BAR2 space: [mem
> 0x1f81f0000-0x1f820ffff 64bit pref] (contains BAR2 for 2 VFs)
> [    0.123502] pci 0000:00:00.1: [1957:e100] type 00 class 0x020001
> [    0.123537] pci 0000:00:00.1: BAR 0: [mem 0x1f8040000-0x1f807ffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.123551] pci 0000:00:00.1: BAR 2: [mem 0x1f8170000-0x1f817ffff
> 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.123564] pci 0000:00:00.1: VF BAR 0: [mem 0x1f8210000-0x1f821ffff
> 64bit] (from Enhanced Allocation, properties 0x4)
> [    0.123577] pci 0000:00:00.1: VF BAR 2: [mem 0x1f8230000-0x1f823ffff
> 64bit pref] (from Enhanced Allocation, properties 0x3)
> [    0.123603] pci 0000:00:00.1: PME# supported from D0 D3hot
> [    0.123618] pci 0000:00:00.1: VF(n) BAR0 space: [mem
> 0x1f8210000-0x1f822ffff 64bit] (contains BAR0 for 2 VFs)
> [    0.123630] pci 0000:00:00.1: VF(n) BAR2 space: [mem
> 0x1f8230000-0x1f824ffff 64bit pref] (contains BAR2 for 2 VFs)
> [    0.123768] pci 0000:00:00.1: Linked as a sync state only consumer to
> 0000:00:00.1
> [    0.123794] pci 0000:00:00.2: [1957:e100] type 00 class 0x020001
> [    0.123825] pci 0000:00:00.2: BAR 0: [mem 0x1f8080000-0x1f80bffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.123838] pci 0000:00:00.2: BAR 2: [mem 0x1f8180000-0x1f818ffff
> 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.123863] pci 0000:00:00.2: PME# supported from D0 D3hot
> [    0.123967] pci 0000:00:00.3: [1957:ee01] type 00 class 0x088001
> [    0.124001] pci 0000:00:00.3: BAR 0: [mem 0x1f8100000-0x1f811ffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.124014] pci 0000:00:00.3: BAR 2: [mem 0x1f8190000-0x1f819ffff
> 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.124039] pci 0000:00:00.3: PME# supported from D0 D3hot
> [    0.124148] pci 0000:00:00.4: [1957:ee02] type 00 class 0x088001
> [    0.124178] pci 0000:00:00.4: BAR 0: [mem 0x1f8120000-0x1f813ffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.124192] pci 0000:00:00.4: BAR 2: [mem 0x1f81a0000-0x1f81affff
> 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.124216] pci 0000:00:00.4: PME# supported from D0 D3hot
> [    0.124318] pci 0000:00:00.5: [1957:eef0] type 00 class 0x020801
> [    0.124349] pci 0000:00:00.5: BAR 0: [mem 0x1f8140000-0x1f815ffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.124362] pci 0000:00:00.5: BAR 2: [mem 0x1f81b0000-0x1f81bffff
> 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.124375] pci 0000:00:00.5: BAR 4: [mem 0x1fc000000-0x1fc3fffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.124399] pci 0000:00:00.5: PME# supported from D0 D3hot
> [    0.124512] pci 0000:00:00.6: [1957:e100] type 00 class 0x020001
> [    0.124542] pci 0000:00:00.6: BAR 0: [mem 0x1f80c0000-0x1f80fffff
> 64bit] (from Enhanced Allocation, properties 0x0)
> [    0.124556] pci 0000:00:00.6: BAR 2: [mem 0x1f81c0000-0x1f81cffff
> 64bit pref] (from Enhanced Allocation, properties 0x1)
> [    0.124580] pci 0000:00:00.6: PME# supported from D0 D3hot
> [    0.125491] pci 0000:00:1f.0: [1957:e001] type 00 class 0x080700
> [    0.125544] OF: /soc/pcie@1f0000000: no msi-map translation for id
> 0xf8 on (null)
> [    0.125670] pci 0000:00:00.0: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125692] pci 0000:00:00.0: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125714] pci 0000:00:00.1: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125727] pci 0000:00:00.1: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125744] pci 0000:00:00.2: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125756] pci 0000:00:00.2: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125772] pci 0000:00:00.3: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125784] pci 0000:00:00.3: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125800] pci 0000:00:00.4: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125812] pci 0000:00:00.4: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125828] pci 0000:00:00.5: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125840] pci 0000:00:00.5: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125855] pci 0000:00:00.6: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125867] pci 0000:00:00.6: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125883] pci 0000:00:1f.0: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    0.125895] pci 0000:00:1f.0: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    0.125919] OF: /soc/pcie@1f0000000: no iommu-map translation for id
> 0xf8 on (null)
> [    0.126061] pcieport 0000:00:1f.0: PME: Signaling with IRQ 118
> [    0.126273] pcieport 0000:00:1f.0: AER: enabled with IRQ 118
> [    0.126409] initcall gen_pci_driver_init+0x0/0x30 returned 0 after
> 3585 usecs
> [    0.126425] calling  altera_pcie_driver_init+0x0/0x30 @ 1
> [    0.126502] initcall altera_pcie_driver_init+0x0/0x30 returned 0
> after 65 usecs
> [    0.126515] calling  ls_pcie_driver_init+0x0/0x38 @ 1
> [    0.126644] layerscape-pcie 3400000.pcie: host bridge
> /soc/pcie@3400000 ranges:
> [    0.126677] layerscape-pcie 3400000.pcie:       IO
> 0x8000010000..0x800001ffff -> 0x0000000000
> [    0.126696] layerscape-pcie 3400000.pcie:      MEM
> 0x8040000000..0x807fffffff -> 0x0040000000
> [    0.126747] layerscape-pcie 3400000.pcie: iATU unroll: disabled
> [    0.126756] layerscape-pcie 3400000.pcie: Detected iATU regions: 8
> outbound, 6 inbound
> [    1.126858] layerscape-pcie 3400000.pcie: Phy link never came up
> [    1.126956] layerscape-pcie 3400000.pcie: PCI host bridge to bus
> 0001:00
> [    1.126968] pci_bus 0001:00: root bus resource [bus 00-ff]
> [    1.126977] pci_bus 0001:00: root bus resource [io  0x0000-0xffff]
> [    1.126987] pci_bus 0001:00: root bus resource [mem
> 0x8040000000-0x807fffffff] (bus address [0x40000000-0x7fffffff])
> [    1.127017] pci 0001:00:00.0: [1957:82c1] type 01 class 0x060400
> [    1.127083] pci 0001:00:00.0: supports D1 D2
> [    1.127091] pci 0001:00:00.0: PME# supported from D0 D1 D2 D3hot
> [    1.128778] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to
> 01
> [    1.128798] pci 0001:00:00.0: PCI bridge to [bus 01]
> [    1.128814] pci 0001:00:00.0: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    1.128835] pci 0001:00:00.0: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    1.128993] layerscape-pcie 3500000.pcie: host bridge
> /soc/pcie@3500000 ranges:
> [    1.129025] layerscape-pcie 3500000.pcie:       IO
> 0x8800010000..0x880001ffff -> 0x0000000000
> [    1.129045] layerscape-pcie 3500000.pcie:      MEM
> 0x8840000000..0x887fffffff -> 0x0040000000
> [    1.129093] layerscape-pcie 3500000.pcie: iATU unroll: disabled
> [    1.129102] layerscape-pcie 3500000.pcie: Detected iATU regions: 8
> outbound, 6 inbound
> [    2.129206] layerscape-pcie 3500000.pcie: Phy link never came up
> [    2.129275] layerscape-pcie 3500000.pcie: PCI host bridge to bus
> 0002:00
> [    2.129286] pci_bus 0002:00: root bus resource [bus 00-ff]
> [    2.129295] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff]
> (bus address [0x0000-0xffff])
> [    2.129307] pci_bus 0002:00: root bus resource [mem
> 0x8840000000-0x887fffffff] (bus address [0x40000000-0x7fffffff])
> [    2.129332] pci 0002:00:00.0: [1957:82c1] type 01 class 0x060400
> [    2.129409] pci 0002:00:00.0: supports D1 D2
> [    2.129418] pci 0002:00:00.0: PME# supported from D0 D1 D2 D3hot
> [    2.131066] pci_bus 0002:01: busn_res: [bus 01-ff] end is updated to
> 01
> [    2.131083] pci 0002:00:00.0: PCI bridge to [bus 01]
> [    2.131097] pci 0002:00:00.0: calling  quirk_fsl_no_msi+0x0/0x30 @ 1
> [    2.131112] pci 0002:00:00.0: quirk_fsl_no_msi+0x0/0x30 took 0 usecs
> [    2.131227] initcall ls_pcie_driver_init+0x0/0x38 returned 0 after
> 1957718 usecs
> [    2.131245] calling  kirin_pcie_driver_init+0x0/0x34 @ 1
> [    2.131310] initcall kirin_pcie_driver_init+0x0/0x34 returned 0 after
> 54 usecs
> [    2.131322] calling  hisi_pcie_almost_ecam_driver_init+0x0/0x30 @ 1
> [    2.131374] initcall hisi_pcie_almost_ecam_driver_init+0x0/0x30
> returned 0 after 41 usecs
> [    2.131387] calling  thunder_ecam_driver_init+0x0/0x30 @ 1
> [    2.131431] initcall thunder_ecam_driver_init+0x0/0x30 returned 0
> after 34 usecs
> [    2.131442] calling  thunder_pem_driver_init+0x0/0x30 @ 1
> [    2.131487] initcall thunder_pem_driver_init+0x0/0x30 returned 0
> after 34 usecs
> [    2.131499] calling  xgene_pcie_driver_init+0x0/0x30 @ 1
> [    2.131546] initcall xgene_pcie_driver_init+0x0/0x30 returned 0 after
> 37 usecs
> [    2.131558] calling  xenfb_init+0x0/0x5c @ 1
> [    2.131567] initcall xenfb_init+0x0/0x5c returned -19 after 0 usecs
> [    2.131576] calling  efifb_driver_init+0x0/0x30 @ 1
> [    2.131607] initcall efifb_driver_init+0x0/0x30 returned 0 after 21
> usecs
> [    2.131617] calling  ged_driver_init+0x0/0x30 @ 1
> [    2.131649] initcall ged_driver_init+0x0/0x30 returned 0 after 21
> usecs
> [    2.131660] calling  acpi_ac_init+0x0/0xd0 @ 1
> [    2.131670] initcall acpi_ac_init+0x0/0xd0 returned -19 after 0 usecs
> [    2.131681] calling  acpi_button_driver_init+0x0/0x84 @ 1
> [    2.131691] initcall acpi_button_driver_init+0x0/0x84 returned 0
> after 0 usecs
> [    2.131702] calling  acpi_fan_driver_init+0x0/0x30 @ 1
> [    2.131737] initcall acpi_fan_driver_init+0x0/0x30 returned 0 after
> 24 usecs
> [    2.131749] calling  acpi_processor_driver_init+0x0/0xec @ 1
> [    2.131759] initcall acpi_processor_driver_init+0x0/0xec returned 0
> after 0 usecs
> [    2.131770] calling  acpi_thermal_init+0x0/0x9c @ 1
> [    2.131889] initcall acpi_thermal_init+0x0/0x9c returned -19 after
> 106 usecs
> [    2.131907] calling  acpi_battery_init+0x0/0x5c @ 1
> [    2.131919] initcall acpi_battery_init+0x0/0x5c returned -19 after 0
> usecs
> [    2.131931] calling  acpi_hed_driver_init+0x0/0x30 @ 1
> [    2.131941] initcall acpi_hed_driver_init+0x0/0x30 returned -19 after
> 0 usecs
> [    2.131953] calling  erst_init+0x0/0x2fc @ 1
> [    2.131963] initcall erst_init+0x0/0x2fc returned 0 after 0 usecs
> [    2.131973] calling  ghes_init+0x0/0x118 @ 1
> [    2.131983] initcall ghes_init+0x0/0x118 returned -19 after 0 usecs
> [    2.131993] calling  einj_init+0x0/0x4a8 @ 1
> [    2.132003] EINJ: ACPI disabled.
> [    2.132009] initcall einj_init+0x0/0x4a8 returned -19 after 5 usecs
> [    2.132020] calling  gtdt_sbsa_gwdt_init+0x0/0x120 @ 1
> [    2.132030] initcall gtdt_sbsa_gwdt_init+0x0/0x120 returned 0 after 0
> usecs
> [    2.132041] calling  of_fixed_factor_clk_driver_init+0x0/0x30 @ 1
> [    2.132104] initcall of_fixed_factor_clk_driver_init+0x0/0x30
> returned 0 after 49 usecs
> [    2.132118] calling  of_fixed_clk_driver_init+0x0/0x30 @ 1
> [    2.132167] initcall of_fixed_clk_driver_init+0x0/0x30 returned 0
> after 36 usecs
> [    2.132181] calling  gpio_clk_driver_init+0x0/0x30 @ 1
> [    2.132236] initcall gpio_clk_driver_init+0x0/0x30 returned 0 after
> 43 usecs
> [    2.132249] calling  cs2000_driver_init+0x0/0x30 @ 1
> [    2.132283] initcall cs2000_driver_init+0x0/0x30 returned 0 after 22
> usecs
> [    2.132295] calling  fsl_flexspi_clk_driver_init+0x0/0x30 @ 1
> [    2.132434] initcall fsl_flexspi_clk_driver_init+0x0/0x30 returned 0
> after 124 usecs
> [    2.132450] calling  fsl_sai_clk_driver_init+0x0/0x30 @ 1
> [    2.132501] initcall fsl_sai_clk_driver_init+0x0/0x30 returned 0
> after 38 usecs
> [    2.132515] calling  plldig_clk_driver_init+0x0/0x30 @ 1
> [    2.132617] initcall plldig_clk_driver_init+0x0/0x30 returned 0 after
> 89 usecs
> [    2.132633] calling  clk_pwm_driver_init+0x0/0x30 @ 1
> [    2.132681] initcall clk_pwm_driver_init+0x0/0x30 returned 0 after 36
> usecs
> [    2.132694] calling  clockgen_cpufreq_init+0x0/0xac @ 1
> [    2.132760] initcall clockgen_cpufreq_init+0x0/0xac returned 0 after
> 54 usecs
> [    2.132774] calling  rk808_clkout_driver_init+0x0/0x30 @ 1
> [    2.132809] initcall rk808_clkout_driver_init+0x0/0x30 returned 0
> after 23 usecs
> [    2.132823] calling  s2mps11_clk_driver_init+0x0/0x30 @ 1
> [    2.132863] initcall s2mps11_clk_driver_init+0x0/0x30 returned 0
> after 27 usecs
> [    2.132877] calling  scpi_clocks_driver_init+0x0/0x30 @ 1
> [    2.132925] initcall scpi_clocks_driver_init+0x0/0x30 returned 0
> after 36 usecs
> [    2.132938] calling  mv_xor_v2_driver_init+0x0/0x30 @ 1
> [    2.132985] initcall mv_xor_v2_driver_init+0x0/0x30 returned 0 after
> 35 usecs
> [    2.132998] calling  pl330_driver_init+0x0/0x2c @ 1
> [    2.133023] initcall pl330_driver_init+0x0/0x2c returned 0 after 13
> usecs
> [    2.133036] calling  hidma_mgmt_init+0x0/0x1f0 @ 1
> [    2.133127] initcall hidma_mgmt_init+0x0/0x1f0 returned 0 after 78
> usecs
> [    2.133140] calling  hidma_driver_init+0x0/0x30 @ 1
> [    2.133199] initcall hidma_driver_init+0x0/0x30 returned 0 after 47
> usecs
> [    2.133212] calling  dpaa2_console_driver_init+0x0/0x30 @ 1
> [    2.133262] initcall dpaa2_console_driver_init+0x0/0x30 returned 0
> after 37 usecs
> [    2.133275] calling  virtio_mmio_init+0x0/0x30 @ 1
> [    2.133323] initcall virtio_mmio_init+0x0/0x30 returned 0 after 36
> usecs
> [    2.133336] calling  virtio_pci_driver_init+0x0/0x38 @ 1
> [    2.133422] initcall virtio_pci_driver_init+0x0/0x38 returned 0 after
> 73 usecs
> [    2.133438] calling  virtio_balloon_driver_init+0x0/0x2c @ 1
> [    2.133460] initcall virtio_balloon_driver_init+0x0/0x2c returned 0
> after 10 usecs
> [    2.133474] calling  xenbus_probe_initcall+0x0/0x74 @ 1
> [    2.133483] initcall xenbus_probe_initcall+0x0/0x74 returned -19
> after 0 usecs
> [    2.133493] calling  xenbus_init+0x0/0x60 @ 1
> [    2.133502] initcall xenbus_init+0x0/0x60 returned -19 after 0 usecs
> [    2.133511] calling  xenbus_backend_init+0x0/0x6c @ 1
> [    2.133519] initcall xenbus_backend_init+0x0/0x6c returned -19 after
> 0 usecs
> [    2.133528] calling  evtchn_init+0x0/0x70 @ 1
> [    2.133537] initcall evtchn_init+0x0/0x70 returned -19 after 0 usecs
> [    2.133545] calling  gntdev_init+0x0/0x78 @ 1
> [    2.133554] initcall gntdev_init+0x0/0x78 returned -19 after 0 usecs
> [    2.133563] calling  gntalloc_init+0x0/0x60 @ 1
> [    2.133571] initcall gntalloc_init+0x0/0x60 returned -19 after 0
> usecs
> [    2.133580] calling  xenfs_init+0x0/0x40 @ 1
> [    2.133588] initcall xenfs_init+0x0/0x40 returned 0 after 0 usecs
> [    2.133597] calling  hyper_sysfs_init+0x0/0x134 @ 1
> [    2.133606] initcall hyper_sysfs_init+0x0/0x134 returned -19 after 0
> usecs
> [    2.133615] calling  hypervisor_subsys_init+0x0/0x40 @ 1
> [    2.133624] initcall hypervisor_subsys_init+0x0/0x40 returned -19
> after 0 usecs
> [    2.133634] calling  privcmd_init+0x0/0x90 @ 1
> [    2.133642] initcall privcmd_init+0x0/0x90 returned -19 after 0 usecs
> [    2.133652] calling  axp20x_regulator_driver_init+0x0/0x30 @ 1
> [    2.133685] initcall axp20x_regulator_driver_init+0x0/0x30 returned 0
> after 23 usecs
> [    2.133697] calling  bd718xx_regulator_init+0x0/0x30 @ 1
> [    2.133729] initcall bd718xx_regulator_init+0x0/0x30 returned 0 after
> 22 usecs
> [    2.133741] calling  bd9571mwv_regulator_driver_init+0x0/0x30 @ 1
> [    2.133773] initcall bd9571mwv_regulator_driver_init+0x0/0x30
> returned 0 after 22 usecs
> [    2.133785] calling  fan53555_regulator_driver_init+0x0/0x30 @ 1
> [    2.133817] initcall fan53555_regulator_driver_init+0x0/0x30 returned
> 0 after 22 usecs
> [    2.133829] calling  hi6421v530_regulator_driver_init+0x0/0x30 @ 1
> [    2.133865] initcall hi6421v530_regulator_driver_init+0x0/0x30
> returned 0 after 26 usecs
> [    2.133877] calling  max77620_regulator_driver_init+0x0/0x30 @ 1
> [    2.133911] initcall max77620_regulator_driver_init+0x0/0x30 returned
> 0 after 24 usecs
> [    2.133923] calling  qcom_spmi_regulator_driver_init+0x0/0x30 @ 1
> [    2.134017] initcall qcom_spmi_regulator_driver_init+0x0/0x30
> returned 0 after 83 usecs
> [    2.134029] calling  pfuze_driver_init+0x0/0x30 @ 1
> [    2.134057] initcall pfuze_driver_init+0x0/0x30 returned 0 after 18
> usecs
> [    2.134067] calling  pwm_regulator_driver_init+0x0/0x30 @ 1
> [    2.134114] initcall pwm_regulator_driver_init+0x0/0x30 returned 0
> after 36 usecs
> [    2.134125] calling  rk808_regulator_driver_init+0x0/0x30 @ 1
> [    2.134159] initcall rk808_regulator_driver_init+0x0/0x30 returned 0
> after 24 usecs
> [    2.134171] calling  s2mps11_pmic_driver_init+0x0/0x30 @ 1
> [    2.134205] initcall s2mps11_pmic_driver_init+0x0/0x30 returned 0
> after 24 usecs
> [    2.134217] calling  brcm_rescal_reset_driver_init+0x0/0x30 @ 1
> [    2.134263] initcall brcm_rescal_reset_driver_init+0x0/0x30 returned
> 0 after 36 usecs
> [    2.134276] calling  n_null_init+0x0/0x38 @ 1
> [    2.134285] initcall n_null_init+0x0/0x38 returned 0 after 0 usecs
> [    2.134294] calling  ttynull_init+0x0/0x114 @ 1
> [    2.134388] initcall ttynull_init+0x0/0x114 returned 0 after 83 usecs
> [    2.134400] calling  pty_init+0x0/0x380 @ 1
> [    2.135702] initcall pty_init+0x0/0x380 returned 0 after 1263 usecs
> [    2.135716] calling  sysrq_init+0x0/0x90 @ 1
> [    2.135738] initcall sysrq_init+0x0/0x90 returned 0 after 13 usecs
> [    2.135749] calling  xen_hvc_init+0x0/0x298 @ 1
> [    2.135758] initcall xen_hvc_init+0x0/0x298 returned -19 after 0
> usecs
> [    2.135768] calling  serial8250_init+0x0/0x16c @ 1
> [    2.135777] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    2.136340] initcall serial8250_init+0x0/0x16c returned 0 after 550
> usecs
> [    2.136355] calling  serial_pci_driver_init+0x0/0x38 @ 1
> [    2.136423] initcall serial_pci_driver_init+0x0/0x38 returned 0 after
> 57 usecs
> [    2.136435] calling  exar_pci_driver_init+0x0/0x38 @ 1
> [    2.136464] initcall exar_pci_driver_init+0x0/0x38 returned 0 after
> 18 usecs
> [    2.136475] calling  fsl8250_platform_driver_init+0x0/0x30 @ 1
> [    2.136510] initcall fsl8250_platform_driver_init+0x0/0x30 returned 0
> after 24 usecs
> [    2.136523] calling  dw8250_platform_driver_init+0x0/0x30 @ 1
> [    2.136592] initcall dw8250_platform_driver_init+0x0/0x30 returned 0
> after 59 usecs
> [    2.136605] calling  of_platform_serial_driver_init+0x0/0x30 @ 1
> [    2.136881] 21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 24,
> base_baud = 12500000) is a 16550A
> [   10.438346] printk: console [ttyS0] enabled
> [   10.442935] 21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 24,
> base_baud = 12500000) is a 16550A
> [   10.451984] initcall of_platform_serial_driver_init+0x0/0x30 returned
> 0 after 8120478 usecs
> [   10.460390] calling  lpuart_serial_init+0x0/0x6c @ 1
> [   10.465519] 2270000.serial: ttyLP2 at MMIO 0x2270000 (irq = 25,
> base_baud = 12500000) is a FSL_LPUART
> [   10.475022] initcall lpuart_serial_init+0x0/0x6c returned 0 after
> 9414 usecs
> [   10.482126] calling  init+0x0/0x124 @ 1
> [   10.486027] initcall init+0x0/0x124 returned 0 after 42 usecs
> [   10.491813] calling  tpm_tis_i2c_driver_init+0x0/0x30 @ 1
> [   10.497270] initcall tpm_tis_i2c_driver_init+0x0/0x30 returned 0
> after 29 usecs
> [   10.504617] calling  arm_smmu_driver_init+0x0/0x30 @ 1
> [   10.510295] arm-smmu 5000000.iommu: probing hardware configuration...
> [   10.516768] arm-smmu 5000000.iommu: SMMUv2 with:
> [   10.521406] arm-smmu 5000000.iommu:  stage 1 translation
> [   10.526740] arm-smmu 5000000.iommu:  stage 2 translation
> [   10.532075] arm-smmu 5000000.iommu:  nested translation
> [   10.537324] arm-smmu 5000000.iommu:  stream matching with 128
> register groups
> [   10.544493] arm-smmu 5000000.iommu:  64 context banks (0 stage-2
> only)
> [   10.551053] arm-smmu 5000000.iommu:  Supported page sizes: 0x61311000
> [   10.557523] arm-smmu 5000000.iommu:  Stage-1: 48-bit VA -> 48-bit IPA
> [   10.563993] arm-smmu 5000000.iommu:  Stage-2: 48-bit IPA -> 48-bit PA
> [   10.570755] initcall arm_smmu_driver_init+0x0/0x30 returned 0 after
> 59541 usecs
> [   10.578105] calling  arm_smmu_driver_init+0x0/0x34 @ 1
> [   10.583311] initcall arm_smmu_driver_init+0x0/0x34 returned 0 after
> 41 usecs
> [   10.590395] calling  drm_kms_helper_init+0x0/0x2c @ 1
> [   10.595472] initcall drm_kms_helper_init+0x0/0x2c returned 0 after 0
> usecs
> [   10.602379] calling  drm_core_init+0x0/0xc8 @ 1
> [   10.606951] initcall drm_core_init+0x0/0xc8 returned 0 after 19 usecs
> [   10.613425] calling  topology_sysfs_init+0x0/0x48 @ 1
> [   10.618534] initcall topology_sysfs_init+0x0/0x48 returned 0 after 32
> usecs
> [   10.625530] calling  cacheinfo_sysfs_init+0x0/0x48 @ 1
> [   10.630833] initcall cacheinfo_sysfs_init+0x0/0x48 returned 0 after
> 133 usecs
> [   10.638009] calling  auxiliary_bus_init+0x0/0x2c @ 1
> [   10.643012] initcall auxiliary_bus_init+0x0/0x2c returned 0 after 13
> usecs
> [   10.649921] calling  devcoredump_init+0x0/0x38 @ 1
> [   10.654744] initcall devcoredump_init+0x0/0x38 returned 0 after 8
> usecs
> [   10.661391] calling  loop_init+0x0/0x160 @ 1
> [   10.669667] loop: module loaded
> [   10.672831] initcall loop_init+0x0/0x160 returned 0 after 6980 usecs
> [   10.679230] calling  init+0x0/0xac @ 1
> [   10.683023] initcall init+0x0/0xac returned 0 after 23 usecs
> [   10.688711] calling  xlblk_init+0x0/0x158 @ 1
> [   10.693093] initcall xlblk_init+0x0/0x158 returned -19 after 0 usecs
> [   10.699479] calling  at24_init+0x0/0x6c @ 1
> [   10.703780] at24 0-0050: supply vcc not found, using dummy regulator
> [   10.710233] at24 0-0050: Linked as a consumer to regulator.0
> [   10.716714] at24 0-0050: 4096 byte 24c32 EEPROM, writable, 32
> bytes/write
> [   10.723618] at24 1-0057: supply vcc not found, using dummy regulator
> [   10.730062] at24 1-0057: Linked as a consumer to regulator.0
> [   10.736516] at24 1-0057: 4096 byte 24c32 EEPROM, writable, 32
> bytes/write
> [   10.743411] at24 2-0050: supply vcc not found, using dummy regulator
> [   10.749859] at24 2-0050: Linked as a consumer to regulator.0
> [   10.756314] at24 2-0050: 4096 byte 24c32 EEPROM, writable, 32
> bytes/write
> [   10.763177] initcall at24_init+0x0/0x6c returned 0 after 58100 usecs
> [   10.769574] calling  at25_driver_init+0x0/0x30 @ 1
> [   10.774402] initcall at25_driver_init+0x0/0x30 returned 0 after 11
> usecs
> [   10.781137] calling  bd9571mwv_driver_init+0x0/0x30 @ 1
> [   10.786406] initcall bd9571mwv_driver_init+0x0/0x30 returned 0 after
> 18 usecs
> [   10.793577] calling  cros_ec_dev_init+0x0/0x94 @ 1
> [   10.798466] initcall cros_ec_dev_init+0x0/0x94 returned 0 after 73
> usecs
> [   10.805202] calling  axp20x_i2c_driver_init+0x0/0x30 @ 1
> [   10.810567] initcall axp20x_i2c_driver_init+0x0/0x30 returned 0 after
> 23 usecs
> [   10.817827] calling  max77620_driver_init+0x0/0x30 @ 1
> [   10.823011] initcall max77620_driver_init+0x0/0x30 returned 0 after
> 19 usecs
> [   10.830096] calling  rk808_i2c_driver_init+0x0/0x30 @ 1
> [   10.835367] initcall rk808_i2c_driver_init+0x0/0x30 returned 0 after
> 19 usecs
> [   10.842539] calling  vexpress_sysreg_driver_init+0x0/0x30 @ 1
> [   10.848390] initcall vexpress_sysreg_driver_init+0x0/0x30 returned 0
> after 70 usecs
> [   10.856088] calling  hi6421_pmic_driver_init+0x0/0x30 @ 1
> [   10.861561] initcall hi6421_pmic_driver_init+0x0/0x30 returned 0
> after 45 usecs
> [   10.868907] calling  simple_mfd_i2c_driver_init+0x0/0x30 @ 1
> [   10.875402] platform 2000000.i2c:sl28cpld@4a:gpio@10: Linked as a
> sync state only consumer to 2310000.gpio
> [   10.890943] sysfs: cannot create duplicate filename
> '/devices/platform/soc/2310000.gpio/consumer:platform:2000000.i2c:sl28cpld@4'
> [   10.902677] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 5.11.0-rc2-next-20210107-00018-g832f4343aa38-dirty #307
> [   10.912635] Hardware name: Kontron KBox A-230-LS (DT)
> [   10.917703] Call trace:
> [   10.920152]  dump_backtrace+0x0/0x1b8
> [   10.923834]  show_stack+0x20/0x70
> [   10.927160]  dump_stack+0xd8/0x134
> [   10.930573]  sysfs_warn_dup+0x6c/0x88
> [   10.934247]  sysfs_do_create_link_sd.isra.2+0x10c/0x110
> [   10.939491]  sysfs_create_link+0x2c/0x50
> [   10.943426]  devlink_add_symlinks+0x114/0x1e0
> [   10.947800]  device_add+0x460/0x798
> [   10.951298]  device_link_add+0x47c/0x670
> [   10.955231]  fw_devlink_create_devlink+0xb8/0xc8
> [   10.959864]  __fw_devlink_link_to_suppliers+0x84/0x180
> [   10.965020]  device_add+0x778/0x798
> [   10.968517]  of_device_add+0x50/0x70
> [   10.972107]  of_platform_device_create_pdata+0xc8/0x118
> [   10.977353]  of_platform_bus_create+0x188/0x3b8
> [   10.981900]  of_platform_populate+0x84/0x110
> [   10.986185]  devm_of_platform_populate+0x58/0xc0
> [   10.990819]  simple_mfd_i2c_probe+0x5c/0x70
> [   10.995018]  i2c_device_probe+0x178/0x2f0
> [   10.999041]  really_probe+0xec/0x3c0
> [   11.002627]  driver_probe_device+0xac/0xc0
> [   11.006737]  device_driver_attach+0x7c/0x88
> [   11.010934]  __driver_attach+0x60/0xe8
> [   11.014695]  bus_for_each_dev+0x7c/0xd0
> [   11.018543]  driver_attach+0x2c/0x38
> [   11.022129]  bus_add_driver+0x194/0x1f8
> [   11.025976]  driver_register+0x6c/0x128
> [   11.029824]  i2c_register_driver+0x50/0xa0
> [   11.033933]  simple_mfd_i2c_driver_init+0x24/0x30
> [   11.038655]  do_one_initcall+0x54/0x2d8
> [   11.042502]  kernel_init_freeable+0x200/0x26c
> [   11.046874]  kernel_init+0x1c/0x120
> [   11.050375]  ret_from_fork+0x10/0x30
> [   11.053987] platform 2000000.i2c:sl28cpld@4a:gpio@15: Linked as a
> sync state only consumer to 2310000.gpio
> [   11.069859] platform buttons0: Linked as a sync state only consumer
> to 2000000.i2c:sl28cpld@4a:interrupt-controller@1c
> [   11.080658] platform 2000000.i2c:sl28cpld@4a:interrupt-controller@1c:
> Linked as a sync state only consumer to 2310000.gpio
> [   11.092632] initcall simple_mfd_i2c_driver_init+0x0/0x30 returned 0
> after 212924 usecs
> [   11.100617] calling  sas_transport_init+0x0/0xc8 @ 1
> [   11.105660] initcall sas_transport_init+0x0/0xc8 returned 0 after 44
> usecs
> [   11.112571] calling  sas_class_init+0x0/0x94 @ 1
> [   11.117230] initcall sas_class_init+0x0/0x94 returned 0 after 14
> usecs
> [   11.123791] calling  init_sd+0x0/0x1a4 @ 1
> [   11.127950] initcall init_sd+0x0/0x1a4 returned 0 after 41 usecs
> [   11.133989] calling  hisi_sas_init+0x0/0x98 @ 1
> [   11.138546] initcall hisi_sas_init+0x0/0x98 returned 0 after 3 usecs
> [   11.144932] calling  hisi_sas_v1_driver_init+0x0/0x30 @ 1
> [   11.150455] initcall hisi_sas_v1_driver_init+0x0/0x30 returned 0
> after 96 usecs
> [   11.157802] calling  hisi_sas_v2_driver_init+0x0/0x30 @ 1
> [   11.163284] initcall hisi_sas_v2_driver_init+0x0/0x30 returned 0
> after 55 usecs
> [   11.170631] calling  sas_v3_pci_driver_init+0x0/0x38 @ 1
> [   11.176011] initcall sas_v3_pci_driver_init+0x0/0x38 returned 0 after
> 38 usecs
> [   11.183271] calling  ahci_pci_driver_init+0x0/0x38 @ 1
> [   11.188471] initcall ahci_pci_driver_init+0x0/0x38 returned 0 after
> 34 usecs
> [   11.195555] calling  ahci_driver_init+0x0/0x30 @ 1
> [   11.200448] initcall ahci_driver_init+0x0/0x30 returned 0 after 76
> usecs
> [   11.207182] calling  sil24_pci_driver_init+0x0/0x38 @ 1
> [   11.212462] initcall sil24_pci_driver_init+0x0/0x38 returned 0 after
> 28 usecs
> [   11.219634] calling  ceva_ahci_driver_init+0x0/0x30 @ 1
> [   11.224931] initcall ceva_ahci_driver_init+0x0/0x30 returned 0 after
> 44 usecs
> [   11.232103] calling  xgene_ahci_driver_init+0x0/0x30 @ 1
> [   11.237497] initcall xgene_ahci_driver_init+0x0/0x30 returned 0 after
> 51 usecs
> [   11.244757] calling  ahci_qoriq_driver_init+0x0/0x30 @ 1
> [   11.250182] ahci-qoriq 3200000.sata: Linked as a consumer to
> 5000000.iommu
> [   11.257105] ahci-qoriq 3200000.sata: Adding to iommu group 0
> [   11.262916] ahci-qoriq 3200000.sata: supply ahci not found, using
> dummy regulator
> [   11.270499] ahci-qoriq 3200000.sata: Linked as a consumer to
> regulator.0
> [   11.277236] ahci-qoriq 3200000.sata: supply phy not found, using
> dummy regulator
> [   11.284701] ahci-qoriq 3200000.sata: supply target not found, using
> dummy regulator
> [   11.292479] ahci-qoriq 3200000.sata: AHCI 0001.0301 32 slots 1 ports
> 6 Gbps 0x1 impl platform mode
> [   11.301502] ahci-qoriq 3200000.sata: flags: 64bit ncq sntf pm clo
> only pmp fbs pio slum part ccc sds apst
> [   11.311664] scsi host0: ahci-qoriq
> [   11.315238] ata1: SATA max UDMA/133 mmio [mem 0x03200000-0x0320ffff]
> port 0x100 irq 31
> [   11.323314] initcall ahci_qoriq_driver_init+0x0/0x30 returned 0 after
> 71503 usecs
> [   11.330848] calling  pata_platform_driver_init+0x0/0x30 @ 1
> [   11.336501] initcall pata_platform_driver_init+0x0/0x30 returned 0
> after 50 usecs
> [   11.344023] calling  pata_of_platform_driver_init+0x0/0x30 @ 1
> [   11.349938] initcall pata_of_platform_driver_init+0x0/0x30 returned 0
> after 52 usecs
> [   11.357722] calling  init_mtd+0x0/0x138 @ 1
> [   11.362003] initcall init_mtd+0x0/0x138 returned 0 after 71 usecs
> [   11.368132] calling  ofpart_parser_init+0x0/0x4c @ 1
> [   11.373123] initcall ofpart_parser_init+0x0/0x4c returned 0 after 0
> usecs
> [   11.379945] calling  init_mtdblock+0x0/0x2c @ 1
> [   11.384501] initcall init_mtdblock+0x0/0x2c returned 0 after 3 usecs
> [   11.390887] calling  denali_dt_driver_init+0x0/0x30 @ 1
> [   11.396202] initcall denali_dt_driver_init+0x0/0x30 returned 0 after
> 63 usecs
> [   11.403375] calling  spi_nor_driver_init+0x0/0x30 @ 1
> [   11.408464] initcall spi_nor_driver_init+0x0/0x30 returned 0 after 11
> usecs
> [   11.415460] calling  fsl_dspi_driver_init+0x0/0x30 @ 1
> [   11.421076] initcall fsl_dspi_driver_init+0x0/0x30 returned 0 after
> 440 usecs
> [   11.428279] calling  nxp_fspi_driver_init+0x0/0x30 @ 1
> [   11.433811] spi-nor spi0.0: w25q32dw (4096 Kbytes)
> [   11.438885] 8 fixed-partitions partitions found on MTD device
> 20c0000.spi
> [   11.445722] Creating 8 MTD partitions on "20c0000.spi":
> [   11.450975] 0x000000000000-0x000000010000 : "rcw"
> [   11.457778] 0x000000010000-0x000000100000 : "failsafe bootloader"
> [   11.465740] 0x000000100000-0x000000140000 : "failsafe DP firmware"
> [   11.473746] 0x000000140000-0x0000001e0000 : "failsafe trusted
> firmware"
> [   11.481733] 0x0000001e0000-0x000000200000 : "reserved"
> [   11.489734] 0x000000200000-0x000000210000 : "configuration store"
> [   11.497757] 0x000000210000-0x0000003e0000 : "bootloader"
> [   11.505742] 0x0000003e0000-0x000000400000 : "bootloader environment"
> [   11.513950] initcall nxp_fspi_driver_init+0x0/0x30 returned 0 after
> 78612 usecs
> [   11.521318] calling  rockchip_spi_driver_init+0x0/0x30 @ 1
> [   11.526977] initcall rockchip_spi_driver_init+0x0/0x30 returned 0
> after 136 usecs
> [   11.534510] calling  net_olddevs_init+0x0/0xa0 @ 1
> [   11.539340] initcall net_olddevs_init+0x0/0xa0 returned 0 after 7
> usecs
> [   11.545993] calling  blackhole_netdev_init+0x0/0x9c @ 1
> [   11.551258] initcall blackhole_netdev_init+0x0/0x9c returned 0 after
> 14 usecs
> [   11.558431] calling  phy_module_init+0x0/0x34 @ 1
> [   11.563210] initcall phy_module_init+0x0/0x34 returned 0 after 50
> usecs
> [   11.569857] calling  phy_module_init+0x0/0x34 @ 1
> [   11.574594] initcall phy_module_init+0x0/0x34 returned 0 after 9
> usecs
> [   11.581154] calling  fixed_mdio_bus_init+0x0/0x124 @ 1
> [   11.586574] libphy: Fixed MDIO Bus: probed
> [   11.590690] initcall fixed_mdio_bus_init+0x0/0x124 returned 0 after
> 4270 usecs
> [   11.597949] calling  phy_module_init+0x0/0x34 @ 1
> [   11.602813] initcall phy_module_init+0x0/0x34 returned 0 after 132
> usecs
> [   11.609552] calling  phy_module_init+0x0/0x34 @ 1
> [   11.614425] initcall phy_module_init+0x0/0x34 returned 0 after 141
> usecs
> [   11.621161] calling  phy_module_init+0x0/0x34 @ 1
> [   11.625900] initcall phy_module_init+0x0/0x34 returned 0 after 10
> usecs
> [   11.632546] calling  thunder_mdiobus_driver_init+0x0/0x38 @ 1
> [   11.638366] initcall thunder_mdiobus_driver_init+0x0/0x38 returned 0
> after 43 usecs
> [   11.645531] ata1: SATA link down (SStatus 0 SControl 300)
> [   11.646061] calling  mdio_mux_mmioreg_driver_init+0x0/0x30 @ 1
> [   11.657414] initcall mdio_mux_mmioreg_driver_init+0x0/0x30 returned 0
> after 79 usecs
> [   11.665197] calling  tun_init+0x0/0xd4 @ 1
> [   11.669314] tun: Universal TUN/TAP device driver, 1.6
> [   11.674483] initcall tun_init+0x0/0xd4 returned 0 after 5048 usecs
> [   11.680699] calling  virtio_net_driver_init+0x0/0xc0 @ 1
> [   11.686051] initcall virtio_net_driver_init+0x0/0xc0 returned 0 after
> 14 usecs
> [   11.693310] calling  can_dev_init+0x0/0x4c @ 1
> [   11.697774] CAN device driver interface
> [   11.701624] initcall can_dev_init+0x0/0x4c returned 0 after 3760
> usecs
> [   11.708181] calling  flexcan_driver_init+0x0/0x30 @ 1
> [   11.713741] initcall flexcan_driver_init+0x0/0x30 returned 0 after
> 472 usecs
> [   11.720837] calling  felix_vsc9959_pci_driver_init+0x0/0x38 @ 1
> [   11.726860] mscc_felix 0000:00:00.5: Linked as a consumer to
> 5000000.iommu
> [   11.733802] mscc_felix 0000:00:00.5: Adding to iommu group 1
> [   11.739639] mscc_felix 0000:00:00.5: enabling device (0404 -> 0406)
> [   11.746091] mscc_felix 0000:00:00.5: Failed to register DSA switch:
> -517
> [   11.752908] initcall felix_vsc9959_pci_driver_init+0x0/0x38 returned
> 0 after 25506 usecs
> [   11.761049] calling  xgbe_mod_init+0x0/0x68 @ 1
> [   11.765733] initcall xgbe_mod_init+0x0/0x68 returned 0 after 127
> usecs
> [   11.772295] calling  macb_driver_init+0x0/0x30 @ 1
> [   11.777254] initcall macb_driver_init+0x0/0x30 returned 0 after 141
> usecs
> [   11.784079] calling  xcv_init_module+0x0/0x5c @ 1
> [   11.788806] thunder_xcv, ver 1.0
> [   11.792069] initcall xcv_init_module+0x0/0x5c returned 0 after 3185
> usecs
> [   11.798891] calling  bgx_init_module+0x0/0x5c @ 1
> [   11.803616] thunder_bgx, ver 1.0
> [   11.806901] initcall bgx_init_module+0x0/0x5c returned 0 after 3207
> usecs
> [   11.813728] calling  nic_init_module+0x0/0x5c @ 1
> [   11.818456] nicpf, ver 1.0
> [   11.821189] initcall nic_init_module+0x0/0x5c returned 0 after 2668
> usecs
> [   11.828012] calling  enetc_pf_driver_init+0x0/0x38 @ 1
> [   11.833242] sysfs: cannot create duplicate filename
> '/devices/platform/soc/5000000.iommu/consumer:pci:0000:00:0'
> [   11.843470] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 5.11.0-rc2-next-20210107-00018-g832f4343aa38-dirty #307
> [   11.853426] Hardware name: Kontron KBox A-230-LS (DT)
> [   11.858493] Call trace:
> [   11.860943]  dump_backtrace+0x0/0x1b8
> [   11.864624]  show_stack+0x20/0x70
> [   11.867949]  dump_stack+0xd8/0x134
> [   11.871362]  sysfs_warn_dup+0x6c/0x88
> [   11.875036]  sysfs_do_create_link_sd.isra.2+0x10c/0x110
> [   11.880280]  sysfs_create_link+0x2c/0x50
> [   11.884213]  devlink_add_symlinks+0x114/0x1e0
> [   11.888588]  device_add+0x460/0x798
> [   11.892085]  device_link_add+0x47c/0x670
> [   11.896020]  arm_smmu_probe_device+0x218/0x478
> [   11.900481]  __iommu_probe_device+0x5c/0x1c8
> [   11.904764]  iommu_probe_device+0x30/0x138
> [   11.908873]  of_iommu_configure+0x134/0x200
> [   11.913070]  of_dma_configure_id+0x110/0x290
> [   11.917358]  pci_dma_configure+0x4c/0xd8
> [   11.921295]  really_probe+0xa8/0x3c0
> [   11.924882]  driver_probe_device+0xac/0xc0
> [   11.928991]  device_driver_attach+0x7c/0x88
> [   11.933188]  __driver_attach+0x60/0xe8
> [   11.936949]  bus_for_each_dev+0x7c/0xd0
> [   11.940797]  driver_attach+0x2c/0x38
> [   11.944383]  bus_add_driver+0x194/0x1f8
> [   11.948230]  driver_register+0x6c/0x128
> [   11.952079]  __pci_register_driver+0x4c/0x58
> [   11.956363]  enetc_pf_driver_init+0x2c/0x38
> [   11.960561]  do_one_initcall+0x54/0x2d8
> [   11.964408]  kernel_init_freeable+0x200/0x26c
> [   11.968780]  kernel_init+0x1c/0x120
> [   11.972280]  ret_from_fork+0x10/0x30
> [   11.975887] fsl_enetc 0000:00:00.0: Linked as a consumer to
> 5000000.iommu
> [   11.982747] fsl_enetc 0000:00:00.0: Adding to iommu group 2
> [   12.093395] fsl_enetc 0000:00:00.0: enabling device (0400 -> 0402)
> [   12.099641] fsl_enetc 0000:00:00.0: no MAC address specified for SI1,
> using ea:45:22:e0:2e:eb
> [   12.108210] fsl_enetc 0000:00:00.0: no MAC address specified for SI2,
> using 9e:da:36:8f:5e:17
> [   12.117174] libphy: Freescale ENETC MDIO Bus: probed
> [   12.123342] libphy: Freescale ENETC internal MDIO Bus: probed
> [   12.129620] sysfs: cannot create duplicate filename
> '/devices/platform/soc/5000000.iommu/consumer:pci:0000:00:0'
> [   12.139851] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 5.11.0-rc2-next-20210107-00018-g832f4343aa38-dirty #307
> [   12.149808] Hardware name: Kontron KBox A-230-LS (DT)
> [   12.154875] Call trace:
> [   12.157323]  dump_backtrace+0x0/0x1b8
> [   12.161005]  show_stack+0x20/0x70
> [   12.164331]  dump_stack+0xd8/0x134
> [   12.167745]  sysfs_warn_dup+0x6c/0x88
> [   12.171419]  sysfs_do_create_link_sd.isra.2+0x10c/0x110
> [   12.176663]  sysfs_create_link+0x2c/0x50
> [   12.180597]  devlink_add_symlinks+0x114/0x1e0
> [   12.184970]  device_add+0x460/0x798
> [   12.188467]  device_link_add+0x47c/0x670
> [   12.192402]  arm_smmu_probe_device+0x218/0x478
> [   12.196861]  __iommu_probe_device+0x5c/0x1c8
> [   12.201146]  iommu_probe_device+0x30/0x138
> [   12.205254]  of_iommu_configure+0x134/0x200
> [   12.209452]  of_dma_configure_id+0x110/0x290
> [   12.213739]  pci_dma_configure+0x4c/0xd8
> [   12.217677]  really_probe+0xa8/0x3c0
> [   12.221263]  driver_probe_device+0xac/0xc0
> [   12.225372]  device_driver_attach+0x7c/0x88
> [   12.229569]  __driver_attach+0x60/0xe8
> [   12.233329]  bus_for_each_dev+0x7c/0xd0
> [   12.237177]  driver_attach+0x2c/0x38
> [   12.240762]  bus_add_driver+0x194/0x1f8
> [   12.244609]  driver_register+0x6c/0x128
> [   12.248458]  __pci_register_driver+0x4c/0x58
> [   12.252743]  enetc_pf_driver_init+0x2c/0x38
> [   12.256942]  do_one_initcall+0x54/0x2d8
> [   12.260790]  kernel_init_freeable+0x200/0x26c
> [   12.265161]  kernel_init+0x1c/0x120
> [   12.268662]  ret_from_fork+0x10/0x30
> [   12.272269] fsl_enetc 0000:00:00.1: Linked as a consumer to
> 5000000.iommu
> [   12.279124] fsl_enetc 0000:00:00.1: Adding to iommu group 3
> [   12.389391] fsl_enetc 0000:00:00.1: enabling device (0400 -> 0402)
> [   12.395640] fsl_enetc 0000:00:00.1: no MAC address specified for SI1,
> using 5e:46:a8:bc:a8:a4
> [   12.404208] fsl_enetc 0000:00:00.1: no MAC address specified for SI2,
> using 72:71:49:df:30:22
> [   12.413193] mdio_bus 0000:00:00.1: Linked as a sync state only
> consumer to 0000:00:00.1
> [   12.421261] libphy: Freescale ENETC MDIO Bus: probed
> [   12.426718] mdio_bus 0000:00:00.1:04: Linked as a sync state only
> consumer to 0000:00:00.1
> [   12.436358] sysfs: cannot create duplicate filename
> '/devices/platform/soc/5000000.iommu/consumer:pci:0000:00:0'
> [   12.446608] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 5.11.0-rc2-next-20210107-00018-g832f4343aa38-dirty #307
> [   12.456565] Hardware name: Kontron KBox A-230-LS (DT)
> [   12.461632] Call trace:
> [   12.464082]  dump_backtrace+0x0/0x1b8
> [   12.467764]  show_stack+0x20/0x70
> [   12.471090]  dump_stack+0xd8/0x134
> [   12.474504]  sysfs_warn_dup+0x6c/0x88
> [   12.478178]  sysfs_do_create_link_sd.isra.2+0x10c/0x110
> [   12.483422]  sysfs_create_link+0x2c/0x50
> [   12.487357]  devlink_add_symlinks+0x114/0x1e0
> [   12.491731]  device_add+0x460/0x798
> [   12.495228]  device_link_add+0x47c/0x670
> [   12.499162]  arm_smmu_probe_device+0x218/0x478
> [   12.503622]  __iommu_probe_device+0x5c/0x1c8
> [   12.507906]  iommu_probe_device+0x30/0x138
> [   12.512015]  of_iommu_configure+0x134/0x200
> [   12.516212]  of_dma_configure_id+0x110/0x290
> [   12.520499]  pci_dma_configure+0x4c/0xd8
> [   12.524437]  really_probe+0xa8/0x3c0
> [   12.528023]  driver_probe_device+0xac/0xc0
> [   12.532132]  device_driver_attach+0x7c/0x88
> [   12.536328]  __driver_attach+0x60/0xe8
> [   12.540088]  bus_for_each_dev+0x7c/0xd0
> [   12.543936]  driver_attach+0x2c/0x38
> [   12.547521]  bus_add_driver+0x194/0x1f8
> [   12.551369]  driver_register+0x6c/0x128
> [   12.555217]  __pci_register_driver+0x4c/0x58
> [   12.559501]  enetc_pf_driver_init+0x2c/0x38
> [   12.563700]  do_one_initcall+0x54/0x2d8
> [   12.567548]  kernel_init_freeable+0x200/0x26c
> [   12.571919]  kernel_init+0x1c/0x120
> [   12.575419]  ret_from_fork+0x10/0x30
> [   12.579037] fsl_enetc 0000:00:00.2: Linked as a consumer to
> 5000000.iommu
> [   12.585895] fsl_enetc 0000:00:00.2: Adding to iommu group 4
> [   12.697391] fsl_enetc 0000:00:00.2: enabling device (0400 -> 0402)
> [   12.703637] fsl_enetc 0000:00:00.2: no MAC address specified for SI0,
> using 4a:b7:31:63:e2:ea
> [   12.712874] sysfs: cannot create duplicate filename
> '/devices/platform/soc/5000000.iommu/consumer:pci:0000:00:0'
> [   12.723111] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 5.11.0-rc2-next-20210107-00018-g832f4343aa38-dirty #307
> [   12.733068] Hardware name: Kontron KBox A-230-LS (DT)
> [   12.738136] Call trace:
> [   12.740585]  dump_backtrace+0x0/0x1b8
> [   12.744263]  show_stack+0x20/0x70
> [   12.747588]  dump_stack+0xd8/0x134
> [   12.751001]  sysfs_warn_dup+0x6c/0x88
> [   12.754674]  sysfs_do_create_link_sd.isra.2+0x10c/0x110
> [   12.759918]  sysfs_create_link+0x2c/0x50
> [   12.763852]  devlink_add_symlinks+0x114/0x1e0
> [   12.768226]  device_add+0x460/0x798
> [   12.771724]  device_link_add+0x47c/0x670
> [   12.775657]  arm_smmu_probe_device+0x218/0x478
> [   12.780116]  __iommu_probe_device+0x5c/0x1c8
> [   12.784399]  iommu_probe_device+0x30/0x138
> [   12.788508]  of_iommu_configure+0x134/0x200
> [   12.792706]  of_dma_configure_id+0x110/0x290
> [   12.796992]  pci_dma_configure+0x4c/0xd8
> [   12.800929]  really_probe+0xa8/0x3c0
> [   12.804515]  driver_probe_device+0xac/0xc0
> [   12.808623]  device_driver_attach+0x7c/0x88
> [   12.812820]  __driver_attach+0x60/0xe8
> [   12.816580]  bus_for_each_dev+0x7c/0xd0
> [   12.820426]  driver_attach+0x2c/0x38
> [   12.824011]  bus_add_driver+0x194/0x1f8
> [   12.827858]  driver_register+0x6c/0x128
> [   12.831707]  __pci_register_driver+0x4c/0x58
> [   12.835991]  enetc_pf_driver_init+0x2c/0x38
> [   12.840190]  do_one_initcall+0x54/0x2d8
> [   12.844037]  kernel_init_freeable+0x200/0x26c
> [   12.848408]  kernel_init+0x1c/0x120
> [   12.851908]  ret_from_fork+0x10/0x30
> [   12.855533] fsl_enetc 0000:00:00.6: Linked as a consumer to
> 5000000.iommu
> [   12.862384] fsl_enetc 0000:00:00.6: Adding to iommu group 5
> [   12.868093] fsl_enetc 0000:00:00.6: device is disabled, skipping
> [   12.874171] initcall enetc_pf_driver_init+0x0/0x38 returned 0 after
> 1016596 usecs
> [   12.881698] calling  enetc_pci_mdio_driver_init+0x0/0x38 @ 1
> [   12.887444] sysfs: cannot create duplicate filename
> '/devices/platform/soc/5000000.iommu/consumer:pci:0000:00:0'
> [   12.897670] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 5.11.0-rc2-next-20210107-00018-g832f4343aa38-dirty #307
> [   12.907626] Hardware name: Kontron KBox A-230-LS (DT)
> [   12.912693] Call trace:
> [   12.915142]  dump_backtrace+0x0/0x1b8
> [   12.918819]  show_stack+0x20/0x70
> [   12.922143]  dump_stack+0xd8/0x134
> [   12.925555]  sysfs_warn_dup+0x6c/0x88
> [   12.929227]  sysfs_do_create_link_sd.isra.2+0x10c/0x110
> [   12.934471]  sysfs_create_link+0x2c/0x50
> [   12.938406]  devlink_add_symlinks+0x114/0x1e0
> [   12.942779]  device_add+0x460/0x798
> [   12.946276]  device_link_add+0x47c/0x670
> [   12.950209]  arm_smmu_probe_device+0x218/0x478
> [   12.954668]  __iommu_probe_device+0x5c/0x1c8
> [   12.958951]  iommu_probe_device+0x30/0x138
> [   12.963061]  of_iommu_configure+0x134/0x200
> [   12.967258]  of_dma_configure_id+0x110/0x290
> [   12.971544]  pci_dma_configure+0x4c/0xd8
> [   12.975481]  really_probe+0xa8/0x3c0
> [   12.979066]  driver_probe_device+0xac/0xc0
> [   12.983175]  device_driver_attach+0x7c/0x88
> [   12.987372]  __driver_attach+0x60/0xe8
> [   12.991132]  bus_for_each_dev+0x7c/0xd0
> [   12.994979]  driver_attach+0x2c/0x38
> [   12.998565]  bus_add_driver+0x194/0x1f8
> [   13.002412]  driver_register+0x6c/0x128
> [   13.006261]  __pci_register_driver+0x4c/0x58
> [   13.010545]  enetc_pci_mdio_driver_init+0x2c/0x38
> [   13.015266]  do_one_initcall+0x54/0x2d8
> [   13.019113]  kernel_init_freeable+0x200/0x26c
> [   13.023484]  kernel_init+0x1c/0x120
> [   13.026984]  ret_from_fork+0x10/0x30
> [   13.030585] fsl_enetc_mdio 0000:00:00.3: Linked as a consumer to
> 5000000.iommu
> [   13.037862] fsl_enetc_mdio 0000:00:00.3: Adding to iommu group 6
> [   13.149397] fsl_enetc_mdio 0000:00:00.3: enabling device (0400 ->
> 0402)
> [   13.156235] libphy: FSL PCIe IE Central MDIO Bus: probed
> [   13.167238] initcall enetc_pci_mdio_driver_init+0x0/0x38 returned 0
> after 273291 usecs
> [   13.175226] calling  hix5hd2_dev_driver_init+0x0/0x30 @ 1
> [   13.180795] initcall hix5hd2_dev_driver_init+0x0/0x30 returned 0
> after 134 usecs
> [   13.188242] calling  hns_mdio_driver_init+0x0/0x30 @ 1
> [   13.193462] initcall hns_mdio_driver_init+0x0/0x30 returned 0 after
> 54 usecs
> [   13.200546] calling  g_dsaf_driver_init+0x0/0x30 @ 1
> [   13.205592] initcall g_dsaf_driver_init+0x0/0x30 returned 0 after 54
> usecs
> [   13.212505] calling  hns_nic_dev_driver_init+0x0/0x30 @ 1
> [   13.217982] initcall hns_nic_dev_driver_init+0x0/0x30 returned 0
> after 50 usecs
> [   13.225327] calling  hclge_init+0x0/0x8c @ 1
> [   13.229617] hclge is initializing
> [   13.232951] initcall hclge_init+0x0/0x8c returned 0 after 3256 usecs
> [   13.239335] calling  hns3_init_module+0x0/0xe4 @ 1
> [   13.244148] hns3: Hisilicon Ethernet Network Driver for Hip08 Family
> - version
> [   13.251401] hns3: Copyright (c) 2017 Huawei Corporation.
> [   13.256774] initcall hns3_init_module+0x0/0xe4 returned 0 after 12329
> usecs
> [   13.263772] calling  igb_init_module+0x0/0x68 @ 1
> [   13.268499] igb: Intel(R) Gigabit Ethernet Network Driver
> [   13.273922] igb: Copyright (c) 2007-2014 Intel Corporation.
> [   13.279538] initcall igb_init_module+0x0/0x68 returned 0 after 10780
> usecs
> [   13.286448] calling  orion_mdio_driver_init+0x0/0x30 @ 1
> [   13.291847] initcall orion_mdio_driver_init+0x0/0x30 returned 0 after
> 56 usecs
> [   13.299117] calling  sky2_init_module+0x0/0x44 @ 1
> [   13.303937] sky2: driver version 1.30
> [   13.307641] initcall sky2_init_module+0x0/0x44 returned 0 after 3617
> usecs
> [   13.314553] calling  mscc_ocelot_driver_init+0x0/0x30 @ 1
> [   13.320031] initcall mscc_ocelot_driver_init+0x0/0x30 returned 0
> after 51 usecs
> [   13.327378] calling  rtl8169_pci_driver_init+0x0/0x38 @ 1
> [   13.332827] initcall rtl8169_pci_driver_init+0x0/0x38 returned 0
> after 21 usecs
> [   13.340177] calling  smc_driver_init+0x0/0x30 @ 1
> [   13.344959] initcall smc_driver_init+0x0/0x30 returned 0 after 54
> usecs
> [   13.351606] calling  smsc911x_init_module+0x0/0x30 @ 1
> [   13.356817] initcall smsc911x_init_module+0x0/0x30 returned 0 after
> 44 usecs
> [   13.363902] calling  stmmac_init+0x0/0x60 @ 1
> [   13.368290] initcall stmmac_init+0x0/0x60 returned 0 after 9 usecs
> [   13.374501] calling  netif_init+0x0/0x7c @ 1
> [   13.378793] initcall netif_init+0x0/0x7c returned -19 after 0 usecs
> [   13.385091] calling  net_failover_init+0x0/0x18 @ 1
> [   13.389992] initcall net_failover_init+0x0/0x18 returned 0 after 0
> usecs
> [   13.396726] calling  vfio_init+0x0/0x18c @ 1
> [   13.401120] VFIO - User Level meta-driver version: 0.3
> [   13.406288] initcall vfio_init+0x0/0x18c returned 0 after 5144 usecs
> [   13.412678] calling  vfio_virqfd_init+0x0/0x54 @ 1
> [   13.417574] initcall vfio_virqfd_init+0x0/0x54 returned 0 after 77
> usecs
> [   13.424321] calling  vfio_iommu_type1_init+0x0/0x2c @ 1
> [   13.429577] initcall vfio_iommu_type1_init+0x0/0x2c returned 0 after
> 0 usecs
> [   13.436662] calling  vfio_pci_init+0x0/0x198 @ 1
> [   13.441339] initcall vfio_pci_init+0x0/0x198 returned 0 after 35
> usecs
> [   13.447901] calling  usb_conn_driver_init+0x0/0x30 @ 1
> [   13.453128] initcall usb_conn_driver_init+0x0/0x30 returned 0 after
> 61 usecs
> [   13.460213] calling  dwc3_driver_init+0x0/0x30 @ 1
> [   13.465089] dwc3 3100000.usb: Linked as a consumer to 5000000.iommu
> [   13.471408] dwc3 3100000.usb: Adding to iommu group 7
> [   13.476906] dwc3 3110000.usb: Linked as a consumer to 5000000.iommu
> [   13.483222] dwc3 3110000.usb: Adding to iommu group 8
> [   13.488681] initcall dwc3_driver_init+0x0/0x30 returned 0 after 23098
> usecs
> [   13.495689] calling  dwc3_pci_driver_init+0x0/0x38 @ 1
> [   13.500894] initcall dwc3_pci_driver_init+0x0/0x38 returned 0 after
> 40 usecs
> [   13.507982] calling  dwc3_haps_driver_init+0x0/0x38 @ 1
> [   13.513253] initcall dwc3_haps_driver_init+0x0/0x38 returned 0 after
> 19 usecs
> [   13.520425] calling  dwc3_of_simple_driver_init+0x0/0x30 @ 1
> [   13.526220] initcall dwc3_of_simple_driver_init+0x0/0x30 returned 0
> after 104 usecs
> [   13.533923] calling  dwc2_platform_driver_init+0x0/0x30 @ 1
> [   13.539668] initcall dwc2_platform_driver_init+0x0/0x30 returned 0
> after 141 usecs
> [   13.547279] calling  isp1760_init+0x0/0x7c @ 1
> [   13.551977] initcall isp1760_init+0x0/0x7c returned 0 after 227 usecs
> [   13.558451] calling  ehci_hcd_init+0x0/0xa4 @ 1
> [   13.563003] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
> Driver
> [   13.569557] initcall ehci_hcd_init+0x0/0xa4 returned 0 after 6401
> usecs
> [   13.576202] calling  ehci_pci_init+0x0/0x98 @ 1
> [   13.580752] ehci-pci: EHCI PCI platform driver
> [   13.585234] initcall ehci_pci_init+0x0/0x98 returned 0 after 4377
> usecs
> [   13.591882] calling  ehci_platform_init+0x0/0x70 @ 1
> [   13.596872] ehci-platform: EHCI generic platform driver
> [   13.602187] initcall ehci_platform_init+0x0/0x70 returned 0 after
> 5189 usecs
> [   13.609270] calling  ohci_hcd_mod_init+0x0/0xac @ 1
> [   13.614169] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [   13.620384] initcall ohci_hcd_mod_init+0x0/0xac returned 0 after 6069
> usecs
> [   13.627380] calling  ohci_pci_init+0x0/0x98 @ 1
> [   13.631930] ohci-pci: OHCI PCI platform driver
> [   13.636413] initcall ohci_pci_init+0x0/0x98 returned 0 after 4378
> usecs
> [   13.643059] calling  ohci_platform_init+0x0/0x70 @ 1
> [   13.648046] ohci-platform: OHCI generic platform driver
> [   13.653352] initcall ohci_platform_init+0x0/0x70 returned 0 after
> 5181 usecs
> [   13.660439] calling  xhci_hcd_init+0x0/0x44 @ 1
> [   13.664996] initcall xhci_hcd_init+0x0/0x44 returned 0 after 4 usecs
> [   13.671381] calling  xhci_pci_init+0x0/0x78 @ 1
> [   13.675955] initcall xhci_pci_init+0x0/0x78 returned 0 after 23 usecs
> [   13.682428] calling  xhci_plat_init+0x0/0x44 @ 1
> [   13.687245] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
> [   13.692767] xhci-hcd xhci-hcd.0.auto: new USB bus registered,
> assigned bus number 1
> [   13.700634] xhci-hcd xhci-hcd.0.auto: hcc params 0x0220f66d hci
> version 0x100 quirks 0x0000000002010010
> [   13.710097] xhci-hcd xhci-hcd.0.auto: irq 29, io mem 0x03100000
> [   13.716461] hub 1-0:1.0: USB hub found
> [   13.720251] hub 1-0:1.0: 1 port detected
> [   13.724351] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
> [   13.729873] xhci-hcd xhci-hcd.0.auto: new USB bus registered,
> assigned bus number 2
> [   13.737571] xhci-hcd xhci-hcd.0.auto: Host supports USB 3.0
> SuperSpeed
> [   13.744167] usb usb2: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [   13.752548] hub 2-0:1.0: USB hub found
> [   13.756331] hub 2-0:1.0: 1 port detected
> [   13.760503] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
> [   13.766024] xhci-hcd xhci-hcd.1.auto: new USB bus registered,
> assigned bus number 3
> [   13.773885] xhci-hcd xhci-hcd.1.auto: hcc params 0x0220f66d hci
> version 0x100 quirks 0x0000000002010010
> [   13.783353] xhci-hcd xhci-hcd.1.auto: irq 30, io mem 0x03110000
> [   13.789669] hub 3-0:1.0: USB hub found
> [   13.793456] hub 3-0:1.0: 1 port detected
> [   13.797546] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
> [   13.803065] xhci-hcd xhci-hcd.1.auto: new USB bus registered,
> assigned bus number 4
> [   13.810761] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0
> SuperSpeed
> [   13.817352] usb usb4: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [   13.825776] hub 4-0:1.0: USB hub found
> [   13.829563] hub 4-0:1.0: 1 port detected
> [   13.833672] initcall xhci_plat_init+0x0/0x44 returned 0 after 143170
> usecs
> [   13.840591] calling  usb_storage_driver_init+0x0/0x54 @ 1
> [   13.846087] usbcore: registered new interface driver usb-storage
> [   13.852122] initcall usb_storage_driver_init+0x0/0x54 returned 0
> after 5955 usecs
> [   13.859643] calling  usb3503_init+0x0/0x74 @ 1
> [   13.864255] initcall usb3503_init+0x0/0x74 returned 0 after 137 usecs
> [   13.870730] calling  musb_driver_init+0x0/0x34 @ 1
> [   13.875575] initcall musb_driver_init+0x0/0x34 returned 0 after 31
> usecs
> [   13.882308] calling  ci_hdrc_platform_register+0x0/0x38 @ 1
> [   13.887946] initcall ci_hdrc_platform_register+0x0/0x38 returned 0
> after 32 usecs
> [   13.895466] calling  ci_hdrc_usb2_driver_init+0x0/0x30 @ 1
> [   13.901039] initcall ci_hdrc_usb2_driver_init+0x0/0x30 returned 0
> after 59 usecs
> [   13.908479] calling  ci_hdrc_msm_driver_init+0x0/0x30 @ 1
> [   13.913950] initcall ci_hdrc_msm_driver_init+0x0/0x30 returned 0
> after 45 usecs
> [   13.921295] calling  ci_hdrc_pci_driver_init+0x0/0x38 @ 1
> [   13.926762] initcall ci_hdrc_pci_driver_init+0x0/0x38 returned 0
> after 41 usecs
> [   13.934107] calling  ci_hdrc_imx_driver_init+0x0/0x30 @ 1
> [   13.939642] initcall ci_hdrc_imx_driver_init+0x0/0x30 returned 0
> after 103 usecs
> [   13.947075] calling  usbmisc_imx_driver_init+0x0/0x30 @ 1
> [   13.952611] initcall usbmisc_imx_driver_init+0x0/0x30 returned 0
> after 111 usecs
> [   13.960044] calling  tegra_usb_driver_init+0x0/0x30 @ 1
> [   13.965369] initcall tegra_usb_driver_init+0x0/0x30 returned 0 after
> 74 usecs
> [   13.972546] calling  gadget_cfs_init+0x0/0x40 @ 1
> [   13.977315] initcall gadget_cfs_init+0x0/0x40 returned 0 after 42
> usecs
> [   13.983963] calling  udc_plat_driver_init+0x0/0x30 @ 1
> [   13.989188] initcall udc_plat_driver_init+0x0/0x30 returned 0 after
> 61 usecs
> [   13.996271] calling  bdc_driver_init+0x0/0x30 @ 1
> [   14.001050] initcall bdc_driver_init+0x0/0x30 returned 0 after 52
> usecs
> [   14.007699] calling  bdc_pci_driver_init+0x0/0x38 @ 1
> [   14.012813] initcall bdc_pci_driver_init+0x0/0x38 returned 0 after 30
> usecs
> [   14.019810] calling  acmmod_init+0x0/0x2c @ 1
> [   14.024187] initcall acmmod_init+0x0/0x2c returned 0 after 0 usecs
> [   14.030399] calling  userial_init+0x0/0x170 @ 1
> [   14.034962] initcall userial_init+0x0/0x170 returned 0 after 7 usecs
> [   14.041349] calling  gsermod_init+0x0/0x2c @ 1
> [   14.045815] initcall gsermod_init+0x0/0x2c returned 0 after 0 usecs
> [   14.052111] calling  obexmod_init+0x0/0x2c @ 1
> [   14.056575] initcall obexmod_init+0x0/0x2c returned 0 after 0 usecs
> [   14.062870] calling  ecmmod_init+0x0/0x2c @ 1
> [   14.067254] initcall ecmmod_init+0x0/0x2c returned 0 after 0 usecs
> [   14.073463] calling  gethmod_init+0x0/0x2c @ 1
> [   14.077926] initcall gethmod_init+0x0/0x2c returned 0 after 0 usecs
> [   14.084223] calling  rndismod_init+0x0/0x2c @ 1
> [   14.088774] initcall rndismod_init+0x0/0x2c returned 0 after 0 usecs
> [   14.095160] calling  mass_storagemod_init+0x0/0x30 @ 1
> [   14.100323] initcall mass_storagemod_init+0x0/0x30 returned 0 after 0
> usecs
> [   14.107318] calling  eth_driver_init+0x0/0x2c @ 1
> [   14.112045] udc-core: couldn't find an available UDC - added
> [g_ether] to list of pending drivers
> [   14.120957] initcall eth_driver_init+0x0/0x2c returned 0 after 8704
> usecs
> [   14.127776] calling  msg_driver_init+0x0/0x2c @ 1
> [   14.132502] udc-core: couldn't find an available UDC - added
> [g_mass_storage] to list of pending drivers
> [   14.137389] usb 3-1: new high-speed USB device number 2 using
> xhci-hcd
> [   14.142023] initcall msg_driver_init+0x0/0x2c returned 0 after 9298
> usecs
> [   14.155403] calling  init+0x0/0xd4 @ 1
> [   14.159195] udc-core: couldn't find an available UDC - added
> [g_serial] to list of pending drivers
> [   14.168201] initcall init+0x0/0xd4 returned 0 after 8795 usecs
> [   14.174061] calling  ambakmi_driver_init+0x0/0x2c @ 1
> [   14.179154] initcall ambakmi_driver_init+0x0/0x2c returned 0 after 17
> usecs
> [   14.186149] calling  input_leds_init+0x0/0x2c @ 1
> [   14.190875] initcall input_leds_init+0x0/0x2c returned 0 after 1
> usecs
> [   14.197432] calling  evdev_init+0x0/0x2c @ 1
> [   14.201722] initcall evdev_init+0x0/0x2c returned 0 after 0 usecs
> [   14.207843] calling  atkbd_init+0x0/0x48 @ 1
> [   14.212173] initcall atkbd_init+0x0/0x48 returned 0 after 36 usecs
> [   14.218391] calling  cros_ec_keyb_driver_init+0x0/0x30 @ 1
> [   14.223989] initcall cros_ec_keyb_driver_init+0x0/0x30 returned 0
> after 81 usecs
> [   14.231422] calling  gpio_keys_polled_driver_init+0x0/0x30 @ 1
> [   14.237444] input: buttons1 as
> /devices/platform/buttons1/input/input0
> [   14.244743] initcall gpio_keys_polled_driver_init+0x0/0x30 returned 0
> after 7285 usecs
> [   14.252705] calling  psmouse_init+0x0/0xa4 @ 1
> [   14.257229] initcall psmouse_init+0x0/0xa4 returned 0 after 54 usecs
> [   14.263619] calling  xenkbd_init+0x0/0x58 @ 1
> [   14.267997] initcall xenkbd_init+0x0/0x58 returned -19 after 0 usecs
> [   14.274381] calling  cros_ec_rtc_driver_init+0x0/0x30 @ 1
> [   14.279849] initcall cros_ec_rtc_driver_init+0x0/0x30 returned 0
> after 38 usecs
> [   14.287202] calling  ds323x_init+0x0/0x88 @ 1
> [   14.291625] initcall ds323x_init+0x0/0x88 returned 0 after 37 usecs
> [   14.297927] calling  efi_rtc_driver_init+0x0/0x38 @ 1
> [   14.303041] initcall efi_rtc_driver_init+0x0/0x38 returned -19 after
> 38 usecs
> [   14.310233] calling  ftm_alarm_init+0x0/0x30 @ 1
> [   14.315327] ftm-alarm 2800000.timer: registered as rtc1
> [   14.320642] initcall ftm_alarm_init+0x0/0x30 returned 0 after 5615
> usecs
> [   14.327380] calling  max77686_rtc_driver_init+0x0/0x30 @ 1
> [   14.332948] initcall max77686_rtc_driver_init+0x0/0x30 returned 0
> after 48 usecs
> [   14.340391] calling  pl031_driver_init+0x0/0x2c @ 1
> [   14.345307] initcall pl031_driver_init+0x0/0x2c returned 0 after 13
> usecs
> [   14.352128] calling  rv8803_driver_init+0x0/0x30 @ 1
> [   14.357749] rtc-rv8803 0-0032: Voltage low, temperature compensation
> stopped.
> [   14.364929] rtc-rv8803 0-0032: Voltage low, data loss detected.
> [   14.370957] hub 3-1:1.0: USB hub found
> [   14.371955] rtc-rv8803 0-0032: Voltage low, data is invalid.
> [   14.380438] hub 3-1:1.0: 7 ports detected
> [   14.384512] rtc-rv8803 0-0032: registered as rtc0
> [   14.389829] rtc-rv8803 0-0032: Voltage low, data is invalid.
> [   14.395528] rtc-rv8803 0-0032: hctosys: unable to read the hardware
> clock
> [   14.402488] initcall rv8803_driver_init+0x0/0x30 returned 0 after
> 44308 usecs
> [   14.409663] calling  s5m_rtc_driver_init+0x0/0x30 @ 1
> [   14.414803] initcall s5m_rtc_driver_init+0x0/0x30 returned 0 after 62
> usecs
> [   14.421800] calling  i2c_dev_init+0x0/0xf0 @ 1
> [   14.426270] i2c /dev entries driver
> [   14.429976] initcall i2c_dev_init+0x0/0xf0 returned 0 after 3618
> usecs
> [   14.436552] calling  rk3x_i2c_driver_init+0x0/0x30 @ 1
> [   14.441857] initcall rk3x_i2c_driver_init+0x0/0x30 returned 0 after
> 128 usecs
> [   14.449038] calling  ec_i2c_tunnel_driver_init+0x0/0x30 @ 1
> [   14.454718] initcall ec_i2c_tunnel_driver_init+0x0/0x30 returned 0
> after 68 usecs
> [   14.462243] calling  pca954x_driver_init+0x0/0x30 @ 1
> [   14.467354] initcall pca954x_driver_init+0x0/0x30 returned 0 after 31
> usecs
> [   14.474351] calling  vexpress_reset_driver_init+0x0/0x30 @ 1
> [   14.480100] initcall vexpress_reset_driver_init+0x0/0x30 returned 0
> after 61 usecs
> [   14.487708] calling  xgene_reboot_init+0x0/0x30 @ 1
> [   14.492663] initcall xgene_reboot_init+0x0/0x30 returned 0 after 49
> usecs
> [   14.499486] calling  syscon_reboot_driver_init+0x0/0x30 @ 1
> [   14.505235] initcall syscon_reboot_driver_init+0x0/0x30 returned 0
> after 146 usecs
> [   14.512847] calling  syscon_reboot_mode_driver_init+0x0/0x30 @ 1
> [   14.518936] initcall syscon_reboot_mode_driver_init+0x0/0x30 returned
> 0 after 48 usecs
> [   14.526896] calling  bq27xxx_battery_i2c_driver_init+0x0/0x30 @ 1
> [   14.533061] initcall bq27xxx_battery_i2c_driver_init+0x0/0x30
> returned 0 after 40 usecs
> [   14.541105] calling  scpi_hwmon_platdrv_init+0x0/0x30 @ 1
> [   14.546585] initcall scpi_hwmon_platdrv_init+0x0/0x30 returned 0
> after 54 usecs
> [   14.553931] calling  sl28cpld_hwmon_driver_init+0x0/0x30 @ 1
> [   14.559861] initcall sl28cpld_hwmon_driver_init+0x0/0x30 returned 0
> after 218 usecs
> [   14.567580] calling  sp805_wdt_driver_init+0x0/0x2c @ 1
> [   14.573041] sp805-wdt c000000.watchdog: registration successful
> [   14.579095] sp805-wdt c010000.watchdog: registration successful
> [   14.585073] initcall sp805_wdt_driver_init+0x0/0x2c returned 0 after
> 11935 usecs
> [   14.592509] calling  dw_wdt_driver_init+0x0/0x30 @ 1
> [   14.597568] initcall dw_wdt_driver_init+0x0/0x30 returned 0 after 69
> usecs
> [   14.604477] calling  imx2_wdt_driver_init+0x0/0x38 @ 1
> [   14.609696] initcall imx2_wdt_driver_init+0x0/0x38 returned -19 after
> 55 usecs
> [   14.616956] calling  sl28cpld_wdt_driver_init+0x0/0x30 @ 1
> [   14.624243] sl28cpld-wdt 2000000.i2c:sl28cpld@4a:watchdog@4: initial
> timeout 6 sec
> [   14.631891] initcall sl28cpld_wdt_driver_init+0x0/0x30 returned 0
> after 9202 usecs
> [   14.639521] calling  dt_cpufreq_platdrv_init+0x0/0x30 @ 1
> [   14.644988] initcall dt_cpufreq_platdrv_init+0x0/0x30 returned 0
> after 39 usecs
> [   14.652334] calling  scpi_cpufreq_platdrv_init+0x0/0x30 @ 1
> [   14.657965] initcall scpi_cpufreq_platdrv_init+0x0/0x30 returned 0
> after 30 usecs
> [   14.665486] calling  arm_idle_init+0x0/0x190 @ 1
> [   14.670141] initcall arm_idle_init+0x0/0x190 returned -95 after 14
> usecs
> [   14.676896] calling  psci_idle_init+0x0/0xc0 @ 1
> [   14.681725] initcall psci_idle_init+0x0/0xc0 returned 0 after 176
> usecs
> [   14.688378] calling  mmc_pwrseq_simple_driver_init+0x0/0x30 @ 1
> [   14.694388] initcall mmc_pwrseq_simple_driver_init+0x0/0x30 returned
> 0 after 59 usecs
> [   14.702279] calling  mmc_pwrseq_emmc_driver_init+0x0/0x30 @ 1
> [   14.708115] initcall mmc_pwrseq_emmc_driver_init+0x0/0x30 returned 0
> after 50 usecs
> [   14.715811] calling  mmc_blk_init+0x0/0x124 @ 1
> [   14.720394] initcall mmc_blk_init+0x0/0x124 returned 0 after 29 usecs
> [   14.726869] calling  mmci_driver_init+0x0/0x30 @ 1
> [   14.731699] initcall mmci_driver_init+0x0/0x30 returned 0 after 15
> usecs
> [   14.738434] calling  sdhci_drv_init+0x0/0x3c @ 1
> [   14.743075] sdhci: Secure Digital Host Controller Interface driver
> [   14.749281] sdhci: Copyright(c) Pierre Ossman
> [   14.753656] initcall sdhci_drv_init+0x0/0x3c returned 0 after 10332
> usecs
> [   14.760477] calling  sdhci_acpi_driver_init+0x0/0x30 @ 1
> [   14.765390] usb 3-1.6: new full-speed USB device number 3 using
> xhci-hcd
> [   14.765849] initcall sdhci_acpi_driver_init+0x0/0x30 returned 0 after
> 32 usecs
> [   14.779797] calling  sdhci_f_sdh30_driver_init+0x0/0x30 @ 1
> [   14.785479] initcall sdhci_f_sdh30_driver_init+0x0/0x30 returned 0
> after 61 usecs
> [   14.793007] calling  mmc_spi_driver_init+0x0/0x30 @ 1
> [   14.798099] initcall mmc_spi_driver_init+0x0/0x30 returned 0 after 14
> usecs
> [   14.805095] calling  dw_mci_init+0x0/0x30 @ 1
> [   14.809489] Synopsys Designware Multimedia Card Interface Driver
> [   14.815531] initcall dw_mci_init+0x0/0x30 returned 0 after 5900 usecs
> [   14.822003] calling  dw_mci_pltfm_driver_init+0x0/0x30 @ 1
> [   14.827585] initcall dw_mci_pltfm_driver_init+0x0/0x30 returned 0
> after 64 usecs
> [   14.835019] calling  dw_mci_exynos_pltfm_driver_init+0x0/0x30 @ 1
> [   14.841219] initcall dw_mci_exynos_pltfm_driver_init+0x0/0x30
> returned 0 after 76 usecs
> [   14.849280] calling  dw_mci_hi3798cv200_driver_init+0x0/0x30 @ 1
> [   14.855371] initcall dw_mci_hi3798cv200_driver_init+0x0/0x30 returned
> 0 after 49 usecs
> [   14.863332] calling  dw_mci_k3_pltfm_driver_init+0x0/0x30 @ 1
> [   14.869168] initcall dw_mci_k3_pltfm_driver_init+0x0/0x30 returned 0
> after 60 usecs
> [   14.876870] calling  sdhci_pltfm_drv_init+0x0/0x30 @ 1
> [   14.882040] sdhci-pltfm: SDHCI platform and OF driver helper
> [   14.887726] initcall sdhci_pltfm_drv_init+0x0/0x30 returned 0 after
> 5553 usecs
> [   14.894985] calling  sdhci_cdns_driver_init+0x0/0x30 @ 1
> [   14.900382] initcall sdhci_cdns_driver_init+0x0/0x30 returned 0 after
> 58 usecs
> [   14.907660] calling  sdhci_arasan_driver_init+0x0/0x30 @ 1
> [   14.913318] initcall sdhci_arasan_driver_init+0x0/0x30 returned 0
> after 123 usecs
> [   14.920857] calling  sdhci_esdhc_driver_init+0x0/0x30 @ 1
> [   14.926397] sdhci-esdhc 2140000.mmc: Linked as a consumer to
> 5000000.iommu
> [   14.926411] initcall sdhci_esdhc_driver_init+0x0/0x30 returned 0
> after 109 usecs
> [   14.933338] sdhci-esdhc 2150000.mmc: Linked as a consumer to
> 5000000.iommu
> [   14.940751] calling  sdhci_xenon_driver_init+0x0/0x30 @ 1
> [   14.947703] sdhci-esdhc 2140000.mmc: Adding to iommu group 9
> [   14.953164] initcall sdhci_xenon_driver_init+0x0/0x30 returned 0
> after 65 usecs
> [   14.958801] sdhci-esdhc 2150000.mmc: Adding to iommu group 10
> [   14.966117] calling  gpio_led_driver_init+0x0/0x30 @ 1
> [   14.981783] initcall gpio_led_driver_init+0x0/0x30 returned 0 after
> 4633 usecs
> [   14.989058] calling  led_pwm_driver_init+0x0/0x30 @ 1
> [   14.994209] initcall led_pwm_driver_init+0x0/0x30 returned 0 after 64
> usecs
> [   14.997942] mmc1: SDHCI controller on 2140000.mmc [2140000.mmc] using
> ADMA
> [   15.001206] calling  syscon_led_driver_init+0x0/0x30 @ 1
> [   15.008197] mmc0: SDHCI controller on 2150000.mmc [2150000.mmc] using
> ADMA
> [   15.013508] initcall syscon_led_driver_init+0x0/0x30 returned 0 after
> 53 usecs
> [   15.027647] calling  ledtrig_disk_init+0x0/0x74 @ 1
> [   15.032593] initcall ledtrig_disk_init+0x0/0x74 returned 0 after 34
> usecs
> [   15.039427] calling  heartbeat_trig_init+0x0/0x5c @ 1
> [   15.044563] initcall heartbeat_trig_init+0x0/0x5c returned 0 after 40
> usecs
> [   15.051597] calling  ledtrig_cpu_init+0x0/0x12c @ 1
> [   15.056565] ledtrig-cpu: registered to indicate activity on CPUs
> [   15.062636] initcall ledtrig_cpu_init+0x0/0x12c returned 0 after 5985
> usecs
> [   15.069668] calling  defon_led_trigger_init+0x0/0x2c @ 1
> [   15.075078] initcall defon_led_trigger_init+0x0/0x2c returned 0 after
> 62 usecs
> [   15.082390] calling  ledtrig_panic_init+0x0/0x5c @ 1
> [   15.087401] initcall ledtrig_panic_init+0x0/0x5c returned 0 after 9
> usecs
> [   15.094241] calling  scpi_driver_init+0x0/0x30 @ 1
> [   15.099152] initcall scpi_driver_init+0x0/0x30 returned 0 after 90
> usecs
> [   15.105892] calling  scpi_power_domain_driver_init+0x0/0x30 @ 1
> [   15.111897] initcall scpi_power_domain_driver_init+0x0/0x30 returned
> 0 after 49 usecs
> [   15.119768] calling  esrt_sysfs_init+0x0/0x2b0 @ 1
> [   15.124583] initcall esrt_sysfs_init+0x0/0x2b0 returned -38 after 0
> usecs
> [   15.131414] calling  efivars_pstore_init+0x0/0xd8 @ 1
> [   15.136496] initcall efivars_pstore_init+0x0/0xd8 returned 0 after 0
> usecs
> [   15.143411] calling  efi_capsule_loader_init+0x0/0x68 @ 1
> [   15.148837] initcall efi_capsule_loader_init+0x0/0x68 returned -19
> after 0 usecs
> [   15.156274] calling  smccc_soc_init+0x0/0x27c @ 1
> [   15.161003] initcall smccc_soc_init+0x0/0x27c returned 0 after 0
> usecs
> [   15.167565] calling  meson_crypto_driver_init+0x0/0x30 @ 1
> [   15.173138] initcall meson_crypto_driver_init+0x0/0x30 returned 0
> after 53 usecs
> [   15.180581] calling  hid_init+0x0/0x6c @ 1
> [   15.184729] initcall hid_init+0x0/0x6c returned 0 after 24 usecs
> [   15.190778] calling  hid_generic_init+0x0/0x38 @ 1
> [   15.195632] initcall hid_generic_init+0x0/0x38 returned 0 after 33
> usecs
> [   15.202372] calling  a4_driver_init+0x0/0x38 @ 1
> [   15.207061] initcall a4_driver_init+0x0/0x38 returned 0 after 40
> usecs
> [   15.213636] calling  apple_driver_init+0x0/0x38 @ 1
> [   15.218569] initcall apple_driver_init+0x0/0x38 returned 0 after 22
> usecs
> [   15.225399] calling  belkin_driver_init+0x0/0x38 @ 1
> [   15.230413] initcall belkin_driver_init+0x0/0x38 returned 0 after 18
> usecs
> [   15.237331] calling  ch_driver_init+0x0/0x38 @ 1
> [   15.241992] initcall ch_driver_init+0x0/0x38 returned 0 after 16
> usecs
> [   15.248577] calling  ch_driver_init+0x0/0x38 @ 1
> [   15.253221] random: fast init done
> [   15.256676] initcall ch_driver_init+0x0/0x38 returned 0 after 17
> usecs
> [   15.263243] calling  cp_driver_init+0x0/0x38 @ 1
> [   15.267904] initcall cp_driver_init+0x0/0x38 returned 0 after 16
> usecs
> [   15.274471] calling  ez_driver_init+0x0/0x38 @ 1
> [   15.279131] initcall ez_driver_init+0x0/0x38 returned 0 after 16
> usecs
> [   15.285698] calling  ite_driver_init+0x0/0x38 @ 1
> [   15.290447] initcall ite_driver_init+0x0/0x38 returned 0 after 16
> usecs
> [   15.297100] calling  ks_driver_init+0x0/0x38 @ 1
> [   15.301762] initcall ks_driver_init+0x0/0x38 returned 0 after 16
> usecs
> [   15.308327] calling  lg_driver_init+0x0/0x38 @ 1
> [   15.312995] initcall lg_driver_init+0x0/0x38 returned 0 after 20
> usecs
> [   15.319561] calling  lg_g15_driver_init+0x0/0x38 @ 1
> [   15.324579] initcall lg_g15_driver_init+0x0/0x38 returned 0 after 23
> usecs
> [   15.331498] calling  ms_driver_init+0x0/0x38 @ 1
> [   15.336167] initcall ms_driver_init+0x0/0x38 returned 0 after 18
> usecs
> [   15.342738] calling  mr_driver_init+0x0/0x38 @ 1
> [   15.347412] initcall mr_driver_init+0x0/0x38 returned 0 after 28
> usecs
> [   15.353980] mmc0: new HS400 MMC card at address 0001
> [   15.353980] calling  redragon_driver_init+0x0/0x38 @ 1
> [   15.359351] mmcblk0: mmc0:0001 S0J58X 29.6 GiB
> [   15.364165] initcall redragon_driver_init+0x0/0x38 returned 0 after
> 34 usecs
> [   15.368912] mmcblk0boot0: mmc0:0001 S0J58X partition 1 31.5 MiB
> [   15.375772] calling  hid_init+0x0/0x84 @ 1
> [   15.381932] mmcblk0boot1: mmc0:0001 S0J58X partition 2 31.5 MiB
> [   15.387233] hid-generic 0003:064F:2AF9.0001: device has no listeners,
> quitting
> [   15.391857] mmcblk0rpmb: mmc0:0001 S0J58X partition 3 4.00 MiB,
> chardev (240:0)
> [   15.399171] usbcore: registered new interface driver usbhid
> [   15.412063] usbhid: USB HID core driver
> [   15.412075]  mmcblk0: p1 p2
> [   15.415923] initcall hid_init+0x0/0x84 returned 0 after 29401 usecs
> [   15.425040] calling  cros_ec_driver_init+0x0/0x30 @ 1
> [   15.430162] initcall cros_ec_driver_init+0x0/0x30 returned 0 after 39
> usecs
> [   15.437164] calling  cros_ec_driver_spi_init+0x0/0x30 @ 1
> [   15.442605] initcall cros_ec_driver_spi_init+0x0/0x30 returned 0
> after 16 usecs
> [   15.449950] calling  cros_ec_chardev_driver_init+0x0/0x30 @ 1
> [   15.455824] initcall cros_ec_chardev_driver_init+0x0/0x30 returned 0
> after 98 usecs
> [   15.463519] calling  cros_ec_lightbar_driver_init+0x0/0x30 @ 1
> [   15.469413] initcall cros_ec_lightbar_driver_init+0x0/0x30 returned 0
> after 31 usecs
> [   15.477195] calling  cros_ec_vbc_driver_init+0x0/0x30 @ 1
> [   15.482656] initcall cros_ec_vbc_driver_init+0x0/0x30 returned 0
> after 36 usecs
> [   15.490002] calling  cros_ec_debugfs_driver_init+0x0/0x30 @ 1
> [   15.495811] initcall cros_ec_debugfs_driver_init+0x0/0x30 returned 0
> after 32 usecs
> [   15.503506] calling  cros_ec_sensorhub_driver_init+0x0/0x30 @ 1
> [   15.509486] initcall cros_ec_sensorhub_driver_init+0x0/0x30 returned
> 0 after 31 usecs
> [   15.517355] calling  cros_ec_sysfs_driver_init+0x0/0x34 @ 1
> [   15.522986] initcall cros_ec_sysfs_driver_init+0x0/0x34 returned 0
> after 31 usecs
> [   15.530506] calling  cros_usbpd_notify_init+0x0/0x50 @ 1
> [   15.535914] initcall cros_usbpd_notify_init+0x0/0x50 returned 0 after
> 62 usecs
> [   15.543177] calling  arm_mhu_driver_init+0x0/0x2c @ 1
> [   15.548267] initcall arm_mhu_driver_init+0x0/0x2c returned 0 after 13
> usecs
> [   15.555266] calling  arm_mhu_db_driver_init+0x0/0x2c @ 1
> [   15.560615] initcall arm_mhu_db_driver_init+0x0/0x2c returned 0 after
> 10 usecs
> [   15.567873] calling  platform_mhu_driver_init+0x0/0x30 @ 1
> [   15.573454] initcall platform_mhu_driver_init+0x0/0x30 returned 0
> after 67 usecs
> [   15.580887] calling  qcom_glink_ssr_driver_init+0x0/0x34 @ 1
> [   15.586584] initcall qcom_glink_ssr_driver_init+0x0/0x34 returned 0
> after 10 usecs
> [   15.594191] calling  extcon_class_init+0x0/0x38 @ 1
> [   15.599101] initcall extcon_class_init+0x0/0x38 returned 0 after 9
> usecs
> [   15.605834] calling  usb_extcon_driver_init+0x0/0x30 @ 1
> [   15.611222] initcall usb_extcon_driver_init+0x0/0x30 returned 0 after
> 48 usecs
> [   15.618483] calling  extcon_cros_ec_driver_init+0x0/0x30 @ 1
> [   15.624222] initcall extcon_cros_ec_driver_init+0x0/0x30 returned 0
> after 51 usecs
> [   15.631829] calling  hisi_l3c_pmu_module_init+0x0/0x98 @ 1
> [   15.637381] initcall hisi_l3c_pmu_module_init+0x0/0x98 returned 0
> after 38 usecs
> [   15.644820] calling  hisi_hha_pmu_module_init+0x0/0x98 @ 1
> [   15.650364] initcall hisi_hha_pmu_module_init+0x0/0x98 returned 0
> after 31 usecs
> [   15.657797] calling  hisi_ddrc_pmu_module_init+0x0/0x98 @ 1
> [   15.663427] initcall hisi_ddrc_pmu_module_init+0x0/0x98 returned 0
> after 30 usecs
> [   15.670947] calling  optee_driver_init+0x0/0x30 @ 1
> [   15.675897] initcall optee_driver_init+0x0/0x30 returned 0 after 48
> usecs
> [   15.682722] calling  alsa_timer_init+0x0/0x23c @ 1
> [   15.687641] initcall alsa_timer_init+0x0/0x23c returned 0 after 102
> usecs
> [   15.694466] calling  alsa_pcm_init+0x0/0x8c @ 1
> [   15.699022] initcall alsa_pcm_init+0x0/0x8c returned 0 after 3 usecs
> [   15.705405] calling  snd_soc_init+0x0/0x98 @ 1
> [   15.710116] initcall snd_soc_init+0x0/0x98 returned 0 after 240 usecs
> [   15.716591] calling  wm8904_i2c_driver_init+0x0/0x30 @ 1
> [   15.721961] initcall wm8904_i2c_driver_init+0x0/0x30 returned 0 after
> 32 usecs
> [   15.729219] calling  asoc_simple_card_init+0x0/0x30 @ 1
> [   15.734532] initcall asoc_simple_card_init+0x0/0x30 returned 0 after
> 62 usecs
> [   15.741706] calling  fsl_sai_driver_init+0x0/0x30 @ 1
> [   15.746868] initcall fsl_sai_driver_init+0x0/0x30 returned 0 after 84
> usecs
> [   15.753863] calling  sock_diag_init+0x0/0x54 @ 1
> [   15.758524] initcall sock_diag_init+0x0/0x54 returned 0 after 22
> usecs
> [   15.765083] calling  init_net_drop_monitor+0x0/0x13c @ 1
> [   15.770419] drop_monitor: Initializing network drop monitor service
> [   15.776737] initcall init_net_drop_monitor+0x0/0x13c returned 0 after
> 6169 usecs
> [   15.784170] calling  failover_init+0x0/0x34 @ 1
> [   15.788722] initcall failover_init+0x0/0x34 returned 0 after 1 usecs
> [   15.795106] calling  llc_init+0x0/0x44 @ 1
> [   15.799226] initcall llc_init+0x0/0x44 returned 0 after 0 usecs
> [   15.805179] calling  snap_init+0x0/0x54 @ 1
> [   15.809385] initcall snap_init+0x0/0x54 returned 0 after 1 usecs
> [   15.815420] calling  gre_offload_init+0x0/0x68 @ 1
> [   15.820235] initcall gre_offload_init+0x0/0x68 returned 0 after 1
> usecs
> [   15.826881] calling  sysctl_ipv4_init+0x0/0x70 @ 1
> [   15.831766] initcall sysctl_ipv4_init+0x0/0x70 returned 0 after 69
> usecs
> [   15.838523] calling  inet_diag_init+0x0/0xb0 @ 1
> [   15.843168] initcall inet_diag_init+0x0/0xb0 returned 0 after 2 usecs
> [   15.849641] calling  tcp_diag_init+0x0/0x2c @ 1
> [   15.854195] initcall tcp_diag_init+0x0/0x2c returned 0 after 0 usecs
> [   15.860580] calling  cubictcp_register+0x0/0x70 @ 1
> [   15.865486] initcall cubictcp_register+0x0/0x70 returned 0 after 0
> usecs
> [   15.872221] calling  inet6_init+0x0/0x350 @ 1
> [   15.876821] NET: Registered protocol family 10
> [   15.881850] Segment Routing with IPv6
> [   15.885573] initcall inet6_init+0x0/0x350 returned 0 after 8762 usecs
> [   15.892071] calling  packet_init+0x0/0xa4 @ 1
> [   15.896455] NET: Registered protocol family 17
> [   15.900921] initcall packet_init+0x0/0xa4 returned 0 after 4362 usecs
> [   15.907394] calling  br_init+0x0/0x100 @ 1
> [   15.911535] bridge: filtering via arp/ip/ip6tables is no longer
> available by default. Update your scripts to load br_netfilter if you
> need this.
> [   15.924550] initcall br_init+0x0/0x100 returned 0 after 12730 usecs
> [   15.930850] calling  dsa_init_module+0x0/0xc0 @ 1
> [   15.935659] initcall dsa_init_module+0x0/0xc0 returned 0 after 72
> usecs
> [   15.942320] calling  dsa_tag_driver_module_init+0x0/0x38 @ 1
> [   15.948020] initcall dsa_tag_driver_module_init+0x0/0x38 returned 0
> after 6 usecs
> [   15.955543] calling  can_init+0x0/0xdc @ 1
> [   15.959661] can: controller area network core
> [   15.964072] NET: Registered protocol family 29
> [   15.968537] initcall can_init+0x0/0xdc returned 0 after 8668 usecs
> [   15.974749] calling  raw_module_init+0x0/0x58 @ 1
> [   15.979477] can: raw protocol
> [   15.982455] initcall raw_module_init+0x0/0x58 returned 0 after 2908
> usecs
> [   15.989276] calling  bcm_module_init+0x0/0x6c @ 1
> [   15.994009] can: broadcast manager protocol
> [   15.998212] initcall bcm_module_init+0x0/0x6c returned 0 after 4105
> usecs
> [   16.005035] calling  cgw_module_init+0x0/0x174 @ 1
> [   16.009849] can: netlink gateway - max_hops=1
> [   16.014277] initcall cgw_module_init+0x0/0x174 returned 0 after 4324
> usecs
> [   16.021190] calling  init_rpcsec_gss+0x0/0x90 @ 1
> [   16.025939] initcall init_rpcsec_gss+0x0/0x90 returned 0 after 20
> usecs
> [   16.032588] calling  init_p9+0x0/0x4c @ 1
> [   16.036672] 9pnet: Installing 9P2000 support
> [   16.040962] initcall init_p9+0x0/0x4c returned 0 after 4242 usecs
> [   16.047086] calling  p9_virtio_init+0x0/0x68 @ 1
> [   16.051746] initcall p9_virtio_init+0x0/0x68 returned 0 after 19
> usecs
> [   16.058310] calling  init_dns_resolver+0x0/0x7fac @ 1
> [   16.063398] Key type dns_resolver registered
> [   16.067688] initcall init_dns_resolver+0x0/0x7fac returned 0 after
> 4199 usecs
> [   16.074918] calling  xen_pm_init+0x0/0x100 @ 1
> [   16.079388] initcall xen_pm_init+0x0/0x100 returned -19 after 0 usecs
> [   16.085860] calling  init_oops_id+0x0/0x68 @ 1
> [   16.090331] initcall init_oops_id+0x0/0x68 returned 0 after 1 usecs
> [   16.096630] calling  reboot_ksysfs_init+0x0/0x6c @ 1
> [   16.101625] initcall reboot_ksysfs_init+0x0/0x6c returned 0 after 6
> usecs
> [   16.108446] calling  cpu_latency_qos_init+0x0/0x60 @ 1
> [   16.113693] initcall cpu_latency_qos_init+0x0/0x60 returned 0 after
> 81 usecs
> [   16.120781] calling  pm_debugfs_init+0x0/0x44 @ 1
> [   16.125518] initcall pm_debugfs_init+0x0/0x44 returned 0 after 9
> usecs
> [   16.132077] calling  printk_late_init+0x0/0x154 @ 1
> [   16.136980] initcall printk_late_init+0x0/0x154 returned 0 after 2
> usecs
> [   16.143714] calling  init_srcu_module_notifier+0x0/0x50 @ 1
> [   16.149316] initcall init_srcu_module_notifier+0x0/0x50 returned 0
> after 1 usecs
> [   16.156748] calling  swiotlb_create_debugfs+0x0/0x78 @ 1
> [   16.162097] initcall swiotlb_create_debugfs+0x0/0x78 returned 0 after
> 11 usecs
> [   16.169356] calling  tk_debug_sleep_time_init+0x0/0x44 @ 1
> [   16.174873] initcall tk_debug_sleep_time_init+0x0/0x44 returned 0
> after 4 usecs
> [   16.182223] calling  taskstats_init+0x0/0x5c @ 1
> [   16.186879] registered taskstats version 1
> [   16.190993] initcall taskstats_init+0x0/0x5c returned 0 after 4031
> usecs
> [   16.197727] calling  init_trampolines+0x0/0x34 @ 1
> [   16.202543] initcall init_trampolines+0x0/0x34 returned 0 after 2
> usecs
> [   16.209188] calling  load_system_certificate_list+0x0/0x12c @ 1
> [   16.215135] Loading compiled-in X.509 certificates
> [   16.219947] initcall load_system_certificate_list+0x0/0x12c returned
> 0 after 4698 usecs
> [   16.227990] calling  fault_around_debugfs+0x0/0x44 @ 1
> [   16.233157] initcall fault_around_debugfs+0x0/0x44 returned 0 after 5
> usecs
> [   16.240153] calling  max_swapfiles_check+0x0/0x18 @ 1
> [   16.245231] initcall max_swapfiles_check+0x0/0x18 returned 0 after 0
> usecs
> [   16.252140] calling  split_huge_pages_debugfs+0x0/0x48 @ 1
> [   16.257659] initcall split_huge_pages_debugfs+0x0/0x48 returned 0
> after 6 usecs
> [   16.265006] calling  check_early_ioremap_leak+0x0/0x6c @ 1
> [   16.270519] initcall check_early_ioremap_leak+0x0/0x6c returned 0
> after 0 usecs
> [   16.277864] calling  pstore_init+0x0/0x80 @ 1
> [   16.282252] initcall pstore_init+0x0/0x80 returned 0 after 10 usecs
> [   16.288549] calling  init_root_keyring+0x0/0x2c @ 1
> [   16.293478] initcall init_root_keyring+0x0/0x2c returned 0 after 26
> usecs
> [   16.300305] calling  integrity_fs_init+0x0/0x78 @ 1
> [   16.305217] initcall integrity_fs_init+0x0/0x78 returned 0 after 6
> usecs
> [   16.311951] calling  blk_timeout_init+0x0/0x24 @ 1
> [   16.316763] initcall blk_timeout_init+0x0/0x24 returned 0 after 0
> usecs
> [   16.323408] calling  prandom_init_late+0x0/0x4c @ 1
> [   16.328311] initcall prandom_init_late+0x0/0x4c returned 0 after 0
> usecs
> [   16.335045] calling  pci_resource_alignment_sysfs_init+0x0/0x38 @ 1
> [   16.341344] initcall pci_resource_alignment_sysfs_init+0x0/0x38
> returned 0 after 3 usecs
> [   16.349474] calling  pci_sysfs_init+0x0/0x70 @ 1
> [   16.354210] initcall pci_sysfs_init+0x0/0x70 returned 0 after 96
> usecs
> [   16.360770] calling  bert_init+0x0/0x254 @ 1
> [   16.365067] initcall bert_init+0x0/0x254 returned 0 after 0 usecs
> [   16.371189] calling  amba_deferred_retry+0x0/0xb8 @ 1
> [   16.376266] initcall amba_deferred_retry+0x0/0xb8 returned 0 after 0
> usecs
> [   16.383173] calling  clk_debug_init+0x0/0x134 @ 1
> [   16.389937] initcall clk_debug_init+0x0/0x134 returned 0 after 1987
> usecs
> [   16.396777] calling  setup_vcpu_hotplug_event+0x0/0x44 @ 1
> [   16.402295] initcall setup_vcpu_hotplug_event+0x0/0x44 returned -19
> after 0 usecs
> [   16.409816] calling  boot_wait_for_devices+0x0/0x38 @ 1
> [   16.415066] initcall boot_wait_for_devices+0x0/0x38 returned 0 after
> 0 usecs
> [   16.422153] calling  sync_state_resume_initcall+0x0/0x28 @ 1
> [   16.427845] initcall sync_state_resume_initcall+0x0/0x28 returned 0
> after 1 usecs
> [   16.435365] calling  deferred_probe_initcall+0x0/0xc0 @ 1
> [   16.440888] fsl-edma 22c0000.dma-controller: Linked as a consumer to
> 5000000.iommu
> [   16.448557] fsl-edma 22c0000.dma-controller: Adding to iommu group 11
> [   16.456171] pcieport 0001:00:00.0: Linked as a consumer to
> 5000000.iommu
> [   16.462940] pcieport 0001:00:00.0: Adding to iommu group 12
> [   16.468701] pcieport 0001:00:00.0: PME: Signaling with IRQ 33
> [   16.474651] pcieport 0001:00:00.0: AER: enabled with IRQ 33
> [   16.480423] pcieport 0002:00:00.0: Linked as a consumer to
> 5000000.iommu
> [   16.487192] pcieport 0002:00:00.0: Adding to iommu group 13
> [   16.492958] pcieport 0002:00:00.0: PME: Signaling with IRQ 35
> [   16.498869] pcieport 0002:00:00.0: AER: enabled with IRQ 35
> [   16.512065] libphy: VSC9959 internal MDIO bus: probed
> [   16.517162] mscc_felix 0000:00:00.5: Found PCS at internal MDIO
> address 0
> [   16.523994] mscc_felix 0000:00:00.5: Found PCS at internal MDIO
> address 1
> [   16.530820] mscc_felix 0000:00:00.5: Found PCS at internal MDIO
> address 2
> [   16.537644] mscc_felix 0000:00:00.5: Found PCS at internal MDIO
> address 3
> [   16.623987] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY
> [0000:00:00.3:07] driver [Broadcom BCM54140] (irq=POLL)
> [   16.699981] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY
> [0000:00:00.3:08] driver [Broadcom BCM54140] (irq=POLL)
> [   16.771982] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY
> [0000:00:00.3:09] driver [Broadcom BCM54140] (irq=POLL)
> [   16.843991] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY
> [0000:00:00.3:0a] driver [Broadcom BCM54140] (irq=POLL)
> [   16.855044] mscc_felix 0000:00:00.5: configuring for fixed/internal
> link mode
> [   16.862229] device eth2 entered promiscuous mode
> [   16.862240] mscc_felix 0000:00:00.5: Link is Up - 2.5Gbps/Full - flow
> control off
> [   16.866886] DSA: tree 0 setup
> [   16.877437] initcall deferred_probe_initcall+0x0/0xc0 returned 0
> after 426411 usecs
> [   16.885144] calling  genpd_power_off_unused+0x0/0xa0 @ 1
> [   16.890486] initcall genpd_power_off_unused+0x0/0xa0 returned 0 after
> 0 usecs
> [   16.897656] calling  genpd_debug_init+0x0/0x98 @ 1
> [   16.902495] initcall genpd_debug_init+0x0/0x98 returned 0 after 24
> usecs
> [   16.909232] calling  gpio_keys_init+0x0/0x30 @ 1
> [   16.916391] input: buttons0 as
> /devices/platform/buttons0/input/input1
> [   16.923137] initcall gpio_keys_init+0x0/0x30 returned 0 after 9047
> usecs
> [   16.929897] calling  register_update_efi_random_seed+0x0/0x44 @ 1
> [   16.936026] initcall register_update_efi_random_seed+0x0/0x44
> returned 0 after 0 usecs
> [   16.943992] calling  efi_shutdown_init+0x0/0x68 @ 1
> [   16.948895] initcall efi_shutdown_init+0x0/0x68 returned -19 after 0
> usecs
> [   16.955806] calling  efi_earlycon_unmap_fb+0x0/0x4c @ 1
> [   16.961058] initcall efi_earlycon_unmap_fb+0x0/0x4c returned 0 after
> 0 usecs
> [   16.968140] calling  of_fdt_raw_init+0x0/0x94 @ 1
> [   16.972922] initcall of_fdt_raw_init+0x0/0x94 returned 0 after 52
> usecs
> [   16.979571] calling  tcp_congestion_default+0x0/0x34 @ 1
> [   16.984910] initcall tcp_congestion_default+0x0/0x34 returned 0 after
> 1 usecs
> [   16.992085] calling  ip_auto_config+0x0/0xea8 @ 1
> [   16.996822] initcall ip_auto_config+0x0/0xea8 returned 0 after 9
> usecs
> [   17.003384] calling  init_amu_fie+0x0/0x29c @ 1
> [   17.007940] initcall init_amu_fie+0x0/0x29c returned 0 after 2 usecs
> [   17.014325] calling  software_resume+0x0/0x1c0 @ 1
> [   17.019143] initcall software_resume+0x0/0x1c0 returned -2 after 1
> usecs
> [   17.025878] calling  trace_eval_sync+0x0/0x34 @ 1
> [   17.030619] initcall trace_eval_sync+0x0/0x34 returned 0 after 11
> usecs
> [   17.037275] calling  clear_boot_tracer+0x0/0x44 @ 1
> [   17.042180] initcall clear_boot_tracer+0x0/0x44 returned 0 after 0
> usecs
> [   17.048914] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0xb4
> @ 1
> [   17.055655] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0xb4
> returned 0 after 0 usecs
> [   17.064223] calling  fb_logo_late_init+0x0/0x24 @ 1
> [   17.069123] initcall fb_logo_late_init+0x0/0x24 returned 0 after 0
> usecs
> [   17.075855] calling  clk_disable_unused+0x0/0xe0 @ 1
> [   17.080869] initcall clk_disable_unused+0x0/0xe0 returned 0 after 22
> usecs
> [   17.087778] calling  regulator_init_complete+0x0/0x5c @ 1
> [   17.093203] initcall regulator_init_complete+0x0/0x5c returned 0
> after 1 usecs
> [   17.100459] calling  of_platform_sync_state_init+0x0/0x28 @ 1
> [   17.106234] initcall of_platform_sync_state_init+0x0/0x28 returned 0
> after 0 usecs
> [   17.113844] calling  alsa_sound_last_init+0x0/0x98 @ 1
> [   17.119007] ALSA device list:
> [   17.121986]   No soundcards found.
> [   17.125400] initcall alsa_sound_last_init+0x0/0x98 returned 0 after
> 6243 usecs
> [   17.136552] EXT4-fs (mmcblk0p2): INFO: recovery required on readonly
> filesystem
> [   17.143912] EXT4-fs (mmcblk0p2): write access will be enabled during
> recovery
> [   17.162334] EXT4-fs (mmcblk0p2): recovery complete
> [   17.168658] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data
> mode. Opts: (null). Quota mode: none.
> [   17.178481] VFS: Mounted root (ext4 filesystem) readonly on device
> 179:2.
> [   17.185537] devtmpfs: mounted
> [   17.193103] Freeing unused kernel memory: 4800K
> [   17.209449] Run /sbin/init as init process
> [   17.213570]   with arguments:
> [   17.216543]     /sbin/init
> [   17.219259]   with environment:
> [   17.222417]     HOME=/
> [   17.224781]     TERM=linux
> [   17.253444] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null). Quota
> mode: none.
>
> HTH,
> -michael
