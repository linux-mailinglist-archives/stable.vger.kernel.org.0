Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19EE18267E
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 02:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387524AbgCLBIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 21:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbgCLBId (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 21:08:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9482072F;
        Thu, 12 Mar 2020 01:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583975313;
        bh=a7x6odggfwpzyR4n3injseZHLnMztWGDhxWA8RAOszk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OARwd0tIwMQd8/PjBoC2mD6rvf+z259fGLDTCNHheZW2rq4F3z2DM4fLQ9RViqLON
         njFRpsiC1KngVO4xBr5b7s5SroRh6iw9kAccj6kQhmPpwGiAqgD7Qft5S+Nue05wjO
         rwBVvV4ViP3jOTF+ArG0AK+e4R/CG6jTMPFt5Fns=
Date:   Wed, 11 Mar 2020 18:08:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cai@lca.pw, david@redhat.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, ying.huang@intel.com
Subject:  + page-flags-fix-a-crash-at-setpageerrorthp_swap.patch
 added to -mm tree
Message-ID: <20200312010832.-ObO3ZKSG%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: page-flags: fix a crash at SetPageError(THP_SWAP)
has been added to the -mm tree.  Its filename is
     page-flags-fix-a-crash-at-setpageerrorthp_swap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-fix-a-crash-at-setpageerrorthp_swap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-fix-a-crash-at-setpageerrorthp_swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: page-flags: fix a crash at SetPageError(THP_SWAP)

The commit bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped
out") supported writing THP to a swap device but forgot to upgrade an
older commit df8c94d13c7e ("page-flags: define behavior of FS/IO-related
flags on compound pages") which could trigger a crash during THP swapping
out with DEBUG_VM_PGFLAGS=y,

kernel BUG at include/linux/page-flags.h:317!

page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
page:fffff3b2ec3a8000 refcount:512 mapcount:0 mapping:000000009eb0338c
index:0x7f6e58200 head:fffff3b2ec3a8000 order:9 compound_mapcount:0
compound_pincount:0
anon flags:
0x45fffe0000d8454(uptodate|lru|workingset|owner_priv_1|writeback|head|reclaim|swapbacked)

end_swap_bio_write()
  SetPageError(page)
    VM_BUG_ON_PAGE(1 && PageCompound(page))

<IRQ>
bio_endio+0x297/0x560
dec_pending+0x218/0x430 [dm_mod]
clone_endio+0xe4/0x2c0 [dm_mod]
bio_endio+0x297/0x560
blk_update_request+0x201/0x920
scsi_end_request+0x6b/0x4b0
scsi_io_completion+0x509/0x7e0
scsi_finish_command+0x1ed/0x2a0
scsi_softirq_done+0x1c9/0x1d0
__blk_mqnterrupt+0xf/0x20
</IRQ>

Fix by checking PF_NO_TAIL in those places instead.

Link: http://lkml.kernel.org/r/20200310235846.1319-1-cai@lca.pw
Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~page-flags-fix-a-crash-at-setpageerrorthp_swap
+++ a/include/linux/page-flags.h
@@ -311,7 +311,7 @@ static inline int TestClearPage##uname(s
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD) __CLEARPAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
-PAGEFLAG(Error, error, PF_NO_COMPOUND) TESTCLEARFLAG(Error, error, PF_NO_COMPOUND)
+PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 PAGEFLAG(Referenced, referenced, PF_HEAD)
 	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
 	__SETPAGEFLAG(Referenced, referenced, PF_HEAD)
_

Patches currently in -mm which might be from cai@lca.pw are

page-flags-fix-a-crash-at-setpageerrorthp_swap.patch
mm-disable-kcsan-for-kmemleak.patch
mm-swapfile-fix-data-races-in-try_to_unuse.patch
kasan-detect-negative-size-in-memory-operation-function-fix.patch
mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
percpu_counter-fix-a-data-race-at-vm_committed_as.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch

