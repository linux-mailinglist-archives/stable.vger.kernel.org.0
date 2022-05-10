Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B86A520C8D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 06:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbiEJEN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 00:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiEJEN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 00:13:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F494209546;
        Mon,  9 May 2022 21:09:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F222B81AEF;
        Tue, 10 May 2022 04:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4D3C385A6;
        Tue, 10 May 2022 04:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155766;
        bh=O2WtmYbTVRKN75/Jvyn828TTCVm9ag5BKQKA+AmeFgE=;
        h=Date:To:From:Subject:From;
        b=OM1gOubpuOFAM3eNAgDylJiUZvfvwFywl5qxuvHVAnnZKavxM2e1P6Tk9Ud/4bM5c
         jzMTZActixHx1t5Vzb4fUnrIJwkBGszgc12Y7tRHu0xoGMe/bjOnVl6wszVjoQAEOo
         1sUatDqq5qoU/e8Jl+xOS+Z3V4wJTIsfACckfgmo=
Date:   Mon, 09 May 2022 21:09:26 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, naoya.horiguchi@nec.com, lkp@intel.com,
        linmiaohe@huawei.com, xuyu@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-do-not-overkill-when-splitting-huge_zero_page.patch removed from -mm tree
Message-Id: <20220510040926.DA4D3C385A6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: do not overkill when splitting huge_zero_page
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-do-not-overkill-when-splitting-huge_zero_page.patch

This patch was dropped because it was merged into mm-hotfixes-stable

------------------------------------------------------
From: Xu Yu <xuyu@linux.alibaba.com>
Subject: mm/huge_memory: do not overkill when splitting huge_zero_page

Kernel panic when injecting memory_failure for the global huge_zero_page,
when CONFIG_DEBUG_VM is enabled, as follows.

  Injecting memory failure for pfn 0x109ff9 at process virtual address 0x20ff9000
  page:00000000fb053fc3 refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109e00
  head:00000000fb053fc3 order:9 compound_mapcount:0 compound_pincount:0
  flags: 0x17fffc000010001(locked|head|node=0|zone=2|lastcpupid=0x1ffff)
  raw: 017fffc000010001 0000000000000000 dead000000000122 0000000000000000
  raw: 0000000000000000 0000000000000000 00000002ffffffff 0000000000000000
  page dumped because: VM_BUG_ON_PAGE(is_huge_zero_page(head))
  ------------[ cut here ]------------
  kernel BUG at mm/huge_memory.c:2499!
  invalid opcode: 0000 [#1] PREEMPT SMP PTI
  CPU: 6 PID: 553 Comm: split_bug Not tainted 5.18.0-rc1+ #11
  Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 3288b3c 04/01/2014
  RIP: 0010:split_huge_page_to_list+0x66a/0x880
  Code: 84 9b fb ff ff 48 8b 7c 24 08 31 f6 e8 9f 5d 2a 00 b8 b8 02 00 00 e9 e8 fb ff ff 48 c7 c6 e8 47 3c 82 4c b
  RSP: 0018:ffffc90000dcbdf8 EFLAGS: 00010246
  RAX: 000000000000003c RBX: 0000000000000001 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffff823e4c4f RDI: 00000000ffffffff
  RBP: ffff88843fffdb40 R08: 0000000000000000 R09: 00000000fffeffff
  R10: ffffc90000dcbc48 R11: ffffffff82d68448 R12: ffffea0004278000
  R13: ffffffff823c6203 R14: 0000000000109ff9 R15: ffffea000427fe40
  FS:  00007fc375a26740(0000) GS:ffff88842fd80000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fc3757c9290 CR3: 0000000102174006 CR4: 00000000003706e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
  try_to_split_thp_page+0x3a/0x130
  memory_failure+0x128/0x800
  madvise_inject_error.cold+0x8b/0xa1
  __x64_sys_madvise+0x54/0x60
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7fc3754f8bf9
  Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 8
  RSP: 002b:00007ffeda93a1d8 EFLAGS: 00000217 ORIG_RAX: 000000000000001c
  RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc3754f8bf9
  RDX: 0000000000000064 RSI: 0000000000003000 RDI: 0000000020ff9000
  RBP: 00007ffeda93a200 R08: 0000000000000000 R09: 0000000000000000
  R10: 00000000ffffffff R11: 0000000000000217 R12: 0000000000400490
  R13: 00007ffeda93a2e0 R14: 0000000000000000 R15: 0000000000000000

We think that raising BUG is overkilling for splitting huge_zero_page, the
huge_zero_page can't be met from normal paths other than memory failure,
but memory failure is a valid caller.  So we tend to replace the BUG to
WARN + returning -EBUSY, and thus the panic above won't happen again.

Link: https://lkml.kernel.org/r/f35f8b97377d5d3ede1bc5ac3114da888c57cbce.1651052574.git.xuyu@linux.alibaba.com
Fixes: d173d5417fb6 ("mm/memory-failure.c: skip huge_zero_page in memory_failure()")
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-do-not-overkill-when-splitting-huge_zero_page
+++ a/mm/huge_memory.c
@@ -2495,11 +2495,16 @@ int split_huge_page_to_list(struct page
 	struct address_space *mapping = NULL;
 	int extra_pins, ret;
 	pgoff_t end;
+	bool is_hzp;
 
-	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
 	VM_BUG_ON_PAGE(!PageLocked(head), head);
 	VM_BUG_ON_PAGE(!PageCompound(head), head);
 
+	is_hzp = is_huge_zero_page(head);
+	VM_WARN_ON_ONCE_PAGE(is_hzp, head);
+	if (is_hzp)
+		return -EBUSY;
+
 	if (PageWriteback(head))
 		return -EBUSY;
 
_

Patches currently in -mm which might be from xuyu@linux.alibaba.com are


