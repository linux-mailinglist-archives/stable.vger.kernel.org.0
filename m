Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A224F0904
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 13:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiDCLim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 07:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiDCLil (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 07:38:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D7D37005
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 04:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F0736106D
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 11:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B23AC340F0;
        Sun,  3 Apr 2022 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648985807;
        bh=6OKR76nzsOmAwuGzQZEnaIKUvD8CQXl249iki/r1WO8=;
        h=Subject:To:Cc:From:Date:From;
        b=hJRfQufKSK2oKS3usnCgVauEJQVIr23ZjhjUGgI+o8l3e7xbvMa0eFfzJtlDmb8UZ
         vozazo72R+8/FfAmetbFJRV6q4xzipL89D2y5O5LvCBXD/SOKlw/6YYpyGaRNumrW1
         PN1J7Kzl3d1tbb0v/WP6HTtImE+AO/f23/quEoCg=
Subject: FAILED: patch "[PATCH] ubifs: rename_whiteout: Fix double free for whiteout_ui->data" failed to apply to 4.9-stable tree
To:     chengzhihao1@huawei.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 13:36:44 +0200
Message-ID: <164898580418665@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 40a8f0d5e7b3999f096570edab71c345da812e3e Mon Sep 17 00:00:00 2001
From: Zhihao Cheng <chengzhihao1@huawei.com>
Date: Mon, 27 Dec 2021 11:22:32 +0800
Subject: [PATCH] ubifs: rename_whiteout: Fix double free for whiteout_ui->data

'whiteout_ui->data' will be freed twice if space budget fail for
rename whiteout operation as following process:

rename_whiteout
  dev = kmalloc
  whiteout_ui->data = dev
  kfree(whiteout_ui->data)  // Free first time
  iput(whiteout)
    ubifs_free_inode
      kfree(ui->data)	    // Double free!

KASAN reports:
==================================================================
BUG: KASAN: double-free or invalid-free in ubifs_free_inode+0x4f/0x70
Call Trace:
  kfree+0x117/0x490
  ubifs_free_inode+0x4f/0x70 [ubifs]
  i_callback+0x30/0x60
  rcu_do_batch+0x366/0xac0
  __do_softirq+0x133/0x57f

Allocated by task 1506:
  kmem_cache_alloc_trace+0x3c2/0x7a0
  do_rename+0x9b7/0x1150 [ubifs]
  ubifs_rename+0x106/0x1f0 [ubifs]
  do_syscall_64+0x35/0x80

Freed by task 1506:
  kfree+0x117/0x490
  do_rename.cold+0x53/0x8a [ubifs]
  ubifs_rename+0x106/0x1f0 [ubifs]
  do_syscall_64+0x35/0x80

The buggy address belongs to the object at ffff88810238bed8 which
belongs to the cache kmalloc-8 of size 8
==================================================================

Let ubifs_free_inode() free 'whiteout_ui->data'. BTW, delete unused
assignment 'whiteout_ui->data_len = 0', process 'ubifs_evict_inode()
-> ubifs_jnl_delete_inode() -> ubifs_jnl_write_inode()' doesn't need it
(because 'inc_nlink(whiteout)' won't be excuted by 'goto out_release',
 and the nlink of whiteout inode is 0).

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index dbe72f664abf..d3ed93d94930 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1425,8 +1425,6 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		err = ubifs_budget_space(c, &wht_req);
 		if (err) {
-			kfree(whiteout_ui->data);
-			whiteout_ui->data_len = 0;
 			iput(whiteout);
 			goto out_release;
 		}

