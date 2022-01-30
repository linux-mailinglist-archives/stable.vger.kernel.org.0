Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64AD4A3842
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 19:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiA3Sta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 13:49:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41780 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiA3Sta (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 13:49:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58030612B7
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 18:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29052C340E4;
        Sun, 30 Jan 2022 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643568569;
        bh=t/eEdLxLst21cw7PKiWbvt5cIM0FBgC0ijPgOHpF7t0=;
        h=Subject:To:Cc:From:Date:From;
        b=OXUtHVlh8oXpoLNfZcp/TcxfpCUcJMzNiR34EtDA6Zrfb0u8pT2KwVPYuAoGrYF/A
         gggEpc0R/qkSY9vVFiA7+BKuPFU6FzQVdTS3vr5PFloUR5+CPHyIExaOVxUoAB2Wz+
         L8uhcJnFN/5200colgFWTqPX6hiI7/HnnALAPsfo=
Subject: FAILED: patch "[PATCH] NFSv4: nfs_atomic_open() can race when looking up a" failed to apply to 4.4-stable tree
To:     trond.myklebust@hammerspace.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 19:49:26 +0100
Message-ID: <1643568566200103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1751fc1db36f6f411709e143d5393f92d12137a9 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Thu, 6 Jan 2022 18:24:03 -0500
Subject: [PATCH] NFSv4: nfs_atomic_open() can race when looking up a
 non-regular file

If the file type changes back to being a regular file on the server
between the failed OPEN and our LOOKUP, then we need to re-run the OPEN.

Fixes: 0dd2b474d0b6 ("nfs: implement i_op->atomic_open()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 408c3bb549b1..5df75ed09268 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1999,12 +1999,17 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
 		    !S_ISDIR(inode->i_mode))
 			res = ERR_PTR(-ENOTDIR);
+		else if (inode && S_ISREG(inode->i_mode))
+			res = ERR_PTR(-EOPENSTALE);
 	} else if (!IS_ERR(res)) {
 		inode = d_inode(res);
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
 		    !S_ISDIR(inode->i_mode)) {
 			dput(res);
 			res = ERR_PTR(-ENOTDIR);
+		} else if (inode && S_ISREG(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-EOPENSTALE);
 		}
 	}
 	if (switched) {

