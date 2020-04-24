Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2AD1B7C2F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgDXQvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXQvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 12:51:06 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BB2C09B046
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:51:05 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k12so8466270qtm.4
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LLWgRgBeL6u7CTZehG2n8AGRFKAbzykj38v03B4IxgI=;
        b=cLqfDo0zDUyTc3G0cD2LyHxwDW6bhH8PIG39B1OGCcaNDjr+nFiZXz/ZCrjWOOAmxy
         NgumJZEK575/8193aDuOzuyWwQ1pAg9I985PLlTjaW4rBesVNscQc5PB3JoLaOOKL2Xw
         X5rKIUJ9UL6ShRxq0EgY70/nOW56yyvqzymPPDH7S/W2cx00wzRCYFI1RuT3p6xoWlKq
         h5l8D0YjARMDMxm/CPmQetAGNmJ0ZOGMC5nuWSBdQjZJNYjUosy1oVPWhjEGinqgsPqj
         PxMzH83KBmgUN9DkB/3wSaCuqntzi5vVGDEqca/9h8oV7RKUA0pOWPw8SST5BqaAVgGB
         hlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LLWgRgBeL6u7CTZehG2n8AGRFKAbzykj38v03B4IxgI=;
        b=Dbw1y6EL4fFCE7LO62YmzL/d2dzpg/JeAjfo5X+WwE4aGEYt4tmx8BuVk22DK4i460
         ttUsXTHCYa8JuB5NQyeb7EYZiBHDFNVXy0NNfStv9zK4RWWaLI1NB/fbDy5Jkp8xggVN
         dOy2DcUvaWIRc4SA+OflUAlb5tnDD/mmd/KQmL9GYkmfOTNaHequUuh4aZJq4HpvYwIJ
         FCQWCSv7YYIJxBa4a7P7p+6aQawlkfb2qseWwms3vgYEkj8MJTaZCHgoA6OC0YAACaXx
         0prfF5/YRFwX8V4y56rrXaTyiWP8CImKC/KPlZwV6X1mbvda0pvibc28NVWy/4SdZ16Y
         +HYQ==
X-Gm-Message-State: AGi0PuZ+wCGVWEtpF9616HB+VOBzaxhx2xQ/Zud6l7vv6CPOoN+r916W
        5qlRXLlJsgflnx4cWIHKHocVBA==
X-Google-Smtp-Source: APiQypLYX8tycLPSQbBePM3tGAGwiQADl6QX/fJ1sGqHE6YRqJ2vJqRkXUxRK3KRg738BARfBcwvsQ==
X-Received: by 2002:ac8:3421:: with SMTP id u30mr10737775qtb.303.1587747065043;
        Fri, 24 Apr 2020 09:51:05 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::921])
        by smtp.gmail.com with ESMTPSA id l9sm4177675qth.60.2020.04.24.09.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 09:51:04 -0700 (PDT)
Date:   Fri, 24 Apr 2020 12:51:03 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424165103.GA575707@cmpxchg.org>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz>
 <20200424151013.GA525165@cmpxchg.org>
 <20200424162103.GK11591@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424162103.GK11591@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 06:21:03PM +0200, Michal Hocko wrote:
> On Fri 24-04-20 11:10:13, Johannes Weiner wrote:
> > On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> > > On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > > > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > > > This patch is an improvement of a previous version[1], as the previous
> > > > > version is not easy to understand.
> > > > > This issue persists in the newest kernel, I have to resend the fix. As
> > > > > the implementation is changed, I drop Roman's ack from the previous
> > > > > version.
> > > > 
> > > > Now that I understand the problem, I much prefer the previous version.
> > > > 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 745697906ce3..2bf91ae1e640 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> > > >  
> > > >  	if (!root)
> > > >  		root = root_mem_cgroup;
> > > > -	if (memcg == root)
> > > > +	if (memcg == root) {
> > > > +		/*
> > > > +		 * The cgroup is the reclaim root in this reclaim
> > > > +		 * cycle, and therefore not protected. But it may have
> > > > +		 * stale effective protection values from previous
> > > > +		 * cycles in which it was not the reclaim root - for
> > > > +		 * example, global reclaim followed by limit reclaim.
> > > > +		 * Reset these values for mem_cgroup_protection().
> > > > +		 */
> > > > +		memcg->memory.emin = 0;
> > > > +		memcg->memory.elow = 0;
> > > >  		return MEMCG_PROT_NONE;
> > > > +	}
> > > 
> > > Could you be more specific why you prefer this over the
> > > mem_cgroup_protection which doesn't change the effective value?
> > > Isn't it easier to simply ignore effective value for the reclaim roots?
> > 
> > Because now both mem_cgroup_protection() and mem_cgroup_protected()
> > have to know about the reclaim root semantics, instead of just the one
> > central place.
> 
> Yes this is true but it is also potentially overwriting the state with
> a parallel reclaim which can lead to surprising results

Checking in mem_cgroup_protection() doesn't avoid the fundamental race:

  root
     `- A (low=2G, elow=2G, max=3G)
        `- A1 (low=2G, elow=2G)

If A does limit reclaim while global reclaim races, the memcg == root
check in mem_cgroup_protection() will reliably calculate the "right"
scan value for A, which has no pages, and the wrong scan value for A1
where the memory actually is.

I'm okay with fixing the case where a really old left-over value is
used by target reclaim.

I don't see a point in special casing this one instance of a
fundamental race condition at the expense of less robust code.
