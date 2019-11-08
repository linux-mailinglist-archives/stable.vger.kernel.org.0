Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF728F3CF5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfKHAis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfKHAis (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 19:38:48 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B538721D7B;
        Fri,  8 Nov 2019 00:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573173527;
        bh=m4YfvVr2QXuSdVQ6qvmsjWXVbjgv5w295EtLbSb1SiY=;
        h=Date:From:To:Subject:From;
        b=lnvDhPLCsxZB8YVe/kmGx4fPFCBLDaxfyD3OtP54n+4YyGHykT2sdR2h1M6ZQrXWT
         oCeT85rbe7BqCJiUIbKBz3T9dj5TeHW3lbCKfxEKMqp0MNBK4pdWjiiYQ28GpIKwX0
         PxBMyLGtUV1sJlwZVmizjqctoLtXSQT1grPXtAko=
Date:   Thu, 07 Nov 2019 16:38:46 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, sunny.s.zhang@oracle.com
Subject:  [merged]
 ocfs2-protect-extent-tree-in-the-ocfs2_prepare_inode_for_write.patch
 removed from -mm tree
Message-ID: <20191108003846.37Rvoi3Rt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()
has been removed from the -mm tree.  Its filename was
     ocfs2-protect-extent-tree-in-the-ocfs2_prepare_inode_for_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuning Zhang <sunny.s.zhang@oracle.com>
Subject: ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()

When the extent tree is modified, it should be protected by inode cluster
lock and ip_alloc_sem.

The extent tree is accessed and modified in the
ocfs2_prepare_inode_for_write, but isn't protected by ip_alloc_sem.

The following is a case.  The function ocfs2_fiemap is accessing the
extent tree, which is modified at the same time.

[47145.974472] kernel BUG at fs/ocfs2/extent_map.c:475!
[47145.974480] invalid opcode: 0000 [#1] SMP
[47145.974489] Modules linked in: tun ocfs2 ocfs2_nodemanager configfs
ocfs2_stackglue xen_netback xen_blkback xen_gntalloc xen_gntdev xen_evtchn
xenfs xen_privcmd vfat fat bnx2fc fcoe libfcoe libfc scsi_transport_fc sunrpc
bridge 8021q mrp garp stp llc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad
ib_core ib_addr dm_round_robin dm_multipath sg pcspkr raid1 shpchp
ipmi_devintf ipmi_msghandler ext4 jbd2 mbcache2 sd_mod nvme nvme_core bnxt_en
xhci_pci xhci_hcd crc32c_intel be2iscsi bnx2i cnic uio cxgb4i cxgb4 cxgb3i
libcxgbi ipv6 cxgb3 mdio qla4xxx wmi dm_mirror dm_region_hash dm_log dm_mod
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi iscsi_ibft
iscsi_boot_sysfs
[47145.974636] CPU: 16 PID: 14047 Comm: o2info Not tainted
4.1.12-124.23.1.el6uek.x86_64 #2
[47145.974646] Hardware name: Oracle Corporation ORACLE SERVER X7-2L/ASM, MB
MECH, X7-2L, BIOS 42040600 10/19/2018
[47145.974658] task: ffff88019487e200 ti: ffff88003daa4000 task.ti:
ffff88003daa4000
[47145.974667] RIP: e030:[<ffffffffa05e4840>]  [<ffffffffa05e4840>]
ocfs2_get_clusters_nocache.isra.11+0x390/0x550 [ocfs2]
[47145.974708] RSP: e02b:ffff88003daa7d88  EFLAGS: 00010287
[47145.974713] RAX: 00000000000000de RBX: ffff8801d1104030 RCX:
ffff8801d1104e10
[47145.974719] RDX: 00000000000000de RSI: 000000000009ec40 RDI:
ffff8801d1104e24
[47145.974725] RBP: ffff88003daa7df8 R08: ffff88003daa7e38 R09:
0000000000000000
[47145.974732] R10: 000000000009ec3f R11: 0000000000000246 R12:
000000000009ec3f
[47145.974739] R13: ffff88004c419000 R14: 0000000000000002 R15:
ffff88003daa7e28
[47145.974754] FS:  00007fdbccc92720(0000) GS:ffff880358800000(0000)
knlGS:ffff880358800000
[47145.974764] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[47145.974772] CR2: 00007fd5dfcd8350 CR3: 0000000208677000 CR4:
0000000000042660
[47145.974785] Stack:
[47145.974790]  ffff88003daa7df8 00002000a05e249b ffff8801d1104000
ffff88003daa7e2c
[47145.974802]  ffff88003daa7e38 ffff88000cc484c0 ffff880145f5b478
0000000000000000
[47145.974811]  0000000000002000 ffff88000cc484c0 ffff88003daa7ea0
0000000000000000
[47145.974820] Call Trace:
[47145.974837]  [<ffffffffa05e53e3>] ocfs2_fiemap+0x1e3/0x430 [ocfs2]
[47145.974848]  [<ffffffff816f644f>] ? xen_hypervisor_callback+0x7f/0x120
[47145.974855]  [<ffffffff816f6448>] ? xen_hypervisor_callback+0x78/0x120
[47145.974861]  [<ffffffff816f64a3>] ? xen_hypervisor_callback+0xd3/0x120
[47145.974872]  [<ffffffff81220905>] do_vfs_ioctl+0x155/0x510
[47145.974878]  [<ffffffff81220d41>] SyS_ioctl+0x81/0xa0
[47145.974885]  [<ffffffff816f1b9f>] ? system_call_after_swapgs+0xe9/0x190
[47145.974891]  [<ffffffff816f1b98>] ? system_call_after_swapgs+0xe2/0x190
[47145.974899]  [<ffffffff816f1b91>] ? system_call_after_swapgs+0xdb/0x190
[47145.974905]  [<ffffffff816f1c5e>] system_call_fastpath+0x18/0xd8
[47145.974910] Code: 18 48 c7 c6 60 7f 65 a0 31 c0 bb e2 ff ff ff 48 8b 4a 40
48 8b 7a 28 48 c7 c2 78 2d 66 a0 e8 38 4f 05 00 e9 28 fe ff ff 0f 1f 00 <0f>
0b 66 0f 1f 44 00 00 bb 86 ff ff ff e9 13 fe ff ff 66 0f 1f
[47145.975000] RIP  [<ffffffffa05e4840>]
ocfs2_get_clusters_nocache.isra.11+0x390/0x550 [ocfs2]
[47145.975018]  RSP <ffff88003daa7d88>
[47145.989999] ---[ end trace c8aa0c8180e869dc ]---
[47146.087579] Kernel panic - not syncing: Fatal exception
[47146.087691] Kernel Offset: disabled

This issue can be reproduced every week in a production environment.

This issue is related to the usage mode.  If others use ocfs2 in this
mode, the kernel will panic frequently.

[akpm@linux-foundation.org: coding style fixes]
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
---

 fs/ocfs2/file.c |  125 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 99 insertions(+), 26 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-protect-extent-tree-in-the-ocfs2_prepare_inode_for_write
+++ a/fs/ocfs2/file.c
@@ -2125,26 +2125,89 @@ out:
 	return ret;
 }
 
+static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,
+					    struct buffer_head **di_bh,
+					    int meta_level,
+					    int overwrite_io,
+					    int write_sem,
+					    int wait)
+{
+	int ret = 0;
+
+	if (wait)
+		ret = ocfs2_inode_lock(inode, NULL, meta_level);
+	else
+		ret = ocfs2_try_inode_lock(inode,
+			overwrite_io ? NULL : di_bh, meta_level);
+	if (ret < 0)
+		goto out;
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
+	}
+
+	return ret;
+
+out_unlock:
+	brelse(*di_bh);
+	ocfs2_inode_unlock(inode, meta_level);
+out:
+	return ret;
+}
+
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
@@ -2156,15 +2219,8 @@ static int ocfs2_prepare_inode_for_write
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
@@ -2183,7 +2239,10 @@ static int ocfs2_prepare_inode_for_write
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
@@ -2197,18 +2256,32 @@ static int ocfs2_prepare_inode_for_write
 
 		ret = ocfs2_check_range_for_refcount(inode, pos, count);
 		if (ret == 1) {
-			ocfs2_inode_unlock(inode, meta_level);
-			meta_level = -1;
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
 
-			ret = ocfs2_prepare_inode_for_refcount(inode,
-							       file,
-							       pos,
-							       count,
-							       &meta_level);
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
 
@@ -2219,10 +2292,10 @@ out_unlock:
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
_

Patches currently in -mm which might be from sunny.s.zhang@oracle.com are


