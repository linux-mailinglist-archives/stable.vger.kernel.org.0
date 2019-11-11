Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296ECF7D8E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbfKKS6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728826AbfKKS6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:58:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69AB9222BD;
        Mon, 11 Nov 2019 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498680;
        bh=4QsMThhEA65HF9EtMyYBKhe5+sAGA/zcEml4nAIBhH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNWnVinm0Tf9NkSfvoyTV0awVB7JN9GlM94nZI3D17VPAbg5OXLNr0HvHnoGoBPUb
         IfPovvskxi2Mqzm8qy7w/eYyExNcZp6fzNH5IM7IRX4LCcRFoyh7ksBuHN/t73Fr40
         whbZU/xglpDIsTUPF+JAuIKB0suBFQd1ByxQBjv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuning Zhang <sunny.s.zhang@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>, Gang He <ghe@suse.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <jiangqi903@gmail.com>,
        Changwei Ge <gechangwei@live.cn>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 188/193] ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()
Date:   Mon, 11 Nov 2019 19:29:30 +0100
Message-Id: <20191111181514.964645895@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuning Zhang <sunny.s.zhang@oracle.com>

[ Upstream commit e74540b285569d2b1e14fe7aee92297078f235ce ]

When the extent tree is modified, it should be protected by inode
cluster lock and ip_alloc_sem.

The extent tree is accessed and modified in the
ocfs2_prepare_inode_for_write, but isn't protected by ip_alloc_sem.

The following is a case.  The function ocfs2_fiemap is accessing the
extent tree, which is modified at the same time.

  kernel BUG at fs/ocfs2/extent_map.c:475!
  invalid opcode: 0000 [#1] SMP
  Modules linked in: tun ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue [...]
  CPU: 16 PID: 14047 Comm: o2info Not tainted 4.1.12-124.23.1.el6uek.x86_64 #2
  Hardware name: Oracle Corporation ORACLE SERVER X7-2L/ASM, MB MECH, X7-2L, BIOS 42040600 10/19/2018
  task: ffff88019487e200 ti: ffff88003daa4000 task.ti: ffff88003daa4000
  RIP: ocfs2_get_clusters_nocache.isra.11+0x390/0x550 [ocfs2]
  Call Trace:
    ocfs2_fiemap+0x1e3/0x430 [ocfs2]
    do_vfs_ioctl+0x155/0x510
    SyS_ioctl+0x81/0xa0
    system_call_fastpath+0x18/0xd8
  Code: 18 48 c7 c6 60 7f 65 a0 31 c0 bb e2 ff ff ff 48 8b 4a 40 48 8b 7a 28 48 c7 c2 78 2d 66 a0 e8 38 4f 05 00 e9 28 fe ff ff 0f 1f 00 <0f> 0b 66 0f 1f 44 00 00 bb 86 ff ff ff e9 13 fe ff ff 66 0f 1f
  RIP  ocfs2_get_clusters_nocache.isra.11+0x390/0x550 [ocfs2]
  ---[ end trace c8aa0c8180e869dc ]---
  Kernel panic - not syncing: Fatal exception
  Kernel Offset: disabled

This issue can be reproduced every week in a production environment.

This issue is related to the usage mode.  If others use ocfs2 in this
mode, the kernel will panic frequently.

[akpm@linux-foundation.org: coding style fixes]
[Fix new warning due to unused function by removing said function - Linus ]
Link: http://lkml.kernel.org/r/1568772175-2906-2-git-send-email-sunny.s.zhang@oracle.com
Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 134 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 90 insertions(+), 44 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4435df3e5adb9..f6d790b7f2e2e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2092,54 +2092,90 @@ static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
 	return 0;
 }
 
-static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
-					    struct file *file,
-					    loff_t pos, size_t count,
-					    int *meta_level)
+static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,
+					    struct buffer_head **di_bh,
+					    int meta_level,
+					    int overwrite_io,
+					    int write_sem,
+					    int wait)
 {
-	int ret;
-	struct buffer_head *di_bh = NULL;
-	u32 cpos = pos >> OCFS2_SB(inode->i_sb)->s_clustersize_bits;
-	u32 clusters =
-		ocfs2_clusters_for_bytes(inode->i_sb, pos + count) - cpos;
+	int ret = 0;
 
-	ret = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (ret) {
-		mlog_errno(ret);
+	if (wait)
+		ret = ocfs2_inode_lock(inode, NULL, meta_level);
+	else
+		ret = ocfs2_try_inode_lock(inode,
+			overwrite_io ? NULL : di_bh, meta_level);
+	if (ret < 0)
 		goto out;
+
+	if (wait) {
+		if (write_sem)
+			down_write(&OCFS2_I(inode)->ip_alloc_sem);
+		else
+			down_read(&OCFS2_I(inode)->ip_alloc_sem);
+	} else {
+		if (write_sem)
+			ret = down_write_trylock(&OCFS2_I(inode)->ip_alloc_sem);
+		else
+			ret = down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem);
+
+		if (!ret) {
+			ret = -EAGAIN;
+			goto out_unlock;
+		}
 	}
 
-	*meta_level = 1;
+	return ret;
 
-	ret = ocfs2_refcount_cow(inode, di_bh, cpos, clusters, UINT_MAX);
-	if (ret)
-		mlog_errno(ret);
+out_unlock:
+	brelse(*di_bh);
+	ocfs2_inode_unlock(inode, meta_level);
 out:
-	brelse(di_bh);
 	return ret;
 }
 
+static void ocfs2_inode_unlock_for_extent_tree(struct inode *inode,
+					       struct buffer_head **di_bh,
+					       int meta_level,
+					       int write_sem)
+{
+	if (write_sem)
+		up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	else
+		up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
+	brelse(*di_bh);
+	*di_bh = NULL;
+
+	if (meta_level >= 0)
+		ocfs2_inode_unlock(inode, meta_level);
+}
+
 static int ocfs2_prepare_inode_for_write(struct file *file,
 					 loff_t pos, size_t count, int wait)
 {
 	int ret = 0, meta_level = 0, overwrite_io = 0;
+	int write_sem = 0;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = d_inode(dentry);
 	struct buffer_head *di_bh = NULL;
 	loff_t end;
+	u32 cpos;
+	u32 clusters;
 
 	/*
 	 * We start with a read level meta lock and only jump to an ex
 	 * if we need to make modifications here.
 	 */
 	for(;;) {
-		if (wait)
-			ret = ocfs2_inode_lock(inode, NULL, meta_level);
-		else
-			ret = ocfs2_try_inode_lock(inode,
-				overwrite_io ? NULL : &di_bh, meta_level);
+		ret = ocfs2_inode_lock_for_extent_tree(inode,
+						       &di_bh,
+						       meta_level,
+						       overwrite_io,
+						       write_sem,
+						       wait);
 		if (ret < 0) {
-			meta_level = -1;
 			if (ret != -EAGAIN)
 				mlog_errno(ret);
 			goto out;
@@ -2151,15 +2187,8 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 */
 		if (!wait && !overwrite_io) {
 			overwrite_io = 1;
-			if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
-				ret = -EAGAIN;
-				goto out_unlock;
-			}
 
 			ret = ocfs2_overwrite_io(inode, di_bh, pos, count);
-			brelse(di_bh);
-			di_bh = NULL;
-			up_read(&OCFS2_I(inode)->ip_alloc_sem);
 			if (ret < 0) {
 				if (ret != -EAGAIN)
 					mlog_errno(ret);
@@ -2178,7 +2207,10 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * set inode->i_size at the end of a write. */
 		if (should_remove_suid(dentry)) {
 			if (meta_level == 0) {
-				ocfs2_inode_unlock(inode, meta_level);
+				ocfs2_inode_unlock_for_extent_tree(inode,
+								   &di_bh,
+								   meta_level,
+								   write_sem);
 				meta_level = 1;
 				continue;
 			}
@@ -2194,18 +2226,32 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 
 		ret = ocfs2_check_range_for_refcount(inode, pos, count);
 		if (ret == 1) {
-			ocfs2_inode_unlock(inode, meta_level);
-			meta_level = -1;
-
-			ret = ocfs2_prepare_inode_for_refcount(inode,
-							       file,
-							       pos,
-							       count,
-							       &meta_level);
+			ocfs2_inode_unlock_for_extent_tree(inode,
+							   &di_bh,
+							   meta_level,
+							   write_sem);
+			ret = ocfs2_inode_lock_for_extent_tree(inode,
+							       &di_bh,
+							       meta_level,
+							       overwrite_io,
+							       1,
+							       wait);
+			write_sem = 1;
+			if (ret < 0) {
+				if (ret != -EAGAIN)
+					mlog_errno(ret);
+				goto out;
+			}
+
+			cpos = pos >> OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+			clusters =
+				ocfs2_clusters_for_bytes(inode->i_sb, pos + count) - cpos;
+			ret = ocfs2_refcount_cow(inode, di_bh, cpos, clusters, UINT_MAX);
 		}
 
 		if (ret < 0) {
-			mlog_errno(ret);
+			if (ret != -EAGAIN)
+				mlog_errno(ret);
 			goto out_unlock;
 		}
 
@@ -2216,10 +2262,10 @@ out_unlock:
 	trace_ocfs2_prepare_inode_for_write(OCFS2_I(inode)->ip_blkno,
 					    pos, count, wait);
 
-	brelse(di_bh);
-
-	if (meta_level >= 0)
-		ocfs2_inode_unlock(inode, meta_level);
+	ocfs2_inode_unlock_for_extent_tree(inode,
+					   &di_bh,
+					   meta_level,
+					   write_sem);
 
 out:
 	return ret;
-- 
2.20.1



