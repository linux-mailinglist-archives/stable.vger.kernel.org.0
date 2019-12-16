Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C068F12196E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLPRuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:50:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfLPRuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:50:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65CA3206EC;
        Mon, 16 Dec 2019 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518653;
        bh=Zh4EvORjiwjuFRIq0OtCGcFRgBY4PLXKZSO978KgCqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgIcDJRkByWY47VyUnQXlyT8+GJuHthP5EGHq4ptSxejCdEINFn88N4/A2mdQH5FV
         26Bb4IKuqG96nmWe51lN3y2yRyemvp2eMCZDwVJUVZZh7TV45uA9xc/ZTn7Ia4SmG5
         ikGHAR/HMbFl2lt9kh2hs/NX5kekSnBQWR2dszog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 012/267] exportfs_decode_fh(): negative pinned may become positive without the parent locked
Date:   Mon, 16 Dec 2019 18:45:38 +0100
Message-Id: <20191216174850.247750580@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index c22cc9d2a5c9a..a561ae17cf435 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -508,26 +508,33 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
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



