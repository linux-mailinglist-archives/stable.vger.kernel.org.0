Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1DE53631E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 15:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbiE0NCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 09:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351708AbiE0NCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 09:02:49 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10BA3D1CA;
        Fri, 27 May 2022 06:02:47 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t13so5782271wrg.9;
        Fri, 27 May 2022 06:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLC0ja767iUSkq7vhFyAS50rOOoNLE8fxflV1RxjsDw=;
        b=Ce6wcdcXt1TAE8vflH0kt2qVCXUEDquQRzoIk1QsLPSGKJrxv3/TWyDqkldiZiWz0i
         k8BmU2cHFMYpYIz7l/TmmHqM4jECDfOmJDkNpEnSV1UYyVN1PwGyjkOT1sFLztdxuf7j
         03V0sclyQft903HsVmOJyNBGyJkQM0BQ14QvteT6NOt384n6wmrEAFffIkYzFpiIBADj
         VbIWdsAnwG+4FO8kXzCPL/xz9Eb0/wvN9KzgOtWNWbRmy9qwdujT4zn5Cqcy6qEhHy3g
         4+5AgZiSQwx0RQSCSK635GjjPyUPTpUjkH66gAVXE/iAC+1EsH7aVDhVhJdROlx8mR+/
         zfsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JLC0ja767iUSkq7vhFyAS50rOOoNLE8fxflV1RxjsDw=;
        b=45gzbWS2yG3VVVCbA8F2IhVnbxtgS+6hupEzX/rhOKG5lelpuz+4vg9U8R0+S2b266
         GK4uQZgHagtj/JH6xxbPX+DnPfzlYczkBdSqb4azmww7x8QLlFIOKDrarh9nYERu18kS
         MADukhc9+zpRdTC9JBJg+NeuItvydJzpVI3Lbp4SB/xNK+Q8Qjyuo8LhYlK0YOVDmN0V
         0jF6HjUvZsQGbPYhnV7U5/p/I1GktCA0vMd2Oie0ZERZDlMb/eJUbnmgYA5bWadRhXsv
         8GBNJkc0DKyVxpTuSn8BEWVD2Q4H7XZEXObIw7Os8XpNpO4kiPo0D5S/eUWBGROB94UV
         ylXw==
X-Gm-Message-State: AOAM530Wje47LQprJmMgsdrqGHTfzPn2iaEO++/ikdRq0rCsS+5st0s7
        dTbs3ZqhPM+C4AAfcJ34DfA=
X-Google-Smtp-Source: ABdhPJyGfv0GNalT3vaY58hB+nHmb/F/PaoEmeY5GqBbuarpYL5V3V1J4FYuHWh3NQwVeXwyIPLoSA==
X-Received: by 2002:a05:6000:791:b0:20e:615c:aae4 with SMTP id bu17-20020a056000079100b0020e615caae4mr35246264wrb.206.1653656566234;
        Fri, 27 May 2022 06:02:46 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c08a400b003942a244f48sm1932569wmp.33.2022.05.27.06.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 06:02:45 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, Jan Kara <jack@suse.cz>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        wenli xie <wlxie7296@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 v2 4/5] xfs: fix an ABBA deadlock in xfs_rename
Date:   Fri, 27 May 2022 16:02:18 +0300
Message-Id: <20220527130219.3110260-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220527130219.3110260-1-amir73il@gmail.com>
References: <20220527130219.3110260-1-amir73il@gmail.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 6da1b4b1ab36d80a3994fd4811c8381de10af604 upstream.

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in order of increasing AG number per the locking rules.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
 fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e55378640b05..d03e6098ded9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
-extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
-				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 2463b5d73447..8c4f76bba88b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
 /*
  * Check whether the sf dir replace operation need more blocks.
  */
-bool
+static bool
 xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..e958b1c74561 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3152,7 +3152,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	struct xfs_buf		*agibp;
+	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3265,6 +3265,30 @@ xfs_rename(
 		}
 	}
 
+	/*
+	 * Lock the AGI buffers we need to handle bumping the nlink of the
+	 * whiteout inode off the unlinked list and to handle dropping the
+	 * nlink of the target inode.  Per locking order rules, do this in
+	 * increasing AG order and before directory block allocation tries to
+	 * grab AGFs because we grab AGIs before AGFs.
+	 *
+	 * The (vfs) caller must ensure that if src is a directory then
+	 * target_ip is either null or an empty directory.
+	 */
+	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
+		if (inodes[i] == wip ||
+		    (inodes[i] == target_ip &&
+		     (VFS_I(target_ip)->i_nlink == 1 || src_is_directory))) {
+			struct xfs_buf	*bp;
+			xfs_agnumber_t	agno;
+
+			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
+			error = xfs_read_agi(mp, tp, agno, &bp);
+			if (error)
+				goto out_trans_cancel;
+		}
+	}
+
 	/*
 	 * Directory entry creation below may acquire the AGF. Remove
 	 * the whiteout from the unlinked list first to preserve correct
@@ -3317,22 +3341,6 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
-
-		/*
-		 * Check whether the replace operation will need to allocate
-		 * blocks.  This happens when the shortform directory lacks
-		 * space and we have to convert it to a block format directory.
-		 * When more blocks are necessary, we must lock the AGI first
-		 * to preserve locking order (AGI -> AGF).
-		 */
-		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
-			error = xfs_read_agi(mp, tp,
-					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
-					&agibp);
-			if (error)
-				goto out_trans_cancel;
-		}
-
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.25.1

