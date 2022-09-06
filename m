Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435745AF3BB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIFSge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiIFSgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:36:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0E19AFE4
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:36:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f3-20020a056902038300b00696588a0e87so9112151ybs.3
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 11:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=tg8eRVP8zBLy5T3GrQ7FiT/ZQysxW7XYE3PgBG3r7xA=;
        b=S3eZGAdLMcRRyRY6vszLIP46WXXfNPaFsof6i/+H/9GzjHxhbEo/ukVAclyOQblN+j
         YtC9+9a9bf+fQBYWTX2gtTRsGmMO1RU0UpyyaTw8bFvLbUjeDGJox/tUHnaOTJEKG87k
         ko89Igxd7SucaTD1zRmPXSO/8FLT9aC6uUZf9i20oB0fQdh/C5KIi7Kk4O+ajyZoiIgk
         yZdpOlRttxfvW0p6D76rsn1ghk2P8VgSflKUjamOXZ0pDZaT5mntm0KP0oPRArqMY70V
         fW74DDoADRoOEe+akXtGOqkkmO+qUy7v7CI1HWbmbT8vvsTKxTxVC+TRynMhzmIj1NEH
         kCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=tg8eRVP8zBLy5T3GrQ7FiT/ZQysxW7XYE3PgBG3r7xA=;
        b=f64QkzA05i2IV30okyp/JC8GviNBGnQuqqNtSlRggCttsZ90+tmXbDTz2ucG70nJj+
         T8nPy20qMkFURRAvmHFnbFcQlRS4M0gSDU3dToDNtiZ5K+nKDtjtNELjJhDLHxunJs+k
         xVuCY60ltw3h4m/I2fCvHB6AnFt2ZMaMJzooCe5nJvQzfZH5U5PvuG1BRvZ7VJKG1KKV
         3RxSKKtXWF6DgRFY9PWgwUKaxjpone2TCnMe2kNvSLDK0YXUe6N4eO5rhfIWdwnaMfXr
         0monqItLkwgRpZBfvUbiV1JZNOgpxb3uhoXPa8EVQDwm+7ftAm0xPgmHY4LMPgSpiwol
         J4zQ==
X-Gm-Message-State: ACgBeo2ip/bZX2CuLLrhBZxlHm3PbB4SVp3KsMCgkrlqDG0L+R+9D21J
        l2cQsbw8h8RtO7qQcQexfo24Obpt/e0o1gGzjQ==
X-Google-Smtp-Source: AA6agR6Vwr8MTE4dfhtiRJCF7nEbIHmBe90cMOH5rLhEb7utSv2g93fnXwMtOaf2cBTNvcUPMwCRqRrVvJJTAdM4+Q==
X-Received: from varshat.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:a35])
 (user=teratipally job=sendgmr) by 2002:a0d:cb91:0:b0:345:454a:77d2 with SMTP
 id n139-20020a0dcb91000000b00345454a77d2mr8387739ywd.402.1662489371543; Tue,
 06 Sep 2022 11:36:11 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:36:00 +0000
In-Reply-To: <20220906183600.1926315-1-teratipally@google.com>
Mime-Version: 1.0
References: <20220906183600.1926315-1-teratipally@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906183600.1926315-2-teratipally@google.com>
Subject: [PATCH] xfs: fix up non-directory creation in SGID directories
From:   Varsha Teratipally <teratipally@google.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

XFS always inherits the SGID bit if it is set on the parent inode, while
the generic inode_init_owner does not do this in a few cases where it can
create a possible security problem, see commit 0fa3ecd87848
("Fix up non-directory creation in SGID directories") for details.

Switch XFS to use the generic helper for the normal path to fix this,
just keeping the simple field inheritance open coded for the case of the
non-sgid case with the bsdgrpid mount option.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ebd9c64aa48..e2a1db4cee43 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -775,6 +775,7 @@ xfs_init_new_inode(
 	prid_t			prid,
 	struct xfs_inode	**ipp)
 {
+	struct inode		*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
@@ -804,18 +805,17 @@ xfs_init_new_inode(
 
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	inode->i_uid = current_fsuid();
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
-	if (pip && XFS_INHERIT_GID(pip)) {
-		inode->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    (mp->m_flags & XFS_MOUNT_GRPID)) {
+		inode->i_uid = current_fsuid();
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = mode;
 	} else {
-		inode->i_gid = current_fsgid();
+		inode_init_owner(inode, dir, mode);
 	}
 
 	/*
-- 
2.37.2.789.g6183377224-goog

