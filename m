Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D0E3CE45C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344045AbhGSPnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240971AbhGSPhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A237360FD7;
        Mon, 19 Jul 2021 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711484;
        bh=hDDzD76JYwZ7g0zfOG+sNBZgxh+bdim46FIsql9f0Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFMACrlq0yZjnEWrK6aBK+y0qEJ0tG3iHhwgrQSTokISkun5Mi9Px7+XeBQD3iu79
         OhLHJqKqtQ2tzkHwMgjmIpmUfV14XYghu4ajP7d1wFAnKuQa1KUhboy7Cvwfm4vNB5
         7XVseBPxDvdh3QbnmnAxZDpB2BqhOcO5ItpbffFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com,
        Joao Martins <joao.m.martins@oracle.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 020/292] mm/hugetlb: fix refs calculation from unaligned @vaddr
Date:   Mon, 19 Jul 2021 16:51:22 +0200
Message-Id: <20210719144943.196978800@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

commit d08af0a59684e18a51aa4bfd24c658994ea3fc5b upstream.

Commit 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording")
refactored the count of subpages but missed an edge case when @vaddr is
not aligned to PAGE_SIZE e.g.  when close to vma->vm_end.  It would then
errousnly set @refs to 0 and record_subpages_vmas() wouldn't set the
@pages array element to its value, consequently causing the reported
null-deref by syzbot.

Fix it by aligning down @vaddr by PAGE_SIZE in @refs calculation.

Link: https://lkml.kernel.org/r/20210713152440.28650-1-joao.m.martins@oracle.com
Fixes: 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording")
Reported-by: syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5029,8 +5029,9 @@ long follow_hugetlb_page(struct mm_struc
 			continue;
 		}
 
-		refs = min3(pages_per_huge_page(h) - pfn_offset,
-			    (vma->vm_end - vaddr) >> PAGE_SHIFT, remainder);
+		/* vaddr may not be aligned to PAGE_SIZE */
+		refs = min3(pages_per_huge_page(h) - pfn_offset, remainder,
+		    (vma->vm_end - ALIGN_DOWN(vaddr, PAGE_SIZE)) >> PAGE_SHIFT);
 
 		if (pages || vmas)
 			record_subpages_vmas(mem_map_offset(page, pfn_offset),


