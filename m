Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA02D9EB5
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440664AbgLNSQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:16:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502371AbgLNRjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:04 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 098/105] mm/hugetlb: clear compound_nr before freeing gigantic pages
Date:   Mon, 14 Dec 2020 18:29:12 +0100
Message-Id: <20201214172559.997198117@linuxfoundation.org>
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

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit ba9c1201beaa86a773e83be5654602a0667e4a4d upstream.

Commit 1378a5ee451a ("mm: store compound_nr as well as compound_order")
added compound_nr counter to first tail struct page, overlaying with
page->mapping.  The overlay itself is fine, but while freeing gigantic
hugepages via free_contig_range(), a "bad page" check will trigger for
non-NULL page->mapping on the first tail page:

  BUG: Bad page state in process bash  pfn:380001
  page:00000000c35f0856 refcount:0 mapcount:0 mapping:00000000126b68aa index:0x0 pfn:0x380001
  aops:0x0
  flags: 0x3ffff00000000000()
  raw: 3ffff00000000000 0000000000000100 0000000000000122 0000000100000000
  raw: 0000000000000000 0000000000000000 ffffffff00000000 0000000000000000
  page dumped because: non-NULL mapping
  Modules linked in:
  CPU: 6 PID: 616 Comm: bash Not tainted 5.10.0-rc7-next-20201208 #1
  Hardware name: IBM 3906 M03 703 (LPAR)
  Call Trace:
    show_stack+0x6e/0xe8
    dump_stack+0x90/0xc8
    bad_page+0xd6/0x130
    free_pcppages_bulk+0x26a/0x800
    free_unref_page+0x6e/0x90
    free_contig_range+0x94/0xe8
    update_and_free_page+0x1c4/0x2c8
    free_pool_huge_page+0x11e/0x138
    set_max_huge_pages+0x228/0x300
    nr_hugepages_store_common+0xb8/0x130
    kernfs_fop_write+0xd2/0x218
    vfs_write+0xb0/0x2b8
    ksys_write+0xac/0xe0
    system_call+0xe6/0x288
  Disabling lock debugging due to kernel taint

This is because only the compound_order is cleared in
destroy_compound_gigantic_page(), and compound_nr is set to
1U << order == 1 for order 0 in set_compound_order(page, 0).

Fix this by explicitly clearing compound_nr for first tail page after
calling set_compound_order(page, 0).

Link: https://lkml.kernel.org/r/20201208182813.66391-2-gerald.schaefer@linux.ibm.com
Fixes: 1378a5ee451a ("mm: store compound_nr as well as compound_order")
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1227,6 +1227,7 @@ static void destroy_compound_gigantic_pa
 	}
 
 	set_compound_order(page, 0);
+	page[1].compound_nr = 0;
 	__ClearPageHead(page);
 }
 


