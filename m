Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB964FE952
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 22:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiDLUIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 16:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiDLUHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 16:07:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F7E88B38;
        Tue, 12 Apr 2022 12:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BB39CE20D5;
        Tue, 12 Apr 2022 19:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A077C385A5;
        Tue, 12 Apr 2022 19:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649793592;
        bh=VImd47/rb9zzhytz3svIY+uw6MIEcxloqHWArdIsIP4=;
        h=Date:To:From:Subject:From;
        b=skwmEyKy70RBeL3x6XC5GcUY9BK3+Qhvyk7yLFZipGhkhqTSQVDYBpfbVux6JQZYJ
         jWkuxoK1Y2NutW9zvJ5csnsCebJEt+7HS28Q2sMh26a0ON8hgLmNBxixhNLcmjA7Vz
         kHa9Q8ol16UFHnoTsc+/jsW3XQ8eOmeHjyLKiqQI=
Date:   Tue, 12 Apr 2022 12:59:51 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        abaci@linux.alibaba.com, xuyu@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-skip-huge_zero_page-in-memory_failure.patch added to -mm tree
Message-Id: <20220412195952.9A077C385A5@smtp.kernel.org>
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
     Subject: mm/memory-failure.c: skip huge_zero_page in memory_failure()
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-skip-huge_zero_page-in-memory_failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-skip-huge_zero_page-in-memory_failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-skip-huge_zero_page-in-memory_failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xu Yu <xuyu@linux.alibaba.com>
Subject: mm/memory-failure.c: skip huge_zero_page in memory_failure()

Kernel panic when injecting memory_failure for the global huge_zero_page,
when CONFIG_DEBUG_VM is enabled, as follows.

[    5.582720] Injecting memory failure for pfn 0x109ff9 at process virtual address 0x20ff9000
[    5.583786] page:00000000fb053fc3 refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109e00
[    5.584900] head:00000000fb053fc3 order:9 compound_mapcount:0 compound_pincount:0
[    5.585796] flags: 0x17fffc000010001(locked|head|node=0|zone=2|lastcpupid=0x1ffff)
[    5.586712] raw: 017fffc000010001 0000000000000000 dead000000000122 0000000000000000
[    5.587640] raw: 0000000000000000 0000000000000000 00000002ffffffff 0000000000000000
[    5.588565] page dumped because: VM_BUG_ON_PAGE(is_huge_zero_page(head))
[    5.589398] ------------[ cut here ]------------
[    5.589952] kernel BUG at mm/huge_memory.c:2499!
[    5.590516] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[    5.591120] CPU: 6 PID: 553 Comm: split_bug Not tainted 5.18.0-rc1+ #11
[    5.591904] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 3288b3c 04/01/2014
[    5.592817] RIP: 0010:split_huge_page_to_list+0x66a/0x880
[    5.593469] Code: 84 9b fb ff ff 48 8b 7c 24 08 31 f6 e8 9f 5d 2a 00 b8 b8 02 00 00 e9 e8 fb ff ff 48 c7 c6 e8 47 3c 82 4c b
[    5.595806] RSP: 0018:ffffc90000dcbdf8 EFLAGS: 00010246
[    5.596434] RAX: 000000000000003c RBX: 0000000000000001 RCX: 0000000000000000
[    5.597322] RDX: 0000000000000000 RSI: ffffffff823e4c4f RDI: 00000000ffffffff
[    5.598162] RBP: ffff88843fffdb40 R08: 0000000000000000 R09: 00000000fffeffff
[    5.598999] R10: ffffc90000dcbc48 R11: ffffffff82d68448 R12: ffffea0004278000
[    5.599849] R13: ffffffff823c6203 R14: 0000000000109ff9 R15: ffffea000427fe40
[    5.600693] FS:  00007fc375a26740(0000) GS:ffff88842fd80000(0000) knlGS:0000000000000000
[    5.601640] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.602304] CR2: 00007fc3757c9290 CR3: 0000000102174006 CR4: 00000000003706e0
[    5.603139] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.603977] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    5.604806] Call Trace:
[    5.605101]  <TASK>
[    5.605357]  ? __irq_work_queue_local+0x39/0x70
[    5.605904]  try_to_split_thp_page+0x3a/0x130
[    5.606430]  memory_failure+0x128/0x800
[    5.606888]  madvise_inject_error.cold+0x8b/0xa1
[    5.607444]  __x64_sys_madvise+0x54/0x60
[    5.607915]  do_syscall_64+0x35/0x80
[    5.608347]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    5.608949] RIP: 0033:0x7fc3754f8bf9
[    5.609374] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 8
[    5.611554] RSP: 002b:00007ffeda93a1d8 EFLAGS: 00000217 ORIG_RAX: 000000000000001c
[    5.612441] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc3754f8bf9
[    5.613269] RDX: 0000000000000064 RSI: 0000000000003000 RDI: 0000000020ff9000
[    5.614108] RBP: 00007ffeda93a200 R08: 0000000000000000 R09: 0000000000000000
[    5.614946] R10: 00000000ffffffff R11: 0000000000000217 R12: 0000000000400490
[    5.615787] R13: 00007ffeda93a2e0 R14: 0000000000000000 R15: 0000000000000000
[    5.616626]  </TASK>

This makes huge_zero_page bail out explicitly before split in
memory_failure(), thus the panic above won't happen again.

Link: https://lkml.kernel.org/r/497d3835612610e370c74e697ea3c721d1d55b9c.1649775850.git.xuyu@linux.alibaba.com
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failurec-skip-huge_zero_page-in-memory_failure
+++ a/mm/memory-failure.c
@@ -1861,6 +1861,19 @@ try_again:
 
 	if (PageTransHuge(hpage)) {
 		/*
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
+		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
 		 * And the flag can't be set in get_hwpoison_page() since
_

Patches currently in -mm which might be from xuyu@linux.alibaba.com are

mm-memory-failurec-skip-huge_zero_page-in-memory_failure.patch

