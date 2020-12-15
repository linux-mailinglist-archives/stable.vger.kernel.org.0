Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240A22DA52D
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 02:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgLOBH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 20:07:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35464 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbgLOBH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 20:07:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BF144op082297;
        Tue, 15 Dec 2020 01:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=kUUcCK2zP9b8L/Fm6IdtMvoJrZcVsrtqFoMGFtfTqtA=;
 b=PtIeEytAU7mbnWujh/MlRoF4Zck4A7boHuOd2kpaShftObJlJu0oK+TZXank4QGoGlwY
 AAIbhws+N4xcJ6Tczij98uTaxs6UJKgICU/F3DOQEbzAW4HLKaxOk0reNbt11VkPeomk
 9GS8oOht4doeo6wjVlqeJsncx5VOpjbYE0hCYmnn7z75ECHIRriFob+DTsENAZEeG6/e
 NLG6ph1WZwuuNeqpm/ftZ6fk4BDqInhpWxVm375nK2dwSCISsa8XUtysk6EgIoyT4neu
 KTxxP/K5dluTQGdq70gYvtRc/dwO4BRweTZ/6JPK/swti3nZadgMzQvrVph18zl8egc2 Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcb8be2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 01:06:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BF10sEc005757;
        Tue, 15 Dec 2020 01:06:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6epp2rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 01:06:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BF16RT3019032;
        Tue, 15 Dec 2020 01:06:27 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 17:06:27 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        syzbot+5eee4145df3c15e96625@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb: fix deadlock in hugetlb_cow error path
Date:   Mon, 14 Dec 2020 17:06:11 -0800
Message-Id: <20201215010611.181063-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150003
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index d029d938d26d..8713f8ef0f4c 100644
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
+			i_mmap_unlock_read(vma->vm_file->f_mapping);
+
 			unmap_ref_private(mm, vma, old_page, haddr);
-			BUG_ON(huge_pte_none(pte));
+
+			i_mmap_lock_read(vma->vm_file->f_mapping);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			spin_lock(ptl);
 			ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 			if (likely(ptep &&
-- 
2.29.2

