Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A1D59240B
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbiHNQ1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242227AbiHNQ1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:27:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E05A19C35;
        Sun, 14 Aug 2022 09:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6ED3B80B7E;
        Sun, 14 Aug 2022 16:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5D7C433D6;
        Sun, 14 Aug 2022 16:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494203;
        bh=3Cx6uIp12/bxIh8U635RMb8+E2YBg42NLG6gUoikfnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0B4TiaGymHRpdpUjUduV8YxDJLw2NSp3yTDm9ZxHVBwVa9pTiKsx7TyLriblNM1P
         /EorWO8+yebH5EHqc+a9RSC0buGCn669c6yZi76+putctn2i5QNFrqZohwrrqSoxte
         OYmVapLK1oPkWGmbHBfM1NcPuL3pfUsuw7zoCHJpvhwnE4zW917j5jwdCyMwxVDLX7
         6b8RvMi1s08DRTaeLOQGzYLkUH6Gc0I3puoJP5xfvGHqHK4YRWypNcLLPhioq5Mi2Y
         135e3M3RHPd5Ood4KsSRrLK32lRDXQ9i5/HZYK1Lx7N5xqXrHyYziwQRyS3HvO6j7m
         u4ohA+Pz7uIgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daeho Jeong <daehojeong@google.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.19 47/48] f2fs: revive F2FS_IOC_ABORT_VOLATILE_WRITE
Date:   Sun, 14 Aug 2022 12:19:40 -0400
Message-Id: <20220814161943.2394452-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 23339e5752d01a4b5e122759b002cf896d26f6c1 ]

F2FS_IOC_ABORT_VOLATILE_WRITE was used to abort a atomic write before.
However it was removed accidentally. So revive it by changing the name,
since volatile write had gone.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Fiexes: 7bc155fec5b3("f2fs: kill volatile write support")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c            | 30 ++++++++++++++++++++++++++++--
 include/uapi/linux/f2fs.h |  2 +-
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index bd14cef1b08f..2ab33fc5ee13 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2115,6 +2115,31 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 	return ret;
 }
 
+static int f2fs_ioc_abort_atomic_write(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+	struct user_namespace *mnt_userns = file_mnt_user_ns(filp);
+	int ret;
+
+	if (!inode_owner_or_capable(mnt_userns, inode))
+		return -EACCES;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	inode_lock(inode);
+
+	if (f2fs_is_atomic_file(inode))
+		f2fs_abort_atomic_write(inode, true);
+
+	inode_unlock(inode);
+
+	mnt_drop_write_file(filp);
+	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
+	return ret;
+}
+
 static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -4060,9 +4085,10 @@ static long __f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_start_atomic_write(filp);
 	case F2FS_IOC_COMMIT_ATOMIC_WRITE:
 		return f2fs_ioc_commit_atomic_write(filp);
+	case F2FS_IOC_ABORT_ATOMIC_WRITE:
+		return f2fs_ioc_abort_atomic_write(filp);
 	case F2FS_IOC_START_VOLATILE_WRITE:
 	case F2FS_IOC_RELEASE_VOLATILE_WRITE:
-	case F2FS_IOC_ABORT_VOLATILE_WRITE:
 		return -EOPNOTSUPP;
 	case F2FS_IOC_SHUTDOWN:
 		return f2fs_ioc_shutdown(filp, arg);
@@ -4731,7 +4757,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC_COMMIT_ATOMIC_WRITE:
 	case F2FS_IOC_START_VOLATILE_WRITE:
 	case F2FS_IOC_RELEASE_VOLATILE_WRITE:
-	case F2FS_IOC_ABORT_VOLATILE_WRITE:
+	case F2FS_IOC_ABORT_ATOMIC_WRITE:
 	case F2FS_IOC_SHUTDOWN:
 	case FITRIM:
 	case FS_IOC_SET_ENCRYPTION_POLICY:
diff --git a/include/uapi/linux/f2fs.h b/include/uapi/linux/f2fs.h
index 352a822d4370..3121d127d5aa 100644
--- a/include/uapi/linux/f2fs.h
+++ b/include/uapi/linux/f2fs.h
@@ -13,7 +13,7 @@
 #define F2FS_IOC_COMMIT_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 2)
 #define F2FS_IOC_START_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 3)
 #define F2FS_IOC_RELEASE_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 4)
-#define F2FS_IOC_ABORT_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 5)
+#define F2FS_IOC_ABORT_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 5)
 #define F2FS_IOC_GARBAGE_COLLECT	_IOW(F2FS_IOCTL_MAGIC, 6, __u32)
 #define F2FS_IOC_WRITE_CHECKPOINT	_IO(F2FS_IOCTL_MAGIC, 7)
 #define F2FS_IOC_DEFRAGMENT		_IOWR(F2FS_IOCTL_MAGIC, 8,	\
-- 
2.35.1

