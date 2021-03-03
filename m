Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2984B32CBB6
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 06:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCDFCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 00:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCDFCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 00:02:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF3AC061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 21:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B76ip7Z1pMeqyo0ZwLMBroQsISdWL+yZsCzxkZ1ErXk=; b=CTmtWS9/X/DNebLxAL9FMJdsZj
        MeyCTW8LPdt1alZjzEG66q5CAN0ESBeYpmoD1bUUCEWRUaNnENvQ1mLXhMvTtU7+dOpmDLw7t1856
        CFNuulPtFyxfAmJTovgQlmnEA5thKeOvP2qayrmsYP/vdsRyS/8HJY2CiAsPmsGf9+vHnw5deDTyH
        /+vSURvY5IZunsuz0rVfFSxU4/CxfyitB1L/u7VPG5srfdYHbNntGyb5N7Qxsqld8CxvGzzUlVr39
        t+dwhvMxw35PHCKgR/AKePTxdVGe1OT9tzB/+pPJIzGpx8ADObCqBoK4zct2pvt0dlvaqKL4AXRvr
        63dUccFQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lHWil-0067U3-3c; Wed, 03 Mar 2021 18:59:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7ADD530011C;
        Wed,  3 Mar 2021 19:59:42 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5DBD023CE7A7E; Wed,  3 Mar 2021 19:59:42 +0100 (CET)
Date:   Wed, 3 Mar 2021 19:59:42 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, eranian@google.com,
        ak@linux.intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only
 single active event"
Message-ID: <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net>
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:

> For some old CPUs (HSW and earlier), the PEBS status in a PEBS record
> may be mistakenly set to 0. To minimize the impact of the defect, the
> commit was introduced to try to avoid dropping the PEBS record for some
> cases. It adds a check in the intel_pmu_drain_pebs_nhm(), and updates
> the local pebs_status accordingly. However, it doesn't correct the PEBS
> status in the PEBS record, which may trigger the crash, especially for
> the large PEBS.
> 
> It's possible that all the PEBS records in a large PEBS have the PEBS
> status 0. If so, the first get_next_pebs_record_by_bit() in the
> __intel_pmu_pebs_event() returns NULL. The at = NULL. Since it's a large
> PEBS, the 'count' parameter must > 1. The second
> get_next_pebs_record_by_bit() will crash.
> 
> Two solutions were considered to fix the crash.
> - Keep the SW workaround and add extra checks in the
>   get_next_pebs_record_by_bit() to workaround the issue. The
>   get_next_pebs_record_by_bit() is a critical path. The extra checks
>   will bring extra overhead for the latest CPUs which don't have the
>   defect. Also, the defect can only be observed on some old CPUs
>   (For example, the issue can be reproduced on an HSW client, but I
>   didn't observe the issue on my Haswell server machine.). The impact
>   of the defect should be limit.
>   This solution is dropped.
> - Drop the SW workaround and revert the commit.
>   It seems that the commit never works, because the PEBS status in the
>   PEBS record never be changed. The get_next_pebs_record_by_bit() only
>   checks the PEBS status in the PEBS record. The record is dropped
>   eventually. Reverting the commit should not change the current
>   behavior.

> +++ b/arch/x86/events/intel/ds.c
> @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
>  			continue;
>  		}
>  
> -		/*
> -		 * On some CPUs the PEBS status can be zero when PEBS is
> -		 * racing with clearing of GLOBAL_STATUS.
> -		 *
> -		 * Normally we would drop that record, but in the
> -		 * case when there is only a single active PEBS event
> -		 * we can assume it's for that event.
> -		 */
> -		if (!pebs_status && cpuc->pebs_enabled &&
> -			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
> -			pebs_status = cpuc->pebs_enabled;

Wouldn't something like:

			pebs_status = p->status = cpus->pebs_enabled;

actually fix things without adding overhead?


