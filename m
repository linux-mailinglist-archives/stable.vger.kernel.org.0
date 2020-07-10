Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF2921ABF3
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 02:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgGJAXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 20:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgGJAXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 20:23:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E66BD20708;
        Fri, 10 Jul 2020 00:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594340629;
        bh=1F9qqVsD9dsJ7gmFOjPvCbPGlZYEuq7lSE/GfL0I/1c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WlKDsWMwqoAbjHMbemIqG370UBwjCY/lH/jldNHnYQspESnFgPTLzC/rnamOytCyE
         GIqg1luObQp+OfNfGkHptHnMorPcDhfwM5u5UjTWneWEWHfURYOsWRapTYZ+5p2fBj
         98Zojt/ir69yTEkbeDfTNzpbKoeCGp7NLZXg1xww=
Date:   Thu, 09 Jul 2020 17:23:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jannh@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  +
 mm-close-race-between-munmap-and-expand_upwards-downwards.patch added to
 -mm tree
Message-ID: <20200710002348.apRnH6OHT%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: close race between munmap() and expand_upwards()/downwards()
has been added to the -mm tree.  Its filename is
     mm-close-race-between-munmap-and-expand_upwards-downwards.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-close-race-between-munmap-and-expand_upwards-downwards.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-close-race-between-munmap-and-expand_upwards-downwards.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/mmap.c: close race between munmap() and expand_upwards()/downwards()

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

Link: http://lkml.kernel.org/r/20200709105309.42495-1-kirill.shutemov@linux.intel.com
Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Jann Horn <jannh@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-close-race-between-munmap-and-expand_upwards-downwards
+++ a/mm/mmap.c
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
+	 * Do not downgrade mmap_sem if we are next to VM_GROWSDOWN or
+	 * VM_GROWSUP VMA. Such VMAs can change their size under
+	 * down_read(mmap_sem) and collide with the VMA we are about to unmap.
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
 		mmap_write_downgrade(mm);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-close-race-between-munmap-and-expand_upwards-downwards.patch

