Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95695F7E5D
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 21:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJGT5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJGT5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 15:57:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC05BB40EF;
        Fri,  7 Oct 2022 12:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8039B61747;
        Fri,  7 Oct 2022 19:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AFFC433C1;
        Fri,  7 Oct 2022 19:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665172654;
        bh=3ioUGXOwIHSSgzA9Xb+oDLQYye2pqliCmNaClnJCjcQ=;
        h=Date:To:From:Subject:From;
        b=P2zDwmoIqgaSbLiomwUGnP7CGTAJJMQqy8+FB/VEa22z2QglLDLjvrEzm2zjOAVfh
         6ASQqIrk/Jin0gU3YaA4fDD9WPdKkHXhvCKXOPleHqcn+ypEX3mPGLYxZJo2ZzSyZZ
         BTYIFpVL/IaRWOzKLXEra21x70NlXJaPwMjEO+CU=
Date:   Fri, 07 Oct 2022 12:57:34 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-leak-of-nilfs_root-in-case-of-writer-thread-creation-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20221007195734.D3AFFC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix leak of nilfs_root in case of writer thread creation failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-leak-of-nilfs_root-in-case-of-writer-thread-creation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-leak-of-nilfs_root-in-case-of-writer-thread-creation-failure.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix leak of nilfs_root in case of writer thread creation failure
Date: Fri, 7 Oct 2022 17:52:26 +0900

If nilfs_attach_log_writer() failed to create a log writer thread, it
frees a data structure of the log writer without any cleanup.  After
commit e912a5b66837 ("nilfs2: use root object to get ifile"), this causes
a leak of struct nilfs_root, which started to leak an ifile metadata inode
and a kobject on that struct.

In addition, if the kernel is booted with panic_on_warn, the above
ifile metadata inode leak will cause the following panic when the
nilfs2 kernel module is removed:

  kmem_cache_destroy nilfs2_inode_cache: Slab cache still has objects when
  called from nilfs_destroy_cachep+0x16/0x3a [nilfs2]
  WARNING: CPU: 8 PID: 1464 at mm/slab_common.c:494 kmem_cache_destroy+0x138/0x140
  ...
  RIP: 0010:kmem_cache_destroy+0x138/0x140
  Code: 00 20 00 00 e8 a9 55 d8 ff e9 76 ff ff ff 48 8b 53 60 48 c7 c6 20 70 65 86 48 c7 c7 d8 69 9c 86 48 8b 4c 24 28 e8 ef 71 c7 00 <0f> 0b e9 53 ff ff ff c3 48 81 ff ff 0f 00 00 77 03 31 c0 c3 53 48
  ...
  Call Trace:
   <TASK>
   ? nilfs_palloc_freev.cold.24+0x58/0x58 [nilfs2]
   nilfs_destroy_cachep+0x16/0x3a [nilfs2]
   exit_nilfs_fs+0xa/0x1b [nilfs2]
    __x64_sys_delete_module+0x1d9/0x3a0
   ? __sanitizer_cov_trace_pc+0x1a/0x50
   ? syscall_trace_enter.isra.19+0x119/0x190
   do_syscall_64+0x34/0x80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
   ...
   </TASK>
  Kernel panic - not syncing: panic_on_warn set ...

This patch fixes these issues by calling nilfs_detach_log_writer() cleanup
function if spawning the log writer thread fails.

Link: https://lkml.kernel.org/r/20221007085226.57667-1-konishi.ryusuke@gmail.com
Fixes: e912a5b66837 ("nilfs2: use root object to get ifile")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+7381dc4ad60658ca4c05@syzkaller.appspotmail.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-fix-leak-of-nilfs_root-in-case-of-writer-thread-creation-failure
+++ a/fs/nilfs2/segment.c
@@ -2786,10 +2786,9 @@ int nilfs_attach_log_writer(struct super
 	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
 
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
-	if (err) {
-		kfree(nilfs->ns_writer);
-		nilfs->ns_writer = NULL;
-	}
+	if (unlikely(err))
+		nilfs_detach_log_writer(sb);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-use-after-free-bug-of-struct-nilfs_root.patch
nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch
nilfs2-fix-leak-of-nilfs_root-in-case-of-writer-thread-creation-failure.patch
nilfs2-replace-warn_ons-by-nilfs_error-for-checkpoint-acquisition-failure.patch

