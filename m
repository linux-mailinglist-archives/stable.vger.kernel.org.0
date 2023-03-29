Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78FD6CF49C
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 22:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjC2Ujn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 16:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjC2Ujm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 16:39:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D515BAB;
        Wed, 29 Mar 2023 13:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35C6161E45;
        Wed, 29 Mar 2023 20:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E633C433EF;
        Wed, 29 Mar 2023 20:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680122380;
        bh=0hM0/3Tr5wsCOsMpUib3iRfv4gzEEx3jVvvpiDZC+t4=;
        h=Date:To:From:Subject:From;
        b=VaB52IrS9l4J42HjPFsHmQQeJg6mNsUg0L48ebW3l9MQKVrl7la+KQ5SkT4uMcCnY
         4e2wLw8O0LlXAobtPuE5ot2Y6gH5iIPHJtqtxvScprGb7JzDs24DUi/FzoUGJGBET4
         B9uP/JqnUUqEOVXN6IjHOe2lJBun5s63JtuHm9w8=
Date:   Wed, 29 Mar 2023 13:39:39 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songliubraving@fb.com, skhan@linuxfoundation.org, riel@surriel.com,
        kirill.shutemov@linux.intel.com, himadrispandya@gmail.com,
        hannes@cmpxchg.org, ivan.orlov0322@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch added to mm-hotfixes-unstable branch
Message-Id: <20230329203940.8E633C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: fix kernel BUG in hpage_collapse_scan_file()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: mm: khugepaged: fix kernel BUG in hpage_collapse_scan_file()
Date: Wed, 29 Mar 2023 18:53:30 +0400

Syzkaller reported the following issue:

kernel BUG at mm/khugepaged.c:1823!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5097 Comm: syz-executor220 Not tainted 6.2.0-syzkaller-13154-g857f1268a591 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:collapse_file mm/khugepaged.c:1823 [inline]
RIP: 0010:hpage_collapse_scan_file+0x67c8/0x7580 mm/khugepaged.c:2233
Code: 00 00 89 de e8 c9 66 a3 ff 31 ff 89 de e8 c0 66 a3 ff 45 84 f6 0f 85 28 0d 00 00 e8 22 64 a3 ff e9 dc f7 ff ff e8 18 64 a3 ff <0f> 0b f3 0f 1e fa e8 0d 64 a3 ff e9 93 f6 ff ff f3 0f 1e fa 4c 89
RSP: 0018:ffffc90003dff4e0 EFLAGS: 00010093
RAX: ffffffff81e95988 RBX: 00000000000001c1 RCX: ffff8880205b3a80
RDX: 0000000000000000 RSI: 00000000000001c0 RDI: 00000000000001c1
RBP: ffffc90003dff830 R08: ffffffff81e90e67 R09: fffffbfff1a433c3
R10: 0000000000000000 R11: dffffc0000000001 R12: 0000000000000000
R13: ffffc90003dff6c0 R14: 00000000000001c0 R15: 0000000000000000
FS:  00007fdbae5ee700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdbae6901e0 CR3: 000000007b2dd000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 madvise_collapse+0x721/0xf50 mm/khugepaged.c:2693
 madvise_vma_behavior mm/madvise.c:1086 [inline]
 madvise_walk_vmas mm/madvise.c:1260 [inline]
 do_madvise+0x9e5/0x4680 mm/madvise.c:1439
 __do_sys_madvise mm/madvise.c:1452 [inline]
 __se_sys_madvise mm/madvise.c:1450 [inline]
 __x64_sys_madvise+0xa5/0xb0 mm/madvise.c:1450
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The xas_store() call during page cache scanning can potentially translate
'xas' into the error state (with the reproducer provided by the syzkaller
the error code is -ENOMEM).  However, there are no further checks after
the 'xas_store', and the next call of 'xas_next' at the start of the
scanning cycle doesn't increase the xa_index, and the issue occurs.

This patch will add the xarray state error checking after the xas_store()
and the corresponding result error code.

Tested via syzbot.

Link: https://lkml.kernel.org/r/20230329145330.23191-1-ivan.orlov0322@gmail.com
Link: https://syzkaller.appspot.com/bug?id=7d6bb3760e026ece7524500fe44fb024a0e959fc
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reported-by: syzbot+9578faa5475acb35fa50@syzkaller.appspotmail.com
Cc: Himadri Pandya <himadrispandya@gmail.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file
+++ a/mm/khugepaged.c
@@ -55,6 +55,7 @@ enum scan_result {
 	SCAN_CGROUP_CHARGE_FAIL,
 	SCAN_TRUNCATED,
 	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_STORE_FAILED,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1840,6 +1841,15 @@ static int collapse_file(struct mm_struc
 					goto xa_locked;
 				}
 				xas_store(&xas, hpage);
+				if (xas_error(&xas)) {
+					/* revert shmem_charge performed
+					 * in the previous condition
+					 */
+					mapping->nrpages--;
+					shmem_uncharge(mapping->host, 1);
+					result = SCAN_STORE_FAILED;
+					goto xa_locked;
+				}
 				nr_none++;
 				continue;
 			}
_

Patches currently in -mm which might be from ivan.orlov0322@gmail.com are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch

