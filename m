Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24378583E2D
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 14:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiG1MA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 08:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiG1MA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 08:00:26 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9501F635;
        Thu, 28 Jul 2022 05:00:24 -0700 (PDT)
Received: from zn.tnic (p57969665.dip0.t-ipconnect.de [87.150.150.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 674091EC0426;
        Thu, 28 Jul 2022 14:00:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1659009618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=orCVEBjejuPAUZdJ3jjyVvWH7nb/Ock0m/K1KUoWRXg=;
        b=Yk3f2nx8ekD4ct7ivaqA63Xb/ce5hb4V8WeVbgGZEACcCVkigsQ70DNqbJLIxozxpXf8XT
        XoqxzNr4f66Z6QDgtSV0+Hv/8g+fMLKZx7Dp2YrvuoKDt74T1HSnPkfCTjLxIWktyQvt65
        TZGWmgX5bI/Q2lkojkUg51ttTelQRjU=
Date:   Thu, 28 Jul 2022 14:00:13 +0200
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
Message-ID: <YuJ6TQpSTIeXLNfB@zn.tnic>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 06:30:18PM -0700, Pawan Gupta wrote:
> Older CPUs beyond its Servicing period are not listed in the affected
> processor list for MMIO Stale Data vulnerabilities. These CPUs currently
> report "Not affected" in sysfs, which may not be correct.
> 
> Add support for "Unknown" reporting for such CPUs. Mitigation is not
> deployed when the status is "Unknown".
> 
> "CPU is beyond its Servicing period" means these CPUs are beyond their
> Servicing [1] period and have reached End of Servicing Updates (ESU) [2].
> 
>   [1] Servicing: The process of providing functional and security
>   updates to Intel processors or platforms, utilizing the Intel Platform
>   Update (IPU) process or other similar mechanisms.
> 
>   [2] End of Servicing Updates (ESU): ESU is the date at which Intel
>   will no longer provide Servicing, such as through IPU or other similar
>   update processes. ESU dates will typically be aligned to end of
>   quarter.

The explanations of those things need to be...

> Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Suggested-by: Tony Luck <tony.luck@intel.com>
> Fixes: 8d50cdf8b834 ("x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
> CPU vulnerability is unknown if, hardware doesn't set the immunity bits
> and CPU is not in the known-affected-list.
> 
> In order to report the unknown status, this patch sets the MMIO bug
> for all Intel CPUs that don't have the hardware immunity bits set.
> Based on the known-affected-list of CPUs, mitigation selection then
> deploys the mitigation or sets the "Unknown" status; which is ugly.
> 
> I will appreciate suggestions to improve this.
> 
> Thanks,
> Pawan
> 
>  .../hw-vuln/processor_mmio_stale_data.rst     |  3 +++
>  arch/x86/kernel/cpu/bugs.c                    | 11 +++++++-
>  arch/x86/kernel/cpu/common.c                  | 26 +++++++++++++------
>  arch/x86/kernel/cpu/cpu.h                     |  1 +
>  4 files changed, 32 insertions(+), 9 deletions(-)
> 
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

... here.

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 736262a76a12..82088410870e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1286,6 +1286,22 @@ static bool arch_cap_mmio_immune(u64 ia32_cap)
>  		ia32_cap & ARCH_CAP_SBDR_SSDP_NO);
>  }
>  
> +bool __init mmio_stale_data_unknown(void)

This function need to go to ...cpu/intel.c

> +{
> +	u64 ia32_cap = x86_read_arch_cap_msr();
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +		return false;

<---- newline here.

> +	/*
> +	 * CPU vulnerability is unknown when, hardware doesn't set the

no comma after the "when"

> +	 * immunity bits and CPU is not in the known affected list.
> +	 */
> +	if (!cpu_matches(cpu_vuln_blacklist, MMIO) &&
> +	    !arch_cap_mmio_immune(ia32_cap))
> +		return true;

<---- newline here.

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

Why is that vendor check here? We have the cpu_vuln_blacklist for a
reason.

>  	    !arch_cap_mmio_immune(ia32_cap))
>  		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
