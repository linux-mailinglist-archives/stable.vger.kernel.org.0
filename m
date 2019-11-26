Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C615D109B3A
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 10:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfKZJ3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 04:29:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51328 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbfKZJ3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 04:29:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id g206so2386996wme.1;
        Tue, 26 Nov 2019 01:29:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DcaxlJQ2+14pCUnNFuZbUg/rXipGcXbwRRsD8mfQyy8=;
        b=FkrjygfCpIkM3BWNyw10kY4TeFfCuIffqvnEj1kbXBhsKn7V33T/HxW5KiLUhxMZDP
         5lwiAGJR78QVR2SU9D8zh9uxcnbsxEM0P/Hew3SGDfl6Vz6wUan99hDAa1Z0nBs+fRdV
         FysJoUfypv1zDeznfxVgXKaL6cUzW05d+dK2QbQz3Z9E+VNEfwgWwx2ale+ejl0rvPG9
         vHdDx8uIP5uu0RsymFKIRYxk1DPsBVXjI6LCEn57aumLRF7jWiCbNI7XKF2AAoMoqUZG
         iBkTdIm0ZHY2NiqHNgx+ZZCdBn5PFqlWZmZ12AHmWGV69jqfocJ+g9lP4YBvfV5wT0gt
         vfnA==
X-Gm-Message-State: APjAAAXoLD3njEZhIklyf5dsXjmZT/jzol4eNwI1HxjdaP/oH4MS74kl
        xvK88jU8LQ+6WrbrlVArb0g=
X-Google-Smtp-Source: APXvYqzVjjDOUKH8s53/FAhkwEoj8sphrO9B2cdvE5yEK4sWgCBVcffxPysEVpcENidZMDlwq6SovQ==
X-Received: by 2002:a05:600c:2254:: with SMTP id a20mr3200434wmm.97.1574760559986;
        Tue, 26 Nov 2019 01:29:19 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id i71sm15653778wri.68.2019.11.26.01.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 01:29:19 -0800 (PST)
Date:   Tue, 26 Nov 2019 10:29:18 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Message-ID: <20191126092918.GB20912@dhcp22.suse.cz>
References: <20191125185453.278468-1-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125185453.278468-1-guro@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 25-11-19 10:54:53, Roman Gushchin wrote:
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

Could you explain how rare this really is please? I still have to wrap
my head around the overall logic here. It looks quite fragile to me TBH.
I am worried that is relies on implementation detail of the PCP ref
counters too much.

> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org
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
> 2.23.0

-- 
Michal Hocko
SUSE Labs
