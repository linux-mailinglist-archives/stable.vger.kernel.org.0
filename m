Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036D2383588
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240850AbhEQPXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243087AbhEQPRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:17:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A167561C65;
        Mon, 17 May 2021 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261994;
        bh=R2pOYF1CecIdaBWP8UyK7lhs94ym5AHYEM9Pw3LWvjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgKHuqB0v+uYHegPGunCBCoJD3g4qr/T0nMKgh5DRuM7iShcDO3H1eimVQ01uREAD
         8XZ7NOG7fiw5YOcso7gsDQYhN998AXAGsZxopthbWW5OrWvtatGskCx/sR+XBRuxUb
         Uo3C7WUC/6ooYlcvWAimzxcBcMMKJxpVfzU+u5ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/289] f2fs: fix compat F2FS_IOC_{MOVE,GARBAGE_COLLECT}_RANGE
Date:   Mon, 17 May 2021 16:00:21 +0200
Message-Id: <20210517140308.416005496@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 34178b1bc4b5c936eab3adb4835578093095a571 ]

Eric reported a ioctl bug in below link:

https://lore.kernel.org/linux-f2fs-devel/20201103032234.GB2875@sol.localdomain/

That said, on some 32-bit architectures, u64 has only 32-bit alignment,
notably i386 and x86_32, so that size of struct f2fs_gc_range compiled
in x86_32 is 20 bytes, however the size in x86_64 is 24 bytes, binary
compiled in x86_32 can not call F2FS_IOC_GARBAGE_COLLECT_RANGE successfully
due to mismatched value of ioctl command in between binary and f2fs
module, similarly, F2FS_IOC_MOVE_RANGE will fail too.

In this patch we introduce two ioctls for compatibility of above special
32-bit binary:
- F2FS_IOC32_GARBAGE_COLLECT_RANGE
- F2FS_IOC32_MOVE_RANGE

Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 137 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 104 insertions(+), 33 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 28f0bde38806..6850fb2081c8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2496,26 +2496,19 @@ out:
 	return ret;
 }
 
-static int f2fs_ioc_gc_range(struct file *filp, unsigned long arg)
+static int __f2fs_ioc_gc_range(struct file *filp, struct f2fs_gc_range *range)
 {
-	struct inode *inode = file_inode(filp);
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct f2fs_gc_range range;
+	struct f2fs_sb_info *sbi = F2FS_I_SB(file_inode(filp));
 	u64 end;
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	if (copy_from_user(&range, (struct f2fs_gc_range __user *)arg,
-							sizeof(range)))
-		return -EFAULT;
-
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
-	end = range.start + range.len;
-	if (end < range.start || range.start < MAIN_BLKADDR(sbi) ||
+	end = range->start + range->len;
+	if (end < range->start || range->start < MAIN_BLKADDR(sbi) ||
 					end >= MAX_BLKADDR(sbi))
 		return -EINVAL;
 
@@ -2524,7 +2517,7 @@ static int f2fs_ioc_gc_range(struct file *filp, unsigned long arg)
 		return ret;
 
 do_more:
-	if (!range.sync) {
+	if (!range->sync) {
 		if (!down_write_trylock(&sbi->gc_lock)) {
 			ret = -EBUSY;
 			goto out;
@@ -2533,20 +2526,30 @@ do_more:
 		down_write(&sbi->gc_lock);
 	}
 
-	ret = f2fs_gc(sbi, range.sync, true, GET_SEGNO(sbi, range.start));
+	ret = f2fs_gc(sbi, range->sync, true, GET_SEGNO(sbi, range->start));
 	if (ret) {
 		if (ret == -EBUSY)
 			ret = -EAGAIN;
 		goto out;
 	}
-	range.start += BLKS_PER_SEC(sbi);
-	if (range.start <= end)
+	range->start += BLKS_PER_SEC(sbi);
+	if (range->start <= end)
 		goto do_more;
 out:
 	mnt_drop_write_file(filp);
 	return ret;
 }
 
+static int f2fs_ioc_gc_range(struct file *filp, unsigned long arg)
+{
+	struct f2fs_gc_range range;
+
+	if (copy_from_user(&range, (struct f2fs_gc_range __user *)arg,
+							sizeof(range)))
+		return -EFAULT;
+	return __f2fs_ioc_gc_range(filp, &range);
+}
+
 static int f2fs_ioc_write_checkpoint(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -2883,9 +2886,9 @@ out:
 	return ret;
 }
 
-static int f2fs_ioc_move_range(struct file *filp, unsigned long arg)
+static int __f2fs_ioc_move_range(struct file *filp,
+				struct f2fs_move_range *range)
 {
-	struct f2fs_move_range range;
 	struct fd dst;
 	int err;
 
@@ -2893,11 +2896,7 @@ static int f2fs_ioc_move_range(struct file *filp, unsigned long arg)
 			!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (copy_from_user(&range, (struct f2fs_move_range __user *)arg,
-							sizeof(range)))
-		return -EFAULT;
-
-	dst = fdget(range.dst_fd);
+	dst = fdget(range->dst_fd);
 	if (!dst.file)
 		return -EBADF;
 
@@ -2910,8 +2909,8 @@ static int f2fs_ioc_move_range(struct file *filp, unsigned long arg)
 	if (err)
 		goto err_out;
 
-	err = f2fs_move_file_range(filp, range.pos_in, dst.file,
-					range.pos_out, range.len);
+	err = f2fs_move_file_range(filp, range->pos_in, dst.file,
+					range->pos_out, range->len);
 
 	mnt_drop_write_file(filp);
 	if (err)
@@ -2925,6 +2924,16 @@ err_out:
 	return err;
 }
 
+static int f2fs_ioc_move_range(struct file *filp, unsigned long arg)
+{
+	struct f2fs_move_range range;
+
+	if (copy_from_user(&range, (struct f2fs_move_range __user *)arg,
+							sizeof(range)))
+		return -EFAULT;
+	return __f2fs_ioc_move_range(filp, &range);
+}
+
 static int f2fs_ioc_flush_device(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -3961,13 +3970,8 @@ err:
 	return ret;
 }
 
-long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static long __f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	if (unlikely(f2fs_cp_error(F2FS_I_SB(file_inode(filp)))))
-		return -EIO;
-	if (!f2fs_is_checkpoint_ready(F2FS_I_SB(file_inode(filp))))
-		return -ENOSPC;
-
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
 		return f2fs_ioc_getflags(filp, arg);
@@ -4054,6 +4058,16 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 }
 
+long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	if (unlikely(f2fs_cp_error(F2FS_I_SB(file_inode(filp)))))
+		return -EIO;
+	if (!f2fs_is_checkpoint_ready(F2FS_I_SB(file_inode(filp))))
+		return -ENOSPC;
+
+	return __f2fs_ioctl(filp, cmd, arg);
+}
+
 static ssize_t f2fs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -4176,8 +4190,63 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
+struct compat_f2fs_gc_range {
+	u32 sync;
+	compat_u64 start;
+	compat_u64 len;
+};
+#define F2FS_IOC32_GARBAGE_COLLECT_RANGE	_IOW(F2FS_IOCTL_MAGIC, 11,\
+						struct compat_f2fs_gc_range)
+
+static int f2fs_compat_ioc_gc_range(struct file *file, unsigned long arg)
+{
+	struct compat_f2fs_gc_range __user *urange;
+	struct f2fs_gc_range range;
+	int err;
+
+	urange = compat_ptr(arg);
+	err = get_user(range.sync, &urange->sync);
+	err |= get_user(range.start, &urange->start);
+	err |= get_user(range.len, &urange->len);
+	if (err)
+		return -EFAULT;
+
+	return __f2fs_ioc_gc_range(file, &range);
+}
+
+struct compat_f2fs_move_range {
+	u32 dst_fd;
+	compat_u64 pos_in;
+	compat_u64 pos_out;
+	compat_u64 len;
+};
+#define F2FS_IOC32_MOVE_RANGE		_IOWR(F2FS_IOCTL_MAGIC, 9,	\
+					struct compat_f2fs_move_range)
+
+static int f2fs_compat_ioc_move_range(struct file *file, unsigned long arg)
+{
+	struct compat_f2fs_move_range __user *urange;
+	struct f2fs_move_range range;
+	int err;
+
+	urange = compat_ptr(arg);
+	err = get_user(range.dst_fd, &urange->dst_fd);
+	err |= get_user(range.pos_in, &urange->pos_in);
+	err |= get_user(range.pos_out, &urange->pos_out);
+	err |= get_user(range.len, &urange->len);
+	if (err)
+		return -EFAULT;
+
+	return __f2fs_ioc_move_range(file, &range);
+}
+
 long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	if (unlikely(f2fs_cp_error(F2FS_I_SB(file_inode(file)))))
+		return -EIO;
+	if (!f2fs_is_checkpoint_ready(F2FS_I_SB(file_inode(file))))
+		return -ENOSPC;
+
 	switch (cmd) {
 	case FS_IOC32_GETFLAGS:
 		cmd = FS_IOC_GETFLAGS;
@@ -4188,6 +4257,10 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC32_GETVERSION:
 		cmd = FS_IOC_GETVERSION;
 		break;
+	case F2FS_IOC32_GARBAGE_COLLECT_RANGE:
+		return f2fs_compat_ioc_gc_range(file, arg);
+	case F2FS_IOC32_MOVE_RANGE:
+		return f2fs_compat_ioc_move_range(file, arg);
 	case F2FS_IOC_START_ATOMIC_WRITE:
 	case F2FS_IOC_COMMIT_ATOMIC_WRITE:
 	case F2FS_IOC_START_VOLATILE_WRITE:
@@ -4205,10 +4278,8 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 	case FS_IOC_GET_ENCRYPTION_NONCE:
 	case F2FS_IOC_GARBAGE_COLLECT:
-	case F2FS_IOC_GARBAGE_COLLECT_RANGE:
 	case F2FS_IOC_WRITE_CHECKPOINT:
 	case F2FS_IOC_DEFRAGMENT:
-	case F2FS_IOC_MOVE_RANGE:
 	case F2FS_IOC_FLUSH_DEVICE:
 	case F2FS_IOC_GET_FEATURES:
 	case FS_IOC_FSGETXATTR:
@@ -4229,7 +4300,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		return -ENOIOCTLCMD;
 	}
-	return f2fs_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
+	return __f2fs_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
 
-- 
2.30.2



