Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9514A2D9FDD
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408868AbgLNTBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502222AbgLNRh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:29 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Zixian <liuzixian4@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Hongxiang Lou <louhongxiang@huawei.com>,
        Hu Shiyuan <hushiyuan@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 037/105] mm/mmap.c: fix mmap return value when vma is merged after call_mmap()
Date:   Mon, 14 Dec 2020 18:28:11 +0100
Message-Id: <20201214172557.067288162@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Zixian <liuzixian4@huawei.com>

[ Upstream commit 309d08d9b3a3659ab3f239d27d4e38b670b08fc9 ]

On success, mmap should return the begin address of newly mapped area,
but patch "mm: mmap: merge vma after call_mmap() if possible" set
vm_start of newly merged vma to return value addr.  Users of mmap will
get wrong address if vma is merged after call_mmap().  We fix this by
moving the assignment to addr before merging vma.

We have a driver which changes vm_flags, and this bug is found by our
testcases.

Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Link: https://lkml.kernel.org/r/20201203085350.22624-1-liuzixian4@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7a8987aa69962..c85a2875a9625 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1774,6 +1774,17 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
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
@@ -1788,25 +1799,12 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
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
2.27.0



