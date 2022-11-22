Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9C06336F4
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 09:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiKVIZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 03:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiKVIZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 03:25:16 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CF740441;
        Tue, 22 Nov 2022 00:25:07 -0800 (PST)
Received: from localhost.localdomain (unknown [39.45.241.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id D200E6602A89;
        Tue, 22 Nov 2022 08:25:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1669105505;
        bh=8UqUmiJ6AjGUWkeqighSLul+GOLZRjtMltLqZjflXsc=;
        h=From:To:Cc:Subject:Date:From;
        b=AsNLV8YX3qAXSS0anyE4EqPtYVtZzdg8B+5EvcSjIJyBeJxXyDfx6bIDhxT3SBBlW
         khbaUPmxJ1+bESaslS4c54pcP3Dh61CcUxZCciyv56J0QzV+KEDg1Q+EvDSmujyIQj
         f8Nwg5Wlo27fKaeSBoGbT0x6aTwTFVtcbB8m81S3VW60ydTsix5W7QckVWiAuBnCx1
         jPqzn8Luqok8D3HgH0fRkKBX+ZoIGX7dtPJk/zqrCSu49ikeDVB4xITbjULePLBc6r
         HiyViM5abEa6zA9V6AJ/ZaV2B7JSqUCd9MO6V0r8hmg4jz8+nkx7u7PeBx/QAOqeCk
         C9y1I4Ah28YRg==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Cc:     Mel Gorman <mgorman@suse.de>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: set the vma flags dirty before testing if it is mergeable
Date:   Tue, 22 Nov 2022 13:24:41 +0500
Message-Id: <20221122082442.1938606-1-usama.anjum@collabora.com>
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
---
 mm/mmap.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f9b96b387a6f..6934b8f61fdc 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1708,6 +1708,15 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
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
 	/*
 	 * Can we just expand an old mapping?
 	 */
@@ -1823,15 +1832,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
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
 
 	return addr;
@@ -2998,6 +2998,8 @@ static int do_brk_flags(unsigned long addr, unsigned long len, unsigned long fla
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
+	flags |= VM_SOFTDIRTY;
+
 	/* Can we just expand an old private anonymous mapping? */
 	vma = vma_merge(mm, prev, addr, addr + len, flags,
 			NULL, NULL, pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
@@ -3026,7 +3028,6 @@ static int do_brk_flags(unsigned long addr, unsigned long len, unsigned long fla
 	mm->data_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
-	vma->vm_flags |= VM_SOFTDIRTY;
 	return 0;
 }
 
-- 
2.30.2

