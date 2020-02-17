Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A54160E6D
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 10:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgBQJZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 04:25:03 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54776 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbgBQJZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 04:25:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so16332754wmh.4
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 01:25:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sviw8dRFEvqwbGMvB0nhSjFBP5YFChvKzAllALvrn/8=;
        b=mjuZZqexDuuivuHNQxxuXWu8ZXnqHfjP3k7yPZ2wGPeFLhloSjjfUT5HwwGrSgThQK
         KwRLPjDkKwnJLsM0FYC0EDth5QZPXycvBa7OX9UFJiW5hOODfAQove9genppXleuYBcS
         ye0spMkBRV9HtapNp0De9+kZHdg97glUUInFFZwtT8lAYGZ2d3IvPcsJovHEMrPIItvt
         yZuEGczl88bZ5WKFhRzBZQO4qI/EDZH5pV9iUJSHcaIuZgLeNoBihJ+UaCZLTSgSTQsP
         ReQ6Y3Q/+VmrmXkMLxCGAoA1I6iqvKVvEQ/JGeqpod1uhtvzXDn+VIvTP1/PQhJeGYXI
         nfeg==
X-Gm-Message-State: APjAAAWHpneD6yGtHo0THUjD5NEh17gg9VE0joIaDdGrPT13voBdl52h
        lM2V1E78o6V86EK75Fo0q6U=
X-Google-Smtp-Source: APXvYqwdIa0b6Lx/2uaoX0r0LQh1uykC6Fe/2uKI4y1KtvHUfM0fbT67AoSxKEsrQEiaqMoif0nHfQ==
X-Received: by 2002:a7b:c652:: with SMTP id q18mr20789818wmk.123.1581931501174;
        Mon, 17 Feb 2020 01:25:01 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id f127sm19503365wma.4.2020.02.17.01.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 01:25:00 -0800 (PST)
Date:   Mon, 17 Feb 2020 10:24:59 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     guro@fb.com, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, chris@chrisdown.name,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
Message-ID: <20200217092459.GG31531@dhcp22.suse.cz>
References: <20200216145249.6900-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200216145249.6900-1-laoar.shao@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> them won't be changed until next recalculation in this function. After
> either or both of them are set, the next reclaimer to relcaim this memcg
> may be a different reclaimer, e.g. this memcg is also the root memcg of
> the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> the old values of them will be used to calculate scan count, that is not
> proper. We should reset them to zero in this case.
> 
> Here's an example of this issue.
> 
>     root_mem_cgroup
>          /
>         A   memory.max=1024M memory.min=512M memory.current=800M
> 
> Once kswapd is waked up, it will try to scan all MEMCGs, including
> this A, and it will assign memory.emin of A with 512M.
> After that, A may reach its hard limit(memory.max), and then it will
> do memcg reclaim. Because A is the root of this reclaimer, so it will
> not calculate its memory.emin. So the memory.emin is the old value
> 512M, and then this old value will be used in
> mem_cgroup_protection() in get_scan_count() to get the scan count.
> That is not proper.

Please document user visible effects of this patch. What does it mean
that this is not proper behavior? What happens if we have concurrent
reclaimers at different levels of the hierarchy how that would affect
the resulting protection?

> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Cc: Chris Down <chris@chrisdown.name>
> Cc: stable@vger.kernel.org
> ---
>  mm/memcontrol.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6f6dc8712e39..df7fedbfc211 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6250,8 +6250,17 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  
>  	if (!root)
>  		root = root_mem_cgroup;
> -	if (memcg == root)
> +	if (memcg == root) {
> +		/*
> +		 * Reset memory.(emin, elow) for reclaiming the memcg
> +		 * itself.
> +		 */
> +		if (memcg != root_mem_cgroup) {
> +			memcg->memory.emin = 0;
> +			memcg->memory.elow = 0;
> +		}
>  		return MEMCG_PROT_NONE;
> +	}
>  
>  	usage = page_counter_read(&memcg->memory);
>  	if (!usage)
> -- 
> 2.14.1

-- 
Michal Hocko
SUSE Labs
