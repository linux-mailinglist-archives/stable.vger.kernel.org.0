Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BEF1EB75B
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 10:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgFBI24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 04:28:56 -0400
Received: from relay.sw.ru ([185.231.240.75]:52076 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgFBI24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 04:28:56 -0400
Received: from [192.168.15.86]
        by relay3.sw.ru with esmtp (Exim 4.93)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1jg2Ho-0000Xn-4B; Tue, 02 Jun 2020 11:28:40 +0300
Subject: Re: [PATCH] shmem, memcg: enable memcg aware shrinker
To:     Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200601032204.124624-1-gthelen@google.com>
 <ffdff0be-f2b6-c7c0-debc-9c5e8a33ae4e@virtuozzo.com>
 <xr93d06i4fus.fsf@gthelen.svl.corp.google.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <5da3cdac-cf05-456f-867f-f09d5a6a2621@virtuozzo.com>
Date:   Tue, 2 Jun 2020 11:28:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <xr93d06i4fus.fsf@gthelen.svl.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.06.2020 00:48, Greg Thelen wrote:
> Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> 
>> Hi, Greg,
>>
>> good finding. See comments below.
>>
>> On 01.06.2020 06:22, Greg Thelen wrote:
>>> Since v4.19 commit b0dedc49a2da ("mm/vmscan.c: iterate only over charged
>>> shrinkers during memcg shrink_slab()") a memcg aware shrinker is only
>>> called when the per-memcg per-node shrinker_map indicates that the
>>> shrinker may have objects to release to the memcg and node.
>>>
>>> shmem_unused_huge_count and shmem_unused_huge_scan support the per-tmpfs
>>> shrinker which advertises per memcg and numa awareness.  The shmem
>>> shrinker releases memory by splitting hugepages that extend beyond
>>> i_size.
>>>
>>> Shmem does not currently set bits in shrinker_map.  So, starting with
>>> b0dedc49a2da, memcg reclaim avoids calling the shmem shrinker under
>>> pressure.  This leads to undeserved memcg OOM kills.
>>> Example that reliably sees memcg OOM kill in unpatched kernel:
>>>   FS=/tmp/fs
>>>   CONTAINER=/cgroup/memory/tmpfs_shrinker
>>>   mkdir -p $FS
>>>   mount -t tmpfs -o huge=always nodev $FS
>>>   # Create 1000 MB container, which shouldn't suffer OOM.
>>>   mkdir $CONTAINER
>>>   echo 1000M > $CONTAINER/memory.limit_in_bytes
>>>   echo $BASHPID >> $CONTAINER/cgroup.procs
>>>   # Create 4000 files.  Ideally each file uses 4k data page + a little
>>>   # metadata.  Assume 8k total per-file, 32MB (4000*8k) should easily
>>>   # fit within container's 1000 MB.  But if data pages use 2MB
>>>   # hugepages (due to aggressive huge=always) then files consume 8GB,
>>>   # which hits memcg 1000 MB limit.
>>>   for i in {1..4000}; do
>>>     echo . > $FS/$i
>>>   done
>>>
>>> v5.4 commit 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg
>>> aware") maintains the per-node per-memcg shrinker bitmap for THP
>>> shrinker.  But there's no such logic in shmem.  Make shmem set the
>>> per-memcg per-node shrinker bits when it modifies inodes to have
>>> shrinkable pages.
>>>
>>> Fixes: b0dedc49a2da ("mm/vmscan.c: iterate only over charged shrinkers during memcg shrink_slab()")
>>> Cc: <stable@vger.kernel.org> # 4.19+
>>> Signed-off-by: Greg Thelen <gthelen@google.com>
>>> ---
>>>  mm/shmem.c | 61 +++++++++++++++++++++++++++++++-----------------------
>>>  1 file changed, 35 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index bd8840082c94..e11090f78cb5 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1002,6 +1002,33 @@ static int shmem_getattr(const struct path *path, struct kstat *stat,
>>>  	return 0;
>>>  }
>>>  
>>> +/*
>>> + * Expose inode and optional page to shrinker as having a possibly splittable
>>> + * hugepage that reaches beyond i_size.
>>> + */
>>> +static void shmem_shrinker_add(struct shmem_sb_info *sbinfo,
>>> +			       struct inode *inode, struct page *page)
>>> +{
>>> +	struct shmem_inode_info *info = SHMEM_I(inode);
>>> +
>>> +	spin_lock(&sbinfo->shrinklist_lock);
>>> +	/*
>>> +	 * _careful to defend against unlocked access to ->shrink_list in
>>> +	 * shmem_unused_huge_shrink()
>>> +	 */
>>> +	if (list_empty_careful(&info->shrinklist)) {
>>> +		list_add_tail(&info->shrinklist, &sbinfo->shrinklist);
>>> +		sbinfo->shrinklist_len++;
>>> +	}
>>> +	spin_unlock(&sbinfo->shrinklist_lock);
>>> +
>>> +#ifdef CONFIG_MEMCG
>>> +	if (page && PageTransHuge(page))
>>> +		memcg_set_shrinker_bit(page->mem_cgroup, page_to_nid(page),
>>> +				       inode->i_sb->s_shrink.id);
>>> +#endif
>>> +}
>>> +
>>>  static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
>>>  {
>>>  	struct inode *inode = d_inode(dentry);
>>> @@ -1048,17 +1075,13 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
>>>  			 * to shrink under memory pressure.
>>>  			 */
>>>  			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>>> -				spin_lock(&sbinfo->shrinklist_lock);
>>> -				/*
>>> -				 * _careful to defend against unlocked access to
>>> -				 * ->shrink_list in shmem_unused_huge_shrink()
>>> -				 */
>>> -				if (list_empty_careful(&info->shrinklist)) {
>>> -					list_add_tail(&info->shrinklist,
>>> -							&sbinfo->shrinklist);
>>> -					sbinfo->shrinklist_len++;
>>> -				}
>>> -				spin_unlock(&sbinfo->shrinklist_lock);
>>> +				struct page *page;
>>> +
>>> +				page = find_get_page(inode->i_mapping,
>>> +					(newsize & HPAGE_PMD_MASK) >> PAGE_SHIFT);
>>> +				shmem_shrinker_add(sbinfo, inode, page);
>>> +				if (page)
>>> +					put_page(page);
>>
>> 1)I'd move PageTransHuge() check from shmem_shrinker_add() to here. In case of page is not trans huge,
>>   it looks strange and completely useless to add inode to shrinklist and then to avoid memcg_set_shrinker_bit().
>>   Nothing should be added to the shrinklist in this case.
> 
> Ack,  I'll take a look at this.
> 
>> 2)In general I think this "last inode page spliter" does not fit SHINKER_MEMCG_AWARE conception, and
>>   shmem_unused_huge_shrink() should be reworked as a new separate !memcg-aware shrinker instead of
>>   .nr_cached_objects callback of generic fs shrinker.
>>
>> CC: Kirill Shutemov
>>
>> Kirill, are there any fundamental reasons to keep this shrinking logic in the generic fs shrinker?
>> Are there any no-go to for conversion this as a separate !memcg-aware shrinker?
> 
> Making the shmem shrinker !memcg-aware seems like it would require tail
> pages beyond i_size not be charged to memcg.  Otherwise memcg pressure
> (which only calls memcg aware shrinkers) won't uncharge them.  Currently
> the entire compound page is charged.

Shrinker is not about charging, shrinker is about uncharging ;) The pages will remain be charged
like they used to be and where they used to be.

The thing is we have single shrinklist for a superblock. An inode with pending tail page splitting
is added to this list. Later, shmem_unused_huge_scan() iterates over the list. It splits the tail
page for every inode in case of the inode size is still unaligned by huge page.

We do not care about memcg here. Tail pages for two inodes may be related to different memcg. But
shmem_unused_huge_scan() shrink all of them, it does not care about memcg in sc->memcg. Even more:
nobody in mm/shmem.c cares about memcg.

In traditional memcg-aware shrinkers we maintain separate lists for every existing memcg. Object,
which is charged to a memcg, is added to a specific shrinker list related to the memcg. So, shrinker
is able to iterate only that objects, which are charged to the memcg.

In case of shmem we have single list for that objects (shrinklist). Even more, we have shrinklist
not for charged objects, we link inodes there. Imagine a situation: file was shrinked and inode
became linked to shrinklist. Tail page is unaligned and it is related to memcg1. Then file became
shrinked one more time. New tail page is also unaligned and it related to another memcg2. So, shmem
shrinker doesn't introduce lists for every memcg (i.e. list_lru), since inode's tail page relation
to a memcg is not constant. So, as shmem shrinker splits any memcg pages (despite its sc->memcg),
it can't be called memcg-aware.

Revisiting this once again today, I think we should make shrinklist a list_lru type. Every time,
when inode is considered to be added to a shrinklist, we should move it to appropriate memcg list.
In case of it's already linked and memcg is changed, we should move it to another memcg list. I.e.,
every place like:

	if (list_empty(&info->shrinklist)) {
		list_add_tail(&info->shrinklist, &sbinfo->shrinklist); 
		sbinfo->shrinklist_len++;
	}

Convert into:

	if (list_empty(&info->shrinklist)) {
		list_lru_add(&sbinfo->shrinklist, &info->shrinklist);
		info->memcg_id = memcg->id;
	} else if (memcg_changed(info)) {
		/* Remove from old memcg list */
		list_lru_del(&info->shrinklist);
		/* Link to new memcg list */
		list_lru_add(&sbinfo->shrinklist, &info->shrinklist);
	}

We may cache memcg->id into info, so memcg_changed() we be able to compare cached memcg
and current, and we will avoid del/add in case of tail page memcg remain the same.

Kirill
