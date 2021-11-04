Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545994458A5
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhKDRjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 13:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbhKDRjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 13:39:21 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAEAC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 10:36:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u11so8438080plf.3
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 10:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JE7BWh7EPof2q1qNnDyfyKa+RjN00TLgKWFmUR6xPto=;
        b=s4ImMsgGQUm6mPzKM3B7NN46K9mZpThq5Ex5NXxELwvAQv//gJkb4OoJtyk5iSzmpJ
         I3mUqa9VU+FgsWW4eNq0E4V7DBBnLF25zbym4s98B02IKYUoSPfPj1BB4YzC1qo7K7e1
         F8jpINNbsAP8yMlNfJafwBgadBd8zcPhur4Z2vkwy2W9QNtrtM7+gkb903YGkJCxe8iN
         6KMSxmUCQVTgc+DflfDvjhll8s9mck6+NRGbQaeVC2SOY+zcKv3+9PjY4HIgqGSGD/BX
         lQWt6XNSDiGQnx8Jy4M+Y4En33jGcYPby6DS7HsWd/4tD4V2VUNhWEuYojKIx0iN9S+0
         XgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JE7BWh7EPof2q1qNnDyfyKa+RjN00TLgKWFmUR6xPto=;
        b=P2ZoZeyah+HnjnKj6LGCAccwarjl+Mo20gRJgtBaKXJw/GvAvJc42QnhRebjpoTlAk
         0Fnnvzonq7f3i+8PdWBvRSBdU11gbS/clEAjlX2Rd72b3xCkb4Mozagh2rVJMUBRw2Hc
         us7qYzCJxcJUHU7yJykXWgi00mKV42QLjKDbVSEOJdEvTGXYHm+HODAtxFSbGkcYMKv5
         vnpv+aJ7xM2yq8NEHrmgnjgqY8B6ahqoqJBjwxRCbV3M7sZzr8l+dDBdoRFxc9awUA3I
         W3/juimZjjk5WhI03pEtKNHrWyI4/xnPu5CR2Dp7cOy5ilyvQTpFvNY2guOv9exRaE3L
         pC/w==
X-Gm-Message-State: AOAM532ngqtp2d/e0BX9uvgkbCs9l2klXG78VKcRVWRFaV9RmRr0o8HC
        K6E6ZmNoksnwuJysIY87uUHM7hgUauUvrkfSKheDY4v6VQevdg==
X-Google-Smtp-Source: ABdhPJxhy9V27nPMVN+tx+tjsLztlj8rfRnBWeo/tBj0oVDBrpNcAk5x1jeblAAtaMT+o1c3DeS+/bIsOjJYVJqUKEA=
X-Received: by 2002:a17:902:aa84:b0:142:36cb:2a47 with SMTP id
 d4-20020a170902aa8400b0014236cb2a47mr4251518plr.89.1636047402658; Thu, 04 Nov
 2021 10:36:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210920120421.29276-1-jgross@suse.com> <163233113662.25758.10031107028271701591.tip-bot2@tip-bot2>
 <e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com> <YYPGsUNm0UXcYKOA@zn.tnic>
In-Reply-To: <YYPGsUNm0UXcYKOA@zn.tnic>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 4 Nov 2021 10:36:32 -0700
Message-ID: <CAPcyv4jG359gnhJz=RdX_cKuh8awcBCzyRCJ1uKyfKCj-nFqvg@mail.gmail.com>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
To:     Borislav Petkov <bp@alien8.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "marmarek@invisiblethingslab.com" <marmarek@invisiblethingslab.com>,
        "Chagam, Anjaneya" <anjaneya.chagam@intel.com>,
        "bp@suse.de" <bp@suse.de>, "x86@kernel.org" <x86@kernel.org>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 4, 2021 at 4:40 AM Borislav Petkov <bp@alien8.de> wrote:
>
> + Mike.
>
> On Thu, Nov 04, 2021 at 05:38:54AM +0000, Williams, Dan J wrote:
> > By inspection, this commit looks like the source of the problem because
> > early_reserve_memory() now runs before parse_early_param().
>
> Yah, I see it too:
>
> early_reserve_memory
> |-> efi_memblock_x86_reserve_range
>     |-> efi_fake_memmap_early
>
> which does
>
>         if (!efi_soft_reserve_enabled())
>                 return;
>
> and that would have set EFI_MEM_NO_SOFT_RESERVE after having parsed
> "nosoftreserve".
>
> And parse_early_param() happens later.
>
> Uuuf, that early memory reservation dance is not going to be over,
> ever...
>
> Well, I guess we can do something like this below. The intent being to
> carve out the command line preparation into a separate function which
> does the early param parsing too. So that it all goes together.
>
> And then call that function before early_reserve_memory() so that the
> params have been parsed by then.
>
> Looking at the changed flow, I think we should be ok but I've said that
> a bunch of times already regarding this memory reservation early and
> something in our house of cards called early boot order always broke.
>
> Damn.

Thanks Boris!

You can add:

Tested-by: Anjaneya Chagam <anjaneya.chagam@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> ---
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 40ed44ead063..05f69e7d84dc 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -742,6 +742,28 @@ dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
>         return 0;
>  }
>
> +static char *prepare_command_line(void)
> +{
> +#ifdef CONFIG_CMDLINE_BOOL
> +#ifdef CONFIG_CMDLINE_OVERRIDE
> +       strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> +#else
> +       if (builtin_cmdline[0]) {
> +               /* append boot loader cmdline to builtin */
> +               strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
> +               strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
> +               strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> +       }
> +#endif
> +#endif
> +
> +       strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> +
> +       parse_early_param();
> +
> +       return command_line;
> +}
> +
>  /*
>   * Determine if we were loaded by an EFI loader.  If so, then we have also been
>   * passed the efi memmap, systab, etc., so we should use these data structures
> @@ -830,6 +852,23 @@ void __init setup_arch(char **cmdline_p)
>
>         x86_init.oem.arch_setup();
>
> +       /*
> +        * x86_configure_nx() is called before parse_early_param() (called by
> +        * prepare_command_line()) to detect whether hardware doesn't support
> +        * NX (so that the early EHCI debug console setup can safely call
> +        * set_fixmap()). It may then be called again from within noexec_setup()
> +        * during parsing early parameters to honor the respective command line
> +        * option.
> +        */
> +       x86_configure_nx();
> +
> +       /*
> +        * This parses early params and it needs to run before
> +        * early_reserve_memory() because latter relies on such settings
> +        * supplies as early params.
> +        */
> +       *cmdline_p = prepare_command_line();
> +
>         /*
>          * Do some memory reservations *before* memory is added to memblock, so
>          * memblock allocations won't overwrite it.
> @@ -863,33 +902,6 @@ void __init setup_arch(char **cmdline_p)
>         bss_resource.start = __pa_symbol(__bss_start);
>         bss_resource.end = __pa_symbol(__bss_stop)-1;
>
> -#ifdef CONFIG_CMDLINE_BOOL
> -#ifdef CONFIG_CMDLINE_OVERRIDE
> -       strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> -#else
> -       if (builtin_cmdline[0]) {
> -               /* append boot loader cmdline to builtin */
> -               strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
> -               strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
> -               strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> -       }
> -#endif
> -#endif
> -
> -       strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> -       *cmdline_p = command_line;
> -
> -       /*
> -        * x86_configure_nx() is called before parse_early_param() to detect
> -        * whether hardware doesn't support NX (so that the early EHCI debug
> -        * console setup can safely call set_fixmap()). It may then be called
> -        * again from within noexec_setup() during parsing early parameters
> -        * to honor the respective command line option.
> -        */
> -       x86_configure_nx();
> -
> -       parse_early_param();
> -
>  #ifdef CONFIG_MEMORY_HOTPLUG
>         /*
>          * Memory used by the kernel cannot be hot-removed because Linux
>
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
