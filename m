Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85CF33E685
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 03:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhCQCEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 22:04:22 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:40431 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhCQCEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 22:04:15 -0400
Received: by mail-qk1-f179.google.com with SMTP id l132so37442869qke.7;
        Tue, 16 Mar 2021 19:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JcruQA4n+4DyqipXWnHJO3WRJQiZCjm/eh3UvgibVSA=;
        b=FEAtcw9XoUK4/euvqLg30g5qxzf6zabElq9js/MznK0FGyPpN6k9uu9HN2cejgs1eX
         Q5P1KSerH0+8tgLFIJoCoLrVMQaq5oyOA8qpNz+4OBDqpNfuZONdkLMTjI/VuYpJFs6O
         zKEHRlGztNqx1TFnq+RtkLcCIDo0Mp5vVG3dzKRjxrvBSRLjCaJbxPNEb8A/FUF3bNiA
         29R6zamzqgxJtYOxdDNj+txHuVBE7plvJ1f4aW+pTW/98q9st/CZh41eB1VitBXBv95u
         X5mcGnCySa+8S9qZkjzJn8mpDRTHQRt9F6q5uSrmE12us/MY8X8IF0SpkaLnx/dORSZM
         0RlQ==
X-Gm-Message-State: AOAM533i3HDbvuGZh+A/HYElWpdxJsC2fEQqy5N/cvSO09LkRxy44Roe
        rCIE+vna84sLYsreBKsn17wA4ic5n42U9NLANpI=
X-Google-Smtp-Source: ABdhPJzSxxfxQXSbM5/wRJ7DkDddj6iKJg2WiFnq69ufcw5RFhZpMGYCJI6qCV8Qskktlh3v+8wBtWD61PC2gfUVUqA=
X-Received: by 2002:a05:620a:3cb:: with SMTP id r11mr2259307qkm.148.1615946654197;
 Tue, 16 Mar 2021 19:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
 <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net> <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
 <YD/vy2RnkWZYiJHP@hirez.programming.kicks-ass.net> <CAM9d7cjbSGC_mac0CuU3xnDN=bkJ81W+FLn5XSvxbaHb5HL6Fw@mail.gmail.com>
 <c0fa23c1-bd49-8b98-a61b-5b34ae6a7a78@linux.intel.com>
In-Reply-To: <c0fa23c1-bd49-8b98-a61b-5b34ae6a7a78@linux.intel.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 17 Mar 2021 11:04:01 +0900
Message-ID: <CAM9d7ciyQAm6scMu6reEh7FT2TDX3W5E96ogUwzigp2usdb+MQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only single
 active event"
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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

On Tue, Mar 16, 2021 at 9:28 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 3/16/2021 3:22 AM, Namhyung Kim wrote:
> > Hi Peter and Kan,
> >
> > On Thu, Mar 4, 2021 at 5:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> On Wed, Mar 03, 2021 at 02:53:00PM -0500, Liang, Kan wrote:
> >>> On 3/3/2021 1:59 PM, Peter Zijlstra wrote:
> >>>> On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:
> >>
> >>>>> +++ b/arch/x86/events/intel/ds.c
> >>>>> @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
> >>>>>                            continue;
> >>>>>                    }
> >>>>> -         /*
> >>>>> -          * On some CPUs the PEBS status can be zero when PEBS is
> >>>>> -          * racing with clearing of GLOBAL_STATUS.
> >>>>> -          *
> >>>>> -          * Normally we would drop that record, but in the
> >>>>> -          * case when there is only a single active PEBS event
> >>>>> -          * we can assume it's for that event.
> >>>>> -          */
> >>>>> -         if (!pebs_status && cpuc->pebs_enabled &&
> >>>>> -                 !(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
> >>>>> -                 pebs_status = cpuc->pebs_enabled;
> >>>>
> >>>> Wouldn't something like:
> >>>>
> >>>>                      pebs_status = p->status = cpus->pebs_enabled;
> >>>>
> >>>
> >>> I didn't consider it as a potential solution in this patch because I don't
> >>> think it's a proper way that SW modifies the buffer, which is supposed to be
> >>> manipulated by the HW.
> >>
> >> Right, but then HW was supposed to write sane values and it doesn't do
> >> that either ;-)
> >>
> >>> It's just a personal preference. I don't see any issue here. We may try it.
> >>
> >> So I mostly agree with you, but I think it's a shame to unsupport such
> >> chips, HSW is still a plenty useable chip today.
> >
> > I got a similar issue on ivybridge machines which caused kernel crash.
> > My case it's related to the branch stack with PEBS events but I think
> > it's the same issue.  And I can confirm that the above approach of
> > updating p->status fixed the problem.
> >
> > I've talked to Stephane about this, and he wants to make it more
> > robust when we see stale (or invalid) PEBS records.  I'll send the
> > patch soon.
> >
>
> Hi Namhyung,
>
> In case you didn't see it, I've already submitted a patch to fix the
> issue last Friday.
> https://lore.kernel.org/lkml/1615555298-140216-1-git-send-email-kan.liang@linux.intel.com/
> But if you have a more robust proposal, please feel free to submit it.
>
> BTW: The patch set from last Friday also fixed another bug found by the
> perf_fuzzer test. You may be interested.

Right, I missed it.  It'd be nice if you could CC me for perf patches later.

Thanks,
Namhyung
