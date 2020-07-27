Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A122F08A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732433AbgG0OZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732431AbgG0OZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:25:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55881207FC;
        Mon, 27 Jul 2020 14:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859925;
        bh=9Qcp3FSel9atNIpCQ+TYVISgopa85/qqx+u7nEV1sU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTLYdjFio/BIuezEJhypbMIpXFhTLwoGs8J0qi7nXlkZggqRyOFZRsnNrcuLuqIzf
         gXDCJ49MoHkKG6nTNFRFAkBatnj3kPBD3P3X2UnZMIrauHO3ClbiRi25J0OkX0kG/7
         PAPBnC1FS/2jm6zdrG30zF9nQYFycD+tg8Zbbq1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 159/179] mm/mmap.c: close race between munmap() and expand_upwards()/downwards()
Date:   Mon, 27 Jul 2020 16:05:34 +0200
Message-Id: <20200727134940.418084921@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit 246c320a8cfe0b11d81a4af38fa9985ef0cc9a4c upstream.

VMA with VM_GROWSDOWN or VM_GROWSUP flag set can change their size under
mmap_read_lock().  It can lead to race with __do_munmap():

	Thread A			Thread B
__do_munmap()
  detach_vmas_to_be_unmapped()
  mmap_write_downgrade()
				expand_downwards()
				  vma->vm_start = address;
				  // The VMA now overlaps with
				  // VMAs detached by the Thread A
				// page fault populates expanded part
				// of the VMA
  unmap_region()
    // Zaps pagetables partly
    // populated by Thread B

Similar race exists for expand_upwards().

The fix is to avoid downgrading mmap_lock in __do_munmap() if detached
VMAs are next to VM_GROWSDOWN or VM_GROWSUP VMA.

[akpm@linux-foundation.org: s/mmap_sem/mmap_lock/ in comment]

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>	[4.20+]
Link: http://lkml.kernel.org/r/20200709105309.42495-1-kirill.shutemov@linux.intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmap.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2620,7 +2620,7 @@ static void unmap_region(struct mm_struc
  * Create a list of vma's touched by the unmap, removing them from the mm's
  * vma list as we go..
  */
-static void
+static bool
 detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct vm_area_struct *prev, unsigned long end)
 {
@@ -2645,6 +2645,17 @@ detach_vmas_to_be_unmapped(struct mm_str
 
 	/* Kill the cache */
 	vmacache_invalidate(mm);
+
+	/*
+	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
+	 * VM_GROWSUP VMA. Such VMAs can change their size under
+	 * down_read(mmap_lock) and collide with the VMA we are about to unmap.
+	 */
+	if (vma && (vma->vm_flags & VM_GROWSDOWN))
+		return false;
+	if (prev && (prev->vm_flags & VM_GROWSUP))
+		return false;
+	return true;
 }
 
 /*
@@ -2825,7 +2836,8 @@ int __do_munmap(struct mm_struct *mm, un
 	}
 
 	/* Detach vmas from rbtree */
-	detach_vmas_to_be_unmapped(mm, vma, prev, end);
+	if (!detach_vmas_to_be_unmapped(mm, vma, prev, end))
+		downgrade = false;
 
 	if (downgrade)
 		downgrade_write(&mm->mmap_sem);


