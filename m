Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9545621354
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiKHNtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiKHNtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2776314
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29CBB81AE8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5957C433D6;
        Tue,  8 Nov 2022 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915358;
        bh=Jf73n+qb3q4iwbObcPz6RNNtWFHTkDz4NXiL+/SmjQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8Ljbqt6nf5/Hw0yAEHNM6ynRfSaN0vsOgS38OemaAw4/YQvXy5vq3kAXW/Hpkskw
         YKO0CuuVMvLkAnkNZPokoJBj7UhJ42nX83rtw2DnjLU4mny/r1xaNn67aBJQUCh/Zn
         sAwyNtRLJN5GlVNgXj6snws2YqLZ7fHi8D2hny5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 38/74] xfs: use ordered buffers to initialize dquot buffers during quotacheck
Date:   Tue,  8 Nov 2022 14:39:06 +0100
Message-Id: <20221108133335.284786255@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 78bba5c812cc651cee51b64b786be926ab7fe2a9 upstream.

While QAing the new xfs_repair quotacheck code, I uncovered a quota
corruption bug resulting from a bad interaction between dquot buffer
initialization and quotacheck.  The bug can be reproduced with the
following sequence:

# mkfs.xfs -f /dev/sdf
# mount /dev/sdf /opt -o usrquota
# su nobody -s /bin/bash -c 'touch /opt/barf'
# sync
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            3      0      0  00 [------]
nobody          1      0      0  00 [------]

# xfs_io -x -c 'shutdown' /opt
# umount /opt
# mount /dev/sdf /opt -o usrquota
# touch /opt/man2
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            1      0      0  00 [------]
nobody          1      0      0  00 [------]

# umount /opt

Notice how the initial quotacheck set the root dquot icount to 3
(rootino, rbmino, rsumino), but after shutdown -> remount -> recovery,
xfs_quota reports that the root dquot has only 1 icount.  We haven't
deleted anything from the filesystem, which means that quota is now
under-counting.  This behavior is not limited to icount or the root
dquot, but this is the shortest reproducer.

I traced the cause of this discrepancy to the way that we handle ondisk
dquot updates during quotacheck vs. regular fs activity.  Normally, when
we allocate a disk block for a dquot, we log the buffer as a regular
(dquot) buffer.  Subsequent updates to the dquots backed by that block
are done via separate dquot log item updates, which means that they
depend on the logged buffer update being written to disk before the
dquot items.  Because individual dquots have their own LSN fields, that
initial dquot buffer must always be recovered.

However, the story changes for quotacheck, which can cause dquot block
allocations but persists the final dquot counter values via a delwri
list.  Because recovery doesn't gate dquot buffer replay on an LSN, this
means that the initial dquot buffer can be replayed over the (newer)
contents that were delwritten at the end of quotacheck.  In effect, this
re-initializes the dquot counters after they've been updated.  If the
log does not contain any other dquot items to recover, the obsolete
dquot contents will not be corrected by log recovery.

Because quotacheck uses a transaction to log the setting of the CHKD
flags in the superblock, we skip quotacheck during the second mount
call, which allows the incorrect icount to remain.

Fix this by changing the ondisk dquot initialization function to use
ordered buffers to write out fresh dquot blocks if it detects that we're
running quotacheck.  If the system goes down before quotacheck can
complete, the CHKD flags will not be set in the superblock and the next
mount will run quotacheck again, which can fix uninitialized dquot
buffers.  This requires amending the defer code to maintaine ordered
buffer state across defer rolls for the sake of the dquot allocation
code.

For regular operations we preserve the current behavior since the dquot
items require properly initialized ondisk dquot records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |   10 +++++++-
 fs/xfs/xfs_dquot.c        |   56 +++++++++++++++++++++++++++++++++++-----------
 2 files changed, 52 insertions(+), 14 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -234,10 +234,13 @@ xfs_defer_trans_roll(
 	struct xfs_log_item		*lip;
 	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
 	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
+	unsigned int			ordered = 0; /* bitmap */
 	int				bpcount = 0, ipcount = 0;
 	int				i;
 	int				error;
 
+	BUILD_BUG_ON(NBBY * sizeof(ordered) < XFS_DEFER_OPS_NR_BUFS);
+
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		switch (lip->li_type) {
 		case XFS_LI_BUF:
@@ -248,7 +251,10 @@ xfs_defer_trans_roll(
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
-				xfs_trans_dirty_buf(tp, bli->bli_buf);
+				if (bli->bli_flags & XFS_BLI_ORDERED)
+					ordered |= (1U << bpcount);
+				else
+					xfs_trans_dirty_buf(tp, bli->bli_buf);
 				bplist[bpcount++] = bli->bli_buf;
 			}
 			break;
@@ -289,6 +295,8 @@ xfs_defer_trans_roll(
 	/* Rejoin the buffers and dirty them so the log moves forward. */
 	for (i = 0; i < bpcount; i++) {
 		xfs_trans_bjoin(tp, bplist[i]);
+		if (ordered & (1U << i))
+			xfs_trans_ordered_buf(tp, bplist[i]);
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -205,16 +205,18 @@ xfs_qm_adjust_dqtimers(
  */
 STATIC void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	struct xfs_dqblk	*d;
+	xfs_dqid_t		curid;
+	unsigned int		qflag;
+	unsigned int		blftype;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -238,11 +240,39 @@ xfs_qm_init_dquot_blk(
 		}
 	}
 
-	xfs_trans_dquot_buf(tp, bp,
-			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
-			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
-			     XFS_BLF_GDQUOT_BUF)));
-	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
+	if (type & XFS_DQ_USER) {
+		qflag = XFS_UQUOTA_CHKD;
+		blftype = XFS_BLF_UDQUOT_BUF;
+	} else if (type & XFS_DQ_PROJ) {
+		qflag = XFS_PQUOTA_CHKD;
+		blftype = XFS_BLF_PDQUOT_BUF;
+	} else {
+		qflag = XFS_GQUOTA_CHKD;
+		blftype = XFS_BLF_GDQUOT_BUF;
+	}
+
+	xfs_trans_dquot_buf(tp, bp, blftype);
+
+	/*
+	 * quotacheck uses delayed writes to update all the dquots on disk in an
+	 * efficient manner instead of logging the individual dquot changes as
+	 * they are made. However if we log the buffer allocated here and crash
+	 * after quotacheck while the logged initialisation is still in the
+	 * active region of the log, log recovery can replay the dquot buffer
+	 * initialisation over the top of the checked dquots and corrupt quota
+	 * accounting.
+	 *
+	 * To avoid this problem, quotacheck cannot log the initialised buffer.
+	 * We must still dirty the buffer and write it back before the
+	 * allocation transaction clears the log. Therefore, mark the buffer as
+	 * ordered instead of logging it directly. This is safe for quotacheck
+	 * because it detects and repairs allocated but initialized dquot blocks
+	 * in the quota inodes.
+	 */
+	if (!(mp->m_qflags & qflag))
+		xfs_trans_ordered_buf(tp, bp);
+	else
+		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
 /*


