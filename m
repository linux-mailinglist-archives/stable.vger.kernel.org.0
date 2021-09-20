Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781F4410E12
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 02:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhITA54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 20:57:56 -0400
Received: from mout.gmx.net ([212.227.15.18]:50119 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231824AbhITA5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Sep 2021 20:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632099376;
        bh=XhCYRuGJWiW3CzynMUOMlib4SgrFOmprP/nrseaXJV4=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=TuytLYfpn8/AoELOYjcZrCHolh79NMI5FWgCPHcch/uEtN9h28zc9QoCvHkv3J3lx
         ciJ9vtHy4oug8r2RrdYomW6UZPriqGyBOPPAkFAcRzf2vSMugFQxyaF/0UvHRSCveM
         S/Piw7GFLLdZuniixpS73uGCNurLW/ci5U6Oh6ik=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.191.217.45]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MpDJd-1nEfE72k4V-00qm8d; Mon, 20
 Sep 2021 02:56:16 +0200
Message-ID: <fc21617d65338078366e70704eb55789a810e45e.camel@gmx.de>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
From:   Mike Galbraith <efault@gmx.de>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org
Date:   Mon, 20 Sep 2021 02:56:15 +0200
In-Reply-To: <YUdtm8hVH0ps18BK@linux.ibm.com>
References: <20210914094108.22482-1-jgross@suse.com>
         <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
         <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
         <YUdtm8hVH0ps18BK@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DdrdXmlc5oPdbLU7W9ls7dMWdIeSG1OECmYQDKt1aNB/fTsoEjC
 +88FD8vnOWz1gtJpsWfMgy9vN4RHTSdweoWDLpYYRYhguDxP5GvQFwuvJt/IwD29oPS+bzJ
 Gc84vHbZY8PTKPLx51zAzb9GgR+XaYK7X4J8O+UzRzw0ee8nZ2XEkrUD22J3BzF2pJoRAC6
 fLJ45mDx9MTEiZnLzVELQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:h0s/mtSbM3M=:5sHugIk81Cd6Ql2N7zuqDg
 n5UeVu3YTVYSs3GvzbjX6hbuiRym2xKYhjBh2T6JggciMdCt/Vk4wycQw5tCJ6mtNoLMFJ2Mr
 LzPjCko8s8hVPA2QiH91jT6v9OugL2Lcwiwo2aQsDMjqEcboFgSUzbFRuMtjRTV24Tae3D+WT
 EBAAGeRtiGtj15Tp9muQWSb5Km/JPsPloLqsepA6w1jaQKpTN8WfRyn7jUwo3vknuDac9YDPJ
 u5rLBl+9c8mTTiWvCsxo/iTmT7H6VgGLv04JlAq2NBxYH4VuMeduBFV2CeVfdLxOwMYa/Kal0
 PdBNHWx/mrnvG1/c/ffosy95CperWIy4VEnPLopGDYnjY1eA0Qv1N3F4xgIu4XGe72CLyK68i
 RBzo/EbsixNUnjJ5NkbYe868lbLqr3L0XzllBLLZUts62DfyWoPh7IkYkKXupANG44Jqoaeqk
 G71c205+9Vx3kxJSaqXsnhnWK66trOmL+S3xDIAnk4h7Nca+pKIvWRn7kdkWcvr1YtpaavKd3
 9SC5QivZXntun0TevbNjMifpK0zK84XbySeN2xK4TDdJlFjitVRrMI8Unf0xx76VXWc+6TSoP
 Z8neehNn7UzSyu6n1rsoOPADQhAJMX02yo1N8YFM8pBSeNuzOeRwwnKxCDbwrkyhx//BnHSKK
 TNI/68Qs+8XiBGZpZdR+tjJZz9jYDVP1ZSy0kfGEXyjdJr/bbPFecuwRz/k4lf3Tgu2jZ2P1d
 P+Dyh9/w29gWzu/5AjLE8doV+h17Ctbw0lB0hYP6AMQZ93MyPhcGpJ0MyR2ogwq7aAqq281ZJ
 Z1KjLFQm/kTzMkeoWSlBDEQkwL6OpPW9FCO3hsW9CH9L2bJpfND7Pao1gbrQsRf7G1HnEGIW/
 sx2Fw3lprU8Nf9HiLSOPiEPea/0uDNSm5EHjfKCigq3WfiL8AU8mRb/m4kcgIRc6vhh5P1m1z
 lvYrM2fUF0W/hLURtDZChXAv6RSdMTXUPzR7E3PbKjreiUTbKcUo4aWgWTQTgPFXIPWiBVtN7
 857RywS0MdnXjX37qdczqK/uVbc/h2PCqgLYrYz8Pl8XfiBi6DPIvei9oXV7Xh3ohPZIb9cih
 5RxeExid5ZhE3c=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-09-19 at 20:04 +0300, Mike Rapoport wrote:
>
> Can you please send the boot log of a working kernel up to
>
> "Memory: %luK/%luK available"
>
> line for both of them?

Desktop box:
[    0.000000] microcode: microcode updated early to revision 0x28, date =
=3D 2019-11-12
[    0.000000] Linux version 5.15.0.g02770d1-tip (root@homer) (gcc (SUSE L=
inux) 7.5.0, GNU ld (GNU Binutils; SUSE Linux Enterprise 15) 2.35.1.202011=
23-7.18) #46 SMP Sun Sep 19 18:42:41 CEST 2021
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.15.0.g02770d1-ti=
p root=3DUUID=3D891c2a1f-cc1a-464b-a529-ab6add65aa21 scsi_mod.use_blk_mq=
=3D1 ftrace_dump_on_oops skew_tick=3D1 nortsched nodelayacct audit=3D0 cgr=
oup_disable=3Dmemory cgroup_hide=3Dall mitigations=3Doff noresume panic=3D=
60 ignore_loglevel showopts crashkernel=3D204M
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating poin=
t registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 b=
ytes, using 'standard' format.
[    0.000000] signal: max sigframe size: 1776
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usab=
le
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf9b7fff] usab=
le
[    0.000000] BIOS-e820: [mem 0x00000000cf9b8000-0x00000000cf9befff] ACPI=
 NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf9bf000-0x00000000cfdfdfff] usab=
le
[    0.000000] BIOS-e820: [mem 0x00000000cfdfe000-0x00000000d00befff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000d00bf000-0x00000000de787fff] usab=
le
[    0.000000] BIOS-e820: [mem 0x00000000de788000-0x00000000de811fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000de812000-0x00000000de828fff] ACPI=
 data
[    0.000000] BIOS-e820: [mem 0x00000000de829000-0x00000000de98dfff] ACPI=
 NVS
[    0.000000] BIOS-e820: [mem 0x00000000de98e000-0x00000000deffefff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000defff000-0x00000000deffffff] usab=
le
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041effffff] usab=
le
[    0.000000] printk: debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xcf673018-0xcf694a57] usable =3D=3D> usa=
ble
[    0.000000] e820: update [mem 0xcf673018-0xcf694a57] usable =3D=3D> usa=
ble
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000057=
fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000058000-0x0000000000058=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000059000-0x000000000009d=
fff] usable
[    0.000000] reserve setup_data: [mem 0x000000000009e000-0x000000000009f=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000cf673=
017] usable
[    0.000000] reserve setup_data: [mem 0x00000000cf673018-0x00000000cf694=
a57] usable
[    0.000000] reserve setup_data: [mem 0x00000000cf694a58-0x00000000cf9b7=
fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000cf9b8000-0x00000000cf9be=
fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000cf9bf000-0x00000000cfdfd=
fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000cfdfe000-0x00000000d00be=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000d00bf000-0x00000000de787=
fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000de788000-0x00000000de811=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000de812000-0x00000000de828=
fff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000de829000-0x00000000de98d=
fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000de98e000-0x00000000deffe=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000defff000-0x00000000defff=
fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fbfff=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed00000-0x00000000fed03=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1f=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fee00000-0x00000000fee00=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000fffff=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000041efff=
fff] usable
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi: ESRT=3D0xdef87998 ACPI=3D0xde816000 ACPI 2.0=3D0xde816=
000 SMBIOS=3D0xdef87598
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: MEDION MS-7848/MS-7848, BIOS M7848W08.20C 09/23/2013
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3591.714 MHz processor
[    0.000092] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> res=
erved
[    0.000094] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000098] last_pfn =3D 0x41f000 max_arch_pfn =3D 0x400000000
[    0.000169] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- W=
T
[    0.000869] e820: update [mem 0xe0000000-0xffffffff] usable =3D=3D> res=
erved
[    0.000874] last_pfn =3D 0xdf000 max_arch_pfn =3D 0x400000000
[    0.005979] esrt: Reserving ESRT space from 0x00000000def87998 to 0x000=
00000def879d0.
[    0.005985] Kernel/User page tables isolation: disabled on command line=
.
[    0.005987] Using GB pages for direct mapping
[    0.006571] Secure boot disabled
[    0.006571] RAMDISK: [mem 0x3f214000-0x3fffafff]
[    0.006575] ACPI: Early table checksum verification disabled
[    0.006577] ACPI: RSDP 0x00000000DE816000 000024 (v02 MEDION)
[    0.006580] ACPI: XSDT 0x00000000DE816088 00008C (v01 MEDION MEDIONAG 1=
1112011 AMI  00010013)
[    0.006583] ACPI: FACP 0x00000000DE822CC8 00010C (v05 MEDION MEDIONAG 1=
1112011 AMI  00010013)
[    0.006587] ACPI: DSDT 0x00000000DE8161A0 00CB24 (v02 MEDION MEDIONAG 0=
0000028 INTL 20120711)
[    0.006589] ACPI: FACS 0x00000000DE98C080 000040
[    0.006591] ACPI: APIC 0x00000000DE822DD8 000092 (v03 MEDION MEDIONAG 1=
1112011 AMI  00010013)
[    0.006593] ACPI: FPDT 0x00000000DE822E70 000044 (v01 MEDION MEDIONAG 1=
1112011 AMI  00010013)
[    0.006595] ACPI: MSDM 0x00000000DE822EB8 000055 (v03 MEDION MEDIONAG 1=
1112011 AMI  00010013)
[    0.006597] ACPI: LPIT 0x00000000DE822F10 00005C (v01 MEDION MEDIONAG 0=
0000000 AMI. 00000005)
[    0.006599] ACPI: SSDT 0x00000000DE822F70 000539 (v01 PmRef  Cpu0Ist  0=
0003000 INTL 20120711)
[    0.006602] ACPI: SSDT 0x00000000DE8234B0 000AD8 (v01 PmRef  CpuPm    0=
0003000 INTL 20120711)
[    0.006604] ACPI: MCFG 0x00000000DE823F88 00003C (v01 MEDION MEDIONAG 1=
1112011 MSFT 00000097)
[    0.006606] ACPI: HPET 0x00000000DE823FC8 000038 (v01 MEDION MEDIONAG 1=
1112011 AMI. 00000005)
[    0.006608] ACPI: SSDT 0x00000000DE824000 000443 (v01 SataRe SataTabl 0=
0001000 INTL 20120711)
[    0.006610] ACPI: SSDT 0x00000000DE824448 0033CE (v01 SaSsdt SaSsdt   0=
0003000 INTL 20091112)
[    0.006612] ACPI: DMAR 0x00000000DE827818 000080 (v01 INTEL  HSW      0=
0000001 INTL 00000001)
[    0.006614] ACPI: SSDT 0x00000000DE827898 000A26 (v01 Intel_ IsctTabl 0=
0001000 INTL 20120711)
[    0.006616] ACPI: Reserving FACP table memory at [mem 0xde822cc8-0xde82=
2dd3]
[    0.006617] ACPI: Reserving DSDT table memory at [mem 0xde8161a0-0xde82=
2cc3]
[    0.006618] ACPI: Reserving FACS table memory at [mem 0xde98c080-0xde98=
c0bf]
[    0.006619] ACPI: Reserving APIC table memory at [mem 0xde822dd8-0xde82=
2e69]
[    0.006620] ACPI: Reserving FPDT table memory at [mem 0xde822e70-0xde82=
2eb3]
[    0.006621] ACPI: Reserving MSDM table memory at [mem 0xde822eb8-0xde82=
2f0c]
[    0.006622] ACPI: Reserving LPIT table memory at [mem 0xde822f10-0xde82=
2f6b]
[    0.006622] ACPI: Reserving SSDT table memory at [mem 0xde822f70-0xde82=
34a8]
[    0.006623] ACPI: Reserving SSDT table memory at [mem 0xde8234b0-0xde82=
3f87]
[    0.006624] ACPI: Reserving MCFG table memory at [mem 0xde823f88-0xde82=
3fc3]
[    0.006625] ACPI: Reserving HPET table memory at [mem 0xde823fc8-0xde82=
3fff]
[    0.006626] ACPI: Reserving SSDT table memory at [mem 0xde824000-0xde82=
4442]
[    0.006627] ACPI: Reserving SSDT table memory at [mem 0xde824448-0xde82=
7815]
[    0.006627] ACPI: Reserving DMAR table memory at [mem 0xde827818-0xde82=
7897]
[    0.006628] ACPI: Reserving SSDT table memory at [mem 0xde827898-0xde82=
82bd]
[    0.006689] No NUMA configuration found
[    0.006690] Faking a node at [mem 0x0000000000000000-0x000000041effffff=
]
[    0.006692] NODE_DATA(0) allocated [mem 0x41eff8000-0x41effbfff]
[    0.006697] Reserving 204MB of memory at 3104MB for crashkernel (System=
 RAM: 16340MB)
[    0.006711] Zone ranges:
[    0.006712]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.006713]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.006714]   Normal   [mem 0x0000000100000000-0x000000041effffff]
[    0.006716] Movable zone start for each node
[    0.006716] Early memory node ranges
[    0.006717]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.006718]   node   0: [mem 0x0000000000059000-0x000000000009dfff]
[    0.006719]   node   0: [mem 0x0000000000100000-0x00000000cf9b7fff]
[    0.006720]   node   0: [mem 0x00000000cf9bf000-0x00000000cfdfdfff]
[    0.006721]   node   0: [mem 0x00000000d00bf000-0x00000000de787fff]
[    0.006721]   node   0: [mem 0x00000000defff000-0x00000000deffffff]
[    0.006722]   node   0: [mem 0x0000000100000000-0x000000041effffff]
[    0.006724] Initmem setup node 0 [mem 0x0000000000001000-0x000000041eff=
ffff]
[    0.006727] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.006728] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.006757] On node 0, zone DMA: 98 pages in unavailable ranges
[    0.012880] On node 0, zone DMA32: 7 pages in unavailable ranges
[    0.013356] On node 0, zone DMA32: 705 pages in unavailable ranges
[    0.013376] On node 0, zone DMA32: 2167 pages in unavailable ranges
[    0.013672] On node 0, zone Normal: 4096 pages in unavailable ranges
[    0.013704] On node 0, zone Normal: 4096 pages in unavailable ranges
[    0.013777] ACPI: PM-Timer IO Port: 0x1808
[    0.013783] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.013792] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0=
-23
[    0.013794] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.013795] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.013798] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.013799] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.013802] TSC deadline timer available
[    0.013803] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.013818] [mem 0xdf000000-0xf7ffffff] available for PCI devices
[    0.013819] Booting paravirtualized kernel on bare hardware
[    0.013821] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.016320] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_n=
ode_ids:1
[    0.016472] percpu: Embedded 52 pages/cpu s173592 r8192 d31208 u262144
[    0.016476] pcpu-alloc: s173592 r8192 d31208 u262144 alloc=3D1*2097152
[    0.016478] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.016496] Built 1 zonelists, mobility grouping on.  Total pages: 4117=
613
[    0.016497] Policy zone: Normal
[    0.016499] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-5.15.0.g027=
70d1-tip root=3DUUID=3D891c2a1f-cc1a-464b-a529-ab6add65aa21 scsi_mod.use_b=
lk_mq=3D1 ftrace_dump_on_oops skew_tick=3D1 nortsched nodelayacct audit=3D=
0 cgroup_disable=3Dmemory cgroup_hide=3Dall mitigations=3Doff noresume pan=
ic=3D60 ignore_loglevel showopts crashkernel=3D204M
[    0.016631] Unknown command line parameters: nodelayacct noresume showo=
pts BOOT_IMAGE=3D/boot/vmlinuz-5.15.0.g02770d1-tip audit=3D0 crashkernel=
=3D204M
[    0.016632] printk: log_buf_len individual max cpu contribution: 32768 =
bytes
[    0.016633] printk: log_buf_len total cpu_extra contributions: 229376 b=
ytes
[    0.016634] printk: log_buf_len min size: 262144 bytes
[    0.016824] printk: log_buf_len: 524288 bytes
[    0.016825] printk: early log buf free: 250392(95%)
[    0.017475] Dentry cache hash table entries: 2097152 (order: 12, 167772=
16 bytes, linear)
[    0.017810] Inode-cache hash table entries: 1048576 (order: 11, 8388608=
 bytes, linear)
[    0.017854] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.037819] Memory: 3431140K/16732532K available (10248K kernel code, 2=
187K rwdata, 3396K rodata, 1628K init, 1084K bss, 632956K reserved, 0K cma=
-reserved)

Lappy:
[    0.000000] microcode: microcode updated early to revision 0xea, date =
=3D 2021-01-25
[    0.000000] Linux version 5.15.0.g02770d1-tip (root@homer) (gcc (SUSE L=
inux) 7.5.0, GNU ld (GNU Binutils; SUSE Linux Enterprise 15) 2.35.1.202011=
23-7.18) #46 SMP Sun Sep 19 18:42:41 CEST 2021
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.15.0.g02770d1-ti=
p root=3DUUID=3Dfa9ef4c7-201b-4d4e-a975-d7042e8c8e92 ntremap=3Dno_x2apic_o=
ptout acpi_backlight=3Dvendor "acpi_osi=3D!Windows 2013" "acpi_osi=3D!Wind=
ows 2012" nortsched ftrace_dump_on_oops audit=3D0 nodelayacct scsi_mod.use=
_blk_mq=3D1 mitigations=3Doff noresume panic=3D60 ignore_loglevel call_tra=
ce=3Dold noresume crashkernel=3D211M,high crashkernel=3D72M,low
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating poin=
t registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds regist=
ers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 960 =
bytes, using 'compacted' format.
[    0.000000] signal: max sigframe size: 2032
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usab=
le
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008454cfff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000008454d000-0x000000008454dfff] ACPI=
 NVS
[    0.000000] BIOS-e820: [mem 0x000000008454e000-0x0000000084577fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x0000000084578000-0x000000008b7aafff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000008b7ab000-0x000000008c4aefff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x000000008c4af000-0x000000008c4fbfff] ACPI=
 data
[    0.000000] BIOS-e820: [mem 0x000000008c4fc000-0x000000008ce3dfff] ACPI=
 NVS
[    0.000000] BIOS-e820: [mem 0x000000008ce3e000-0x000000008d2fefff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x000000008d2ff000-0x000000008d2fffff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000008d300000-0x000000008d3fffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] rese=
rved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000026effffff] usab=
le
[    0.000000] printk: debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x831d6018-0x831e6057] usable =3D=3D> usa=
ble
[    0.000000] e820: update [mem 0x831d6018-0x831e6057] usable =3D=3D> usa=
ble
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000057=
fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000058000-0x0000000000058=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000059000-0x000000000009d=
fff] usable
[    0.000000] reserve setup_data: [mem 0x000000000009e000-0x000000000009f=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000831d6=
017] usable
[    0.000000] reserve setup_data: [mem 0x00000000831d6018-0x00000000831e6=
057] usable
[    0.000000] reserve setup_data: [mem 0x00000000831e6058-0x000000008454c=
fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008454d000-0x000000008454d=
fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000008454e000-0x0000000084577=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000084578000-0x000000008b7aa=
fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008b7ab000-0x000000008c4ae=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008c4af000-0x000000008c4fb=
fff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000008c4fc000-0x000000008ce3d=
fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000008ce3e000-0x000000008d2fe=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008d2ff000-0x000000008d2ff=
fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008d300000-0x000000008d3ff=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000e0000000-0x00000000effff=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fe000000-0x00000000fe010=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fee00000-0x00000000fee00=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000fffff=
fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000026efff=
fff] usable
[    0.000000] efi: EFI v2.40 by American Megatrends
[    0.000000] efi: ESRT=3D0x8d265118 ACPI=3D0x8c4c6000 ACPI 2.0=3D0x8c4c6=
000 SMBIOS=3D0x8a64d010 TPMEventLog=3D0x845e9018
[    0.000000] TPM Final Events table not present
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: HP HP Spectre x360 Convertible/804F, BIOS F.47 11/22/2=
017
[    0.000000] tsc: Detected 2400.000 MHz processor
[    0.000725] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> res=
erved
[    0.000728] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000734] last_pfn =3D 0x26f000 max_arch_pfn =3D 0x400000000
[    0.000836] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- W=
T
[    0.001875] last_pfn =3D 0x8d300 max_arch_pfn =3D 0x400000000
[    0.009164] esrt: Reserving ESRT space from 0x000000008d265118 to 0x000=
000008d265150.
[    0.009173] Kernel/User page tables isolation: disabled on command line=
.
[    0.009174] Using GB pages for direct mapping
[    0.009885] Secure boot disabled
[    0.009886] RAMDISK: [mem 0x3f1c1000-0x3fffafff]
[    0.009890] ACPI: Early table checksum verification disabled
[    0.009893] ACPI: RSDP 0x000000008C4C6000 000024 (v02 HPQOEM)
[    0.009897] ACPI: XSDT 0x000000008C4C60A8 0000CC (v01 HPQOEM SLIC-MPC 0=
1072009 HP   00010013)
[    0.009902] ACPI: FACP 0x000000008C4F2DF0 00010C (v05 HPQOEM SLIC-MPC 0=
1072009 HP   00010013)
[    0.009907] ACPI: DSDT 0x000000008C4C6200 02CBE9 (v02 HPQOEM 804F     0=
1072009 ACPI 20120913)
[    0.009910] ACPI: FACS 0x000000008CE3BF80 000040
[    0.009913] ACPI: APIC 0x000000008C4F2F00 000084 (v03 HPQOEM 804F     0=
1072009 HP   00010013)
[    0.009915] ACPI: FPDT 0x000000008C4F2F88 000044 (v01 HPQOEM 804F     0=
1072009 HP   00010013)
[    0.009918] ACPI: FIDT 0x000000008C4F2FD0 00009C (v01 HPQOEM 804F     0=
1072009 HP   00010013)
[    0.009921] ACPI: MCFG 0x000000008C4F3070 00003C (v01 HPQOEM 804F     0=
1072009 HP   00000097)
[    0.009924] ACPI: HPET 0x000000008C4F30B0 000038 (v01 HPQOEM 804F     0=
1072009 HP   0005000B)
[    0.009926] ACPI: LPIT 0x000000008C4F30E8 000094 (v01 HPQOEM 804F     0=
0000000 HP   0000005F)
[    0.009929] ACPI: SSDT 0x000000008C4F3180 000248 (v02 HPQOEM 804F     0=
0000000 ACPI 20120913)
[    0.009932] ACPI: SSDT 0x000000008C4F33C8 0011A8 (v02 HPQOEM 804F     0=
0001000 ACPI 20120913)
[    0.009935] ACPI: SSDT 0x000000008C4F4570 0004A3 (v02 HPQOEM 804F     0=
0001000 ACPI 20120913)
[    0.009938] ACPI: DBGP 0x000000008C4F4A18 000034 (v01 HPQOEM 804F     0=
0000000 HP   0000005F)
[    0.009941] ACPI: DBG2 0x000000008C4F4A50 000054 (v00 HPQOEM 804F     0=
0000000 HP   0000005F)
[    0.009943] ACPI: SSDT 0x000000008C4F4AA8 000024 (v02 HPQOEM 804F     0=
0000000 ACPI 20120913)
[    0.009946] ACPI: MSDM 0x000000008C4F4AD0 000055 (v03 HPQOEM SLIC-MPC 0=
0000001 HP   00010013)
[    0.009949] ACPI: SSDT 0x000000008C4F4B28 00546C (v02 HPQOEM 804F     0=
0003000 ACPI 20120913)
[    0.009951] ACPI: UEFI 0x000000008C4F9F98 000042 (v01 HPQOEM 804F     0=
0000000 HP   00000000)
[    0.009955] ACPI: SSDT 0x000000008C4F9FE0 000E73 (v02 HPQOEM 804F     0=
0003000 ACPI 20120913)
[    0.009958] ACPI: DMAR 0x000000008C4FAE58 0000A8 (v01 HPQOEM 804F     0=
0000001 HP   00000001)
[    0.009960] ACPI: TPM2 0x000000008C4FAF00 000034 (v03 HPQOEM 804F     0=
0000001 HP   00000000)
[    0.009963] ACPI: ASF! 0x000000008C4FAF38 0000A5 (v32 HPQOEM 804F     0=
0000001 HP   000F4240)
[    0.009966] ACPI: BGRT 0x000000008C4FAFE0 000038 (v01 HPQOEM 804F     0=
1072009 HP   00010013)
[    0.009969] ACPI: Reserving FACP table memory at [mem 0x8c4f2df0-0x8c4f=
2efb]
[    0.009971] ACPI: Reserving DSDT table memory at [mem 0x8c4c6200-0x8c4f=
2de8]
[    0.009972] ACPI: Reserving FACS table memory at [mem 0x8ce3bf80-0x8ce3=
bfbf]
[    0.009973] ACPI: Reserving APIC table memory at [mem 0x8c4f2f00-0x8c4f=
2f83]
[    0.009974] ACPI: Reserving FPDT table memory at [mem 0x8c4f2f88-0x8c4f=
2fcb]
[    0.009975] ACPI: Reserving FIDT table memory at [mem 0x8c4f2fd0-0x8c4f=
306b]
[    0.009976] ACPI: Reserving MCFG table memory at [mem 0x8c4f3070-0x8c4f=
30ab]
[    0.009978] ACPI: Reserving HPET table memory at [mem 0x8c4f30b0-0x8c4f=
30e7]
[    0.009979] ACPI: Reserving LPIT table memory at [mem 0x8c4f30e8-0x8c4f=
317b]
[    0.009980] ACPI: Reserving SSDT table memory at [mem 0x8c4f3180-0x8c4f=
33c7]
[    0.009981] ACPI: Reserving SSDT table memory at [mem 0x8c4f33c8-0x8c4f=
456f]
[    0.009982] ACPI: Reserving SSDT table memory at [mem 0x8c4f4570-0x8c4f=
4a12]
[    0.009983] ACPI: Reserving DBGP table memory at [mem 0x8c4f4a18-0x8c4f=
4a4b]
[    0.009984] ACPI: Reserving DBG2 table memory at [mem 0x8c4f4a50-0x8c4f=
4aa3]
[    0.009985] ACPI: Reserving SSDT table memory at [mem 0x8c4f4aa8-0x8c4f=
4acb]
[    0.009986] ACPI: Reserving MSDM table memory at [mem 0x8c4f4ad0-0x8c4f=
4b24]
[    0.009988] ACPI: Reserving SSDT table memory at [mem 0x8c4f4b28-0x8c4f=
9f93]
[    0.009989] ACPI: Reserving UEFI table memory at [mem 0x8c4f9f98-0x8c4f=
9fd9]
[    0.009990] ACPI: Reserving SSDT table memory at [mem 0x8c4f9fe0-0x8c4f=
ae52]
[    0.009991] ACPI: Reserving DMAR table memory at [mem 0x8c4fae58-0x8c4f=
aeff]
[    0.009992] ACPI: Reserving TPM2 table memory at [mem 0x8c4faf00-0x8c4f=
af33]
[    0.009994] ACPI: Reserving ASF! table memory at [mem 0x8c4faf38-0x8c4f=
afdc]
[    0.009995] ACPI: Reserving BGRT table memory at [mem 0x8c4fafe0-0x8c4f=
b017]
[    0.010282] No NUMA configuration found
[    0.010283] Faking a node at [mem 0x0000000000000000-0x000000026effffff=
]
[    0.010287] NODE_DATA(0) allocated [mem 0x26effa000-0x26effdfff]
[    0.010298] Reserving 72MB of low memory at 2016MB for crashkernel (low=
 RAM limit: 4096MB)
[    0.010300] Reserving 211MB of memory at 9744MB for crashkernel (System=
 RAM: 8103MB)
[    0.010313] Zone ranges:
[    0.010314]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.010316]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.010318]   Normal   [mem 0x0000000100000000-0x000000026effffff]
[    0.010320] Movable zone start for each node
[    0.010321] Early memory node ranges
[    0.010322]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.010323]   node   0: [mem 0x0000000000059000-0x000000000009dfff]
[    0.010325]   node   0: [mem 0x0000000000100000-0x000000008454cfff]
[    0.010326]   node   0: [mem 0x0000000084578000-0x000000008b7aafff]
[    0.010327]   node   0: [mem 0x000000008d2ff000-0x000000008d2fffff]
[    0.010328]   node   0: [mem 0x0000000100000000-0x000000026effffff]
[    0.010330] Initmem setup node 0 [mem 0x0000000000001000-0x000000026eff=
ffff]
[    0.010334] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.010336] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.010373] On node 0, zone DMA: 98 pages in unavailable ranges
[    0.016133] On node 0, zone DMA32: 43 pages in unavailable ranges
[    0.016202] On node 0, zone DMA32: 6996 pages in unavailable ranges
[    0.016653] On node 0, zone Normal: 11520 pages in unavailable ranges
[    0.016695] On node 0, zone Normal: 4096 pages in unavailable ranges
[    0.016704] Reserving Intel graphics memory at [mem 0x8e000000-0x8fffff=
ff]
[    0.017024] ACPI: PM-Timer IO Port: 0x1808
[    0.017030] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.017032] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.017033] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.017034] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.017060] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0=
-119
[    0.017063] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.017065] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.017068] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.017069] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.017075] e820: update [mem 0x89ade000-0x89b00fff] usable =3D=3D> res=
erved
[    0.017084] TSC deadline timer available
[    0.017085] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.017104] [mem 0x90000000-0xdfffffff] available for PCI devices
[    0.017105] Booting paravirtualized kernel on bare hardware
[    0.017108] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.020679] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_n=
ode_ids:1
[    0.020813] percpu: Embedded 52 pages/cpu s173592 r8192 d31208 u524288
[    0.020819] pcpu-alloc: s173592 r8192 d31208 u524288 alloc=3D1*2097152
[    0.020822] pcpu-alloc: [0] 0 1 2 3
[    0.020842] Built 1 zonelists, mobility grouping on.  Total pages: 2041=
826
[    0.020844] Policy zone: Normal
[    0.020846] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-5.15.0.g027=
70d1-tip root=3DUUID=3Dfa9ef4c7-201b-4d4e-a975-d7042e8c8e92 ntremap=3Dno_x=
2apic_optout acpi_backlight=3Dvendor "acpi_osi=3D!Windows 2013" "acpi_osi=
=3D!Windows 2012" nortsched ftrace_dump_on_oops audit=3D0 nodelayacct scsi=
_mod.use_blk_mq=3D1 mitigations=3Doff noresume panic=3D60 ignore_loglevel =
call_trace=3Dold noresume crashkernel=3D211M,high crashkernel=3D72M,low
[    0.021078] Unknown command line parameters: nodelayacct noresume nores=
ume BOOT_IMAGE=3D/boot/vmlinuz-5.15.0.g02770d1-tip ntremap=3Dno_x2apic_opt=
out audit=3D0 call_trace=3Dold crashkernel=3D72M,low
[    0.021465] Dentry cache hash table entries: 1048576 (order: 11, 838860=
8 bytes, linear)
[    0.021661] Inode-cache hash table entries: 524288 (order: 10, 4194304 =
bytes, linear)
[    0.021701] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.041321] Memory: 2104580K/8297588K available (10248K kernel code, 21=
87K rwdata, 3396K rodata, 1628K init, 1084K bss, 672016K reserved, 0K cma-=
reserved)


