Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCC133CE8E
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 08:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCPHWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 03:22:50 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:36591 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhCPHWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 03:22:22 -0400
Received: by mail-qk1-f181.google.com with SMTP id n79so34294733qke.3;
        Tue, 16 Mar 2021 00:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XypHAARpZukwprD44oUN3XYz7B3z0WrE+Lu1+PHkgig=;
        b=DJu7FVdXsGxNzfxjvdEwY62FgcIPFQx+64uuqiC2Uv/gQG5FnmRWvDPatCYP6cjkVO
         rtPrPyyEdMmmUrKCAYgg00YnnNyrPfjBC9Z7t3pxBz4B7bC1WSzONXIXDDqkG4Pmz9se
         tNTiO5GXzuRsFJIe+5IBD4BgF+wf8izx1uGk/3VsHBEQmw4YdqS/QA0mBzswVmLgS1Zd
         n+gBcpPxOC2ylK+/3CQDV05hWs+cFzYq94wsOymlfUD1Wfrg/HgAkE1A3sgPonnXpZ+y
         9Ixs0X2JU1h2GI/j6Mx5rSbCoiUQxU8bS2LuTYIPRLA7Mb0McBYpqnTdid6VLzaYdYyR
         ct3Q==
X-Gm-Message-State: AOAM530qc8LnxvsAyt3qTUCeJ7blXTTDi/WcI2BvZi/NluVlgz5/1uvG
        cfh4pUb/9adhypMe2QJa4mh65Tb4qvjnILw1EBs=
X-Google-Smtp-Source: ABdhPJzNscKvYrVo+yrr63c4ruxSltZ20SZE0CtI9tai+v3U891vPaTD8W/Rcxc8hou49p+hVH6oeQgoIeNrK8O4jkc=
X-Received: by 2002:a05:620a:4511:: with SMTP id t17mr29049978qkp.316.1615879341399;
 Tue, 16 Mar 2021 00:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
 <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net> <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
 <YD/vy2RnkWZYiJHP@hirez.programming.kicks-ass.net>
In-Reply-To: <YD/vy2RnkWZYiJHP@hirez.programming.kicks-ass.net>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Tue, 16 Mar 2021 16:22:09 +0900
Message-ID: <CAM9d7cjbSGC_mac0CuU3xnDN=bkJ81W+FLn5XSvxbaHb5HL6Fw@mail.gmail.com>
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only single
 active event"
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        "stable # 4 . 5" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter and Kan,

On Thu, Mar 4, 2021 at 5:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Mar 03, 2021 at 02:53:00PM -0500, Liang, Kan wrote:
> > On 3/3/2021 1:59 PM, Peter Zijlstra wrote:
> > > On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:
>
> > > > +++ b/arch/x86/events/intel/ds.c
> > > > @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
> > > >                           continue;
> > > >                   }
> > > > -         /*
> > > > -          * On some CPUs the PEBS status can be zero when PEBS is
> > > > -          * racing with clearing of GLOBAL_STATUS.
> > > > -          *
> > > > -          * Normally we would drop that record, but in the
> > > > -          * case when there is only a single active PEBS event
> > > > -          * we can assume it's for that event.
> > > > -          */
> > > > -         if (!pebs_status && cpuc->pebs_enabled &&
> > > > -                 !(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
> > > > -                 pebs_status = cpuc->pebs_enabled;
> > >
> > > Wouldn't something like:
> > >
> > >                     pebs_status = p->status = cpus->pebs_enabled;
> > >
> >
> > I didn't consider it as a potential solution in this patch because I don't
> > think it's a proper way that SW modifies the buffer, which is supposed to be
> > manipulated by the HW.
>
> Right, but then HW was supposed to write sane values and it doesn't do
> that either ;-)
>
> > It's just a personal preference. I don't see any issue here. We may try it.
>
> So I mostly agree with you, but I think it's a shame to unsupport such
> chips, HSW is still a plenty useable chip today.

I got a similar issue on ivybridge machines which caused kernel crash.
My case it's related to the branch stack with PEBS events but I think
it's the same issue.  And I can confirm that the above approach of
updating p->status fixed the problem.

I've talked to Stephane about this, and he wants to make it more
robust when we see stale (or invalid) PEBS records.  I'll send the
patch soon.

Thanks,
Namhyung
