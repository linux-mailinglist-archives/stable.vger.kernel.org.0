Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2B616BF
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfGGTma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:42:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57644 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727616AbfGGTiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:12 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0006k7-9Q; Sun, 07 Jul 2019 20:38:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005ds-2v; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dominique Martinet" <dominique.martinet@cea.fr>,
        "Hou Tao" <houtao1@huawei.com>,
        "Xing Gaopeng" <xingaopeng@huawei.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.384221353@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 094/129] 9p: use inode->i_lock to protect
 i_size_write() under 32-bit
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

commit 5e3cc1ee1405a7eb3487ed24f786dec01b4cbe1f upstream.

Use inode->i_lock to protect i_size_write(), else i_size_read() in
generic_fillattr() may loop infinitely in read_seqcount_begin() when
multiple processes invoke v9fs_vfs_getattr() or v9fs_vfs_getattr_dotl()
simultaneously under 32-bit SMP environment, and a soft lockup will be
triggered as show below:

  watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [stat:2217]
  Modules linked in:
  CPU: 5 PID: 2217 Comm: stat Not tainted 5.0.0-rc1-00005-g7f702faf5a9e #4
  Hardware name: Generic DT based system
  PC is at generic_fillattr+0x104/0x108
  LR is at 0xec497f00
  pc : [<802b8898>]    lr : [<ec497f00>]    psr: 200c0013
  sp : ec497e20  ip : ed608030  fp : ec497e3c
  r10: 00000000  r9 : ec497f00  r8 : ed608030
  r7 : ec497ebc  r6 : ec497f00  r5 : ee5c1550  r4 : ee005780
  r3 : 0000052d  r2 : 00000000  r1 : ec497f00  r0 : ed608030
  Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
  Control: 10c5387d  Table: ac48006a  DAC: 00000051
  CPU: 5 PID: 2217 Comm: stat Not tainted 5.0.0-rc1-00005-g7f702faf5a9e #4
  Hardware name: Generic DT based system
  Backtrace:
  [<8010d974>] (dump_backtrace) from [<8010dc88>] (show_stack+0x20/0x24)
  [<8010dc68>] (show_stack) from [<80a1d194>] (dump_stack+0xb0/0xdc)
  [<80a1d0e4>] (dump_stack) from [<80109f34>] (show_regs+0x1c/0x20)
  [<80109f18>] (show_regs) from [<801d0a80>] (watchdog_timer_fn+0x280/0x2f8)
  [<801d0800>] (watchdog_timer_fn) from [<80198658>] (__hrtimer_run_queues+0x18c/0x380)
  [<801984cc>] (__hrtimer_run_queues) from [<80198e60>] (hrtimer_run_queues+0xb8/0xf0)
  [<80198da8>] (hrtimer_run_queues) from [<801973e8>] (run_local_timers+0x28/0x64)
  [<801973c0>] (run_local_timers) from [<80197460>] (update_process_times+0x3c/0x6c)
  [<80197424>] (update_process_times) from [<801ab2b8>] (tick_nohz_handler+0xe0/0x1bc)
  [<801ab1d8>] (tick_nohz_handler) from [<80843050>] (arch_timer_handler_virt+0x38/0x48)
  [<80843018>] (arch_timer_handler_virt) from [<80180a64>] (handle_percpu_devid_irq+0x8c/0x240)
  [<801809d8>] (handle_percpu_devid_irq) from [<8017ac20>] (generic_handle_irq+0x34/0x44)
  [<8017abec>] (generic_handle_irq) from [<8017b344>] (__handle_domain_irq+0x6c/0xc4)
  [<8017b2d8>] (__handle_domain_irq) from [<801022e0>] (gic_handle_irq+0x4c/0x88)
  [<80102294>] (gic_handle_irq) from [<80101a30>] (__irq_svc+0x70/0x98)
  [<802b8794>] (generic_fillattr) from [<8056b284>] (v9fs_vfs_getattr_dotl+0x74/0xa4)
  [<8056b210>] (v9fs_vfs_getattr_dotl) from [<802b8904>] (vfs_getattr_nosec+0x68/0x7c)
  [<802b889c>] (vfs_getattr_nosec) from [<802b895c>] (vfs_getattr+0x44/0x48)
  [<802b8918>] (vfs_getattr) from [<802b8a74>] (vfs_statx+0x9c/0xec)
  [<802b89d8>] (vfs_statx) from [<802b9428>] (sys_lstat64+0x48/0x78)
  [<802b93e0>] (sys_lstat64) from [<80101000>] (ret_fast_syscall+0x0/0x28)

[dominique.martinet@cea.fr: updated comment to not refer to a function
in another subsystem]
Link: http://lkml.kernel.org/r/20190124063514.8571-2-houtao1@huawei.com
Fixes: 7549ae3e81cc ("9p: Use the i_size_[read, write]() macros instead of using inode->i_size directly.")
Reported-by: Xing Gaopeng <xingaopeng@huawei.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/9p/v9fs_vfs.h       | 23 +++++++++++++++++++++--
 fs/9p/vfs_file.c       |  6 +++++-
 fs/9p/vfs_inode.c      | 23 +++++++++++------------
 fs/9p/vfs_inode_dotl.c | 27 ++++++++++++++-------------
 fs/9p/vfs_super.c      |  4 ++--
 5 files changed, 53 insertions(+), 30 deletions(-)

--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -40,6 +40,9 @@
  */
 #define P9_LOCK_TIMEOUT (30*HZ)
 
+/* flags for v9fs_stat2inode() & v9fs_stat2inode_dotl() */
+#define V9FS_STAT2INODE_KEEP_ISIZE 1
+
 extern struct file_system_type v9fs_fs_type;
 extern const struct address_space_operations v9fs_addr_operations;
 extern const struct file_operations v9fs_file_operations;
@@ -61,8 +64,10 @@ int v9fs_init_inode(struct v9fs_session_
 		    struct inode *inode, umode_t mode, dev_t);
 void v9fs_evict_inode(struct inode *inode);
 ino_t v9fs_qid2ino(struct p9_qid *qid);
-void v9fs_stat2inode(struct p9_wstat *, struct inode *, struct super_block *);
-void v9fs_stat2inode_dotl(struct p9_stat_dotl *, struct inode *);
+void v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
+		      struct super_block *sb, unsigned int flags);
+void v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
+			   unsigned int flags);
 int v9fs_dir_release(struct inode *inode, struct file *filp);
 int v9fs_file_open(struct inode *inode, struct file *file);
 void v9fs_inode2stat(struct inode *inode, struct p9_wstat *stat);
@@ -87,4 +92,18 @@ static inline void v9fs_invalidate_inode
 }
 
 int v9fs_open_to_dotl_flags(int flags);
+
+static inline void v9fs_i_size_write(struct inode *inode, loff_t i_size)
+{
+	/*
+	 * 32-bit need the lock, concurrent updates could break the
+	 * sequences and make i_size_read() loop forever.
+	 * 64-bit updates are atomic and can skip the locking.
+	 */
+	if (sizeof(i_size) > sizeof(long))
+		spin_lock(&inode->i_lock);
+	i_size_write(inode, i_size);
+	if (sizeof(i_size) > sizeof(long))
+		spin_unlock(&inode->i_lock);
+}
 #endif
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -484,7 +484,11 @@ v9fs_file_write_internal(struct inode *i
 		i_size = i_size_read(inode);
 		if (*offset > i_size) {
 			inode_add_bytes(inode, *offset - i_size);
-			i_size_write(inode, *offset);
+			/*
+			 * Need to serialize against i_size_write() in
+			 * v9fs_stat2inode()
+			 */
+			v9fs_i_size_write(inode, *offset);
 		}
 	}
 	if (n < 0)
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -538,7 +538,7 @@ static struct inode *v9fs_qid_iget(struc
 	if (retval)
 		goto error;
 
-	v9fs_stat2inode(st, inode, sb);
+	v9fs_stat2inode(st, inode, sb, 0);
 	v9fs_cache_inode_get_cookie(inode);
 	unlock_new_inode(inode);
 	return inode;
@@ -1074,7 +1074,7 @@ v9fs_vfs_getattr(struct vfsmount *mnt, s
 	if (IS_ERR(st))
 		return PTR_ERR(st);
 
-	v9fs_stat2inode(st, dentry->d_inode, dentry->d_inode->i_sb);
+	v9fs_stat2inode(st, dentry->d_inode, dentry->d_inode->i_sb, 0);
 	generic_fillattr(dentry->d_inode, stat);
 
 	p9stat_free(st);
@@ -1152,12 +1152,13 @@ static int v9fs_vfs_setattr(struct dentr
  * @stat: Plan 9 metadata (mistat) structure
  * @inode: inode to populate
  * @sb: superblock of filesystem
+ * @flags: control flags (e.g. V9FS_STAT2INODE_KEEP_ISIZE)
  *
  */
 
 void
 v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
-	struct super_block *sb)
+		 struct super_block *sb, unsigned int flags)
 {
 	umode_t mode;
 	char ext[32];
@@ -1198,10 +1199,11 @@ v9fs_stat2inode(struct p9_wstat *stat, s
 	mode = p9mode2perm(v9ses, stat);
 	mode |= inode->i_mode & ~S_IALLUGO;
 	inode->i_mode = mode;
-	i_size_write(inode, stat->length);
 
+	if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE))
+		v9fs_i_size_write(inode, stat->length);
 	/* not real number of blocks, but 512 byte ones ... */
-	inode->i_blocks = (i_size_read(inode) + 512 - 1) >> 9;
+	inode->i_blocks = (stat->length + 512 - 1) >> 9;
 	v9inode->cache_validity &= ~V9FS_INO_INVALID_ATTR;
 }
 
@@ -1465,9 +1467,9 @@ int v9fs_refresh_inode(struct p9_fid *fi
 {
 	int umode;
 	dev_t rdev;
-	loff_t i_size;
 	struct p9_wstat *st;
 	struct v9fs_session_info *v9ses;
+	unsigned int flags;
 
 	v9ses = v9fs_inode2v9ses(inode);
 	st = p9_client_stat(fid);
@@ -1480,16 +1482,13 @@ int v9fs_refresh_inode(struct p9_fid *fi
 	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
 		goto out;
 
-	spin_lock(&inode->i_lock);
 	/*
 	 * We don't want to refresh inode->i_size,
 	 * because we may have cached data
 	 */
-	i_size = inode->i_size;
-	v9fs_stat2inode(st, inode, inode->i_sb);
-	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
-		inode->i_size = i_size;
-	spin_unlock(&inode->i_lock);
+	flags = (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) ?
+		V9FS_STAT2INODE_KEEP_ISIZE : 0;
+	v9fs_stat2inode(st, inode, inode->i_sb, flags);
 out:
 	p9stat_free(st);
 	kfree(st);
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -143,7 +143,7 @@ static struct inode *v9fs_qid_iget_dotl(
 	if (retval)
 		goto error;
 
-	v9fs_stat2inode_dotl(st, inode);
+	v9fs_stat2inode_dotl(st, inode, 0);
 	v9fs_cache_inode_get_cookie(inode);
 	retval = v9fs_get_acl(inode, fid);
 	if (retval)
@@ -498,7 +498,7 @@ v9fs_vfs_getattr_dotl(struct vfsmount *m
 	if (IS_ERR(st))
 		return PTR_ERR(st);
 
-	v9fs_stat2inode_dotl(st, dentry->d_inode);
+	v9fs_stat2inode_dotl(st, dentry->d_inode, 0);
 	generic_fillattr(dentry->d_inode, stat);
 	/* Change block size to what the server returned */
 	stat->blksize = st->st_blksize;
@@ -609,11 +609,13 @@ int v9fs_vfs_setattr_dotl(struct dentry
  * v9fs_stat2inode_dotl - populate an inode structure with stat info
  * @stat: stat structure
  * @inode: inode to populate
+ * @flags: ctrl flags (e.g. V9FS_STAT2INODE_KEEP_ISIZE)
  *
  */
 
 void
-v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
+v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
+		      unsigned int flags)
 {
 	umode_t mode;
 	struct v9fs_inode *v9inode = V9FS_I(inode);
@@ -633,7 +635,8 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl
 		mode |= inode->i_mode & ~S_IALLUGO;
 		inode->i_mode = mode;
 
-		i_size_write(inode, stat->st_size);
+		if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE))
+			v9fs_i_size_write(inode, stat->st_size);
 		inode->i_blocks = stat->st_blocks;
 	} else {
 		if (stat->st_result_mask & P9_STATS_ATIME) {
@@ -663,8 +666,9 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl
 		}
 		if (stat->st_result_mask & P9_STATS_RDEV)
 			inode->i_rdev = new_decode_dev(stat->st_rdev);
-		if (stat->st_result_mask & P9_STATS_SIZE)
-			i_size_write(inode, stat->st_size);
+		if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE) &&
+		    stat->st_result_mask & P9_STATS_SIZE)
+			v9fs_i_size_write(inode, stat->st_size);
 		if (stat->st_result_mask & P9_STATS_BLOCKS)
 			inode->i_blocks = stat->st_blocks;
 	}
@@ -946,9 +950,9 @@ ndset:
 
 int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
 {
-	loff_t i_size;
 	struct p9_stat_dotl *st;
 	struct v9fs_session_info *v9ses;
+	unsigned int flags;
 
 	v9ses = v9fs_inode2v9ses(inode);
 	st = p9_client_getattr_dotl(fid, P9_STATS_ALL);
@@ -960,16 +964,13 @@ int v9fs_refresh_inode_dotl(struct p9_fi
 	if ((inode->i_mode & S_IFMT) != (st->st_mode & S_IFMT))
 		goto out;
 
-	spin_lock(&inode->i_lock);
 	/*
 	 * We don't want to refresh inode->i_size,
 	 * because we may have cached data
 	 */
-	i_size = inode->i_size;
-	v9fs_stat2inode_dotl(st, inode);
-	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
-		inode->i_size = i_size;
-	spin_unlock(&inode->i_lock);
+	flags = (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) ?
+		V9FS_STAT2INODE_KEEP_ISIZE : 0;
+	v9fs_stat2inode_dotl(st, inode, flags);
 out:
 	kfree(st);
 	return 0;
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -169,7 +169,7 @@ static struct dentry *v9fs_mount(struct
 			goto release_sb;
 		}
 		root->d_inode->i_ino = v9fs_qid2ino(&st->qid);
-		v9fs_stat2inode_dotl(st, root->d_inode);
+		v9fs_stat2inode_dotl(st, root->d_inode, 0);
 		kfree(st);
 	} else {
 		struct p9_wstat *st = NULL;
@@ -180,7 +180,7 @@ static struct dentry *v9fs_mount(struct
 		}
 
 		root->d_inode->i_ino = v9fs_qid2ino(&st->qid);
-		v9fs_stat2inode(st, root->d_inode, sb);
+		v9fs_stat2inode(st, root->d_inode, sb, 0);
 
 		p9stat_free(st);
 		kfree(st);

