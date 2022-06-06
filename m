Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ECE53EBF6
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbiFFOdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbiFFOdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:10 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DAA2AC5F;
        Mon,  6 Jun 2022 07:33:08 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id z17so2934020wmi.1;
        Mon, 06 Jun 2022 07:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9bZ/oogoWoPQX2w9BuFOFgcjiIV4xqYgwERl5n3obI=;
        b=e7oTz65RaFs+soZopzJhoh12f2yOpDyBOz5hlGHewlDIBVpTgGNjO5YNtwJlMg/LTe
         S1DBp1kZo6jBdGW1GJzlZpbIs9esnjos6E6EkqK4ut5rCjCkru2L/T7BB6dFKBkFC0PK
         ynWXNaX44E3rthVSUhrJv14oHB5RCTXbDE3tTnHudRznMGi6gTLhMJjOtUw6XEgejFFn
         iO662O9ThrLeS7o3zuSl4rdFQtMthtxvli9cCbRDcZSMK/ZpMjuk+1z0ps5vwk1b9Zpu
         dYigbVlClnhzxCsZxZ4Q6zvvXwuw/VNLR1jHfy/6t6ZFOd6o96MUWw2lz/S8cYSEuBNW
         AANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9bZ/oogoWoPQX2w9BuFOFgcjiIV4xqYgwERl5n3obI=;
        b=x7Ag51+GzX5Q9s5z7bvbHmKXEIhE2kooaS6IkXA0N2DiTknZqCjMiXN1g1y83qgglC
         7tByBapA/A/7LigsFpHTl1u++9y77ZxBx03Ih+UT4FQ3xl/y++jAC76iNL830PBUd+QX
         6TZ2qQ69+AOxAA0XaJTFRM5GQYzHgGcQXPPer+voNitqZGlxczi4pCYGDrCVOuRkTHOi
         C/cQizrRByACm2SKZ0+s4ONYxVYvzPc3b77ulz1I1wSHTNxopNgFgeh+1/oct+XX5Hp7
         vw5vVMN6epE7DC7b7lVNbZ5J15bfyJGRhy/AdOSO6n8gg6Q7XOOjKvtaNKOFex5cga1b
         leVA==
X-Gm-Message-State: AOAM530IFWt+avCpKyahQtnC0XnB4Km2gkNwCBwgWZrMXHmoacwtnCAF
        mxWj4v6t4mlCDEzUEBUtw2A=
X-Google-Smtp-Source: ABdhPJzIXLPzU24TwlJbx+3T4KQsSvX/FRp2+cWiy/Bo1wFczL6AgqIJKxutRY1UGxQiL6hCW+YVRg==
X-Received: by 2002:a05:600c:1f05:b0:39c:51c6:7c85 with SMTP id bd5-20020a05600c1f0500b0039c51c67c85mr4264753wmb.33.1654525987313;
        Mon, 06 Jun 2022 07:33:07 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 3/8] xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
Date:   Mon,  6 Jun 2022 17:32:50 +0300
Message-Id: <20220606143255.685988-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606143255.685988-1-amir73il@gmail.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1aecf3734a95f3c167d1495550ca57556d33f7ec upstream.

While refactoring the quota code to create a function to allocate inode
change transactions, I noticed that xfs_qm_vop_chown_reserve does more
than just make reservations: it also *modifies* the incore counts
directly to handle the owner id change for the delalloc blocks.

I then observed that the fssetxattr code continues validating input
arguments after making the quota reservation but before dirtying the
transaction.  If the routine decides to error out, it fails to undo the
accounting switch!  This leads to incorrect quota reservation and
failure down the line.

We can fix this by making the reservation function do only that -- for
the new dquot, it reserves ondisk and delalloc blocks to the
transaction, and the old dquot hangs on to its incore reservation for
now.  Once we actually switch the dquots, we can then update the incore
reservations because we've dirtied the transaction and it's too late to
turn back now.

No fixes tag because this has been broken since the start of git.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_qm.c | 92 +++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b2a9abee8b2b..64e5da33733b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1785,6 +1785,29 @@ xfs_qm_vop_chown(
 	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
 	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
+	/*
+	 * Back when we made quota reservations for the chown, we reserved the
+	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
+	 * switched the dquots, decrease the new dquot's block reservation
+	 * (having already bumped up the real counter) so that we don't have
+	 * any reservation to give back when we commit.
+	 */
+	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
+			-ip->i_delayed_blks);
+
+	/*
+	 * Give the incore reservation for delalloc blocks back to the old
+	 * dquot.  We don't normally handle delalloc quota reservations
+	 * transactionally, so just lock the dquot and subtract from the
+	 * reservation.  Dirty the transaction because it's too late to turn
+	 * back now.
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_dqlock(prevdq);
+	ASSERT(prevdq->q_blk.reserved >= ip->i_delayed_blks);
+	prevdq->q_blk.reserved -= ip->i_delayed_blks;
+	xfs_dqunlock(prevdq);
+
 	/*
 	 * Take an extra reference, because the inode is going to keep
 	 * this dquot pointer even after the trans_commit.
@@ -1807,84 +1830,39 @@ xfs_qm_vop_chown_reserve(
 	uint			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		delblks;
 	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
-	struct xfs_dquot	*gdq_unres = NULL;
-	struct xfs_dquot	*pdq_unres = NULL;
 	struct xfs_dquot	*udq_delblks = NULL;
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
-	int			error;
-
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	delblks = ip->i_delayed_blks;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
+	    i_uid_read(VFS_I(ip)) != udqp->q_id)
 		udq_delblks = udqp;
-		/*
-		 * If there are delayed allocation blocks, then we have to
-		 * unreserve those from the old dquot, and add them to the
-		 * new dquot.
-		 */
-		if (delblks) {
-			ASSERT(ip->i_udquot);
-			udq_unres = ip->i_udquot;
-		}
-	}
+
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
+	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
 		gdq_delblks = gdqp;
-		if (delblks) {
-			ASSERT(ip->i_gdquot);
-			gdq_unres = ip->i_gdquot;
-		}
-	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != pdqp->q_id) {
+	    ip->i_d.di_projid != pdqp->q_id)
 		pdq_delblks = pdqp;
-		if (delblks) {
-			ASSERT(ip->i_pdquot);
-			pdq_unres = ip->i_pdquot;
-		}
-	}
-
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1, flags | blkflags);
-	if (error)
-		return error;
 
 	/*
-	 * Do the delayed blks reservations/unreservations now. Since, these
-	 * are done without the help of a transaction, if a reservation fails
-	 * its previous reservations won't be automatically undone by trans
-	 * code. So, we have to do it manually here.
+	 * Reserve enough quota to handle blocks on disk and reserved for a
+	 * delayed allocation.  We'll actually transfer the delalloc
+	 * reservation between dquots at chown time, even though that part is
+	 * only semi-transactional.
 	 */
-	if (delblks) {
-		/*
-		 * Do the reservations first. Unreservation can't fail.
-		 */
-		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
-		ASSERT(udq_unres || gdq_unres || pdq_unres);
-		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
-		if (error)
-			return error;
-		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, pdq_unres,
-				-((xfs_qcnt_t)delblks), 0, blkflags);
-	}
-
-	return 0;
+	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
+			gdq_delblks, pdq_delblks,
+			ip->i_d.di_nblocks + ip->i_delayed_blks,
+			1, blkflags | flags);
 }
 
 int
-- 
2.25.1

