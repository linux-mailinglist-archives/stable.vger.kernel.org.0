Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D574163236
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBRUAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgBRUAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA3E24655;
        Tue, 18 Feb 2020 19:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055999;
        bh=lyZsnS0h6TGGW/VfN0c4oQr58ckhLVmklvBo/A/pFM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qddYIbDF30d4k7Uvw/LvL22SCRduk9+6odpOL49O5H5TEMJ84Dc9PVaPGKBxjdB2N
         WGh2EnEcxqhpPo0qSSWDTy6nrkFPxMSQo07tH8WAJeeCr+SzRSMP9wIKsuMaD2PcE7
         Fhi4Xgl4fyg/YMFiLrhwL4tRF02605bKRf8mrXgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/66] ext4: choose hardlimit when softlimit is larger than hardlimit in ext4_statfs_project()
Date:   Tue, 18 Feb 2020 20:55:30 +0100
Message-Id: <20200218190434.030902996@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit 57c32ea42f8e802bda47010418e25043e0c9337f ]

Setting softlimit larger than hardlimit seems meaningless
for disk quota but currently it is allowed. In this case,
there may be a bit of comfusion for users when they run
df comamnd to directory which has project quota.

For example, we set 20M softlimit and 10M hardlimit of
block usage limit for project quota of test_dir(project id 123).

[root@hades mnt_ext4]# repquota -P -a
*** Report for project quotas on device /dev/loop0
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
Project         used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
 0        --      13       0       0              2     0     0
 123      --   10237   20480   10240              5   200   100

The result of df command as below:

[root@hades mnt_ext4]# df -h test_dir
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0       20M   10M   10M  50% /home/cgxu/test/mnt_ext4

Even though it looks like there is another 10M free space to use,
if we write new data to diretory test_dir(inherit project id),
the write will fail with errno(-EDQUOT).

After this patch, the df result looks like below.

[root@hades mnt_ext4]# df -h test_dir
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0       10M   10M  3.0K 100% /home/cgxu/test/mnt_ext4

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191016022501.760-1-cgxu519@mykernel.net
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 95826bde9025b..914230e630544 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5540,9 +5540,15 @@ static int ext4_statfs_project(struct super_block *sb,
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = (dquot->dq_dqb.dqb_bsoftlimit ?
-		 dquot->dq_dqb.dqb_bsoftlimit :
-		 dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
+	limit = 0;
+	if (dquot->dq_dqb.dqb_bsoftlimit &&
+	    (!limit || dquot->dq_dqb.dqb_bsoftlimit < limit))
+		limit = dquot->dq_dqb.dqb_bsoftlimit;
+	if (dquot->dq_dqb.dqb_bhardlimit &&
+	    (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
+		limit = dquot->dq_dqb.dqb_bhardlimit;
+	limit >>= sb->s_blocksize_bits;
+
 	if (limit && buf->f_blocks > limit) {
 		curblock = (dquot->dq_dqb.dqb_curspace +
 			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
@@ -5552,9 +5558,14 @@ static int ext4_statfs_project(struct super_block *sb,
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = dquot->dq_dqb.dqb_isoftlimit ?
-		dquot->dq_dqb.dqb_isoftlimit :
-		dquot->dq_dqb.dqb_ihardlimit;
+	limit = 0;
+	if (dquot->dq_dqb.dqb_isoftlimit &&
+	    (!limit || dquot->dq_dqb.dqb_isoftlimit < limit))
+		limit = dquot->dq_dqb.dqb_isoftlimit;
+	if (dquot->dq_dqb.dqb_ihardlimit &&
+	    (!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
+		limit = dquot->dq_dqb.dqb_ihardlimit;
+
 	if (limit && buf->f_files > limit) {
 		buf->f_files = limit;
 		buf->f_ffree =
-- 
2.20.1



