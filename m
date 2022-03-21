Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6258C4E29A6
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349051AbiCUOHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348817AbiCUOFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:05:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCA93B02A;
        Mon, 21 Mar 2022 07:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4346B816E1;
        Mon, 21 Mar 2022 14:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032A4C340ED;
        Mon, 21 Mar 2022 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871295;
        bh=u3F5wmbk+6PkM8pt2vrxqech9PMOYixTjf4rRI8WWcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU/TADhVZdWXvUJ/8Aps3n/V3Por6ohsJBlFDWyxS31/zx9X7RrP0p9FpVIn+svOh
         j0mEKFqYy4JKf6APPPlmdW1+NwNmBfKleRMjdPjtU9Khen6BgH8+PrCfwve8QPYxFs
         wikWMuZ+ZCNd6nGUNAAUXj5FA2wKN8WsZekH9Yxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ziliang <guo.ziliang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roger Quadros <rogerq@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 03/37] mm: swap: get rid of livelock in swapin readahead
Date:   Mon, 21 Mar 2022 14:52:45 +0100
Message-Id: <20220321133221.392695021@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ziliang <guo.ziliang@zte.com.cn>

commit 029c4628b2eb2ca969e9bf979b05dc18d8d5575e upstream.

In our testing, a livelock task was found.  Through sysrq printing, same
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

The reason for the livelock is that swapcache_prepare() always returns
EEXIST, indicating that SWAP_HAS_CACHE has not been cleared, so that it
cannot jump out of the loop.  We suspect that the task that clears the
SWAP_HAS_CACHE flag never gets a chance to run.  We try to lower the
priority of the task stuck in a livelock so that the task that clears
the SWAP_HAS_CACHE flag will run.  The results show that the system
returns to normal after the priority is lowered.

In our testing, multiple real-time tasks are bound to the same core, and
the task in the livelock is the highest priority task of the core, so
the livelocked task cannot be preempted.

Although cond_resched() is used by __read_swap_cache_async, it is an
empty function in the preemptive system and cannot achieve the purpose
of releasing the CPU.  A high-priority task cannot release the CPU
unless preempted by a higher-priority task.  But when this task is
already the highest priority task on this core, other tasks will not be
able to be scheduled.  So we think we should replace cond_resched() with
schedule_timeout_uninterruptible(1), schedule_timeout_interruptible will
call set_current_state first to set the task state, so the task will be
removed from the running queue, so as to achieve the purpose of giving
up the CPU and prevent it from running in kernel mode for too long.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -478,7 +478,7 @@ struct page *__read_swap_cache_async(swp
 		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
 		 * in swap_map, but not yet added its page to swap cache.
 		 */
-		cond_resched();
+		schedule_timeout_uninterruptible(1);
 	}
 
 	/*


