Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2729585497
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 19:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiG2RgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 13:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiG2RgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 13:36:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D15558C5;
        Fri, 29 Jul 2022 10:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659116171; x=1690652171;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nFNqgikl3WWL9NcWcxWKbMwXIUo1OKIzdWPoKUTNJlI=;
  b=eTebB7C8MqDGTQ+W+sVfPLCH8GbbXPQFjlPTdg9pNWJkXsLHzwxHEtjf
   VRrZ+tKaweg1L1mQlgdS8C81zPuPy0rRF2dDXDFU189Jr9sz9UhVzcWux
   m5OSiCvcyCJ2EnfFkZlkiz0laCSIJp1X2doSSyBcyqRN73kdSXijDL9I5
   Wynbxl6xQJj8oerKy7TyqFheaQOj8xmszDR1kPhYIW+K3vdI/t57AEWFw
   shH54UI7qtzfSlaaHnBLBxgDNQ1WF6JZM1FPOXlyjadJZAkkNk3NKub7i
   LyGF/hyFEPfe2tYTT6suxdCaK+51r+LCvo1fP+uTuLVsMlLkw8dIgu9+s
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="268582020"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="268582020"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 10:36:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="577023530"
Received: from aahmedsi-mobl.amr.corp.intel.com (HELO desk) ([10.209.118.55])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 10:36:10 -0700
Date:   Fri, 29 Jul 2022 10:36:09 -0700
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
Message-ID: <20220729173609.45o7lllpvsgjttqt@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuPpKa6OsG9e9nTj@zn.tnic>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 04:05:29PM +0200, Borislav Petkov wrote:
> On Thu, Jul 28, 2022 at 07:28:51PM -0700, Pawan Gupta wrote:
> > To keep things simple, can this stay in cpu/common.c?
> 
> I know, right?
> 
> The gullible maintainer should simply take your half-baked patch so that
> you can check off that box and then he can clean it up later.

I am sorry if it felt like that, its really not my intention.

I did also say:

  "And if there is a compelling reason, I am willing to make the
  required changes."

I was genuinely curious about why not to use cpu/common.c for mmio.

cpu/common.c is heavily used for bugs infrastructure. It already has the
affected tables, bug enumerations and helper functions for previous
bugs. Maybe it needs a cleanup as a whole.

> See if this works:

Thanks for this.

> ---
> diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> index 9393c50b5afc..14cd3c6ddec6 100644
> --- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> +++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
> @@ -230,6 +230,21 @@ The possible values in this file are:
>       * - 'Mitigation: Clear CPU buffers'
>         - The processor is vulnerable and the CPU buffer clearing mitigation is
>           enabled.
> +     * - 'Unknown: CPU is beyond its servicing period'
> +       - The processor vulnerability status is unknown because it is
> +	 out of Servicing period. Mitigation is not attempted.
> +
> +
> +Definitions:
> +------------
> +
> +Servicing period: The process of providing functional and security
> +updates to Intel processors or platforms, utilizing the Intel Platform
> +Update (IPU) process or other similar mechanisms.
> +
> +End of Servicing Updates (ESU): ESU is the date at which Intel will no
> +longer provide Servicing, such as through IPU or other similar update
> +processes. ESU dates will typically be aligned to end of quarter.
>  
>  If the processor is vulnerable then the following information is appended to
>  the above information:
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index ea34cc31b047..fe66e94d7b86 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -154,6 +154,7 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
>  } while (0)
>  
>  #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
> +#define setup_clear_cpu_bug(bit) setup_clear_cpu_cap(bit)
>  
>  #if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
>  
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 5fe7f6c8a7a4..130cb46ecaf9 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -454,7 +454,8 @@
>  #define X86_BUG_TAA			X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
>  #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
>  #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
> -#define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
> -#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
> +#define X86_BUG_MMIO_UNKNOWN		X86_BUG(25) /* CPU is too old and its MMIO Stale Data status is unknown */
> +#define X86_BUG_MMIO_STALE_DATA		X86_BUG(26) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
> +#define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
>  
>  #endif /* _ASM_X86_CPUFEATURES_H */
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 6454bc767f0f..a83d1c4265ae 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -433,7 +433,8 @@ static void __init mmio_select_mitigation(void)
>  	u64 ia32_cap;
>  
>  	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
> -	    cpu_mitigations_off()) {
> +	     boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN) ||
> +	     cpu_mitigations_off()) {
>  		mmio_mitigation = MMIO_MITIGATION_OFF;
>  		return;
>  	}




> @@ -2247,6 +2248,9 @@ static ssize_t tsx_async_abort_show_state(char *buf)
>  
>  static ssize_t mmio_stale_data_show_state(char *buf)
>  {
> +	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
> +		return sysfs_emit(buf, "Unknown: CPU is beyond its servicing period\n");
> +
>  	if (mmio_mitigation == MMIO_MITIGATION_OFF)
>  		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
>  
> @@ -2378,6 +2382,7 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
>  		return srbds_show_state(buf);
>  
>  	case X86_BUG_MMIO_STALE_DATA:
> +	case X86_BUG_MMIO_UNKNOWN:
>  		return mmio_stale_data_show_state(buf);
>  
>  	case X86_BUG_RETBLEED:
> @@ -2437,7 +2442,10 @@ ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *
>  
>  ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> -	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
> +	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
> +		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_UNKNOWN);
> +	else
> +		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
>  }
>  
>  ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 736262a76a12..fb3e8576a3b4 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1356,9 +1356,13 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
>  	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
>  	 * not want the guest to enumerate the bug.
>  	 */
> -	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> -	    !arch_cap_mmio_immune(ia32_cap))
> -		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> +	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN)) {

This should be !boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN). Otherwise
X86_BUG_MMIO_STALE_DATA will not be set on affected systems.

> +		if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
> +		    !arch_cap_mmio_immune(ia32_cap)) {
> +			setup_clear_cpu_bug(X86_BUG_MMIO_UNKNOWN);

Clearing X86_BUG_MMIO_UNKNOWN wont be required then.

> +			setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
> +		}
> +	}

Does this look okay:

-       if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
-           !arch_cap_mmio_immune(ia32_cap))
-               setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+       if (!boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN)) {
+               if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
+                   !arch_cap_mmio_immune(ia32_cap)) {
+                       setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+               }
+       }

>  	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
>  		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 663f6e6dd288..5b2508adc38a 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -372,6 +372,10 @@ static void early_init_intel(struct cpuinfo_x86 *c)
>  static void bsp_init_intel(struct cpuinfo_x86 *c)
>  {
>  	resctrl_cpu_detect(c);
> +
> +	/* Set on older crap */
> +	if (c->x86_model < INTEL_FAM6_IVYBRIDGE)
> +		setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);

Thanks for suggesting this approach.
