Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFDE10BAB5
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732340AbfK0VFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbfK0VFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10C682176D;
        Wed, 27 Nov 2019 21:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888751;
        bh=GsNJSubEqy9092/kPFVh7cTNvDDqTlvKsL8ToKkBp3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C648szzbFwBduCYjhuJFYmrNeuFZpwe28LCe12sTTzvBWCxjYhxuTpuSMJ0ssghoY
         Um9YzGy+k3wxl+Di755f7uREcgjiyqMrY0bw3/k0a811HZz5amvSPK/NKg5hFMcBo5
         BNiREDSZa+4gwp2veMdSMVhP8ZAclRPavXgYIMwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinayak Menon <vinmenon@codeaurora.org>,
        Minchan Kim <minchan@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 255/306] mm/page_io.c: do not free shared swap slots
Date:   Wed, 27 Nov 2019 21:31:45 +0100
Message-Id: <20191127203133.499090401@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinayak Menon <vinmenon@codeaurora.org>

[ Upstream commit 5df373e95689b9519b8557da7c5bd0db0856d776 ]

The following race is observed due to which a processes faulting on a
swap entry, finds the page neither in swapcache nor swap.  This causes
zram to give a zero filled page that gets mapped to the process,
resulting in a user space crash later.

Consider parent and child processes Pa and Pb sharing the same swap slot
with swap_count 2.  Swap is on zram with SWP_SYNCHRONOUS_IO set.
Virtual address 'VA' of Pa and Pb points to the shared swap entry.

Pa                                       Pb

fault on VA                              fault on VA
do_swap_page                             do_swap_page
lookup_swap_cache fails                  lookup_swap_cache fails
                                         Pb scheduled out
swapin_readahead (deletes zram entry)
swap_free (makes swap_count 1)
                                         Pb scheduled in
                                         swap_readpage (swap_count == 1)
                                         Takes SWP_SYNCHRONOUS_IO path
                                         zram enrty absent
                                         zram gives a zero filled page

Fix this by making sure that swap slot is freed only when swap count
drops down to one.

Link: http://lkml.kernel.org/r/1571743294-14285-1-git-send-email-vinmenon@codeaurora.org
Fixes: aa8d22a11da9 ("mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference")
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Suggested-by: Minchan Kim <minchan@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index aafd19ec1db46..08d2eae58fcee 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -76,6 +76,7 @@ static void swap_slot_free_notify(struct page *page)
 {
 	struct swap_info_struct *sis;
 	struct gendisk *disk;
+	swp_entry_t entry;
 
 	/*
 	 * There is no guarantee that the page is in swap cache - the software
@@ -107,11 +108,11 @@ static void swap_slot_free_notify(struct page *page)
 	 * we again wish to reclaim it.
 	 */
 	disk = sis->bdev->bd_disk;
-	if (disk->fops->swap_slot_free_notify) {
-		swp_entry_t entry;
+	entry.val = page_private(page);
+	if (disk->fops->swap_slot_free_notify &&
+			__swap_count(sis, entry) == 1) {
 		unsigned long offset;
 
-		entry.val = page_private(page);
 		offset = swp_offset(entry);
 
 		SetPageDirty(page);
-- 
2.20.1



