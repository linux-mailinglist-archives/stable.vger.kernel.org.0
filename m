Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2D0499D96
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583906AbiAXWYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353083AbiAXWRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C369FC04A2E5;
        Mon, 24 Jan 2022 12:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D09A60C23;
        Mon, 24 Jan 2022 20:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC3CC340E5;
        Mon, 24 Jan 2022 20:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057160;
        bh=rKEnzmRNzR7KabDzJxbjdFEi1uqoOkavf2ooI37fkbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLTRdVitrdhPHDNpssge7d3PjoMzj0j0fzVkT2AyCyfeX7byFM9jqKOkiG5mrKW6U
         LAI4zlIekJomz0b/leW7lYWp2goLJcMPl0WRQe0Zt+KnchtxY7IJcfn3E2i8tZfalh
         LYyOBORi3+/EATxqQYEum2v6NvKaaJkzoxI3DcBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 688/846] s390/mm: fix 2KB pgtable release race
Date:   Mon, 24 Jan 2022 19:43:25 +0100
Message-Id: <20220124184124.788606967@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit c2c224932fd0ee6854d6ebfc8d059c2bcad86606 upstream.

There is a race on concurrent 2KB-pgtables release paths when
both upper and lower halves of the containing parent page are
freed, one via page_table_free_rcu() + __tlb_remove_table(),
and the other via page_table_free(). The race might lead to a
corruption as result of remove of list item in page_table_free()
concurrently with __free_page() in __tlb_remove_table().

Let's assume first the lower and next the upper 2KB-pgtables are
freed from a page. Since both halves of the page are allocated
the tracking byte (bits 24-31 of the page _refcount) has value
of 0x03 initially:

CPU0				CPU1
----				----

page_table_free_rcu() // lower half
{
	// _refcount[31..24] == 0x03
	...
	atomic_xor_bits(&page->_refcount,
			0x11U << (0 + 24));
	// _refcount[31..24] <= 0x12
	...
	table = table | (1U << 0);
	tlb_remove_table(tlb, table);
}
...
__tlb_remove_table()
{
	// _refcount[31..24] == 0x12
	mask = _table & 3;
	// mask <= 0x01
	...

				page_table_free() // upper half
				{
					// _refcount[31..24] == 0x12
					...
					atomic_xor_bits(
						&page->_refcount,
						1U << (1 + 24));
					// _refcount[31..24] <= 0x10
					// mask <= 0x10
					...
	atomic_xor_bits(&page->_refcount,
			mask << (4 + 24));
	// _refcount[31..24] <= 0x00
	// mask <= 0x00
	...
	if (mask != 0) // == false
		break;
	fallthrough;
	...
					if (mask & 3) // == false
						...
					else
	__free_page(page);			list_del(&page->lru);
	^^^^^^^^^^^^^^^^^^	RACE!		^^^^^^^^^^^^^^^^^^^^^
}					...
				}

The problem is page_table_free() releases the page as result of
lower nibble unset and __tlb_remove_table() observing zero too
early. With this update page_table_free() will use the similar
logic as page_table_free_rcu() + __tlb_remove_table(), and mark
the fragment as pending for removal in the upper nibble until
after the list_del().

In other words, the parent page is considered as unreferenced and
safe to release only when the lower nibble is cleared already and
unsetting a bit in upper nibble results in that nibble turned zero.

Cc: stable@vger.kernel.org
Suggested-by: Vlastimil Babka <vbabka@suse.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pgalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -244,13 +244,15 @@ void page_table_free(struct mm_struct *m
 		/* Free 2K page table fragment of a 4K page */
 		bit = ((unsigned long) table & ~PAGE_MASK)/(PTRS_PER_PTE*sizeof(pte_t));
 		spin_lock_bh(&mm->context.lock);
-		mask = atomic_xor_bits(&page->_refcount, 1U << (bit + 24));
+		mask = atomic_xor_bits(&page->_refcount, 0x11U << (bit + 24));
 		mask >>= 24;
 		if (mask & 3)
 			list_add(&page->lru, &mm->context.pgtable_list);
 		else
 			list_del(&page->lru);
 		spin_unlock_bh(&mm->context.lock);
+		mask = atomic_xor_bits(&page->_refcount, 0x10U << (bit + 24));
+		mask >>= 24;
 		if (mask != 0)
 			return;
 	} else {


