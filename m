Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101ED4C5300
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 02:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiBZBU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 20:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiBZBU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 20:20:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9082261CD;
        Fri, 25 Feb 2022 17:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD8FB833C1;
        Sat, 26 Feb 2022 01:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C31EC340E7;
        Sat, 26 Feb 2022 01:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645838421;
        bh=MNZX72o3nFMbB/Wwvsuo/JcaX7p+1wDXXsOIDM8WRLU=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=zmWl8r1zxiQ0jrS8v8GX2dMS2IbwAeJT3rJc4OKcvYDvfgriT/2Uh+pJMTxjwkmga
         dec2ncVjw75/YQsfaJ41+6Vkm0UlnLtet/OAZkUCcbZEBLuq/+WccgxsVMq89VFcHB
         3RaCOTxB6U4AZBiA/00lgniy6doBCdZfikWpFUHY=
Date:   Fri, 25 Feb 2022 17:20:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shakeel Butt <shakeelb@google.com>,
        =?ISO-8859-1?Q? "Michal_Koutn=FD" ?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Daniel Dao <dqminh@cloudflare.com>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Message-Id: <20220225172020.b3e59e11a0a3dd15e0d34141@linux-foundation.org>
In-Reply-To: <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
References: <20220226002412.113819-1-shakeelb@google.com>
        <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Feb 2022 16:58:42 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

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
> b) there's an assumption here that the flusher is able to keep up
>    with the producer.  What happens if that isn't the case?  Do we
>    simply wind up the deferred items until the system goes oom?
> 
>    What happens if there's a producer running on each CPU?  Can the
>    flushers keep up?
> 
>    Pathologically, what happens if the producer is running
>    task_is_realtime() on a single-CPU system?  Or if there's a
>    task_is_realtime() producer running on every CPU?  The flusher never
>    gets to run and we're dead?

Not some theoretical thing, btw.  See how __read_swap_cache_async()
just got its sins exposed by real-time tasks:
https://lkml.kernel.org/r/20220221111749.1928222-1-cgel.zte@gmail.com

