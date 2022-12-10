Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A59648C8F
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 03:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLJCmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 21:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLJCmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 21:42:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D49C7A188;
        Fri,  9 Dec 2022 18:42:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE750623D6;
        Sat, 10 Dec 2022 02:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFD8C433D2;
        Sat, 10 Dec 2022 02:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670640120;
        bh=MwCNP1CzMSUDek37vxVpUGsHjfbKOYagLXt6MJUPkQg=;
        h=Date:To:From:Subject:From;
        b=NGgbsTBf//oIGMeOx3cL/LVeLGRheXXDWD7VMooLHuGSyGSDw5ZPipkRYm936ypJl
         wF7TPVr6CcqiaoT2DujcHuzOKvXIGoSKQ+QTGPBgmj9pNyPbuz43yvzzYI86CXHnMw
         1VnMZ3IGh2ShQ3J09cFFdk7J0EzcO6cAO/lprLZE=
Date:   Fri, 09 Dec 2022 18:41:59 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        stable@vger.kernel.org, ssengar@linux.microsoft.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jack@suse.cz,
        david@redhat.com, dan.j.williams@intel.com, apopple@nvidia.com,
        jostarks@microsoft.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-fix-gup_pud_range-for-dax.patch removed from -mm tree
Message-Id: <20221210024200.3FFD8C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: fix gup_pud_range() for dax
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-gup_pud_range-for-dax.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Starks <jostarks@microsoft.com>
Subject: mm/gup: fix gup_pud_range() for dax
Date: Tue, 6 Dec 2022 22:00:53 -0800

For dax pud, pud_huge() returns true on x86. So the function works as long
as hugetlb is configured. However, dax doesn't depend on hugetlb.
Commit 414fd080d125 ("mm/gup: fix gup_pmd_range() for dax") fixed
devmap-backed huge PMDs, but missed devmap-backed huge PUDs. Fix this as
well.

This fixes the below kernel panic:

general protection fault, probably for non-canonical address 0x69e7c000cc478: 0000 [#1] SMP
	< snip >
Call Trace:
<TASK>
get_user_pages_fast+0x1f/0x40
iov_iter_get_pages+0xc6/0x3b0
? mempool_alloc+0x5d/0x170
bio_iov_iter_get_pages+0x82/0x4e0
? bvec_alloc+0x91/0xc0
? bio_alloc_bioset+0x19a/0x2a0
blkdev_direct_IO+0x282/0x480
? __io_complete_rw_common+0xc0/0xc0
? filemap_range_has_page+0x82/0xc0
generic_file_direct_write+0x9d/0x1a0
? inode_update_time+0x24/0x30
__generic_file_write_iter+0xbd/0x1e0
blkdev_write_iter+0xb4/0x150
? io_import_iovec+0x8d/0x340
io_write+0xf9/0x300
io_issue_sqe+0x3c3/0x1d30
? sysvec_reschedule_ipi+0x6c/0x80
__io_queue_sqe+0x33/0x240
? fget+0x76/0xa0
io_submit_sqes+0xe6a/0x18d0
? __fget_light+0xd1/0x100
__x64_sys_io_uring_enter+0x199/0x880
? __context_tracking_enter+0x1f/0x70
? irqentry_exit_to_user_mode+0x24/0x30
? irqentry_exit+0x1d/0x30
? __context_tracking_exit+0xe/0x70
do_syscall_64+0x3b/0x90
entry_SYSCALL_64_after_hwframe+0x61/0xcb
RIP: 0033:0x7fc97c11a7be
	< snip >
</TASK>
---[ end trace 48b2e0e67debcaeb ]---
RIP: 0010:internal_get_user_pages_fast+0x340/0x990
	< snip >
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled

Link: https://lkml.kernel.org/r/1670392853-28252-1-git-send-email-ssengar@linux.microsoft.com
Fixes: 414fd080d125 ("mm/gup: fix gup_pmd_range() for dax")
Signed-off-by: John Starks <jostarks@microsoft.com>
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-fix-gup_pud_range-for-dax
+++ a/mm/gup.c
@@ -2852,7 +2852,7 @@ static int gup_pud_range(p4d_t *p4dp, p4
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
 			return 0;
-		if (unlikely(pud_huge(pud))) {
+		if (unlikely(pud_huge(pud) || pud_devmap(pud))) {
 			if (!gup_huge_pud(pud, pudp, addr, next, flags,
 					  pages, nr))
 				return 0;
_

Patches currently in -mm which might be from jostarks@microsoft.com are


