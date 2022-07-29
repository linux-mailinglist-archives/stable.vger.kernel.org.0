Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B83F585628
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 22:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiG2Ua5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 16:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239250AbiG2Uaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 16:30:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CE81BEA0;
        Fri, 29 Jul 2022 13:30:48 -0700 (PDT)
Received: from zn.tnic (p57969665.dip0.t-ipconnect.de [87.150.150.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 260A81EC06C1;
        Fri, 29 Jul 2022 22:30:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1659126643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Reva7c533rvViROlencOmIQvzuYlzhCaWdAsP+xz+QM=;
        b=DgUX22PSlqWuOAtG4DrDV1QmWPRHYB4omO7lDFv3A7P+FPsbl4tg9KNrU+dwi9B3eUyLSD
        55gFZu+S7B+Sxu1a8NAhxime5YCGlcdlvYNA6bhdwFwSpZdR56cXbZGPbzYErWUSzRu7+q
        tTcN1t6mL1Mya1vmA9pnQ4i5P1djT70=
Date:   Fri, 29 Jul 2022 22:30:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Message-ID: <YuRDbuQPYiYBZghm@zn.tnic>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic>
 <20220729173609.45o7lllpvsgjttqt@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220729173609.45o7lllpvsgjttqt@desk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 10:36:09AM -0700, Pawan Gupta wrote:
> Does this look okay:
> 
> -       if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> -           !arch_cap_mmio_immune(ia32_cap))
> -               setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> +       if (!boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN)) {
> +               if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> +                   !arch_cap_mmio_immune(ia32_cap)) {
> +                       setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> +               }
> +       }

Yeah, I had initially X86_BUG_MMIO_UNKNOWN set unconditionally on all.

Then I thought I should set it only on older but as dhansen said, Intel
is going in and out of servicing period so we better set it on all
initially and then clear it when the CPU is not in the vuln blacklist.

> 
> >  	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
> >  		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
> > diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> > index 663f6e6dd288..5b2508adc38a 100644
> > --- a/arch/x86/kernel/cpu/intel.c
> > +++ b/arch/x86/kernel/cpu/intel.c
> > @@ -372,6 +372,10 @@ static void early_init_intel(struct cpuinfo_x86 *c)
> >  static void bsp_init_intel(struct cpuinfo_x86 *c)
> >  {
> >  	resctrl_cpu_detect(c);
> > +
> > +	/* Set on older crap */
> > +	if (c->x86_model < INTEL_FAM6_IVYBRIDGE)

i.e., remove this check.

> > +		setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
> 
> Thanks for suggesting this approach.

You're welcome. I'm assuming you're gonna finish it or should I?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
