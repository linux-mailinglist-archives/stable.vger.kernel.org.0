Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048385FDFA3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiJMR4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiJMR4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:56:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16941CFE4;
        Thu, 13 Oct 2022 10:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAADE618F4;
        Thu, 13 Oct 2022 17:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD48DC433C1;
        Thu, 13 Oct 2022 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683684;
        bh=ixGC6c5QNd1hYNF90xkJ46CBLj9g67afRa4MeEm1zIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dv5xh/B/E49LzbNx/Hh145Bj6gcfTsD8s+I27EUbcb84CMfuY0VgOrRznaKomMojb
         IVxe0jCwSbnUqtNle20HR1wWSMhpGsv0uIUm/qayw0swmylbG9HYNBZjo/nywF9utX
         u7eYnMbgXR7/lRaaTz9YdQwvp7lNMJlHTsruAut4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+7381dc4ad60658ca4c05@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 03/54] nilfs2: fix leak of nilfs_root in case of writer thread creation failure
Date:   Thu, 13 Oct 2022 19:51:57 +0200
Message-Id: <20221013175147.429141425@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit d0d51a97063db4704a5ef6bc978dddab1636a306 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2791,10 +2791,9 @@ int nilfs_attach_log_writer(struct super
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
 


