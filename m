Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63929672E01
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 02:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjASBTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 20:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjASBRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 20:17:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E5A6C548;
        Wed, 18 Jan 2023 17:15:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF02B81FBD;
        Thu, 19 Jan 2023 01:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87567C433D2;
        Thu, 19 Jan 2023 01:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090937;
        bh=PFkEzI4PC6zXUgeRNUUCFeXNNVyrCy15+qXp7hK55Ho=;
        h=Date:To:From:Subject:From;
        b=epr/Ef0FfZW1Ziaetvb4OV4VWwMNgWPIDoeFqUX49wV0yVGoo6/TCjdF2bK6P2tJd
         Ri/bBUvjkqVjv1xgk3cUHfLgv7VFo5D+iUQ5K9Pr5XQNhfZ4EWayb7JKdfM19M8ffF
         TYZ1gzfa3GLZTYlgv5mS9sJsEIMdD+ElTBV2MO8Y=
Date:   Wed, 18 Jan 2023 17:15:37 -0800
To:     mm-commits@vger.kernel.org, zhengjun.xing@linux.intel.com,
        ying.huang@intel.com, willy@infradead.org, stable@vger.kernel.org,
        shy828301@gmail.com, rientjes@google.com, riel@surriel.com,
        nathan@kernel.org, feng.tang@intel.com, fengwei.yin@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch removed from -mm tree
Message-Id: <20230119011537.87567C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: check and bail out if page in deferred queue already
has been removed from the -mm tree.  Its filename was
     mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: mm/thp: check and bail out if page in deferred queue already
Date: Fri, 23 Dec 2022 21:52:07 +0800

Kernel build regression with LLVM was reported here:
https://lore.kernel.org/all/Y1GCYXGtEVZbcv%2F5@dev-arch.thelio-3990X/ with
commit f35b5d7d676e ("mm: align larger anonymous mappings on THP
boundaries").  And the commit f35b5d7d676e was reverted.

It turned out the regression is related with madvise(MADV_DONTNEED)
was used by ld.lld. But with none PMD_SIZE aligned parameter len.
trace-bpfcc captured:
531607  531732  ld.lld          do_madvise.part.0 start: 0x7feca9000000, len: 0x7fb000, behavior: 0x4
531607  531793  ld.lld          do_madvise.part.0 start: 0x7fec86a00000, len: 0x7fb000, behavior: 0x4

If the underneath physical page is THP, the madvise(MADV_DONTNEED) can
trigger split_queue_lock contention raised significantly. perf showed
following data:
    14.85%     0.00%  ld.lld           [kernel.kallsyms]           [k]
       entry_SYSCALL_64_after_hwframe
           11.52%
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                __x64_sys_madvise
                do_madvise.part.0
                zap_page_range
                unmap_single_vma
                unmap_page_range
                page_remove_rmap
                deferred_split_huge_page
                __lock_text_start
                native_queued_spin_lock_slowpath

If THP can't be removed from rmap as whole THP, partial THP will be
removed from rmap by removing sub-pages from rmap.  Even the THP head page
is added to deferred queue already, the split_queue_lock will be acquired
and check whether the THP head page is in the queue already.  Thus, the
contention of split_queue_lock is raised.

Before acquire split_queue_lock, check and bail out early if the THP
head page is in the queue already. The checking without holding
split_queue_lock could race with deferred_split_scan, but it doesn't
impact the correctness here.

Test result of building kernel with ld.lld:
commit 7b5a0b664ebe (parent commit of f35b5d7d676e):
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        6:07.99 real,   26367.77 user,  5063.35 sys

commit f35b5d7d676e:
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        7:22.15 real,   26235.03 user,  12504.55 sys

commit f35b5d7d676e with the fixing patch:
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        6:08.49 real,   26520.15 user,  5047.91 sys

Link: https://lkml.kernel.org/r/20221223135207.2275317-1-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c~mm-thp-check-and-bail-out-if-page-in-deferred-queue-already
+++ a/mm/huge_memory.c
@@ -2835,6 +2835,9 @@ void deferred_split_huge_page(struct pag
 	if (PageSwapCache(page))
 		return;
 
+	if (!list_empty(page_deferred_list(page)))
+		return;
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
_

Patches currently in -mm which might be from fengwei.yin@intel.com are


