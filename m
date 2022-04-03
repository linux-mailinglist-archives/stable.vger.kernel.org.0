Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD944F0915
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 13:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357003AbiDCLk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 07:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357005AbiDCLk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 07:40:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC6DBE1E
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 04:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13CDBB80BFA
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 11:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C776C340F0;
        Sun,  3 Apr 2022 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648985911;
        bh=Mp8NMOHIQeX8r/oBJPgkcIvTN2R3HkAEsOcMbqjhr+s=;
        h=Subject:To:Cc:From:Date:From;
        b=iLliiYJj+uMYFSSX3mnAcS/xadqoc3mOXXeSRrItDzY4deWMPSz7HaQPOlIDygfT5
         Rcbr8j5qUcvN93ZEfFwkc2jBsVk/h6dnngJJFoC64eO/N2IUowH5ZkycqiCdL3qVly
         t7kVlcwWP7z5QQlHGJcEFtbdKG5BwpR2g9FXoRzw=
Subject: FAILED: patch "[PATCH] ubifs: Rectify space amount budget for mkdir/tmpfile" failed to apply to 5.4-stable tree
To:     chengzhihao1@huawei.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 13:38:20 +0200
Message-ID: <164898590016116@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a6dab6607d4681d227905d5198710b575dbdb519 Mon Sep 17 00:00:00 2001
From: Zhihao Cheng <chengzhihao1@huawei.com>
Date: Mon, 27 Dec 2021 11:22:38 +0800
Subject: [PATCH] ubifs: Rectify space amount budget for mkdir/tmpfile
 operations

UBIFS should make sure the flash has enough space to store dirty (Data
that is newer than disk) data (in memory), space budget is exactly
designed to do that. If space budget calculates less data than we need,
'make_reservation()' will do more work(return -ENOSPC if no free space
lelf, sometimes we can see "cannot reserve xxx bytes in jhead xxx, error
-28" in ubifs error messages) with ubifs inodes locked, which may effect
other syscalls.

A simple way to decide how much space do we need when make a budget:
See how much space is needed by 'make_reservation()' in ubifs_jnl_xxx()
function according to corresponding operation.

It's better to report ENOSPC in ubifs_budget_space(), as early as we can.

Fixes: 474b93704f32163 ("ubifs: Implement O_TMPFILE")
Fixes: 1e51764a3c2ac05 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index faca567ef06b..ae082a0be2a3 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -428,15 +428,18 @@ static int ubifs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
 {
 	struct inode *inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1};
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1 };
 	struct ubifs_inode *ui;
 	int err, instantiated = 0;
 	struct fscrypt_name nm;
 
 	/*
-	 * Budget request settings: new dirty inode, new direntry,
-	 * budget for dirtied inode will be released via writeback.
+	 * Budget request settings: new inode, new direntry, changing the
+	 * parent directory inode.
+	 * Allocate budget separately for new dirtied inode, the budget will
+	 * be released via writeback.
 	 */
 
 	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
@@ -979,7 +982,8 @@ static int ubifs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	struct ubifs_inode *dir_ui = ubifs_inode(dir);
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 	int err, sz_change;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct fscrypt_name nm;
 
 	/*

