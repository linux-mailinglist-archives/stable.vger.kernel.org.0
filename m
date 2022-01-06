Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB50486906
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 18:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242161AbiAFRqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 12:46:18 -0500
Received: from mail-qk1-f169.google.com ([209.85.222.169]:45602 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiAFRqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 12:46:15 -0500
Received: by mail-qk1-f169.google.com with SMTP id e25so3375816qkl.12;
        Thu, 06 Jan 2022 09:46:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A+kg58RJUdU3TEwPb/OXklUxQQrIJTYnYTJT2lTmJPE=;
        b=BwNjvGeerVNwqB/3jq8sJ8NdJYLJtcg6uOyFtLTgEXRsJRrOhhtR0Orc+IHi9zJC4E
         3gmEVlPgth433qJXT5Iz7no3nccCfJz9Yruv2XlXLMFL6x7Veokbwa/e10zrquNMBV4e
         dO/anLU1T2Z4UzqHqGnnUHz4KcCpeBVzxWH3ieBH2K4NLtegH4z6J7yK6vmYjtDGeSEW
         xXZV6xAAOcUF3POn0R+/ZAoY1CQ1wsXwnPHxuEG3oIcRln0FxsODaw/i4jt5nUzpDS9W
         6V1GvyFC5I+1gA/nXtjs0iBPO9JCSwFEf6aePY2/Y/qHyek28OML72l9+y0wTOCNoX86
         6hEg==
X-Gm-Message-State: AOAM532HxgbJQoRpOYTj2wleuFreXxla3RrOdGwDXEUNIlAgE1L6iOue
        8dO5uGqGcS5R5rCmYjrfxFAccrwPJVulUgJJEALWe8JP
X-Google-Smtp-Source: ABdhPJwE49C7LXEuMuTMeRtwOkwL04MrpLdEggN+HnPC2axjH4ETbdW428FVIjbRJDqQprvsCK39aMa+dtBQp/zGUXA=
X-Received: by 2002:a05:620a:40cc:: with SMTP id g12mr2029849qko.621.1641491175098;
 Thu, 06 Jan 2022 09:46:15 -0800 (PST)
MIME-Version: 1.0
References: <20220106074306.2712090-1-ray.huang@amd.com> <20220106074306.2712090-2-ray.huang@amd.com>
 <CAJZ5v0htW=twuLY88XJmLGnDtmmjoav=Z8WLZZcjG29-YKQMog@mail.gmail.com>
In-Reply-To: <CAJZ5v0htW=twuLY88XJmLGnDtmmjoav=Z8WLZZcjG29-YKQMog@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 6 Jan 2022 18:46:04 +0100
Message-ID: <CAJZ5v0iH=rAgC0YPcCv_zoMtNoA1hG=ZGgLRdrgKqWAjmsYqcw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
To:     Huang Rui <ray.huang@amd.com>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Perry Yuan <Perry.Yuan@amd.com>,
        Jinzhou Su <Jinzhou.Su@amd.com>,
        Xiaojian Du <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 6, 2022 at 6:12 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Thu, Jan 6, 2022 at 8:43 AM Huang Rui <ray.huang@amd.com> wrote:
> >
> > The init_freq_invariance_cppc function is implemented in smpboot and depends on
> > CONFIG_SMP.
> >
> >   MODPOST vmlinux.symvers
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> >   LD      .tmp_vmlinux.kallsyms1
> > ld: drivers/acpi/cppc_acpi.o: in function `acpi_cppc_processor_probe':
> > /home/ray/brahma3/linux/drivers/acpi/cppc_acpi.c:819: undefined reference to `init_freq_invariance_cppc'
> > make: *** [Makefile:1161: vmlinux] Error 1
> >
> > See https://lore.kernel.org/lkml/484af487-7511-647e-5c5b-33d4429acdec@infradead.org/.
> >
> > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: x86@kernel.org
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/x86/include/asm/topology.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> > index cc164777e661..2f0b6be8eaab 100644
> > --- a/arch/x86/include/asm/topology.h
> > +++ b/arch/x86/include/asm/topology.h
> > @@ -221,7 +221,7 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_ACPI_CPPC_LIB
> > +#if defined(CONFIG_ACPI_CPPC_LIB) && defined(CONFIG_SMP)
> >  void init_freq_invariance_cppc(void);
> >  #define init_freq_invariance_cppc init_freq_invariance_cppc
>
> Why don't you check CONFIG_SMP instead of this symbol in cppc_acpi.c?
> That file depends on CONFIG_ACPI_CPPC_LIB anyway.

Scratch that, it needs to compile on non-x86 too.

The $subject patch is cleaner than all of the alternatives I have
considered, so I'm going to apply it.

However, I'm not really happy with the dependencies between CPPC and
smpboot.c going both ways.
