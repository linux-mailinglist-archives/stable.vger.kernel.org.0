Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6F34C8756
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiCAJGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiCAJGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:06:19 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290C289319;
        Tue,  1 Mar 2022 01:05:38 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B84BD21637;
        Tue,  1 Mar 2022 09:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646125536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wGg057MYVvEAycP3sfZdyFUbrSVStkSu0yUPk3uN7Bk=;
        b=PJoZmxdWQDxzOd6JDIbAkU3p3tENb3df9iSpKNeHZYe93Q99vfTMJarHj+aETJi22OlE5Q
        efK+c6N9PbE136rXo1pky4rH41gSHXh2m7J9RwIyMmRpO8MczpWn87pP2o6nC4Fl5P54lt
        Me2wF3cUpDucfbZcglIKYCU5DXTsEoQ=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 76159A3B88;
        Tue,  1 Mar 2022 09:05:36 +0000 (UTC)
Date:   Tue, 1 Mar 2022 10:05:35 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Message-ID: <Yh3h33W45+YaMo92@dhcp22.suse.cz>
References: <20220226002412.113819-1-shakeelb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226002412.113819-1-shakeelb@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 25-02-22 16:24:12, Shakeel Butt wrote:
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

Why do we need to trigger flushing in the first place from those paths.
Later in the thread you are saying there is a regular flushing done
every 2 seconds. What would happen if these paths didn't flush at all?
Also please note that WQ context can be overwhelmed by other work so
these flushes can happen much much later.

So in other words why does async work (that can happen at any time
without any control) make more sense than no flushing?
-- 
Michal Hocko
SUSE Labs
