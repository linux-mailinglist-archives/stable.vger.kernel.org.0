Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED91B2597EA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgIAQUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbgIAPcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 11:32:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36CCC061244;
        Tue,  1 Sep 2020 08:32:47 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id d11so2240705ejt.13;
        Tue, 01 Sep 2020 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4y5+uILsrYEyrll+p0CQ1799yDtGVcYn/QLXWN/UkVA=;
        b=EHuuu2pzBr1VfUBw4YoRiSfvSUiZeM+77kGjAP5zTLHasH7nR9vXXYvwCrbZU6c2jd
         4seupK2oQl7hy/pRNHsPIqGejkRNxOtFMlnhfBZDpAiMkHr5pZB6BzPT4m+xJPonISe1
         HNL48Aq235dCBlPMhV8inHNlZDOIrbnOh1JBXPfbeG8+sj6XuyqKsj94Gpd9ONs14vLu
         deSYvLYAn6bVnvmYKfnhfxtYq2kvw0toScDDKCc1SxRZHd8XQ+4rc2te9/bh4pe/QeAl
         lQCzapBnm6XmP/Hk7wQ5e2G3zy3d5GlwxxTvtVvi1NsTwVz1Ra28amh4VKBfVkpE2OfS
         5CZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4y5+uILsrYEyrll+p0CQ1799yDtGVcYn/QLXWN/UkVA=;
        b=Ym+mzSh5cdCJNDMZabqt1Xrre+C7S3QscthrKgYreDVxXYNKGitSweOAqTCszH3Box
         tg2GwzbbYbuz6bWiK0UT2SkMzycRnGizC+LLShGqrmbNsLXDpnhDuXy6P2MAJW7i494m
         Bf9/xLDB51yHKQCySoacOKDet30xcUatIACt2+wqEinE5mz8FqWKEPiUOIJYcjLRsmMu
         jLQo8fy1ahFTDX9CXwxy1hFrhHomRBM1wf11hM1Pvz6tzMqYwyKu0RiEcFTd2Ew17obQ
         l8XbRq9n8NJ8zXbkBZr6a5IBRUE2Pemfg84uPXXhf50uZ3uHOGM8rYnDO0alxs4QjKs4
         01Yw==
X-Gm-Message-State: AOAM531JT8P+b4s9qR1KvH8fzdyjEfWspmuoGKlpS0wpbgBFpzGXZTSk
        jly3t9ZNjz+nzdQTTm1ViHsmOjk1Urj/cDPx0CE=
X-Google-Smtp-Source: ABdhPJzjka1igjLabnL5+FLiBQxxm/UurFtkX4pyV20hzOcltWvHAgjxNxAU2zE5rwt6/lT63IqZjcdxApMAe3KOB6I=
X-Received: by 2002:a17:906:3a85:: with SMTP id y5mr1900924ejd.507.1598974366460;
 Tue, 01 Sep 2020 08:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190812222911.2364802-1-guro@fb.com> <20190812222911.2364802-2-guro@fb.com>
 <20190813142752.35807b6070db795674f86feb@linux-foundation.org> <20190813214643.GA20632@tower.DHCP.thefacebook.com>
In-Reply-To: <20190813214643.GA20632@tower.DHCP.thefacebook.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Tue, 1 Sep 2020 08:32:33 -0700
Message-ID: <CAHbLzkrEWnfgUT7gEPvKR9uz+NkANzKUMOd17GEAoe-dHTjF_g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: memcontrol: flush percpu vmstats before releasing memcg
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This report is kind of late, hope everyone still remembers the context.

I just happened to see a similar problem on our v4.19 kernel, please
see the below output from memory.stat:

total_cache 7361626112
total_rss 8268165120
total_rss_huge 0
total_shmem 0
total_mapped_file 4154929152
total_dirty 389689344
total_writeback 101376000
...
[snip]
...
total_inactive_anon 4096
total_active_anon 1638400
total_inactive_file 208990208
total_active_file 275030016

And memory.usage_in_bytes:
1248215040

The total_* counters are way bigger than the counters of LRUs and usage.

Some ephemeral cgroups were created/deleted frequently under this
problematic cgroup. And this host has been up for more than 200 days.
I didn't see such problems on shorter uptime hosts (the other 4.19
host is up for 19 days) and v5.4 hosts.

v4.19 also updates stats from per-cpu caches, and total_* sum all sub
cgroups together. So it seems this is the same problem.

Anyway this is not a significant problem since we can get the correct
numbers from other counters, i.e. LRUs, but just confusing. Not sure
if it is worth backporting the fix to v4.19.

On Tue, Aug 13, 2019 at 2:46 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Tue, Aug 13, 2019 at 02:27:52PM -0700, Andrew Morton wrote:
> > On Mon, 12 Aug 2019 15:29:10 -0700 Roman Gushchin <guro@fb.com> wrote:
> >
> > > Percpu caching of local vmstats with the conditional propagation
> > > by the cgroup tree leads to an accumulation of errors on non-leaf
> > > levels.
> > >
> > > Let's imagine two nested memory cgroups A and A/B. Say, a process
> > > belonging to A/B allocates 100 pagecache pages on the CPU 0.
> > > The percpu cache will spill 3 times, so that 32*3=96 pages will be
> > > accounted to A/B and A atomic vmstat counters, 4 pages will remain
> > > in the percpu cache.
> > >
> > > Imagine A/B is nearby memory.max, so that every following allocation
> > > triggers a direct reclaim on the local CPU. Say, each such attempt
> > > will free 16 pages on a new cpu. That means every percpu cache will
> > > have -16 pages, except the first one, which will have 4 - 16 = -12.
> > > A/B and A atomic counters will not be touched at all.
> > >
> > > Now a user removes A/B. All percpu caches are freed and corresponding
> > > vmstat numbers are forgotten. A has 96 pages more than expected.
> > >
> > > As memory cgroups are created and destroyed, errors do accumulate.
> > > Even 1-2 pages differences can accumulate into large numbers.
> > >
> > > To fix this issue let's accumulate and propagate percpu vmstat
> > > values before releasing the memory cgroup. At this point these
> > > numbers are stable and cannot be changed.
> > >
> > > Since on cpu hotplug we do flush percpu vmstats anyway, we can
> > > iterate only over online cpus.
> > >
> > > Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty")
> >
> > Is this not serious enough for a cc:stable?
>
> I hope the "Fixes" tag will work, but yeah, my bad, cc:stable is definitely
> a good idea here.
>
> Added stable@ to cc.
>
> Thanks!
>
