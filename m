Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD8322F19A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbgG0OSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbgG0OSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992EC2070A;
        Mon, 27 Jul 2020 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859481;
        bh=6rrJ4vF0KkOU6fgx8VcLlGCgvhfHnsigbaZGsxfaHaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Go7Bi6U2igMkDFDUgkc+qgrrJPttQEacVoR+swfDqMUXqtD67/64oZWMZTmGKL8bj
         IslHqP3UkQ0E2l757VI+83Kgi2VKEh4fFhFL41dhaun5RViSJrYxlkLqKttJCKrSvq
         LF6jRJ8Xk+a5KIYYIFPVChVhP4oyQEskLxex9qN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 125/138] khugepaged: fix null-pointer dereference due to race
Date:   Mon, 27 Jul 2020 16:05:20 +0200
Message-Id: <20200727134931.680601862@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit 594cced14ad3903166c8b091ff96adac7552f0b3 upstream.

khugepaged has to drop mmap lock several times while collapsing a page.
The situation can change while the lock is dropped and we need to
re-validate that the VMA is still in place and the PMD is still subject
for collapse.

But we miss one corner case: while collapsing an anonymous pages the VMA
could be replaced with file VMA.  If the file VMA doesn't have any
private pages we get NULL pointer dereference:

	general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
	KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
	anon_vma_lock_write include/linux/rmap.h:120 [inline]
	collapse_huge_page mm/khugepaged.c:1110 [inline]
	khugepaged_scan_pmd mm/khugepaged.c:1349 [inline]
	khugepaged_scan_mm_slot mm/khugepaged.c:2110 [inline]
	khugepaged_do_scan mm/khugepaged.c:2193 [inline]
	khugepaged+0x3bba/0x5a10 mm/khugepaged.c:2238

The fix is to make sure that the VMA is anonymous in
hugepage_vma_revalidate().  The helper is only used for collapsing
anonymous pages.

Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Reported-by: syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200722121439.44328-1-kirill.shutemov@linux.intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/khugepaged.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -876,6 +876,9 @@ static int hugepage_vma_revalidate(struc
 		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
+	/* Anon VMA expected */
+	if (!vma->anon_vma || vma->vm_ops)
+		return SCAN_VMA_CHECK;
 	return 0;
 }
 


