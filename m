Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0260E6AED20
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCGSB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCGSBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DFF94F61
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00305B819BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31825C433D2;
        Tue,  7 Mar 2023 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211696;
        bh=8ZdmRVxLmr16nHrQfbTY+WCVRTuplyEAS75UyCMdkhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2bl22OitKLhGrc3yiYW01bchgfewuzoKKfMAXFE8hIZSyzR1jAFp+LO+N03cGNIF
         VhK+SIMumLNVZlQf7JtrfYMtQQNuxmN4C4oSWGbOTNp76zDJxjqXZKW8DdSxPibjWv
         KrkrgOSApNaq6PTp5tdXQ8p/RPx2pZNWoA2Bt8lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yin Fengwei <fengwei.yin@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        David Rientjes <rientjes@google.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Rik van Riel <riel@surriel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 0946/1001] mm/thp: check and bail out if page in deferred queue already
Date:   Tue,  7 Mar 2023 18:01:58 +0100
Message-Id: <20230307170103.191896610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yin Fengwei <fengwei.yin@intel.com>

commit 81e506bec9be1eceaf5a2c654e28ba5176ef48d8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2837,6 +2837,9 @@ void deferred_split_huge_page(struct pag
 	if (PageSwapCache(page))
 		return;
 
+	if (!list_empty(page_deferred_list(page)))
+		return;
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);


