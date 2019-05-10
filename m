Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736781A45C
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfEJVNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 17:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEJVNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 17:13:46 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5118520896;
        Fri, 10 May 2019 21:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557522825;
        bh=nLR2QW0fB1Fl7UukWeXFIKkJcVOwwCAVELTr1DYuZVc=;
        h=Date:From:To:Subject:From;
        b=VXPDWKWOOinNp2S1T77QRpc7u+7m3Pn7m/aPYItsF2nfy/RWjSfU67e5gnAgbnax3
         NfdGpV/K+JBvq35yXqjYvZiDDUh15Eo9iOPmdKqDgf6+Qk1TvRNOONXg5ZFTNOZH2W
         x250mSinb510y1ZvgRSqKO/KxCOMN4Z4FgM2GXB8=
Date:   Fri, 10 May 2019 14:13:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        mhocko@suse.com, dvyukov@google.com, cai@lca.pw,
        aryabinin@virtuozzo.com, mgorman@techsingularity.net
Subject:  +
 =?us-ascii?Q?mm-compactionc-correct-zone-boundary-handling-when-isolat?=
 =?us-ascii?Q?ing-pages-from-a-pageblock.patch?= added to -mm tree
Message-ID: <20190510211344.HgA2j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: correct zone boundary handling when isolating pages from a pageblock
has been added to the -mm tree.  Its filename is
     mm-compactionc-correct-zone-boundary-handling-when-isolating-pages-from-a-pageblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compactionc-correct-zone-boundary-handling-when-isolating-pages-from-a-pageblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compactionc-correct-zone-boundary-handling-when-isolating-pages-from-a-pageblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/compaction.c: correct zone boundary handling when isolating pages from a pageblock

syzbot reported the following error from a tree with a head commit of
baf76f0c58ae ("slip: make slhc_free() silently accept an error pointer")

  BUG: unable to handle kernel paging request at ffffea0003348000
  #PF error: [normal kernel read fault]
  PGD 12c3f9067 P4D 12c3f9067 PUD 12c3f8067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP KASAN
  CPU: 1 PID: 28916 Comm: syz-executor.2 Not tainted 5.1.0-rc6+ #89
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:constant_test_bit arch/x86/include/asm/bitops.h:314 [inline]
  RIP: 0010:PageCompound include/linux/page-flags.h:186 [inline]
  RIP: 0010:isolate_freepages_block+0x1c0/0xd40 mm/compaction.c:579
  Code: 01 d8 ff 4d 85 ed 0f 84 ef 07 00 00 e8 29 00 d8 ff 4c 89 e0 83 85 38 ff
  ff ff 01 48 c1 e8 03 42 80 3c 38 00 0f 85 31 0a 00 00 <4d> 8b 2c 24 31 ff 49
  c1 ed 10 41 83 e5 01 44 89 ee e8 3a 01 d8 ff
  RSP: 0018:ffff88802b31eab8 EFLAGS: 00010246
  RAX: 1ffffd4000669000 RBX: 00000000000cd200 RCX: ffffc9000a235000
  RDX: 000000000001ca5e RSI: ffffffff81988cc7 RDI: 0000000000000001
  RBP: ffff88802b31ebd8 R08: ffff88805af700c0 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: ffffea0003348000
  R13: 0000000000000000 R14: ffff88802b31f030 R15: dffffc0000000000
  FS:  00007f61648dc700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffea0003348000 CR3: 0000000037c64000 CR4: 00000000001426e0
  Call Trace:
   fast_isolate_around mm/compaction.c:1243 [inline]
   fast_isolate_freepages mm/compaction.c:1418 [inline]
   isolate_freepages mm/compaction.c:1438 [inline]
   compaction_alloc+0x1aee/0x22e0 mm/compaction.c:1550

There is no reproducer and it is difficult to hit -- 1 crash every few
days.  The issue is very similar to the fix in commit 6b0868c820ff
("mm/compaction.c: correct zone boundary handling when resetting pageblock
skip hints").  When isolating free pages around a target pageblock, the
boundary handling is off by one and can stray into the next pageblock. 
Triggering the syzbot error requires that the end of pageblock is section
or zone aligned, and that the next section is unpopulated.

A more subtle consequence of the bug is that pageblocks were being
improperly used as migration targets which potentially hurts fragmentation
avoidance in the long-term one page at a time.

A debugging patch revealed that it's definitely possible to stray outside
of a pageblock which is not intended.  While syzbot cannot be used to
verify this patch, it was confirmed that the debugging warning no longer
triggers with this patch applied.  It has also been confirmed that the THP
allocation stress tests are not degraded by this patch.

Link: http://lkml.kernel.org/r/20190510182124.GI18914@techsingularity.net
Fixes: e332f741a8dd ("mm, compaction: be selective about what pageblocks to clear skip hints")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: syzbot+d84c80f9fe26a0f7a734@syzkaller.appspotmail.com
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compactionc-correct-zone-boundary-handling-when-isolating-pages-from-a-pageblock
+++ a/mm/compaction.c
@@ -1228,7 +1228,7 @@ fast_isolate_around(struct compact_contr
 
 	/* Pageblock boundaries */
 	start_pfn = pageblock_start_pfn(pfn);
-	end_pfn = min(start_pfn + pageblock_nr_pages, zone_end_pfn(cc->zone));
+	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone)) - 1;
 
 	/* Scan before */
 	if (start_pfn != pfn) {
@@ -1239,7 +1239,7 @@ fast_isolate_around(struct compact_contr
 
 	/* Scan after */
 	start_pfn = pfn + nr_isolated;
-	if (start_pfn != end_pfn)
+	if (start_pfn < end_pfn)
 		isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-compactionc-correct-zone-boundary-handling-when-isolating-pages-from-a-pageblock.patch

