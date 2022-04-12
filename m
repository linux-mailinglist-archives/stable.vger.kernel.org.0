Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D79F4FCF14
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347031AbiDLFuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344379AbiDLFuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62FF28E21;
        Mon, 11 Apr 2022 22:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EBDA61862;
        Tue, 12 Apr 2022 05:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9C6C385A1;
        Tue, 12 Apr 2022 05:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649742501;
        bh=cgeRhs/ApvaNYGH9iK4LRCPUOGebM4VMdLU7Lqm3pX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hz3lhBD7U6q5FzF5hZ/3QVxJefBQgc5VuY1K3mZ/TxI12pXAnzSmWMR6pJX2YHAuk
         USjdZPoISoZD1tms2GUZVMf9pGud1uouYQ5Lbe88j4pyfdcLHEy/MwDEti3CadZCcq
         PuMVteSKn7695NaXSUSg6ppHqhRDfIkmCleKZ3ms=
Date:   Tue, 12 Apr 2022 07:48:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [stable:PATCH v4.9.309 40/43] arm64: Mitigate spectre style
 branch history side channels
Message-ID: <YlUSootNwoUIIOow@kroah.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
 <20220406164546.1888528-40-james.morse@arm.com>
 <82b7cb2e-825a-0efc-daae-98aa556c5086@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82b7cb2e-825a-0efc-daae-98aa556c5086@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 08, 2022 at 05:56:34PM +0100, James Morse wrote:
> Hi Greg,
> 
> On 06/04/2022 17:45, James Morse wrote:
> > commit 558c303c9734af5a813739cd284879227f7297d2 upstream.
> > 
> > Speculation attacks against some high-performance processors can
> > make use of branch history to influence future speculation.
> > When taking an exception from user-space, a sequence of branches
> > or a firmware call overwrites or invalidates the branch history.
> > 
> > The sequence of branches is added to the vectors, and should appear
> > before the first indirect branch. For systems using KPTI the sequence
> > is added to the kpti trampoline where it has a free register as the exit
> > from the trampoline is via a 'ret'. For systems not using KPTI, the same
> > register tricks are used to free up a register in the vectors.
> > 
> > For the firmware call, arch-workaround-3 clobbers 4 registers, so
> > there is no choice but to save them to the EL1 stack. This only happens
> > for entry from EL0, so if we take an exception due to the stack access,
> > it will not become re-entrant.
> > 
> > For KVM, the existing branch-predictor-hardening vectors are used.
> > When a spectre version of these vectors is in use, the firmware call
> > is sufficient to mitigate against Spectre-BHB. For the non-spectre
> > versions, the sequence of branches is added to the indirect vector.
> 
> 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 42719bd58046..6d12c3b78777 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -799,6 +799,16 @@ config ARM64_SSBD
> >  
> >  	  If unsure, say Y.
> >  
> > +config MITIGATE_SPECTRE_BRANCH_HISTORY
> > +	bool "Mitigate Spectre style attacks against branch history" if EXPERT
> > +	default y
> > +	depends on HARDEN_BRANCH_PREDICTOR || !KVM
> > +	help
> > +	  Speculation attacks against some high-performance processors can
> > +	  make use of branch history to influence future speculation.
> > +	  When taking an exception from user-space, a sequence of branches
> > +	  or a firmware call overwrites the branch history.
> 
> The build problem reported here[]0 is due to enabling CONFIG_EXPERT, and disabling
> CONFIG_HARDEN_BRANCH_PREDICTOR and CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY: The harden_bp
> stuff uses #ifdef all over the place, whereas the BHB bits use IS_ENABLED(). As there are
> dependencies between the two, mixing them doesn't go well.
> 
> The fix is a little noisy. The reason is the 'matches' support ought to be kept even if
> the feature is disabled so that the sysfs files still report Vulnerable on affected
> hardware, regardless of the Kconfig.
> 
> ------------------------>%------------------------
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index d6bc44a7d471..ae364d6b37ac 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -561,7 +561,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>                 .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>                 .capability = ARM64_SPECTRE_BHB,
>                 .matches = is_spectre_bhb_affected,
> +#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
>                 .cpu_enable = spectre_bhb_enable_mitigation,
> +#endif
>         },
>         {
>         }
> @@ -571,8 +573,8 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>   * We try to ensure that the mitigation state can never change as the result of
>   * onlining a late CPU.
>   */
> -static void update_mitigation_state(enum mitigation_state *oldp,
> -                                   enum mitigation_state new)
> +static void __maybe_unused update_mitigation_state(enum mitigation_state *oldp,
> +                                                  enum mitigation_state new)
>  {
>         enum mitigation_state state;
> 
> @@ -708,7 +710,7 @@ static bool is_spectre_bhb_fw_affected(int scope)
>         return false;
>  }
> 
> -static bool supports_ecbhb(int scope)
> +static bool __maybe_unused supports_ecbhb(int scope)
>  {
>         u64 mmfr1;
> 
> @@ -738,6 +740,7 @@ bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry,
>         return false;
>  }
> 
> +#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>  static void this_cpu_set_vectors(enum arm64_bp_harden_el1_vectors slot)
>  {
>         const char *v = arm64_get_bp_hardening_vector(slot);
> @@ -812,7 +815,7 @@ static void kvm_setup_bhb_slot(const char *hyp_vecs_start)
>  #define __spectre_bhb_loop_k32_start NULL
> 
>  static void kvm_setup_bhb_slot(const char *hyp_vecs_start) { };
> -#endif
> +#endif /* CONFIG_KVM */
> 
>  static bool is_spectrev2_safe(void)
>  {
> @@ -891,3 +894,4 @@ void __init spectre_bhb_patch_loop_iter(struct alt_instr *alt,
>                                          AARCH64_INSN_MOVEWIDE_ZERO);
>         *updptr++ = cpu_to_le32(insn);
>  }
> +#endif /* CONFIG_HARDEN_BRANCH_PREDICTOR */
> ------------------------>%------------------------
> 
> 
> This version of the backport isn't affected by Will's report here:
> https://lore.kernel.org/linux-arm-kernel/20220408120041.GB27685@willie-the-truck/
> as Kconfig describes that dependency as it was too hard to unpick with the helpers v4.9 has.

Thanks for the fixup, now applied, and it passes my local testing here
with the failed configuration.  I'll push out a release and see if it
breaks anyone :)

greg k-h
