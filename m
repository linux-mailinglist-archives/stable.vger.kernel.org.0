Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29737584667
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 21:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiG1TIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 15:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiG1TIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 15:08:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D0676960;
        Thu, 28 Jul 2022 12:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659035320; x=1690571320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mwYRhPt/qNkJg8iTUFWz1cbb29drUFK9eTaW+3vHFUE=;
  b=YVkoVxC+xm3MfepcJuS9NbyQFOIt+M3dNvPmt5CLNPTx4GlWM5PdK6l/
   u5hX5GqTqLfZkftR7HsqJyvx6RPuov48hH2OJvcuRitk7pK7xiPlGJB4J
   SMNFB4hh2+EY0zxzxEaTaYtlhHHYL0YN27XdgONFDA72J2TtDTx4Iyipt
   /Py6eXKf44YOWrw3PDGP8V6BIu+1BN+R8JkFLA2RtMj1aB6MK9AVr69WQ
   EQhPjAu9fxcn0fpEBO7M/M32PS8CsF2dFK/9HVVHwdUbh24ovw3Zts9Ba
   6AmQbiTx36LYBKr6AiZQ7XoCGpikrNxCY6Rxo5s43Gb3+K5qKtg9rhpH7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="271636652"
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="271636652"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:08:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="551440101"
Received: from bbandar7-mobl1.amr.corp.intel.com (HELO [10.209.124.46]) ([10.209.124.46])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:08:39 -0700
Message-ID: <f173a7c0-b4f8-17f3-a65d-e581fed32368@intel.com>
Date:   Thu, 28 Jul 2022 12:08:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Content-Language: en-US
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tony.luck@intel.com,
        antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/22 18:30, Pawan Gupta wrote:
> Older CPUs beyond its Servicing period are not listed in the affected
> processor list for MMIO Stale Data vulnerabilities. These CPUs currently
> report "Not affected" in sysfs, which may not be correct.

I'd kinda like to remove the talk about the "servicing period" in this
patch.  First, it's a moving target.  CPUs can move in and out of their
servicing period as Intel changes its mind, or simply as time passes.

Intel could also totally choose to report a CPU as vulnerable *AND* have
it be outside its service period.  Or, some good Samaritan community
member might be able to test a crusty old CPU and determine if it's
vulnerable.

> diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> index 9393c50b5afc..55524e0798da 100644
> --- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> +++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> @@ -230,6 +230,9 @@ The possible values in this file are:
>       * - 'Mitigation: Clear CPU buffers'
>         - The processor is vulnerable and the CPU buffer clearing mitigation is
>           enabled.
> +     * - 'Unknown: CPU is beyond its Servicing period'
> +       - The processor vulnerability status is unknown because it is
> +	 out of Servicing period. Mitigation is not attempted.

Unknown: Processor vendor did not provide vulnerability status.

>  If the processor is vulnerable then the following information is appended to
>  the above information:
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 0dd04713434b..dd6e78d370bc 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -416,6 +416,7 @@ enum mmio_mitigations {
>  	MMIO_MITIGATION_OFF,
>  	MMIO_MITIGATION_UCODE_NEEDED,
>  	MMIO_MITIGATION_VERW,
> +	MMIO_MITIGATION_UNKNOWN,
>  };
>  
>  /* Default mitigation for Processor MMIO Stale Data vulnerabilities */
> @@ -426,12 +427,18 @@ static const char * const mmio_strings[] = {
>  	[MMIO_MITIGATION_OFF]		= "Vulnerable",
>  	[MMIO_MITIGATION_UCODE_NEEDED]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
>  	[MMIO_MITIGATION_VERW]		= "Mitigation: Clear CPU buffers",
> +	[MMIO_MITIGATION_UNKNOWN]	= "Unknown: CPU is beyond its servicing period",
>  };

Let's just say:

	Unknown: no mitigations

or even just: "Unknown"

>  static void __init mmio_select_mitigation(void)
>  {
>  	u64 ia32_cap;
>  
> +	if (mmio_stale_data_unknown()) {
> +		mmio_mitigation = MMIO_MITIGATION_UNKNOWN;
> +		return;
> +	}
> +
>  	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
>  	    cpu_mitigations_off()) {
>  		mmio_mitigation = MMIO_MITIGATION_OFF;
> @@ -1638,6 +1645,7 @@ void cpu_bugs_smt_update(void)
>  			pr_warn_once(MMIO_MSG_SMT);
>  		break;
>  	case MMIO_MITIGATION_OFF:
> +	case MMIO_MITIGATION_UNKNOWN:
>  		break;
>  	}
>  
> @@ -2235,7 +2243,8 @@ static ssize_t tsx_async_abort_show_state(char *buf)
>  
>  static ssize_t mmio_stale_data_show_state(char *buf)
>  {
> -	if (mmio_mitigation == MMIO_MITIGATION_OFF)
> +	if (mmio_mitigation == MMIO_MITIGATION_OFF ||
> +	    mmio_mitigation == MMIO_MITIGATION_UNKNOWN)
>  		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
>  
>  	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 736262a76a12..82088410870e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1286,6 +1286,22 @@ static bool arch_cap_mmio_immune(u64 ia32_cap)
>  		ia32_cap & ARCH_CAP_SBDR_SSDP_NO);
>  }
>  
> +bool __init mmio_stale_data_unknown(void)
> +{
> +	u64 ia32_cap = x86_read_arch_cap_msr();
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +		return false;

Let's say why Intel is the special snowflake.  Maybe:

	/*
	 * Intel does not document vulnerability information for old
	 * CPUs.  This means that only Intel CPUs can have unknown
	 * vulnerability state.
	 */

> +	/*
> +	 * CPU vulnerability is unknown when, hardware doesn't set the
> +	 * immunity bits and CPU is not in the known affected list.
> +	 */
> +	if (!cpu_matches(cpu_vuln_blacklist, MMIO) &&
> +	    !arch_cap_mmio_immune(ia32_cap))
> +		return true;
> +	return false;
> +}
> +
>  static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
>  {
>  	u64 ia32_cap = x86_read_arch_cap_msr();
> @@ -1349,14 +1365,8 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
>  	    cpu_matches(cpu_vuln_blacklist, SRBDS | MMIO_SBDS))
>  		    setup_force_cpu_bug(X86_BUG_SRBDS);
>  
> -	/*
> -	 * Processor MMIO Stale Data bug enumeration
> -	 *
> -	 * Affected CPU list is generally enough to enumerate the vulnerability,
> -	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
> -	 * not want the guest to enumerate the bug.
> -	 */
> -	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> +	 /* Processor MMIO Stale Data bug enumeration */
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
>  	    !arch_cap_mmio_immune(ia32_cap))
>  		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);

Yeah, this is all looking a little clunky.

Maybe we just need a third state of cpu_has_bug() for all this and we
shouldn't try cramming it in the MMIO-specific code and diluting the
specificity of boot_cpu_has_bug().

Then the selection logic becomes simple:

	if (!arch_cap_mmio_immune(ia32_cap))) {
		if (cpu_matches(cpu_vuln_blacklist, MMIO))
			setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
		else if (x86_vendor == X86_VENDOR_INTEL)
			setup_force_unknown_bug(X86_BUG_MMIO...);
	}

... and then spit out the "Unknown" in the common code, just like the
treatment "Not affected" gets.

static ssize_t cpu_show_common(...)
{
        if (!boot_cpu_has_bug(bug))
                return sprintf(buf, "Not affected\n");
+
+       if (!boot_cpu_unknown_bug(bug))
+               return sprintf(buf, "Unknown\n");

Thoughts?
