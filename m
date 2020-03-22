Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC9E18E5C3
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 02:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgCVBWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 21:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 21:22:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6509D20767;
        Sun, 22 Mar 2020 01:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584840137;
        bh=XwF5h4p2dBv3GlAJCQYiZjh45FNcFG32ScXQ89g/8eM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q8czOS3yNxwj3ClzBtaHy1SNMex0yyZTR1OtxL8FYTGKwYw44mv5fkTTkJaPlTdfv
         pjVugX2zc+dpYzkyAEZqd2ogBF0ohTmSFlFgSC5FdZZy/RTTA+MwTzGI4/DyWJwU6H
         JG6yes95qJoyDGdCru0HxZ2fsGnEmb5/wL+vCgYY=
Date:   Sat, 21 Mar 2020 18:22:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aquini@redhat.com, cai@lca.pw,
        david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ying.huang@intel.com
Subject:  [patch 03/10] page-flags: fix a crash at
 SetPageError(THP_SWAP)
Message-ID: <20200322012217.Bs-GLyLDU%akpm@linux-foundation.org>
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Acked-by: Rafael Aquini <aquini@redhat.com>
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
