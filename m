Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167D233E752
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 04:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhCQDBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 23:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCQDBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 23:01:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A9AC06174A;
        Tue, 16 Mar 2021 20:01:06 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so2446714pjb.0;
        Tue, 16 Mar 2021 20:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SdsTMooi92NRcHVBy2PnTkunRKL2Xu7qbGA9O+vVbVs=;
        b=qvudIyZjNxfmcqJ1XR4pcxRCER9jHiYC34auqQtUwvQvh+AUwZrzaP1UW1rZu7v0Kn
         P1JlU+QDEDF+Zp5laM3KXXphoFlZOjapBwGWmi84XRPNws0BjB+uh9csDWgWJMOsbPZb
         FrCCldrbdd5Aw9xdIcIq2+nOXZBzsfTPweZ5hbiz0Mot2FZ9Mq0UzRvjY/adkT6/+pqk
         OhftmJWRw3WcmFLgmv6gNec+UCu/mv+gdZellopMNBDQOzBysBF0aoiEVojzSlljuGH/
         3nUsIMXMYJtbVeKd+IFULk5Kkv5PoZ1zJqmFJ6xrnvZbUnk+I3Q2zBEESu6m9cowNF7M
         w+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=SdsTMooi92NRcHVBy2PnTkunRKL2Xu7qbGA9O+vVbVs=;
        b=jZqNV0jaekDqHrlR69ZL/1MMaYvQdBWMV5WUhcGAzESdPIox9oZaUUF6823nJ0Oc/m
         JTh/aQC3lQsirXZAUr65y1CeeuXLCt8TutyxdaDFHUfcPkgQ4qsvB3bVEysJAV2Xkg52
         ZDmQChbHKmQxlEwDntnae062oYqQTOwu4fbSQDH2GxO88AJhUYjr1MqQxQytpL/yx3WV
         A2IgkX7jzh6QHOu9oyn6HNrkIwSGyj/pizpMP2vi4x5dlOLXGtRjxlkTRUq4hy2R5gH2
         84aG4bDDqrttyCVgyxyJPxZ/DblmAGcCxR21YVysBY0nVLLB+BtW2Jp4Ux9MWpwKL46a
         292g==
X-Gm-Message-State: AOAM530tw8rJb7PwmtCHicDOYmiQ+39xt6Cxahjp/UsjPYCRFBea0av+
        IZVfZbtz/U5QE0BNkTYfPhwSW5hIlf0=
X-Google-Smtp-Source: ABdhPJygtjhw+ic8c3Bnu+X2wB5MuPCx14rV4Jh11mM8p1vyMoYtcjLGHxCb9CMaA1Mxl7tDwq1Vfw==
X-Received: by 2002:a17:902:be0c:b029:e6:f0b:91ab with SMTP id r12-20020a170902be0cb02900e60f0b91abmr2388344pls.2.1615950065463;
        Tue, 16 Mar 2021 20:01:05 -0700 (PDT)
Received: from google.com ([101.235.31.111])
        by smtp.gmail.com with ESMTPSA id gm10sm684536pjb.4.2021.03.16.20.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 20:01:04 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
Date:   Wed, 17 Mar 2021 12:01:00 +0900
From:   Namhyung Kim <namhyung@kernel.org>
To:     kan.liang@linux.intel.com
Cc:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, vincent.weaver@maine.edu,
        eranian@google.com, ak@linux.intel.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] perf/x86/intel: Fix a crash caused by zero PEBS
 status
Message-ID: <YFFw7OvwqN/KVzvp@google.com>
References: <1615555298-140216-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1615555298-140216-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 05:21:37AM -0800, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> A repeatable crash can be triggered by the perf_fuzzer on some Haswell
> system.
> https://lore.kernel.org/lkml/7170d3b-c17f-1ded-52aa-cc6d9ae999f4@maine.edu/
> 
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
> Besides the local pebs_status, correct the PEBS status in the PEBS
> record as well.
> 
> Fixes: 01330d7288e0 ("perf/x86: Allow zero PEBS status with only single active event")
> Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org

Tested-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  arch/x86/events/intel/ds.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index 7ebae18..bcf4fa5 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -2010,7 +2010,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
>  		 */
>  		if (!pebs_status && cpuc->pebs_enabled &&
>  			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
> -			pebs_status = cpuc->pebs_enabled;
> +			pebs_status = p->status = cpuc->pebs_enabled;
>  
>  		bit = find_first_bit((unsigned long *)&pebs_status,
>  					x86_pmu.max_pebs_events);
> -- 
> 2.7.4
> 
