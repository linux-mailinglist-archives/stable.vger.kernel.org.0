Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC411B7E0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbfLKQKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730328AbfLKPLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C4022173E;
        Wed, 11 Dec 2019 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077111;
        bh=3AC9YLPT4sFT5BYDbu5+f0dgyOFyXPBT2s0ZPrDyeuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4QWtC+/O2UJyMgHS2JdAIQZV6tOLXT9dyuoJJ8OTvKhqHJlWmGA2IkcRAwy8pue7
         neejc7q5sEQcKyTb0b2qOYuxVG6aqO4XGzB1ReZG8Kzg6ckwowp9OVHVX3cI5Ir8pU
         d0K2nwaDevbZ3OCDwgA9+psKY40xN32TwgRIioMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 021/105] exportfs_decode_fh(): negative pinned may become positive without the parent locked
Date:   Wed, 11 Dec 2019 16:05:10 +0100
Message-Id: <20191211150226.989775102@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit a2ece088882666e1dc7113744ac912eb161e3f87 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exportfs/expfs.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index f0e549783caf9..ba6de72a3e34a 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -519,26 +519,33 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 		 * inode is actually connected to the parent.
 		 */
 		err = exportfs_get_name(mnt, target_dir, nbuf, result);
-		if (!err) {
-			inode_lock(target_dir->d_inode);
-			nresult = lookup_one_len(nbuf, target_dir,
-						 strlen(nbuf));
-			inode_unlock(target_dir->d_inode);
-			if (!IS_ERR(nresult)) {
-				if (nresult->d_inode) {
-					dput(result);
-					result = nresult;
-				} else
-					dput(nresult);
-			}
+		if (err) {
+			dput(target_dir);
+			goto err_result;
 		}
 
+		inode_lock(target_dir->d_inode);
+		nresult = lookup_one_len(nbuf, target_dir, strlen(nbuf));
+		if (!IS_ERR(nresult)) {
+			if (unlikely(nresult->d_inode != result->d_inode)) {
+				dput(nresult);
+				nresult = ERR_PTR(-ESTALE);
+			}
+		}
+		inode_unlock(target_dir->d_inode);
 		/*
 		 * At this point we are done with the parent, but it's pinned
 		 * by the child dentry anyway.
 		 */
 		dput(target_dir);
 
+		if (IS_ERR(nresult)) {
+			err = PTR_ERR(nresult);
+			goto err_result;
+		}
+		dput(result);
+		result = nresult;
+
 		/*
 		 * And finally make sure the dentry is actually acceptable
 		 * to NFSD.
-- 
2.20.1



