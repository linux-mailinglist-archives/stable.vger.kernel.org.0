Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4A753E62D
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiFFOdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239748AbiFFOdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:08 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37EF2AE2C;
        Mon,  6 Jun 2022 07:33:07 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id q15so4634172wmj.2;
        Mon, 06 Jun 2022 07:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KtH8GLMcafEYSB20tONa+zJ9ioX5tusX1ZCZq7mMdkA=;
        b=gR2A8c7WofRsDAd9EPAoi+yXmS9SsEjsLvasD7U2oy6C89qQwmJJQgsKwDAmmMCIom
         3SG6dXs0ANMl+te54nCmulT/E6wzc4cgnDp+d0ZEv8GNMtV7qhq/P+8u/WjfSUWd8rxn
         zJLT1dlNilBzLJW2hZQn/iqth63BWZJxTArm3JM+ofixVyGgGLKXtBYi4nfrW848eozh
         qDgXElzDZsnuZcgKYQD3S+Upka0f+obooNESRo3XENzp5hsMjJ1fIEpvfLACoh/i/L8C
         ALXdvKPG9MH72voghs2W0W/EJII4/BintopgP+ys1KyfXM2Hyz0KkComJH8izNBJpox/
         QDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KtH8GLMcafEYSB20tONa+zJ9ioX5tusX1ZCZq7mMdkA=;
        b=IYUq56oLsqjwnAZkAjis3GwFnErPnUgD6aS6bb3v9Cqs/DP6PZBXqIGI+D/kfYLNnc
         98Wwfa0RcLhxg2pFZCJ6IP/+uljL9qpbMzeehxBQdM9Xxzjy1/KYN4zwebnsyoVJ3lLv
         czHh708wxWRlTwnXk1S6ComlAtbZgJAP5OSlY58DCL+jb24qRowt7p1sUfJQyPkiw7z+
         0CGzumTjxJrKXOKimpp7DrSsYrDMcNaEgUHmpWffKKoBoo+TsgoIok7sor5HWwYSZ60H
         pLW8mJlx/hKMls807yIYtynEyRMQArgHQN3MJt5wFunlZ4vwmD5pSxXjOMJ6mYD48xv2
         Z2yg==
X-Gm-Message-State: AOAM530hOR3XkjR/Yvr5lL5Olvfldd2HGihXEtNF3BTkxBGy9AnlygpX
        xsDDg4XHJiElQk7Blwya8LPgmIH4Ky5QNg==
X-Google-Smtp-Source: ABdhPJzHBSJy4GpckPylEDJZvQkhwZU0vMCaqZ0ZP+Ag7+wF7p2/TC6NpZzrDE3Ism5vYmg0adgKQQ==
X-Received: by 2002:a7b:c777:0:b0:39c:4e1d:fd27 with SMTP id x23-20020a7bc777000000b0039c4e1dfd27mr6463863wmk.1.1654525985909;
        Mon, 06 Jun 2022 07:33:05 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:05 -0700 (PDT)
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
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Gao Xiang <hsiangkao@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH 5.10 v2 2/8] xfs: sync lazy sb accounting on quiesce of read-only mounts
Date:   Mon,  6 Jun 2022 17:32:49 +0300
Message-Id: <20220606143255.685988-3-amir73il@gmail.com>
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

From: Brian Foster <bfoster@redhat.com>

commit 50d25484bebe94320c49dd1347d3330c7063bbdb upstream.

xfs_log_sbcount() syncs the superblock specifically to accumulate
the in-core percpu superblock counters and commit them to disk. This
is required to maintain filesystem consistency across quiesce
(freeze, read-only mount/remount) or unmount when lazy superblock
accounting is enabled because individual transactions do not update
the superblock directly.

This mechanism works as expected for writable mounts, but
xfs_log_sbcount() skips the update for read-only mounts. Read-only
mounts otherwise still allow log recovery and write out an unmount
record during log quiesce. If a read-only mount performs log
recovery, it can modify the in-core superblock counters and write an
unmount record when the filesystem unmounts without ever syncing the
in-core counters. This leaves the filesystem with a clean log but in
an inconsistent state with regard to lazy sb counters.

Update xfs_log_sbcount() to use the same logic
xfs_log_unmount_write() uses to determine when to write an unmount
record. This ensures that lazy accounting is always synced before
the log is cleaned. Refactor this logic into a new helper to
distinguish between a writable filesystem and a writable log.
Specifically, the log is writable unless the filesystem is mounted
with the norecovery mount option, the underlying log device is
read-only, or the filesystem is shutdown. Drop the freeze state
check because the update is already allowed during the freezing
process and no context calls this function on an already frozen fs.
Also, retain the shutdown check in xfs_log_unmount_write() to catch
the case where the preceding log force might have triggered a
shutdown.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
 fs/xfs/xfs_log.h   |  1 +
 fs/xfs/xfs_mount.c |  3 +--
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa2d05e65ff1..b445e63cbc3c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -347,6 +347,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
 	tic->t_res_num++;
 }
 
+bool
+xfs_log_writable(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * Never write to the log on norecovery mounts, if the block device is
+	 * read-only, or if the filesystem is shutdown. Read-only mounts still
+	 * allow internal writes for log recovery and unmount purposes, so don't
+	 * restrict that case here.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return false;
+	if (xfs_readonly_buftarg(mp->m_log->l_targ))
+		return false;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return false;
+	return true;
+}
+
 /*
  * Replenish the byte reservation required by moving the grant write head.
  */
@@ -886,15 +905,8 @@ xfs_log_unmount_write(
 {
 	struct xlog		*log = mp->m_log;
 
-	/*
-	 * Don't write out unmount record on norecovery mounts or ro devices.
-	 * Or, if we are doing a forced umount (typically because of IO errors).
-	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_targ)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_log_writable(mp))
 		return;
-	}
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 58c3fcbec94a..98c913da7587 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -127,6 +127,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
+bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7110507a2b6b..a62b8a574409 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1176,8 +1176,7 @@ xfs_fs_writable(
 int
 xfs_log_sbcount(xfs_mount_t *mp)
 {
-	/* allow this to proceed during the freeze sequence... */
-	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
+	if (!xfs_log_writable(mp))
 		return 0;
 
 	/*
-- 
2.25.1

