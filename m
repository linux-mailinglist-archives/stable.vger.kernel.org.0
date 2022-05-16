Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50F1528FE6
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344310AbiEPUE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348877AbiEPT7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3192FEE2F;
        Mon, 16 May 2022 12:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A62F260ABE;
        Mon, 16 May 2022 19:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2ACC385AA;
        Mon, 16 May 2022 19:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730709;
        bh=g0egG5JYloZbB00XCf6BHZ4tIRT9Du2TbaWzcFpdHHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ca1iPEG1dIfaDfSlsJxxaytRuY1n6oIeBKidLyd3j/h5DZtcu09Ws3PX+loPbPI/j
         P5yeSlVVKZCkFUQx4HbT50pqlpWg3G8nLpvgN4JFhdb97CL0JVFEvTQvxzJJ0NvQfH
         Yb9+u+gYQy+Sb+JpffnOixFDwmmaPsKf+n61nuwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yu <xuyu@linux.alibaba.com>,
        Yang Shi <shy828301@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 083/102] mm/huge_memory: do not overkill when splitting huge_zero_page
Date:   Mon, 16 May 2022 21:36:57 +0200
Message-Id: <20220516193626.376176682@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yu <xuyu@linux.alibaba.com>

commit 478d134e9506c7e9bfe2830ed03dd85e97966313 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2617,11 +2617,16 @@ int split_huge_page_to_list(struct page
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
 


