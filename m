Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BDB1FFED
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 09:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEPHE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 03:04:56 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:37480 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfEPHE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 03:04:56 -0400
Received: by mail-vs1-f66.google.com with SMTP id o5so1641602vsq.4;
        Thu, 16 May 2019 00:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q015/QHSXrok6Bw3iqMxHNHZLCbCNdwdW05xVaqSbFA=;
        b=Adg2mPG3Opp+lMa037EF7O/Z1k8qcMAVRXY/0GcL5pmFYE4HfMGm08a0FIZgCUx/R5
         8p0gqUgNp1uXo83fe0Bvp+XcCTJ+f7CL1DZYA2871cudz2eKINib1AMy7ZoH4O7XEKgj
         cnNYXnnpGXoaqesWVesiJuB/7AHR53r8ohgG/JJ/ZMkfJIR5oz/YDxTaOzbw7Aw4LCsY
         ZmwoXeDMXEW37JXu8THg6noFDcbR2CDSRP5KUVn8hL6jA/sla/eKVoOuHWyBaaTqr/8R
         h7u4TlCjVHWXOuKyLSRRIxdidBroJHs9SBWaj3y9u/Pp1RyZDPvuu2afgGjJUVpnb30v
         240Q==
X-Gm-Message-State: APjAAAU2EBzwMfTpnl15FnXKz03Rx4nSwgbdczpkO7u/F24d7+uOXEH1
        N/QHtB3e9hA76qWno7WlR3DpuxUzPyAbzoIo8O8=
X-Google-Smtp-Source: APXvYqw6dkP3FpbWRddQ96QVJAiiTPvgI18vgQaVewrbrBgFk7NwzmrgB/94Q+BFkCvWo9DPpaDiVAnXWQvZ+5swDfg=
X-Received: by 2002:a67:f303:: with SMTP id p3mr11428563vsf.166.1557990294356;
 Thu, 16 May 2019 00:04:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190515090722.696531131@linuxfoundation.org> <20190515090731.364702401@linuxfoundation.org>
In-Reply-To: <20190515090731.364702401@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 May 2019 09:04:41 +0200
Message-ID: <CAMuHMdVFaQLbH7F=Ard5MzUzG1FTfwLH=7xz=LpA3YaZyj2+Zg@mail.gmail.com>
Subject: Re: [PATCH 4.4 247/266] cpu/speculation: Add mitigations= cmdline option
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Steven Price <steven.price@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jon Masters <jcm@redhat.com>, Waiman Long <longman@redhat.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Jiri Kosina <jikos@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Phil Auld <pauld@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Ben,

On Wed, May 15, 2019 at 1:12 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
>
> commit 98af8452945c55652de68536afdde3b520fec429 upstream.
>
> Keeping track of the number of mitigations for all the CPU speculation
> bugs has become overwhelming for many users.  It's getting more and more
> complicated to decide which mitigations are needed for a given
> architecture.  Complicating matters is the fact that each arch tends to
> have its own custom way to mitigate the same vulnerability.
>
> Most users fall into a few basic categories:
>
> a) they want all mitigations off;
>
> b) they want all reasonable mitigations on, with SMT enabled even if
>    it's vulnerable; or
>
> c) they want all reasonable mitigations on, with SMT disabled if
>    vulnerable.
>
> Define a set of curated, arch-independent options, each of which is an
> aggregation of existing options:
>
> - mitigations=off: Disable all mitigations.
>
> - mitigations=auto: [default] Enable all the default mitigations, but
>   leave SMT enabled, even if it's vulnerable.
>
> - mitigations=auto,nosmt: Enable all the default mitigations, disabling
>   SMT if needed by a mitigation.
>
> Currently, these options are placeholders which don't actually do
> anything.  They will be fleshed out in upcoming patches.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

> [bwh: Backported to 4.4:
>  - Drop the auto,nosmt option which we can't support

This doesn't really stand out. I.e. I completely missed it, and started
wondering why "auto,nosmt" was not documented in
kernel-parameters.txt below...

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2173,6 +2173,25 @@ bytes respectively. Such letter suffixes
>                         in the "bleeding edge" mini2440 support kernel at
>                         http://repo.or.cz/w/linux-2.6/mini2440.git
>
> +       mitigations=
> +                       Control optional mitigations for CPU vulnerabilities.
> +                       This is a set of curated, arch-independent options, each
> +                       of which is an aggregation of existing arch-specific
> +                       options.
> +
> +                       off
> +                               Disable all optional CPU mitigations.  This
> +                               improves system performance, but it may also
> +                               expose users to several CPU vulnerabilities.
> +
> +                       auto (default)
> +                               Mitigate all CPU vulnerabilities, but leave SMT
> +                               enabled, even if it's vulnerable.  This is for
> +                               users who don't want to be surprised by SMT
> +                               getting disabled across kernel upgrades, or who
> +                               have other ways of avoiding SMT-based attacks.
> +                               This is the default behavior.
> +
>         mminit_loglevel=
>                         [KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
>                         parameter allows control of the logging verbosity for

> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -842,3 +842,16 @@ void init_cpu_online(const struct cpumas
>  {
>         cpumask_copy(to_cpumask(cpu_online_bits), src);
>  }
> +
> +enum cpu_mitigations cpu_mitigations = CPU_MITIGATIONS_AUTO;
> +
> +static int __init mitigations_parse_cmdline(char *arg)
> +{
> +       if (!strcmp(arg, "off"))
> +               cpu_mitigations = CPU_MITIGATIONS_OFF;
> +       else if (!strcmp(arg, "auto"))
> +               cpu_mitigations = CPU_MITIGATIONS_AUTO;

Perhaps

    else
            pr_crit("mitigations=%s is not supported\n", arg);

?

Actually that makes sense on mainline, too.
Cooking a patch...

> +
> +       return 0;
> +}
> +early_param("mitigations", mitigations_parse_cmdline);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
