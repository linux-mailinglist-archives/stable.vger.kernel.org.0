Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F6C4C52C6
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbiBZA7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 19:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239387AbiBZA7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 19:59:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC69179A28;
        Fri, 25 Feb 2022 16:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56345CE27D8;
        Sat, 26 Feb 2022 00:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD25C340E7;
        Sat, 26 Feb 2022 00:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645837123;
        bh=7jPwtC/LdmlqEz69iDS2lkoVpynptg4SU3kS78wjJ68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FNSyEFmnICgX6UEvl7Wu3fgt3zLc9lRn+wQwfYO3ZFHGcFj0Tm7HvAngITqEdnO9R
         oG/CeNsDZvz5lj6xIDYfZQa1MaaE7B3vXsgFrdppQ755Rrva+OEKwsXHQr0zIiPWzz
         SzfnJMh87Ix34h4oB3OTLsO7HE5ZdJctfEvRYRuk=
Date:   Fri, 25 Feb 2022 16:58:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     =?ISO-8859-1?Q? "Michal_Koutn=FD" ?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Daniel Dao <dqminh@cloudflare.com>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Message-Id: <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
In-Reply-To: <20220226002412.113819-1-shakeelb@google.com>
References: <20220226002412.113819-1-shakeelb@google.com>
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

On Fri, 25 Feb 2022 16:24:12 -0800 Shakeel Butt <shakeelb@google.com> wrote:

> Daniel Dao has reported [1] a regression on workloads that may trigger
> a lot of refaults (anon and file). The underlying issue is that flushing
> rstat is expensive. Although rstat flush are batched with (nr_cpus *
> MEMCG_BATCH) stat updates, it seems like there are workloads which
> genuinely do stat updates larger than batch value within short amount of
> time. Since the rstat flush can happen in the performance critical
> codepaths like page faults, such workload can suffer greatly.
> 
> The easiest fix for now is for performance critical codepaths trigger
> the rstat flush asynchronously. This patch converts the refault codepath
> to use async rstat flush. In addition, this patch has premptively
> converted mem_cgroup_wb_stats and shrink_node to also use the async
> rstat flush as they may also similar performance regressions.

Gee we do this trick a lot and gee I don't like it :(

a) if we're doing too much work then we're doing too much work. 
   Punting that work over to a different CPU or thread doesn't alter
   that - it in fact adds more work.

b) there's an assumption here that the flusher is able to keep up
   with the producer.  What happens if that isn't the case?  Do we
   simply wind up the deferred items until the system goes oom?

   What happens if there's a producer running on each CPU?  Can the
   flushers keep up?

   Pathologically, what happens if the producer is running
   task_is_realtime() on a single-CPU system?  Or if there's a
   task_is_realtime() producer running on every CPU?  The flusher never
   gets to run and we're dead?


An obvious fix is to limit the permissible amount of windup (to what?)
and at some point, do the flushing synchronously anyway.

Or we just don't do any this at all and put up with the cost of the
current code.  I mean, this "fix" is kind of fake anyway, isn't it? 
Pushing the 4-10ms delay onto a different CPU will just disrupt
something else which wanted to run on that CPU.  The overall effect is
to hide the impact from one particular testcase, but is the benefit
really a real one?

