Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DAA56A9F6
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiGGRro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 13:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiGGRrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 13:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26E55C977;
        Thu,  7 Jul 2022 10:47:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12502620A6;
        Thu,  7 Jul 2022 17:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E9DC341C0;
        Thu,  7 Jul 2022 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657216059;
        bh=3aP6xJLpeoifWw1fIfq1b/9aP4YULhLH7y4W8nJ0Ngw=;
        h=Date:To:From:Subject:From;
        b=TpirIbQzYG7Dq8yH6IJenUbsBLUyL+IEqdGLxyMq8Ygo5qmSiH5w0ws93gwP/tFK1
         1etr5mKv161n9ipcbCgeAeYiTiokBbMDLObUyvSdWtdMdA+bb6Nv7W/lbzAur8OLDT
         ZPTVAbyCN0d/Ds3611Cfrt8xpSMNv+c/lyG6LWxI=
Date:   Thu, 07 Jul 2022 10:47:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, hdanton@sina.com, ebiggers@kernel.org,
        axelrasmussen@google.com, rppt@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + secretmem-fix-unhandled-fault-in-truncate.patch added to mm-hotfixes-unstable branch
Message-Id: <20220707174739.64E9DC341C0@smtp.kernel.org>
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
     Subject: secretmem: fix unhandled fault in truncate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     secretmem-fix-unhandled-fault-in-truncate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/secretmem-fix-unhandled-fault-in-truncate.patch

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
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: secretmem: fix unhandled fault in truncate
Date: Thu, 7 Jul 2022 19:56:50 +0300

syzkaller reports the following issue:

BUG: unable to handle page fault for address: ffff888021f7e005
PGD 11401067 P4D 11401067 PUD 11402067 PMD 21f7d063 PTE 800fffffde081060
Oops: 0002 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3761 Comm: syz-executor281 Not tainted 5.19.0-rc4-syzkaller-00014-g941e3e791269 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:64
Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
RSP: 0018:ffffc9000329fa90 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000000ffb
RDX: 0000000000000ffb RSI: 0000000000000000 RDI: ffff888021f7e005
RBP: ffffea000087df80 R08: 0000000000000001 R09: ffff888021f7e005
R10: ffffed10043efdff R11: 0000000000000000 R12: 0000000000000005
R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000000ffb
FS:  00007fb29d8b2700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff888021f7e005 CR3: 0000000026e7b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 zero_user_segments include/linux/highmem.h:272 [inline]
 folio_zero_range include/linux/highmem.h:428 [inline]
 truncate_inode_partial_folio+0x76a/0xdf0 mm/truncate.c:237
 truncate_inode_pages_range+0x83b/0x1530 mm/truncate.c:381
 truncate_inode_pages mm/truncate.c:452 [inline]
 truncate_pagecache+0x63/0x90 mm/truncate.c:753
 simple_setattr+0xed/0x110 fs/libfs.c:535
 secretmem_setattr+0xae/0xf0 mm/secretmem.c:170
 notify_change+0xb8c/0x12b0 fs/attr.c:424
 do_truncate+0x13c/0x200 fs/open.c:65
 do_sys_ftruncate+0x536/0x730 fs/open.c:193
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fb29d900899
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb29d8b2318 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
RAX: ffffffffffffffda RBX: 00007fb29d988408 RCX: 00007fb29d900899
RDX: 00007fb29d900899 RSI: 0000000000000005 RDI: 0000000000000003
RBP: 00007fb29d988400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb29d98840c
R13: 00007ffca01a23bf R14: 00007fb29d8b2400 R15: 0000000000022000
 </TASK>
Modules linked in:
CR2: ffff888021f7e005
---[ end trace 0000000000000000 ]---

Eric Biggers suggested that this happens when
secretmem_setattr()->simple_setattr() races with secretmem_fault() so that
a page that is faulted in by secretmem_fault() (and thus removed from the
direct map) is zeroed by inode truncation right afterwards.

Since do_truncate() takes inode_lock(), adding inode_lock_shared() to
secretmem_fault() prevents the race.

Link: https://lkml.kernel.org/r/20220707165650.248088-1-rppt@kernel.org
Reported-by: syzbot+9bd2b7adbd34b30b87e4@syzkaller.appspotmail.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/secretmem.c~secretmem-fix-unhandled-fault-in-truncate
+++ a/mm/secretmem.c
@@ -55,22 +55,28 @@ static vm_fault_t secretmem_fault(struct
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
 	struct page *page;
+	vm_fault_t ret;
 	int err;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return vmf_error(-EINVAL);
 
+	inode_lock_shared(inode);
+
 retry:
 	page = find_lock_page(mapping, offset);
 	if (!page) {
 		page = alloc_page(gfp | __GFP_ZERO);
-		if (!page)
-			return VM_FAULT_OOM;
+		if (!page) {
+			ret = VM_FAULT_OOM;
+			goto out;
+		}
 
 		err = set_direct_map_invalid_noflush(page);
 		if (err) {
 			put_page(page);
-			return vmf_error(err);
+			ret = vmf_error(err);
+			goto out;
 		}
 
 		__SetPageUptodate(page);
@@ -86,7 +92,8 @@ retry:
 			if (err == -EEXIST)
 				goto retry;
 
-			return vmf_error(err);
+			ret = vmf_error(err);
+			goto out;
 		}
 
 		addr = (unsigned long)page_address(page);
@@ -94,7 +101,11 @@ retry:
 	}
 
 	vmf->page = page;
-	return VM_FAULT_LOCKED;
+	ret = VM_FAULT_LOCKED;
+
+out:
+	inode_unlock_shared(inode);
+	return ret;
 }
 
 static const struct vm_operations_struct secretmem_vm_ops = {
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

secretmem-fix-unhandled-fault-in-truncate.patch
csky-drop-definition-of-pte_order.patch
csky-drop-definition-of-pgd_order.patch
mips-rename-pud_order-to-pud_table_order.patch
mips-drop-definitions-of-pte_order.patch
mips-rename-pgd_order-to-pgd_table_order.patch
nios2-drop-definition-of-pte_order.patch
nios2-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pte_order.patch
loongarch-drop-definition-of-pmd_order.patch
loongarch-drop-definition-of-pud_order.patch
loongarch-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pgd_order-v2.patch
parisc-rename-pgd_order-to-pgd_table_order.patch
xtensa-drop-definition-of-pgd_order.patch
arm-heads-rename-pmd_order-to-pmd_entry_order.patch

