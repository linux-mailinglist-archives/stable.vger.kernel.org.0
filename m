Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DC84DBADB
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 00:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiCPXQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 19:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiCPXQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 19:16:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A6B25D8;
        Wed, 16 Mar 2022 16:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A6CA6165D;
        Wed, 16 Mar 2022 23:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1FBC340EC;
        Wed, 16 Mar 2022 23:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647472504;
        bh=zNSaguHsQ0Z2gT5BRDht4ZRF2pSwkFvPw/VCK/fS2rU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=WfHu4NO17kX+/KhtTIvQHFzwpu5wxJJ+ipBYzR5NyJq1qql8RTKchjaSTFWTbkJ2s
         hAmTBubEv/TovifNCu8wbqskdLRjNga9Xut243aQTJ9qp4z+4A7I/ApL3UTdyEd4S2
         Sqe25MYVTXlQlt66X4bcll6swxs6Frct8dIVQO60=
Date:   Wed, 16 Mar 2022 16:15:03 -0700
To:     zealci@zte.com.cn, yang.yang29@zte.com.cn, stable@vger.kernel.org,
        rogerq@kernel.org, ran.xiaokai@zte.com.cn, naoya.horiguchi@nec.com,
        minchan@kernel.org, mhocko@kernel.org, jiang.xuexin@zte.com.cn,
        hughd@google.com, hannes@cmpxchg.org, guo.ziliang@zte.com.cn,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220316161433.5c2e137a69eaee50d2249a27@linux-foundation.org>
Subject: [patch 1/4] mm: swap: get rid of deadloop in swapin readahead
Message-Id: <20220316231503.DA1FBC340EC@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
