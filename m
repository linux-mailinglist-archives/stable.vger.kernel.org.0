Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03865A941E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiIAKR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiIAKR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:17:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED94134185;
        Thu,  1 Sep 2022 03:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ADCB61C16;
        Thu,  1 Sep 2022 10:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813C2C433C1;
        Thu,  1 Sep 2022 10:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662027445;
        bh=JW9M1JXTYO1UMC8gDNPIcYY4mz5Vy50Al0FW/T7delg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCmYjCJObVxVs9f4wq6UHto7SxpHqqE1kfsyK0y8banc/U7dS7eHHihGimliFlv18
         O6KNHTB0xxWgWfavo/91jAmOO7XNXTQZlGfnI0pH2OKaH9XK/s6qxEODXcBVEsz6q9
         7y9sYvmpPaQxEgyWDUvrOyH8taerAy2OpUQWK8ck=
Date:   Thu, 1 Sep 2022 12:17:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     stable@vger.kernel.org, andrew.cooper3@citrix.com, bp@suse.de,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.9 2/2] x86/bugs: Add "unknown" reporting for MMIO Stale
 Data
Message-ID: <YxCGstvTOwwLF8q/@kroah.com>
References: <81f08c055ed116d80a1b139b41f1b663867368b5.1661899974.git.pawan.kumar.gupta@linux.intel.com>
 <5fd43d61e1c26271200f0a259c3bb6bca7d49a4d.1661899974.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fd43d61e1c26271200f0a259c3bb6bca7d49a4d.1661899974.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 04:03:24PM -0700, Pawan Gupta wrote:
> [ Upstream commit 7df548840c496b0141fb2404b889c346380c2b22 ]
> 
> Older Intel CPUs that are not in the affected processor list for MMIO
> Stale Data vulnerabilities currently report "Not affected" in sysfs,
> which may not be correct. Vulnerability status for these older CPUs is
> unknown.
> 
> Add known-not-affected CPUs to the whitelist. Report "unknown"
> mitigation status for CPUs that are not in blacklist, whitelist and also
> don't enumerate MSR ARCH_CAPABILITIES bits that reflect hardware
> immunity to MMIO Stale Data vulnerabilities.
> 
> Mitigation is not deployed when the status is unknown.
> 
>   [ bp: Massage, fixup. ]
> 
> Fixes: 8d50cdf8b834 ("x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data")
> Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com
> ---
>  .../hw-vuln/processor_mmio_stale_data.rst     | 14 ++++++++
>  arch/x86/include/asm/cpufeatures.h            |  1 +
>  arch/x86/kernel/cpu/bugs.c                    | 14 ++++++--
>  arch/x86/kernel/cpu/common.c                  | 34 +++++++++++++------
>  4 files changed, 50 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/hw-vuln/processor_mmio_stale_data.rst b/Documentation/hw-vuln/processor_mmio_stale_data.rst
> index 9393c50b5afc..c98fd11907cc 100644
> --- a/Documentation/hw-vuln/processor_mmio_stale_data.rst
> +++ b/Documentation/hw-vuln/processor_mmio_stale_data.rst
> @@ -230,6 +230,20 @@ The possible values in this file are:
>       * - 'Mitigation: Clear CPU buffers'
>         - The processor is vulnerable and the CPU buffer clearing mitigation is
>           enabled.
> +     * - 'Unknown: No mitigations'
> +       - The processor vulnerability status is unknown because it is
> +	 out of Servicing period. Mitigation is not attempted.
> +
> +Definitions:
> +------------
> +
> +Servicing period: The process of providing functional and security updates to
> +Intel processors or platforms, utilizing the Intel Platform Update (IPU)
> +process or other similar mechanisms.
> +
> +End of Servicing Updates (ESU): ESU is the date at which Intel will no
> +longer provide Servicing, such as through IPU or other similar update
> +processes. ESU dates will typically be aligned to end of quarter.
>  
>  If the processor is vulnerable then the following information is appended to
>  the above information:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 910304aec2e6..a033fa5c596d 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -363,5 +363,6 @@
>  #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
>  #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
>  #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
> +#define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
>  
>  #endif /* _ASM_X86_CPUFEATURES_H */
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index b4416df41d63..d8ba0b60e088 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -395,7 +395,8 @@ static void __init mmio_select_mitigation(void)
>  	u64 ia32_cap;
>  
>  	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
> -	    cpu_mitigations_off()) {
> +	     boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN) ||
> +	     cpu_mitigations_off()) {
>  		mmio_mitigation = MMIO_MITIGATION_OFF;
>  		return;
>  	}
> @@ -500,6 +501,8 @@ static void __init md_clear_update_mitigation(void)
>  		pr_info("TAA: %s\n", taa_strings[taa_mitigation]);
>  	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
>  		pr_info("MMIO Stale Data: %s\n", mmio_strings[mmio_mitigation]);
> +	else if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
> +		pr_info("MMIO Stale Data: Unknown: No mitigations\n");
>  }
>  
>  static void __init md_clear_select_mitigation(void)
> @@ -1824,6 +1827,9 @@ static ssize_t tsx_async_abort_show_state(char *buf)
>  
>  static ssize_t mmio_stale_data_show_state(char *buf)
>  {
> +	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
> +		return sysfs_emit(buf, "Unknown: No mitigations\n");
> +
>  	if (mmio_mitigation == MMIO_MITIGATION_OFF)
>  		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
>  
> @@ -1934,6 +1940,7 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
>  		return srbds_show_state(buf);
>  
>  	case X86_BUG_MMIO_STALE_DATA:
> +	case X86_BUG_MMIO_UNKNOWN:
>  		return mmio_stale_data_show_state(buf);
>  
>  	default:
> @@ -1990,6 +1997,9 @@ ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *
>  
>  ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> -	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
> +	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
> +		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_UNKNOWN);
> +	else
> +		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
>  }
>  #endif
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 48843fc76695..656f336074a3 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -899,6 +899,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
>  #define MSBDS_ONLY		BIT(5)
>  #define NO_SWAPGS		BIT(6)
>  #define NO_ITLB_MULTIHIT	BIT(7)
> +#define NO_MMIO			BIT(8)
>  
>  #define VULNWL(_vendor, _family, _model, _whitelist)	\
>  	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
> @@ -916,6 +917,11 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
>  	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
>  
>  	/* Intel Family 6 */
> +	VULNWL_INTEL(TIGERLAKE,			NO_MMIO),
> +	VULNWL_INTEL(TIGERLAKE_L,		NO_MMIO),
> +	VULNWL_INTEL(ALDERLAKE,			NO_MMIO),
> +	VULNWL_INTEL(ALDERLAKE_L,		NO_MMIO),
> +
>  	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
>  	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
>  	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
> @@ -933,9 +939,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
>  
>  	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
>  
> -	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
> -	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
> -	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
> +	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
> +	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
> +	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
>  
>  	/*
>  	 * Technically, swapgs isn't serializing on AMD (despite it previously
> @@ -946,13 +952,13 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
>  	 */
>  
>  	/* AMD Family 0xf - 0x12 */
> -	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
> -	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
> -	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
> -	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
> +	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
> +	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
> +	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
> +	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
>  
>  	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
> -	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
> +	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
>  	{}
>  };
>  
> @@ -1092,10 +1098,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
>  	 * Affected CPU list is generally enough to enumerate the vulnerability,
>  	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
>  	 * not want the guest to enumerate the bug.
> +	 *
> +	 * Set X86_BUG_MMIO_UNKNOWN for CPUs that are neither in the blacklist,
> +	 * nor in the whitelist and also don't enumerate MSR ARCH_CAP MMIO bits.
>  	 */
> -	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> -	    !arch_cap_mmio_immune(ia32_cap))
> -		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> +	if (!arch_cap_mmio_immune(ia32_cap)) {
> +		if (cpu_matches(cpu_vuln_blacklist, MMIO))
> +			setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> +		else if (!cpu_matches(cpu_vuln_whitelist, NO_MMIO))
> +			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
> +	}
>  
>  	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
>  		return;
> -- 
> 2.37.2
> 
> 

All now queued up, thanks.

greg k-h
