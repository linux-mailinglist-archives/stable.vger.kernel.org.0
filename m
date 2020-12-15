Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314982DB697
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbgLOWkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 17:40:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60444 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729802AbgLOWkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 17:40:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFMdiZa029726;
        Tue, 15 Dec 2020 22:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4QmLHvrBsUjuL3+RI0Oe/61V/03hxVujeNXABHfcE0o=;
 b=Ior35owJr+CojS017WWvxv8+zJmD6vCYdLLf+IXdOLWTEq1kTyQorwv/iE6eWDB9PQ7m
 pGXzPr6Z9CLjd1nznbBieapqUTO7/zp5hTyQvUZMTbcJIvYndAGgrBYXdVZ9MiNAXNKg
 LcN1C6IKc1UyGrVpdaD1+AJ8Kb8ihV5vZsNi5x8bqSuxsStv7YFUiWWk7QpZX00QVeJW
 c7Mg2AqZ25E0C6whxhLQjeHupHCnwKHIOnBT53PeeBPlZL9/qHWO0gJmTl/WF23ZE7gj
 nmjXi0FXtE/ifenrZ7kBjorLmAvPTXtTWeqVPLIDbawg/zQgikYK44/CTQ7qccrQWRCA 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcbdbxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 22:39:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFMa8GH168241;
        Tue, 15 Dec 2020 22:39:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35d7swwaum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 22:39:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BFMdd00000864;
        Tue, 15 Dec 2020 22:39:39 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 14:39:39 -0800
Subject: Re: [PATCH] mm/hugetlb: fix deadlock in hugetlb_cow error path
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        syzbot+5eee4145df3c15e96625@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20201215010611.181063-1-mike.kravetz@oracle.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <4c5781b8-3b00-761e-c0c7-c5edebb6ec1a@oracle.com>
Date:   Tue, 15 Dec 2020 14:39:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20201215010611.181063-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150153
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/14/20 5:06 PM, Mike Kravetz wrote:
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d029d938d26d..8713f8ef0f4c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4106,10 +4106,30 @@ static vm_fault_t hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  		 * may get SIGKILLed if it later faults.
>  		 */
>  		if (outside_reserve) {
> +			struct address_space *mapping = vma->vm_file->f_mapping;
> +			pgoff_t idx;
> +			u32 hash;
> +
>  			put_page(old_page);
>  			BUG_ON(huge_pte_none(pte));
> +			/*
> +			 * Drop hugetlb_fault_mutex and i_mmap_rwsem before
> +			 * unmapping.  unmapping needs to hold i_mmap_rwsem
> +			 * in write mode.  Dropping i_mmap_rwsem in read mode
> +			 * here is OK as COW mappings do not interact with
> +			 * PMD sharing.
> +			 *
> +			 * Reacquire both after unmap operation.
> +			 */
> +			idx = vma_hugecache_offset(h, vma, haddr);
> +			hash = hugetlb_fault_mutex_hash(mapping, idx);
> +			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> +			i_mmap_unlock_read(vma->vm_file->f_mapping);

The assignment 'mapping = vma->vm_file->f_mapping' is done at the beginning
of this block.  Silly that it is not used here.

> +
>  			unmap_ref_private(mm, vma, old_page, haddr);
> -			BUG_ON(huge_pte_none(pte));
> +
> +			i_mmap_lock_read(vma->vm_file->f_mapping);

and here.

> +			mutex_lock(&hugetlb_fault_mutex_table[hash]);
>  			spin_lock(ptl);
>  			ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
>  			if (likely(ptep &&
> 

Updated patch to use block local variable mapping.

From aa450d80a63dc4533b2eca9f61c1acfb37587c06 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 14 Dec 2020 16:26:32 -0800
Subject: [PATCH v2] mm/hugetlb: fix deadlock in hugetlb_cow error path

syzbot reported the deadlock here [1].  The issue is in hugetlb cow
error handling when there are not enough huge pages for the faulting
task which took the original reservation.  It is possible that other
(child) tasks could have consumed pages associated with the reservation.
In this case, we want the task which took the original reservation to
succeed.  So, we unmap any associated pages in children so that they
can be used by the faulting task that owns the reservation.

The unmapping code needs to hold i_mmap_rwsem in write mode.  However,
due to commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd
sharing synchronization") we are already holding i_mmap_rwsem in read
mode when hugetlb_cow is called.  Technically, i_mmap_rwsem does not
need to be held in read mode for COW mappings as they can not share
pmd's.  Modifying the fault code to not take i_mmap_rwsem in read mode
for COW (and other non-sharable) mappings is too involved for a stable
fix.  Instead, we simply drop the hugetlb_fault_mutex and i_mmap_rwsem
before unmapping.  This is OK as it is technically not needed.  They
are reacquired after unmapping as expected by calling code.  Since this
is done in an uncommon error path, the overhead of dropping and
reacquiring mutexes is acceptable.

While making changes, remove redundant BUG_ON after unmap_ref_private.

[1] https://lkml.kernel.org/r/000000000000b73ccc05b5cf8558@google.com

Reported-by: syzbot+5eee4145df3c15e96625@syzkaller.appspotmail.com
Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d029d938d26d..7e89f31d7ef8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4106,10 +4106,30 @@ static vm_fault_t hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 		 * may get SIGKILLed if it later faults.
 		 */
 		if (outside_reserve) {
+			struct address_space *mapping = vma->vm_file->f_mapping;
+			pgoff_t idx;
+			u32 hash;
+
 			put_page(old_page);
 			BUG_ON(huge_pte_none(pte));
+			/*
+			 * Drop hugetlb_fault_mutex and i_mmap_rwsem before
+			 * unmapping.  unmapping needs to hold i_mmap_rwsem
+			 * in write mode.  Dropping i_mmap_rwsem in read mode
+			 * here is OK as COW mappings do not interact with
+			 * PMD sharing.
+			 *
+			 * Reacquire both after unmap operation.
+			 */
+			idx = vma_hugecache_offset(h, vma, haddr);
+			hash = hugetlb_fault_mutex_hash(mapping, idx);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			i_mmap_unlock_read(mapping);
+
 			unmap_ref_private(mm, vma, old_page, haddr);
-			BUG_ON(huge_pte_none(pte));
+
+			i_mmap_lock_read(mapping);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			spin_lock(ptl);
 			ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 			if (likely(ptep &&
-- 
2.29.2

