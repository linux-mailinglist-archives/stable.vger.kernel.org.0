Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8C33ED05F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhHPIe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234025AbhHPIe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:34:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA1F61B23;
        Mon, 16 Aug 2021 08:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629102865;
        bh=3YEutj3bDMCaJ4+ve9fprNnWP2Ew89/JAaSv3hfe95A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pw2xK9Dgx6nK8n8BF8fUTZK6n/HfSrKYjtArjqeA6jiMcM1XmISfaJe+sV2cPW4Aj
         Z1hGfv9QBfjRhHkYKqIUfbCitWjEXn+FDsq4UWy4E81FGSJFhPWhK5f0VMbBz/bSSD
         2jsv6OjeLMvstIWSHrdpefBMJc7veH1wPFQv1++E=
Date:   Mon, 16 Aug 2021 10:34:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chen Huang <chenhuang5@huawei.com>
Cc:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Wang Hai <wanghai38@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.10.y 01/11] mm: memcontrol: Use helpers to read page's
 memcg data
Message-ID: <YRojDsTAjSnw0jIh@kroah.com>
References: <20210816072147.3481782-1-chenhuang5@huawei.com>
 <20210816072147.3481782-2-chenhuang5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816072147.3481782-2-chenhuang5@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:21:37AM +0000, Chen Huang wrote:
> From: Roman Gushchin <guro@fb.com>

What is the git commit id of this patch in Linus's tree?

> 
> Patch series "mm: allow mapping accounted kernel pages to userspace", v6.
> 
> Currently a non-slab kernel page which has been charged to a memory cgroup
> can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
> flag is defined as a page type (like buddy, offline, etc), so it takes a
> bit from a page->mapped counter.  Pages with a type set can't be mapped to
> userspace.
> 
> But in general the kmemcg flag has nothing to do with mapping to
> userspace.  It only means that the page has been accounted by the page
> allocator, so it has to be properly uncharged on release.
> 
> Some bpf maps are mapping the vmalloc-based memory to userspace, and their
> memory can't be accounted because of this implementation detail.
> 
> This patchset removes this limitation by moving the PageKmemcg flag into
> one of the free bits of the page->mem_cgroup pointer.  Also it formalizes
> accesses to the page->mem_cgroup and page->obj_cgroups using new helpers,
> adds several checks and removes a couple of obsolete functions.  As the
> result the code became more robust with fewer open-coded bit tricks.
> 
> This patch (of 4):
> 
> Currently there are many open-coded reads of the page->mem_cgroup pointer,
> as well as a couple of read helpers, which are barely used.
> 
> It creates an obstacle on a way to reuse some bits of the pointer for
> storing additional bits of information.  In fact, we already do this for
> slab pages, where the last bit indicates that a pointer has an attached
> vector of objcg pointers instead of a regular memcg pointer.
> 
> This commits uses 2 existing helpers and introduces a new helper to
> converts all read sides to calls of these helpers:
>   struct mem_cgroup *page_memcg(struct page *page);
>   struct mem_cgroup *page_memcg_rcu(struct page *page);
>   struct mem_cgroup *page_memcg_check(struct page *page);
> 
> page_memcg_check() is intended to be used in cases when the page can be a
> slab page and have a memcg pointer pointing at objcg vector.  It does
> check the lowest bit, and if set, returns NULL.  page_memcg() contains a
> VM_BUG_ON_PAGE() check for the page not being a slab page.
> 
> To make sure nobody uses a direct access, struct page's
> mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
> Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
> Link: https://lore.kernel.org/bpf/20201201215900.3569844-2-guro@fb.com
> 
> Conflicts:
> 	mm/memcontrol.c

The "Conflicts:" lines should be removed.

Please fix up the patch series and resubmit.  But note, this seems
really intrusive, are you sure these are all needed?

What UIO driver are you using that is showing problems like this?

thanks,

greg k-h
