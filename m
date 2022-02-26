Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B354C531A
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 02:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiBZBns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 20:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiBZBnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 20:43:47 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2112A2308
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 17:43:10 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c9so6237847pll.0
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 17:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PVUmr01vxo2MfeZIcVa242AyLzLGr7DmFOqnKspe5oo=;
        b=g7+3YvD71i4cYpDgsVXRs6VjOt3Np9OxZ/vd1UugXCCnnBMzSZ1u/kSQOgIzsv2RW7
         KTwGzMI7ijIz+tnxvMMLRvTVtizPUmJxNhHdWZeQUskYgbYwYdrSIbM+QpPqkGAlHfy2
         LdZM9ykzpQE3lLbLvVEmFW3X4f5AYqqCEen/v5MWGCQNWVPjmo7wXmGhy2kqZSBNKZPP
         oUGF6XnpafKrhrj8EaW65TOo3AfKd9PBClE0LNfewWSAfXfxtSao2EkVBplJOO1ffH65
         LK9yweKPr75iY/XsHxIoqk1/gDWy7/pRyIBR8vmRLw2mgrUhflfHqdTx+uqGhXAY3CX8
         I7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVUmr01vxo2MfeZIcVa242AyLzLGr7DmFOqnKspe5oo=;
        b=4kldicLQZzMOAwFTucYJ3RrHNxesmrCbaBI0fQpsaU9yLeWWhcmbe8WRy6Q8U4zjUH
         Ho7tDJugDvxAJBK6x2ptQYWVoQUeLQ4p1UelZDwFeG0gpncTd0ncykVaDYh28x3UzS1L
         wluqXFeg3Y49ahpX+pMrT9E07TeI7cyLJ8ttpMfA2x6BQ+R+SV2+Plco9l10VyXolA5H
         5zO0qcy51yLytkclRIgjFopPUL5kps61DwASRnP5Xw5K/zRPn/f4n52jHbBI0dzbWtkZ
         HtP8wjszGB/YV1lnTuD7jeZXtsBIeSX1iJcll6AhDVEqHEPX99k/kzpmjskXZ6VjorXn
         4cdA==
X-Gm-Message-State: AOAM5307AuGygr5aLH4Y3JwS+K1RAGz7qLOe0qpjhzkpuyESqcxrudRx
        t7vckNrTKUGHfIviEm6OJWum03V2r9K7L4evXBjfTQ==
X-Google-Smtp-Source: ABdhPJxNsp5giug54AbkHUefcht34gnRyF3rG7vWHDkcAp7FfUNXEr572Feoy/GkEEt4P7nae81xhjcvF4WhhVFwKz0=
X-Received: by 2002:a17:90a:db15:b0:1bd:71f:8123 with SMTP id
 g21-20020a17090adb1500b001bd071f8123mr3081583pjv.126.1645839789806; Fri, 25
 Feb 2022 17:43:09 -0800 (PST)
MIME-Version: 1.0
References: <20220226002412.113819-1-shakeelb@google.com> <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
In-Reply-To: <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 25 Feb 2022 17:42:57 -0800
Message-ID: <CALvZod7SA17vounKnq1KX23172rztNN_Oo0K1XaeEuS4JVEhMw@mail.gmail.com>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive codepaths
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Dao <dqminh@cloudflare.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 4:58 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 25 Feb 2022 16:24:12 -0800 Shakeel Butt <shakeelb@google.com> wrote:
>
> > Daniel Dao has reported [1] a regression on workloads that may trigger
> > a lot of refaults (anon and file). The underlying issue is that flushing
> > rstat is expensive. Although rstat flush are batched with (nr_cpus *
> > MEMCG_BATCH) stat updates, it seems like there are workloads which
> > genuinely do stat updates larger than batch value within short amount of
> > time. Since the rstat flush can happen in the performance critical
> > codepaths like page faults, such workload can suffer greatly.
> >
> > The easiest fix for now is for performance critical codepaths trigger
> > the rstat flush asynchronously. This patch converts the refault codepath
> > to use async rstat flush. In addition, this patch has premptively
> > converted mem_cgroup_wb_stats and shrink_node to also use the async
> > rstat flush as they may also similar performance regressions.
>
> Gee we do this trick a lot and gee I don't like it :(
>
> a) if we're doing too much work then we're doing too much work.
>    Punting that work over to a different CPU or thread doesn't alter
>    that - it in fact adds more work.
>

Please note that we already have the async worker running every 2
seconds. Normally no consumer would need to flush the stats but if
there were too many stat updates from producers in a short amount of
time then one of the consumers will have to pay the price of the
flush.

We have two types of consumers i.e. performance critical (e.g.
refault) and non-performance critical (e.g. memory.stat or num_stat
readers). I think we can let the performance critical consumer skip
the synchronous flushing and the async worker do the work for
performance reasons.

> b) there's an assumption here that the flusher is able to keep up
>    with the producer.  What happens if that isn't the case?  Do we
>    simply wind up the deferred items until the system goes oom?
>

Without a consumer nothing bad can happen even if flusher is slow (or
it has too much work) or too many stats are being updated by many
producers.

With a couple of consumers, in the current kernel, one of them may
have to pay the cost of synch flush. With this patch, we will have two
types of consumers. First, who are ok to pay the price of sync flush
to get the accurate stats and second who are ok with out of sync stats
but bounded by 2 seconds (yes assuming flusher runs every 2 seconds).

BTW there is no concern of the system going into oom due to reading a
bit older stats.

>    What happens if there's a producer running on each CPU?  Can the
>    flushers keep up?
>
>    Pathologically, what happens if the producer is running
>    task_is_realtime() on a single-CPU system?  Or if there's a
>    task_is_realtime() producer running on every CPU?  The flusher never
>    gets to run and we're dead?
>

I think it has to be a mix of (stat) producers and (stat) consumers
which are hogging CPU forever and no, we will not be dead. At worst
the consumers might be making some wrong decisions due to consuming
older stats.

One can argue that since one consumer is reclaim code, some reclaim
heuristic can get messed up due to older stats. Yes, that can happen.

>
> An obvious fix is to limit the permissible amount of windup (to what?)
> and at some point, do the flushing synchronously anyway.
>

That is what we are currently doing. The limit being nr_cpus * MEMCG_BATCH.

> Or we just don't do any this at all and put up with the cost of the
> current code.  I mean, this "fix" is kind of fake anyway, isn't it?
> Pushing the 4-10ms delay onto a different CPU will just disrupt
> something else which wanted to run on that CPU.  The overall effect is
> to hide the impact from one particular testcase, but is the benefit
> really a real one?
>

Yes, the right fix would be to optimize the flushing code (but that
would require more work/time). However I still think letting
performance critical code paths to skip the sync flush would be good
in general. So, if the current patch is not to your liking we can
remove mem_cgroup_flush_stats() from workingset_refault().
