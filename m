Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607531B7B54
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDXQVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:21:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35541 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXQVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 12:21:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id x18so11571968wrq.2
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q0pJPiNahulzXjepW4Fsah9pOIeUNBqbsHnVMKibHTw=;
        b=FIxP63nANrrlqlvuduBTbJtIn/jDM8qtlDXjz26NhGuNw35+PA2LzNEZkyd6HwH3HA
         r3mMjOavh7KxNAh5NSSHQV9B4CRkNCf3syIQVgNVUQ5IeARJ/htS93YANUTVn1U8MNRl
         h18rhOVfixGZ15tew9bh5uhpGFRhrHSCXvbGZrePwEXSAVY9MZ8ec+HNTUUAS0nsFlTE
         1ZUm6XfInCSQjYNnx0T+9W6SXYq8DCD0kAbUF79UxOaaPMy3JzULUHpDO5xN4OifFnSs
         bZ4tXTpGPBtC3Cgq2Qlibmf0AmHdq7z6wDARCG9BeJXHtZzswrcHSqYre7lWcxY8Yf5l
         Ol7g==
X-Gm-Message-State: AGi0Pub3QtDrdwCafvGcJwHakqbVasDnr14mVZCIpHlJF8Iyt1A9uHnT
        JyZXJAJ/JbRTPZYOjdW9wGk=
X-Google-Smtp-Source: APiQypJ27Vk63KNaOL2/qa5F5TtZbSWQUXj0MofRfX8qGY/2+/C3iSSnS4Z0g2l7Zh6htzuVY4e3cQ==
X-Received: by 2002:adf:db4d:: with SMTP id f13mr11434693wrj.289.1587745265085;
        Fri, 24 Apr 2020 09:21:05 -0700 (PDT)
Received: from localhost (ip-37-188-130-62.eurotel.cz. [37.188.130.62])
        by smtp.gmail.com with ESMTPSA id z76sm4035330wmc.9.2020.04.24.09.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 09:21:04 -0700 (PDT)
Date:   Fri, 24 Apr 2020 18:21:03 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424162103.GK11591@dhcp22.suse.cz>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz>
 <20200424151013.GA525165@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424151013.GA525165@cmpxchg.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-04-20 11:10:13, Johannes Weiner wrote:
> On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> > On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > > This patch is an improvement of a previous version[1], as the previous
> > > > version is not easy to understand.
> > > > This issue persists in the newest kernel, I have to resend the fix. As
> > > > the implementation is changed, I drop Roman's ack from the previous
> > > > version.
> > > 
> > > Now that I understand the problem, I much prefer the previous version.
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 745697906ce3..2bf91ae1e640 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> > >  
> > >  	if (!root)
> > >  		root = root_mem_cgroup;
> > > -	if (memcg == root)
> > > +	if (memcg == root) {
> > > +		/*
> > > +		 * The cgroup is the reclaim root in this reclaim
> > > +		 * cycle, and therefore not protected. But it may have
> > > +		 * stale effective protection values from previous
> > > +		 * cycles in which it was not the reclaim root - for
> > > +		 * example, global reclaim followed by limit reclaim.
> > > +		 * Reset these values for mem_cgroup_protection().
> > > +		 */
> > > +		memcg->memory.emin = 0;
> > > +		memcg->memory.elow = 0;
> > >  		return MEMCG_PROT_NONE;
> > > +	}
> > 
> > Could you be more specific why you prefer this over the
> > mem_cgroup_protection which doesn't change the effective value?
> > Isn't it easier to simply ignore effective value for the reclaim roots?
> 
> Because now both mem_cgroup_protection() and mem_cgroup_protected()
> have to know about the reclaim root semantics, instead of just the one
> central place.

Yes this is true but it is also potentially overwriting the state with
a parallel reclaim which can lead to surprising results beacause
parent's effective protection is used to define protection distribution
for children. Let's have global and A's reclaim in parallel:
 |
 A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
 |\
 | C (low = 1G, usage = 2.5G)
 B (low = 1G, usage = 0.5G)

for A reclaim we have
B.elow = B.low
C.elow = C.low

For the global reclaim
A.elow = A.low
B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
C.elow = min(C.usage, C.low)

With the effective values reseting we have A reclaim
A.elow = 0
B.elow = B.low
C.elow = C.low
[...]

and global reclaim could see the above and then
B.elow = C.elow = 0 because children_low_usage > A.elow

> And the query function has to know additional rules about when the
> emin/elow values are uptodate or it could silently be looking at stale
> data, which isn't very robust.
> 
> "The effective protection values are uptodate after calling
> mem_cgroup_protected() inside the reclaim cycle - UNLESS the group
> you're looking at happens to be..."
> 
> It's much easier to make the rule: The values are uptodate after you
> called mem_cgroup_protected().
> 
> Or mem_cgroup_calculate_protection(), if we go with that later.
> 
> > > As others have noted, it's fairly hard to understand the problem from
> > > the above changelog. How about the following:
> > > 
> > > A cgroup can have both memory protection and a memory limit to isolate
> > > it from its siblings in both directions - for example, to prevent it
> > > from being shrunk below 2G under high pressure from outside, but also
> > > from growing beyond 4G under low pressure.
> > > 
> > > 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > > implemented proportional scan pressure so that multiple siblings in
> > > excess of their protection settings don't get reclaimed equally but
> > > instead in accordance to their unprotected portion.
> > > 
> > > During limit reclaim, this proportionality shouldn't apply of course:
> > > there is no competition, all pressure is from within the cgroup and
> > > should be applied as such. Reclaim should operate at full efficiency.
> > > 
> > > However, mem_cgroup_protected() never expected anybody to look at the
> > > effective protection values when it indicated that the cgroup is above
> > > its protection. As a result, a query during limit reclaim may return
> > > stale protection values that were calculated by a previous reclaim
> > > cycle in which the cgroup did have siblings.
> > 
> > This is better. Thanks!
> > 
> > > When this happens, reclaim is unnecessarily hesitant and potentially
> > > slow to meet the desired limit. In theory this could lead to premature
> > > OOM kills, although it's not obvious this has occurred in practice.
> > 
> > I do not see how this would lead all the way to OOM killer but it
> > certainly can lead to unnecessary increase of the reclaim priority. The
> > smaller the difference between the reclaim target and protection the
> > more visible the effect would be. But if there are reclaimable pages
> > then the reclaim should see them sooner or later
> 
> It would be a pretty extreme case, but not impossible AFAICS, because
> OOM is just a sampled state, not deterministic.
> 
> If memory.max is 64G and memory.low is 64G minus one page, this bug
> could cause limit reclaim to look at no more than SWAP_CLUSTER_MAX
> pages at priority 0. It's possible it wouldn't get through the full
> 64G worth of memory before giving up and declaring OOM.

Yes, my bad I didn't really realize that there won't be a full scan even
under priority 0.
-- 
Michal Hocko
SUSE Labs
