Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA73B83C82
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfHFVfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728179AbfHFVfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:35:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8492E2089E;
        Tue,  6 Aug 2019 21:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127307;
        bh=RJ/mBnQ9yApPExC7G9QkBrupCdlJeI8/8KL7fi+0rj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOEECtgZbf89hAtxVEUkrgEIwEAgwWO8mT1nCBMPJpN7f+hFIAzoz6G4Cv1aobdBF
         +yjYI9YhZzb8HZuyTO6Zj6CLIkhikJsufSFkEwGqB80aE6wBhUQ6e/C6+VDPftjiPF
         xwfodfYyKN3Czg73YaRAQ6528VOCIaYCoAcI8Fyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Shi <yang.shi@linux.alibaba.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Hocko <mhocko@suse.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.2 54/59] Revert "kmemleak: allow to coexist with fault injection"
Date:   Tue,  6 Aug 2019 17:33:14 -0400
Message-Id: <20190806213319.19203-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

[ Upstream commit df9576def004d2cd5beedc00cb6e8901427634b9 ]

When running ltp's oom test with kmemleak enabled, the below warning was
triggerred since kernel detects __GFP_NOFAIL & ~__GFP_DIRECT_RECLAIM is
passed in:

  WARNING: CPU: 105 PID: 2138 at mm/page_alloc.c:4608 __alloc_pages_nodemask+0x1c31/0x1d50
  Modules linked in: loop dax_pmem dax_pmem_core ip_tables x_tables xfs virtio_net net_failover virtio_blk failover ata_generic virtio_pci virtio_ring virtio libata
  CPU: 105 PID: 2138 Comm: oom01 Not tainted 5.2.0-next-20190710+ #7
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
  RIP: 0010:__alloc_pages_nodemask+0x1c31/0x1d50
  ...
   kmemleak_alloc+0x4e/0xb0
   kmem_cache_alloc+0x2a7/0x3e0
   mempool_alloc_slab+0x2d/0x40
   mempool_alloc+0x118/0x2b0
   bio_alloc_bioset+0x19d/0x350
   get_swap_bio+0x80/0x230
   __swap_writepage+0x5ff/0xb20

The mempool_alloc_slab() clears __GFP_DIRECT_RECLAIM, however kmemleak
has __GFP_NOFAIL set all the time due to d9570ee3bd1d4f2 ("kmemleak:
allow to coexist with fault injection").  But, it doesn't make any sense
to have __GFP_NOFAIL and ~__GFP_DIRECT_RECLAIM specified at the same
time.

According to the discussion on the mailing list, the commit should be
reverted for short term solution.  Catalin Marinas would follow up with
a better solution for longer term.

The failure rate of kmemleak metadata allocation may increase in some
circumstances, but this should be expected side effect.

Link: http://lkml.kernel.org/r/1563299431-111710-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: d9570ee3bd1d4f2 ("kmemleak: allow to coexist with fault injection")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 3e147ea831826..3afb01bce736a 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -114,7 +114,7 @@
 /* GFP bitmask for kmemleak internal allocations */
 #define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
 				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
-				 __GFP_NOWARN | __GFP_NOFAIL)
+				 __GFP_NOWARN)
 
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
-- 
2.20.1

