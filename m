Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB083EE67F
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 08:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhHQGPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 02:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233676AbhHQGPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 02:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BBA60E78;
        Tue, 17 Aug 2021 06:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629180900;
        bh=NZjiKqRb5lmmInzfCqVEdFiurrR2yJY2P60ADXWH3c4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1VTUu8ohNsUCmIpWF5K2BJtCu68kxWHlhvISHVRM30dbPZNjODkm6eFbLOIQOUtgi
         caMChXiEbra7k1YJ4ITdQbZcpI7lORH13SSs44DO0+1zcAidDAkvhPgCiQ3kThguvk
         27AkrHAoV7KRod8taHWWYIvhqKSHt7o2pH2HXksY=
Date:   Tue, 17 Aug 2021 08:14:58 +0200
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
Message-ID: <YRtT4obiu86hp6z3@kroah.com>
References: <20210816072147.3481782-1-chenhuang5@huawei.com>
 <20210816072147.3481782-2-chenhuang5@huawei.com>
 <YRojDsTAjSnw0jIh@kroah.com>
 <a4c545a8-fff0-38bb-4749-3483c9334daa@huawei.com>
 <YRppmvYOftjAAl/R@kroah.com>
 <0d3c6aa4-be05-3c93-bdcd-ac30788d82bd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d3c6aa4-be05-3c93-bdcd-ac30788d82bd@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 09:45:00AM +0800, Chen Huang wrote:
> 
> 
> 在 2021/8/16 21:35, Greg Kroah-Hartman 写道:
> > On Mon, Aug 16, 2021 at 09:21:11PM +0800, Chen Huang wrote:
> >>
> >>
> >> 在 2021/8/16 16:34, Greg Kroah-Hartman 写道:
> >>> On Mon, Aug 16, 2021 at 07:21:37AM +0000, Chen Huang wrote:
> >>>> From: Roman Gushchin <guro@fb.com>
> >>>
> >>> What is the git commit id of this patch in Linus's tree?
> >>>
> >>>>
> >>>> Patch series "mm: allow mapping accounted kernel pages to userspace", v6.
> >>>>
> >>>> Currently a non-slab kernel page which has been charged to a memory cgroup
> >>>> can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
> >>>> flag is defined as a page type (like buddy, offline, etc), so it takes a
> >>>> bit from a page->mapped counter.  Pages with a type set can't be mapped to
> >>>> userspace.
> >>>>
> >>>> But in general the kmemcg flag has nothing to do with mapping to
> >>>> userspace.  It only means that the page has been accounted by the page
> >>>> allocator, so it has to be properly uncharged on release.
> >>>>
> >>>> Some bpf maps are mapping the vmalloc-based memory to userspace, and their
> >>>> memory can't be accounted because of this implementation detail.
> >>>>
> >>>> This patchset removes this limitation by moving the PageKmemcg flag into
> >>>> one of the free bits of the page->mem_cgroup pointer.  Also it formalizes
> >>>> accesses to the page->mem_cgroup and page->obj_cgroups using new helpers,
> >>>> adds several checks and removes a couple of obsolete functions.  As the
> >>>> result the code became more robust with fewer open-coded bit tricks.
> >>>>
> >>>> This patch (of 4):
> >>>>
> >>>> Currently there are many open-coded reads of the page->mem_cgroup pointer,
> >>>> as well as a couple of read helpers, which are barely used.
> >>>>
> >>>> It creates an obstacle on a way to reuse some bits of the pointer for
> >>>> storing additional bits of information.  In fact, we already do this for
> >>>> slab pages, where the last bit indicates that a pointer has an attached
> >>>> vector of objcg pointers instead of a regular memcg pointer.
> >>>>
> >>>> This commits uses 2 existing helpers and introduces a new helper to
> >>>> converts all read sides to calls of these helpers:
> >>>>   struct mem_cgroup *page_memcg(struct page *page);
> >>>>   struct mem_cgroup *page_memcg_rcu(struct page *page);
> >>>>   struct mem_cgroup *page_memcg_check(struct page *page);
> >>>>
> >>>> page_memcg_check() is intended to be used in cases when the page can be a
> >>>> slab page and have a memcg pointer pointing at objcg vector.  It does
> >>>> check the lowest bit, and if set, returns NULL.  page_memcg() contains a
> >>>> VM_BUG_ON_PAGE() check for the page not being a slab page.
> >>>>
> >>>> To make sure nobody uses a direct access, struct page's
> >>>> mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.
> >>>>
> >>>> Signed-off-by: Roman Gushchin <guro@fb.com>
> >>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >>>> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> >>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>>> Acked-by: Michal Hocko <mhocko@suse.com>
> >>>> Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
> >>>> Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
> >>>> Link: https://lore.kernel.org/bpf/20201201215900.3569844-2-guro@fb.com
> >>>>
> >>>> Conflicts:
> >>>> 	mm/memcontrol.c
> >>>
> >>> The "Conflicts:" lines should be removed.
> >>>
> >>> Please fix up the patch series and resubmit.  But note, this seems
> >>> really intrusive, are you sure these are all needed?
> >>>
> >>
> >> OK，I will resend the patchset.
> >> Roman Gushchin's patchset formalize accesses to the page->mem_cgroup and
> >> page->obj_cgroups. But for LRU pages and most other raw memcg, they may
> >> pin to a memcg cgroup pointer, which should always point to an object cgroup
> >> pointer. That's the problem I met. And Muchun Song's patchset fix this.
> >> So I think these are all needed.
> > 
> > What in-tree driver causes this to happen and under what workload?
> > 
> >>> What UIO driver are you using that is showing problems like this?
> >>>
> >>
> >> The UIO driver is my own driver, and it's creation likes this:
> >> First, we register a device
> >> 	pdev = platform_device_register_simple("uio_driver,0, NULL, 0);
> >> and use uio_info to describe the UIO driver, the page is alloced and used
> >> for uio_vma_fault
> >> 	info->mem[0].addr = (phys_addr_t) kzalloc(PAGE_SIZE, GFP_ATOMIC);
> > 
> > That is not a physical address, and is not what the uio api is for at
> > all.  Please do not abuse it that way.
> > 
> >> then we register the UIO driver.
> >> 	uio_register_device(&pdev->dev, info)
> > 
> > So no in-tree drivers are having problems with the existing code, only
> > fake ones?
> 
> Yes, but the nullptr porblem may not just about uio driver. For now, page struct
> has a union
> union {
> 	struct mem_cgroup *mem_cgroup;
> 	struct obj_cgroup **obj_cgroups;
> };
> For the slab pages, the union info should belong to obj_cgroups. And for user
> pages, it should belong to mem_cgroup. When a slab page changes its obj_cgroups,
> then another user page which is in the same compound page of that slab page will
> gets the wrong mem_cgroup in __mod_lruvec_page_state(), and will trigger nullptr
> in mem_cgroup_lruvec(). Correct me if I'm wrong. Thanks!

And how can that be triggered by a user in the 5.10.y kernel tree at the
moment?

I'm all for fixing problems, but this one does not seem like it is an
actual issue for the 5.10 tree right now.  Am I missing something?

thanks,

greg k-h
