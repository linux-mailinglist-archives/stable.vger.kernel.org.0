Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9436B4489
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjCJOZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbjCJOYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:24:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A882C10DE76
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:23:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45ED3618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1A3C433D2;
        Fri, 10 Mar 2023 14:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458220;
        bh=WmY4WOHV/4WsG8QuztXRyrrc8gE7y66aJg+FsFNN/sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhljHntwhaEpN6EPlodvZSw2gEO4T98HQ7525FEp7T803ra4tyf8BzZrGwDKzC+iH
         QXN5l8lX2TN0sSS+GZSC5RDHx+YA+uBRmdSEJ9MAZqBNQExJB2QZFb9FtxQI0dBcEA
         YWPumgLrBXcDu0WlkzzmVuA9p7OiJ0YE8zE1CytM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 205/252] ubifs: do_rename: Fix wrong space budget when target inodes nlink > 1
Date:   Fri, 10 Mar 2023 14:39:35 +0100
Message-Id: <20230310133725.283403715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 25fce616a61fc2f1821e4a9ce212d0e064707093 ]

If target inode is a special file (eg. block/char device) with nlink
count greater than 1, the inode with ui->data will be re-written on
disk. However, UBIFS losts target inode's data_len while doing space
budget. Bad space budget may let make_reservation() return with -ENOSPC,
which could turn ubifs to read-only mode in do_writepage() process.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216494
Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 89c5c2abc0faf..3b93b14e00412 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1309,9 +1309,13 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 		old_dentry, old_inode->i_ino, old_dir->i_ino,
 		new_dentry, new_dir->i_ino, flags);
 
-	if (unlink)
+	if (unlink) {
 		ubifs_assert(c, inode_is_locked(new_inode));
 
+		/* Budget for old inode's data when its nlink > 1. */
+		req.dirtied_ino_d = ALIGN(ubifs_inode(new_inode)->data_len, 8);
+	}
+
 	if (unlink && is_dir) {
 		err = ubifs_check_dir_empty(new_inode);
 		if (err)
-- 
2.39.2



