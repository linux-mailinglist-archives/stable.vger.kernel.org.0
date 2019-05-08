Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A24017252
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 09:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfEHHKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 03:10:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7732 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbfEHHKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 03:10:20 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 410D641BD71046C7F0A4;
        Wed,  8 May 2019 15:10:18 +0800 (CST)
Received: from [127.0.0.1] (10.177.219.49) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 May 2019
 15:10:08 +0800
Subject: Re: [PATCH] hugetlbfs: always use address space in inode for resv_map
 pointer
To:     Mike Kravetz <mike.kravetz@oracle.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
CC:     Michal Hocko <mhocko@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>, <yuyufen@huawei.com>
References: <20190416065058.GB11561@dhcp22.suse.cz>
 <20190419204435.16984-1-mike.kravetz@oracle.com>
From:   yuyufen <yuyufen@huawei.com>
Message-ID: <fafe9985-7db1-b65c-523d-875ab4b3b3b8@huawei.com>
Date:   Wed, 8 May 2019 15:10:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190419204435.16984-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.177.219.49]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/4/20 4:44, Mike Kravetz wrote:
> Continuing discussion about commit 58b6e5e8f1ad ("hugetlbfs: fix memory
> leak for resv_map") brought up the issue that inode->i_mapping may not
> point to the address space embedded within the inode at inode eviction
> time.  The hugetlbfs truncate routine handles this by explicitly using
> inode->i_data.  However, code cleaning up the resv_map will still use
> the address space pointed to by inode->i_mapping.  Luckily, private_data
> is NULL for address spaces in all such cases today but, there is no
> guarantee this will continue.
>
> Change all hugetlbfs code getting a resv_map pointer to explicitly get
> it from the address space embedded within the inode.  In addition, add
> more comments in the code to indicate why this is being done.
>
> Reported-by: Yufen Yu <yuyufen@huawei.com>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>   fs/hugetlbfs/inode.c | 11 +++++++++--
>   mm/hugetlb.c         | 19 ++++++++++++++++++-
>   2 files changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 9285dd4f4b1c..cbc649cd1722 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -499,8 +499,15 @@ static void hugetlbfs_evict_inode(struct inode *inode)
>   	struct resv_map *resv_map;
>   
>   	remove_inode_hugepages(inode, 0, LLONG_MAX);
> -	resv_map = (struct resv_map *)inode->i_mapping->private_data;
> -	/* root inode doesn't have the resv_map, so we should check it */
> +
> +	/*
> +	 * Get the resv_map from the address space embedded in the inode.
> +	 * This is the address space which points to any resv_map allocated
> +	 * at inode creation time.  If this is a device special inode,
> +	 * i_mapping may not point to the original address space.
> +	 */
> +	resv_map = (struct resv_map *)(&inode->i_data)->private_data;
> +	/* Only regular and link inodes have associated reserve maps */
>   	if (resv_map)
>   		resv_map_release(&resv_map->refs);
>   	clear_inode(inode);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6cdc7b2d9100..b30e97b0ef37 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -740,7 +740,15 @@ void resv_map_release(struct kref *ref)
>   
>   static inline struct resv_map *inode_resv_map(struct inode *inode)
>   {
> -	return inode->i_mapping->private_data;
> +	/*
> +	 * At inode evict time, i_mapping may not point to the original
> +	 * address space within the inode.  This original address space
> +	 * contains the pointer to the resv_map.  So, always use the
> +	 * address space embedded within the inode.
> +	 * The VERY common case is inode->mapping == &inode->i_data but,
> +	 * this may not be true for device special inodes.
> +	 */
> +	return (struct resv_map *)(&inode->i_data)->private_data;
>   }
>   
>   static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
> @@ -4477,6 +4485,11 @@ int hugetlb_reserve_pages(struct inode *inode,
>   	 * called to make the mapping read-write. Assume !vma is a shm mapping
>   	 */
>   	if (!vma || vma->vm_flags & VM_MAYSHARE) {
> +		/*
> +		 * resv_map can not be NULL as hugetlb_reserve_pages is only
> +		 * called for inodes for which resv_maps were created (see
> +		 * hugetlbfs_get_inode).
> +		 */
>   		resv_map = inode_resv_map(inode);
>   
>   		chg = region_chg(resv_map, from, to);
> @@ -4568,6 +4581,10 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
>   	struct hugepage_subpool *spool = subpool_inode(inode);
>   	long gbl_reserve;
>   
> +	/*
> +	 * Since this routine can be called in the evict inode path for all
> +	 * hugetlbfs inodes, resv_map could be NULL.
> +	 */
>   	if (resv_map) {
>   		chg = region_del(resv_map, start, end);
>   		/*

Dose this patch have been applied?

I think it is better to add fixes label, like:
Fixes: 58b6e5e8f1ad ("hugetlbfs: fix memory leak for resv_map")

Since the commit 58b6e5e8f1a has been merged to stable, this patch also 
be needed.
https://www.spinics.net/lists/stable/msg298740.html





