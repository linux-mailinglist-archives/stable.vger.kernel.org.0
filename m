Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0761D5856A3
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 23:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiG2Vqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 17:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiG2Vqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 17:46:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67E28B4BB;
        Fri, 29 Jul 2022 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659131189; x=1690667189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yuBKFOjdVhm5xzW7H39ySAdNm5fv6KOJ8EcoqSoFYzU=;
  b=THCA0SQ1LA5dwrX08XtGDLW9+oZrOJHcfy43kbwYuIIa+G//7fin0buK
   qZS7BA4Bqoo95V9h6hlRyumzKN42BhvdXMA4GCJaMYgoSnhFqxWatWB5l
   Q9yThBJJaodwTL9iFxkOUiNMO3+Ir88d4wWIKMDRAeCnIpp/tRfZ7SL2X
   FRYNq+1fkx3tr2rP3PLvGbPjdrwLWU+60/yETplXEJ95ajb1B7/wh3Ljt
   I2af0PcUwTr2FAYua2cqBKhKVDehQ95va/8Ql+UbpLNOXnamIIROjm1f2
   ElHZs8uJhi7YB9vblDicA/ofnJ7+y4gHtvccTyUsEel7uWAqby6rGa3Kr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="375157939"
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="375157939"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 14:46:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="598375994"
Received: from unknown (HELO desk) ([10.252.135.102])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 14:46:28 -0700
Date:   Fri, 29 Jul 2022 14:46:27 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
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
Message-ID: <20220729214627.wowu5sny226c5pe4@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic>
 <20220729173609.45o7lllpvsgjttqt@desk>
 <YuRDbuQPYiYBZghm@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuRDbuQPYiYBZghm@zn.tnic>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 10:30:38PM +0200, Borislav Petkov wrote:
> On Fri, Jul 29, 2022 at 10:36:09AM -0700, Pawan Gupta wrote:
> > Does this look okay:
> > 
> > -       if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> > -           !arch_cap_mmio_immune(ia32_cap))
> > -               setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> > +       if (!boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN)) {
> > +               if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> > +                   !arch_cap_mmio_immune(ia32_cap)) {
> > +                       setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> > +               }
> > +       }
> 
> Yeah, I had initially X86_BUG_MMIO_UNKNOWN set unconditionally on all.
> 
> Then I thought I should set it only on older but as dhansen said, Intel
> is going in and out of servicing period so we better set it on all
> initially and then clear it when the CPU is not in the vuln blacklist.

Setting all to "unknown" initially can lead to some CPUs incorrectly
reporting "Unknown".

Let me see if there is a way to distinguish between 4. and 5. below:

   CPU category				  X86_BUG_MMIO_STALE_DATA	X86_BUG_MMIO_UNKNOWN
-----------------------------------------------------------------------------------------------
1. Known affected (in cpu list)			1				0
2. CPUs with HW immunity (MMIO_NO=1)		0				0
3. Other vendors				0				0
4. Older Intel CPUs				0				1
5. Not affected current CPUs (but MMIO_NO=0)	0				?

> > >  	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
> > >  		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
> > > diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> > > index 663f6e6dd288..5b2508adc38a 100644
> > > --- a/arch/x86/kernel/cpu/intel.c
> > > +++ b/arch/x86/kernel/cpu/intel.c
> > > @@ -372,6 +372,10 @@ static void early_init_intel(struct cpuinfo_x86 *c)
> > >  static void bsp_init_intel(struct cpuinfo_x86 *c)
> > >  {
> > >  	resctrl_cpu_detect(c);
> > > +
> > > +	/* Set on older crap */
> > > +	if (c->x86_model < INTEL_FAM6_IVYBRIDGE)
> 
> i.e., remove this check.

This check actually solves the above problem, but consider it gone.

> > > +		setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
> > 
> > Thanks for suggesting this approach.
> 
> You're welcome. I'm assuming you're gonna finish it or should I?

I will finish it, working on it.
