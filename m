Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4B10D28D
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 09:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfK2Inw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 03:43:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46629 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfK2Inw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 03:43:52 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so30591869wrl.13;
        Fri, 29 Nov 2019 00:43:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mEnIisdjimHf8Vq+Pdn+jaQWPmoV6hp0tVKP943mDWE=;
        b=Ue6A5aM6Zt3sBEaWCXKWSfCAr9DN9h8EqhyPlmYRloiQVWmGRF6u8083T7EUMG/Hxh
         VLf8rFedHVwrx3dzInFxCw3SNs6EJ1ylJpsRxxoSuBPGwh9YhI2Ghdoxok2vni8kwmna
         1O7snnDyDwTOPvUxFzoTkeS/HGrIc5IIAkMi1gYi/g7zzfetABY2SnvhBfKrNACR79qV
         4YEe08sAMF0kqvwwWGNDk06LbuE9Ty81g8WaTZM1tPV6ALq+MNqdEyD6XBp2LRLXmQSE
         5VVa7rysRT8TR5Em1gyr6/rikXBUm+dPmRIxiZNp6p1LJmgxk5gMDcGMGV6ANVJZqNCz
         JqXw==
X-Gm-Message-State: APjAAAVwu21B1uVTwM67zg812Hkev/jiS4nLdnGpdPnI8NVbwlMLYmVa
        NLCfRyzgbh6zdKR4RnlOg6I=
X-Google-Smtp-Source: APXvYqzA6Tb0oWOvbCsUl15MoIdYEwYDa0E/Gxqb9g8lz2MEU4NLiSIVJWvzoJEuB105Qvce1NfqUQ==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr31743371wrm.264.1575017028811;
        Fri, 29 Nov 2019 00:43:48 -0800 (PST)
Received: from localhost (ip-37-188-177-133.eurotel.cz. [37.188.177.133])
        by smtp.gmail.com with ESMTPSA id c144sm12772572wmd.1.2019.11.29.00.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 00:43:47 -0800 (PST)
Date:   Fri, 29 Nov 2019 09:43:46 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcg/slab: wait for !root kmem_cache refcnt
 killing on root kmem_cache destruction
Message-ID: <20191129084346.GB20173@dhcp22.suse.cz>
References: <20191129025011.3076017-1-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129025011.3076017-1-guro@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 28-11-19 18:50:11, Roman Gushchin wrote:
> Christian reported a warning like the following obtained during running some
> KVM-related tests on s390:
> 
> WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0x50/0x58
> Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_na>
> CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
> Hardware name: IBM 2964 NC9 712 (LPAR)
> Workqueue: events sysfs_slab_remove_workfn
> Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58)
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 0036008100000000
>            0000001f00000000 0035008100000000 0000001fb3573ab8 0000000000000000
>            0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb3573b00
>            0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e009263cd0
> Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),2046,0
>            0000001529746848: 47000700            bc         0,1792
>           #000000152974684c: a7f40001            brc        15,152974684e
>           >0000001529746850: a7f4fff2            brc        15,1529746834
>            0000001529746854: 0707                bcr        0,%r7
>            0000001529746856: 0707                bcr        0,%r7
>            0000001529746858: eb8ff0580024        stmg       %r8,%r15,88(%r15)
>            000000152974685e: a738ffff            lhi        %r3,-1
> Call Trace:
> ([<000003e009263d00>] 0x3e009263d00)
>  [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70
>  [<0000001529b04882>] kobject_put+0xaa/0xe8
>  [<000000152918cf28>] process_one_work+0x1e8/0x428
>  [<000000152918d1b0>] worker_thread+0x48/0x460
>  [<00000015291942c6>] kthread+0x126/0x160
>  [<0000001529b22344>] ret_from_fork+0x28/0x30
>  [<0000001529b2234c>] kernel_thread_starter+0x0/0x10
> Last Breaking-Event-Address:
>  [<000000152974684c>] percpu_ref_exit+0x4c/0x58
> ---[ end trace b035e7da5788eb09 ]---
> 
> The problem occurs because kmem_cache_destroy() is called immediately
> after deleting of a memcg, so it races with the memcg kmem_cache
> deactivation.
> 
> flush_memcg_workqueue() at the beginning of kmem_cache_destroy()
> is supposed to guarantee that all deactivation processes are finished,
> but failed to do so. It waits for an rcu grace period, after which all
> children kmem_caches should be deactivated. During the deactivation
> percpu_ref_kill() is called for non root kmem_cache refcounters,
> but it requires yet another rcu grace period to finish the transition
> to the atomic (dead) state.
> 
> So in a rare case when not all children kmem_caches are destroyed
> at the moment when the root kmem_cache is about to be gone, we need
> to wait another rcu grace period before destroying the root
> kmem_cache.
> 
> This issue can be triggered only with dynamically created kmem_caches
> which are used with memcg accounting. In this case per-memcg child
> kmem_caches are created. They are deactivated from the cgroup removing
> path. If the destruction of the root kmem_cache is racing with the
> removal of the cgroup (both are quite complicated multi-stage
> processes), the described issue can occur. The only known way to
> trigger it in the real life, is to unload some kernel module which
> creates a dedicated kmem_cache, used from different memory cgroups
> with GFP_ACCOUNT flag. If the unloading happens immediately after
> calling rmdir on the corresponding cgroup, there is some chance to
> trigger the issue.
> 
> v2: added a note to the commit log, proposed by Michal Hocko
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Cc: stable@vger.kernel.org

Thanks for extending the changelog. This is easier to digest.
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/slab_common.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 8afa188f6e20..f0ab6d4ceb4c 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -904,6 +904,18 @@ static void flush_memcg_workqueue(struct kmem_cache *s)
>  	 * previous workitems on workqueue are processed.
>  	 */
>  	flush_workqueue(memcg_kmem_cache_wq);
> +
> +	/*
> +	 * If we're racing with children kmem_cache deactivation, it might
> +	 * take another rcu grace period to complete their destruction.
> +	 * At this moment the corresponding percpu_ref_kill() call should be
> +	 * done, but it might take another rcu grace period to complete
> +	 * switching to the atomic mode.
> +	 * Please, note that we check without grabbing the slab_mutex. It's safe
> +	 * because at this moment the children list can't grow.
> +	 */
> +	if (!list_empty(&s->memcg_params.children))
> +		rcu_barrier();
>  }
>  #else
>  static inline int shutdown_memcg_caches(struct kmem_cache *s)
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs
