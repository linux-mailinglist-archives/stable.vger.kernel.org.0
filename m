Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F78263FF9
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 10:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgIJIcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 04:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730287AbgIJIcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 04:32:47 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF917C061573;
        Thu, 10 Sep 2020 01:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G3nNqf5JBiDJaw2zC0YQ7yH7mIdITSgiMb8ebwlBBr8=; b=rUsfX3hYLhfcfajSqh1YoOUQJm
        lvXH0WoX3lNO33iU0NeSkXptod9s+vcx27Eqa1KCHBRZt57G4pkxNGmX5D4i97HfJYgMcI//yilvM
        FFOVK34ocrYKszzfKlukkRmLXtoTsfXdI+OYqKJJSdwdzidGE4x0LyULaacQHcZHSQf4QV4R8WcmQ
        1N/Lyyx3spy22oxzEi4QLuMtbBJrhJe+rF4jJdG8wbiF18JYpV6hNWxQflbmnUbXeguqu9R9xfQMu
        uWk3/XdwEa3XUOv0qjo+gyuebDctyP/XWu73MuTQ7WDbtf9G0tQzuQWf05HEDHRSZvhkLEqoVyfwA
        UpnoJC1g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGI0L-000566-SJ; Thu, 10 Sep 2020 08:32:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 545D23050F0;
        Thu, 10 Sep 2020 10:32:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A8A1726512445; Thu, 10 Sep 2020 10:32:23 +0200 (CEST)
Date:   Thu, 10 Sep 2020 10:32:23 +0200
From:   peterz@infradead.org
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Stephane Eranian <stephane.eranian@google.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 3/7] arch/x86/amd/ibs: Fix re-arming IBS Fetch
Message-ID: <20200910083223.GY1362448@hirez.programming.kicks-ass.net>
References: <20200908214740.18097-1-kim.phillips@amd.com>
 <20200908214740.18097-4-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908214740.18097-4-kim.phillips@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 04:47:36PM -0500, Kim Phillips wrote:
> Stephane Eranian found a bug in that IBS' current Fetch counter was not
> being reset when the driver would write the new value to clear it along
> with the enable bit set, and found that adding an MSR write that would
> first disable IBS Fetch would make IBS Fetch reset its current count.
> 
> Indeed, the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54 - Sep 12,
> 2019 states "The periodic fetch counter is set to IbsFetchCnt [...] when
> IbsFetchEn is changed from 0 to 1."
> 
> Explicitly set IbsFetchEn to 0 and then to 1 when re-enabling IBS Fetch,
> so the driver properly resets the internal counter to 0 and IBS
> Fetch starts counting again.
> 
> A family 15h machine tested does not have this problem, and the extra
> wrmsr is also not needed on Family 19h, so only do the extra wrmsr on
> families 16h through 18h.

*groan*...

> ---
>  arch/x86/events/amd/ibs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
> index 26c36357c4c9..3eb9a55e998c 100644
> --- a/arch/x86/events/amd/ibs.c
> +++ b/arch/x86/events/amd/ibs.c
> @@ -363,7 +363,14 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
>  static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
>  					 struct hw_perf_event *hwc, u64 config)
>  {
> -	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
> +	u64 _config = (hwc->config | config) & ~perf_ibs->enable_mask;
> +
> +	/* On Fam17h, the periodic fetch counter is set when IbsFetchEn is changed from 0 to 1 */
> +	if (perf_ibs == &perf_ibs_fetch && boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
> +		wrmsrl(hwc->config_base, _config);

That's an anti-patttern (and for some reason this is the second time in
a week I've seen it). This is a fairly hot path and you're adding a
whole bunch of loads and branches.

Granted, in case you need the extra wrmsr that's probably noise, but
supposedly you're going to be fixing this in hardware eventually, and
you'll be getting rid of the second wrmsr again. But then you're stuck
with the loads and branches.

A better option would be to use hwc->flags, you're loading from that
line already, so it's guaranteed hot and then you only have a single
branch. Or stick it in perf_ibs near enable_mask, same difference.

> + 	_config |= perf_ibs->enable_mask;
> +	wrmsrl(hwc->config_base, _config);
>  }
>  
>  /*
> -- 
> 2.27.0
> 
