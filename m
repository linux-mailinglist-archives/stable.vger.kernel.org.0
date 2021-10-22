Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6D4375CB
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 13:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhJVLDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 07:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbhJVLDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 07:03:07 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DDDC061764;
        Fri, 22 Oct 2021 04:00:49 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so3848351otl.11;
        Fri, 22 Oct 2021 04:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O50hXanb4kpe1a8IHgqkvFCHGp1QCS6MEMG0FcvIJ9o=;
        b=AmeKMRjz4GVO/7fDBYKzy3icuDVorUO3ZOAp3CSZhVRuALzjWM9B7XdbTppsMuShDy
         WdN0WhZ5MGfnk//HgzcQXaU6cHg7z+/sajCJiKOoAmCHkbXB3fhbmRumltadiKSnyMgn
         QWoqDn5jwB1/XvoxK4GB4FJu4oF1g5NtDNS5CC8o5MVZ2fyNxYPIjZSIP8ITRf9x6usZ
         mhIbJ+WGND5nZoygm4cduHGXGAtTBpjLUbIIOWDDm3XrDVYDxrBk/TMKaBmRoNGCPZuh
         PzRDDKWbXqJuyb+25JdpiUFdogL3g7crm77WucWZ/tdokKgmyR4W3sfZ/6sTdKmFfStk
         VXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O50hXanb4kpe1a8IHgqkvFCHGp1QCS6MEMG0FcvIJ9o=;
        b=Ev0ZurztjF+4Temzc3c2tZW+E/ZJd4ep3lTrtYFbpvxb5XPLswu8lEloyRPwGDziag
         dkeJ8U+nbwocuU0fLQVazo91q1Rgdkp+v2QGRRZlXOMwLOo0gwnQwu/OQtDmqJfMlAFM
         nTgPcKXAStVP9ru573CFqo+Jw4u5q939SvNSUtiKTK8kMCjVg7gjf6iIv7i0oXm6IMit
         ygdaVXPZnBt+EOLK5sgcHNYYJv6ycRv/esGg2u0TXNICbLEM62cZdcLZWczgjoDGEg/a
         dXqdqBbgvGNNpYLcOvh7LdNEAdzDvZMgOIP0xh/bOQLfvo/PZDqYXxPPHZ/xRkCirvil
         SLBA==
X-Gm-Message-State: AOAM532baR/FbRVlE0SAJWRvgfj2su/apvSAruyGrlOcl+QrjMjhoRf2
        BHb+exSoTUHTSVRcSHnwZwL6esrSlAcxW82d0fU6Io4oNSk=
X-Google-Smtp-Source: ABdhPJzCNdJtlPV/88VD5hfsnmh8P9u1V3Wywda9mpWkrixcW/JNP5db1Qj736yCP/fAo3+X6UYPIv5hmV8yJdRTfFo=
X-Received: by 2002:a9d:70c4:: with SMTP id w4mr9375697otj.170.1634900447545;
 Fri, 22 Oct 2021 04:00:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:4b15:0:0:0:0:0 with HTTP; Fri, 22 Oct 2021 04:00:46
 -0700 (PDT)
In-Reply-To: <20211022105913.7671-1-youling257@gmail.com>
References: <20211008092547.3996295-5-mathias.nyman@linux.intel.com> <20211022105913.7671-1-youling257@gmail.com>
From:   youling 257 <youling257@gmail.com>
Date:   Fri, 22 Oct 2021 19:00:46 +0800
Message-ID: <CAOzgRdY8+Wm-Ane==RQTvEe4aKa40+h1VF9JSg8WQsm-XH0ZCw@mail.gmail.com>
Subject: Re: [PATCH 4/5] xhci: Fix command ring pointer corruption while
 aborting a command
To:     mathias.nyman@linux.intel.com
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        pkondeti@codeaurora.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

full log.

Welcome to Ubuntu 21.10 (GNU/Linux 5.15.0-rc6-android-x86_64+ i686)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 updates can be applied immediately.

Last login: Fri Oct 22 17:27:47 2021 from 192.168.3.3
youling257@localhost:~$ su
=E5=AF=86=E7=A0=81=EF=BC=9A
root@localhost:/home/youling257# dmesg
[    0.000000] microcode: microcode updated early to revision 0xde,
date =3D 2020-05-26
[    0.000000] Linux version 5.15.0-rc6-android-x86_64+
(root@localhost) (gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU
Binutils for Ubuntu) 2.37) #1 SMP PREEMPT Mon Oct 18 15:01:27 CST 2021
[    0.000000] Command line: BOOT_IMAGE=3D/32/kernel root=3D/dev/ram0
SRC=3Dq mnt=3D422c65cf-53c6-4e63-8619-298ce0f01129 resume=3D/dev/nvme0n1p1
resume_offset=3D65728512 video=3D2560x1600@60 RAMDISK=3D1ramdisk.img system=
=3D
DATA=3D androidboot.selinux=3Dpermissive buildvariant=3Duserdebug
memmap=3D1M!5M ramoops.mem_size=3D1048576 ramoops.ecc=3D1
ramoops.mem_address=3D0x00500000 ramoops.console_size=3D16384
ramoops.ftrace_size=3D16384 ramoops.pmsg_size=3D16384
ramoops.record_size=3D32768 DEBUG=3D1 quiet loglevel=3D3
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating
point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registe=
rs'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is
960 bytes, using 'compacted' format.
[    0.000000] signal: max sigframe size: 2032
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009efff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000850d6fff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000850d7000-0x00000000850d7fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000850d8000-0x00000000850d8fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000850d9000-0x000000008bea7fff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000008bea8000-0x000000008caeefff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000008caef000-0x000000008cb99fff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000008cb9a000-0x000000008cf3dfff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x000000008cf3e000-0x000000008d357fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000008d358000-0x000000008d3fefff] type =
20
[    0.000000] BIOS-e820: [mem 0x000000008d3ff000-0x000000008d3fffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000008d400000-0x000000008fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000026effffff] usabl=
e
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] user: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] user: [mem 0x0000000000059000-0x000000000009efff] usable
[    0.000000] user: [mem 0x000000000009f000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x00000000004fffff] usable
[    0.000000] user: [mem 0x0000000000500000-0x00000000005fffff]
persistent (type 12)
[    0.000000] user: [mem 0x0000000000600000-0x00000000850d6fff] usable
[    0.000000] user: [mem 0x00000000850d7000-0x00000000850d7fff] ACPI NVS
[    0.000000] user: [mem 0x00000000850d8000-0x00000000850d8fff] reserved
[    0.000000] user: [mem 0x00000000850d9000-0x000000008bea7fff] usable
[    0.000000] user: [mem 0x000000008bea8000-0x000000008caeefff] reserved
[    0.000000] user: [mem 0x000000008caef000-0x000000008cb99fff] usable
[    0.000000] user: [mem 0x000000008cb9a000-0x000000008cf3dfff] ACPI NVS
[    0.000000] user: [mem 0x000000008cf3e000-0x000000008d357fff] reserved
[    0.000000] user: [mem 0x000000008d358000-0x000000008d3fefff] type 20
[    0.000000] user: [mem 0x000000008d3ff000-0x000000008d3fffff] usable
[    0.000000] user: [mem 0x000000008d400000-0x000000008fffffff] reserved
[    0.000000] user: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] user: [mem 0x00000000fe000000-0x00000000fe010fff] reserved
[    0.000000] user: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] user: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] user: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x000000026effffff] usable
[    0.000000] efi: EFI v2.60 by American Megatrends
[    0.000000] efi: ACPI 2.0=3D0x8cb9a000 ACPI=3D0x8cb9a000
SMBIOS=3D0x8d2b7000 SMBIOS 3.0=3D0x8d2b6000 ESRT=3D0x8ac24498
MEMATTR=3D0x880a0018
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: Default string Default string/SKYBAY, BIOS 5.12 03/02/2=
020
[    0.000000] tsc: Detected 2900.000 MHz processor
[    0.000000] tsc: Detected 2899.886 MHz TSC
[    0.000524] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000527] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000534] last_pfn =3D 0x26f000 max_arch_pfn =3D 0x400000000
[    0.000672] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.001511] last_pfn =3D 0x8d400 max_arch_pfn =3D 0x400000000
[    0.008101] found SMP MP-table at [mem 0x000fcdc0-0x000fcdcf]
[    0.008109] esrt: Reserving ESRT space from 0x000000008ac24498 to
0x000000008ac244d0.
[    0.008115] e820: update [mem 0x8ac24000-0x8ac24fff] usable =3D=3D> rese=
rved
[    0.008128] Using GB pages for direct mapping
[    0.008891] Secure boot disabled
[    0.008892] RAMDISK: [mem 0x371db000-0x378e4fff]
[    0.008895] ACPI: Early table checksum verification disabled
[    0.008897] ACPI: RSDP 0x000000008CB9A000 000024 (v02 ALASKA)
[    0.008901] ACPI: XSDT 0x000000008CB9A0B0 0000DC (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.008906] ACPI: FACP 0x000000008CBC2840 000114 (v06 ALASKA A M I
  01072009 AMI  00010013)
[    0.008911] ACPI: DSDT 0x000000008CB9A220 028620 (v02 ALASKA A M I
  01072009 INTL 20160422)
[    0.008913] ACPI: FACS 0x000000008CF3DF00 000040
[    0.008915] ACPI: APIC 0x000000008CBC2958 0000BC (v03 ALASKA A M I
  01072009 AMI  00010013)
[    0.008918] ACPI: FPDT 0x000000008CBC2A18 000044 (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.008920] ACPI: FIDT 0x000000008CBC2A60 00009C (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.008923] ACPI: MCFG 0x000000008CBC2B00 00003C (v01 ALASKA A M I
  01072009 MSFT 00000097)
[    0.008925] ACPI: SSDT 0x000000008CBC2B40 000359 (v01 SataRe
SataTabl 00001000 INTL 20160422)
[    0.008928] ACPI: SSDT 0x000000008CBC2EA0 003164 (v02 SaSsdt SaSsdt
  00003000 INTL 20160422)
[    0.008930] ACPI: HPET 0x000000008CBC6008 000038 (v01 INTEL  KBL
  00000001 MSFT 0000005F)
[    0.008933] ACPI: SSDT 0x000000008CBC6040 000DE5 (v02 INTEL
Ther_Rvp 00001000 INTL 20160422)
[    0.008935] ACPI: SSDT 0x000000008CBC6E28 0008FE (v02 INTEL
xh_rvp11 00000000 INTL 20160422)
[    0.008938] ACPI: UEFI 0x000000008CBC7728 000042 (v01 ALASKA A M I
  00000002      01000013)
[    0.008940] ACPI: SSDT 0x000000008CBC7770 000EDE (v02 CpuRef
CpuSsdt  00003000 INTL 20160422)
[    0.008942] ACPI: LPIT 0x000000008CBC8650 000094 (v01 INTEL  KBL
  00000000 MSFT 0000005F)
[    0.008945] ACPI: SSDT 0x000000008CBC86E8 000141 (v02 INTEL  HdaDsp
  00000000 INTL 20160422)
[    0.008947] ACPI: SSDT 0x000000008CBC8830 00029F (v02 INTEL
sensrhub 00000000 INTL 20160422)
[    0.008950] ACPI: SSDT 0x000000008CBC8AD0 003002 (v02 INTEL
PtidDevc 00001000 INTL 20160422)
[    0.008952] ACPI: SSDT 0x000000008CBCBAD8 000517 (v02 INTEL
TbtTypeC 00000000 INTL 20160422)
[    0.008955] ACPI: DBGP 0x000000008CBCBFF0 000034 (v01 INTEL
  00000002 MSFT 0000005F)
[    0.008957] ACPI: DBG2 0x000000008CBCC028 000054 (v00 INTEL
  00000002 MSFT 0000005F)
[    0.008960] ACPI: DMAR 0x000000008CBCC080 0000CC (v01 INTEL  KBL
  00000001 INTL 00000001)
[    0.008962] ACPI: BGRT 0x000000008CBCC150 000038 (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.008965] ACPI: ASF! 0x000000008CBCC188 0000A0 (v32 INTEL   HCG
  00000001 TFSM 000F4240)
[    0.008967] ACPI: WSMT 0x000000008CBCC228 000028 (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.008969] ACPI: Reserving FACP table memory at [mem 0x8cbc2840-0x8cbc2=
953]
[    0.008971] ACPI: Reserving DSDT table memory at [mem 0x8cb9a220-0x8cbc2=
83f]
[    0.008972] ACPI: Reserving FACS table memory at [mem 0x8cf3df00-0x8cf3d=
f3f]
[    0.008973] ACPI: Reserving APIC table memory at [mem 0x8cbc2958-0x8cbc2=
a13]
[    0.008974] ACPI: Reserving FPDT table memory at [mem 0x8cbc2a18-0x8cbc2=
a5b]
[    0.008975] ACPI: Reserving FIDT table memory at [mem 0x8cbc2a60-0x8cbc2=
afb]
[    0.008975] ACPI: Reserving MCFG table memory at [mem 0x8cbc2b00-0x8cbc2=
b3b]
[    0.008976] ACPI: Reserving SSDT table memory at [mem 0x8cbc2b40-0x8cbc2=
e98]
[    0.008977] ACPI: Reserving SSDT table memory at [mem 0x8cbc2ea0-0x8cbc6=
003]
[    0.008978] ACPI: Reserving HPET table memory at [mem 0x8cbc6008-0x8cbc6=
03f]
[    0.008979] ACPI: Reserving SSDT table memory at [mem 0x8cbc6040-0x8cbc6=
e24]
[    0.008980] ACPI: Reserving SSDT table memory at [mem 0x8cbc6e28-0x8cbc7=
725]
[    0.008980] ACPI: Reserving UEFI table memory at [mem 0x8cbc7728-0x8cbc7=
769]
[    0.008981] ACPI: Reserving SSDT table memory at [mem 0x8cbc7770-0x8cbc8=
64d]
[    0.008982] ACPI: Reserving LPIT table memory at [mem 0x8cbc8650-0x8cbc8=
6e3]
[    0.008983] ACPI: Reserving SSDT table memory at [mem 0x8cbc86e8-0x8cbc8=
828]
[    0.008984] ACPI: Reserving SSDT table memory at [mem 0x8cbc8830-0x8cbc8=
ace]
[    0.008985] ACPI: Reserving SSDT table memory at [mem 0x8cbc8ad0-0x8cbcb=
ad1]
[    0.008986] ACPI: Reserving SSDT table memory at [mem 0x8cbcbad8-0x8cbcb=
fee]
[    0.008987] ACPI: Reserving DBGP table memory at [mem 0x8cbcbff0-0x8cbcc=
023]
[    0.008987] ACPI: Reserving DBG2 table memory at [mem 0x8cbcc028-0x8cbcc=
07b]
[    0.008988] ACPI: Reserving DMAR table memory at [mem 0x8cbcc080-0x8cbcc=
14b]
[    0.008989] ACPI: Reserving BGRT table memory at [mem 0x8cbcc150-0x8cbcc=
187]
[    0.008990] ACPI: Reserving ASF! table memory at [mem 0x8cbcc188-0x8cbcc=
227]
[    0.008991] ACPI: Reserving WSMT table memory at [mem 0x8cbcc228-0x8cbcc=
24f]
[    0.009018] Zone ranges:
[    0.009019]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.009021]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.009022]   Normal   [mem 0x0000000100000000-0x000000026effffff]
[    0.009024] Movable zone start for each node
[    0.009024] Early memory node ranges
[    0.009025]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.009026]   node   0: [mem 0x0000000000059000-0x000000000009efff]
[    0.009027]   node   0: [mem 0x0000000000100000-0x00000000004fffff]
[    0.009028]   node   0: [mem 0x0000000000600000-0x00000000850d6fff]
[    0.009029]   node   0: [mem 0x00000000850d9000-0x000000008bea7fff]
[    0.009030]   node   0: [mem 0x000000008caef000-0x000000008cb99fff]
[    0.009031]   node   0: [mem 0x000000008d3ff000-0x000000008d3fffff]
[    0.009031]   node   0: [mem 0x0000000100000000-0x000000026effffff]
[    0.009033] Initmem setup node 0 [mem 0x0000000000001000-0x000000026efff=
fff]
[    0.009036] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.009038] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.009043] On node 0, zone DMA: 97 pages in unavailable ranges
[    0.009058] On node 0, zone DMA: 256 pages in unavailable ranges
[    0.013678] On node 0, zone DMA32: 2 pages in unavailable ranges
[    0.013714] On node 0, zone DMA32: 3143 pages in unavailable ranges
[    0.013738] On node 0, zone DMA32: 2149 pages in unavailable ranges
[    0.027324] On node 0, zone Normal: 11264 pages in unavailable ranges
[    0.027356] On node 0, zone Normal: 4096 pages in unavailable ranges
[    0.027366] Reserving Intel graphics memory at [mem 0x8e000000-0x8ffffff=
f]
[    0.027672] ACPI: PM-Timer IO Port: 0x1808
[    0.027677] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.027679] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.027679] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.027680] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.027681] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.027681] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.027682] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.027683] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.027709] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
119
[    0.027711] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.027713] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.027716] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.027717] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.027724] e820: update [mem 0x8805d000-0x8809bfff] usable =3D=3D> rese=
rved
[    0.027733] TSC deadline timer available
[    0.027733] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.027757] PM: hibernation: Registered nosave memory: [mem
0x00000000-0x00000fff]
[    0.027759] PM: hibernation: Registered nosave memory: [mem
0x00058000-0x00058fff]
[    0.027761] PM: hibernation: Registered nosave memory: [mem
0x0009f000-0x000fffff]
[    0.027763] PM: hibernation: Registered nosave memory: [mem
0x00500000-0x005fffff]
[    0.027765] PM: hibernation: Registered nosave memory: [mem
0x850d7000-0x850d7fff]
[    0.027766] PM: hibernation: Registered nosave memory: [mem
0x850d8000-0x850d8fff]
[    0.027767] PM: hibernation: Registered nosave memory: [mem
0x8805d000-0x8809bfff]
[    0.027769] PM: hibernation: Registered nosave memory: [mem
0x8ac24000-0x8ac24fff]
[    0.027771] PM: hibernation: Registered nosave memory: [mem
0x8bea8000-0x8caeefff]
[    0.027773] PM: hibernation: Registered nosave memory: [mem
0x8cb9a000-0x8cf3dfff]
[    0.027773] PM: hibernation: Registered nosave memory: [mem
0x8cf3e000-0x8d357fff]
[    0.027774] PM: hibernation: Registered nosave memory: [mem
0x8d358000-0x8d3fefff]
[    0.027776] PM: hibernation: Registered nosave memory: [mem
0x8d400000-0x8fffffff]
[    0.027777] PM: hibernation: Registered nosave memory: [mem
0x90000000-0xdfffffff]
[    0.027777] PM: hibernation: Registered nosave memory: [mem
0xe0000000-0xefffffff]
[    0.027778] PM: hibernation: Registered nosave memory: [mem
0xf0000000-0xfdffffff]
[    0.027779] PM: hibernation: Registered nosave memory: [mem
0xfe000000-0xfe010fff]
[    0.027779] PM: hibernation: Registered nosave memory: [mem
0xfe011000-0xfebfffff]
[    0.027780] PM: hibernation: Registered nosave memory: [mem
0xfec00000-0xfec00fff]
[    0.027781] PM: hibernation: Registered nosave memory: [mem
0xfec01000-0xfecfffff]
[    0.027781] PM: hibernation: Registered nosave memory: [mem
0xfed00000-0xfed00fff]
[    0.027782] PM: hibernation: Registered nosave memory: [mem
0xfed01000-0xfedfffff]
[    0.027782] PM: hibernation: Registered nosave memory: [mem
0xfee00000-0xfee00fff]
[    0.027783] PM: hibernation: Registered nosave memory: [mem
0xfee01000-0xfeffffff]
[    0.027784] PM: hibernation: Registered nosave memory: [mem
0xff000000-0xffffffff]
[    0.027785] [mem 0x90000000-0xdfffffff] available for PCI devices
[    0.027786] Booting paravirtualized kernel on bare hardware
[    0.027788] clocksource: refined-jiffies: mask: 0xffffffff
max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.032592] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8
nr_node_ids:1
[    0.032771] percpu: Embedded 50 pages/cpu s167936 r8192 d28672 u262144
[    0.032782] pcpu-alloc: s167936 r8192 d28672 u262144 alloc=3D1*2097152
[    0.032784] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.032812] Built 1 zonelists, mobility grouping on.  Total pages: 20435=
45
[    0.032814] Kernel command line: BOOT_IMAGE=3D/32/kernel
root=3D/dev/ram0 SRC=3Dq mnt=3D422c65cf-53c6-4e63-8619-298ce0f01129
resume=3D/dev/nvme0n1p1 resume_offset=3D65728512 video=3D2560x1600@60
RAMDISK=3D1ramdisk.img system=3D DATA=3D androidboot.selinux=3Dpermissive
buildvariant=3Duserdebug memmap=3D1M!5M ramoops.mem_size=3D1048576
ramoops.ecc=3D1 ramoops.mem_address=3D0x00500000
ramoops.console_size=3D16384 ramoops.ftrace_size=3D16384
ramoops.pmsg_size=3D16384 ramoops.record_size=3D32768 DEBUG=3D1 quiet
loglevel=3D3
[    0.032941] Unknown command line parameters: BOOT_IMAGE=3D/32/kernel
SRC=3Dq mnt=3D422c65cf-53c6-4e63-8619-298ce0f01129 RAMDISK=3D1ramdisk.img
system=3D DATA=3D buildvariant=3Duserdebug DEBUG=3D1
[    0.033399] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes, linear)
[    0.033640] Inode-cache hash table entries: 524288 (order: 10,
4194304 bytes, linear)
[    0.033707] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.066384] Memory: 8009008K/8304572K available (14346K kernel
code, 1870K rwdata, 5512K rodata, 1624K init, 8568K bss, 295304K
reserved, 0K cma-reserved)
[    0.066391] random: get_random_u64 called from
__kmem_cache_create+0x24/0x480 with crng_init=3D0
[    0.067085] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, N=
odes=3D1
[    0.067087] kmemleak: Kernel memory leak detector disabled
[    0.067098] Kernel/User page tables isolation: enabled
[    0.067111] ftrace: allocating 43271 entries in 170 pages
[    0.081159] ftrace: allocated 170 pages with 4 groups
[    0.081224] rcu: Preemptible hierarchical RCU implementation.
[    0.081225]  Trampoline variant of Tasks RCU enabled.
[    0.081226]  Rude variant of Tasks RCU enabled.
[    0.081226]  Tracing variant of Tasks RCU enabled.
[    0.081227] rcu: RCU calculated value of scheduler-enlistment delay
is 100 jiffies.
[    0.081880] NR_IRQS: 4352, nr_irqs: 2048, preallocated irqs: 16
[    0.082411] Console: colour dummy device 80x25
[    0.082434] printk: console [tty0] enabled
[    0.082441] ACPI: Core revision 20210730
[    0.082619] hpet: HPET dysfunctional in PC10. Force disabled.
[    0.082620] APIC: Switch to symmetric I/O mode setup
[    0.086406] clocksource: tsc-early: mask: 0xffffffffffffffff
max_cycles: 0x29ccd767b87, max_idle_ns: 440795223720 ns
[    0.086411] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5799.77 BogoMIPS (lpj=3D2899886)
[    0.086413] pid_max: default: 32768 minimum: 301
[    0.087410] LSM: Security Framework initializing
[    0.087410] SELinux:  Initializing.
[    0.087410] Mount-cache hash table entries: 16384 (order: 5, 131072
bytes, linear)
[    0.087410] Mountpoint-cache hash table entries: 16384 (order: 5,
131072 bytes, linear)
[    0.087410] CPU0: Thermal monitoring enabled (TM1)
[    0.087410] process: using mwait in idle threads
[    0.087410] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.087410] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.087410] Spectre V1 : Mitigation: usercopy/swapgs barriers and
__user pointer sanitization
[    0.087410] Spectre V2 : Mitigation: Full generic retpoline
[    0.087410] Spectre V2 : Spectre v2 / SpectreRSB mitigation:
Filling RSB on context switch
[    0.087410] Spectre V2 : Enabling Restricted Speculation for firmware ca=
lls
[    0.087410] Spectre V2 : mitigation: Enabling conditional Indirect
Branch Prediction Barrier
[    0.087410] Spectre V2 : User space: Mitigation: STIBP via seccomp and p=
rctl
[    0.087410] Speculative Store Bypass: Mitigation: Speculative Store
Bypass disabled via prctl and seccomp
[    0.087410] SRBDS: Mitigation: Microcode
[    0.087410] MDS: Mitigation: Clear CPU buffers
[    0.087410] Freeing SMP alternatives memory: 40K
[    0.087410] smpboot: Estimated ratio of average max frequency by
base frequency (times 1024): 1235
[    0.087410] smpboot: CPU0: Intel(R) Core(TM) i7-7820HK CPU @
2.90GHz (family: 0x6, model: 0x9e, stepping: 0x9)
[    0.087410] Performance Events: PEBS fmt3+, Skylake events, 32-deep
LBR, full-width counters, Intel PMU driver.
[    0.087410] ... version:                4
[    0.087410] ... bit width:              48
[    0.087410] ... generic registers:      4
[    0.087410] ... value mask:             0000ffffffffffff
[    0.087410] ... max period:             00007fffffffffff
[    0.087410] ... fixed-purpose events:   3
[    0.087410] ... event mask:             000000070000000f
[    0.087410] rcu: Hierarchical SRCU implementation.
[    0.087410] NMI watchdog: Enabled. Permanently consumes one hw-PMU count=
er.
[    0.087410] smp: Bringing up secondary CPUs ...
[    0.087410] x86: Booting SMP configuration:
[    0.087410] .... node  #0, CPUs:      #1 #2 #3 #4
[    0.094718] MDS CPU bug present and SMT on, data leak possible. See
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html
for more details.
[    0.094718]  #5 #6 #7
[    0.095926] smp: Brought up 1 node, 8 CPUs
[    0.095926] smpboot: Max logical packages: 1
[    0.095926] smpboot: Total of 8 processors activated (46398.17 BogoMIPS)
[    0.096648] ACPI: PM: Registering ACPI NVS region [mem
0x850d7000-0x850d7fff] (4096 bytes)
[    0.096648] ACPI: PM: Registering ACPI NVS region [mem
0x8cb9a000-0x8cf3dfff] (3817472 bytes)
[    0.096648] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.096648] futex hash table entries: 2048 (order: 5, 131072 bytes, line=
ar)
[    0.096648] pinctrl core: initialized pinctrl subsystem
[    0.096772] PM: RTC time: 09:24:51, date: 2021-10-22
[    0.096823] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.096899] DMA: preallocated 1024 KiB GFP_KERNEL pool for atomic alloca=
tions
[    0.096903] DMA: preallocated 1024 KiB GFP_KERNEL|GFP_DMA pool for
atomic allocations
[    0.096907] DMA: preallocated 1024 KiB GFP_KERNEL|GFP_DMA32 pool
for atomic allocations
[    0.096912] audit: initializing netlink subsys (disabled)
[    0.096917] audit: type=3D2000 audit(1634894691.010:1):
state=3Dinitialized audit_enabled=3D0 res=3D1
[    0.096917] ramoops: using module parameters
[    0.096917] ramoops: error in header, 4
[    0.098149] printk: console [ramoops-1] enabled
[    0.098163] pstore: Registered ramoops as persistent store backend
[    0.098164] ramoops: using 0x100000@0x500000, ecc: 16
[    0.098220] thermal_sys: Registered thermal governor 'bang_bang'
[    0.098221] thermal_sys: Registered thermal governor 'step_wise'
[    0.098222] thermal_sys: Registered thermal governor 'user_space'
[    0.098230] cpuidle: using governor ladder
[    0.098233] cpuidle: using governor menu
[    0.098260] ACPI: bus type PCI registered
[    0.098260] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.098260] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.098260] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E82=
0
[    0.098260] PCI: Using configuration type 1 for base access
[    0.098552] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.100446] ACPI: Added _OSI(Module Device)
[    0.100448] ACPI: Added _OSI(Processor Device)
[    0.100448] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.100449] ACPI: Added _OSI(Processor Aggregator Device)
[    0.100450] ACPI: Added _OSI(Linux-Dell-Video)
[    0.100451] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.100452] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.133862] ACPI: 10 ACPI AML tables successfully acquired and loaded
[    0.138656] ACPI: Dynamic OEM Table Load:
[    0.138667] ACPI: SSDT 0xFFFF94B400B10800 000672 (v02 PmRef
Cpu0Ist  00003000 INTL 20160422)
[    0.139524] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.140631] ACPI: Dynamic OEM Table Load:
[    0.140635] ACPI: SSDT 0xFFFF94B400E2CC00 0003FF (v02 PmRef
Cpu0Cst  00003001 INTL 20160422)
[    0.141469] ACPI: Dynamic OEM Table Load:
[    0.141473] ACPI: SSDT 0xFFFF94B400239C00 000115 (v02 PmRef
Cpu0Hwp  00003000 INTL 20160422)
[    0.142190] ACPI: Dynamic OEM Table Load:
[    0.142193] ACPI: SSDT 0xFFFF94B40023AA00 0001A4 (v02 PmRef  HwpLvt
  00003000 INTL 20160422)
[    0.143166] ACPI: Dynamic OEM Table Load:
[    0.143171] ACPI: SSDT 0xFFFF94B400B16800 00065C (v02 PmRef  ApIst
  00003000 INTL 20160422)
[    0.144183] ACPI: Dynamic OEM Table Load:
[    0.144186] ACPI: SSDT 0xFFFF94B400238C00 000197 (v02 PmRef  ApHwp
  00003000 INTL 20160422)
[    0.144994] ACPI: Dynamic OEM Table Load:
[    0.144998] ACPI: SSDT 0xFFFF94B400234200 00018A (v02 PmRef  ApCst
  00003000 INTL 20160422)
[    0.148652] ACPI: Interpreter enabled
[    0.148689] ACPI: PM: (supports S0 S3 S4 S5)
[    0.148690] ACPI: Using IOAPIC for interrupt routing
[    0.148724] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=3Dnocrs" and report a bug
[    0.149507] ACPI: Enabled 6 GPEs in block 00 to 7F
[    0.152805] ACPI: PM: Power Resource [WRST]
[    0.153021] ACPI: PM: Power Resource [WRST]
[    0.153239] ACPI: PM: Power Resource [WRST]
[    0.153457] ACPI: PM: Power Resource [WRST]
[    0.153670] ACPI: PM: Power Resource [WRST]
[    0.153886] ACPI: PM: Power Resource [WRST]
[    0.154105] ACPI: PM: Power Resource [WRST]
[    0.154320] ACPI: PM: Power Resource [WRST]
[    0.154548] ACPI: PM: Power Resource [WRST]
[    0.154763] ACPI: PM: Power Resource [WRST]
[    0.154976] ACPI: PM: Power Resource [WRST]
[    0.155192] ACPI: PM: Power Resource [WRST]
[    0.155406] ACPI: PM: Power Resource [WRST]
[    0.155623] ACPI: PM: Power Resource [WRST]
[    0.155837] ACPI: PM: Power Resource [WRST]
[    0.156050] ACPI: PM: Power Resource [WRST]
[    0.156263] ACPI: PM: Power Resource [WRST]
[    0.157253] ACPI: PM: Power Resource [WRST]
[    0.157470] ACPI: PM: Power Resource [WRST]
[    0.157687] ACPI: PM: Power Resource [WRST]
[    0.165638] ACPI: PM: Power Resource [FN00]
[    0.165697] ACPI: PM: Power Resource [FN01]
[    0.165751] ACPI: PM: Power Resource [FN02]
[    0.165802] ACPI: PM: Power Resource [FN03]
[    0.165851] ACPI: PM: Power Resource [FN04]
[    0.166676] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.166682] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI HPX-Type3]
[    0.167662] acpi PNP0A08:00: _OSC: OS now controls [PME AER
PCIeCapability LTR]
[    0.168192] PCI host bridge to bus 0000:00
[    0.168193] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window=
]
[    0.168195] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window=
]
[    0.168197] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff window]
[    0.168198] pci_bus 0000:00: root bus resource [mem
0x90000000-0xdfffffff window]
[    0.168199] pci_bus 0000:00: root bus resource [mem
0xfd000000-0xfe7fffff window]
[    0.168200] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.168305] pci 0000:00:00.0: [8086:5910] type 00 class 0x060000
[    0.168532] pci 0000:00:02.0: [8086:591b] type 00 class 0x030000
[    0.168542] pci 0000:00:02.0: reg 0x10: [mem 0xde000000-0xdeffffff 64bit=
]
[    0.168548] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff
64bit pref]
[    0.168552] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.168568] pci 0000:00:02.0: BAR 2: assigned to efifb
[    0.168727] pci 0000:00:08.0: [8086:1911] type 00 class 0x088000
[    0.168735] pci 0000:00:08.0: reg 0x10: [mem 0xdf330000-0xdf330fff 64bit=
]
[    0.168943] pci 0000:00:14.0: [8086:a12f] type 00 class 0x0c0330
[    0.168970] pci 0000:00:14.0: reg 0x10: [mem 0xdf310000-0xdf31ffff 64bit=
]
[    0.169066] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.169574] pci 0000:00:14.2: [8086:a131] type 00 class 0x118000
[    0.169597] pci 0000:00:14.2: reg 0x10: [mem 0xdf32f000-0xdf32ffff 64bit=
]
[    0.169845] pci 0000:00:16.0: [8086:a13a] type 00 class 0x078000
[    0.169866] pci 0000:00:16.0: reg 0x10: [mem 0xdf32e000-0xdf32efff 64bit=
]
[    0.169932] pci 0000:00:16.0: PME# supported from D3hot
[    0.170376] pci 0000:00:17.0: [8086:a103] type 00 class 0x010601
[    0.170406] pci 0000:00:17.0: reg 0x10: [mem 0xdf328000-0xdf329fff]
[    0.170424] pci 0000:00:17.0: reg 0x14: [mem 0xdf32d000-0xdf32d0ff]
[    0.170443] pci 0000:00:17.0: reg 0x18: [io  0xf090-0xf097]
[    0.170458] pci 0000:00:17.0: reg 0x1c: [io  0xf080-0xf083]
[    0.170474] pci 0000:00:17.0: reg 0x20: [io  0xf060-0xf07f]
[    0.170491] pci 0000:00:17.0: reg 0x24: [mem 0xdf32c000-0xdf32c7ff]
[    0.170584] pci 0000:00:17.0: PME# supported from D3hot
[    0.170876] pci 0000:00:1c.0: [8086:a112] type 01 class 0x060400
[    0.170975] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.171412] pci 0000:00:1c.3: [8086:a113] type 01 class 0x060400
[    0.171506] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.171948] pci 0000:00:1d.0: [8086:a118] type 01 class 0x060400
[    0.172037] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.172552] pci 0000:00:1e.0: [8086:a127] type 00 class 0x118000
[    0.172621] pci 0000:00:1e.0: reg 0x10: [mem 0xdf32b000-0xdf32bfff 64bit=
]
[    0.173384] pci 0000:00:1f.0: [8086:a153] type 00 class 0x060100
[    0.173722] pci 0000:00:1f.2: [8086:a121] type 00 class 0x058000
[    0.173738] pci 0000:00:1f.2: reg 0x10: [mem 0xdf324000-0xdf327fff]
[    0.174028] pci 0000:00:1f.3: [8086:a171] type 00 class 0x040300
[    0.174048] pci 0000:00:1f.3: reg 0x10: [mem 0xdf320000-0xdf323fff 64bit=
]
[    0.174076] pci 0000:00:1f.3: reg 0x20: [mem 0xdf300000-0xdf30ffff 64bit=
]
[    0.174126] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.174812] pci 0000:00:1f.4: [8086:a123] type 00 class 0x0c0500
[    0.174870] pci 0000:00:1f.4: reg 0x10: [mem 0xdf32a000-0xdf32a0ff 64bit=
]
[    0.174940] pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[    0.175258] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.175279] pci 0000:01:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.175306] pci 0000:01:00.0: reg 0x18: [mem 0xdf204000-0xdf204fff 64bit=
]
[    0.175324] pci 0000:01:00.0: reg 0x20: [mem 0xdf200000-0xdf203fff 64bit=
]
[    0.175449] pci 0000:01:00.0: supports D1 D2
[    0.175450] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.175736] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.175740] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.175743] pci 0000:00:1c.0:   bridge window [mem 0xdf200000-0xdf2fffff=
]
[    0.175842] pci 0000:02:00.0: [8086:2723] type 00 class 0x028000
[    0.175865] pci 0000:02:00.0: reg 0x10: [mem 0xdf100000-0xdf103fff 64bit=
]
[    0.175995] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.176260] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    0.176265] pci 0000:00:1c.3:   bridge window [mem 0xdf100000-0xdf1fffff=
]
[    0.176360] pci 0000:03:00.0: [15b7:5006] type 00 class 0x010802
[    0.176383] pci 0000:03:00.0: reg 0x10: [mem 0xdf000000-0xdf003fff 64bit=
]
[    0.176420] pci 0000:03:00.0: reg 0x20: [mem 0xdf004000-0xdf0040ff 64bit=
]
[    0.176819] pci 0000:00:1d.0: PCI bridge to [bus 03]
[    0.176826] pci 0000:00:1d.0:   bridge window [mem 0xdf000000-0xdf0fffff=
]
[    0.176857] pci_bus 0000:00: on NUMA node 0
[    0.178395] ACPI: PCI: Interrupt link LNKA configured for IRQ 11
[    0.178437] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[    0.178478] ACPI: PCI: Interrupt link LNKC configured for IRQ 11
[    0.178519] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[    0.178559] ACPI: PCI: Interrupt link LNKE configured for IRQ 11
[    0.178599] ACPI: PCI: Interrupt link LNKF configured for IRQ 11
[    0.178640] ACPI: PCI: Interrupt link LNKG configured for IRQ 11
[    0.178681] ACPI: PCI: Interrupt link LNKH configured for IRQ 11
[    0.182740] iommu: Default domain type: Translated
[    0.182741] iommu: DMA domain TLB invalidation policy: lazy mode
[    0.182754] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.182757] pci 0000:00:02.0: vgaarb: VGA device added:
decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
[    0.182762] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.182762] vgaarb: loaded
[    0.182811] SCSI subsystem initialized
[    0.182816] libata version 3.00 loaded.
[    0.182819] ACPI: bus type USB registered
[    0.182832] usbcore: registered new interface driver usbfs
[    0.182838] usbcore: registered new interface driver hub
[    0.182843] usbcore: registered new device driver usb
[    0.182862] mc: Linux media interface: v0.10
[    0.182866] videodev: Linux video capture interface: v2.00
[    0.182880] EDAC MC: Ver: 3.0.0
[    0.182880] Registered efivars operations
[    0.182880] PCI: Using ACPI for IRQ routing
[    0.211190] PCI: pci_cache_line_size set to 64 bytes
[    0.211273] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.211275] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.211275] e820: reserve RAM buffer [mem 0x850d7000-0x87ffffff]
[    0.211277] e820: reserve RAM buffer [mem 0x8805d000-0x8bffffff]
[    0.211278] e820: reserve RAM buffer [mem 0x8ac24000-0x8bffffff]
[    0.211279] e820: reserve RAM buffer [mem 0x8bea8000-0x8bffffff]
[    0.211279] e820: reserve RAM buffer [mem 0x8cb9a000-0x8fffffff]
[    0.211280] e820: reserve RAM buffer [mem 0x8d400000-0x8fffffff]
[    0.211281] e820: reserve RAM buffer [mem 0x26f000000-0x26fffffff]
[    0.211356] clocksource: Switched to clocksource tsc-early
[    0.214679] VFS: Disk quotas dquot_6.6.0
[    0.214690] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    0.214715] pnp: PnP ACPI init
[    0.214913] system 00:00: [io  0x0a00-0x0a2f] has been reserved
[    0.214916] system 00:00: [io  0x0a30-0x0a3f] has been reserved
[    0.214918] system 00:00: [io  0x0a40-0x0a4f] has been reserved
[    0.215102] system 00:03: [io  0x0680-0x069f] has been reserved
[    0.215104] system 00:03: [io  0xffff] has been reserved
[    0.215105] system 00:03: [io  0xffff] has been reserved
[    0.215106] system 00:03: [io  0xffff] has been reserved
[    0.215107] system 00:03: [io  0x1800-0x18fe] has been reserved
[    0.215109] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.215190] system 00:04: [io  0x0800-0x087f] has been reserved
[    0.215229] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.215408] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.215410] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.215414] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.215416] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
[    0.215417] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.215418] system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.215419] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.215421] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.215422] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.215424] system 00:07: [mem 0xdffe0000-0xdfffffff] has been reserved
[    0.215457] system 00:08: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.215459] system 00:08: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.215460] system 00:08: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.215461] system 00:08: [mem 0xfe000000-0xfe01ffff] could not be reser=
ved
[    0.215463] system 00:08: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.215464] system 00:08: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.215465] system 00:08: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.215732] system 00:09: [io  0xff00-0xfffe] has been reserved
[    0.216718] system 00:0a: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.216720] system 00:0a: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.216721] system 00:0a: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.217445] pnp: PnP ACPI: found 11 devices
[    0.222439] clocksource: acpi_pm: mask: 0xffffff max_cycles:
0xffffff, max_idle_ns: 2085701024 ns
[    0.222467] NET: Registered PF_INET protocol family
[    0.222537] IP idents hash table entries: 131072 (order: 8, 1048576
bytes, linear)
[    0.223402] tcp_listen_portaddr_hash hash table entries: 4096
(order: 4, 65536 bytes, linear)
[    0.223423] TCP established hash table entries: 65536 (order: 7,
524288 bytes, linear)
[    0.223491] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes, linear)
[    0.223625] TCP: Hash tables configured (established 65536 bind 65536)
[    0.223646] UDP hash table entries: 4096 (order: 5, 131072 bytes, linear=
)
[    0.223661] UDP-Lite hash table entries: 4096 (order: 5, 131072
bytes, linear)
[    0.223697] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.223706] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.223710] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.223716] pci 0000:00:1c.0:   bridge window [mem 0xdf200000-0xdf2fffff=
]
[    0.223726] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    0.223731] pci 0000:00:1c.3:   bridge window [mem 0xdf100000-0xdf1fffff=
]
[    0.223742] pci 0000:00:1d.0: PCI bridge to [bus 03]
[    0.223746] pci 0000:00:1d.0:   bridge window [mem 0xdf000000-0xdf0fffff=
]
[    0.223756] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.223758] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.223759] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    0.223760] pci_bus 0000:00: resource 7 [mem 0x90000000-0xdfffffff windo=
w]
[    0.223761] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff windo=
w]
[    0.223763] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.223764] pci_bus 0000:01: resource 1 [mem 0xdf200000-0xdf2fffff]
[    0.223765] pci_bus 0000:02: resource 1 [mem 0xdf100000-0xdf1fffff]
[    0.223766] pci_bus 0000:03: resource 1 [mem 0xdf000000-0xdf0fffff]
[    0.223857] pci 0000:00:02.0: Video device with shadowed ROM at
[mem 0x000c0000-0x000dffff]
[    0.224100] PCI: CLS 64 bytes, default 64
[    0.224109] DMAR: Host address width 39
[    0.224110] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.224117] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap
1c0000c40660462 ecap 19e2ff0505e
[    0.224119] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.224124] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap
d2008c40660462 ecap f050da
[    0.224126] DMAR: RMRR base: 0x0000008c444000 end: 0x0000008c463fff
[    0.224128] DMAR: RMRR base: 0x0000008d800000 end: 0x0000008fffffff
[    0.224129] DMAR: ANDD device: 9 name: \_SB.PCI0.UA00
[    0.224133] DMAR: ACPI device "device:77" under DMAR at fed91000 as 00:1=
e.0
[    0.224140] Trying to unpack rootfs image as initramfs...
[    0.224143] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.224144] software IO TLB: mapped [mem
0x000000007fe64000-0x0000000083e64000] (64MB)
[    0.224208] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters,
655360 ms ovfl timer
[    0.224209] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    0.224210] RAPL PMU: hw unit of domain package 2^-14 Joules
[    0.224211] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    0.224212] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    0.229930] Initialise system trusted keyrings
[    0.229970] workingset: timestamp_bits=3D46 max_order=3D21 bucket_order=
=3D0
[    0.230925] zbud: loaded
[    0.231121] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.231165] fuse: init (API version 7.34)
[    0.239249] Key type asymmetric registered
[    0.239252] Asymmetric key parser 'x509' registered
[    0.239260] io scheduler mq-deadline registered
[    0.239261] io scheduler kyber registered
[    0.239278] io scheduler bfq registered
[    0.239550] pcieport 0000:00:1c.0: PME: Signaling with IRQ 120
[    0.239595] pcieport 0000:00:1c.0: AER: enabled with IRQ 120
[    0.239801] pcieport 0000:00:1c.3: PME: Signaling with IRQ 121
[    0.239842] pcieport 0000:00:1c.3: AER: enabled with IRQ 121
[    0.240022] pcieport 0000:00:1d.0: PME: Signaling with IRQ 122
[    0.240069] pcieport 0000:00:1d.0: AER: enabled with IRQ 122
[    0.240638] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.240659] ACPI: button: Sleep Button [SLPB]
[    0.240683] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.240697] ACPI: button: Power Button [PWRB]
[    0.240723] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.240757] ACPI: button: Power Button [PWRF]
[    0.240947] smpboot: Estimated ratio of average max frequency by
base frequency (times 1024): 1235
[    0.241869] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.242250] hpet_acpi_add: no address or irqs in _CRS
[    0.242270] Linux agpgart interface v0.103
[    0.242295] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    0.242296] AMD-Vi: AMD IOMMUv2 functionality not available on this syst=
em
[    0.243537] brd: module loaded
[    0.244511] loop: module loaded
[    0.244586] zram: Added device: zram0
[    0.244814] nvme nvme0: pci function 0000:03:00.0
[    0.244843] ahci 0000:00:17.0: version 3.0
[    0.245144] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 2 ports 6
Gbps 0xc impl SATA mode
[    0.245147] ahci 0000:00:17.0: flags: 64bit ncq sntf pm led clo
only pio slum part ems deso sadm sds apst
[    0.253475] nvme nvme0: 8/0/0 default/read/poll queues
[    0.256135]  nvme0n1: p1 p2
[    0.260926] scsi host0: ahci
[    0.261047] scsi host1: ahci
[    0.261125] scsi host2: ahci
[    0.261208] scsi host3: ahci
[    0.261248] ata1: DUMMY
[    0.261250] ata2: DUMMY
[    0.261254] ata3: SATA max UDMA/133 abar m2048@0xdf32c000 port
0xdf32c200 irq 124
[    0.261259] ata4: SATA max UDMA/133 abar m2048@0xdf32c000 port
0xdf32c280 irq 124
[    0.261428] tun: Universal TUN/TAP device driver, 1.6
[    0.261460] VFIO - User Level meta-driver version: 0.3
[    0.261795] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.261804] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 1
[    0.262924] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci
version 0x100 quirks 0x0000000001109810
[    0.263350] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.263353] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 2
[    0.263355] xhci_hcd 0000:00:14.0: Host supports USB 3.0 SuperSpeed
[    0.263457] hub 1-0:1.0: USB hub found
[    0.263492] hub 1-0:1.0: 16 ports detected
[    0.264526] hub 2-0:1.0: USB hub found
[    0.264546] hub 2-0:1.0: 8 ports detected
[    0.265086] usbcore: registered new interface driver usb-storage
[    0.265109] userial_init: registered 8 ttyGS* devices
[    0.265161] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    0.265899] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.265929] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.265985] mousedev: PS/2 mouse device common for all mice
[    0.266044] rtc_cmos 00:05: RTC can wake from S4
[    0.266464] rtc rtc0: alarm rollover: day
[    0.266642] rtc_cmos 00:05: char device (250:0)
[    0.266645] rtc_cmos 00:05: registered as rtc0
[    0.266780] rtc_cmos 00:05: setting system clock to
2021-10-22T09:24:51 UTC (1634894691)
[    0.266793] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram
[    0.266966] device-mapper: ioctl: 4.45.0-ioctl (2021-03-22)
initialised: dm-devel@redhat.com
[    0.266974] intel_pstate: Intel P-state driver initializing
[    0.267327] intel_pstate: Disabling energy efficiency optimization
[    0.267328] intel_pstate: HWP enabled
[    0.267339] sdhci: Secure Digital Host Controller Interface driver
[    0.267340] sdhci: Copyright(c) Pierre Ossman
[    0.267358] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.267553] efifb: probing for efifb
[    0.267569] efifb: showing boot graphics
[    0.268784] efifb: framebuffer at 0xc0000000, using 16000k, total 16000k
[    0.268785] efifb: mode is 2560x1600x32, linelength=3D10240, pages=3D1
[    0.268786] efifb: scrolling: redraw
[    0.268787] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.268806] fbcon: Deferring console take-over
[    0.268807] fb0: EFI VGA frame buffer device
[    0.268825] hid: raw HID events driver (C) Jiri Kosina
[    0.268865] usbcore: registered new interface driver usbhid
[    0.268865] usbhid: USB HID core driver
[    0.268942] ashmem: initialized
[    0.268996] resource sanity check: requesting [mem
0xfdffe800-0xfe0007ff], which spans more than pnp 00:08 [mem
0xfdb00000-0xfdffffff]
[    0.268998] caller pmc_core_probe+0xaa/0x680 mapping multiple BARs
[    0.269009] intel_pmc_core INT33A1:00:  initialized
[    0.269086] GACT probability NOT on
[    0.269088] Mirror/redirect action on
[    0.269089] netem: version 1.3
[    0.269089] u32 classifier
[    0.269090]     input device check on
[    0.269090]     Actions configured
[    0.269546] xt_time: kernel timezone is -0000
[    0.269585] Initializing XFRM netlink socket
[    0.269647] NET: Registered PF_INET6 protocol family
[    0.269833] Segment Routing with IPv6
[    0.269836] In-situ OAM (IOAM) with IPv6
[    0.269850] mip6: Mobile IPv6
[    0.269858] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    0.270028] NET: Registered PF_PACKET protocol family
[    0.270030] NET: Registered PF_KEY protocol family
[    0.270033] NET: Registered PF_PHONET protocol family
[    0.270326] microcode: sig=3D0x906e9, pf=3D0x20, revision=3D0xde
[    0.270351] microcode: Microcode Update Driver: v2.2.
[    0.270354] IPI shorthand broadcast: enabled
[    0.270361] sched_clock: Marking stable (266043372,
4239037)->(291803746, -21521337)
[    0.270521] registered taskstats version 1
[    0.270523] Loading compiled-in X.509 certificates
[    0.270557] Key type ._fscrypt registered
[    0.270558] Key type .fscrypt registered
[    0.270559] Key type fscrypt-provisioning registered
[    0.270676] pstore: Using crash dump compression: zstd
[    0.270743] PM:   Magic number: 9:7:425
[    0.270926] PM: Image not found (code -22)
[    0.315624] Freeing initrd memory: 7208K
[    0.504494] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[    0.572508] ata4: SATA link down (SStatus 4 SControl 300)
[    0.572558] ata3: SATA link down (SStatus 4 SControl 300)
[    0.577096] Freeing unused decrypted memory: 2036K
[    0.577663] Freeing unused kernel image (initmem) memory: 1624K
[    0.577756] Write protecting the kernel read-only data: 22528k
[    0.578668] Freeing unused kernel image (text/rodata gap) memory: 2036K
[    0.579032] Freeing unused kernel image (rodata/data gap) memory: 632K
[    0.579093] rodata_test: all tests were successful
[    0.579106] Run /init as init process
[    0.579108]   with arguments:
[    0.579110]     /init
[    0.579112]   with environment:
[    0.579114]     HOME=3D/
[    0.579115]     TERM=3Dlinux
[    0.579117]     BOOT_IMAGE=3D/32/kernel
[    0.579119]     SRC=3Dq
[    0.579120]     mnt=3D422c65cf-53c6-4e63-8619-298ce0f01129
[    0.579122]     RAMDISK=3D1ramdisk.img
[    0.579123]     system=3D
[    0.579125]     DATA=3D
[    0.579126]     buildvariant=3Duserdebug
[    0.579128]     DEBUG=3D1
[    0.580535] fbcon: Taking over console
[    0.580701] Console: switching to colour frame buffer device 320x100
[    0.635235] hub 1-1:1.0: USB hub found
[    0.635570] hub 1-1:1.0: 4 ports detected
[    0.745618] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    0.762100] hub 2-1:1.0: USB hub found
[    0.762385] hub 2-1:1.0: 4 ports detected
[    0.819103] random: fast init done
[    0.873441] usb 1-9: new full-speed USB device number 3 using xhci_hcd
[    1.063455] usb 1-1.1: new low-speed USB device number 4 using xhci_hcd
[    1.148788] input: PixArt USB Optical Mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:093A:2510.00=
01/input/input3
[    1.148860] hid-generic 0003:093A:2510.0001: input,hidraw0: USB HID
v1.11 Mouse [PixArt USB Optical Mouse] on usb-0000:00:14.0-1.1/input0
[    1.269452] tsc: Refined TSC clocksource calibration: 2903.998 MHz
[    1.269457] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x29dc03c1beb, max_idle_ns: 440795205215 ns
[    1.269502] clocksource: Switched to clocksource tsc
[    2.926526] random: crng init done
[    3.959202] EXT4-fs (nvme0n1p1): mounted filesystem with ordered
data mode. Opts: (null). Quota mode: none.
[    4.017383] loop0: detected capacity change from 0 to 1126832
[    4.064934] loop1: detected capacity change from 0 to 2654208
[    4.116550] EXT4-fs (loop1): mounted filesystem with ordered data
mode. Opts: (null). Quota mode: none.
[    4.165793] EXT4-fs (nvme0n1p1): re-mounted. Opts: (null). Quota mode: n=
one.
[    4.172059] magiskinit: cmdline: [BOOT_IMAGE]=3D[/32/kernel]
[    4.172068] magiskinit: cmdline: [root]=3D[/dev/ram0]
[    4.172074] magiskinit: cmdline: [SRC]=3D[q]
[    4.172080] magiskinit: cmdline: [mnt]=3D[422c65cf-53c6-4e63-8619-298ce0=
f01129]
[    4.172085] magiskinit: cmdline: [resume]=3D[/dev/nvme0n1p1]
[    4.172091] magiskinit: cmdline: [resume_offset]=3D[65728512]
[    4.172096] magiskinit: cmdline: [video]=3D[2560x1600@60]
[    4.172101] magiskinit: cmdline: [RAMDISK]=3D[1ramdisk.img]
[    4.172106] magiskinit: cmdline: [system]=3D[]
[    4.172111] magiskinit: cmdline: [DATA]=3D[]
[    4.365501] printk: init: 28 output lines suppressed due to ratelimiting
[    4.365778] init: init first stage started!
[    4.375174] SELinux:  policy capability network_peer_controls=3D1
[    4.375177] SELinux:  policy capability open_perms=3D1
[    4.375177] SELinux:  policy capability extended_socket_class=3D1
[    4.375178] SELinux:  policy capability always_check_network=3D0
[    4.375178] SELinux:  policy capability cgroup_seclabel=3D0
[    4.375178] SELinux:  policy capability nnp_nosuid_transition=3D1
[    4.375179] SELinux:  policy capability genfs_seclabel_symlinks=3D0
[    4.390493] audit: type=3D1403 audit(1634894695.622:2):
auid=3D4294967295 ses=3D4294967295 lsm=3Dselinux res=3D1
[    4.390643] init: (Initializing SELinux non-enforcing took 0.02s.)
[    4.391159] init: init second stage started!
[    4.391966] init: Running restorecon...
[    4.418628] init: (Loading properties from /default.prop took 0.00s.)
[    4.419160] init: (Parsing /init.environ.rc took 0.00s.)
[    4.419283] init: (Parsing /init.usb.rc took 0.00s.)
[    4.419371] init: (Parsing /init.cm_android_x86.rc took 0.00s.)
[    4.419547] init: (Parsing /init.usb.configfs.rc took 0.00s.)
[    4.419574] init: (Parsing /init.zygote32.rc took 0.00s.)
[    4.419715] init: (Parsing /su/init.supersu.rc took 0.00s.)
[    4.419917] init: (Parsing /init.cm.rc took 0.00s.)
[    4.420128] audit: type=3D1400 audit(1634894695.651:3): avc:  denied
{ write } for  pid=3D1 comm=3D"init" name=3D"parameters" dev=3D"sysfs"
ino=3D2386 scontext=3Du:r:init:s0 tcontext=3Du:object_r:sysfs:s0 tclass=3Dd=
ir
permissive=3D1
[    4.420130] audit: type=3D1400 audit(1634894695.651:4): avc:  denied
{ add_name } for  pid=3D1 comm=3D"init" name=3D"ctrl_write_limited"
scontext=3Du:r:init:s0 tcontext=3Du:object_r:sysfs:s0 tclass=3Ddir
permissive=3D1
[    4.420132] audit: type=3D1400 audit(1634894695.651:5): avc:  denied
{ create } for  pid=3D1 comm=3D"init" name=3D"ctrl_write_limited"
scontext=3Du:r:init:s0 tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile
permissive=3D1
[    4.420318] audit: type=3D1400 audit(1634894695.651:6): avc:  denied
{ execute_no_trans } for  pid=3D607 comm=3D"init" path=3D"/init" dev=3D"tmp=
fs"
ino=3D34 scontext=3Du:r:init:s0 tcontext=3Du:object_r:init_exec:s0
tclass=3Dfile permissive=3D1
[    4.420550] ueventd: ueventd started!
[    4.421413] audit: type=3D1400 audit(1634894695.652:7): avc:  denied
{ open } for  pid=3D606 comm=3D"ueventd"
path=3D"/system/lib/modules/5.15.0-rc6-android-x86_64+/modules.alias"
dev=3D"nvme0n1p1" ino=3D37225654 scontext=3Du:r:ueventd:s0
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dfile permissive=3D1
[    4.424323] audit: type=3D1400 audit(1634894695.655:8): avc:  denied
{ sys_module } for  pid=3D607 comm=3D"modprobe" capability=3D16
scontext=3Du:r:init:s0 tcontext=3Du:r:init:s0 tclass=3Dcapability
permissive=3D1
[    4.424329] audit: type=3D1400 audit(1634894695.655:9): avc:  denied
{ module_load } for  pid=3D607 comm=3D"modprobe"
path=3D"/system/lib/modules/5.15.0-rc6-android-x86_64+/kernel/fs/sdcardfs/s=
dcardfs.ko"
dev=3D"nvme0n1p1" ino=3D37225288 scontext=3Du:r:init:s0
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dsystem permissive=3D1
[    4.425139] Registering sdcardfs 0.1
[    4.428073] audit: type=3D1400 audit(1634894695.659:10): avc:  denied
 { sys_module } for  pid=3D606 comm=3D"ueventd" capability=3D16
scontext=3Du:r:ueventd:s0 tcontext=3Du:r:ueventd:s0 tclass=3Dcapability
permissive=3D1
[    4.444299] modprobe: /sbin/modprobe mdio:000000000001110011001000000000=
00
[    4.446714] libphy: r8169: probed
[    4.446841] r8169 0000:01:00.0 eth0: RTL8168h/8111h,
00:e4:4f:68:0f:a9, XID 541, IRQ 134
[    4.446844] r8169 0000:01:00.0 eth0: jumbo features [frames: 9194
bytes, tx checksumming: ko]
[    4.468021] cfg80211: Loading compiled-in X.509 certificates for
regulatory database
[    4.468347] modprobe: /sbin/modprobe crypto-pkcs1pad(rsa,sha256)
[    4.470363] modprobe: /sbin/modprobe crypto-pkcs1pad(rsa,sha256)-all
[    4.472436] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    4.476101] Intel(R) Wireless WiFi driver for Linux
[    4.476137] iwlwifi 0000:02:00.0: enabling device (0000 -> 0002)
[    4.476625] iwlwifi 0000:02:00.0: Direct firmware load for
iwlwifi-cc-a0-66.ucode failed with error -2
[    4.476632] iwlwifi 0000:02:00.0: Direct firmware load for
iwlwifi-cc-a0-65.ucode failed with error -2
[    4.476637] iwlwifi 0000:02:00.0: Direct firmware load for
iwlwifi-cc-a0-64.ucode failed with error -2
[    4.476642] iwlwifi 0000:02:00.0: Direct firmware load for
iwlwifi-cc-a0-63.ucode failed with error -2
[    4.476647] iwlwifi 0000:02:00.0: Direct firmware load for
iwlwifi-cc-a0-62.ucode failed with error -2
[    4.476652] iwlwifi 0000:02:00.0: Direct firmware load for
iwlwifi-cc-a0-61.ucode failed with error -2
[    4.476657] iwlwifi 0000:02:00.0: Direct firmware load for
iwlwifi-cc-a0-60.ucode failed with error -2
[    4.477969] iwlwifi 0000:02:00.0: api flags index 2 larger than
supported by driver
[    4.477975] iwlwifi 0000:02:00.0: TLV_FW_FSEQ_VERSION: FSEQ
Version: 89.3.35.22
[    4.478116] iwlwifi 0000:02:00.0: loaded firmware version
59.601f3a66.0 cc-a0-59.ucode op_mode iwlmvm
[    4.478451] modprobe: /sbin/modprobe iwlmvm
[    4.478957] intel-lpss 0000:00:1e.0: enabling device (0000 -> 0002)
[    4.491783] dw-apb-uart.0: ttyS0 at MMIO 0xdf32b000 (irq =3D 20,
base_baud =3D 115200) is a 16550A
[    4.502776] iwlwifi 0000:02:00.0: Detected Intel(R) Wi-Fi 6 AX200
160MHz, REV=3D0x340
[    4.510925] thermal thermal_zone0: failed to read out thermal zone (-61)
[    4.511084] snd_hda_intel 0000:00:1f.3: enabling device (0000 -> 0002)
[    4.511609] modprobe: /sbin/modprobe i915
[    4.515623] ueventd: blacklisted module intel_pch_thermal: 1
[    4.576934] checking generic (c0000000 fa0000) vs hw (de000000 1000000)
[    4.576936] checking generic (c0000000 fa0000) vs hw (c0000000 10000000)
[    4.576937] fb0: switching to i915 from EFI VGA
[    4.576995] Console: switching to colour dummy device 80x25
[    4.577047] i915 0000:00:02.0: vgaarb: deactivate vga console
[    4.578580] i915 0000:00:02.0: vgaarb: changed VGA decodes:
olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    4.579149] i915 0000:00:02.0: [drm] Finished loading DMC firmware
i915/kbl_dmc_ver1_04.bin (v1.4)
[    4.623308] iwlwifi 0000:02:00.0: Detected RF HR B3, rfid=3D0x10a100
[    4.687941] iwlwifi 0000:02:00.0: base HW address: 78:2b:46:4f:e3:d1
[    4.847634] i915 0000:00:02.0: [drm] failed to retrieve link info,
disabling eDP
[    4.847728] i915 0000:00:02.0: [drm] [ENCODER:94:DDI B/PHY B] is
disabled/in DSI mode with an ungated DDI clock, gate it
[    4.875148] [drm] Initialized i915 1.6.0 20201103 for 0000:00:02.0 on mi=
nor 0
[    4.876595] ACPI: video: Video Device [GFX0] (multi-head: yes  rom:
no  post: no)
[    4.876783] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    4.876889] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops
i915_audio_component_bind_ops [i915])
[    4.905749] fbcon: i915 (fb0) is primary device
[    4.946870] Console: switching to colour frame buffer device 320x100
[    4.981057] i915 0000:00:02.0: [drm] fb0: i915 frame buffer device
[    5.009322] modprobe: /sbin/modprobe hdaudio:v10EC0662r00100300a01

[    5.026241] Bluetooth: Core ver 2.22
[    5.026276] NET: Registered PF_BLUETOOTH protocol family
[    5.026279] Bluetooth: HCI device and connection manager initialized
[    5.026285] Bluetooth: HCI socket layer initialized
[    5.026288] Bluetooth: L2CAP socket layer initialized
[    5.026295] Bluetooth: SCO socket layer initialized
[    5.034288] usbcore: registered new interface driver btusb
[    5.034362] snd_hda_codec_realtek hdaudioC0D0: autoconfig for
ALC662 rev3: line_outs=3D1 (0x14/0x0/0x0/0x0/0x0) type:hp
[    5.034374] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=3D0
(0x0/0x0/0x0/0x0/0x0)
[    5.034381] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D0
(0x0/0x0/0x0/0x0/0x0)
[    5.034387] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0x0
[    5.034389] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    5.034392] snd_hda_codec_realtek hdaudioC0D0:      Mic=3D0x18
[    5.034692] Bluetooth: hci0: Bootloader revision 0.3 build 0 week 24 201=
7
[    5.035746] Bluetooth: hci0: Device revision is 1
[    5.035754] Bluetooth: hci0: Secure boot is enabled
[    5.035757] Bluetooth: hci0: OTP lock is enabled
[    5.035761] Bluetooth: hci0: API lock is enabled
[    5.035762] Bluetooth: hci0: Debug lock is disabled
[    5.035764] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[    5.037271] Bluetooth: hci0: Found device firmware: intel/ibt-20-1-3.sfi
[    5.055685] modprobe: /sbin/modprobe hdaudio:v8086280Br00100000a01

[    5.064910] input: HDA Intel PCH HDMI/DP,pcm=3D3 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input5
[    5.064932] input: HDA Intel PCH HDMI/DP,pcm=3D7 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input6
[    5.064950] input: HDA Intel PCH HDMI/DP,pcm=3D8 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input7
[    5.064967] input: HDA Intel PCH HDMI/DP,pcm=3D9 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input8
[    5.064983] input: HDA Intel PCH HDMI/DP,pcm=3D10 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input9
[    5.135126] kauditd_printk_skb: 19 callbacks suppressed
[    5.135129] audit: type=3D1400 audit(1634894696.366:30): avc:  denied
 { relabelfrom } for  pid=3D606 comm=3D"ueventd" name=3D"timer" dev=3D"tmpf=
s"
ino=3D65 scontext=3Du:r:ueventd:s0 tcontext=3Du:object_r:audio_device:s0
tclass=3Dchr_file permissive=3D1
[    5.135132] audit: type=3D1400 audit(1634894696.366:31): avc:  denied
 { relabelto } for  pid=3D606 comm=3D"ueventd" name=3D"timer" dev=3D"tmpfs"
ino=3D65 scontext=3Du:r:ueventd:s0 tcontext=3Du:object_r:audio_device:s0
tclass=3Dchr_file permissive=3D1
[    5.153778] audit: type=3D1400 audit(1634894696.385:32): avc:  denied
 { relabelfrom } for  pid=3D606 comm=3D"ueventd" name=3D"event4" dev=3D"tmp=
fs"
ino=3D86 scontext=3Du:r:ueventd:s0 tcontext=3Du:object_r:input_device:s0
tclass=3Dchr_file permissive=3D1
[    5.153781] audit: type=3D1400 audit(1634894696.385:33): avc:  denied
 { relabelto } for  pid=3D606 comm=3D"ueventd" name=3D"event4" dev=3D"tmpfs=
"
ino=3D86 scontext=3Du:r:ueventd:s0 tcontext=3Du:object_r:input_device:s0
tclass=3Dchr_file permissive=3D1
[    5.170330] ueventd: Coldboot took 0.75s.
[    5.176134] cgroup: Unknown subsys name 'schedtune'
[    5.176487] audit: type=3D1400 audit(1634865896.404:34): avc:  denied
 { setattr } for  pid=3D1 comm=3D"init" name=3D"hwbinder" dev=3D"binder" in=
o=3D5
scontext=3Du:r:init:s0 tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file
permissive=3D1
[    5.177211] audit: type=3D1400 audit(1634865896.404:35): avc:  denied
 { dac_read_search } for  pid=3D1 comm=3D"init" capability=3D2
scontext=3Du:r:init:s0 tcontext=3Du:r:init:s0 tclass=3Dcapability
permissive=3D1
[    5.177270] audit: type=3D1400 audit(1634865896.404:36): avc:  denied
 { create } for  pid=3D1 comm=3D"init" name=3D"cpu.rt_period_us"
scontext=3Du:r:init:s0 tcontext=3Du:object_r:cgroup:s0 tclass=3Dfile
permissive=3D1
[    5.186078] cgroup: Unknown subsys name 'bfqio'
[    5.191647] audit: type=3D1400 audit(1634865896.419:37): avc:  denied
 { execute_no_trans } for  pid=3D647 comm=3D"init"
path=3D"/system/bin/logwrapper" dev=3D"loop1" ino=3D280 scontext=3Du:r:init=
:s0
tcontext=3Du:object_r:system_file:s0 tclass=3Dfile permissive=3D1
[    5.228264] audit: type=3D1400 audit(1634865896.455:38): avc:  denied
 { dac_read_search } for  pid=3D646 comm=3D"logd" capability=3D2
scontext=3Du:r:logd:s0 tcontext=3Du:r:logd:s0 tclass=3Dcapability
permissive=3D1
[    5.228330] audit: type=3D1400 audit(1634865896.455:39): avc:  denied
 { execute_no_trans } for  pid=3D649 comm=3D"logwrapper"
path=3D"/system/bin/sh" dev=3D"loop1" ino=3D395 scontext=3Du:r:init:s0
tcontext=3Du:object_r:shell_exec:s0 tclass=3Dfile permissive=3D1
[    5.228473] logd.auditd: start
[    5.228476] logd.klogd: 5224235590
[    5.263393] type=3D1400 audit(1634865896.490:40): avc: denied { write
} for pid=3D659 comm=3D"setprop" name=3D"property_service" dev=3D"tmpfs"
ino=3D49 scontext=3Du:r:toolbox:s0 tcontext=3Du:object_r:property_socket:s0
tclass=3Dsock_file permissive=3D1
[    5.263497] type=3D1400 audit(1634865896.490:41): avc: denied {
connectto } for pid=3D659 comm=3D"setprop"
path=3D"/dev/socket/property_service" scontext=3Du:r:toolbox:s0
tcontext=3Du:r:init:s0 tclass=3Dunix_stream_socket permissive=3D1
[    5.273594] type=3D1400 audit(1634865896.501:42): avc: denied {
getattr } for pid=3D663 comm=3D"mount" path=3D"/su/vold" dev=3D"nvme0n1p1"
ino=3D15729707 scontext=3Du:r:toolbox:s0 tcontext=3Du:object_r:vold_exec:s0
tclass=3Dfile permissive=3D1
[    5.273649] type=3D1400 audit(1634865896.501:43): avc: denied {
mounton } for pid=3D663 comm=3D"mount" path=3D"/system/bin/vold" dev=3D"loo=
p1"
ino=3D461 scontext=3Du:r:toolbox:s0 tcontext=3Du:object_r:vold_exec:s0
tclass=3Dfile permissive=3D1
[    5.276689] type=3D1400 audit(1634865896.504:44): avc: denied { write
} for pid=3D664 comm=3D"ln" name=3D"/" dev=3D"tmpfs" ino=3D1
scontext=3Du:r:toolbox:s0 tcontext=3Du:object_r:device:s0 tclass=3Ddir
permissive=3D1
[    5.276786] type=3D1400 audit(1634865896.504:45): avc: denied {
add_name } for pid=3D664 comm=3D"ln" name=3D"loop0" scontext=3Du:r:toolbox:=
s0
tcontext=3Du:object_r:device:s0 tclass=3Ddir permissive=3D1
[    5.276819] type=3D1400 audit(1634865896.504:46): avc: denied {
create } for pid=3D664 comm=3D"ln" name=3D"loop0" scontext=3Du:r:toolbox:s0
tcontext=3Du:object_r:device:s0 tclass=3Dlnk_file permissive=3D1
[    5.291638] type=3D1400 audit(1634865896.519:47): avc: denied {
search } for pid=3D666 comm=3D"swapon" name=3D"/" dev=3D"nvme0n1p1" ino=3D2
scontext=3Du:r:toolbox:s0 tcontext=3Du:object_r:unlabeled:s0 tclass=3Ddir
permissive=3D1
[    5.292944] Adding 4194300k swap on /data/f2fs/swapfile.
Priority:-2 extents:19 across:6127612k SSFS
[    5.425479] magiskinit: Mount /sbin tmpfs overlay
[    5.675705] export_store: invalid GPIO 339
[    5.677625] modprobe: /sbin/modprobe fs-overlay
[    5.684217] SELinux:  Context  is not valid (left unmapped).
[    5.945778] binder: 773:773 transaction failed 29189/-22, size 0-0 line =
2723
[    6.208088] capability: warning: `daemonsu' uses 32-bit
capabilities (legacy support in use)
[    6.506137] usb 1-1-port1: disabled by hub (EMI?), re-enabling...
[    6.506371] usb 1-1.1: USB disconnect, device number 4
[    6.692968] Bluetooth: hci0: Waiting for firmware download to complete
[    6.693696] Bluetooth: hci0: Firmware loaded in 1617597 usecs
[    6.693732] Bluetooth: hci0: Waiting for device to boot
[    6.697485] usb 1-1.1: new low-speed USB device number 5 using xhci_hcd
[    6.708730] Bluetooth: hci0: Device booted in 14657 usecs
[    6.709017] Bluetooth: hci0: Found Intel DDC parameters: intel/ibt-20-1-=
3.ddc
[    6.710712] Bluetooth: hci0: Applying Intel DDC parameters completed
[    6.713735] Bluetooth: hci0: Firmware revision 0.0 build 118 week 15 202=
1
[    6.783621] input: PixArt USB Optical Mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:093A:2510.00=
02/input/input10
[    6.783710] hid-generic 0003:093A:2510.0002: input,hidraw0: USB HID
v1.11 Mouse [PixArt USB Optical Mouse] on usb-0000:00:14.0-1.1/input0
[    6.946375] healthd: BatteryStatusPath not found
[    6.946380] healthd: BatteryHealthPath not found
[    6.946383] healthd: BatteryPresentPath not found
[    6.946387] healthd: BatteryCapacityPath not found
[    6.946390] healthd: BatteryVoltagePath not found
[    6.946394] healthd: BatteryTemperaturePath not found
[    6.946397] healthd: BatteryTechnologyPath not found
[    6.946400] healthd: BatteryCurrentNowPath not found
[    6.946403] healthd: BatteryFullChargePath not found
[    6.946406] healthd: BatteryCycleCountPath not found
[    6.983802] SELinux:  Converting 276 SID table entries...
[    6.985990] SELinux:  policy capability network_peer_controls=3D1
[    6.985991] SELinux:  policy capability open_perms=3D1
[    6.985992] SELinux:  policy capability extended_socket_class=3D1
[    6.985993] SELinux:  policy capability always_check_network=3D0
[    6.985993] SELinux:  policy capability cgroup_seclabel=3D0
[    6.985993] SELinux:  policy capability nnp_nosuid_transition=3D1
[    6.985994] SELinux:  policy capability genfs_seclabel_symlinks=3D0
[   10.358673] type=3D1400 audit(1634865901.586:445): avc: denied {
execmod } for pid=3D781 comm=3D"main"
path=3D"/system/vendor/lib/libavcodec.so" dev=3D"nvme0n1p1" ino=3D16797503
scontext=3Du:r:zygote:s0 tcontext=3Du:object_r:system_file:s0 tclass=3Dfile
permissive=3D1
[   10.558066] type=3D1400 audit(1634865901.785:446): avc: denied { read
write } for pid=3D1134 comm=3D"system_server" name=3D"binder" dev=3D"binder=
"
ino=3D4 scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   10.558267] type=3D1400 audit(1634865901.785:447): avc: denied { open
} for pid=3D1134 comm=3D"system_server" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   10.558299] type=3D1400 audit(1634865901.785:448): avc: denied {
ioctl } for pid=3D1134 comm=3D"system_server" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6209 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   10.558334] type=3D1400 audit(1634865901.785:449): avc: denied { map
} for pid=3D1134 comm=3D"system_server" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   10.678910] type=3D1400 audit(1634865901.906:450): avc: denied {
ioctl } for pid=3D1033 comm=3D"Binder:1033_1" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   10.943195] input: Android Power Button as /devices/virtual/input/input1=
1
[   10.943248] type=3D1400 audit(1634865902.170:451): avc: denied {
write } for pid=3D1134 comm=3D"system_server" name=3D"uinput" dev=3D"tmpfs"
ino=3D147 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:uhid_device:s0 tclass=3Dchr_file permissive=3D1
[   10.943280] type=3D1400 audit(1634865902.170:452): avc: denied { open
} for pid=3D1134 comm=3D"system_server" path=3D"/dev/uinput" dev=3D"tmpfs"
ino=3D147 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:uhid_device:s0 tclass=3Dchr_file permissive=3D1
[   10.943299] type=3D1400 audit(1634865902.170:453): avc: denied {
ioctl } for pid=3D1134 comm=3D"system_server" path=3D"/dev/uinput"
dev=3D"tmpfs" ino=3D147 ioctlcmd=3D0x5564 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:uhid_device:s0 tclass=3Dchr_file permissive=3D1
[   10.976241] type=3D1400 audit(1634865902.203:454): avc: denied { read
} for pid=3D1134 comm=3D"system_server"
name=3D"privapp-permissions-screenrecorder.xml" dev=3D"nvme0n1p1"
ino=3D15730885 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:adb_data_file:s0 tclass=3Dfile permissive=3D1
[   11.663409] audit_log_lost: 4 callbacks suppressed
[   11.663417] audit: audit_lost=3D332 audit_rate_limit=3D20 audit_backlog_=
limit=3D64
[   11.663418] audit: rate limit exceeded
[   17.556268] type=3D1400 audit(1634865908.783:471): avc: denied {
dac_read_search } for pid=3D785 comm=3D"installd" capability=3D2
scontext=3Du:r:installd:s0 tcontext=3Du:r:installd:s0 tclass=3Dcapability
permissive=3D1
[   17.800871] type=3D1400 audit(1634865909.028:472): avc: denied {
ioctl } for pid=3D773 comm=3D"healthd" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:healthd:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   17.889565] type=3D1400 audit(1634865909.117:473): avc: denied {
wake_alarm } for pid=3D1134 comm=3D"system_server" capability=3D35
scontext=3Du:r:system_server:s0 tcontext=3Du:r:system_server:s0
tclass=3Dcapability2 permissive=3D1
[   17.889594] type=3D1400 audit(1634865909.117:474): avc: denied {
wake_alarm } for pid=3D1134 comm=3D"system_server" capability=3D35
scontext=3Du:r:system_server:s0 tcontext=3Du:r:system_server:s0
tclass=3Dcapability2 permissive=3D1
[   18.952541] init: write_file: Unable to open
'/proc/sys/vm/extra_free_kbytes': No such file or directory
[   18.975012] type=3D1400 audit(1634865910.202:475): avc: denied {
ioctl } for pid=3D992 comm=3D"BootAnimation" path=3D"/dev/dri/renderD128"
dev=3D"tmpfs" ino=3D82 ioctlcmd=3D0x642e scontext=3Du:r:bootanim:s0
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   20.082244] type=3D1400 audit(1634865911.309:476): avc: denied {
ioctl } for pid=3D791 comm=3D"Binder:791_3" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:netd:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   20.445287] init: write_file: Unable to open
'/sys/class/android_usb/android0/enable': No such file or directory
[   20.445296] init: write_file: Unable to open
'/sys/class/android_usb/android0/bDeviceClass': No such file or
directory
[   20.528260] type=3D1400 audit(1634865911.755:477): avc: denied { read
write } for pid=3D1134 comm=3D"Thread-3" name=3D"renderD128" dev=3D"tmpfs"
ino=3D82 scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[   20.528286] type=3D1400 audit(1634865911.755:478): avc: denied { open
} for pid=3D1134 comm=3D"Thread-3" path=3D"/dev/dri/renderD128" dev=3D"tmpf=
s"
ino=3D82 scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[   20.528315] type=3D1400 audit(1634865911.755:479): avc: denied {
ioctl } for pid=3D1134 comm=3D"Thread-3" path=3D"/dev/dri/renderD128"
dev=3D"tmpfs" ino=3D82 ioctlcmd=3D0x6400 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   20.530082] type=3D1400 audit(1634865911.757:480): avc: denied {
getattr } for pid=3D1134 comm=3D"Thread-3" path=3D"/dev/dri/card0"
dev=3D"tmpfs" ino=3D83 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   20.662509] Generic FE-GE Realtek PHY r8169-0-100:00: attached PHY
driver (mii_bus:phy_addr=3Dr8169-0-100:00, irq=3DMAC)
[   20.826604] r8169 0000:01:00.0 eth0: Link is Down
[   21.126836] sdcardfs version 2.0
[   21.126838] sdcardfs: dev_name -> /data/media
[   21.126839] sdcardfs: gid=3D1015,mask=3D6
[   21.126850] sdcardfs: mounted on top of /data/media type ext4
[   21.126886] sdcardfs version 2.0
[   21.126887] sdcardfs: dev_name -> /data/media
[   21.126887] sdcardfs: gid=3D9997,mask=3D17
[   21.126890] sdcardfs: mounted on top of /data/media type ext4
[   21.126908] sdcardfs version 2.0
[   21.126908] sdcardfs: dev_name -> /data/media
[   21.126909] sdcardfs: gid=3D9997,mask=3D7
[   21.126911] sdcardfs: mounted on top of /data/media type ext4
[   21.159210] audit: audit_lost=3D333 audit_rate_limit=3D20 audit_backlog_=
limit=3D64
[   21.159213] audit: rate limit exceeded
[   21.244023] init: Starting service 'wpa_supplicant'...
[   23.437968] type=3D1400 audit(1634865914.665:571): avc: denied {
ioctl } for pid=3D782 comm=3D"AudioOut_D" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:audioserver:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   23.783962] type=3D1400 audit(1634865915.011:572): avc: denied {
search } for pid=3D1511 comm=3D"RenderThread" name=3D"com.n0n3m4.gltools"
dev=3D"nvme0n1p1" ino=3D25428439 scontext=3Du:r:system_app:s0
tcontext=3Du:object_r:app_data_file:s0:c512,c768 tclass=3Ddir permissive=3D=
1
[   24.025537] r8169 0000:01:00.0 eth0: Link is Up - 1Gbps/Full - flow
control off
[   24.025557] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.091579] type=3D1400 audit(1634865916.319:573): avc: denied {
ioctl } for pid=3D791 comm=3D"Binder:791_7" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:netd:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   25.098595] type=3D1400 audit(1634865916.326:574): avc: denied {
ioctl } for pid=3D777 comm=3D"Binder:777_2" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:surfaceflinger:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   25.103816] type=3D1400 audit(1634865916.331:575): avc: denied {
ioctl } for pid=3D776 comm=3D"servicemanager" path=3D"/dev/binderfs/binder"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:servicemanager:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   25.108344] init: write_file: Unable to open
'/proc/sys/net/ipv4/tcp_default_init_rwnd': No such file or directory
[   25.108535] init: Starting service 'exec 5 (/system/bin/logwrapper)'...
[   25.108919] type=3D1400 audit(1634865916.336:576): avc: denied {
execute_no_trans } for pid=3D1635 comm=3D"init"
path=3D"/system/bin/logwrapper" dev=3D"loop1" ino=3D280 scontext=3Du:r:init=
:s0
tcontext=3Du:object_r:system_file:s0 tclass=3Dfile permissive=3D1
[   25.112042] type=3D1400 audit(1634865916.339:577): avc: denied {
execute_no_trans } for pid=3D1636 comm=3D"logwrapper"
path=3D"/system/bin/sh" dev=3D"loop1" ino=3D395 scontext=3Du:r:init:s0
tcontext=3Du:object_r:shell_exec:s0 tclass=3Dfile permissive=3D1
[   25.118839] type=3D1400 audit(1634865916.346:578): avc: denied {
write } for pid=3D1641 comm=3D"getprop" path=3D"pipe:[17885]" dev=3D"pipefs=
"
ino=3D17885 scontext=3Du:r:toolbox:s0 tcontext=3Du:r:init:s0
tclass=3Dfifo_file permissive=3D1
[   25.119509] type=3D1400 audit(1634865916.346:579): avc: denied {
ioctl } for pid=3D1511 comm=3D"RenderThread" path=3D"/dev/dri/renderD128"
dev=3D"tmpfs" ino=3D82 ioctlcmd=3D0x642e scontext=3Du:r:system_app:s0
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   25.122337] type=3D1400 audit(1634865916.349:580): avc: denied {
getattr } for pid=3D1641 comm=3D"getprop" path=3D"pipe:[17885]" dev=3D"pipe=
fs"
ino=3D17885 scontext=3Du:r:toolbox:s0 tcontext=3Du:r:init:s0
tclass=3Dfifo_file permissive=3D1
[   25.126134] netpoll: netconsole: couldn't parse config at ''!
[   25.126136] netconsole: cleaning up
[   25.146622] init: Service 'exec 5 (/system/bin/logwrapper)' (pid
1635) exited with status 0
[   26.843126] init: Service 'bootanim' (pid 992) exited with status 0
[   27.007186] init: Starting service 'kQt11hU9nomI'...
[   27.007359] init: Starting service 'exec 6 (/system/bin/logwrapper)'...
[   27.011136] init: Service 'kQt11hU9nomI' (pid 1662) exited with status 0
[   27.037751] init: Service 'exec 6 (/system/bin/logwrapper)' (pid
1663) exited with status 0
[   27.038021] init: Starting service 'exec 7 (/system/bin/bootstat)'...
[   27.043735] init: Service 'exec 7 (/system/bin/bootstat)' (pid
1676) exited with status 0
[   27.163747] audit: audit_lost=3D393 audit_rate_limit=3D20 audit_backlog_=
limit=3D64
[   27.163750] audit: rate limit exceeded
[   27.774093] netpoll: netconsole: couldn't parse config at ''!
[   27.774096] netconsole: cleaning up
[   28.467385] type=3D1400 audit(1634894719.619:673): avc: denied { read
write } for pid=3D1782 comm=3D"s.nexuslauncher" name=3D"renderD128"
dev=3D"tmpfs" ino=3D82 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   28.467514] type=3D1400 audit(1634894719.619:674): avc: denied { open
} for pid=3D1782 comm=3D"s.nexuslauncher" path=3D"/dev/dri/renderD128"
dev=3D"tmpfs" ino=3D82 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   28.467589] type=3D1400 audit(1634894719.619:675): avc: denied {
ioctl } for pid=3D1782 comm=3D"s.nexuslauncher" path=3D"/dev/dri/renderD128=
"
dev=3D"tmpfs" ino=3D82 ioctlcmd=3D0x6400
scontext=3Du:r:untrusted_app:s0:c512,c768 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[   28.484128] type=3D1400 audit(1634894719.636:676): avc: denied { read
} for pid=3D1782 comm=3D"RenderThread" name=3D"dri" dev=3D"tmpfs" ino=3D81
scontext=3Du:r:untrusted_app:s0:c512,c768 tcontext=3Du:object_r:device:s0
tclass=3Ddir permissive=3D1
[   28.484294] type=3D1400 audit(1634894719.636:677): avc: denied { open
} for pid=3D1782 comm=3D"RenderThread" path=3D"/dev/dri" dev=3D"tmpfs" ino=
=3D81
scontext=3Du:r:untrusted_app:s0:c512,c768 tcontext=3Du:object_r:device:s0
tclass=3Ddir permissive=3D1
[   28.484351] type=3D1400 audit(1634894719.636:678): avc: denied {
getattr } for pid=3D1782 comm=3D"RenderThread" path=3D"/dev/dri/card0"
dev=3D"tmpfs" ino=3D83 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   28.484406] type=3D1400 audit(1634894719.636:679): avc: denied {
getattr } for pid=3D1782 comm=3D"RenderThread" path=3D"/sys/dev/char/226:0"
dev=3D"sysfs" ino=3D26814 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dlnk_file permissive=3D1
[   28.484871] type=3D1400 audit(1634894719.636:680): avc: denied { read
} for pid=3D1782 comm=3D"RenderThread" name=3D"uevent" dev=3D"sysfs" ino=3D=
6087
scontext=3Du:r:untrusted_app:s0:c512,c768 tcontext=3Du:object_r:sysfs:s0
tclass=3Dfile permissive=3D1
[   28.484936] type=3D1400 audit(1634894719.636:681): avc: denied { open
} for pid=3D1782 comm=3D"RenderThread"
path=3D"/sys/devices/pci0000:00/0000:00:02.0/uevent" dev=3D"sysfs"
ino=3D6087 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[   28.484983] type=3D1400 audit(1634894719.637:682): avc: denied {
getattr } for pid=3D1782 comm=3D"RenderThread"
path=3D"/sys/devices/pci0000:00/0000:00:02.0/uevent" dev=3D"sysfs"
ino=3D6087 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[   28.949901] audit: audit_lost=3D452 audit_rate_limit=3D20 audit_backlog_=
limit=3D64
[   28.949904] audit: rate limit exceeded
[   29.961074] audit: audit_lost=3D464 audit_rate_limit=3D20 audit_backlog_=
limit=3D64
[   29.961077] audit: rate limit exceeded
[   30.314173] usb 1-1-port1: disabled by hub (EMI?), re-enabling...
[   30.314407] usb 1-1.1: USB disconnect, device number 5
[   30.507423] usb 1-1.1: new low-speed USB device number 6 using xhci_hcd
[   30.592202] input: PixArt USB Optical Mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:093A:2510.00=
03/input/input12
[   30.592298] hid-generic 0003:093A:2510.0003: input,hidraw0: USB HID
v1.11 Mouse [PixArt USB Optical Mouse] on usb-0000:00:14.0-1.1/input0
[   30.672330] wlan0: authenticate with b4:a8:98:22:f9:ac
[   30.676012] wlan0: send auth to b4:a8:98:22:f9:ac (try 1/3)
[   30.713090] wlan0: authenticated
[   30.713425] wlan0: associate with b4:a8:98:22:f9:ac (try 1/3)
[   30.722415] wlan0: RX AssocResp from b4:a8:98:22:f9:ac
(capab=3D0x1531 status=3D0 aid=3D4)
[   30.726271] wlan0: associated
[   30.736618] modprobe: /sbin/modprobe crypto-ccm(aes)
[   30.739078] modprobe: /sbin/modprobe crypto-ccm(aes)-all
[   30.743562] modprobe: /sbin/modprobe crypto-ccm
[   30.747298] modprobe: /sbin/modprobe crypto-cbcmac(aes)
[   30.750745] modprobe: /sbin/modprobe crypto-cbcmac(aes)-all
[   30.754081] modprobe: /sbin/modprobe crypto-ctr(aes)
[   30.757385] modprobe: /sbin/modprobe crypto-ctr(aes)-all
[   30.972454] init: Service 'logcat' is being killed...
[   30.974496] init: Service 'logcat' (pid 779) killed by signal 9
[   30.974504] init: Service 'logcat' (pid 779) killing any children
in process group
[   30.977568] init: Service 'logd' is being killed...
[   30.983890] printk: logd.auditd: 192 output lines suppressed due to
ratelimiting
[   30.984005] init: Service 'logd' (pid 646) killed by signal 9
[   30.984011] init: Service 'logd' (pid 646) killing any children in
process group
[   30.984801] init: Untracked pid 1038 exited with status 1
[   30.999376] audit: audit_lost=3D504 audit_rate_limit=3D20 audit_backlog_=
limit=3D64
[   30.999380] audit: rate limit exceeded
[   30.999565] binder: 789:1458 transaction failed 29189/-22, size
60-0 line 2723
[   31.000054] binder: 1134:1251 transaction failed 29189/-22, size
348-0 line 2723
[   31.004064] binder: 1134:1134 transaction failed 29189/-22, size
96-0 line 2723
[   31.081809] audit: type=3D1400 audit(1634894722.234:795): avc:
denied  { search } for  pid=3D2664 comm=3D"android.vending" name=3D"/"
dev=3D"binder" ino=3D1 scontext=3Du:r:priv_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Ddir permissive=3D1
[   31.095825] audit: type=3D1400 audit(1634894722.248:796): avc:
denied  { search } for  pid=3D2680 comm=3D"onelli.juicessh" name=3D"/"
dev=3D"binder" ino=3D1 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Ddir permissive=3D1
[   31.193446] init: write_file: Unable to open
'/sys/class/android_usb/android0/enable': No such file or directory
[   31.193456] init: write_file: Unable to open
'/sys/class/android_usb/android0/bDeviceClass': No such file or
directory
[   31.208820] it87: Found IT8728F chip at 0xa40, revision 0
[   31.208887] it87: Beeping is supported
[   31.264573] modprobe: /sbin/modprobe char-major-10-125
[   31.267613] qtaguid: ctrl_cmd_tag(): User space forgot to open
/dev/xt_qtaguid? pid=3D1994 tgid=3D1865 uid=3D10020
[   31.467596] binder: 1134:1134 transaction failed 29189/-22, size
84-0 line 2723
[   31.674287] binder: 1134:1148 transaction failed 29189/-22, size
0-0 line 2723
[   32.205976] kauditd_printk_skb: 23 callbacks suppressed
[   32.205980] audit: type=3D1400 audit(1634894723.358:858): avc:
denied  { getattr } for  pid=3D781 comm=3D"main"
path=3D"/system/framework/XposedBridge.jar" dev=3D"nvme0n1p1" ino=3D1573051=
3
scontext=3Du:r:zygote:s0 tcontext=3Du:object_r:adb_data_file:s0
tclass=3Dfile permissive=3D1
[   32.210019] audit: type=3D1400 audit(1634894723.362:859): avc:
denied  { read } for  pid=3D3103 comm=3D"main" name=3D"XposedBridge.jar"
dev=3D"nvme0n1p1" ino=3D15730513 scontext=3Du:r:zygote:s0
tcontext=3Du:object_r:adb_data_file:s0 tclass=3Dfile permissive=3D1
[   32.210042] audit: type=3D1400 audit(1634894723.362:860): avc:
denied  { open } for  pid=3D3103 comm=3D"main"
path=3D"/system/framework/XposedBridge.jar" dev=3D"nvme0n1p1" ino=3D1573051=
3
scontext=3Du:r:zygote:s0 tcontext=3Du:object_r:adb_data_file:s0
tclass=3Dfile permissive=3D1
[   34.075975] audit: type=3D1400 audit(1634894725.228:861): avc:
denied  { module_request } for  pid=3D2497 comm=3D4173796E635461736B202332
kmod=3D"char-major-10-125" scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:r:kernel:s0 tclass=3Dsystem permissive=3D1
[   34.077178] modprobe: /sbin/modprobe char-major-10-125
[   34.984652] audit: type=3D1400 audit(1634894726.137:862): avc:
denied  { ioctl } for  pid=3D782 comm=3D"audioserver"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:audioserver:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   34.986870] audit: type=3D1400 audit(1634894726.139:863): avc:
denied  { search } for  pid=3D782 comm=3D"audioserver" name=3D"/"
dev=3D"tmpfs" ino=3D1 scontext=3Du:r:audioserver:s0
tcontext=3Du:object_r:tmpfs:s0 tclass=3Ddir permissive=3D1
[   35.467495] audit: type=3D1400 audit(1634894726.619:864): avc:
denied  { read } for  pid=3D3177 comm=3D"RenderThread" name=3D"dri"
dev=3D"tmpfs" ino=3D81 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:device:s0 tclass=3Ddir permissive=3D1
[   35.467504] audit: type=3D1400 audit(1634894726.620:865): avc:
denied  { open } for  pid=3D3177 comm=3D"RenderThread" path=3D"/dev/dri"
dev=3D"tmpfs" ino=3D81 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:device:s0 tclass=3Ddir permissive=3D1
[   37.218283] audit: type=3D1400 audit(1634894728.370:866): avc:
denied  { map } for  pid=3D3237 comm=3D"su" path=3D"/su/bin/su"
dev=3D"nvme0n1p1" ino=3D15729502 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dfile permissive=3D1
[   37.232439] audit: type=3D1400 audit(1634894728.385:867): avc:
denied  { ioctl } for  pid=3D3177 comm=3D"RenderThread"
path=3D"/dev/dri/renderD128" dev=3D"tmpfs" ino=3D82 ioctlcmd=3D0x642e
scontext=3Du:r:untrusted_app:s0:c512,c768 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[   37.329191] EXT4-fs (nvme0n1p1): re-mounted. Opts: . Quota mode: none.
[   37.330224] audit: type=3D1400 audit(1634894728.482:868): avc:
denied  { ioctl } for  pid=3D777 comm=3D"surfaceflinger"
path=3D"/dev/dri/card0" dev=3D"tmpfs" ino=3D83 ioctlcmd=3D0x64af
scontext=3Du:r:surfaceflinger:s0 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[   37.330226] audit: type=3D1400 audit(1634894728.482:869): avc:
denied  { ioctl } for  pid=3D777 comm=3D"vsync" path=3D"/dev/dri/card0"
dev=3D"tmpfs" ino=3D83 ioctlcmd=3D0x643a scontext=3Du:r:surfaceflinger:s0
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[   37.383015] audit: type=3D1400 audit(1634894728.535:870): avc:
denied  { ioctl } for  pid=3D2630 comm=3D"Binder:2630_4"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:platform_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   37.706457] audit: type=3D1400 audit(1634894728.858:871): avc:
denied  { ioctl } for  pid=3D1903 comm=3D"Binder:1903_3"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:priv_app:s0:c512,c768 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   38.173335] audit: type=3D1400 audit(1634894729.325:872): avc:
denied  { ioctl } for  pid=3D1134 comm=3D"SoundPool"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   38.182319] audit: type=3D1400 audit(1634894729.335:873): avc:
denied  { ioctl } for  pid=3D1782 comm=3D"s.nexuslauncher"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   39.572265] qtaguid: qtaguid_untag(): User space forgot to open
/dev/xt_qtaguid? pid=3D1879 tgid=3D1865 sk_pid=3D1865, uid=3D10020
[   40.235603] audit: type=3D1400 audit(1634894731.388:874): avc:
denied  { wake_alarm } for  pid=3D1134 comm=3D"AlarmManager" capability=3D3=
5
 scontext=3Du:r:system_server:s0 tcontext=3Du:r:system_server:s0
tclass=3Dcapability2 permissive=3D1
[   40.299365] audit: type=3D1400 audit(1634894731.451:875): avc:
denied  { read write } for  pid=3D2680 comm=3D"onelli.juicessh"
name=3D"renderD128" dev=3D"tmpfs" ino=3D82
scontext=3Du:r:untrusted_app:s0:c512,c768 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[   42.364236] kauditd_printk_skb: 4 callbacks suppressed
[   42.364238] audit: type=3D1400 audit(1634894733.516:880): avc:
denied  { ioctl } for  pid=3D791 comm=3D"netd" path=3D"/dev/binderfs/binder=
"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:netd:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   50.328118] audit: type=3D1400 audit(1634894741.481:881): avc:
denied  { module_request } for  pid=3D2459 comm=3D"measurement-1"
kmod=3D"char-major-10-125" scontext=3Du:r:priv_app:s0:c512,c768
tcontext=3Du:r:kernel:s0 tclass=3Dsystem permissive=3D1
[   50.329315] modprobe: /sbin/modprobe char-major-10-125
[   50.329354] audit: type=3D1400 audit(1634894741.481:882): avc:
denied  { write } for  pid=3D3674 comm=3D"modprobe" name=3D"kmsg"
dev=3D"tmpfs" ino=3D133 scontext=3Du:r:init:s0
tcontext=3Du:object_r:kmsg_device:s0 tclass=3Dchr_file permissive=3D1
[   50.429642] audit: type=3D1400 audit(1634894741.582:883): avc:
denied  { ioctl } for  pid=3D1493 comm=3D"Binder:1493_1"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:radio:s0 tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_fil=
e
permissive=3D1
[   50.680176] audit: type=3D1400 audit(1634894741.833:884): avc:
denied  { read } for  pid=3D2811 comm=3D".yanyan.cputemp" name=3D"temp"
dev=3D"sysfs" ino=3D28900 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[   50.680184] audit: type=3D1400 audit(1634894741.833:885): avc:
denied  { open } for  pid=3D2811 comm=3D".yanyan.cputemp"
path=3D"/sys/devices/virtual/thermal/thermal_zone1/temp" dev=3D"sysfs"
ino=3D28900 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[   50.680203] audit: type=3D1400 audit(1634894741.833:886): avc:
denied  { getattr } for  pid=3D2811 comm=3D".yanyan.cputemp"
path=3D"/sys/devices/virtual/thermal/thermal_zone1/temp" dev=3D"sysfs"
ino=3D28900 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[   55.727832] audit: type=3D1400 audit(1634894746.880:887): avc:
denied  { map } for  pid=3D1134 comm=3D"InputDispatcher"
path=3D2F69393135202864656C6574656429 dev=3D"tmpfs" ino=3D3156
scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:surfaceflinger_tmpfs:s0 tclass=3Dfile permissive=3D1
[   55.727847] audit: type=3D1400 audit(1634894746.880:888): avc:
denied  { read write } for  pid=3D1134 comm=3D"InputDispatcher"
path=3D2F69393135202864656C6574656429 dev=3D"tmpfs" ino=3D3156
scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:surfaceflinger_tmpfs:s0 tclass=3Dfile permissive=3D1
[   57.649268] audit: type=3D1400 audit(1634894748.801:889): avc:
denied  { confidentiality } for  pid=3D3713 comm=3D"main"
lockdown_reason=3D"use of tracefs" scontext=3Du:r:zygote:s0
tcontext=3Du:r:zygote:s0 tclass=3Dlockdown permissive=3D1
[   57.652210] audit: type=3D1400 audit(1634894748.804:890): avc:
denied  { mounton } for  pid=3D3713 comm=3D"main" path=3D"/storage"
dev=3D"tmpfs" ino=3D42 scontext=3Du:r:zygote:s0 tcontext=3Du:object_r:tmpfs=
:s0
tclass=3Ddir permissive=3D1
[   57.652430] audit: type=3D1400 audit(1634894748.804:891): avc:
denied  { dac_read_search } for  pid=3D3713 comm=3D"main" capability=3D2
scontext=3Du:r:zygote:s0 tcontext=3Du:r:zygote:s0 tclass=3Dcapability
permissive=3D1
[   57.659323] audit: type=3D1400 audit(1634894748.811:892): avc:
denied  { search } for  pid=3D3713 comm=3D"catgames.Xplore" name=3D"/"
dev=3D"binder" ino=3D1 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Ddir permissive=3D1
[   57.659333] audit: type=3D1400 audit(1634894748.811:893): avc:
denied  { read write } for  pid=3D3713 comm=3D"catgames.Xplore"
name=3D"binder" dev=3D"binder" ino=3D4
scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   57.659338] audit: type=3D1400 audit(1634894748.811:894): avc:
denied  { open } for  pid=3D3713 comm=3D"catgames.Xplore"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4
scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   57.659359] audit: type=3D1400 audit(1634894748.811:895): avc:
denied  { map } for  pid=3D3713 comm=3D"catgames.Xplore"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4
scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   57.899174] audit: type=3D1400 audit(1634894749.051:896): avc:
denied  { read } for  pid=3D3713 comm=3D"catgames.Xplore" name=3D"xposed"
dev=3D"nvme0n1p1" ino=3D17699765 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dfile permissive=3D1
[   60.914466] kauditd_printk_skb: 8 callbacks suppressed
[   60.914468] audit: type=3D1400 audit(1634894752.067:905): avc:
denied  { ioctl } for  pid=3D790 comm=3D"Binder:790_2"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:mediaserver:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   73.054548] audit: type=3D1400 audit(1634894764.207:906): avc:
denied  { search } for  pid=3D782 comm=3D"AudioOut_D" name=3D"/" dev=3D"tmp=
fs"
ino=3D1 scontext=3Du:r:audioserver:s0 tcontext=3Du:object_r:tmpfs:s0
tclass=3Ddir permissive=3D1
[   80.666188] audit: type=3D1400 audit(1634894771.818:907): avc:
denied  { open } for  pid=3D1134 comm=3D"BackgroundDexOp"
path=3D"/system/priv-app/Phonesky/base.apk" dev=3D"nvme0n1p1" ino=3D1679072=
5
scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:app_data_file:s0:c512,c768 tclass=3Dfile
permissive=3D1
[   80.666264] audit: type=3D1400 audit(1634894771.818:908): avc:
denied  { map } for  pid=3D1134 comm=3D"BackgroundDexOp"
path=3D"/system/priv-app/Phonesky/base.apk" dev=3D"nvme0n1p1" ino=3D1679072=
5
scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:app_data_file:s0:c512,c768 tclass=3Dfile
permissive=3D1
[   80.815994] audit: type=3D1400 audit(1634894771.968:909): avc:
denied  { getattr } for  pid=3D1134 comm=3D"BackgroundDexOp"
path=3D"/system/priv-app/ScreenCam" dev=3D"nvme0n1p1" ino=3D15730887
scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:adb_data_file:s0
tclass=3Ddir permissive=3D1
[   80.815998] audit: type=3D1400 audit(1634894771.968:910): avc:
denied  { search } for  pid=3D1134 comm=3D"BackgroundDexOp"
name=3D"ScreenCam" dev=3D"nvme0n1p1" ino=3D15730887
scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:adb_data_file:s0
tclass=3Ddir permissive=3D1
[   80.816007] audit: type=3D1400 audit(1634894771.968:911): avc:
denied  { getattr } for  pid=3D1134 comm=3D"BackgroundDexOp"
path=3D"/system/priv-app/ScreenCam/ScreenCam.apk" dev=3D"nvme0n1p1"
ino=3D15730888 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:adb_data_file:s0 tclass=3Dfile permissive=3D1
[   80.816528] audit: type=3D1400 audit(1634894771.969:912): avc:
denied  { read } for  pid=3D1134 comm=3D"BackgroundDexOp"
name=3D"ScreenCam.apk" dev=3D"nvme0n1p1" ino=3D15730888
scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:adb_data_file:s0
tclass=3Dfile permissive=3D1
[   80.816530] audit: type=3D1400 audit(1634894771.969:913): avc:
denied  { open } for  pid=3D1134 comm=3D"BackgroundDexOp"
path=3D"/system/priv-app/ScreenCam/ScreenCam.apk" dev=3D"nvme0n1p1"
ino=3D15730888 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:adb_data_file:s0 tclass=3Dfile permissive=3D1
[   80.816607] audit: type=3D1400 audit(1634894771.969:914): avc:
denied  { map } for  pid=3D1134 comm=3D"BackgroundDexOp"
path=3D"/system/priv-app/ScreenCam/ScreenCam.apk" dev=3D"nvme0n1p1"
ino=3D15730888 scontext=3Du:r:system_server:s0
tcontext=3Du:object_r:adb_data_file:s0 tclass=3Dfile permissive=3D1
[   83.303229] audit: type=3D1400 audit(1634894774.455:915): avc:
denied  { map } for  pid=3D3919 comm=3D"su" path=3D"/su/bin/su"
dev=3D"nvme0n1p1" ino=3D15729502 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dfile permissive=3D1
[   83.343604] audit: type=3D1400 audit(1634894774.496:916): avc:
denied  { write } for  pid=3D3713 comm=3D457870616E6420646972
name=3D".ash_history" dev=3D"nvme0n1p1" ino=3D15729469
scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dfile permissive=3D1
[   89.896591] kauditd_printk_skb: 2 callbacks suppressed
[   89.896598] audit: type=3D1400 audit(1634894781.049:919): avc:
denied  { ioctl } for  pid=3D1648 comm=3D"Binder:1648_3"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:priv_app:s0:c512,c768 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   90.300488] audit: type=3D1400 audit(1634894781.453:920): avc:
denied  { ioctl } for  pid=3D777 comm=3D"surfaceflinger"
path=3D"/dev/dri/renderD128" dev=3D"tmpfs" ino=3D82 ioctlcmd=3D0x64bf
scontext=3Du:r:surfaceflinger:s0 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[   90.302063] audit: type=3D1400 audit(1634894781.454:921): avc:
denied  { ioctl } for  pid=3D2630 comm=3D"ndroid.systemui"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:platform_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[   90.304961] audit: type=3D1400 audit(1634894781.457:922): avc:
denied  { ioctl } for  pid=3D789 comm=3D"Binder:789_1"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:mediaextractor:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   90.344214] audit: type=3D1400 audit(1634894781.496:923): avc:
denied  { ioctl } for  pid=3D787 comm=3D"Binder:787_1"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:mediacodec:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[   91.172789] audit: type=3D1400 audit(1634894782.325:924): avc:
denied  { ioctl } for  pid=3D1493 comm=3D"Binder:1493_1"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:radio:s0 tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_fil=
e
permissive=3D1
[   91.268588] audit: type=3D1400 audit(1634894782.422:925): avc:
denied  { ioctl } for  pid=3D773 comm=3D"healthd"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:healthd:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[  120.532595] audit: type=3D1400 audit(1634894811.685:926): avc:
denied  { wake_alarm } for  pid=3D1134 comm=3D"AlarmManager" capability=3D3=
5
 scontext=3Du:r:system_server:s0 tcontext=3Du:r:system_server:s0
tclass=3Dcapability2 permissive=3D1
[  132.699142] audit: type=3D1400 audit(1634894823.851:927): avc:
denied  { module_request } for  pid=3D2664 comm=3D"Thread-5"
kmod=3D"char-major-10-125" scontext=3Du:r:priv_app:s0:c512,c768
tcontext=3Du:r:kernel:s0 tclass=3Dsystem permissive=3D1
[  132.699491] audit: type=3D1400 audit(1634894823.852:928): avc:
denied  { write } for  pid=3D4044 comm=3D"modprobe" name=3D"kmsg"
dev=3D"tmpfs" ino=3D133 scontext=3Du:r:init:s0
tcontext=3Du:object_r:kmsg_device:s0 tclass=3Dchr_file permissive=3D1
[  132.699494] modprobe: /sbin/modprobe char-major-10-125
[  140.967761] init: write_file: Unable to open
'/proc/sys/net/ipv4/tcp_default_init_rwnd': No such file or directory
[  140.969241] init: Starting service 'exec 12 (/system/bin/logwrapper)'...
[  140.969981] audit: type=3D1400 audit(1634894832.122:929): avc:
denied  { execute_no_trans } for  pid=3D4060 comm=3D"init"
path=3D"/system/bin/logwrapper" dev=3D"loop1" ino=3D280 scontext=3Du:r:init=
:s0
tcontext=3Du:object_r:system_file:s0 tclass=3Dfile permissive=3D1
[  140.971319] audit: type=3D1400 audit(1634894832.123:930): avc:
denied  { ioctl } for  pid=3D1511 comm=3D"Binder:1511_2"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:system_app:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[  140.975962] audit: type=3D1400 audit(1634894832.128:931): avc:
denied  { execute_no_trans } for  pid=3D4061 comm=3D"logwrapper"
path=3D"/system/bin/sh" dev=3D"loop1" ino=3D395 scontext=3Du:r:init:s0
tcontext=3Du:object_r:shell_exec:s0 tclass=3Dfile permissive=3D1
[  140.976240] audit: type=3D1400 audit(1634894832.128:932): avc:
denied  { ioctl } for  pid=3D1134 comm=3D"ConnectivitySer"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[  140.981288] audit: type=3D1400 audit(1634894832.133:933): avc:
denied  { write } for  pid=3D4066 comm=3D"getprop" path=3D"pipe:[25454]"
dev=3D"pipefs" ino=3D25454 scontext=3Du:r:toolbox:s0 tcontext=3Du:r:init:s0
tclass=3Dfifo_file permissive=3D1
[  140.983955] audit: type=3D1400 audit(1634894832.136:934): avc:
denied  { getattr } for  pid=3D4066 comm=3D"getprop" path=3D"pipe:[25454]"
dev=3D"pipefs" ino=3D25454 scontext=3Du:r:toolbox:s0 tcontext=3Du:r:init:s0
tclass=3Dfifo_file permissive=3D1
[  140.984240] audit: type=3D1400 audit(1634894832.136:935): avc:
denied  { execute_no_trans } for  pid=3D4067 comm=3D"sh" path=3D"/init"
dev=3D"tmpfs" ino=3D34 scontext=3Du:r:init:s0
tcontext=3Du:object_r:init_exec:s0 tclass=3Dfile permissive=3D1
[  140.986092] audit: type=3D1400 audit(1634894832.138:936): avc:
denied  { sys_module } for  pid=3D4067 comm=3D"modprobe" capability=3D16
scontext=3Du:r:init:s0 tcontext=3Du:r:init:s0 tclass=3Dcapability
permissive=3D1
[  140.986094] audit: type=3D1400 audit(1634894832.138:937): avc:
denied  { module_load } for  pid=3D4067 comm=3D"modprobe"
path=3D"/system/lib/modules/5.15.0-rc6-android-x86_64+/kernel/drivers/net/n=
etconsole.ko"
dev=3D"nvme0n1p1" ino=3D16912487 scontext=3Du:r:init:s0
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dsystem permissive=3D1
[  140.986422] netpoll: netconsole: couldn't parse config at ''!
[  140.986423] netconsole: cleaning up
[  141.011535] init: Service 'exec 12 (/system/bin/logwrapper)' (pid
4060) exited with status 0
[  157.813192] audit: type=3D1400 audit(1634894848.965:938): avc:
denied  { ioctl } for  pid=3D791 comm=3D"netd" path=3D"/dev/binderfs/binder=
"
dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201 scontext=3Du:r:netd:s0
tcontext=3Du:object_r:unlabeled:s0 tclass=3Dchr_file permissive=3D1
[  175.872687] audit: type=3D1400 audit(1634894867.025:939): avc:
denied  { read } for  pid=3D2811 comm=3D".yanyan.cputemp" name=3D"temp"
dev=3D"sysfs" ino=3D28900 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[  175.872699] audit: type=3D1400 audit(1634894867.025:940): avc:
denied  { open } for  pid=3D2811 comm=3D".yanyan.cputemp"
path=3D"/sys/devices/virtual/thermal/thermal_zone1/temp" dev=3D"sysfs"
ino=3D28900 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[  175.872704] audit: type=3D1400 audit(1634894867.025:941): avc:
denied  { getattr } for  pid=3D2811 comm=3D".yanyan.cputemp"
path=3D"/sys/devices/virtual/thermal/thermal_zone1/temp" dev=3D"sysfs"
ino=3D28900 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:sysfs:s0 tclass=3Dfile permissive=3D1
[  187.199410] audit: type=3D1400 audit(1634894878.351:942): avc:
denied  { getattr } for  pid=3D781 comm=3D"main"
path=3D"/system/framework/XposedBridge.jar" dev=3D"nvme0n1p1" ino=3D1573051=
3
scontext=3Du:r:zygote:s0 tcontext=3Du:object_r:adb_data_file:s0
tclass=3Dfile permissive=3D1
[  187.205168] audit: type=3D1400 audit(1634894878.357:943): avc:
denied  { confidentiality } for  pid=3D4206 comm=3D"main"
lockdown_reason=3D"use of tracefs" scontext=3Du:r:zygote:s0
tcontext=3Du:r:zygote:s0 tclass=3Dlockdown permissive=3D1
[  187.205701] audit: type=3D1400 audit(1634894878.358:944): avc:
denied  { read } for  pid=3D4206 comm=3D"main" name=3D"XposedBridge.jar"
dev=3D"nvme0n1p1" ino=3D15730513 scontext=3Du:r:zygote:s0
tcontext=3Du:object_r:adb_data_file:s0 tclass=3Dfile permissive=3D1
[  187.205713] audit: type=3D1400 audit(1634894878.358:945): avc:
denied  { open } for  pid=3D4206 comm=3D"main"
path=3D"/system/framework/XposedBridge.jar" dev=3D"nvme0n1p1" ino=3D1573051=
3
scontext=3Du:r:zygote:s0 tcontext=3Du:object_r:adb_data_file:s0
tclass=3Dfile permissive=3D1
[  187.208437] audit: type=3D1400 audit(1634894878.360:946): avc:
denied  { mounton } for  pid=3D4206 comm=3D"main" path=3D"/storage"
dev=3D"tmpfs" ino=3D42 scontext=3Du:r:zygote:s0 tcontext=3Du:object_r:tmpfs=
:s0
tclass=3Ddir permissive=3D1
[  187.208687] audit: type=3D1400 audit(1634894878.361:947): avc:
denied  { dac_read_search } for  pid=3D4206 comm=3D"main" capability=3D2
scontext=3Du:r:zygote:s0 tcontext=3Du:r:zygote:s0 tclass=3Dcapability
permissive=3D1
[  187.216122] audit: type=3D1400 audit(1634894878.368:948): avc:
denied  { search } for  pid=3D4206 comm=3D"eatherquicktile" name=3D"/"
dev=3D"binder" ino=3D1 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:unlabeled:s0 tclass=3Ddir permissive=3D1
[  187.249411] audit: type=3D1400 audit(1634894878.401:949): avc:
denied  { read } for  pid=3D2108 comm=3D"RxCachedThreadS" name=3D"xposed"
dev=3D"nvme0n1p1" ino=3D17699765 scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dfile permissive=3D1
[  187.249433] audit: type=3D1400 audit(1634894878.401:950): avc:
denied  { getattr } for  pid=3D2108 comm=3D"RxCachedThreadS"
path=3D"/data/ru.nanPXdAK.hOIfAOSXG/xposed" dev=3D"nvme0n1p1" ino=3D1769976=
5
scontext=3Du:r:untrusted_app:s0:c512,c768
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dfile permissive=3D1
[  189.253120] audit: type=3D1400 audit(1634894880.405:951): avc:
denied  { ioctl } for  pid=3D782 comm=3D"audioserver"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:audioserver:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[  189.292054] PM: hibernation: hibernation entry
[  189.295273] Filesystems sync: 0.000 seconds
[  189.295281] Freezing user space processes ... (elapsed 0.003 seconds) do=
ne.
[  189.298514] OOM killer disabled.
[  189.298590] PM: hibernation: Marking nosave pages: [mem
0x00000000-0x00000fff]
[  189.298594] PM: hibernation: Marking nosave pages: [mem
0x00058000-0x00058fff]
[  189.298596] PM: hibernation: Marking nosave pages: [mem
0x0009f000-0x000fffff]
[  189.298600] PM: hibernation: Marking nosave pages: [mem
0x00500000-0x005fffff]
[  189.298607] PM: hibernation: Marking nosave pages: [mem
0x850d7000-0x850d8fff]
[  189.298609] PM: hibernation: Marking nosave pages: [mem
0x8805d000-0x8809bfff]
[  189.298612] PM: hibernation: Marking nosave pages: [mem
0x8ac24000-0x8ac24fff]
[  189.298614] PM: hibernation: Marking nosave pages: [mem
0x8bea8000-0x8caeefff]
[  189.298689] PM: hibernation: Marking nosave pages: [mem
0x8cb9a000-0x8d3fefff]
[  189.298741] PM: hibernation: Marking nosave pages: [mem
0x8d400000-0xffffffff]
[  189.300918] PM: hibernation: Basic memory bitmaps created
[  189.301088] PM: hibernation: Preallocating image memory
[  189.812115] PM: hibernation: Allocated 779311 pages for snapshot
[  189.812118] PM: hibernation: Allocated 3117244 kbytes in 0.51
seconds (6112.24 MB/s)
[  189.812121] Freezing remaining freezable tasks ... (elapsed 0.001
seconds) done.
[  189.813884] printk: Suspending console(s) (use no_console_suspend to deb=
ug)
[  189.814016] wlan0: deauthenticating from b4:a8:98:22:f9:ac by local
choice (Reason: 3=3DDEAUTH_LEAVING)
[  189.814310] rtc_cmos 00:05: suspend, ctrl 02
[  189.844670] r8169 0000:01:00.0 eth0: Link is Down
[  190.081522] ACPI: PM: Preparing to enter system sleep state S4
[  190.083051] ACPI: PM: Saving platform NVS memory
[  190.087556] Disabling non-boot CPUs ...
[  190.089802] smpboot: CPU 1 is now offline
[  190.092841] smpboot: CPU 2 is now offline
[  190.095235] smpboot: CPU 3 is now offline
[  190.098592] smpboot: CPU 4 is now offline
[  190.100660] smpboot: CPU 5 is now offline
[  190.102967] smpboot: CPU 6 is now offline
[  190.105047] smpboot: CPU 7 is now offline
[  190.106828] PM: hibernation: Creating image:
[  190.211897] PM: hibernation: Need to copy 775681 pages
[  190.211898] PM: hibernation: Normal pages needed: 775681 + 1024,
available pages: 1300224
[  190.107012] ACPI: PM: Restoring platform NVS memory
[  190.108184] Enabling non-boot CPUs ...
[  190.108225] x86: Booting SMP configuration:
[  190.108225] smpboot: Booting Node 0 Processor 1 APIC 0x2
[  190.109416] CPU1 is up
[  190.109440] smpboot: Booting Node 0 Processor 2 APIC 0x4
[  190.110088] CPU2 is up
[  190.110111] smpboot: Booting Node 0 Processor 3 APIC 0x6
[  190.110775] CPU3 is up
[  190.110799] smpboot: Booting Node 0 Processor 4 APIC 0x1
[  190.111532] CPU4 is up
[  190.111558] smpboot: Booting Node 0 Processor 5 APIC 0x3
[  190.112280] CPU5 is up
[  190.112303] smpboot: Booting Node 0 Processor 6 APIC 0x5
[  190.113056] CPU6 is up
[  190.113084] smpboot: Booting Node 0 Processor 7 APIC 0x7
[  190.113886] CPU7 is up
[  190.116276] ACPI: PM: Waking up from system sleep state S4
[  190.187264] usb usb1: root hub lost power or was reset
[  190.187296] usb usb2: root hub lost power or was reset
[  190.188384] rtc_cmos 00:05: resume, ctrl 02
[  190.189946] i915 0000:00:02.0: [drm] [ENCODER:94:DDI B/PHY B] is
disabled/in DSI mode with an ungated DDI clock, gate it
[  190.195185] nvme nvme0: 8/0/0 default/read/poll queues
[  190.354168] r8169 0000:01:00.0 eth0: Link is Down
[  190.526336] ata3: SATA link down (SStatus 4 SControl 300)
[  190.526389] ata4: SATA link down (SStatus 4 SControl 300)
[  191.214037] snd_hda_intel 0000:00:1f.3: azx_get_response timeout,
switching to polling mode: last cmd=3D0x206f0015
[  191.214047] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214054] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214058] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214061] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214064] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214067] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214070] snd_hda_intel 0000:00:1f.3: spurious response
0x200:0x2, last cmd=3D0x206f0015
[  191.214073] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214076] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  191.214079] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2,
last cmd=3D0x206f0015
[  192.216095] snd_hda_intel 0000:00:1f.3: No response from codec,
disabling MSI: last cmd=3D0x20670100
[  193.218095] snd_hda_intel 0000:00:1f.3: azx_get_response timeout,
switching to single_cmd mode: last cmd=3D0x20670100
[  193.547924] r8169 0000:01:00.0 eth0: Link is Up - 1Gbps/Full - flow
control off
[  200.640141] xhci_hcd 0000:00:14.0: Abort failed to stop command ring: -1=
10
[  200.640148] xhci_hcd 0000:00:14.0: xHCI host controller not
responding, assume dead
[  200.640151] xhci_hcd 0000:00:14.0: HC died; cleaning up
[  200.640165] xhci_hcd 0000:00:14.0: Timeout while waiting for setup
device command
[  201.056143] usb 2-1: device not accepting address 2, error -22
[  201.058193] PM: hibernation: Basic memory bitmaps freed
[  201.058197] OOM killer enabled.
[  201.058197] Restarting tasks ...
[  201.058212] usb 2-1: USB disconnect, device number 2
[  201.058234] kauditd_printk_skb: 5 callbacks suppressed
[  201.058238] audit: type=3D1400 audit(1634894919.000:957): avc:
denied  { perfmon } for  pid=3D17 comm=3D"cpuhp/1" capability=3D38
scontext=3Du:r:kernel:s0 tcontext=3Du:r:kernel:s0 tclass=3Dcapability2
permissive=3D1
[  201.058249] usb 1-1: USB disconnect, device number 2
[  201.058255] audit: type=3D1400 audit(1634894919.000:958): avc:
denied  { cpu } for  pid=3D17 comm=3D"cpuhp/1" scontext=3Du:r:kernel:s0
tcontext=3Du:r:kernel:s0 tclass=3Dperf_event permissive=3D1
[  201.058256] usb 1-1.1: USB disconnect, device number 6
[  201.059059] done.
[  201.059328] video LNXVIDEO:00: Restoring backlight state
[  201.059332] PM: hibernation: hibernation exit
[  201.067203] audit: type=3D1400 audit(1634894929.957:959): avc:
denied  { ioctl } for  pid=3D776 comm=3D"servicemanager"
path=3D"/dev/binderfs/binder" dev=3D"binder" ino=3D4 ioctlcmd=3D0x6201
scontext=3Du:r:servicemanager:s0 tcontext=3Du:object_r:unlabeled:s0
tclass=3Dchr_file permissive=3D1
[  201.072873] init: write_file: Unable to open
'/proc/sys/net/ipv4/tcp_default_init_rwnd': No such file or directory
[  201.073489] usb 1-9: USB disconnect, device number 3
[  201.078233] audit: type=3D1400 audit(1634894929.968:960): avc:
denied  { ioctl } for  pid=3D1134 comm=3D"android.display"
path=3D"/dev/dri/renderD128" dev=3D"tmpfs" ino=3D82 ioctlcmd=3D0x6409
scontext=3Du:r:system_server:s0 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[  201.082770] init: Untracked pid 4171 killed by signal 1
[  201.083664] init: Untracked pid 4170 exited with status 255
[  201.085257] init: Untracked pid 4185 exited with status 1
[  201.088167] audit: type=3D1400 audit(1634894929.978:961): avc:
denied  { module_load } for  pid=3D4327 comm=3D"modprobe"
path=3D"/system/lib/modules/5.15.0-rc6-android-x86_64+/kernel/drivers/hid/h=
id-multitouch.ko"
dev=3D"nvme0n1p1" ino=3D16912286 scontext=3Du:r:supersu:s0
tcontext=3Du:object_r:system_data_file:s0 tclass=3Dsystem permissive=3D1
[  201.110458] audit: type=3D1400 audit(1634894930.000:962): avc:
denied  { wake_alarm } for  pid=3D1134 comm=3D"Binder:1134_8"
capability=3D35  scontext=3Du:r:system_server:s0
tcontext=3Du:r:system_server:s0 tclass=3Dcapability2 permissive=3D1
[  201.114747] init: write_file: Unable to open
'/proc/sys/net/ipv4/tcp_default_init_rwnd': No such file or directory
[  201.115245] init: Starting service 'exec 13 (/system/bin/logwrapper)'...
[  201.116439] audit: type=3D1400 audit(1634894930.006:963): avc:
denied  { execute_no_trans } for  pid=3D4342 comm=3D"init"
path=3D"/system/bin/logwrapper" dev=3D"loop1" ino=3D280 scontext=3Du:r:init=
:s0
tcontext=3Du:object_r:system_file:s0 tclass=3Dfile permissive=3D1
[  201.124053] audit: type=3D1400 audit(1634894930.013:964): avc:
denied  { execute_no_trans } for  pid=3D4343 comm=3D"logwrapper"
path=3D"/system/bin/sh" dev=3D"loop1" ino=3D395 scontext=3Du:r:init:s0
tcontext=3Du:object_r:shell_exec:s0 tclass=3Dfile permissive=3D1
[  201.129392] audit: type=3D1400 audit(1634894930.019:966): avc:
denied  { ioctl } for  pid=3D777 comm=3D"surfaceflinger"
path=3D"/dev/dri/card0" dev=3D"tmpfs" ino=3D83 ioctlcmd=3D0x64af
scontext=3Du:r:surfaceflinger:s0 tcontext=3Du:object_r:device:s0
tclass=3Dchr_file permissive=3D1
[  201.129397] audit: type=3D1400 audit(1634894930.019:965): avc:
denied  { ioctl } for  pid=3D777 comm=3D"vsync" path=3D"/dev/dri/card0"
dev=3D"tmpfs" ino=3D83 ioctlcmd=3D0x643a scontext=3Du:r:surfaceflinger:s0
tcontext=3Du:object_r:device:s0 tclass=3Dchr_file permissive=3D1
[  201.146111] netpoll: netconsole: couldn't parse config at ''!
[  201.146115] netconsole: cleaning up
[  201.169062] init: Service 'exec 13 (/system/bin/logwrapper)' (pid
4342) exited with status 0
[  201.169585] init: write_file: Unable to open
'/proc/sys/net/ipv4/tcp_default_init_rwnd': No such file or directory
[  201.169726] init: Starting service 'exec 14 (/system/bin/logwrapper)'...
[  201.191855] netpoll: netconsole: couldn't parse config at ''!
[  201.191858] netconsole: cleaning up
[  201.209950] init: Service 'exec 14 (/system/bin/logwrapper)' (pid
4357) exited with status 0
[  201.294928] netpoll: netconsole: couldn't parse config at ''!
[  201.294932] netconsole: cleaning up
[  202.198914] netpoll: netconsole: couldn't parse config at ''!
[  202.198916] netconsole: cleaning up
[  204.107075] wlan0: authenticate with b4:a8:98:22:f9:ac
[  204.110023] wlan0: send auth to b4:a8:98:22:f9:ac (try 1/3)
[  204.136950] wlan0: authenticated
[  204.138010] wlan0: associate with b4:a8:98:22:f9:ac (try 1/3)
[  204.140191] wlan0: RX AssocResp from b4:a8:98:22:f9:ac
(capab=3D0x1531 status=3D0 aid=3D4)
[  204.143640] wlan0: associated
root@localhost:/home/youling257#

2021-10-22 18:59 GMT+08:00, youling257 <youling257@gmail.com>:
> This patch cause suspend to disk resume usb not work, xhci_hcd 0000:00:14=
.0:
> Abort failed to stop command ring: -110.
>
> [  189.292054] PM: hibernation: hibernation entry
> [  189.295273] Filesystems sync: 0.000 seconds
> [  189.295281] Freezing user space processes ... (elapsed 0.003 seconds)
> done.
> [  189.298514] OOM killer disabled.
> [  189.298590] PM: hibernation: Marking nosave pages: [mem
> 0x00000000-0x00000fff]
> [  189.298594] PM: hibernation: Marking nosave pages: [mem
> 0x00058000-0x00058fff]
> [  189.298596] PM: hibernation: Marking nosave pages: [mem
> 0x0009f000-0x000fffff]
> [  189.298600] PM: hibernation: Marking nosave pages: [mem
> 0x00500000-0x005fffff]
> [  189.298607] PM: hibernation: Marking nosave pages: [mem
> 0x850d7000-0x850d8fff]
> [  189.298609] PM: hibernation: Marking nosave pages: [mem
> 0x8805d000-0x8809bfff]
> [  189.298612] PM: hibernation: Marking nosave pages: [mem
> 0x8ac24000-0x8ac24fff]
> [  189.298614] PM: hibernation: Marking nosave pages: [mem
> 0x8bea8000-0x8caeefff]
> [  189.298689] PM: hibernation: Marking nosave pages: [mem
> 0x8cb9a000-0x8d3fefff]
> [  189.298741] PM: hibernation: Marking nosave pages: [mem
> 0x8d400000-0xffffffff]
> [  189.300918] PM: hibernation: Basic memory bitmaps created
> [  189.301088] PM: hibernation: Preallocating image memory
> [  189.812115] PM: hibernation: Allocated 779311 pages for snapshot
> [  189.812118] PM: hibernation: Allocated 3117244 kbytes in 0.51 seconds
> (6112.24 MB/s)
> [  189.812121] Freezing remaining freezable tasks ... (elapsed 0.001
> seconds) done.
> [  189.813884] printk: Suspending console(s) (use no_console_suspend to
> debug)
> [  189.814016] wlan0: deauthenticating from b4:a8:98:22:f9:ac by local
> choice (Reason: 3=3DDEAUTH_LEAVING)
> [  189.814310] rtc_cmos 00:05: suspend, ctrl 02
> [  189.844670] r8169 0000:01:00.0 eth0: Link is Down
> [  190.081522] ACPI: PM: Preparing to enter system sleep state S4
> [  190.083051] ACPI: PM: Saving platform NVS memory
> [  190.087556] Disabling non-boot CPUs ...
> [  190.089802] smpboot: CPU 1 is now offline
> [  190.092841] smpboot: CPU 2 is now offline
> [  190.095235] smpboot: CPU 3 is now offline
> [  190.098592] smpboot: CPU 4 is now offline
> [  190.100660] smpboot: CPU 5 is now offline
> [  190.102967] smpboot: CPU 6 is now offline
> [  190.105047] smpboot: CPU 7 is now offline
> [  190.106828] PM: hibernation: Creating image:
> [  190.211897] PM: hibernation: Need to copy 775681 pages
> [  190.211898] PM: hibernation: Normal pages needed: 775681 + 1024,
> available pages: 1300224
> [  190.107012] ACPI: PM: Restoring platform NVS memory
> [  190.108184] Enabling non-boot CPUs ...
> [  190.108225] x86: Booting SMP configuration:
> [  190.108225] smpboot: Booting Node 0 Processor 1 APIC 0x2
> [  190.109416] CPU1 is up
> [  190.109440] smpboot: Booting Node 0 Processor 2 APIC 0x4
> [  190.110088] CPU2 is up
> [  190.110111] smpboot: Booting Node 0 Processor 3 APIC 0x6
> [  190.110775] CPU3 is up
> [  190.110799] smpboot: Booting Node 0 Processor 4 APIC 0x1
> [  190.111532] CPU4 is up
> [  190.111558] smpboot: Booting Node 0 Processor 5 APIC 0x3
> [  190.112280] CPU5 is up
> [  190.112303] smpboot: Booting Node 0 Processor 6 APIC 0x5
> [  190.113056] CPU6 is up
> [  190.113084] smpboot: Booting Node 0 Processor 7 APIC 0x7
> [  190.113886] CPU7 is up
> [  190.116276] ACPI: PM: Waking up from system sleep state S4
> [  190.187264] usb usb1: root hub lost power or was reset
> [  190.187296] usb usb2: root hub lost power or was reset
> [  190.188384] rtc_cmos 00:05: resume, ctrl 02
> [  190.189946] i915 0000:00:02.0: [drm] [ENCODER:94:DDI B/PHY B] is
> disabled/in DSI mode with an ungated DDI clock, gate it
> [  190.195185] nvme nvme0: 8/0/0 default/read/poll queues
> [  190.354168] r8169 0000:01:00.0 eth0: Link is Down
> [  190.526336] ata3: SATA link down (SStatus 4 SControl 300)
> [  190.526389] ata4: SATA link down (SStatus 4 SControl 300)
> [  191.214037] snd_hda_intel 0000:00:1f.3: azx_get_response timeout,
> switching to polling mode: last cmd=3D0x206f0015
> [  191.214047] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214054] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214058] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214061] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214064] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214067] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214070] snd_hda_intel 0000:00:1f.3: spurious response 0x200:0x2, l=
ast
> cmd=3D0x206f0015
> [  191.214073] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214076] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  191.214079] snd_hda_intel 0000:00:1f.3: spurious response 0x0:0x2, las=
t
> cmd=3D0x206f0015
> [  192.216095] snd_hda_intel 0000:00:1f.3: No response from codec, disabl=
ing
> MSI: last cmd=3D0x20670100
> [  193.218095] snd_hda_intel 0000:00:1f.3: azx_get_response timeout,
> switching to single_cmd mode: last cmd=3D0x20670100
> [  193.547924] r8169 0000:01:00.0 eth0: Link is Up - 1Gbps/Full - flow
> control off
> [  200.640141] xhci_hcd 0000:00:14.0: Abort failed to stop command ring:
> -110
> [  200.640148] xhci_hcd 0000:00:14.0: xHCI host controller not responding=
,
> assume dead
> [  200.640151] xhci_hcd 0000:00:14.0: HC died; cleaning up
> [  200.640165] xhci_hcd 0000:00:14.0: Timeout while waiting for setup dev=
ice
> command
> [  201.056143] usb 2-1: device not accepting address 2, error -22
> [  201.058193] PM: hibernation: Basic memory bitmaps freed
> [  201.058197] OOM killer enabled.
> [  201.058197] Restarting tasks ...
> [  201.058212] usb 2-1: USB disconnect, device number 2
>
