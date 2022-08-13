Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E875591CB1
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 23:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbiHMV0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 17:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbiHMV0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 17:26:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7A717E3D;
        Sat, 13 Aug 2022 14:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C079B80AC3;
        Sat, 13 Aug 2022 21:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596BFC433B5;
        Sat, 13 Aug 2022 21:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660425976;
        bh=m/fOuZbScL5Ia/dH/yFtWLt0sWlBxxVO5xKQt+6bMeA=;
        h=Date:To:From:Subject:From;
        b=qQr39mMlCaiop69NGbqY8L+kc/mWnYGvy4Ao1Rcbqx7Y+NkpbMsycF2E0ScUAtpUu
         +8tt68N588JRKX+dQJWSXsrZ1dYOwQVty8AQyBy51s+LnwUcF8dNg0gbp5+1I9I5/x
         RSAt4SJaH5cUaBwOdmX0u+agXsD/PwR/ne3+RG6k=
Date:   Sat, 13 Aug 2022 14:26:15 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, hch@lst.de, david@redhat.com,
        bhe@redhat.com, mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch removed from -mm tree
Message-Id: <20220813212616.596BFC433B5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: dma/pool: do not complain if DMA pool is not allocated
has been removed from the -mm tree.  Its filename was
     dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: dma/pool: do not complain if DMA pool is not allocated
Date: Tue, 9 Aug 2022 17:37:59 +0200

We have a system complaining about order-10 allocation for the DMA pool.

[   14.017417][    T1] swapper/0: page allocation failure: order:10, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0-7
[   14.017429][    T1] CPU: 4 PID: 1 Comm: swapper/0 Not tainted 5.14.21-150400.22-default #1 SLE15-SP4 0b6a6578ade2de5c4a0b916095dff44f76ef1704
[   14.017434][    T1] Hardware name: XXXX
[   14.017437][    T1] Call Trace:
[   14.017444][    T1]  <TASK>
[   14.017449][    T1]  dump_stack_lvl+0x45/0x57
[   14.017469][    T1]  warn_alloc+0xfe/0x160
[   14.017490][    T1]  __alloc_pages_slowpath.constprop.112+0xc27/0xc60
[   14.017497][    T1]  ? rdinit_setup+0x2b/0x2b
[   14.017509][    T1]  ? rdinit_setup+0x2b/0x2b
[   14.017512][    T1]  __alloc_pages+0x2d5/0x320
[   14.017517][    T1]  alloc_page_interleave+0xf/0x70
[   14.017531][    T1]  atomic_pool_expand+0x4a/0x200
[   14.017541][    T1]  ? rdinit_setup+0x2b/0x2b
[   14.017544][    T1]  __dma_atomic_pool_init+0x44/0x90
[   14.017556][    T1]  dma_atomic_pool_init+0xad/0x13f
[   14.017560][    T1]  ? __dma_atomic_pool_init+0x90/0x90
[   14.017562][    T1]  do_one_initcall+0x41/0x200
[   14.017581][    T1]  kernel_init_freeable+0x236/0x298
[   14.017589][    T1]  ? rest_init+0xd0/0xd0
[   14.017596][    T1]  kernel_init+0x16/0x120
[   14.017599][    T1]  ret_from_fork+0x22/0x30
[   14.017604][    T1]  </TASK>
[...]
[   14.018026][    T1] Node 0 DMA free:160kB boost:0kB min:0kB low:0kB high:0kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15996kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[   14.018035][    T1] lowmem_reserve[]: 0 0 0 0 0
[   14.018339][    T1] Node 0 DMA: 0*4kB 0*8kB 0*16kB 1*32kB (U) 0*64kB 1*128kB (U) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 160kB

The usable memory in the DMA zone is obviously too small for the pool
pre-allocation.  The allocation failure raises concern by admins because
this is considered an error state.

In fact the preallocation itself doesn't expose any actual problem.  It is
not even clear whether anybody is ever going to use this pool.  If yes
then a warning will be triggered anyway.

Silence the warning to prevent confusion and bug reports.

Link: https://lkml.kernel.org/r/YvJ/V2bor9Q3P6ov@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Donnelly <john.p.donnelly@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/pool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/dma/pool.c~dma-pool-do-not-complain-if-dma-pool-is-not-allocated
+++ a/kernel/dma/pool.c
@@ -205,7 +205,7 @@ static int __init dma_atomic_pool_init(v
 		ret = -ENOMEM;
 	if (has_managed_dma()) {
 		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
-						GFP_KERNEL | GFP_DMA);
+						GFP_KERNEL | GFP_DMA | __GFP_NOWARN);
 		if (!atomic_pool_dma)
 			ret = -ENOMEM;
 	}
_

Patches currently in -mm which might be from mhocko@suse.com are


