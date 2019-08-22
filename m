Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15BA99C20
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404521AbfHVRZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404513AbfHVRZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:53 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C7012341E;
        Thu, 22 Aug 2019 17:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494752;
        bh=yDeMJbzq+TOjCwQOhDH0nlJsiz1Mfw7aQRUec/IWZzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vd/LB7abIv0mrdl8mi0RPq112ehzxP2HnFIx89h+bcCHD/4GNxBbFTuL0wB0ISf+b
         6DDvVmkFnO6Zs3fk+r2MuSdia4hlxucK8gunhKw8qah0+sv8OZLnTGByne4+3A+Di9
         QP/v6BKmT7rPXCadRJxISmCGwHpkNxYJyiS3nqxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Hocko <mhocko@suse.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/85] Revert "kmemleak: allow to coexist with fault injection"
Date:   Thu, 22 Aug 2019 10:19:24 -0700
Message-Id: <20190822171733.477513236@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 6c94b6865ac22..5eeabece0c178 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -126,7 +126,7 @@
 /* GFP bitmask for kmemleak internal allocations */
 #define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
 				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
-				 __GFP_NOWARN | __GFP_NOFAIL)
+				 __GFP_NOWARN)
 
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
-- 
2.20.1



