Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD2B2CD1E0
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 09:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgLCIym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 03:54:42 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8234 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387559AbgLCIyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 03:54:41 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CmqPG57Hgzkj4W;
        Thu,  3 Dec 2020 16:53:22 +0800 (CST)
Received: from huawei.com (10.174.176.134) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 16:53:50 +0800
From:   Liu Zixian <liuzixian4@huawei.com>
To:     <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
        <louhongxiang@huawei.com>, <linux-mm@kvack.org>,
        <liuzixian4@huawei.com>
CC:     <hushiyuan@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] fix mmap return value when vma is merged after call_mmap()
Date:   Thu, 3 Dec 2020 16:53:50 +0800
Message-ID: <20201203085350.22624-1-liuzixian4@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.176.134]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On success, mmap should return the begin address of newly mapped area,
but patch "mm: mmap: merge vma after call_mmap() if possible"
set vm_start of newly merged vma to return value addr.
Users of mmap will get wrong address if vma is merged after call_mmap().
We fix this by moving the assignment to addr before merging vma.

Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
---
v2:
We want to do "addr = vma->vm_start;" unconditionally,
so move assignment to addr before if(unlikely) block.
---
 mm/mmap.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index d91ecb00d38c..5c8b4485860d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1808,6 +1808,17 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		if (error)
 			goto unmap_and_free_vma;
 
+		/* Can addr have changed??
+		 *
+		 * Answer: Yes, several device drivers can do it in their
+		 *         f_op->mmap method. -DaveM
+		 * Bug: If addr is changed, prev, rb_link, rb_parent should
+		 *      be updated for vma_link()
+		 */
+		WARN_ON_ONCE(addr != vma->vm_start);
+
+		addr = vma->vm_start;
+
 		/* If vm_flags changed after call_mmap(), we should try merge vma again
 		 * as we may succeed this time.
 		 */
@@ -1822,25 +1833,12 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 				fput(vma->vm_file);
 				vm_area_free(vma);
 				vma = merge;
-				/* Update vm_flags and possible addr to pick up the change. We don't
-				 * warn here if addr changed as the vma is not linked by vma_link().
-				 */
-				addr = vma->vm_start;
+				/* Update vm_flags to pick up the change. */
 				vm_flags = vma->vm_flags;
 				goto unmap_writable;
 			}
 		}
 
-		/* Can addr have changed??
-		 *
-		 * Answer: Yes, several device drivers can do it in their
-		 *         f_op->mmap method. -DaveM
-		 * Bug: If addr is changed, prev, rb_link, rb_parent should
-		 *      be updated for vma_link()
-		 */
-		WARN_ON_ONCE(addr != vma->vm_start);
-
-		addr = vma->vm_start;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
-- 
2.23.0

