Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01255A4B40
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiH2MNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiH2MM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:12:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C0514030;
        Mon, 29 Aug 2022 04:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 632B7B80F10;
        Mon, 29 Aug 2022 11:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC4BC433D7;
        Mon, 29 Aug 2022 11:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771952;
        bh=mTyPZ20fSjaSYpQ61j5NTmfzTrJ+8OrucPF3r/b1kUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oWefVvhh9p6aY9HZiOqT5HGHYD0TJtxHIq381vQ+n51HrBMKkMNLiYDfS0iyMdXE
         +RyeDU/uFnxxdtKU/aoCSEGfVrnAfZ2OfjbCPdL46gTbe7+Ia8I+z7zKFD2VrUjfsP
         YpGoHdXWkhZVySPVkZvReA4bV8uxnvJdFrK87Lck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 118/158] mm/mprotect: only reference swap pfn page if type match
Date:   Mon, 29 Aug 2022 12:59:28 +0200
Message-Id: <20220829105814.053798920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 3d2f78f08cd8388035ac375e731ec1ac1b79b09d upstream.

Yu Zhao reported a bug after the commit "mm/swap: Add swp_offset_pfn() to
fetch PFN from swap entry" added a check in swp_offset_pfn() for swap type [1]:

  kernel BUG at include/linux/swapops.h:117!
  CPU: 46 PID: 5245 Comm: EventManager_De Tainted: G S         O L 6.0.0-dbg-DEV #2
  RIP: 0010:pfn_swap_entry_to_page+0x72/0xf0
  Code: c6 48 8b 36 48 83 fe ff 74 53 48 01 d1 48 83 c1 08 48 8b 09 f6
  c1 01 75 7b 66 90 48 89 c1 48 8b 09 f6 c1 01 74 74 5d c3 eb 9e <0f> 0b
  48 ba ff ff ff ff 03 00 00 00 eb ae a9 ff 0f 00 00 75 13 48
  RSP: 0018:ffffa59e73fabb80 EFLAGS: 00010282
  RAX: 00000000ffffffe8 RBX: 0c00000000000000 RCX: ffffcd5440000000
  RDX: 1ffffffffff7a80a RSI: 0000000000000000 RDI: 0c0000000000042b
  RBP: ffffa59e73fabb80 R08: ffff9965ca6e8bb8 R09: 0000000000000000
  R10: ffffffffa5a2f62d R11: 0000030b372e9fff R12: ffff997b79db5738
  R13: 000000000000042b R14: 0c0000000000042b R15: 1ffffffffff7a80a
  FS:  00007f549d1bb700(0000) GS:ffff99d3cf680000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000440d035b3180 CR3: 0000002243176004 CR4: 00000000003706e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   change_pte_range+0x36e/0x880
   change_p4d_range+0x2e8/0x670
   change_protection_range+0x14e/0x2c0
   mprotect_fixup+0x1ee/0x330
   do_mprotect_pkey+0x34c/0x440
   __x64_sys_mprotect+0x1d/0x30

It triggers because pfn_swap_entry_to_page() could be called upon e.g. a
genuine swap entry.

Fix it by only calling it when it's a write migration entry where the page*
is used.

[1] https://lore.kernel.org/lkml/CAOUHufaVC2Za-p8m0aiHw6YkheDcrO-C3wRGixwDS32VTS+k1w@mail.gmail.com/

Link: https://lkml.kernel.org/r/20220823221138.45602-1-peterx@redhat.com
Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -158,10 +158,11 @@ static unsigned long change_pte_range(st
 			pages++;
 		} else if (is_swap_pte(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
-			struct page *page = pfn_swap_entry_to_page(entry);
 			pte_t newpte;
 
 			if (is_writable_migration_entry(entry)) {
+				struct page *page = pfn_swap_entry_to_page(entry);
+
 				/*
 				 * A protection check is difficult so
 				 * just be safe and disable write


