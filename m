Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F371B7851
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgDXOaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 10:30:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45266 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgDXOaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 10:30:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id t14so11071710wrw.12
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 07:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ntRosrtUKhnfwwIu0YTV0WuFJr742CEVYmDb3JkguhE=;
        b=mN6/NQ/CRLZ7gepiuVuMjUmZzCH1nzZi6BmWUH1ldxEgFRKgd3F695tR0ZXue4rHFZ
         nKye7CC1TIHO43H1TKBLPxx+J207QovOBjE0vb/9SS2UJH25skZBOKJYD/ZSg669qR1J
         o7aw+dQ1CATifUs2PXUfdbKuASyWSSwTTUSg2fgLqZHtxQXWtT8UEHPw3FYjj0uZQsBu
         qDzjCmMha5CQclus9961oBvtfGKUb77eLQi7X3p5OZcNxAmZ6R8BVER4HwXOkXz3PyYe
         HAXgpH/CdSNSV4CBgyAje7n7JQ5pXveMA2p8kYGlHnCmDVB6qJHZjYeArnwHzeULWpUR
         GUcQ==
X-Gm-Message-State: AGi0PuYDuHU9Ab7nxpp6VrrRcKM0Vvr5cHCJKKRNl4ZsMxa+YLS9rVmc
        STdPvgx4+YxTENbjofTFuwk=
X-Google-Smtp-Source: APiQypJ3pqDVjIF8e+Mn3n8/qqL5ElDYO9BH3pM78N8PJvM/S6XJVgoTNryAh6vTE8AAdAtPlkeIDw==
X-Received: by 2002:adf:f604:: with SMTP id t4mr11588389wrp.399.1587738601165;
        Fri, 24 Apr 2020 07:30:01 -0700 (PDT)
Received: from localhost (ip-37-188-130-62.eurotel.cz. [37.188.130.62])
        by smtp.gmail.com with ESMTPSA id f23sm3061719wml.4.2020.04.24.07.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:30:00 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:29:58 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424142958.GF11591@dhcp22.suse.cz>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424131450.GA495720@cmpxchg.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > This patch is an improvement of a previous version[1], as the previous
> > version is not easy to understand.
> > This issue persists in the newest kernel, I have to resend the fix. As
> > the implementation is changed, I drop Roman's ack from the previous
> > version.
> 
> Now that I understand the problem, I much prefer the previous version.
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 745697906ce3..2bf91ae1e640 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  
>  	if (!root)
>  		root = root_mem_cgroup;
> -	if (memcg == root)
> +	if (memcg == root) {
> +		/*
> +		 * The cgroup is the reclaim root in this reclaim
> +		 * cycle, and therefore not protected. But it may have
> +		 * stale effective protection values from previous
> +		 * cycles in which it was not the reclaim root - for
> +		 * example, global reclaim followed by limit reclaim.
> +		 * Reset these values for mem_cgroup_protection().
> +		 */
> +		memcg->memory.emin = 0;
> +		memcg->memory.elow = 0;
>  		return MEMCG_PROT_NONE;
> +	}

Could you be more specific why you prefer this over the
mem_cgroup_protection which doesn't change the effective value?
Isn't it easier to simply ignore effective value for the reclaim roots?

[...]

> As others have noted, it's fairly hard to understand the problem from
> the above changelog. How about the following:
> 
> A cgroup can have both memory protection and a memory limit to isolate
> it from its siblings in both directions - for example, to prevent it
> from being shrunk below 2G under high pressure from outside, but also
> from growing beyond 4G under low pressure.
> 
> 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> implemented proportional scan pressure so that multiple siblings in
> excess of their protection settings don't get reclaimed equally but
> instead in accordance to their unprotected portion.
> 
> During limit reclaim, this proportionality shouldn't apply of course:
> there is no competition, all pressure is from within the cgroup and
> should be applied as such. Reclaim should operate at full efficiency.
> 
> However, mem_cgroup_protected() never expected anybody to look at the
> effective protection values when it indicated that the cgroup is above
> its protection. As a result, a query during limit reclaim may return
> stale protection values that were calculated by a previous reclaim
> cycle in which the cgroup did have siblings.

This is better. Thanks!

> When this happens, reclaim is unnecessarily hesitant and potentially
> slow to meet the desired limit. In theory this could lead to premature
> OOM kills, although it's not obvious this has occurred in practice.

I do not see how this would lead all the way to OOM killer but it
certainly can lead to unnecessary increase of the reclaim priority. The
smaller the difference between the reclaim target and protection the
more visible the effect would be. But if there are reclaimable pages
then the reclaim should see them sooner or later
-- 
Michal Hocko
SUSE Labs
