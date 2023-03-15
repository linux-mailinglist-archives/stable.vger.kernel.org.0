Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D117A6BB1B6
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjCOMaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjCOM3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:29:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8379CFC1
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF44F61D72
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D248FC433EF;
        Wed, 15 Mar 2023 12:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883316;
        bh=vrGgUOnpAqLLz5kca6TgBOPcfH+fu/CQKFcxxJ7unWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13H4QuJFgvbwNUm70kqnfksGeUX3WKtIgmYtPm3uAiBJnAif4S1HhBAdQMblX/D8+
         x2YOP+1NMpSeFKRvTw+el7K70K/Tnz6yVxjOJqxup+NUcD1fqIzDDGCNyuBq022Z8n
         ONGM05febsu/3Wwh6F3RGu6/pjNPT1wfEa9nGU/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/145] xfs: set prealloc flag in xfs_alloc_file_space()
Date:   Wed, 15 Mar 2023 13:12:43 +0100
Message-Id: <20230315115742.180463331@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 0b02c8c0d75a738c98c35f02efb36217c170d78c upsream.

Now that we only call xfs_update_prealloc_flags() from
xfs_file_fallocate() in the case where we need to set the
preallocation flag, do this in xfs_alloc_file_space() where we
already have the inode joined into a transaction and get
rid of the call to xfs_update_prealloc_flags() from the fallocate
code.

This also means that we now correctly avoid setting the
XFS_DIFLAG_PREALLOC flag when xfs_is_always_cow_inode() is true, as
these inodes will never have preallocated extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 9 +++------
 fs/xfs/xfs_file.c      | 8 --------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73a36b7be3bd1..fd2ad6a3019ca 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -851,9 +851,6 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
 				dblocks, rblocks, false, &tp);
 		if (error)
@@ -870,9 +867,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 020e0a412287a..8cd0c3df253f9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -909,7 +909,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -1007,8 +1006,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1059,11 +1056,6 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-
-		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
-		if (error)
-			goto out_unlock;
-
 	}
 
 	/* Change file size if needed */
-- 
2.39.2



