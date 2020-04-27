Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8107B1BAA72
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgD0QwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgD0QwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 12:52:25 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B400C0610D5
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 09:52:25 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id y19so8854229qvv.4
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 09:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uHH5G3ygpt6fz1ZtSnotHqjI9vLZ9l9n/xiOJEspxzY=;
        b=e6G34f8uAPYUx2k2uaAuy4SLcrPrsnbqi2o0P3Dh+KDsHJE+ILdHRQt/MuYWJj6I9x
         9HS629s5ypPl0MtGgXwjCGdlAgNAJQRWV1Ci94LeqkhTRdn4Jjl/eNwOHJzSY2DEsCSN
         1h25RYEyTPWPnfyOJA750nfLCYaGATl6uqqu6k4uJhJqWcmhY+qyr2QpWt3SFyqmHOqq
         Xgf7teNPnBseBh+PUmkvywabwOzBWELdQNQya15Yvo9Tssuyr3OMrUUD+XENqrEwlaW+
         XqvzG5eCdMZzoSUdFMuCw7xBFy4WuNclZAY/gYdpI2r2JxR4HlcUqofWZfq/pYl7UrF4
         RNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uHH5G3ygpt6fz1ZtSnotHqjI9vLZ9l9n/xiOJEspxzY=;
        b=r8fNqlaSQYl3Pj/qFm6gyoh1ydwIOVJlo5AcsCRRbTstgHr5FhJtN6K+CHgqXMyWEV
         8hjtjyIR1MqxDBcK7Hn6kxgcWVY9fsN6YWxM7IBrrFzByStvXT+lSiTjbTV6o53vmch/
         6b2mtqHzKNqGz3lPtqFLUFRte6SCB1Ob7S0DSecZ5E//Mc+Ine98qofkeuVf2KDxos97
         8NRSmkI5AQKP0opp+5lhTI2ErUYNIA4h/94eX7APOu+443B3eQ1+K3hf+q+U+YHUn9lw
         1waERkK6pvZVIw+vvh0mmYoZhLhrJMQMlnverny48lNjAeGvmdKI5nqz3Abm9RqVsL7q
         xgxQ==
X-Gm-Message-State: AGi0PubRuj4XkgclhMPvsnyS1G7NH6M0lt1hWfPKVg7ChPgvu+WZI4Jt
        pK96EdqDJV1kytvwfT03MyIcVg==
X-Google-Smtp-Source: APiQypKGzBwVtw111Fx8k0Vex9YZnDP8gqisd4acj6TYO6vBc0sd7275uVf5RW7gJI6oezZlh3xKxA==
X-Received: by 2002:a0c:e305:: with SMTP id s5mr23797736qvl.234.1588006344115;
        Mon, 27 Apr 2020 09:52:24 -0700 (PDT)
Received: from localhost (70.44.39.90.res-cmts.bus.ptd.net. [70.44.39.90])
        by smtp.gmail.com with ESMTPSA id q27sm11109873qkn.7.2020.04.27.09.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 09:52:23 -0700 (PDT)
Date:   Mon, 27 Apr 2020 12:52:12 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200427165212.GA29022@cmpxchg.org>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz>
 <20200424151013.GA525165@cmpxchg.org>
 <20200424162103.GK11591@dhcp22.suse.cz>
 <20200424165103.GA575707@cmpxchg.org>
 <20200427082524.GC28637@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427082524.GC28637@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 27, 2020 at 10:25:24AM +0200, Michal Hocko wrote:
> On Fri 24-04-20 12:51:03, Johannes Weiner wrote:
> > On Fri, Apr 24, 2020 at 06:21:03PM +0200, Michal Hocko wrote:
> > > On Fri 24-04-20 11:10:13, Johannes Weiner wrote:
> > > > On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> > > > > On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > > > > > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > > > > > This patch is an improvement of a previous version[1], as the previous
> > > > > > > version is not easy to understand.
> > > > > > > This issue persists in the newest kernel, I have to resend the fix. As
> > > > > > > the implementation is changed, I drop Roman's ack from the previous
> > > > > > > version.
> > > > > > 
> > > > > > Now that I understand the problem, I much prefer the previous version.
> > > > > > 
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index 745697906ce3..2bf91ae1e640 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> > > > > >  
> > > > > >  	if (!root)
> > > > > >  		root = root_mem_cgroup;
> > > > > > -	if (memcg == root)
> > > > > > +	if (memcg == root) {
> > > > > > +		/*
> > > > > > +		 * The cgroup is the reclaim root in this reclaim
> > > > > > +		 * cycle, and therefore not protected. But it may have
> > > > > > +		 * stale effective protection values from previous
> > > > > > +		 * cycles in which it was not the reclaim root - for
> > > > > > +		 * example, global reclaim followed by limit reclaim.
> > > > > > +		 * Reset these values for mem_cgroup_protection().
> > > > > > +		 */
> > > > > > +		memcg->memory.emin = 0;
> > > > > > +		memcg->memory.elow = 0;
> > > > > >  		return MEMCG_PROT_NONE;
> > > > > > +	}
> > > > > 
> > > > > Could you be more specific why you prefer this over the
> > > > > mem_cgroup_protection which doesn't change the effective value?
> > > > > Isn't it easier to simply ignore effective value for the reclaim roots?
> > > > 
> > > > Because now both mem_cgroup_protection() and mem_cgroup_protected()
> > > > have to know about the reclaim root semantics, instead of just the one
> > > > central place.
> > > 
> > > Yes this is true but it is also potentially overwriting the state with
> > > a parallel reclaim which can lead to surprising results
> > 
> > Checking in mem_cgroup_protection() doesn't avoid the fundamental race:
> > 
> >   root
> >      `- A (low=2G, elow=2G, max=3G)
> >         `- A1 (low=2G, elow=2G)
> > 
> > If A does limit reclaim while global reclaim races, the memcg == root
> > check in mem_cgroup_protection() will reliably calculate the "right"
> > scan value for A, which has no pages, and the wrong scan value for A1
> > where the memory actually is.
> 
> I am sorry but I do not see how A1 would get wrong scan value.

I mistyped the example. If we're in limit reclaim in A, elow should
look like this:

  root
     `- A (low=2G, max=3G -> elow=0)
        `- A1 (low=0G -> elow=0)

But if global reclaim were to kick in, it could overwrite elow to
this:

  root
     `- A (low=2G, max=3G -> elow=2G)
        `- A1 (low=0G -> elow=2G)

(This is with the recursive memory.low semantics, of course.)

> > I'm okay with fixing the case where a really old left-over value is
> > used by target reclaim.
> > 
> > I don't see a point in special casing this one instance of a
> > fundamental race condition at the expense of less robust code.
> 
> I am definitely not calling to fragment the code. I do agree that having
> a special case in mem_cgroup_protection is quite non-intuitive.
> The existing code is quite hard to reason about in its current form
> as we can see. If we can fix all that in mem_cgroup_protected then no
> objections from me at all.

Agreed, sounds reasonable.
