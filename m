Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D4448C1B6
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 10:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbiALJyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 04:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239362AbiALJyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 04:54:36 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1926C06173F;
        Wed, 12 Jan 2022 01:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AkEsNGw7XQrqb8BRcUxXpRJLYWEiaYJ1i3UkAFQeC+8=; b=gxnHIGVg5zc9Z2933Qq10jQJSy
        DM0dQEXd/HiFA2mpV/IyvnM+c+0DalZ6cCv0SJTdbDGCWcm3Az3ZyrxNF9rwERusRhBkriiWfHm5N
        Z+KL8wArT1VXK0+uZwQltZxI9ZKUOyTjWVGxt4kfwf/Y/efzqVmcS6xYJeqLFo6LiuO/6Pqj9A2hR
        zo7Hcm2pzKDlwsKk808YMHF3DTyeadl0YJet7/fmDuSvVr1DA9JFaGSb/w40OZXnWdmOZglxoLVE/
        piLu7LU4pFhrofccQwCKapvsT9a+p1T1drVmcbDgqFtTYEUnfsay7YkYFOgCBaal9I1PNxZCwMVi2
        3PWSUyrg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7aKi-000mPx-1r; Wed, 12 Jan 2022 09:54:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8CEAB3001FD;
        Wed, 12 Jan 2022 10:54:16 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 45E4E2B33EC0A; Wed, 12 Jan 2022 10:54:16 +0100 (CET)
Date:   Wed, 12 Jan 2022 10:54:16 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        damarion@cisco.com, edison_chan_gz@hotmail.com,
        ray.kinsella@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel: Add a quirk for the calculation of the
 number of counters on Alder Lake
Message-ID: <Yd6lSH41fqcpUS+P@hirez.programming.kicks-ass.net>
References: <1641925238-149288-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641925238-149288-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 10:20:38AM -0800, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> For some Alder Lake machine with all E-cores disabled in a BIOS, the
> below warning may be triggered.
> 
> [ 2.010766] hw perf events fixed 5 > max(4), clipping!
> 
> Current perf code relies on the CPUID leaf 0xA and leaf 7.EDX[15] to
> calculate the number of the counters and follow the below assumption.
> 
> For a hybrid configuration, the leaf 7.EDX[15] (X86_FEATURE_HYBRID_CPU)
> is set. The leaf 0xA only enumerate the common counters. Linux perf has
> to manually add the extra GP counters and fixed counters for P-cores.
> For a non-hybrid configuration, the X86_FEATURE_HYBRID_CPU should not
> be set. The leaf 0xA enumerates all counters.
> 
> However, that's not the case when all E-cores are disabled in a BIOS.
> Although there are only P-cores in the system, the leaf 7.EDX[15]
> (X86_FEATURE_HYBRID_CPU) is still set. But the leaf 0xA is updated
> to enumerate all counters of P-cores. The inconsistency triggers the
> warning.
> 
> Several software ways were considered to handle the inconsistency.
> - Drop the leaf 0xA and leaf 7.EDX[15] CPUID enumeration support.
>   Hardcode the number of counters. This solution may be a problem for
>   virtualization. A hypervisor cannot control the number of counters
>   in a Linux guest via changing the guest CPUID enumeration anymore.
> - Find another CPUID bit that is also updated with E-cores disabled.
>   There may be a problem in the virtualization environment too. Because
>   a hypervisor may disable the feature/CPUID bit.
> - The P-cores have a maximum of 8 GP counters and 4 fixed counters on
>   ADL. The maximum number can be used to detect the case.
>   This solution is implemented in this patch.

ARGH!! This is horrific :-(

This is also the N-th problem with hybrid enumeration; is there a plan
to fix all that for the next generation or are we going to keep muddling
things?

> Fixes: ee72a94ea4a6 ("perf/x86/intel: Fix fixed counter check warning for some Alder Lake")
> Reported-by: Damjan Marion (damarion) <damarion@cisco.com>
> Tested-by: Damjan Marion (damarion) <damarion@cisco.com>
> Reported-by: Chan Edison <edison_chan_gz@hotmail.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/events/intel/core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 187906e..f1201e8 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -6239,6 +6239,18 @@ __init int intel_pmu_init(void)
>  			pmu->num_counters = x86_pmu.num_counters;
>  			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
>  		}
> +
> +		/* Quirk: For some Alder Lake machine, when all E-cores are disabled in
> +		 * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
> +		 * the X86_FEATURE_HYBRID_CPU is still set. The above codes will
> +		 * mistakenly add extra counters for P-cores. Correct the number of
> +		 * counters here.
> +		 */

I fixed that comment style for you.

> +		if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
> +			pmu->num_counters = x86_pmu.num_counters;
> +			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
> +		}
> +
>  		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
>  		pmu->unconstrained = (struct event_constraint)
>  					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
> -- 
> 2.7.4
> 
