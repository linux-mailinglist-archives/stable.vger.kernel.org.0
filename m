Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6A84E310C
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 21:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352885AbiCUUGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 16:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240609AbiCUUGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 16:06:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264E335DF0;
        Mon, 21 Mar 2022 13:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6AC760F76;
        Mon, 21 Mar 2022 20:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12386C340E8;
        Mon, 21 Mar 2022 20:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647893123;
        bh=/VJB/d/3Z6TvE59Uq2N7YwI67p3DC5nPAdndbLHX+LI=;
        h=Date:To:From:Subject:From;
        b=FC7BaZvXw2iNOPn4M7QFn6AT8onn4KMpH6pIyYqUg+2PZW3uxjX5sPF9nm5IXM+6A
         qOCM3TOOzXRG20hw7ceosxw9WBGoWUN9lcJcbQKyMDiB8M/85p8bJ17p07RR+LGd3W
         xTc8TxZUZ6fhYVOYJcizLE+aBCAWDBxdcitrutRU=
Date:   Mon, 21 Mar 2022 13:05:22 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, stable@vger.kernel.org, rogerq@kernel.org,
        ran.xiaokai@zte.com.cn, naoya.horiguchi@nec.com,
        minchan@kernel.org, mhocko@kernel.org, jiang.xuexin@zte.com.cn,
        hughd@google.com, hannes@cmpxchg.org, guo.ziliang@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-swap-get-rid-of-deadloop-in-swapin-readahead.patch removed from -mm tree
Message-Id: <20220321200523.12386C340E8@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: swap: get rid of deadloop in swapin readahead
has been removed from the -mm tree.  Its filename was
     mm-swap-get-rid-of-deadloop-in-swapin-readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Ziliang <guo.ziliang@zte.com.cn>
Subject: mm: swap: get rid of deadloop in swapin readahead

In our testing, a deadloop task was found.  Through sysrq printing, same
stack was found every time, as follows:

__swap_duplicate+0x58/0x1a0
swapcache_prepare+0x24/0x30
__read_swap_cache_async+0xac/0x220
read_swap_cache_async+0x58/0xa0
swapin_readahead+0x24c/0x628
do_swap_page+0x374/0x8a0
__handle_mm_fault+0x598/0xd60
handle_mm_fault+0x114/0x200
do_page_fault+0x148/0x4d0
do_translation_fault+0xb0/0xd4
do_mem_abort+0x50/0xb0

The reason for the deadloop is that swapcache_prepare() always returns
EEXIST, indicating that SWAP_HAS_CACHE has not been cleared, so that it
cannot jump out of the loop.  We suspect that the task that clears the
SWAP_HAS_CACHE flag never gets a chance to run.  We try to lower the
priority of the task stuck in a deadloop so that the task that clears the
SWAP_HAS_CACHE flag will run.  The results show that the system returns to
normal after the priority is lowered.

In our testing, multiple real-time tasks are bound to the same core, and
the task in the deadloop is the highest priority task of the core, so the
deadloop task cannot be preempted.

Although cond_resched() is used by __read_swap_cache_async, it is an empty
function in the preemptive system and cannot achieve the purpose of
releasing the CPU.  A high-priority task cannot release the CPU unless
preempted by a higher-priority task.  But when this task is already the
highest priority task on this core, other tasks will not be able to be
scheduled.  So we think we should replace cond_resched() with
schedule_timeout_uninterruptible(1), schedule_timeout_interruptible will
call set_current_state first to set the task state, so the task will be
removed from the running queue, so as to achieve the purpose of giving up
the CPU and prevent it from running in kernel mode for too long.

(akpm: ugly hack becomes uglier.  But it fixes the issue in a
backportable-to-stable fashion while we hopefully work on something
better)

Link: https://lkml.kernel.org/r/20220221111749.1928222-1-cgel.zte@gmail.com
Signed-off-by: Guo Ziliang <guo.ziliang@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Jiang Xuexin <jiang.xuexin@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roger Quadros <rogerq@kernel.org>
Cc: Ziliang Guo <guo.ziliang@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-get-rid-of-deadloop-in-swapin-readahead
+++ a/mm/swap_state.c
@@ -478,7 +478,7 @@ struct page *__read_swap_cache_async(swp
 		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
 		 * in swap_map, but not yet added its page to swap cache.
 		 */
-		cond_resched();
+		schedule_timeout_uninterruptible(1);
 	}
 
 	/*
_

Patches currently in -mm which might be from guo.ziliang@zte.com.cn are


