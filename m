Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5CF1B9A0F
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 10:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgD0IZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 04:25:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40312 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgD0IZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 04:25:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id u16so19406168wmc.5
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 01:25:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TQyaco5bENyFMyx3Y0RVnuBk45d45ZFKv2auSl9AsF8=;
        b=knyjXYLREbyeEAUEGOHXoJGM2NCip8FIe7keeIyku/mkCeD8MYfaDs7e4n4vhEptOx
         mNhPvy0kAgeCZEds2f6S9Fkiz2+wF60qk0JlaRBp870KmCX8pZad5oNV/dy6mq7UOVZY
         hd1GyITkn2pq4UNmElUjrbYl1fE4rYwgUadjntkouUCOC7NPSp1DjTCWLM1ltzGhdJ6D
         MWeXMeXSmTriM4eAHBRPaMiC5AdqUqMEP8ieQ9vUeI2NlV/h3J75F2A1CO1di1moZJ/n
         d4sH+JzeBbxhQG94u1Ns0UW+LNrmT007ceElfFoYNamAk8ZmYskxDSINlUgguK6bcvIl
         iyAA==
X-Gm-Message-State: AGi0Puawobn7Tmej4bUgl3NBZaRKbw5gBzm+Zk4r7xE77bh3WTiT6+cd
        bn+YX2GuIZB/16nvZ6zjzDY=
X-Google-Smtp-Source: APiQypIr+RDDNZwSOnL2p7gOVyxWakP6lr/+33/HW0PQcTL29I9oqhi8A/NdE6dVtS4ucmEX228MRw==
X-Received: by 2002:a7b:c927:: with SMTP id h7mr24570559wml.122.1587975926618;
        Mon, 27 Apr 2020 01:25:26 -0700 (PDT)
Received: from localhost (ip-37-188-130-62.eurotel.cz. [37.188.130.62])
        by smtp.gmail.com with ESMTPSA id x23sm14146541wmj.6.2020.04.27.01.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 01:25:25 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:25:24 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200427082524.GC28637@dhcp22.suse.cz>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz>
 <20200424151013.GA525165@cmpxchg.org>
 <20200424162103.GK11591@dhcp22.suse.cz>
 <20200424165103.GA575707@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424165103.GA575707@cmpxchg.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-04-20 12:51:03, Johannes Weiner wrote:
> On Fri, Apr 24, 2020 at 06:21:03PM +0200, Michal Hocko wrote:
> > On Fri 24-04-20 11:10:13, Johannes Weiner wrote:
> > > On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> > > > On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > > > > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > > > > This patch is an improvement of a previous version[1], as the previous
> > > > > > version is not easy to understand.
> > > > > > This issue persists in the newest kernel, I have to resend the fix. As
> > > > > > the implementation is changed, I drop Roman's ack from the previous
> > > > > > version.
> > > > > 
> > > > > Now that I understand the problem, I much prefer the previous version.
> > > > > 
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index 745697906ce3..2bf91ae1e640 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> > > > >  
> > > > >  	if (!root)
> > > > >  		root = root_mem_cgroup;
> > > > > -	if (memcg == root)
> > > > > +	if (memcg == root) {
> > > > > +		/*
> > > > > +		 * The cgroup is the reclaim root in this reclaim
> > > > > +		 * cycle, and therefore not protected. But it may have
> > > > > +		 * stale effective protection values from previous
> > > > > +		 * cycles in which it was not the reclaim root - for
> > > > > +		 * example, global reclaim followed by limit reclaim.
> > > > > +		 * Reset these values for mem_cgroup_protection().
> > > > > +		 */
> > > > > +		memcg->memory.emin = 0;
> > > > > +		memcg->memory.elow = 0;
> > > > >  		return MEMCG_PROT_NONE;
> > > > > +	}
> > > > 
> > > > Could you be more specific why you prefer this over the
> > > > mem_cgroup_protection which doesn't change the effective value?
> > > > Isn't it easier to simply ignore effective value for the reclaim roots?
> > > 
> > > Because now both mem_cgroup_protection() and mem_cgroup_protected()
> > > have to know about the reclaim root semantics, instead of just the one
> > > central place.
> > 
> > Yes this is true but it is also potentially overwriting the state with
> > a parallel reclaim which can lead to surprising results
> 
> Checking in mem_cgroup_protection() doesn't avoid the fundamental race:
> 
>   root
>      `- A (low=2G, elow=2G, max=3G)
>         `- A1 (low=2G, elow=2G)
> 
> If A does limit reclaim while global reclaim races, the memcg == root
> check in mem_cgroup_protection() will reliably calculate the "right"
> scan value for A, which has no pages, and the wrong scan value for A1
> where the memory actually is.

I am sorry but I do not see how A1 would get wrong scan value.
- Global reclaim
  - A.elow = 2G
  - A1.elow = min(A1.low, A1.usage) ; if (A.children_low_usage < A.elow)

- A reclaim.
  - A.elow = stale/undefined
  - A1.elow = A1.low

if mem_cgroup_protection returns 0 for A's reclaim targeting A (assuming
the check is there) then not a big deal as there are no pages there as
you say.

Let's compare the GR (global reclaim), AR (A reclaim).
GR(A1.elow) <= AR(A1.elow) by definition, right? For A1.low
overcommitted we have
min(A1.low, A1.usage) * A.elow / A.children_low_usage <= min(A1.low, A1.usage)
because A.elow <= A.children_low_usage

so in both cases we have GR(A1.elow) <= AR(A1.elow) which means that
racing reclaims will behave sanely because the protection for the
external pressure pressure is not violated. A is going to reclaim A1
less than the global reclaim but that should be OK.

Or what do I miss?

> I'm okay with fixing the case where a really old left-over value is
> used by target reclaim.
> 
> I don't see a point in special casing this one instance of a
> fundamental race condition at the expense of less robust code.

I am definitely not calling to fragment the code. I do agree that having
a special case in mem_cgroup_protection is quite non-intuitive.
The existing code is quite hard to reason about in its current form
as we can see. If we can fix all that in mem_cgroup_protected then no
objections from me at all.

-- 
Michal Hocko
SUSE Labs
