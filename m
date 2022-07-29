Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF75854D8
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 20:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbiG2SAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 14:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbiG2SAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 14:00:02 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE4689AA0;
        Fri, 29 Jul 2022 11:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659117601; x=1690653601;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mXZW/CQJ/ErcFEYDlw85Mljff6yNsGMgn0EWXI0B0DM=;
  b=DDKbsZJ2+x1h7vrw2QhLdHgQ1iisyJIzRuUw0gP2xWn2rWyLfGRweH6l
   uDs8/6tGK9g0Jy96Vt7UUyfus8CyXTfIL7/tIpt49pVEAUuhRMMHLsIHb
   UlKMpjDWiNQ0OLaUVJY2WdUuSvAw3FbtF42z5ITdCR0MleNHzcU7dit9J
   WZ023jrjgx18fWCs+4ezzyQ30Pj0r2Rltr19+8dDXrLqm2fX1OZ4K09aK
   rYKKeDhVBXg2Ff9tVHq/YAriqYd9OtfqToeyYo4jVqiXyrttGHRPuBDCK
   JU5K6mGPEwyHQAKrX+Euv7jy7E/UjZI//foaPMdjOHQKjAovgQwyMxo/K
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="288831034"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="288831034"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 11:00:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="928821579"
Received: from aahmedsi-mobl.amr.corp.intel.com (HELO desk) ([10.209.118.55])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 11:00:00 -0700
Date:   Fri, 29 Jul 2022 10:59:59 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Message-ID: <20220729175959.w7gd5z7dsbxrnydn@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <f173a7c0-b4f8-17f3-a65d-e581fed32368@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f173a7c0-b4f8-17f3-a65d-e581fed32368@intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 12:08:39PM -0700, Dave Hansen wrote:
> On 7/14/22 18:30, Pawan Gupta wrote:
> > Older CPUs beyond its Servicing period are not listed in the affected
> > processor list for MMIO Stale Data vulnerabilities. These CPUs currently
> > report "Not affected" in sysfs, which may not be correct.
> 
> I'd kinda like to remove the talk about the "servicing period" in this
> patch.  First, it's a moving target.  CPUs can move in and out of their
> servicing period as Intel changes its mind, or simply as time passes.
> 
> Intel could also totally choose to report a CPU as vulnerable *AND* have
> it be outside its service period.  Or, some good Samaritan community
> member might be able to test a crusty old CPU and determine if it's
> vulnerable.
> 
> > diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> > index 9393c50b5afc..55524e0798da 100644
> > --- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> > +++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> > @@ -230,6 +230,9 @@ The possible values in this file are:
> >       * - 'Mitigation: Clear CPU buffers'
> >         - The processor is vulnerable and the CPU buffer clearing mitigation is
> >           enabled.
> > +     * - 'Unknown: CPU is beyond its Servicing period'
> > +       - The processor vulnerability status is unknown because it is
> > +	 out of Servicing period. Mitigation is not attempted.
> 
> Unknown: Processor vendor did not provide vulnerability status.
> 
> >  If the processor is vulnerable then the following information is appended to
> >  the above information:
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 0dd04713434b..dd6e78d370bc 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -416,6 +416,7 @@ enum mmio_mitigations {
> >  	MMIO_MITIGATION_OFF,
> >  	MMIO_MITIGATION_UCODE_NEEDED,
> >  	MMIO_MITIGATION_VERW,
> > +	MMIO_MITIGATION_UNKNOWN,
> >  };
> >  
> >  /* Default mitigation for Processor MMIO Stale Data vulnerabilities */
> > @@ -426,12 +427,18 @@ static const char * const mmio_strings[] = {
> >  	[MMIO_MITIGATION_OFF]		= "Vulnerable",
> >  	[MMIO_MITIGATION_UCODE_NEEDED]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
> >  	[MMIO_MITIGATION_VERW]		= "Mitigation: Clear CPU buffers",
> > +	[MMIO_MITIGATION_UNKNOWN]	= "Unknown: CPU is beyond its servicing period",
> >  };
> 
> Let's just say:
> 
> 	Unknown: no mitigations
> 
> or even just: "Unknown"
> 
> >  static void __init mmio_select_mitigation(void)
> >  {
> >  	u64 ia32_cap;
> >  
> > +	if (mmio_stale_data_unknown()) {
> > +		mmio_mitigation = MMIO_MITIGATION_UNKNOWN;
> > +		return;
> > +	}
> > +
> >  	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
> >  	    cpu_mitigations_off()) {
> >  		mmio_mitigation = MMIO_MITIGATION_OFF;
> > @@ -1638,6 +1645,7 @@ void cpu_bugs_smt_update(void)
> >  			pr_warn_once(MMIO_MSG_SMT);
> >  		break;
> >  	case MMIO_MITIGATION_OFF:
> > +	case MMIO_MITIGATION_UNKNOWN:
> >  		break;
> >  	}
> >  
> > @@ -2235,7 +2243,8 @@ static ssize_t tsx_async_abort_show_state(char *buf)
> >  
> >  static ssize_t mmio_stale_data_show_state(char *buf)
> >  {
> > -	if (mmio_mitigation == MMIO_MITIGATION_OFF)
> > +	if (mmio_mitigation == MMIO_MITIGATION_OFF ||
> > +	    mmio_mitigation == MMIO_MITIGATION_UNKNOWN)
> >  		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
> >  
> >  	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index 736262a76a12..82088410870e 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1286,6 +1286,22 @@ static bool arch_cap_mmio_immune(u64 ia32_cap)
> >  		ia32_cap & ARCH_CAP_SBDR_SSDP_NO);
> >  }
> >  
> > +bool __init mmio_stale_data_unknown(void)
> > +{
> > +	u64 ia32_cap = x86_read_arch_cap_msr();
> > +
> > +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> > +		return false;
> 
> Let's say why Intel is the special snowflake.  Maybe:
> 
> 	/*
> 	 * Intel does not document vulnerability information for old
> 	 * CPUs.  This means that only Intel CPUs can have unknown
> 	 * vulnerability state.
> 	 */
> 
> > +	/*
> > +	 * CPU vulnerability is unknown when, hardware doesn't set the
> > +	 * immunity bits and CPU is not in the known affected list.
> > +	 */
> > +	if (!cpu_matches(cpu_vuln_blacklist, MMIO) &&
> > +	    !arch_cap_mmio_immune(ia32_cap))
> > +		return true;
> > +	return false;
> > +}
> > +
> >  static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
> >  {
> >  	u64 ia32_cap = x86_read_arch_cap_msr();
> > @@ -1349,14 +1365,8 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
> >  	    cpu_matches(cpu_vuln_blacklist, SRBDS | MMIO_SBDS))
> >  		    setup_force_cpu_bug(X86_BUG_SRBDS);
> >  
> > -	/*
> > -	 * Processor MMIO Stale Data bug enumeration
> > -	 *
> > -	 * Affected CPU list is generally enough to enumerate the vulnerability,
> > -	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
> > -	 * not want the guest to enumerate the bug.
> > -	 */
> > -	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> > +	 /* Processor MMIO Stale Data bug enumeration */
> > +	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
> >  	    !arch_cap_mmio_immune(ia32_cap))
> >  		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> 
> Yeah, this is all looking a little clunky.
> 
> Maybe we just need a third state of cpu_has_bug() for all this and we
> shouldn't try cramming it in the MMIO-specific code and diluting the
> specificity of boot_cpu_has_bug().
> 
> Then the selection logic becomes simple:
> 
> 	if (!arch_cap_mmio_immune(ia32_cap))) {
> 		if (cpu_matches(cpu_vuln_blacklist, MMIO))
> 			setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> 		else if (x86_vendor == X86_VENDOR_INTEL)
> 			setup_force_unknown_bug(X86_BUG_MMIO...);
> 	}
> 
> ... and then spit out the "Unknown" in the common code, just like the
> treatment "Not affected" gets.
> 
> static ssize_t cpu_show_common(...)
> {
>         if (!boot_cpu_has_bug(bug))
>                 return sprintf(buf, "Not affected\n");
> +
> +       if (!boot_cpu_unknown_bug(bug))
> +               return sprintf(buf, "Unknown\n");
> 
> Thoughts?

Sounds good. Similar to this Borislav suggested to add
X86_BUG_MMIO_UNKNOWN. I will see if I can combine both approaches.
