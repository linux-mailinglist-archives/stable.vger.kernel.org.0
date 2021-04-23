Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836D1369418
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 15:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhDWNyZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 23 Apr 2021 09:54:25 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:33604 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhDWNyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 09:54:24 -0400
Received: by mail-ot1-f42.google.com with SMTP id 92-20020a9d02e50000b029028fcc3d2c9eso22866864otl.0;
        Fri, 23 Apr 2021 06:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IlVuTaydnitx16M/SV8QHZMWLqzW7hKNG71N88pb3IU=;
        b=LhBfOGVZOKAr+Mt8acGmm352bqhbfS/oPK/ahU/ckrNZhobcbrzU8w0EZWdFz0rc2e
         N6I8o9BlXwyvIPs19rPKcV6+2l4SfuhfhMNBDMGW7QtlrNjDWaEU8Qv71fP/6DSEI+un
         cLfuLjztdFdYY3lpFEt5vMZLVanF0wFz2J1YbArsvfMJEw/G9jyZRb3PFmwSgVFHJ8+o
         1OPZ9pp7dMDOm8J8/ZDvjW0Ct4r8XoIydcwmpOixKSgyBIjc0Ed0zGiIp5Yap9feq5fl
         2Lh7yB8l5rV+LtylHRjiwFqW41jkl2ZgZFl0+NC7Rra71LoUEHrMOBMoPeUb0gCaNyN6
         GZVw==
X-Gm-Message-State: AOAM533hsSwrbA7aClYSECRVHo+ZvEJCVhW5Grsxkny2zanf7o3FohO6
        D/YB5n+k5a7G6RS+Bt13x/8pID94FT96DflLso8=
X-Google-Smtp-Source: ABdhPJw8Cg0F0Dm1dYCeeIJY9rOhvZJvF/zuE9mRZkL3bz7sLak4HfLPsLodL11q9P0piALLp2lSeKJGO1aAPiv9ED4=
X-Received: by 2002:a9d:6951:: with SMTP id p17mr3625082oto.206.1619186028094;
 Fri, 23 Apr 2021 06:53:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210423023928.688767-1-ray.huang@amd.com> <CAJZ5v0iH0-YL-yVPSA2oJF7PGfQs5Tcv5ktH43xMLPAKysDXPw@mail.gmail.com>
 <20210423125208.GA688865@hr-amd>
In-Reply-To: <20210423125208.GA688865@hr-amd>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 23 Apr 2021 15:53:37 +0200
Message-ID: <CAJZ5v0i3QUbhRqBKDuNzYoxy254Kq-36G30cVWLazQo+uUhJTw@mail.gmail.com>
Subject: Re: [PATCH v3] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
To:     Huang Rui <ray.huang@amd.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Fontenot, Nathan" <Nathan.Fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 2:52 PM Huang Rui <ray.huang@amd.com> wrote:
>
> On Fri, Apr 23, 2021 at 08:09:49PM +0800, Rafael J. Wysocki wrote:
> > On Fri, Apr 23, 2021 at 4:40 AM Huang Rui <ray.huang@amd.com> wrote:
> > >
> > > Some AMD Ryzen generations has different calculation method on maximum
> > > perf. 255 is not for all asics, some specific generations should use 166
> > > as the maximum perf. Otherwise, it will report incorrect frequency value
> > > like below:
> > >
> > > ~  $B"* (B lscpu | grep MHz
> > > CPU MHz:                         3400.000
> > > CPU max MHz:                     7228.3198
> > > CPU min MHz:                     2200.0000
> > >
> > > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> > > Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
> > >
> > > Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > > Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > > Bugzilla: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D211791&amp;data=04%7C01%7Cray.huang%40amd.com%7Ce9ed877387fc4b7431e108d90650b98f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637547766057950380%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=R%2FSBLaYOhTjrli%2BT054EytKeh8VmN7ryOQuQW4mgz6M%3D&amp;reserved=0
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: Nathan Fontenot <nathan.fontenot@amd.com>
> > > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: x86@kernel.org
> > > Cc: stable@vger.kernel.org
> > > ---
> > >
> > > Changes from V1 -> V2:
> > > - Enhance the commit message.
> > > - Move amd_get_highest_perf() into amd.c.
> > > - Refine the implementation of switch-case.
> > > - Cc stable mail list.
> > >
> > > Changes from V2 -> V3:
> > > - Move the update into cppc_get_perf_caps() to correct the highest perf value in
> > >   the API.
> > >
> > > ---
> > >  arch/x86/include/asm/processor.h |  2 ++
> > >  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
> > >  drivers/acpi/cppc_acpi.c         |  8 ++++++--
> > >  3 files changed, 30 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> > > index f1b9ed5efaa9..908bcaea1361 100644
> > > --- a/arch/x86/include/asm/processor.h
> > > +++ b/arch/x86/include/asm/processor.h
> > > @@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
> > >
> > >  #ifdef CONFIG_CPU_SUP_AMD
> > >  extern u32 amd_get_nodes_per_socket(void);
> > > +extern u32 amd_get_highest_perf(void);
> > >  #else
> > >  static inline u32 amd_get_nodes_per_socket(void)       { return 0; }
> > > +static inline u32 amd_get_highest_perf(void)           { return 0; }
> > >  #endif
> > >
> > >  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> > > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > > index 347a956f71ca..aadb691d9357 100644
> > > --- a/arch/x86/kernel/cpu/amd.c
> > > +++ b/arch/x86/kernel/cpu/amd.c
> > > @@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> > >                 break;
> > >         }
> > >  }
> > > +
> > > +u32 amd_get_highest_perf(void)
> > > +{
> > > +       struct cpuinfo_x86 *c = &boot_cpu_data;
> > > +       u32 cppc_max_perf = 225;
> > > +
> > > +       switch (c->x86) {
> > > +       case 0x17:
> > > +               if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > > +                   (c->x86_model >= 0x70 && c->x86_model < 0x80))
> > > +                       cppc_max_perf = 166;
> > > +               break;
> > > +       case 0x19:
> > > +               if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > > +                   (c->x86_model >= 0x40 && c->x86_model < 0x70))
> > > +                       cppc_max_perf = 166;
> > > +               break;
> > > +       }
> > > +
> > > +       return cppc_max_perf;
> > > +}
> > > +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> > > diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
> > > index 69057fcd2c04..58e72b6e222f 100644
> > > --- a/drivers/acpi/cppc_acpi.c
> > > +++ b/drivers/acpi/cppc_acpi.c
> > > @@ -1107,8 +1107,12 @@ int cppc_get_perf_caps(int cpunum, struct cppc_perf_caps *perf_caps)
> > >                 }
> > >         }
> > >
> > > -       cpc_read(cpunum, highest_reg, &high);
> > > -       perf_caps->highest_perf = high;
> > > +       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
> >
> > This is a generic arch-independent file.
> >
> > Can we avoid adding the x86-specific check here?
>
> OK, I see, it will be used by ARM as well.
>
> Can I rollback to implementation of V2:
>
> https://lore.kernel.org/r/20210421023807.1540290-1-ray.huang@amd.com

This would work IMO, but it can be simplified somewhat AFAICS.

The obvious drawback is that amd_get_highest_perf() would need to be
called directly wherever the CPPC highest perf is needed and the
vendor may be AMD.

> If stick to add quirk in cppc_acpi.c and avoid x86-specific check at the
> same time here, the code will not be straight forward. Or will you have any
> other good idea?

Not at the moment, sorry.
