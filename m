Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF241B78F1
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgDXPKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726806AbgDXPKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 11:10:18 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49D7C09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 08:10:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id h26so7839602qtu.8
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 08:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B9LE4V62b+cl1uM2lXnBQgFoXmc3f50PCV4zSuqYtEw=;
        b=w3NpaQ4lXPGVQ3dv+rlCgbup7I62krVchcohKzSTijMkXIsxdKsTj0gfgJQimpfjLv
         mSBtIgvQCGMPBIGFrJCQ1eQxWbHFuJG+LWsFK2a7GfTDHXwH9QGZ+rTZid3JBw0s/rz1
         fzkqA3uk8+Dwd7FzNHT2i+qiWAbb1Vex+jnUUdC4BUHVB4OvW2XyvkppKaU+yl+OQK++
         p8nJb8FmTX8pnG8AV9UgSXCEp4MCBpZliJu26Bq50rNaESfzHmp29Zq4kbAncTWCRIda
         z3fPX0RdaiLnvTYL72A8CQlRjuzLu/ERQCUIF/l+lerJ69SlhuobDLX7svcq0Jmfc0Bh
         sPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B9LE4V62b+cl1uM2lXnBQgFoXmc3f50PCV4zSuqYtEw=;
        b=TztkZatI/LGkNMYPnDaEp8lg6Y0tVFBOFE2mJmTRmAv3CUJfN8pfVWqw2qV2RUqICT
         cqIrDQuMhvhmTwASrnm5OYcGSp54k3zUn7edOZ61WnK20iCiZgtjwGYd7Pv/oTl0N8Z2
         7JjFs0zez93sJtN9jg2scIjpCkyB03NBL6W46Kcgad3qMM5LE2aZdXzzg45pVdxh3DhC
         5ATIPOWH/aZk+/h5Y4HRzzDj/VYQ061laSe87aUnX3Ftyjl7+E9tfEhcTJSqoLcapQxl
         Nasso38M/2KSGDEProp8xJ0lYedB/BU0FHHOFBiHUuO1Iqua11AvERNSSF4zmnVJC40M
         sPmQ==
X-Gm-Message-State: AGi0PuYFrjTNfOH8S0Bpi2pQthXl7CybAEBZcqr0BZvhBMc33a0EP+Mi
        oJqNqIxA3kGafnVTuu/6Kdo16EEhkJo=
X-Google-Smtp-Source: APiQypKhsllylConDKMnH0wr4qa/70n99l9H7GgK2dnOIJMqwO/P5QWRP0AX55zY5EnDz0x36Z+crQ==
X-Received: by 2002:ac8:4e81:: with SMTP id 1mr9766772qtp.58.1587741016960;
        Fri, 24 Apr 2020 08:10:16 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::921])
        by smtp.gmail.com with ESMTPSA id t15sm4222036qtc.64.2020.04.24.08.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 08:10:14 -0700 (PDT)
Date:   Fri, 24 Apr 2020 11:10:13 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424151013.GA525165@cmpxchg.org>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424142958.GF11591@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > This patch is an improvement of a previous version[1], as the previous
> > > version is not easy to understand.
> > > This issue persists in the newest kernel, I have to resend the fix. As
> > > the implementation is changed, I drop Roman's ack from the previous
> > > version.
> > 
> > Now that I understand the problem, I much prefer the previous version.
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 745697906ce3..2bf91ae1e640 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> >  
> >  	if (!root)
> >  		root = root_mem_cgroup;
> > -	if (memcg == root)
> > +	if (memcg == root) {
> > +		/*
> > +		 * The cgroup is the reclaim root in this reclaim
> > +		 * cycle, and therefore not protected. But it may have
> > +		 * stale effective protection values from previous
> > +		 * cycles in which it was not the reclaim root - for
> > +		 * example, global reclaim followed by limit reclaim.
> > +		 * Reset these values for mem_cgroup_protection().
> > +		 */
> > +		memcg->memory.emin = 0;
> > +		memcg->memory.elow = 0;
> >  		return MEMCG_PROT_NONE;
> > +	}
> 
> Could you be more specific why you prefer this over the
> mem_cgroup_protection which doesn't change the effective value?
> Isn't it easier to simply ignore effective value for the reclaim roots?

Because now both mem_cgroup_protection() and mem_cgroup_protected()
have to know about the reclaim root semantics, instead of just the one
central place.

And the query function has to know additional rules about when the
emin/elow values are uptodate or it could silently be looking at stale
data, which isn't very robust.

"The effective protection values are uptodate after calling
mem_cgroup_protected() inside the reclaim cycle - UNLESS the group
you're looking at happens to be..."

It's much easier to make the rule: The values are uptodate after you
called mem_cgroup_protected().

Or mem_cgroup_calculate_protection(), if we go with that later.

> > As others have noted, it's fairly hard to understand the problem from
> > the above changelog. How about the following:
> > 
> > A cgroup can have both memory protection and a memory limit to isolate
> > it from its siblings in both directions - for example, to prevent it
> > from being shrunk below 2G under high pressure from outside, but also
> > from growing beyond 4G under low pressure.
> > 
> > 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > implemented proportional scan pressure so that multiple siblings in
> > excess of their protection settings don't get reclaimed equally but
> > instead in accordance to their unprotected portion.
> > 
> > During limit reclaim, this proportionality shouldn't apply of course:
> > there is no competition, all pressure is from within the cgroup and
> > should be applied as such. Reclaim should operate at full efficiency.
> > 
> > However, mem_cgroup_protected() never expected anybody to look at the
> > effective protection values when it indicated that the cgroup is above
> > its protection. As a result, a query during limit reclaim may return
> > stale protection values that were calculated by a previous reclaim
> > cycle in which the cgroup did have siblings.
> 
> This is better. Thanks!
> 
> > When this happens, reclaim is unnecessarily hesitant and potentially
> > slow to meet the desired limit. In theory this could lead to premature
> > OOM kills, although it's not obvious this has occurred in practice.
> 
> I do not see how this would lead all the way to OOM killer but it
> certainly can lead to unnecessary increase of the reclaim priority. The
> smaller the difference between the reclaim target and protection the
> more visible the effect would be. But if there are reclaimable pages
> then the reclaim should see them sooner or later

It would be a pretty extreme case, but not impossible AFAICS, because
OOM is just a sampled state, not deterministic.

If memory.max is 64G and memory.low is 64G minus one page, this bug
could cause limit reclaim to look at no more than SWAP_CLUSTER_MAX
pages at priority 0. It's possible it wouldn't get through the full
64G worth of memory before giving up and declaring OOM.

Not that that would be a sensical configuration... My point is that
OOM is defined as "I've looked at X pages and found nothing" and this
bug can significantly lower X.
