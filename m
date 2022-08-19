Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D366759A57E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349906AbiHSSPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350573AbiHSSP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:28 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0F92DC6;
        Fri, 19 Aug 2022 11:14:40 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 12so4296322pga.1;
        Fri, 19 Aug 2022 11:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zyEmZ6pSXSCb2FIby9CbhEWVxXTomK0HClRyYX/LZAo=;
        b=cSUzeR5nplM760GgjUDWnSXnwFRwPvLZKSwVljnDX0dNWn8DuxvBoygPVuyXWuel93
         rZvoXpicV0O7O8cNGRCB2IIPn60X//26ORwXwpoI44hA/SyIagbVehDrWNvx5bwSCnyS
         WaK0Pw6nWsoSpS5fTH2PnDBEdKMEvWmjUYHgyW8L9a8d9zJd/2fxX+HqqdvFZLu3hpY/
         H0mdiPVvWQE/2/MAF6SUbgQGB10WszZjpNPdJ5qIqR+JWXge4gdxI+/pHuGFrITLSiUN
         GgUxPhPATekp6ZKxtcy+DRqphMaIGfncrIpRfrxQR6PcogzXeAQUZM4QukxWvWLpHYhM
         7/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zyEmZ6pSXSCb2FIby9CbhEWVxXTomK0HClRyYX/LZAo=;
        b=gJEEwiCY1nCG9EbuV28e0okP0X7BtUgd1zTW3JkOJ2wOA+/hQTR/NyBsAz/m3kKsHe
         8IvA3OhKix+Oxh9PUCRrrB+g0qS2x45PggUFbbmtrYtUXLe+cmV/d4WAVQkGr6e7I1kB
         81SiW0atVNQimVR2oLXCWFFDo14zHvvkFJaqR4vB6mnt9BEEnK1L9Gr02Y0vyzoZtf9M
         gsSpcJFEek76KXBtG47DjPAJOMbadKrzQmhrIujLELIFS25CCZ/oq/0SZn1J/ZQyr85n
         /zpICwuIxbM4yplrbjYWsutwaxcA9ocTP4x4V61a0lQAy5+494Sds+UKH9o/ODNVY8r8
         4XjQ==
X-Gm-Message-State: ACgBeo2DC7uTEPUu71QZCX9LKu2rDz9rYFvKoR7fepYC6ozo4digMs3H
        X3zvl2atTjZnq5OYgX6jI/YwuORGNOf00Q==
X-Google-Smtp-Source: AA6agR46jbe9Ef5h6xd8p/t2t1VjRmZR/p7vyOA4Il6KRg3u1FEuJcg8NuBJAkS8ap2cfKDUCSuNSQ==
X-Received: by 2002:a63:64a:0:b0:429:8c1a:81a2 with SMTP id 71-20020a63064a000000b004298c1a81a2mr6814032pgg.503.1660932879803;
        Fri, 19 Aug 2022 11:14:39 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:39 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 2/9] xfs: reserve quota for dir expansion when linking/unlinking files
Date:   Fri, 19 Aug 2022 11:14:24 -0700
Message-Id: <20220819181431.4113819-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220819181431.4113819-1-leah.rumancik@gmail.com>
References: <20220819181431.4113819-1-leah.rumancik@gmail.com>
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

[ Upstream commit 871b9316e7a778ff97bdc34fdb2f2977f616651d ]

XFS does not reserve quota for directory expansion when linking or
unlinking children from a directory.  This means that we don't reject
the expansion with EDQUOT when we're at or near a hard limit, which
means that unprivileged userspace can use link()/unlink() to exceed
quota.

The fix for this is nuanced -- link operations don't always expand the
directory, and we allow a link to proceed with no space reservation if
we don't need to add a block to the directory to handle the addition.
Unlink operations generally do not expand the directory (you'd have to
free a block and then cause a btree split) and we can defer the
directory block freeing if there is no space reservation.

Moreover, there is a further bug in that we do not trigger the blockgc
workers to try to clear space when we're out of quota.

To fix both cases, create a new xfs_trans_alloc_dir function that
allocates the transaction, locks and joins the inodes, and reserves
quota for the directory.  If there isn't sufficient space or quota,
we'll switch the caller to reservationless mode.  This should prevent
quota usage overruns with the least restriction in functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 46 +++++++++----------------
 fs/xfs/xfs_trans.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |  3 ++
 3 files changed, 106 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c19f3ca605af..f4dec7f6c6d0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1223,7 +1223,7 @@ xfs_link(
 {
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
-	int			error;
+	int			error, nospace_error = 0;
 	int			resblks;
 
 	trace_xfs_link(tdp, target_name);
@@ -1242,19 +1242,11 @@ xfs_link(
 		goto std_return;
 
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
-	}
+	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
+			&tp, &nospace_error);
 	if (error)
 		goto std_return;
 
-	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
-
 	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -1312,6 +1304,8 @@ xfs_link(
  error_return:
 	xfs_trans_cancel(tp);
  std_return:
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
@@ -2761,6 +2755,7 @@ xfs_remove(
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t             *tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
+	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
 
@@ -2778,31 +2773,24 @@ xfs_remove(
 		goto std_return;
 
 	/*
-	 * We try to get the real space reservation first,
-	 * allowing for directory btree deletion(s) implying
-	 * possible bmap insert(s).  If we can't get the space
-	 * reservation then we use 0 instead, and avoid the bmap
-	 * btree insert(s) in the directory code by, if the bmap
-	 * insert tries to happen, instead trimming the LAST
-	 * block from the directory.
+	 * We try to get the real space reservation first, allowing for
+	 * directory btree deletion(s) implying possible bmap insert(s).  If we
+	 * can't get the space reservation then we use 0 instead, and avoid the
+	 * bmap btree insert(s) in the directory code by, if the bmap insert
+	 * tries to happen, instead trimming the LAST block from the directory.
+	 *
+	 * Ignore EDQUOT and ENOSPC being returned via nospace_error because
+	 * the directory code can handle a reservationless update and we don't
+	 * want to prevent a user from trying to free space by deleting things.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
-				&tp);
-	}
+	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
+			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto std_return;
 	}
 
-	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 67dec11e34c7..95c183072e7a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1201,3 +1201,89 @@ xfs_trans_alloc_ichange(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * Allocate an transaction, lock and join the directory and child inodes to it,
+ * and reserve quota for a directory update.  If there isn't sufficient space,
+ * @dblocks will be set to zero for a reservationless directory update and
+ * @nospace_error will be set to a negative errno describing the space
+ * constraint we hit.
+ *
+ * The caller must ensure that the on-disk dquots attached to this inode have
+ * already been allocated and initialized.  The ILOCKs will be dropped when the
+ * transaction is committed or cancelled.
+ */
+int
+xfs_trans_alloc_dir(
+	struct xfs_inode	*dp,
+	struct xfs_trans_res	*resv,
+	struct xfs_inode	*ip,
+	unsigned int		*dblocks,
+	struct xfs_trans	**tpp,
+	int			*nospace_error)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		resblks;
+	bool			retried = false;
+	int			error;
+
+retry:
+	*nospace_error = 0;
+	resblks = *dblocks;
+	error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	if (error == -ENOSPC) {
+		*nospace_error = error;
+		resblks = 0;
+		error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	}
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_qm_dqattach_locked(dp, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	if (resblks == 0)
+		goto done;
+
+	error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
+	if (error == -EDQUOT || error == -ENOSPC) {
+		if (!retried) {
+			xfs_trans_cancel(tp);
+			xfs_blockgc_free_quota(dp, 0);
+			retried = true;
+			goto retry;
+		}
+
+		*nospace_error = error;
+		resblks = 0;
+		error = 0;
+	}
+	if (error)
+		goto out_cancel;
+
+done:
+	*tpp = tp;
+	*dblocks = resblks;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 50da47f23a07..faba74d4c702 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -265,6 +265,9 @@ int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
 int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+		struct xfs_inode *ip, unsigned int *dblocks,
+		struct xfs_trans **tpp, int *nospace_error);
 
 static inline void
 xfs_trans_set_context(
-- 
2.37.1.595.g718a3a8f04-goog

