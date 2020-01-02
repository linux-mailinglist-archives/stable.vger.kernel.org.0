Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36412F133
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgABWPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgABWPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C72E2253D;
        Thu,  2 Jan 2020 22:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003313;
        bh=V0fFlgsZEjywMSvwazLJJImMQhrXkl4rvnE6M1h6jak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLvMV+ljIDWD/fXdbe4Z3/1oXzt/BSKZHQwC7MZ3mW43rkKqzDZ0nOVtKfPQKqux9
         0r6p2f7IgNp6vD6WfO/L+KXlQh9mYqVPWGcjiN4yoNVkbgLk6b/QJtMszANlZqoSN5
         oJqd0knzEfzX10xuEnR8cJAnJXUdrYwKRzhQoggE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/191] f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()
Date:   Thu,  2 Jan 2020 23:06:30 +0100
Message-Id: <20200102215841.487559565@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit 909110c060f22e65756659ec6fa957ae75777e00 ]

Setting softlimit larger than hardlimit seems meaningless
for disk quota but currently it is allowed. In this case,
there may be a bit of comfusion for users when they run
df comamnd to directory which has project quota.

For example, we set 20M softlimit and 10M hardlimit of
block usage limit for project quota of test_dir(project id 123).

[root@hades f2fs]# repquota -P -a
*** Report for project quotas on device /dev/nvme0n1p8
Block grace time: 7days; Inode grace time: 7days
Block limits File limits
Project used soft hard grace used soft hard grace
----------------------------------------------------------------------
0 -- 4 0 0 1 0 0
123 +- 10248 20480 10240 2 0 0

The result of df command as below:

[root@hades f2fs]# df -h /mnt/f2fs/test
Filesystem Size Used Avail Use% Mounted on
/dev/nvme0n1p8 20M 11M 10M 51% /mnt/f2fs

Even though it looks like there is another 10M free space to use,
if we write new data to diretory test(inherit project id),
the write will fail with errno(-EDQUOT).

After this patch, the df result looks like below.

[root@hades f2fs]# df -h /mnt/f2fs/test
Filesystem Size Used Avail Use% Mounted on
/dev/nvme0n1p8 10M 10M 0 100% /mnt/f2fs

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1443cee15863..a2af155567b8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1213,9 +1213,13 @@ static int f2fs_statfs_project(struct super_block *sb,
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = (dquot->dq_dqb.dqb_bsoftlimit ?
-		 dquot->dq_dqb.dqb_bsoftlimit :
-		 dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
+	limit = 0;
+	if (dquot->dq_dqb.dqb_bsoftlimit)
+		limit = dquot->dq_dqb.dqb_bsoftlimit;
+	if (dquot->dq_dqb.dqb_bhardlimit &&
+			(!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
+		limit = dquot->dq_dqb.dqb_bhardlimit;
+
 	if (limit && buf->f_blocks > limit) {
 		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;
 		buf->f_blocks = limit;
@@ -1224,9 +1228,13 @@ static int f2fs_statfs_project(struct super_block *sb,
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = dquot->dq_dqb.dqb_isoftlimit ?
-		dquot->dq_dqb.dqb_isoftlimit :
-		dquot->dq_dqb.dqb_ihardlimit;
+	limit = 0;
+	if (dquot->dq_dqb.dqb_isoftlimit)
+		limit = dquot->dq_dqb.dqb_isoftlimit;
+	if (dquot->dq_dqb.dqb_ihardlimit &&
+			(!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
+		limit = dquot->dq_dqb.dqb_ihardlimit;
+
 	if (limit && buf->f_files > limit) {
 		buf->f_files = limit;
 		buf->f_ffree =
-- 
2.20.1



