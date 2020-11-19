Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED88A2B8B67
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 07:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKSGKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 01:10:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgKSGKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 01:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605766201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nw1nBoxlkrIi+sBPh1ycm+OiKo8H6cgaHJAgodwyazE=;
        b=f6r4/3WzkvXLvUGyPE0WjEfK9KDJoeu9pe5nmETd71Xh58vKMECHuld+b+dn/nMJHDZCTI
        tlV2DzEB7piBOZisKs6oYsvYv9S5ektkRFoogKPLIzkiHkp4C3ddc5EJMhw1a49NTTZLww
        LfQs3JVvVR30eA2iIKhqKWjt3XjFYis=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-gMfCiKYyM6GN0JeZuQqzdg-1; Thu, 19 Nov 2020 01:09:51 -0500
X-MC-Unique: gMfCiKYyM6GN0JeZuQqzdg-1
Received: by mail-io1-f70.google.com with SMTP id q126so3871062iof.3
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 22:09:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nw1nBoxlkrIi+sBPh1ycm+OiKo8H6cgaHJAgodwyazE=;
        b=h/LPzitX5uOjwhLpUuwGCccWVSrvaAG7KbEi0C0OOMQpni0xdNaOEXfjySTiVcRgca
         BfemCmTiz9WiYTeXR9w+HmEdAYR/O1HScXCn2y4SY+PiHs12PuNZDJe2FJxo/dHw/4kl
         WIZtKWH5bpORy4kzGhQv8MaIzHIN+mdTg1wCBx7/qQ2o67S5+f64LXIjVLZVztvJgYE1
         ZB73PdTI8EltezUvd/Vaqvm6VHCbnqqmuPC/F5XZao4UmWyfqf3obvT/kOutKv86fOKN
         DSoxBQMT6QElVimJtv8zpA+oWZqgfxu39/rc839M7ZFgMuBIEKRetfSEiAYLEEoXJqr+
         uUTg==
X-Gm-Message-State: AOAM530GbSN/v5R/17jHtEfz9Gdhs8ZJdNvGInr3lqPOTropkF7LEJI8
        zw9ZBtQWAPWA1DuxCFxSL9buvnt+8qY3orNaqez8fZfi23xuf6Fapg+vvP2ufCh4peulC10dG7+
        8p69PP0zDrhIfLvODH40WWzL8/CgaPuEf
X-Received: by 2002:a5d:8151:: with SMTP id f17mr19804584ioo.129.1605766190563;
        Wed, 18 Nov 2020 22:09:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWIXELKZsH573YkHKg2jO/a7U4wowfnv6t5HOOehUSVdlQ5EV2g4Z+KgcnDqp5f5IR9y+ndhDFb/BxdXGy8eA=
X-Received: by 2002:a5d:8151:: with SMTP id f17mr19804551ioo.129.1605766190252;
 Wed, 18 Nov 2020 22:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
In-Reply-To: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
From:   Kairui Song <kasong@redhat.com>
Date:   Thu, 19 Nov 2020 14:09:39 +0800
Message-ID: <CACPcB9e8p5Ayw15aOe5ZNPOa7MF3+pzPdcaZgTc_E_TZYkgD6Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     john.p.donnelly@oracle.com, stable@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Anson Huang <Anson.Huang@nxp.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?Q?Diego_Elio_Petten=C3=B2?= <flameeyes@flameeyes.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 7:29 AM Saeed Mirzamohammadi
<saeed.mirzamohammadi@oracle.com> wrote:
>
> This adds crashkernel=auto feature to configure reserved memory for
> vmcore creation to both x86 and ARM platforms based on the total memory
> size.

Thanks for the patch! This is very helpful for distribution makers,
this allows the distro to have better control of the crashkernel size
and ship it with the kernel. The crashkernel value is sensitive to
kernel and driver changes, so shipping it with the kernel makes sense.

And I think crashkernel=auto could be used as an indicator that user
want the kernel to control the crashkernel size, so some further work
could be done to adjust the crashkernel more accordingly. eg. when
memory encryption is enabled, increase the crashkernel value for the
auto estimation, as it's known to consume more crashkernel memory.

There have been a lot of efforts trying to push this in upstream:
https://lkml.org/lkml/2018/5/20/262
https://lkml.org/lkml/2009/8/12/61

Still, it's not yet accepted. it's good to see more people working on this.

But why not make it arch-independent? This crashkernel=auto idea
should simply work with every arch.

>
> Cc: stable@vger.kernel.org
> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> ---
>  Documentation/admin-guide/kdump/kdump.rst |  5 +++++
>  arch/arm64/Kconfig                        | 26 ++++++++++++++++++++++-
>  arch/arm64/configs/defconfig              |  1 +
>  arch/x86/Kconfig                          | 26 ++++++++++++++++++++++-
>  arch/x86/configs/x86_64_defconfig         |  1 +
>  kernel/crash_core.c                       | 20 +++++++++++++++--
>  6 files changed, 75 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/admin-guide/kdump/kdump.rst b/Documentation/admin-guide/kdump/kdump.rst
> index 75a9dd98e76e..f95a2af64f59 100644
> --- a/Documentation/admin-guide/kdump/kdump.rst
> +++ b/Documentation/admin-guide/kdump/kdump.rst
> @@ -285,7 +285,12 @@ This would mean:
>      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
>      3) if the RAM size is larger than 2G, then reserve 128M
>
> +Or you can use crashkernel=auto if you have enough memory. The threshold
> +is 1G on x86_64 and arm64. If your system memory is less than the threshold,
> +crashkernel=auto will not reserve memory. The size changes according to
> +the system memory size like below:
>
> +    x86_64/arm64: 1G-64G:128M,64G-1T:256M,1T-:512M
>
>  Boot into System Kernel
>  =======================
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1515f6f153a0..d359dcffa80e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1124,7 +1124,7 @@ comment "Support for PE file signature verification disabled"
>         depends on KEXEC_SIG
>         depends on !EFI || !SIGNED_PE_FILE_VERIFICATION
>
> -config CRASH_DUMP
> +menuconfig CRASH_DUMP
>         bool "Build kdump crash kernel"
>         help
>           Generate crash dump after being started by kexec. This should
> @@ -1135,6 +1135,30 @@ config CRASH_DUMP
>
>           For more details see Documentation/admin-guide/kdump/kdump.rst
>
> +if CRASH_DUMP
> +
> +config CRASH_AUTO_STR
> +        string "Memory reserved for crash kernel"
> +       depends on CRASH_DUMP
> +        default "1G-64G:128M,64G-1T:256M,1T-:512M"
> +       help
> +         This configures the reserved memory dependent
> +         on the value of System RAM. The syntax is:
> +         crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> +                     range=start-[end]
> +
> +         For example:
> +             crashkernel=512M-2G:64M,2G-:128M
> +
> +         This would mean:
> +
> +             1) if the RAM is smaller than 512M, then don't reserve anything
> +                (this is the "rescue" case)
> +             2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> +             3) if the RAM size is larger than 2G, then reserve 128M
> +
> +endif # CRASH_DUMP
> +
>  config XEN_DOM0
>         def_bool y
>         depends on XEN
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index 5cfe3cf6f2ac..899ef3b6a78f 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -69,6 +69,7 @@ CONFIG_SECCOMP=y
>  CONFIG_KEXEC=y
>  CONFIG_KEXEC_FILE=y
>  CONFIG_CRASH_DUMP=y
> +# CONFIG_CRASH_AUTO_STR is not set
>  CONFIG_XEN=y
>  CONFIG_COMPAT=y
>  CONFIG_RANDOMIZE_BASE=y
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f6946b81f74a..bacd17312bb1 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2035,7 +2035,7 @@ config KEXEC_BZIMAGE_VERIFY_SIG
>         help
>           Enable bzImage signature verification support.
>
> -config CRASH_DUMP
> +menuconfig CRASH_DUMP
>         bool "kernel crash dumps"
>         depends on X86_64 || (X86_32 && HIGHMEM)
>         help
> @@ -2049,6 +2049,30 @@ config CRASH_DUMP
>           (CONFIG_RELOCATABLE=y).
>           For more details see Documentation/admin-guide/kdump/kdump.rst
>
> +if CRASH_DUMP
> +
> +config CRASH_AUTO_STR
> +        string "Memory reserved for crash kernel" if X86_64
> +       depends on CRASH_DUMP
> +        default "1G-64G:128M,64G-1T:256M,1T-:512M"
> +       help
> +         This configures the reserved memory dependent
> +         on the value of System RAM. The syntax is:
> +         crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> +                     range=start-[end]
> +
> +         For example:
> +             crashkernel=512M-2G:64M,2G-:128M
> +
> +         This would mean:
> +
> +             1) if the RAM is smaller than 512M, then don't reserve anything
> +                (this is the "rescue" case)
> +             2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> +             3) if the RAM size is larger than 2G, then reserve 128M
> +
> +endif # CRASH_DUMP
> +
>  config KEXEC_JUMP
>         bool "kexec jump"
>         depends on KEXEC && HIBERNATION
> diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
> index 9936528e1939..7a87fbecf40b 100644
> --- a/arch/x86/configs/x86_64_defconfig
> +++ b/arch/x86/configs/x86_64_defconfig
> @@ -33,6 +33,7 @@ CONFIG_EFI_MIXED=y
>  CONFIG_HZ_1000=y
>  CONFIG_KEXEC=y
>  CONFIG_CRASH_DUMP=y
> +# CONFIG_CRASH_AUTO_STR is not set
>  CONFIG_HIBERNATION=y
>  CONFIG_PM_DEBUG=y
>  CONFIG_PM_TRACE_RTC=y
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 106e4500fd53..a44cd9cc12c4 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -7,6 +7,7 @@
>  #include <linux/crash_core.h>
>  #include <linux/utsname.h>
>  #include <linux/vmalloc.h>
> +#include <linux/kexec.h>
>
>  #include <asm/page.h>
>  #include <asm/sections.h>
> @@ -41,6 +42,15 @@ static int __init parse_crashkernel_mem(char *cmdline,
>                                         unsigned long long *crash_base)
>  {
>         char *cur = cmdline, *tmp;
> +       unsigned long long total_mem = system_ram;
> +
> +       /*
> +        * Firmware sometimes reserves some memory regions for it's own use.
> +        * so we get less than actual system memory size.
> +        * Workaround this by round up the total size to 128M which is
> +        * enough for most test cases.
> +        */
> +       total_mem = roundup(total_mem, SZ_128M);

I think this rounding may be better moved to the arch specified part
where parse_crashkernel is called?

>
>         /* for each entry of the comma-separated list */
>         do {
> @@ -85,13 +95,13 @@ static int __init parse_crashkernel_mem(char *cmdline,
>                         return -EINVAL;
>                 }
>                 cur = tmp;
> -               if (size >= system_ram) {
> +               if (size >= total_mem) {
>                         pr_warn("crashkernel: invalid size\n");
>                         return -EINVAL;
>                 }
>
>                 /* match ? */
> -               if (system_ram >= start && system_ram < end) {
> +               if (total_mem >= start && total_mem < end) {
>                         *crash_size = size;
>                         break;
>                 }
> @@ -250,6 +260,12 @@ static int __init __parse_crashkernel(char *cmdline,
>         if (suffix)
>                 return parse_crashkernel_suffix(ck_cmdline, crash_size,
>                                 suffix);
> +#ifdef CONFIG_CRASH_AUTO_STR
> +       if (strncmp(ck_cmdline, "auto", 4) == 0) {
> +               ck_cmdline = CONFIG_CRASH_AUTO_STR;
> +               pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
> +       }
> +#endif
>         /*
>          * if the commandline contains a ':', then that's the extended
>          * syntax -- if not, it must be the classic syntax
> --
> 2.18.4
>


--
Best Regards,
Kairui Song

