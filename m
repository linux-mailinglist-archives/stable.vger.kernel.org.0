Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DE13EE3EB
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 03:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhHQBph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 21:45:37 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:14214 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhHQBpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 21:45:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GpYjz3q2kz1CXbv;
        Tue, 17 Aug 2021 09:44:39 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 09:45:01 +0800
Received: from [10.174.177.134] (10.174.177.134) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 17 Aug 2021 09:45:01 +0800
Subject: Re: [PATCH 5.10.y 01/11] mm: memcontrol: Use helpers to read page's
 memcg data
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Wang Hai" <wanghai38@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20210816072147.3481782-1-chenhuang5@huawei.com>
 <20210816072147.3481782-2-chenhuang5@huawei.com> <YRojDsTAjSnw0jIh@kroah.com>
 <a4c545a8-fff0-38bb-4749-3483c9334daa@huawei.com>
 <YRppmvYOftjAAl/R@kroah.com>
From:   Chen Huang <chenhuang5@huawei.com>
Message-ID: <0d3c6aa4-be05-3c93-bdcd-ac30788d82bd@huawei.com>
Date:   Tue, 17 Aug 2021 09:45:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YRppmvYOftjAAl/R@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.134]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema756-chm.china.huawei.com (10.1.198.198)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2021/8/16 21:35, Greg Kroah-Hartman 写道:
> On Mon, Aug 16, 2021 at 09:21:11PM +0800, Chen Huang wrote:
>>
>>
>> 在 2021/8/16 16:34, Greg Kroah-Hartman 写道:
>>> On Mon, Aug 16, 2021 at 07:21:37AM +0000, Chen Huang wrote:
>>>> From: Roman Gushchin <guro@fb.com>
>>>
>>> What is the git commit id of this patch in Linus's tree?
>>>
>>>>
>>>> Patch series "mm: allow mapping accounted kernel pages to userspace", v6.
>>>>
>>>> Currently a non-slab kernel page which has been charged to a memory cgroup
>>>> can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
>>>> flag is defined as a page type (like buddy, offline, etc), so it takes a
>>>> bit from a page->mapped counter.  Pages with a type set can't be mapped to
>>>> userspace.
>>>>
>>>> But in general the kmemcg flag has nothing to do with mapping to
>>>> userspace.  It only means that the page has been accounted by the page
>>>> allocator, so it has to be properly uncharged on release.
>>>>
>>>> Some bpf maps are mapping the vmalloc-based memory to userspace, and their
>>>> memory can't be accounted because of this implementation detail.
>>>>
>>>> This patchset removes this limitation by moving the PageKmemcg flag into
>>>> one of the free bits of the page->mem_cgroup pointer.  Also it formalizes
>>>> accesses to the page->mem_cgroup and page->obj_cgroups using new helpers,
>>>> adds several checks and removes a couple of obsolete functions.  As the
>>>> result the code became more robust with fewer open-coded bit tricks.
>>>>
>>>> This patch (of 4):
>>>>
>>>> Currently there are many open-coded reads of the page->mem_cgroup pointer,
>>>> as well as a couple of read helpers, which are barely used.
>>>>
>>>> It creates an obstacle on a way to reuse some bits of the pointer for
>>>> storing additional bits of information.  In fact, we already do this for
>>>> slab pages, where the last bit indicates that a pointer has an attached
>>>> vector of objcg pointers instead of a regular memcg pointer.
>>>>
>>>> This commits uses 2 existing helpers and introduces a new helper to
>>>> converts all read sides to calls of these helpers:
>>>>   struct mem_cgroup *page_memcg(struct page *page);
>>>>   struct mem_cgroup *page_memcg_rcu(struct page *page);
>>>>   struct mem_cgroup *page_memcg_check(struct page *page);
>>>>
>>>> page_memcg_check() is intended to be used in cases when the page can be a
>>>> slab page and have a memcg pointer pointing at objcg vector.  It does
>>>> check the lowest bit, and if set, returns NULL.  page_memcg() contains a
>>>> VM_BUG_ON_PAGE() check for the page not being a slab page.
>>>>
>>>> To make sure nobody uses a direct access, struct page's
>>>> mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.
>>>>
>>>> Signed-off-by: Roman Gushchin <guro@fb.com>
>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>> Reviewed-by: Shakeel Butt <shakeelb@google.com>
>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>> Acked-by: Michal Hocko <mhocko@suse.com>
>>>> Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
>>>> Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
>>>> Link: https://lore.kernel.org/bpf/20201201215900.3569844-2-guro@fb.com
>>>>
>>>> Conflicts:
>>>> 	mm/memcontrol.c
>>>
>>> The "Conflicts:" lines should be removed.
>>>
>>> Please fix up the patch series and resubmit.  But note, this seems
>>> really intrusive, are you sure these are all needed?
>>>
>>
>> OK，I will resend the patchset.
>> Roman Gushchin's patchset formalize accesses to the page->mem_cgroup and
>> page->obj_cgroups. But for LRU pages and most other raw memcg, they may
>> pin to a memcg cgroup pointer, which should always point to an object cgroup
>> pointer. That's the problem I met. And Muchun Song's patchset fix this.
>> So I think these are all needed.
> 
> What in-tree driver causes this to happen and under what workload?
> 
>>> What UIO driver are you using that is showing problems like this?
>>>
>>
>> The UIO driver is my own driver, and it's creation likes this:
>> First, we register a device
>> 	pdev = platform_device_register_simple("uio_driver,0, NULL, 0);
>> and use uio_info to describe the UIO driver, the page is alloced and used
>> for uio_vma_fault
>> 	info->mem[0].addr = (phys_addr_t) kzalloc(PAGE_SIZE, GFP_ATOMIC);
> 
> That is not a physical address, and is not what the uio api is for at
> all.  Please do not abuse it that way.
> 
>> then we register the UIO driver.
>> 	uio_register_device(&pdev->dev, info)
> 
> So no in-tree drivers are having problems with the existing code, only
> fake ones?

Yes, but the nullptr porblem may not just about uio driver. For now, page struct
has a union
union {
	struct mem_cgroup *mem_cgroup;
	struct obj_cgroup **obj_cgroups;
};
For the slab pages, the union info should belong to obj_cgroups. And for user
pages, it should belong to mem_cgroup. When a slab page changes its obj_cgroups,
then another user page which is in the same compound page of that slab page will
gets the wrong mem_cgroup in __mod_lruvec_page_state(), and will trigger nullptr
in mem_cgroup_lruvec(). Correct me if I'm wrong. Thanks!

static inline void __mod_lruvec_page_state(struct page *page,
                                           enum node_stat_item idx, int val)
{
        struct page *head = compound_head(page); /* rmap on tail pages */
        pg_data_t *pgdat = page_pgdat(page);
        struct lruvec *lruvec;

        /* Untracked pages have no memcg, no lruvec. Update only the node */
        if (!head->mem_cgroup) {
                __mod_node_page_state(pgdat, idx, val);
                return;
        }

        lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
        __mod_lruvec_state(lruvec, idx, val);
}

> 
> thanks,
> 
> greg k-h
> .
> 
