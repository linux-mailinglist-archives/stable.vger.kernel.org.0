Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225249E184
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfH0H6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbfH0H6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADF652173E;
        Tue, 27 Aug 2019 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892729;
        bh=UCmvr/boJAZd9iWw6T45AHsw+TVfmCjLhuD6urnPtbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlWwF9ofPmtEeHOOpssuwGe7uKv3qhqMg29/qnfSfT6eZXpFMc+tWug/2YYhh5m7F
         uy2lJB6BFQks0mbSrkAsKB9ndRDAERc2yxgx2exDZQQ3DzOvffVd1Xb+htWvxALUYA
         Z1KK8VElvbTd3k6VIMniXENXyUbJSHza7xof3rXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 91/98] xfs: Add helper function xfs_attr_try_sf_addname
Date:   Tue, 27 Aug 2019 09:51:10 +0200
Message-Id: <20190827072722.947494361@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4c74a56b9de76bb6b581274b76b52535ad77c2a7 upstream.

This patch adds a subroutine xfs_attr_try_sf_addname
used by xfs_attr_set.  This subrotine will attempt to
add the attribute name specified in args in shortform,
as well and perform error handling previously done in
xfs_attr_set.

This patch helps to pre-simplify xfs_attr_set for reviewing
purposes and reduce indentation.  New function will be added
in the next patch.

[dgc: moved commit to helper function, too.]

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 53 +++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c6299f82a6e49..c15a1debec907 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -191,6 +191,33 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+STATIC int
+xfs_attr_try_sf_addname(
+	struct xfs_inode	*dp,
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_mount	*mp = dp->i_mount;
+	int			error, error2;
+
+	error = xfs_attr_shortform_addname(args);
+	if (error == -ENOSPC)
+		return error;
+
+	/*
+	 * Commit the shortform mods, and we're done.
+	 * NOTE: this is also the error path (EEXIST, etc).
+	 */
+	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(args->trans);
+
+	error2 = xfs_trans_commit(args->trans);
+	return error ? error : error2;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -204,7 +231,7 @@ xfs_attr_set(
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
-	int			error, err2, local;
+	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -281,30 +308,10 @@ xfs_attr_set(
 		 * Try to add the attr to the attribute list in
 		 * the inode.
 		 */
-		error = xfs_attr_shortform_addname(&args);
+		error = xfs_attr_try_sf_addname(dp, &args);
 		if (error != -ENOSPC) {
-			/*
-			 * Commit the shortform mods, and we're done.
-			 * NOTE: this is also the error path (EEXIST, etc).
-			 */
-			ASSERT(args.trans != NULL);
-
-			/*
-			 * If this is a synchronous mount, make sure that
-			 * the transaction goes to disk before returning
-			 * to the user.
-			 */
-			if (mp->m_flags & XFS_MOUNT_WSYNC)
-				xfs_trans_set_sync(args.trans);
-
-			if (!error && (flags & ATTR_KERNOTIME) == 0) {
-				xfs_trans_ichgtime(args.trans, dp,
-							XFS_ICHGTIME_CHG);
-			}
-			err2 = xfs_trans_commit(args.trans);
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-			return error ? error : err2;
+			return error;
 		}
 
 		/*
-- 
2.20.1



