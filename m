Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6631B8250
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 01:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgDXXFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 19:05:47 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63151 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXXFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 19:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587769546; x=1619305546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=lbID2KMN5Ail++U85D8adVCZD6urKaX35FpklbiFOTs=;
  b=DG9A5k4mAaNKq/z6HhTQnh1tq2jWrZIEn6cg5kqjrDeSoC5SMzusICyn
   GDcY8ycH8cM6+XSyNgxPexRh1WkgsLDZ8BvwI3tgSDw+V1m60MtCipItt
   NlHpvnxMUXx9DzuF15GxEDCzQod0FEuf0VBM4+GgzLA8FVOllp7881mxW
   E=;
IronPort-SDR: avRJr7aqNX4YXXjmp6K+0LtR4cKcVWrTjGMYC2gJuiUh15w6MqDN5fGdvLSEqrDtLn/nI+V1KG
 L4FaEv83FnAg==
X-IronPort-AV: E=Sophos;i="5.73,313,1583193600"; 
   d="scan'208";a="31041450"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 24 Apr 2020 23:05:45 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 1C916A2149;
        Fri, 24 Apr 2020 23:05:44 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 23:05:44 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.162.70) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 23:05:43 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <sjitindarsingh@gmail.com>, <linux-xfs@vger.kernel.org>,
        kaixuxia <xiakaixu1987@gmail.com>,
        kaixuxia <kaixuxia@tencent.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH STABLE v4.14.y 2/2] xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT
Date:   Fri, 24 Apr 2020 16:05:32 -0700
Message-ID: <20200424230532.2852-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424230532.2852-1-surajjs@amazon.com>
References: <20200424230532.2852-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.70]
X-ClientProxiedBy: EX13D43UWC004.ant.amazon.com (10.43.162.42) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: kaixuxia <xiakaixu1987@gmail.com>

commit bc56ad8c74b8588685c2875de0df8ab6974828ef upstream.

When performing rename operation with RENAME_WHITEOUT flag, we will
hold AGF lock to allocate or free extents in manipulating the dirents
firstly, and then doing the xfs_iunlink_remove() call last to hold
AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.

The big problem here is that we have an ordering constraint on AGF
and AGI locking - inode allocation locks the AGI, then can allocate
a new extent for new inodes, locking the AGF after the AGI. Hence
the ordering that is imposed by other parts of the code is AGI before
AGF. So we get an ABBA deadlock between the AGI and AGF here.

Process A:
Call trace:
 ? __schedule+0x2bd/0x620
 schedule+0x33/0x90
 schedule_timeout+0x17d/0x290
 __down_common+0xef/0x125
 ? xfs_buf_find+0x215/0x6c0 [xfs]
 down+0x3b/0x50
 xfs_buf_lock+0x34/0xf0 [xfs]
 xfs_buf_find+0x215/0x6c0 [xfs]
 xfs_buf_get_map+0x37/0x230 [xfs]
 xfs_buf_read_map+0x29/0x190 [xfs]
 xfs_trans_read_buf_map+0x13d/0x520 [xfs]
 xfs_read_agf+0xa6/0x180 [xfs]
 ? schedule_timeout+0x17d/0x290
 xfs_alloc_read_agf+0x52/0x1f0 [xfs]
 xfs_alloc_fix_freelist+0x432/0x590 [xfs]
 ? down+0x3b/0x50
 ? xfs_buf_lock+0x34/0xf0 [xfs]
 ? xfs_buf_find+0x215/0x6c0 [xfs]
 xfs_alloc_vextent+0x301/0x6c0 [xfs]
 xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
 ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
 xfs_dialloc+0x116/0x290 [xfs]
 xfs_ialloc+0x6d/0x5e0 [xfs]
 ? xfs_log_reserve+0x165/0x280 [xfs]
 xfs_dir_ialloc+0x8c/0x240 [xfs]
 xfs_create+0x35a/0x610 [xfs]
 xfs_generic_create+0x1f1/0x2f0 [xfs]
 ...

Process B:
Call trace:
 ? __schedule+0x2bd/0x620
 ? xfs_bmapi_allocate+0x245/0x380 [xfs]
 schedule+0x33/0x90
 schedule_timeout+0x17d/0x290
 ? xfs_buf_find+0x1fd/0x6c0 [xfs]
 __down_common+0xef/0x125
 ? xfs_buf_get_map+0x37/0x230 [xfs]
 ? xfs_buf_find+0x215/0x6c0 [xfs]
 down+0x3b/0x50
 xfs_buf_lock+0x34/0xf0 [xfs]
 xfs_buf_find+0x215/0x6c0 [xfs]
 xfs_buf_get_map+0x37/0x230 [xfs]
 xfs_buf_read_map+0x29/0x190 [xfs]
 xfs_trans_read_buf_map+0x13d/0x520 [xfs]
 xfs_read_agi+0xa8/0x160 [xfs]
 xfs_iunlink_remove+0x6f/0x2a0 [xfs]
 ? current_time+0x46/0x80
 ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
 xfs_rename+0x57a/0xae0 [xfs]
 xfs_vn_rename+0xe4/0x150 [xfs]
 ...

In this patch we move the xfs_iunlink_remove() call to
before acquiring the AGF lock to preserve correct AGI/AGF locking
order.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Minor massage required to backport to apply due to removal of
out_bmap_cancel: error path label upstream as a result of code
rework. Only change was to the last code block removed by the
patch. Functionally equivalent to upstream.

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 fs/xfs/xfs_inode.c | 85 +++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cb4833d06467..7cfbe2b0f886 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3035,7 +3035,8 @@ xfs_rename(
 					&dfops, &first_block, spaceres);
 
 	/*
-	 * Set up the target.
+	 * Check for expected errors before we dirty the transaction
+	 * so we can return an error without a transaction abort.
 	 */
 	if (target_ip == NULL) {
 		/*
@@ -3047,6 +3048,46 @@ xfs_rename(
 			if (error)
 				goto out_trans_cancel;
 		}
+	} else {
+		/*
+		 * If target exists and it's a directory, check that whether
+		 * it can be destroyed.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
+		    (!xfs_dir_isempty(target_ip) ||
+		     (VFS_I(target_ip)->i_nlink > 2))) {
+			error = -EEXIST;
+			goto out_trans_cancel;
+		}
+	}
+
+	/*
+	 * Directory entry creation below may acquire the AGF. Remove
+	 * the whiteout from the unlinked list first to preserve correct
+	 * AGI/AGF locking order. This dirties the transaction so failures
+	 * after this point will abort and log recovery will clean up the
+	 * mess.
+	 *
+	 * For whiteouts, we need to bump the link count on the whiteout
+	 * inode. After this point, we have a real link, clear the tmpfile
+	 * state flag from the inode so it doesn't accidentally get misused
+	 * in future.
+	 */
+	if (wip) {
+		ASSERT(VFS_I(wip)->i_nlink == 0);
+		error = xfs_iunlink_remove(tp, wip);
+		if (error)
+			goto out_trans_cancel;
+
+		xfs_bumplink(tp, wip);
+		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
+		VFS_I(wip)->i_state &= ~I_LINKABLE;
+	}
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
 		/*
 		 * If target does not exist and the rename crosses
 		 * directories, adjust the target directory link count
@@ -3067,22 +3108,6 @@ xfs_rename(
 				goto out_bmap_cancel;
 		}
 	} else { /* target_ip != NULL */
-		/*
-		 * If target exists and it's a directory, check that both
-		 * target and source are directories and that target can be
-		 * destroyed, or that neither is a directory.
-		 */
-		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
-			/*
-			 * Make sure target dir is empty.
-			 */
-			if (!(xfs_dir_isempty(target_ip)) ||
-			    (VFS_I(target_ip)->i_nlink > 2)) {
-				error = -EEXIST;
-				goto out_trans_cancel;
-			}
-		}
-
 		/*
 		 * Link the source inode under the target name.
 		 * If the source inode is a directory and we are moving
@@ -3175,32 +3200,6 @@ xfs_rename(
 	if (error)
 		goto out_bmap_cancel;
 
-	/*
-	 * For whiteouts, we need to bump the link count on the whiteout inode.
-	 * This means that failures all the way up to this point leave the inode
-	 * on the unlinked list and so cleanup is a simple matter of dropping
-	 * the remaining reference to it. If we fail here after bumping the link
-	 * count, we're shutting down the filesystem so we'll never see the
-	 * intermediate state on disk.
-	 */
-	if (wip) {
-		ASSERT(VFS_I(wip)->i_nlink == 0);
-		error = xfs_bumplink(tp, wip);
-		if (error)
-			goto out_bmap_cancel;
-		error = xfs_iunlink_remove(tp, wip);
-		if (error)
-			goto out_bmap_cancel;
-		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
-
-		/*
-		 * Now we have a real link, clear the "I'm a tmpfile" state
-		 * flag from the inode so it doesn't accidentally get misused in
-		 * future.
-		 */
-		VFS_I(wip)->i_state &= ~I_LINKABLE;
-	}
-
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
-- 
2.17.1

