Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F86585342
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiG2QQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 12:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236756AbiG2QQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 12:16:20 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA3487C3E;
        Fri, 29 Jul 2022 09:16:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id z23so9360613eju.8;
        Fri, 29 Jul 2022 09:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=KNfXq782lrl3lQPVisBmX8hhOSGpB8zE5ysZ1GtZpTk=;
        b=TQYNILPm/4miWr3bNY60+qIafuBu9jf5rYIM98hEBX9XYLG5sLAsbIE+sKSc+Pmgdq
         Z2JVqLMADs+gs7OsYgOTegT9yimdGo3mi6FG2PjAhKQrK54Ax7Ce7k8rvA1p28hMQ3kR
         lDGFOX9lSCBUHla5aZ1hYqMtmeLA+gBj+1OgXwpWzZlUeFlE0I/Vo8NfWVuHbzyDGXty
         7mWbj8KC6/vPPXMs+nRiJvAC81n/tyZX1lEQwthYAu8XauzCcbNRT2g1UD67H8KdrV4l
         GZPAw3zUc5siSN/9WcHI2rl1WJYN9tJlZ2ukKP8M8oWNJa88j7u2/EH9ShQT7scNbYUy
         DT2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=KNfXq782lrl3lQPVisBmX8hhOSGpB8zE5ysZ1GtZpTk=;
        b=CtQzYjvCUzlmNlLnmwU4U1wLp5hvHWg9RD0GwWfKfD7IngqP9iYZhTBBPeScTvLgkI
         ZyujM+/kDQsFBRpamBOYq1kEH3uVND0ODN0gqxFCayaMF+7ttgSteJCD0cawAyEqsQqn
         vgvjFKxHU31muMF4bBPuKBRfyHWKWwp1SIAJpJJgTs42Jpx5YGjbTOTJFE9I/VJ27nO3
         ZkTs4sJHDtI/joiiqBtrbyoULvS4Gwmk6idCOjHhGE92QssX5rVpKcTlI0XUgDrLk6B5
         4zW2zk0nql7uA2NUsdrtv75KaSvfV6G3dSC5DowUfEOmeHIhaHOgWBR/oYHEJQDVf3cC
         5gjw==
X-Gm-Message-State: AJIora+bxIK1KKF2+7f2FGrWaap1FfQO+BpQeitZK0Kl6kFs34A8NzAo
        SAPMVl0AY8Xv55TGHaNg8bs=
X-Google-Smtp-Source: AGRyM1t7d6OViN3Te7qpGpJs/ue3bmS4kM+llASMM51MAnw/A0Y1ClYPzaydOEUpwU+ZjEwuElKx7w==
X-Received: by 2002:a17:907:7fa2:b0:72b:60c4:a04e with SMTP id qk34-20020a1709077fa200b0072b60c4a04emr3453596ejc.290.1659111378018;
        Fri, 29 Jul 2022 09:16:18 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (4.196.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.196.4])
        by smtp.gmail.com with ESMTPSA id fm15-20020a1709072acf00b0072b14836087sm1870116ejc.103.2022.07.29.09.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:16:17 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 v2 1/9] xfs: refactor xfs_file_fsync
Date:   Fri, 29 Jul 2022 18:16:01 +0200
Message-Id: <20220729161609.4071252-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729161609.4071252-1-amir73il@gmail.com>
References: <20220729161609.4071252-1-amir73il@gmail.com>
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

From: Christoph Hellwig <hch@lst.de>

commit f22c7f87777361f94aa17f746fbadfa499248dc8 upstream.

[backported for dependency]

Factor out the log syncing logic into two helpers to make the code easier
to read and more maintainable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 81 +++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f73837..414d856e2e75 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -118,6 +118,54 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
+static xfs_lsn_t
+xfs_fsync_lsn(
+	struct xfs_inode	*ip,
+	bool			datasync)
+{
+	if (!xfs_ipincount(ip))
+		return 0;
+	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		return 0;
+	return ip->i_itemp->ili_last_lsn;
+}
+
+/*
+ * All metadata updates are logged, which means that we just have to flush the
+ * log up to the latest LSN that touched the inode.
+ *
+ * If we have concurrent fsync/fdatasync() calls, we need them to all block on
+ * the log force before we clear the ili_fsync_fields field. This ensures that
+ * we don't get a racing sync operation that does not wait for the metadata to
+ * hit the journal before returning.  If we race with clearing ili_fsync_fields,
+ * then all that will happen is the log force will do nothing as the lsn will
+ * already be on disk.  We can't race with setting ili_fsync_fields because that
+ * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
+ * shared until after the ili_fsync_fields is cleared.
+ */
+static  int
+xfs_fsync_flush_log(
+	struct xfs_inode	*ip,
+	bool			datasync,
+	int			*log_flushed)
+{
+	int			error = 0;
+	xfs_lsn_t		lsn;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	lsn = xfs_fsync_lsn(ip, datasync);
+	if (lsn) {
+		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
+					  log_flushed);
+
+		spin_lock(&ip->i_itemp->ili_lock);
+		ip->i_itemp->ili_fsync_fields = 0;
+		spin_unlock(&ip->i_itemp->ili_lock);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
@@ -125,13 +173,10 @@ xfs_file_fsync(
 	loff_t			end,
 	int			datasync)
 {
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
 	int			log_flushed = 0;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_file_fsync(ip);
 
@@ -155,33 +200,7 @@ xfs_file_fsync(
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
-	/*
-	 * All metadata updates are logged, which means that we just have to
-	 * flush the log up to the latest LSN that touched the inode. If we have
-	 * concurrent fsync/fdatasync() calls, we need them to all block on the
-	 * log force before we clear the ili_fsync_fields field. This ensures
-	 * that we don't get a racing sync operation that does not wait for the
-	 * metadata to hit the journal before returning. If we race with
-	 * clearing the ili_fsync_fields, then all that will happen is the log
-	 * force will do nothing as the lsn will already be on disk. We can't
-	 * race with setting ili_fsync_fields because that is done under
-	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
-	 * until after the ili_fsync_fields is cleared.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip)) {
-		if (!datasync ||
-		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-			lsn = iip->ili_last_lsn;
-	}
-
-	if (lsn) {
-		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
-		spin_lock(&iip->ili_lock);
-		iip->ili_fsync_fields = 0;
-		spin_unlock(&iip->ili_lock);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
 
 	/*
 	 * If we only have a single device, and the log force about was
-- 
2.25.1

