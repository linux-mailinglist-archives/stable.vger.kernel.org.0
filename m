Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CDE50DDB3
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbiDYKQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiDYKQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:16:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15145625C
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A52B060C41
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914EBC385AB;
        Mon, 25 Apr 2022 10:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650881622;
        bh=xoIDtgq/SY2eWRLIi6OY3gig+GTw3qRGuXN0tuKlpcQ=;
        h=Subject:To:Cc:From:Date:From;
        b=E27VBoggLJ/eLuij7437Er5OZktHjSM+iG91f6DjHcr2oKAWlGNHIlgl6KZOp0ETy
         HyHQ+3eOH49H9MsulKFMLO3nd6Um0r1yfyblVmoF0uWDoz4eFmvAFLdMJIS9VOK3DR
         vp/5fceVze+oPIl2FqANCRk1LIXneWlfvOndgvm0=
Subject: FAILED: patch "[PATCH] mm/memory-failure.c: skip huge_zero_page in memory_failure()" failed to apply to 4.19-stable tree
To:     xuyu@linux.alibaba.com, abaci@linux.alibaba.com,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linmiaohe@huawei.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 12:13:33 +0200
Message-ID: <1650881613138175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d173d5417fb67411e623d394aab986d847e47dad Mon Sep 17 00:00:00 2001
From: Xu Yu <xuyu@linux.alibaba.com>
Date: Thu, 21 Apr 2022 16:35:37 -0700
Subject: [PATCH] mm/memory-failure.c: skip huge_zero_page in memory_failure()

Kernel panic when injecting memory_failure for the global
huge_zero_page, when CONFIG_DEBUG_VM is enabled, as follows.

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

This makes huge_zero_page bail out explicitly before split in
memory_failure(), thus the panic above won't happen again.

Link: https://lkml.kernel.org/r/497d3835612610e370c74e697ea3c721d1d55b9c.1649775850.git.xuyu@linux.alibaba.com
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2020944398c9..27760c19bad7 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1860,6 +1860,19 @@ try_again:
 	}
 
 	if (PageTransHuge(hpage)) {
+		/*
+		 * Bail out before SetPageHasHWPoisoned() if hpage is
+		 * huge_zero_page, although PG_has_hwpoisoned is not
+		 * checked in set_huge_zero_page().
+		 *
+		 * TODO: Handle memory failure of huge_zero_page thoroughly.
+		 */
+		if (is_huge_zero_page(hpage)) {
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
+			res = -EBUSY;
+			goto unlock_mutex;
+		}
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.

