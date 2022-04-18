Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84741505679
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242057AbiDRNfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244942AbiDRNbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:31:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847E01F637;
        Mon, 18 Apr 2022 05:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1347B80EC0;
        Mon, 18 Apr 2022 12:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDD7C385C5;
        Mon, 18 Apr 2022 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286658;
        bh=GIE3HzTDpwckLqB/Xz8Djr2o/FKp2Cb43+btUx8kDUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5miZ7m5e9tQTS3HAMSvfi9CS+YQBpV5zeZc0LQoiNKEUIb3B7Q61FGskECWUO75y
         oUHZ6OJPgPfR3tP5cFiY38wc6j+n3/Fh2FBsFEdus6jhAi1N6Z+7H7de1r3JCif7cq
         STNT15sGzboOG0ciB3+VmkLPKWnd8d3elnbL+AW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 203/284] ubifs: Rectify space amount budget for mkdir/tmpfile operations
Date:   Mon, 18 Apr 2022 14:13:04 +0200
Message-Id: <20220418121217.497469705@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit a6dab6607d4681d227905d5198710b575dbdb519 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 12356dcc3ecb..299611052bbf 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -390,15 +390,18 @@ static int do_tmpfile(struct inode *dir, struct dentry *dentry,
 {
 	struct inode *inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1};
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1 };
 	struct ubifs_inode *ui, *dir_ui = ubifs_inode(dir);
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
@@ -990,7 +993,8 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct ubifs_inode *dir_ui = ubifs_inode(dir);
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 	int err, sz_change;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct fscrypt_name nm;
 
 	/*
-- 
2.35.1



