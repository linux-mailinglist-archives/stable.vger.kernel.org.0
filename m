Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE38659D86E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbiHWJkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243334AbiHWJjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A837859E;
        Tue, 23 Aug 2022 01:41:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB2AB61499;
        Tue, 23 Aug 2022 08:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EE3C433D6;
        Tue, 23 Aug 2022 08:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243709;
        bh=qwM3ShvFVEwOhnb4lNkJcm+UOiGSvKD2PWo6NN8Oelg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9AE7zOFs+IX5JWJ3dn55yWwWX4Fzh0E+LUkEfXD39DN/6TncGfWmykWjfmIOm/Ct
         mVDxsn0eCnveapeHwohKdGHekSNKX4+oNidEHYqbQgOUO85Rldx35+ryBvPr1hBahc
         RvUyoPG8XnSTSXdhfeKm4OEoAdp2rkoGXRFIg3So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 362/365] f2fs: revive F2FS_IOC_ABORT_VOLATILE_WRITE
Date:   Tue, 23 Aug 2022 10:04:23 +0200
Message-Id: <20220823080133.443422112@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fc0f30738b21..41547604f192 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2108,6 +2108,31 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
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
@@ -4063,9 +4088,10 @@ static long __f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
@@ -4734,7 +4760,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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



