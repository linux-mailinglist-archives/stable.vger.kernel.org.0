Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1124DD0EF
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 23:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiCQW5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 18:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiCQW5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 18:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246CD2AB884;
        Thu, 17 Mar 2022 15:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3A04B8205E;
        Thu, 17 Mar 2022 22:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417E7C340E9;
        Thu, 17 Mar 2022 22:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647557777;
        bh=/VJB/d/3Z6TvE59Uq2N7YwI67p3DC5nPAdndbLHX+LI=;
        h=Date:To:From:Subject:From;
        b=Q1NPoNB5KXb+hAZPA4zP3pvhZ6ar4km8KgGgdFrPIIpIntGR9wK/F0wznyDuiZ1To
         4YSp9wOehxUf4HIu0BoYAypGKjf3k8Arim1yfaAswhk5a97o4yIHIM3M2Qg69R3Y53
         MLkuWfPRtX9c/L4HG/3mNEJt+rto4OiQ8losfcPo=
Date:   Thu, 17 Mar 2022 15:56:16 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, stable@vger.kernel.org, rogerq@kernel.org,
        ran.xiaokai@zte.com.cn, naoya.horiguchi@nec.com,
        minchan@kernel.org, mhocko@kernel.org, jiang.xuexin@zte.com.cn,
        hughd@google.com, hannes@cmpxchg.org, guo.ziliang@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-swap-get-rid-of-deadloop-in-swapin-readahead.patch removed from -mm tree
Message-Id: <20220317225617.417E7C340E9@smtp.kernel.org>
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


