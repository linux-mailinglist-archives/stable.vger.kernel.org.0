Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76351A651
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349717AbiEDQzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354421AbiEDQyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B9F48E57;
        Wed,  4 May 2022 09:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F0D617A5;
        Wed,  4 May 2022 16:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70341C385A4;
        Wed,  4 May 2022 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682969;
        bh=DKYLV+LZxiUOMb7u0bnXMz4p/6ql4ov5ZJDiPdMji7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4u4leVXQXS1chPChhgAZmGOVDqRekV8unfxn9NkAFxr6dwHZsvTL5pzOa3c5lZ+G
         jFITvSYcSi+f0mTjGT+xz30Qsmau5e/w2BxgEQwISzX98PESh+Z1x/ZojSVVspjnYr
         Rp3UF/ime+eVsLLzUdWUjqPoAqe3drkmbo/ffACk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Shijie Hu <hushijie3@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will@kernel.org>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        yangerkun <yangerkun@huawei.com>, ChenGang <cg.chen@huawei.com>,
        Chen Jie <chenjie6@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 5.4 83/84] hugetlbfs: get unmapped area below TASK_UNMAPPED_BASE for hugetlbfs
Date:   Wed,  4 May 2022 18:45:04 +0200
Message-Id: <20220504152934.001472741@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shijie Hu <hushijie3@huawei.com>

commit 885902531586d5a20a74099c1357bfdc982befe3 upstream.

In a 32-bit program, running on arm64 architecture.  When the address
space below mmap base is completely exhausted, shmat() for huge pages will
return ENOMEM, but shmat() for normal pages can still success on no-legacy
mode.  This seems not fair.

For normal pages, the calling trace of get_unmapped_area() is:

	=> mm->get_unmapped_area()
	if on legacy mode,
		=> arch_get_unmapped_area()
			=> vm_unmapped_area()
	if on no-legacy mode,
		=> arch_get_unmapped_area_topdown()
			=> vm_unmapped_area()

For huge pages, the calling trace of get_unmapped_area() is:

	=> file->f_op->get_unmapped_area()
		=> hugetlb_get_unmapped_area()
			=> vm_unmapped_area()

To solve this issue, we only need to make hugetlb_get_unmapped_area() take
the same way as mm->get_unmapped_area().  Add *bottomup() and *topdown()
for hugetlbfs, and check current mm->get_unmapped_area() to decide which
one to use.  If mm->get_unmapped_area is equal to
arch_get_unmapped_area_topdown(), hugetlb_get_unmapped_area() calls
topdown routine, otherwise calls bottomup routine.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Shijie Hu <hushijie3@huawei.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: yangerkun <yangerkun@huawei.com>
Cc: ChenGang <cg.chen@huawei.com>
Cc: Chen Jie <chenjie6@huawei.com>
Link: http://lkml.kernel.org/r/20200518065338.113664-1-hushijie3@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |   67 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 8 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -38,6 +38,7 @@
 #include <linux/uio.h>
 
 #include <linux/uaccess.h>
+#include <linux/sched/mm.h>
 
 static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
@@ -201,13 +202,60 @@ out:
 
 #ifndef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 static unsigned long
+hugetlb_get_unmapped_area_bottomup(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
+
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = current->mm->mmap_base;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
+}
+
+static unsigned long
+hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
+
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.high_limit = current->mm->mmap_base;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	addr = vm_unmapped_area(&info);
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	if (unlikely(offset_in_page(addr))) {
+		VM_BUG_ON(addr != -ENOMEM);
+		info.flags = 0;
+		info.low_limit = current->mm->mmap_base;
+		info.high_limit = TASK_SIZE;
+		addr = vm_unmapped_area(&info);
+	}
+
+	return addr;
+}
+
+static unsigned long
 hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -228,13 +276,16 @@ hugetlb_get_unmapped_area(struct file *f
 			return addr;
 	}
 
-	info.flags = 0;
-	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
-	info.high_limit = TASK_SIZE;
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
-	return vm_unmapped_area(&info);
+	/*
+	 * Use mm->get_unmapped_area value as a hint to use topdown routine.
+	 * If architectures have special needs, they should define their own
+	 * version of hugetlb_get_unmapped_area.
+	 */
+	if (mm->get_unmapped_area == arch_get_unmapped_area_topdown)
+		return hugetlb_get_unmapped_area_topdown(file, addr, len,
+				pgoff, flags);
+	return hugetlb_get_unmapped_area_bottomup(file, addr, len,
+			pgoff, flags);
 }
 #endif
 


