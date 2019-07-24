Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECD672858
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 08:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfGXGfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 02:35:03 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35708 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 02:35:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so20416618pfn.2;
        Tue, 23 Jul 2019 23:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xoa5a82eIxITyfBu9c17I6H6oKzbLXvPgdiCD02JaB4=;
        b=LAXSqazSR9GyyaAT5HzF9+mQ2fOwCUZzK6f/wuRU1ZrOS6qBiv2fpr2XtSbiwppkqe
         USInhYx+N97bP4CVQXDB0z0b+T3daRzDyUNj/lCWcW/bk0bBs8nxIzLKsT8NhMwYj300
         Me1KmT13jvQ/LxkiJGcwY595bjlOG3o6EeF/eHut6X1TRyte0+KmxM2WFo6aLrTmr3aa
         wM9k2ca6L5x9rybfNjQ6qR1zhhnn0je7UDnmxb9fS1MQKE8O7MCkFv6uzL94i61Qpf5f
         FsBXXDNN6u66RuF/kOS53OYbPUHuY+ZevrxliAx62WEbvnBJBFh2drYXAFMxtw3kJBDb
         YLZg==
X-Gm-Message-State: APjAAAXKgubTPm/aCkD+40aBc0HFaRwmtagshb6GUXelmXf1N5mgcUKC
        6DuwfEbvZNS/g3nk+KTRqJ8=
X-Google-Smtp-Source: APXvYqwq92WAWjSrxGIVK4FzfSH7yfoj2nGjP58pThY3ncUqpCvMmBRLdTX0IavsyHQsIpkT81O8vQ==
X-Received: by 2002:a62:ae02:: with SMTP id q2mr9444053pff.1.1563950102100;
        Tue, 23 Jul 2019 23:35:02 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id i124sm81500638pfe.61.2019.07.23.23.34.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:34:59 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 8CC234047C; Wed, 24 Jul 2019 06:34:58 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 3/6] xfs: Add helper function xfs_attr_try_sf_addname
Date:   Wed, 24 Jul 2019 06:34:48 +0000
Message-Id: <20190724063451.26190-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724063451.26190-1-mcgrof@kernel.org>
References: <20190724063451.26190-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

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
---
 fs/xfs/libxfs/xfs_attr.c | 53 +++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c6299f82a6e4..c15a1debec90 100644
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
2.18.0

