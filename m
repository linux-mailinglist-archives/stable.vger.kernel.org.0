Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3741633BC6
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 12:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiKVLuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 06:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiKVLuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 06:50:32 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE6726130;
        Tue, 22 Nov 2022 03:50:29 -0800 (PST)
Received: from localhost.localdomain (unknown [39.45.241.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id AB5516602AD8;
        Tue, 22 Nov 2022 11:50:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1669117828;
        bh=u3h8sO+dj4QZ9RGvdJiydoYM2ps78IAv/+HQGYXP/5A=;
        h=From:To:Cc:Subject:Date:From;
        b=XJensu8BWSPD1vRHzW+fu3abtZIDrOqa2RwLq+uZbtFY5+JOVit49UouoYycp2iuS
         l2oJzKgs3Q2Sd83TCS3knOSU9EqZdG6GMikI//LRw6CtImSCyoBClNA5NpbP8i2qLc
         dG16XQH1yctTwxgCxMe2U/FtV7LSnn45byMOyYZFOs9I37Zu41/a/FAr5aoY7NMa62
         9JiqqKyNADeVLjxvhRblG2GkuUhPUr97kMGmCRnSlf+4+50faMQuRD/1SnM3n813IL
         sUgI2tuj4QpclGFA2SDmCZPueIeJwJUyz1SWY/GLptXGITvdWPlu+2AOSfgUPBTEgG
         xN7cQZFkSyFIw==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Cc:     Mel Gorman <mgorman@suse.de>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: set the vma flags dirty before testing if it is mergeable
Date:   Tue, 22 Nov 2022 16:50:07 +0500
Message-Id: <20221122115007.2787017-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The VM_SOFTDIRTY should be set in the vma flags to be tested if new
allocation should be merged in previous vma or not. With this patch,
the new allocations are merged in the previous VMAs.

I've tested it by reverting the commit 34228d473efe ("mm: ignore
VM_SOFTDIRTY on VMA merging") and after adding this following patch,
I'm seeing that all the new allocations done through mmap() are merged
in the previous VMAs. The number of VMAs doesn't increase drastically
which had contributed to the crash of gimp. If I run the same test after
reverting and not including this patch, the number of VMAs keep on
increasing with every mmap() syscall which proves this patch.

The commit 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
seems like a workaround. But it lets the soft-dirty and non-soft-dirty
VMA to get merged. It helps in avoiding the creation of too many VMAs.
But it creates the problem while adding the feature of clearing the
soft-dirty status of only a part of the memory region.

Cc: <stable@vger.kernel.org>
Fixes: d9104d1ca966 ("mm: track vma changes with VM_SOFTDIRTY bit")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
We need more testing of this patch.

While implementing clear soft-dirty bit for a range of address space, I'm
facing an issue. The non-soft dirty VMA gets merged sometimes with the soft
dirty VMA. Thus the non-soft dirty VMA become dirty which is undesirable.
When discussed with the some other developers they consider it the
regression. Why the non-soft dirty page should appear as soft dirty when it
isn't soft dirty in reality? I agree with them. Should we revert
34228d473efe or find a workaround in the IOCTL?

* Revert may cause the VMAs to expand in uncontrollable situation where the
soft dirty bit of a lot of memory regions or the whole address space is
being cleared again and again. AFAIK normal process must either be only
clearing a few memory regions. So the applications should be okay. There is
still chance of regressions if some applications are already using the
soft-dirty bit. I'm not sure how to test it.

* Add a flag in the IOCTL to ignore the dirtiness of VMA. The user will
surely lose the functionality to detect reused memory regions. But the
extraneous soft-dirty pages would not appear. I'm trying to do this in the
patch series [1]. Some discussion is going on that this fails with some
mprotect use case [2]. I still need to have a look at the mprotect selftest
to see how and why this fails. I think this can be implemented after some
more work probably in mprotect side.

[1] https://lore.kernel.org/all/20221109102303.851281-1-usama.anjum@collabora.com/
[2] https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/

Changes in v2:
- Rebase on top of next-20221122
---
 mm/mmap.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f4e2989be5ff..031d23bc43c4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2552,6 +2552,15 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		vm_flags |= VM_ACCOUNT;
 	}
 
+	/*
+	 * New (or expanded) vma always get soft dirty status.
+	 * Otherwise user-space soft-dirty page tracker won't
+	 * be able to distinguish situation when vma area unmapped,
+	 * then new mapped in-place (which must be aimed as
+	 * a completely new data area).
+	 */
+	vm_flags |= VM_SOFTDIRTY;
+
 	next = mas_next(&mas, ULONG_MAX);
 	prev = mas_prev(&mas, 0);
 	if (vm_flags & VM_SPECIAL)
@@ -2724,15 +2733,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	if (file)
 		uprobe_mmap(vma);
 
-	/*
-	 * New (or expanded) vma always get soft dirty status.
-	 * Otherwise user-space soft-dirty page tracker won't
-	 * be able to distinguish situation when vma area unmapped,
-	 * then new mapped in-place (which must be aimed as
-	 * a completely new data area).
-	 */
-	vma->vm_flags |= VM_SOFTDIRTY;
-
 	vma_set_page_prot(vma);
 
 	validate_mm(mm);
@@ -2974,7 +2974,7 @@ static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *vma,
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 	vma->vm_pgoff = addr >> PAGE_SHIFT;
-	vma->vm_flags = flags;
+	vma->vm_flags = flags | VM_SOFTDIRTY;
 	vma->vm_page_prot = vm_get_page_prot(flags);
 	mas_set_range(mas, vma->vm_start, addr + len - 1);
 	if (mas_store_gfp(mas, vma, GFP_KERNEL))
@@ -2987,7 +2987,6 @@ static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *vma,
 	mm->data_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
-	vma->vm_flags |= VM_SOFTDIRTY;
 	validate_mm(mm);
 	return 0;
 
@@ -3021,6 +3020,8 @@ int vm_brk_flags(unsigned long addr, unsigned long request, unsigned long flags)
 	if ((flags & (~VM_EXEC)) != 0)
 		return -EINVAL;
 
+	flags |= VM_SOFTDIRTY;
+
 	ret = check_brk_limits(addr, len);
 	if (ret)
 		goto limits_failed;
-- 
2.30.2

