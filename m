Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC0576562
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiGOQlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGOQlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:41:31 -0400
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA72624A0;
        Fri, 15 Jul 2022 09:41:29 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id r3so9328008ybr.6;
        Fri, 15 Jul 2022 09:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UvwfLw66R/P7k8ZVdzukFQ8abYNVRPzG+g6tIH2YHJ8=;
        b=u+lxk9HmSPeoxjEpwUXOP4UO+Oc9nLb9TJdk2lB9ykLc1GafHzls0lOHx+G1dYPgu7
         9xwBgtk8qBpxAFiuziIjV20SxEGIpaWViAYQAbEORCs365z3yQUPpEgm6wohGHM8mQB6
         fQErpxP6d1qsk3Rj9Yx3i4QiENJEZQpqYDXnY4N21vlCLZMqrtTau2qCvkd2/w8uMvHf
         mmDFV4OVdZ7H4siNQOmfaFOcp+8mSrx57A/jnEdBh2a4p99ojtjgXU5trUi2shOMj1Lc
         hx/dem5eZn9Xq+puCHJLitmfW70wc4QIL6jitsagADdhusCS89YhyN2YAf+sbp/mzNrS
         WCkg==
X-Gm-Message-State: AJIora88f39VOVuXvRWxD8VrDXiU/5KXMKRllM+1bEORn0ASg33LGGW3
        rH1tR4CKBc0sN4nT+Q+v/E9pfCzFoCx+mwStKnZ9x4+l
X-Google-Smtp-Source: AGRyM1vbk52b4PTIMyepiNCX50Et3/hR2FYDZGF2luietd8kabCMCwcigDx9h7LkJfN+B4X89PhLum0ZlW4vpxO2Ga8=
X-Received: by 2002:a05:6902:1207:b0:66e:f2d2:6e91 with SMTP id
 s7-20020a056902120700b0066ef2d26e91mr15502657ybu.153.1657903288940; Fri, 15
 Jul 2022 09:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220715142549.25223-1-jgross@suse.com> <20220715142549.25223-3-jgross@suse.com>
In-Reply-To: <20220715142549.25223-3-jgross@suse.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 15 Jul 2022 18:41:17 +0200
Message-ID: <CAJZ5v0hY_D3n3m51gG6r+7P0MVGAObLTDGy4stXYFKwLqtX6ew@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: add wrapper functions for mtrr functions
 handling also pat
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>, brchuckz@netscape.net,
        Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 4:25 PM Juergen Gross <jgross@suse.com> wrote:
>
> There are several MTRR functions which also do PAT handling. In order
> to support PAT handling without MTRR in the future, add some wrappers
> for those functions.
>
> Cc: <stable@vger.kernel.org> # 5.17
> Fixes: bdd8b6c98239 ("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Do I understand correctly that this particular patch doesn't change
the behavior?

If so, it would be good to mention that in the changelog.

> ---
>  arch/x86/include/asm/mtrr.h      |  2 --
>  arch/x86/include/asm/processor.h |  7 +++++
>  arch/x86/kernel/cpu/common.c     | 44 +++++++++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/mtrr/mtrr.c  | 25 +++---------------
>  arch/x86/kernel/setup.c          |  5 +---
>  arch/x86/kernel/smpboot.c        |  8 +++---
>  arch/x86/power/cpu.c             |  2 +-
>  7 files changed, 59 insertions(+), 34 deletions(-)
>
> diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
> index 12a16caed395..900083ac9f60 100644
> --- a/arch/x86/include/asm/mtrr.h
> +++ b/arch/x86/include/asm/mtrr.h
> @@ -43,7 +43,6 @@ extern int mtrr_del(int reg, unsigned long base, unsigned long size);
>  extern int mtrr_del_page(int reg, unsigned long base, unsigned long size);
>  extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
>  extern void mtrr_ap_init(void);
> -extern void set_mtrr_aps_delayed_init(void);
>  extern void mtrr_aps_init(void);
>  extern void mtrr_bp_restore(void);
>  extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
> @@ -86,7 +85,6 @@ static inline void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
>  {
>  }
>  #define mtrr_ap_init() do {} while (0)
> -#define set_mtrr_aps_delayed_init() do {} while (0)
>  #define mtrr_aps_init() do {} while (0)
>  #define mtrr_bp_restore() do {} while (0)
>  #define mtrr_disable() do {} while (0)
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 5c934b922450..e2140204fb7e 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -865,7 +865,14 @@ bool arch_is_platform_page(u64 paddr);
>  #define arch_is_platform_page arch_is_platform_page
>  #endif
>
> +extern bool cache_aps_delayed_init;
> +
>  void cache_disable(void);
>  void cache_enable(void);
> +void cache_bp_init(void);
> +void cache_ap_init(void);
> +void cache_set_aps_delayed_init(void);
> +void cache_aps_init(void);
> +void cache_bp_restore(void);
>
>  #endif /* _ASM_X86_PROCESSOR_H */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index e43322f8a4ef..0a1bd14f7966 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1929,7 +1929,7 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
>  #ifdef CONFIG_X86_32
>         enable_sep_cpu();
>  #endif
> -       mtrr_ap_init();
> +       cache_ap_init();
>         validate_apic_and_package_id(c);
>         x86_spec_ctrl_setup_ap();
>         update_srbds_msr();
> @@ -2403,3 +2403,45 @@ void cache_enable(void) __releases(cache_disable_lock)
>
>         raw_spin_unlock(&cache_disable_lock);
>  }
> +
> +void __init cache_bp_init(void)
> +{
> +       if (IS_ENABLED(CONFIG_MTRR))
> +               mtrr_bp_init();
> +       else
> +               pat_disable("PAT support disabled because CONFIG_MTRR is disabled in the kernel.");
> +}
> +
> +void cache_ap_init(void)
> +{
> +       if (cache_aps_delayed_init)
> +               return;
> +
> +       mtrr_ap_init();
> +}
> +
> +bool cache_aps_delayed_init;
> +
> +void cache_set_aps_delayed_init(void)
> +{
> +       cache_aps_delayed_init = true;
> +}
> +
> +void cache_aps_init(void)
> +{
> +       /*
> +        * Check if someone has requested the delay of AP cache initialization,
> +        * by doing cache_set_aps_delayed_init(), prior to this point. If not,
> +        * then we are done.
> +        */
> +       if (!cache_aps_delayed_init)
> +               return;
> +
> +       mtrr_aps_init();
> +       cache_aps_delayed_init = false;
> +}
> +
> +void cache_bp_restore(void)
> +{
> +       mtrr_bp_restore();
> +}
> diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
> index 2746cac9d8a9..c1593cfae641 100644
> --- a/arch/x86/kernel/cpu/mtrr/mtrr.c
> +++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
> @@ -69,7 +69,6 @@ unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
>  static DEFINE_MUTEX(mtrr_mutex);
>
>  u64 size_or_mask, size_and_mask;
> -static bool mtrr_aps_delayed_init;
>
>  static const struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM] __ro_after_init;
>
> @@ -176,7 +175,8 @@ static int mtrr_rendezvous_handler(void *info)
>         if (data->smp_reg != ~0U) {
>                 mtrr_if->set(data->smp_reg, data->smp_base,
>                              data->smp_size, data->smp_type);
> -       } else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
> +       } else if ((use_intel() && cache_aps_delayed_init) ||
> +                  !cpu_online(smp_processor_id())) {
>                 mtrr_if->set_all();
>         }
>         return 0;
> @@ -789,7 +789,7 @@ void mtrr_ap_init(void)
>         if (!mtrr_enabled())
>                 return;
>
> -       if (!use_intel() || mtrr_aps_delayed_init)
> +       if (!use_intel())
>                 return;
>
>         /*
> @@ -823,16 +823,6 @@ void mtrr_save_state(void)
>         smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
>  }
>
> -void set_mtrr_aps_delayed_init(void)
> -{
> -       if (!mtrr_enabled())
> -               return;
> -       if (!use_intel())
> -               return;
> -
> -       mtrr_aps_delayed_init = true;
> -}
> -
>  /*
>   * Delayed MTRR initialization for all AP's
>   */
> @@ -841,16 +831,7 @@ void mtrr_aps_init(void)
>         if (!use_intel() || !mtrr_enabled())
>                 return;
>
> -       /*
> -        * Check if someone has requested the delay of AP MTRR initialization,
> -        * by doing set_mtrr_aps_delayed_init(), prior to this point. If not,
> -        * then we are done.
> -        */
> -       if (!mtrr_aps_delayed_init)
> -               return;
> -
>         set_mtrr(~0U, 0, 0, 0);
> -       mtrr_aps_delayed_init = false;
>  }
>
>  void mtrr_bp_restore(void)
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index bd6c6fd373ae..27d61f73c68a 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1001,10 +1001,7 @@ void __init setup_arch(char **cmdline_p)
>         max_pfn = e820__end_of_ram_pfn();
>
>         /* update e820 for memory not covered by WB MTRRs */
> -       if (IS_ENABLED(CONFIG_MTRR))
> -               mtrr_bp_init();
> -       else
> -               pat_disable("PAT support disabled because CONFIG_MTRR is disabled in the kernel.");
> +       cache_bp_init();
>
>         if (mtrr_trim_uncached_memory(max_pfn))
>                 max_pfn = e820__end_of_ram_pfn();
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 5e7f9532a10d..535d73a47062 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1432,7 +1432,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>
>         uv_system_init();
>
> -       set_mtrr_aps_delayed_init();
> +       cache_set_aps_delayed_init();
>
>         smp_quirk_init_udelay();
>
> @@ -1443,12 +1443,12 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>
>  void arch_thaw_secondary_cpus_begin(void)
>  {
> -       set_mtrr_aps_delayed_init();
> +       cache_set_aps_delayed_init();
>  }
>
>  void arch_thaw_secondary_cpus_end(void)
>  {
> -       mtrr_aps_init();
> +       cache_aps_init();
>  }
>
>  /*
> @@ -1491,7 +1491,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
>
>         nmi_selftest();
>         impress_friends();
> -       mtrr_aps_init();
> +       cache_aps_init();
>  }
>
>  static int __initdata setup_possible_cpus = -1;
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index bb176c72891c..21e014715322 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -261,7 +261,7 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
>         do_fpu_end();
>         tsc_verify_tsc_adjust(true);
>         x86_platform.restore_sched_clock_state();
> -       mtrr_bp_restore();
> +       cache_bp_restore();
>         perf_restore_debug_store();
>
>         c = &cpu_data(smp_processor_id());
> --
> 2.35.3
>
