Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF7B5F2A22
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiJCHbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiJCH3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F685F48;
        Mon,  3 Oct 2022 00:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A445B80E80;
        Mon,  3 Oct 2022 07:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9118AC433C1;
        Mon,  3 Oct 2022 07:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781548;
        bh=ZrxVxtXp/dUbfCF43tK79HuuLUoVMBvREU6yefQDcls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tg20w5kUAafDZfG3IHf1IKFuXlJyU1g1rsBPlgwb18w8HnOW05s7yztd48+hyC+qr
         8aB73bL+b0git9cLwsDwOFImJASEvdJyQQ61og+q6HtDIcdTw9eCelgUIJQaUa4s4/
         ZYR6WvW09hvX5v26gtqQy8ezud4Hl/RTEUH7pADY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Karol Herbst <kherbst@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Lyude Paul <lyude@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 32/83] mm/migrate_device.c: flush TLB while holding PTL
Date:   Mon,  3 Oct 2022 09:10:57 +0200
Message-Id: <20221003070722.804229905@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

commit 60bae73708963de4a17231077285bd9ff2f41c44 upstream.

When clearing a PTE the TLB should be flushed whilst still holding the PTL
to avoid a potential race with madvise/munmap/etc.  For example consider
the following sequence:

  CPU0                          CPU1
  ----                          ----

  migrate_vma_collect_pmd()
  pte_unmap_unlock()
                                madvise(MADV_DONTNEED)
                                -> zap_pte_range()
                                pte_offset_map_lock()
                                [ PTE not present, TLB not flushed ]
                                pte_unmap_unlock()
                                [ page is still accessible via stale TLB ]
  flush_tlb_range()

In this case the page may still be accessed via the stale TLB entry after
madvise returns.  Fix this by flushing the TLB while holding the PTL.

Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Link: https://lkml.kernel.org/r/9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2422,13 +2422,14 @@ next:
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = mpfn;
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
 
 	/* Only flush the TLB if we actually modified any entries */
 	if (unmapped)
 		flush_tlb_range(walk->vma, start, end);
 
+	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(ptep - 1, ptl);
+
 	return 0;
 }
 


