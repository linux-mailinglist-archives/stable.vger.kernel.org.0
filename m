Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D631B1B27
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 03:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgDUBOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 21:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgDUBOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 21:14:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB872084D;
        Tue, 21 Apr 2020 01:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587431645;
        bh=XvvXYonhZa0GL7oNOaC6GQTL4SXqNbNVKkNSPVERfz8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UfuFVdB62BFJUA6wHf2TWYYW5TzPle+mkq3u4X2GuVaubI+7x6nr7XiVK1yM9gtnc
         Bbd7WQP+YpkP9bbDaduB0hqgCRfT0vgzwFk86XuWNeFNsx9fbUNXBKRJF7BQGVVpTc
         kSXH3mhljMmCbgHl2Doi09QfHtlt4G6FsefDqgN4=
Date:   Mon, 20 Apr 2020 18:14:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        duanxiongchun@bytedance.com, hughd@google.com,
        imbrenda@linux.vnet.ibm.com, ktkhai@virtuozzo.com,
        linux-mm@kvack.org, Markus.Elfring@web.de,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 09/15] mm/ksm: fix NULL pointer dereference when
 KSM zero page is enabled
Message-ID: <20200421011404.KWPZupAdk%akpm@linux-foundation.org>
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/ksm: fix NULL pointer dereference when KSM zero page is enabled

find_mergeable_vma() can return NULL.  In this case, it leads to a crash
when we access vm_mm(its offset is 0x40) later in write_protect_page.  And
this case did happen on our server.  The following call trace is captured
in kernel 4.19 with the following patch applied and KSM zero page enabled
on our server.

  commit e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")

So add a vma check to fix it.

--------------------------------------------------------------------------
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
  Oops: 0000 [#1] SMP NOPTI
  CPU: 9 PID: 510 Comm: ksmd Kdump: loaded Tainted: G OE 4.19.36.bsk.9-amd64 #4.19.36.bsk.9
  RIP: 0010:try_to_merge_one_page+0xc7/0x760
  Code: 24 58 65 48 33 34 25 28 00 00 00 89 e8 0f 85 a3 06 00 00 48 83 c4
        60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 46 08 a8 01 75 b8 <49>
        8b 44 24 40 4c 8d 7c 24 20 b9 07 00 00 00 4c 89 e6 4c 89 ff 48
  RSP: 0018:ffffadbdd9fffdb0 EFLAGS: 00010246
  RAX: ffffda83ffd4be08 RBX: ffffda83ffd4be40 RCX: 0000002c6e800000
  RDX: 0000000000000000 RSI: ffffda83ffd4be40 RDI: 0000000000000000
  RBP: ffffa11939f02ec0 R08: 0000000094e1a447 R09: 00000000abe76577
  R10: 0000000000000962 R11: 0000000000004e6a R12: 0000000000000000
  R13: ffffda83b1e06380 R14: ffffa18f31f072c0 R15: ffffda83ffd4be40
  FS: 0000000000000000(0000) GS:ffffa0da43b80000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000040 CR3: 0000002c77c0a003 CR4: 00000000007626e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
    ? follow_page_pte+0x36d/0x5e0
    ksm_scan_thread+0x115e/0x1960
    ? remove_wait_queue+0x60/0x60
    kthread+0xf5/0x130
    ? try_to_merge_with_ksm_page+0x90/0x90
    ? kthread_create_worker_on_cpu+0x70/0x70
    ret_from_fork+0x1f/0x30
--------------------------------------------------------------------------

[songmuchun@bytedance.com: if the vma is out of date, just exit]
  Link: http://lkml.kernel.org/r/20200416025034.29780-1-songmuchun@bytedance.com
[akpm@linux-foundation.org: add the conventional braces, replace /** with /*]
Link: http://lkml.kernel.org/r/20200416025034.29780-1-songmuchun@bytedance.com
Link: http://lkml.kernel.org/r/20200414132905.83819-1-songmuchun@bytedance.com
Fixes: e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Xiongchun Duan <duanxiongchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled
+++ a/mm/ksm.c
@@ -2112,8 +2112,16 @@ static void cmp_and_merge_page(struct pa
 
 		down_read(&mm->mmap_sem);
 		vma = find_mergeable_vma(mm, rmap_item->address);
-		err = try_to_merge_one_page(vma, page,
-					    ZERO_PAGE(rmap_item->address));
+		if (vma) {
+			err = try_to_merge_one_page(vma, page,
+					ZERO_PAGE(rmap_item->address));
+		} else {
+			/*
+			 * If the vma is out of date, we do not need to
+			 * continue.
+			 */
+			err = 0;
+		}
 		up_read(&mm->mmap_sem);
 		/*
 		 * In case of failure, the page was not really empty, so we
_
