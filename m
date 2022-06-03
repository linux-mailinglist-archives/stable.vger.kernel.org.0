Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA8C53CD80
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344072AbiFCQsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 12:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344080AbiFCQsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 12:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383EB515B3
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 09:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B3E61A0C
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 16:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B457BC385A9;
        Fri,  3 Jun 2022 16:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654274918;
        bh=vxItDf59MjfML9lnPt1m5lqUXfgrYqjfvFns6kc4qOg=;
        h=Subject:To:Cc:From:Date:From;
        b=U4VqsyLMbKP220HTPrjOadx27f6bUIINeBbqQkM+t/A2xn9RfpPDPheq18SaDY7Ci
         ftx2TMI5dfy8DjQFNxngTbbZ1RI4zJswiGNfdy/l59dlA0lOIz6ckKq/tqah7vzk8W
         IHZxE5Q9zJYgky8tNcgsbt54eNy/VahDMXM++YuA=
Subject: FAILED: patch "[PATCH] nfsd: Fix null-ptr-deref in nfsd_fill_super()" failed to apply to 5.4-stable tree
To:     zhangxiaoxu5@huawei.com, chuck.lever@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 18:48:19 +0200
Message-ID: <1654274899221142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6f6f84aa215f7b6665ccbb937db50860f9ec2989 Mon Sep 17 00:00:00 2001
From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Date: Sat, 21 May 2022 12:08:45 +0800
Subject: [PATCH] nfsd: Fix null-ptr-deref in nfsd_fill_super()

KASAN report null-ptr-deref as follows:

  BUG: KASAN: null-ptr-deref in nfsd_fill_super+0xc6/0xe0 [nfsd]
  Write of size 8 at addr 000000000000005d by task a.out/852

  CPU: 7 PID: 852 Comm: a.out Not tainted 5.18.0-rc7-dirty #66
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   kasan_report+0xab/0x120
   ? nfsd_mkdir+0x71/0x1c0 [nfsd]
   ? nfsd_fill_super+0xc6/0xe0 [nfsd]
   nfsd_fill_super+0xc6/0xe0 [nfsd]
   ? nfsd_mkdir+0x1c0/0x1c0 [nfsd]
   get_tree_keyed+0x8e/0x100
   vfs_get_tree+0x41/0xf0
   __do_sys_fsconfig+0x590/0x670
   ? fscontext_read+0x180/0x180
   ? anon_inode_getfd+0x4f/0x70
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This can be reproduce by concurrent operations:
	1. fsopen(nfsd)/fsconfig
	2. insmod/rmmod nfsd

Since the nfsd file system is registered before than nfsd_net allocated,
the caller may get the file_system_type and use the nfsd_net before it
allocated, then null-ptr-deref occurred.

So init_nfsd() should call register_filesystem() last.

Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 55949e60897d..0621c2faf242 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1535,25 +1535,25 @@ static int __init init_nfsd(void)
 	retval = create_proc_exports_entry();
 	if (retval)
 		goto out_free_lockd;
-	retval = register_filesystem(&nfsd_fs_type);
-	if (retval)
-		goto out_free_exports;
 	retval = register_pernet_subsys(&nfsd_net_ops);
 	if (retval < 0)
-		goto out_free_filesystem;
+		goto out_free_exports;
 	retval = register_cld_notifier();
 	if (retval)
 		goto out_free_subsys;
 	retval = nfsd4_create_laundry_wq();
+	if (retval)
+		goto out_free_cld;
+	retval = register_filesystem(&nfsd_fs_type);
 	if (retval)
 		goto out_free_all;
 	return 0;
 out_free_all:
+	nfsd4_destroy_laundry_wq();
+out_free_cld:
 	unregister_cld_notifier();
 out_free_subsys:
 	unregister_pernet_subsys(&nfsd_net_ops);
-out_free_filesystem:
-	unregister_filesystem(&nfsd_fs_type);
 out_free_exports:
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);
@@ -1571,6 +1571,7 @@ static int __init init_nfsd(void)
 
 static void __exit exit_nfsd(void)
 {
+	unregister_filesystem(&nfsd_fs_type);
 	nfsd4_destroy_laundry_wq();
 	unregister_cld_notifier();
 	unregister_pernet_subsys(&nfsd_net_ops);
@@ -1581,7 +1582,6 @@ static void __exit exit_nfsd(void)
 	nfsd_lockd_shutdown();
 	nfsd4_free_slabs();
 	nfsd4_exit_pnfs();
-	unregister_filesystem(&nfsd_fs_type);
 }
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");

