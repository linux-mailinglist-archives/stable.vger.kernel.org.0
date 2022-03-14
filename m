Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF0C4D8438
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbiCNMXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbiCNMTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:19:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDC650062;
        Mon, 14 Mar 2022 05:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C761DB80D24;
        Mon, 14 Mar 2022 12:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E7DC340E9;
        Mon, 14 Mar 2022 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260091;
        bh=vBP/YxaUzrVlJHfNwkewHyeHTb6r0DcQuvfBndlKXP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u34oGR4TL61N1+gzBHQ92WLDzdPfI4ib7lUBI73QgPl8f6XrhTlNt3DVUVtGV/4Z0
         +7M1WmZ00G4oyBHH7+6qAAaCiKl2p6NRRs68bdWM3nGQCQBwl9/cHMd4j7jBaaU/p/
         2wpvIIEWgX/RnGzfuPSzMOvd3hcEfEwTKdhjSbOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.16 053/121] mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
Date:   Mon, 14 Mar 2022 12:53:56 +0100
Message-Id: <20220314112745.606855263@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit fe673d3f5bf1fc50cdc4b754831db91a2ec10126 ]

Instead of using GUP, make fault_in_safe_writeable() actually force a
'handle_mm_fault()' using the same fixup_user_fault() machinery that
futexes already use.

Using the GUP machinery meant that fault_in_safe_writeable() did not do
everything that a real fault would do, ranging from not auto-expanding
the stack segment, to not updating accessed or dirty flags in the page
tables (GUP sets those flags on the pages themselves).

The latter causes problems on architectures (like s390) that do accessed
bit handling in software, which meant that fault_in_safe_writeable()
didn't actually do all the fault handling it needed to, and trying to
access the user address afterwards would still cause faults.

Reported-and-tested-by: Andreas Gruenbacher <agruenba@redhat.com>
Fixes: cdd591fc86e3 ("iov_iter: Introduce fault_in_iov_iter_writeable")
Link: https://lore.kernel.org/all/CAHc6FU5nP+nziNGG0JAF1FUx-GV7kKFvM7aZuU_XD2_1v4vnvg@mail.gmail.com/
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 57 +++++++++++++++++++-------------------------------------
 1 file changed, 19 insertions(+), 38 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 37087529bb95..b7e5e80538c9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1723,11 +1723,11 @@ EXPORT_SYMBOL(fault_in_writeable);
  * @uaddr: start of address range
  * @size: length of address range
  *
- * Faults in an address range using get_user_pages, i.e., without triggering
- * hardware page faults.  This is primarily useful when we already know that
- * some or all of the pages in the address range aren't in memory.
+ * Faults in an address range for writing.  This is primarily useful when we
+ * already know that some or all of the pages in the address range aren't in
+ * memory.
  *
- * Other than fault_in_writeable(), this function is non-destructive.
+ * Unlike fault_in_writeable(), this function is non-destructive.
  *
  * Note that we don't pin or otherwise hold the pages referenced that we fault
  * in.  There's no guarantee that they'll stay in memory for any duration of
@@ -1738,46 +1738,27 @@ EXPORT_SYMBOL(fault_in_writeable);
  */
 size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
 {
-	unsigned long start = (unsigned long)untagged_addr(uaddr);
-	unsigned long end, nstart, nend;
+	unsigned long start = (unsigned long)uaddr, end;
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = NULL;
-	int locked = 0;
+	bool unlocked = false;
 
-	nstart = start & PAGE_MASK;
+	if (unlikely(size == 0))
+		return 0;
 	end = PAGE_ALIGN(start + size);
-	if (end < nstart)
+	if (end < start)
 		end = 0;
-	for (; nstart != end; nstart = nend) {
-		unsigned long nr_pages;
-		long ret;
 
-		if (!locked) {
-			locked = 1;
-			mmap_read_lock(mm);
-			vma = find_vma(mm, nstart);
-		} else if (nstart >= vma->vm_end)
-			vma = vma->vm_next;
-		if (!vma || vma->vm_start >= end)
-			break;
-		nend = end ? min(end, vma->vm_end) : vma->vm_end;
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
-			continue;
-		if (nstart < vma->vm_start)
-			nstart = vma->vm_start;
-		nr_pages = (nend - nstart) / PAGE_SIZE;
-		ret = __get_user_pages_locked(mm, nstart, nr_pages,
-					      NULL, NULL, &locked,
-					      FOLL_TOUCH | FOLL_WRITE);
-		if (ret <= 0)
+	mmap_read_lock(mm);
+	do {
+		if (fixup_user_fault(mm, start, FAULT_FLAG_WRITE, &unlocked))
 			break;
-		nend = nstart + ret * PAGE_SIZE;
-	}
-	if (locked)
-		mmap_read_unlock(mm);
-	if (nstart == end)
-		return 0;
-	return size - min_t(size_t, nstart - start, size);
+		start = (start + PAGE_SIZE) & PAGE_MASK;
+	} while (start != end);
+	mmap_read_unlock(mm);
+
+	if (size > (unsigned long)uaddr - start)
+		return size - ((unsigned long)uaddr - start);
+	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);
 
-- 
2.34.1



