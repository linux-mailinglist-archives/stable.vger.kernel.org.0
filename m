Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D7E59B3C0
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiHUM0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 08:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiHUM0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 08:26:13 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6818A23BE7;
        Sun, 21 Aug 2022 05:26:12 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9882329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9882:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D225F1EC02AD;
        Sun, 21 Aug 2022 14:26:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1661084767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=g1rcKArseoTcwKRluy/+n/zWWnLG0mmO4BjXiUTjTQo=;
        b=Iybi51cDAMmwdoswfJCzVyrOZu2xIpJoc4ZLh3BwbIZvIxwN/Il3v3+/iw4QD6FBdGIV5p
        4jYB7MwWbMe0uBbMOvcK74WMuQGkuULIapHbVjBsvf4CphE5n/UXtrjvPyO/BAD+581FMF
        EHTbIc1eeAxKJ7PF6dHQI6hheajBQXI=
Date:   Sun, 21 Aug 2022 14:25:59 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/10] x86/mtrr: fix MTRR fixup on APs
Message-ID: <YwIkV7mYAC4Ebbwb@zn.tnic>
References: <20220820092533.29420-1-jgross@suse.com>
 <20220820092533.29420-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220820092533.29420-2-jgross@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 11:25:24AM +0200, Juergen Gross wrote:
> When booting or resuming the system MTRR state is saved on the boot
> processor and then this state is loaded into MTRRs of all other cpus.

s/cpu/CPU/g

Pls check all commit messages.

> During update of the MTRRs the MTRR mechanism needs to be disabled by
> writing the related MSR. The old contents of this MSR are saved in a
> set of static variables and later those static variables are used to
> restore the MSR.
> 
> In case the MSR contents need to be modified on a cpu due to the MSR
> not having been initialized properly by the BIOS, the related update
> function is modifying the static variables accordingly.
> 
> Unfortunately the MTRR state update is usually running on all cpus
> at the same time, so using just one set of static variables for all
> cpus is racy in case the MSR contents differ across cpus.
> 
> Fix that by using percpu variables for saving the MSR contents.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> I thought adding a "Fixes:" tag for the kernel's initial git commit
> would maybe be entertaining, but without being really helpful.
> The percpu variables were preferred over on-stack ones in order to
> avoid more code churn in followup patches decoupling PAT from MTRR
> support.

So if that thing has been broken for so long and no one noticed, we
could just as well not backport to stable at all...

> V2:
> - new patch
> ---
>  arch/x86/kernel/cpu/mtrr/generic.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
> index 558108296f3c..3d185fcf08ca 100644
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -679,7 +679,8 @@ static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
>  	return changed;
>  }
>  
> -static u32 deftype_lo, deftype_hi;
> +static DEFINE_PER_CPU(u32, deftype_lo);
> +static DEFINE_PER_CPU(u32, deftype_hi);

My APM says that the high 32 bits of the MTRRdefType MSR are reserved
and MBZ. So you can drop the _hi thing and use 0 everywhere. Or rather a
dummy = 0 var because of that damn rdmsr() macro.

Or simply use a

u64 deftype;

use the rdmsrl/wrmsrl() variants and split it when passing to
umtrr_wrmsr() because that thing wants 2 32s.

>  /**
>   * set_mtrr_state - Set the MTRR state for this CPU.
> @@ -691,6 +692,7 @@ static unsigned long set_mtrr_state(void)
>  {
>  	unsigned long change_mask = 0;
>  	unsigned int i;
> +	u32 *lo = this_cpu_ptr(&deftype_lo);

The tip-tree preferred ordering of variable declarations at the
beginning of a function is reverse fir tree order::

	struct long_struct_name *descriptive_name;
	unsigned long foo, bar;
	unsigned int tmp;
	int ret;

The above is faster to parse than the reverse ordering::

	int ret;
	unsigned int tmp;
	unsigned long foo, bar;
	struct long_struct_name *descriptive_name;

And even more so than random ordering::

	unsigned long foo, bar;
	int ret;
	struct long_struct_name *descriptive_name;
	unsigned int tmp;

Please check all your patches.

>  	for (i = 0; i < num_var_ranges; i++) {
>  		if (set_mtrr_var_ranges(i, &mtrr_state.var_ranges[i]))
> @@ -704,10 +706,10 @@ static unsigned long set_mtrr_state(void)
>  	 * Set_mtrr_restore restores the old value of MTRRdefType,
>  	 * so to set it we fiddle with the saved value:
>  	 */
> -	if ((deftype_lo & 0xff) != mtrr_state.def_type
> -	    || ((deftype_lo & 0xc00) >> 10) != mtrr_state.enabled) {
> +	if ((*lo & 0xff) != mtrr_state.def_type
> +	    || ((*lo & 0xc00) >> 10) != mtrr_state.enabled) {
>  
> -		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type |
> +		*lo = (*lo & ~0xcff) | mtrr_state.def_type |
>  			     (mtrr_state.enabled << 10);
>  		change_mask |= MTRR_CHANGE_MASK_DEFTYPE;
>  	}
> @@ -729,6 +731,8 @@ static DEFINE_RAW_SPINLOCK(set_atomicity_lock);
>  static void prepare_set(void) __acquires(set_atomicity_lock)
>  {
>  	unsigned long cr0;
> +	u32 *lo = this_cpu_ptr(&deftype_lo);
> +	u32 *hi = this_cpu_ptr(&deftype_hi);

You don't need the pointers here - this_cpu_read() should be enough.

>  	/*
>  	 * Note that this is not ideal
> @@ -763,10 +767,10 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
>  	flush_tlb_local();
>  
>  	/* Save MTRR state */
> -	rdmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
> +	rdmsr(MSR_MTRRdefType, *lo, *hi);
>  
>  	/* Disable MTRRs, and set the default type to uncached */
> -	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
> +	mtrr_wrmsr(MSR_MTRRdefType, *lo & ~0xcff, *hi);
>  
>  	/* Again, only flush caches if we have to. */
>  	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
> @@ -775,12 +779,15 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
>  
>  static void post_set(void) __releases(set_atomicity_lock)
>  {
> +	u32 *lo = this_cpu_ptr(&deftype_lo);
> +	u32 *hi = this_cpu_ptr(&deftype_hi);

Ditto.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
