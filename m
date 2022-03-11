Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A0D4D65A1
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 17:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350082AbiCKQCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 11:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350102AbiCKQB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 11:01:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEAC1CCB02;
        Fri, 11 Mar 2022 08:00:54 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1B6B621106;
        Fri, 11 Mar 2022 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647014453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAaUOGAe1srGHsWHBvn1FZ7QUyxX7XpJoMnIGqLANGo=;
        b=JC9r4EOT7aEN0yB8Qf9FysIjDt/Lfq9D5zM4Ke/NbM9uN/KN1uAZpE5K4BgUSbilo63d9z
        ht/QmX4FXDK1KjhUAtCwUayHbXzLF9H3rBvvtmdT+W0F37+q8YPjroPqnmmlYH+VtrjBi7
        QtXDY6i3jI+KGH0cCUUGI9NsJFBQN9M=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DE50513A89;
        Fri, 11 Mar 2022 16:00:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gxi4NTRyK2IjHwAAMHmgww
        (envelope-from <mkoutny@suse.com>); Fri, 11 Mar 2022 16:00:52 +0000
Date:   Fri, 11 Mar 2022 17:00:51 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Message-ID: <20220311160051.GA24796@blackbody.suse.cz>
References: <20220304184040.1304781-1-shakeelb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220304184040.1304781-1-shakeelb@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

TL;DR rstats are slow but accurate on reader side. To tackle the
performance regression no flush seems simpler than this patch.


So, I've made an overview for myself what were the relevant changes with
rstat introduction.
The amount of work is:
- before
  R: O(1)
  W: O(tree_depth)

- after
  R: O(nr_cpus * nr_cgroups(subtree) * nr_counters) 
  W: O(tree_depth)

That doesn't look like a positive change especially on the reader side.

(In theory, the reader's work would be amortized but as the original
report here shows, not all workloads are diluting the flushes
sufficiently. [1])

The benefit this was traded for was the greater accuracy, the possible
error is:
- before
  - O(nr_cpus * nr_cgroups(subtree) * MEMCG_CHARGE_BATCH)	(1)
- after
    O(nr_cpus * MEMCG_CHARGE_BATCH) // sync. flush
    or
    O(flush_period * max_cr) // periodic flush only		(2)
                             // max_cr is per-counter max change rate

So we could argue that if the pre-rstat kernels did just fine with the
error (1), they would not be worse with periodic flush if we can compare
(1) and (2). 

On Fri, Mar 04, 2022 at 06:40:40PM +0000, Shakeel Butt <shakeelb@google.com> wrote:
> This patch fixes this regression by making the rstat flushing
> conditional in the performance critical codepaths. More specifically,
> the kernel relies on the async periodic rstat flusher to flush the stats
> and only if the periodic flusher is delayed by more than twice the
> amount of its normal time window then the kernel allows rstat flushing
> from the performance critical codepaths.

I'm not sure whether your patch attempts to solve the problem of
(a) periodic flush getting stuck or (b) limiting error on refault path.
If it's (a), it should be tackled more systematically (dedicated wq?).
If it's (b), why not just rely on periodic flush (self answer: (1) and
(2) comparison is workload dependent).

> Now the question: what are the side-effects of this change? The worst
> that can happen is the refault codepath will see 4sec old lruvec stats
> and may cause false (or missed) activations of the refaulted page which
> may under-or-overestimate the workingset size. Though that is not very
> concerning as the kernel can already miss or do false activations.

We can't argue what's the effect of periodic only flushing so this
newly introduced factor would inherit that too. I find it superfluous.


Michal

[1] This is worth looking at in more detail.

From the flush condition we have
  cr * Δt = nr_cpus * MEMCG_CHARGE_BATCH 
where Δt is time between flushes and cr is global change rate.

cr composes of all updates together (corresponds to stats_updates in
memcg_rstat_updated(), max_cr is change rate per counter)
  cr = Σ cr_i <= nr_counters * max_cr 

By combining these two we get shortest time between flushes:
  cr * Δt <= nr_counters * max_cr * Δt
  nr_cpus * MEMCG_CHARGE_BATCH <= nr_counters * max_cr * Δt
  Δt >= (nr_cpus * MEMCG_CHARGE_BATCH) / (nr_counters * max_cr)

We are interested in 
  R_amort = flush_work / Δt
which is
  R_amort <= flush_work * nr_counters * max_cr / (nr_cpus * MEMCG_CHARGE_BATCH)

R_amort: O( nr_cpus * nr_cgroups(subtree) * nr_counters * (nr_counters * max_cr) / (nr_cpus * MEMCG_CHARGE_BATCH) )
R_amort: O( nr_cgroups(subtree) * nr_counters^2 * max_cr) / (MEMCG_CHARGE_BATCH) )

The square looks interesting given there are already tens of counters.
(As data from Ivan have shown, we can hardly restore the pre-rstat
performance on the read side even with mere mod_delayed_work().)
This is what you partially solved with introduction of NR_MEMCG_EVENTS
but the stats_updates was still sum of all events, so the flush might
have still triggered too frequently.

Maybe that would be better long-term approach, splitting into accurate
and approximate counters and reflect that in the error estimator stats_updates.

Or some other optimization of mem_cgroup_css_rstat_flush().


