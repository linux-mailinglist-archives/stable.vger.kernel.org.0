Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D891E4CEFBC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 03:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiCGCpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 21:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbiCGCpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 21:45:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ADA5E178;
        Sun,  6 Mar 2022 18:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E51F3B80FA1;
        Mon,  7 Mar 2022 02:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCF9C340EC;
        Mon,  7 Mar 2022 02:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646621045;
        bh=fXrrtpJvgRp7AsWlaFX0EIrBU3vOypZe0/w7Wy6tFaw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yl3BC2AszB49zMZHwLObBmVoM7K4Jl5NAwLN0LcontcU6+PloRGpwxKbmoFAmASQj
         nil01KZFN6gYYCX2zEhBcI6kMloe1CybbviLAQBKoOkg5XN9rEbtCJknWmiocyWi5A
         D0VbwX/8Vvx4sLUsNXs5QUX9ruW6Do6QDnUJL25c=
Date:   Sun, 6 Mar 2022 18:44:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     =?ISO-8859-1?Q? "Michal_Koutn=FD" ?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Message-Id: <20220306184404.049447f8447d288fde34cabe@linux-foundation.org>
In-Reply-To: <20220304184040.1304781-1-shakeelb@google.com>
References: <20220304184040.1304781-1-shakeelb@google.com>
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

On Fri,  4 Mar 2022 18:40:40 +0000 Shakeel Butt <shakeelb@google.com> wrote:

> Daniel Dao has reported [1] a regression on workloads that may trigger
> a lot of refaults (anon and file). The underlying issue is that flushing
> rstat is expensive. Although rstat flush are batched with (nr_cpus *
> MEMCG_BATCH) stat updates, it seems like there are workloads which
> genuinely do stat updates larger than batch value within short amount of
> time. Since the rstat flush can happen in the performance critical
> codepaths like page faults, such workload can suffer greatly.
> 
> This patch fixes this regression by making the rstat flushing
> conditional in the performance critical codepaths. More specifically,
> the kernel relies on the async periodic rstat flusher to flush the stats
> and only if the periodic flusher is delayed by more than twice the
> amount of its normal time window then the kernel allows rstat flushing
> from the performance critical codepaths.
> 
> Now the question: what are the side-effects of this change? The worst
> that can happen is the refault codepath will see 4sec old lruvec stats
> and may cause false (or missed) activations of the refaulted page which
> may under-or-overestimate the workingset size. Though that is not very
> concerning as the kernel can already miss or do false activations.
> 
> There are two more codepaths whose flushing behavior is not changed by
> this patch and we may need to come to them in future. One is the
> writeback stats used by dirty throttling and second is the deactivation
> heuristic in the reclaim. For now keeping an eye on them and if there is
> report of regression due to these codepaths, we will reevaluate then.
> 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
>
> ...
>
> @@ -648,10 +652,16 @@ void mem_cgroup_flush_stats(void)
>  		__mem_cgroup_flush_stats();
>  }
>  
> +void mem_cgroup_flush_stats_delayed(void)
> +{
> +	if (rstat_flush_time && time_after64(jiffies_64, flush_next_time))

rstat_flush_time isn't defined for me and my googling indicates this is
the first time the symbol has been used in the history of the world. 
I'm stumped.

> +		mem_cgroup_flush_stats();
> +}
> +
>
> ...
>
