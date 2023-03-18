Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180E96BF95E
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCRKP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCRKPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:50 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DFC32E42;
        Sat, 18 Mar 2023 03:15:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p13-20020a05600c358d00b003ed346d4522so4726761wmq.2;
        Sat, 18 Mar 2023 03:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0umKp2XY96WqbVyuc0DfJHbI4fSMf6LKhYhZe2jZwM=;
        b=Jk54qC3ZazmMXpbT/HgytgYn/sYzgt7ksawjYYt5A1EPsmfOkHbqX4BLYU/kKeVSil
         lxjtN6v7W85HoP0vi3Jj8jeJ3GtrM6ZFXSDH6lFHYqkAi+ccqvyTGqJe5cTzSd6A3oVt
         4gcJkZ0ADqfdO3NKoFnnMRWxPmsUcZE+VlZOTITpmMEY9wxy5kYJ/N91zOCHwO0wQoEj
         A6du2Nfw5tj0coYjfq74ggEVgpRsJlYJsWrI8DiJg5TIgVRhseJmfOnjmqBV7wggSEy9
         ItxBj02R6kdHN208u8r+bCIIwpnooK6l9X1S/nnlzw6Aebym1yO1OyI2xNhcdvIiTdJq
         v2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0umKp2XY96WqbVyuc0DfJHbI4fSMf6LKhYhZe2jZwM=;
        b=rpZx881rYRhBpyQ0+nt4tQO8T5lB3iXu4Y5pXEZIKYOB7uC/Gbi2PrvWrHdMjzPFMQ
         g20pqLd48VtOnkIazSS+TTqoNg1EJMQcxdQj6Tu8QeBwZ8HeLhsemnC5pOQJZK5MrGs0
         fZAVt7EETBUuqC3v49ZMjIfgcd5lcp51y4JGBrdlrhrqbMuymxZdsgIK/vSse+KLM0+e
         eNPTTTmwowkV0nFAv2tM+ORz4/B9q4LwpekO5fx1V07g45bKhwE/uD8zAFsxK4x05m6y
         QtrrgM62G3aa/IymAVdbl0AFAf82g/maabMUV0sC1i6cLm4suvTCc9oiT2H4WDTmcOLi
         splA==
X-Gm-Message-State: AO0yUKUc2mTffeQvC+yeIx6rIoGTFhWwa1mMP2T5+vb4kznYftXlrXWd
        Q4sfdMha1zMf2S8wCk65tVw=
X-Google-Smtp-Source: AK7set+ojK3WGHxMuXp8HUXrv1qkb1nxhdgb+GokuopgjPtKa1oip7V0fdhJTPcLNNcYhcqHCszOjA==
X-Received: by 2002:a05:600c:4453:b0:3eb:389d:156c with SMTP id v19-20020a05600c445300b003eb389d156cmr28586169wmn.37.1679134547213;
        Sat, 18 Mar 2023 03:15:47 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:46 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 07/15] xfs: use setattr_copy to set vfs inode attributes
Date:   Sat, 18 Mar 2023 12:15:21 +0200
Message-Id: <20230318101529.1361673-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit e014f37db1a2d109afa750042ac4d69cf3e3d88e upstream.

[remove userns argument of setattr_copy() for 5.10.y backport]

Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
revocation isn't consistent with btrfs[1] or ext4.  Those two
filesystems use the VFS function setattr_copy to convey certain
attributes from struct iattr into the VFS inode structure.

Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
decide if it should clear setgid and setuid on a file attribute update.
This is a second symptom of the problem that Filipe noticed.

XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
/not/ a simple copy function; it contains additional logic to clear the
setgid bit when setting the mode, and XFS' version no longer matches.

The VFS implements its own setuid/setgid stripping logic, which
establishes consistent behavior.  It's a tad unfortunate that it's
scattered across notify_change, should_remove_suid, and setattr_copy but
XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
functions and get rid of the old functions.

[1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/

Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iops.c | 56 +++--------------------------------------------
 fs/xfs/xfs_pnfs.c |  3 ++-
 2 files changed, 5 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6a3026e78a9b..69fef29df428 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -595,37 +595,6 @@ xfs_vn_getattr(
 	return 0;
 }
 
-static void
-xfs_setattr_mode(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-	umode_t			mode = iattr->ia_mode;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	inode->i_mode &= S_IFMT;
-	inode->i_mode |= mode & ~S_IFMT;
-}
-
-void
-xfs_setattr_time(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
-	if (iattr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = iattr->ia_ctime;
-	if (iattr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = iattr->ia_mtime;
-}
-
 static int
 xfs_vn_change_ok(
 	struct dentry	*dentry,
@@ -740,16 +709,6 @@ xfs_setattr_nonsize(
 				goto out_cancel;
 		}
 
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			inode->i_mode &= ~(S_ISUID|S_ISGID);
-
 		/*
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
@@ -761,7 +720,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
@@ -772,15 +730,10 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			inode->i_gid = gid;
 		}
 	}
 
-	if (mask & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	setattr_copy(inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
@@ -1025,11 +978,8 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	if (iattr->ia_valid & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 64ab54f2fe81..053b99929f83 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -285,7 +285,8 @@ xfs_fs_commit_blocks(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_setattr_time(ip, iattr);
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(inode, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
 		ip->i_d.di_size = iattr->ia_size;
-- 
2.34.1

