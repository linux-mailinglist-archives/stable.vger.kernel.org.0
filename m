Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1337033B919
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhCOOFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhCOOBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB6A064F1E;
        Mon, 15 Mar 2021 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816841;
        bh=2Qvw5oxgi1UZ0Go013q4G6uaRYto2WTdKaVUvB/OSeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdcKhRKiaW3diFXf9UBAFcXpMva+m7o3pInB0n16V0LyyTisnFxgg2Kz/5dtadwVj
         ZcAsJR3rYi6NJhGJaQXYhkL451K9N+e+miJSq7kLVs8HS5TosttmLgE1kexO7lFUT1
         g/zBNp21d/Fm5R37bXpxfhwElnZLVzHmixVEzrgQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/168] NFS: Dont gratuitously clear the inode cache when lookup failed
Date:   Mon, 15 Mar 2021 14:56:19 +0100
Message-Id: <20210315135555.168479516@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 47397915ede0192235474b145ebcd81b37b03624 ]

The fact that the lookup revalidation failed, does not mean that the
inode contents have changed.

Fixes: 5ceb9d7fdaaf ("NFS: Refactor nfs_lookup_revalidate()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 59092d2780a3..e7c0790308fe 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1116,18 +1116,14 @@ nfs_lookup_revalidate_done(struct inode *dir, struct dentry *dentry,
 			__func__, dentry);
 		return 1;
 	case 0:
-		if (inode && S_ISDIR(inode->i_mode)) {
-			/* Purge readdir caches. */
-			nfs_zap_caches(inode);
-			/*
-			 * We can't d_drop the root of a disconnected tree:
-			 * its d_hash is on the s_anon list and d_drop() would hide
-			 * it from shrink_dcache_for_unmount(), leading to busy
-			 * inodes on unmount and further oopses.
-			 */
-			if (IS_ROOT(dentry))
-				return 1;
-		}
+		/*
+		 * We can't d_drop the root of a disconnected tree:
+		 * its d_hash is on the s_anon list and d_drop() would hide
+		 * it from shrink_dcache_for_unmount(), leading to busy
+		 * inodes on unmount and further oopses.
+		 */
+		if (inode && IS_ROOT(dentry))
+			return 1;
 		dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) is invalid\n",
 				__func__, dentry);
 		return 0;
-- 
2.30.1



