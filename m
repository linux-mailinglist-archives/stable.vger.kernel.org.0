Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7F32E7F0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEMYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhCEMXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F2164F23;
        Fri,  5 Mar 2021 12:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947019;
        bh=BM/hZWzOBeGsgw1d+sQ2xPgqAemo6Qb3dBRV9fFGy98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2igjQGSACPwLWVI2jYK6XpG/7WMw+2sPIKmHzqDYglK31mngMdwa3KdulZj5dnMWh
         3ApOgmEu0Icjn1A6CWDHeMpRccPEg6bQ2MNsHytxDms5wpsmJn/AeQ41q9xy/63bku
         3shJJg9Wj/DxEDRgWUtaDOM1Qwm0Iy3qFEPs1kL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Xinhai <lixinhai.lxh@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 019/104] mm/hugetlb.c: fix unnecessary address expansion of pmd sharing
Date:   Fri,  5 Mar 2021 13:20:24 +0100
Message-Id: <20210305120904.117640678@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Xinhai <lixinhai.lxh@gmail.com>

commit a1ba9da8f0f9a37d900ff7eff66482cf7de8015e upstream.

The current code would unnecessarily expand the address range.  Consider
one example, (start, end) = (1G-2M, 3G+2M), and (vm_start, vm_end) =
(1G-4M, 3G+4M), the expected adjustment should be keep (1G-2M, 3G+2M)
without expand.  But the current result will be (1G-4M, 3G+4M).  Actually,
the range (1G-4M, 1G) and (3G, 3G+4M) would never been involved in pmd
sharing.

After this patch, we will check that the vma span at least one PUD aligned
size and the start,end range overlap the aligned range of vma.

With above example, the aligned vma range is (1G, 3G), so if (start, end)
range is within (1G-4M, 1G), or within (3G, 3G+4M), then no adjustment to
both start and end.  Otherwise, we will have chance to adjust start
downwards or end upwards without exceeding (vm_start, vm_end).

Mike:

: The 'adjusted range' is used for calls to mmu notifiers and cache(tlb)
: flushing.  Since the current code unnecessarily expands the range in some
: cases, more entries than necessary would be flushed.  This would/could
: result in performance degradation.  However, this is highly dependent on
: the user runtime.  Is there a combination of vma layout and calls to
: actually hit this issue?  If the issue is hit, will those entries
: unnecessarily flushed be used again and need to be unnecessarily reloaded?

Link: https://lkml.kernel.org/r/20210104081631.2921415-1-lixinhai.lxh@gmail.com
Fixes: 75802ca66354 ("mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5304,21 +5304,23 @@ static bool vma_shareable(struct vm_area
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long a_start, a_end;
+	unsigned long v_start = ALIGN(vma->vm_start, PUD_SIZE),
+		v_end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
 
-	if (!(vma->vm_flags & VM_MAYSHARE))
+	/*
+	 * vma need span at least one aligned PUD size and the start,end range
+	 * must at least partialy within it.
+	 */
+	if (!(vma->vm_flags & VM_MAYSHARE) || !(v_end > v_start) ||
+		(*end <= v_start) || (*start >= v_end))
 		return;
 
 	/* Extend the range to be PUD aligned for a worst case scenario */
-	a_start = ALIGN_DOWN(*start, PUD_SIZE);
-	a_end = ALIGN(*end, PUD_SIZE);
+	if (*start > v_start)
+		*start = ALIGN_DOWN(*start, PUD_SIZE);
 
-	/*
-	 * Intersect the range with the vma range, since pmd sharing won't be
-	 * across vma after all
-	 */
-	*start = max(vma->vm_start, a_start);
-	*end = min(vma->vm_end, a_end);
+	if (*end < v_end)
+		*end = ALIGN(*end, PUD_SIZE);
 }
 
 /*


