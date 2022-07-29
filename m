Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479DD5849BD
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 04:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiG2C2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 22:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG2C2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 22:28:55 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E7D7B1F4;
        Thu, 28 Jul 2022 19:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659061734; x=1690597734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=12gKVngtqnjv+QPw8p8qTC74M0DQ2NH3SlFgYl5vsoQ=;
  b=GOFV5TQyBSl8WuneX8oGHNn9c0iIHCd8LtAy+syRT3pC/7VVlFzrQEiY
   RoxItuoRBhWYGCkTJxOG+uq93MWiWn4azOaRrLUMdeEcfstuG0oharIum
   9tSf/stDTLvWnootubaRPBk0hHOmMp/ANbHW2PXvOUZNjLgc4cjSJx1Br
   eY5vaP15eQWBuYsHiaLJS88diZ4U8rOxjF0eeFTrR651rwYq1TtDXX783
   7answ6K2XeVCygpLH9kSfOk9Dw3m9KUnbvA+ytUpBwibcIJY7I1U5UyPW
   wMEKsaao694wSTpFXST139wXxguq1977leqDMpYIaA/YPc+TWz6lXfcIc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="275555809"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="275555809"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:28:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="669120036"
Received: from astallix-mobl.amr.corp.intel.com (HELO desk) ([10.212.148.249])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:28:52 -0700
Date:   Thu, 28 Jul 2022 19:28:51 -0700
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
Message-ID: <20220729022851.mdj3wuevkztspodh@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuJ6TQpSTIeXLNfB@zn.tnic>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 02:00:13PM +0200, Borislav Petkov wrote:
> On Thu, Jul 14, 2022 at 06:30:18PM -0700, Pawan Gupta wrote:
> > Older CPUs beyond its Servicing period are not listed in the affected
> > processor list for MMIO Stale Data vulnerabilities. These CPUs currently
> > report "Not affected" in sysfs, which may not be correct.
> > 
> > Add support for "Unknown" reporting for such CPUs. Mitigation is not
> > deployed when the status is "Unknown".
> > 
> > "CPU is beyond its Servicing period" means these CPUs are beyond their
> > Servicing [1] period and have reached End of Servicing Updates (ESU) [2].
> > 
> >   [1] Servicing: The process of providing functional and security
> >   updates to Intel processors or platforms, utilizing the Intel Platform
> >   Update (IPU) process or other similar mechanisms.
> > 
> >   [2] End of Servicing Updates (ESU): ESU is the date at which Intel
> >   will no longer provide Servicing, such as through IPU or other similar
> >   update processes. ESU dates will typically be aligned to end of
> >   quarter.
> 
> The explanations of those things need to be...
> 
> > Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
> > Suggested-by: Tony Luck <tony.luck@intel.com>
> > Fixes: 8d50cdf8b834 ("x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> > CPU vulnerability is unknown if, hardware doesn't set the immunity bits
> > and CPU is not in the known-affected-list.
> > 
> > In order to report the unknown status, this patch sets the MMIO bug
> > for all Intel CPUs that don't have the hardware immunity bits set.
> > Based on the known-affected-list of CPUs, mitigation selection then
> > deploys the mitigation or sets the "Unknown" status; which is ugly.
> > 
> > I will appreciate suggestions to improve this.
> > 
> > Thanks,
> > Pawan
> > 
> >  .../hw-vuln/processor_mmio_stale_data.rst     |  3 +++
> >  arch/x86/kernel/cpu/bugs.c                    | 11 +++++++-
> >  arch/x86/kernel/cpu/common.c                  | 26 +++++++++++++------
> >  arch/x86/kernel/cpu/cpu.h                     |  1 +
> >  4 files changed, 32 insertions(+), 9 deletions(-)
> > 
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
> ... here.

Sure, I will move it here.

> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index 736262a76a12..82088410870e 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1286,6 +1286,22 @@ static bool arch_cap_mmio_immune(u64 ia32_cap)
> >  		ia32_cap & ARCH_CAP_SBDR_SSDP_NO);
> >  }
> >  
> > +bool __init mmio_stale_data_unknown(void)
> 
> This function need to go to ...cpu/intel.c

It will be big churn to move this function to ...cpu/intel.c.

cpu/intel.c is not compiled for !CONFIG_CPU_SUP_INTEL, and bugs.c
depends on this function. For bugs.c to compile there needs to be
another version of this function for !CONFIG_CPU_SUP_INTEL.

Secondly, this function relies on cpu_vuln_blacklist and
arch_cap_mmio_immune(), both are in cpu/common.c and defined static.
They would also need to made available in cpu/intel.c.

To keep things simple, can this stay in cpu/common.c? And if there is a
compelling reason, I am willing to make the required changes.

> > +{
> > +	u64 ia32_cap = x86_read_arch_cap_msr();
> > +
> > +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> > +		return false;
> 
> <---- newline here.
> 
> > +	/*
> > +	 * CPU vulnerability is unknown when, hardware doesn't set the
> 
> no comma after the "when"
> 
> > +	 * immunity bits and CPU is not in the known affected list.
> > +	 */
> > +	if (!cpu_matches(cpu_vuln_blacklist, MMIO) &&
> > +	    !arch_cap_mmio_immune(ia32_cap))
> > +		return true;
> 
> <---- newline here.

Will do this, and above changes.

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
> 
> Why is that vendor check here? We have the cpu_vuln_blacklist for a
> reason.

cpu_vuln_blacklist only has in-support MMIO vulnerable CPUs.

There is no easy way to report unknown status for older CPUs. This
patch sets the MMIO bug for all Intel CPUs that don't have the hardware
immunity bits set.

Later, mmio_select_mitigation() deploys the mitigation or sets the
"Unknown" status based on the known-affected-list of CPUs i.e.
cpu_vuln_blacklist.

The vendor check is required, otherwise MMIO bug will be set for
non-Intel CPUs also.

Thanks,
Pawan
