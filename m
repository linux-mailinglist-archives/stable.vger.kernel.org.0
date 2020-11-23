Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2E02C1118
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 17:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgKWQxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 11:53:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1734 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbgKWQxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 11:53:22 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANGY5nI153083;
        Mon, 23 Nov 2020 11:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=e6BSsjG/T8ryJQOS9viWeH6JytTsfcf9nqihUhGFK3s=;
 b=U3OIuPCDntWboYt2l1PkeZQeVihxiNFD+NlxWaPZfcRB2nkvtjMU5CRFWvt0OmVXnPgt
 5Sj8HUsac8yJbrXZ/9G/+EzUnGmxWYlsRZjupvG2695OJmEIGsdbeToB4RuUr6UlTxoe
 vI5xlsYPgvct4c1hbPOnszTzatpY23v/hZYKl0LwgU+ua00PElYJj/2yME1mMq94Y/Jf
 QezK+rv173wthQSi53OBTavlACYI86OFkoFU4GcCxy+pdCb1p64KmZgml3yMJyZeeN8T
 +TgBXQuoyI8RzIqIkgw8UbLITb2I/gRnhrlzkP9IOKPtoX7lVgxE6YXTHD70GVNe9bOy 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fg5bnsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 11:53:20 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ANGYvGL160588;
        Mon, 23 Nov 2020 11:53:19 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fg5bns5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 11:53:19 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANGqKHB016533;
        Mon, 23 Nov 2020 16:53:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 34y6k4s5rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 16:53:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANGrE8L61604252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 16:53:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB06BAE051;
        Mon, 23 Nov 2020 16:53:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AAD6AE04D;
        Mon, 23 Nov 2020 16:53:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 16:53:14 +0000 (GMT)
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH for v4.14] mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()
Date:   Mon, 23 Nov 2020 17:52:58 +0100
Message-Id: <20201123165258.80810-1-gerald.schaefer@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <1606124856217243@kroah.com>
References: <1606124856217243@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_14:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit bfe8cc1db02ab243c62780f17fc57f65bde0afe1 upstream.

Alexander reported a syzkaller / KASAN finding on s390, see below for
complete output.

In do_huge_pmd_anonymous_page(), the pre-allocated pagetable will be
freed in some cases.  In the case of userfaultfd_missing(), this will
happen after calling handle_userfault(), which might have released the
mmap_lock.  Therefore, the following pte_free(vma->vm_mm, pgtable) will
access an unstable vma->vm_mm, which could have been freed or re-used
already.

For all architectures other than s390 this will go w/o any negative
impact, because pte_free() simply frees the page and ignores the
passed-in mm.  The implementation for SPARC32 would also access
mm->page_table_lock for pte_free(), but there is no THP support in
SPARC32, so the buggy code path will not be used there.

For s390, the mm->context.pgtable_list is being used to maintain the 2K
pagetable fragments, and operating on an already freed or even re-used
mm could result in various more or less subtle bugs due to list /
pagetable corruption.

Fix this by calling pte_free() before handle_userfault(), similar to how
it is already done in __do_huge_pmd_anonymous_page() for the WRITE /
non-huge_zero_page case.

Commit 6b251fc96cf2c ("userfaultfd: call handle_userfault() for
userfaultfd_missing() faults") actually introduced both, the
do_huge_pmd_anonymous_page() and also __do_huge_pmd_anonymous_page()
changes wrt to calling handle_userfault(), but only in the latter case
it put the pte_free() before calling handle_userfault().

  BUG: KASAN: use-after-free in do_huge_pmd_anonymous_page+0xcda/0xd90 mm/huge_memory.c:744
  Read of size 8 at addr 00000000962d6988 by task syz-executor.0/9334

  CPU: 1 PID: 9334 Comm: syz-executor.0 Not tainted 5.10.0-rc1-syzkaller-07083-g4c9720875573 #0
  Hardware name: IBM 3906 M04 701 (KVM/Linux)
  Call Trace:
    do_huge_pmd_anonymous_page+0xcda/0xd90 mm/huge_memory.c:744
    create_huge_pmd mm/memory.c:4256 [inline]
    __handle_mm_fault+0xe6e/0x1068 mm/memory.c:4480
    handle_mm_fault+0x288/0x748 mm/memory.c:4607
    do_exception+0x394/0xae0 arch/s390/mm/fault.c:479
    do_dat_exception+0x34/0x80 arch/s390/mm/fault.c:567
    pgm_check_handler+0x1da/0x22c arch/s390/kernel/entry.S:706
    copy_from_user_mvcos arch/s390/lib/uaccess.c:111 [inline]
    raw_copy_from_user+0x3a/0x88 arch/s390/lib/uaccess.c:174
    _copy_from_user+0x48/0xa8 lib/usercopy.c:16
    copy_from_user include/linux/uaccess.h:192 [inline]
    __do_sys_sigaltstack kernel/signal.c:4064 [inline]
    __s390x_sys_sigaltstack+0xc8/0x240 kernel/signal.c:4060
    system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

  Allocated by task 9334:
    slab_alloc_node mm/slub.c:2891 [inline]
    slab_alloc mm/slub.c:2899 [inline]
    kmem_cache_alloc+0x118/0x348 mm/slub.c:2904
    vm_area_dup+0x9c/0x2b8 kernel/fork.c:356
    __split_vma+0xba/0x560 mm/mmap.c:2742
    split_vma+0xca/0x108 mm/mmap.c:2800
    mlock_fixup+0x4ae/0x600 mm/mlock.c:550
    apply_vma_lock_flags+0x2c6/0x398 mm/mlock.c:619
    do_mlock+0x1aa/0x718 mm/mlock.c:711
    __do_sys_mlock2 mm/mlock.c:738 [inline]
    __s390x_sys_mlock2+0x86/0xa8 mm/mlock.c:728
    system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

  Freed by task 9333:
    slab_free mm/slub.c:3142 [inline]
    kmem_cache_free+0x7c/0x4b8 mm/slub.c:3158
    __vma_adjust+0x7b2/0x2508 mm/mmap.c:960
    vma_merge+0x87e/0xce0 mm/mmap.c:1209
    userfaultfd_release+0x412/0x6b8 fs/userfaultfd.c:868
    __fput+0x22c/0x7a8 fs/file_table.c:281
    task_work_run+0x200/0x320 kernel/task_work.c:151
    tracehook_notify_resume include/linux/tracehook.h:188 [inline]
    do_notify_resume+0x100/0x148 arch/s390/kernel/signal.c:538
    system_call+0xe6/0x28c arch/s390/kernel/entry.S:416

  The buggy address belongs to the object at 00000000962d6948 which belongs to the cache vm_area_struct of size 200
  The buggy address is located 64 bytes inside of 200-byte region [00000000962d6948, 00000000962d6a10)
  The buggy address belongs to the page: page:00000000313a09fe refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x962d6 flags: 0x3ffff00000000200(slab)
  raw: 3ffff00000000200 000040000257e080 0000000c0000000c 000000008020ba00
  raw: 0000000000000000 000f001e00000000 ffffffff00000001 0000000096959501
  page dumped because: kasan: bad access detected
  page->mem_cgroup:0000000096959501

  Memory state around the buggy address:
   00000000962d6880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   00000000962d6900: 00 fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
  >00000000962d6980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                        ^
   00000000962d6a00: fb fb fc fc fc fc fc fc fc fc 00 00 00 00 00 00
   00000000962d6a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ==================================================================

Fixes: 6b251fc96cf2c ("userfaultfd: call handle_userfault() for userfaultfd_missing() faults")
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[4.3+]
Link: https://lkml.kernel.org/r/20201110190329.11920-1-gerald.schaefer@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
Changes for v4.14 stable:
  - Make it apply w/o
    * Commit 4cf58924951ef ("mm: treewide: remove unused address argument
      from pte_alloc functions")
    * Commit 2b7403035459c ("mm: Change return type int to vm_fault_t for
      fault handlers")
---
 mm/huge_memory.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 51068ef1dff5..5d9dd24d99c8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -688,7 +688,6 @@ int do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
 		struct page *zero_page;
-		bool set;
 		int ret;
 		pgtable = pte_alloc_one(vma->vm_mm, haddr);
 		if (unlikely(!pgtable))
@@ -701,25 +700,25 @@ int do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		}
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		ret = 0;
-		set = false;
 		if (pmd_none(*vmf->pmd)) {
 			ret = check_stable_address_space(vma->vm_mm);
 			if (ret) {
 				spin_unlock(vmf->ptl);
+				pte_free(vma->vm_mm, pgtable);
 			} else if (userfaultfd_missing(vma)) {
 				spin_unlock(vmf->ptl);
+				pte_free(vma->vm_mm, pgtable);
 				ret = handle_userfault(vmf, VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
 				set_huge_zero_page(pgtable, vma->vm_mm, vma,
 						   haddr, vmf->pmd, zero_page);
 				spin_unlock(vmf->ptl);
-				set = true;
 			}
-		} else
+		} else {
 			spin_unlock(vmf->ptl);
-		if (!set)
 			pte_free(vma->vm_mm, pgtable);
+		}
 		return ret;
 	}
 	gfp = alloc_hugepage_direct_gfpmask(vma);
-- 
2.17.1

