Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7716E18E57C
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 00:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgCUXs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 19:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgCUXs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 19:48:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCB520776;
        Sat, 21 Mar 2020 23:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584834537;
        bh=sWExtjn8sa4U+VoWjZDvGtP+9AcpWaq/4Mq2vl0qPTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d9Tdc1/r7NUzkOgvOakY6hhP+Dr5lXeCZPcNa0FEny4Ue+fx23XzfbRoN+isjFRnt
         WVm/r9s1cCwT0VQyt9izelOraD9hU3NuEm0IdL2tY8gLS03kTOSi229WjhiHuyR6M1
         gOLnRyzVaXknbwTTlZRYopw6g6oS0JHKbRsjUeb4=
Date:   Sat, 21 Mar 2020 16:48:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: fork: fix kernel_stack memcg stats for various
 stack implementations
Message-Id: <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
In-Reply-To: <20200303233550.251375-1-guro@fb.com>
References: <20200303233550.251375-1-guro@fb.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Mar 2020 15:35:50 -0800 Roman Gushchin <guro@fb.com> wrote:

> Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio
> the space for task stacks can be allocated using __vmalloc_node_range(),
> alloc_pages_node() and kmem_cache_alloc_node(). In the first and the
> second cases page->mem_cgroup pointer is set, but in the third it's
> not: memcg membership of a slab page should be determined using the
> memcg_from_slab_page() function, which looks at
> page->slab_cache->memcg_params.memcg . In this case, using
> mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
> page->mem_cgroup pointer is NULL even for pages charged to a non-root
> memory cgroup.
> 
> It can lead to kernel_stack per-memcg counters permanently showing 0
> on some architectures (depending on the configuration).
> 
> In order to fix it, let's introduce a mod_memcg_obj_state() helper,
> which takes a pointer to a kernel object as a first argument, uses
> mem_cgroup_from_obj() to get a RCU-protected memcg pointer and
> calls mod_memcg_state(). It allows to handle all possible
> configurations (CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE
> values) without spilling any memcg/kmem specifics into fork.c .
> 
> Note: this patch has been first posted as a part of the new slab
> controller patchset. This is a slightly updated version: the fixes
> tag has been added and the commit log was extended by the advice
> of Johannes Weiner. Because it's a fix that makes sense by itself,
> I'm re-posting it as a standalone patch.

Actually, it isn't a standalone patch.

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -776,6 +776,17 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
>  	rcu_read_unlock();
>  }
>  
> +void mod_memcg_obj_state(void *p, int idx, int val)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_obj(p);
> +	if (memcg)
> +		mod_memcg_state(memcg, idx, val);
> +	rcu_read_unlock();
> +}

mem_cgroup_from_obj() is later added by
http://lkml.kernel.org/r/20200117203609.3146239-1-guro@fb.com

We could merge both mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
and this patch, but that's a whole lot of stuff to backport into
-stable.

Are you able to come up with a simpler suitable-for-stable fix?
