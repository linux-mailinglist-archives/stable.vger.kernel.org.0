Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4980147C78
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbgAXJv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388018AbgAXJv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:51:28 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27EB2206D5;
        Fri, 24 Jan 2020 09:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859487;
        bh=WKzXeWT4Awu0s4uegOxYzvPw2p20sIzOy+n7A/irXZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H33OXLq7+JChCaSptfhY8r9dYGe4Go/eubMwGYuamLphoVLWKJfPV6ej3u787hgs9
         1p95MJTg+K0pXNIkSVc3FRF/Mo0f0VM9CYtDEOZEtrWYuA2y0IYKmGX2gra3z/RQks
         g/QacIyQjD5NaDA2aCiFo6SFQ2AqMDXrNS7zXEDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 128/343] NFS/pnfs: Bulk destroy of layouts needs to be safe w.r.t. umount
Date:   Fri, 24 Jan 2020 10:29:06 +0100
Message-Id: <20200124092936.802588959@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 5085607d209102b37b169bc94d0aa39566a9842a ]

If a bulk layout recall or a metadata server reboot coincides with a
umount, then holding a reference to an inode is unsafe unless we
also hold a reference to the super block.

Fixes: fd9a8d7160937 ("NFSv4.1: Fix bulk recall and destroy of layouts")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 33 +++++++++++++++++++++++----------
 fs/nfs/pnfs.h |  1 +
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index ec04cce31814b..83abf3dd73511 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -725,22 +725,35 @@ static int
 pnfs_layout_bulk_destroy_byserver_locked(struct nfs_client *clp,
 		struct nfs_server *server,
 		struct list_head *layout_list)
+	__must_hold(&clp->cl_lock)
+	__must_hold(RCU)
 {
 	struct pnfs_layout_hdr *lo, *next;
 	struct inode *inode;
 
 	list_for_each_entry_safe(lo, next, &server->layouts, plh_layouts) {
-		if (test_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags))
+		if (test_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags) ||
+		    test_bit(NFS_LAYOUT_INODE_FREEING, &lo->plh_flags) ||
+		    !list_empty(&lo->plh_bulk_destroy))
 			continue;
+		/* If the sb is being destroyed, just bail */
+		if (!nfs_sb_active(server->super))
+			break;
 		inode = igrab(lo->plh_inode);
-		if (inode == NULL)
-			continue;
-		list_del_init(&lo->plh_layouts);
-		if (pnfs_layout_add_bulk_destroy_list(inode, layout_list))
-			continue;
-		rcu_read_unlock();
-		spin_unlock(&clp->cl_lock);
-		iput(inode);
+		if (inode != NULL) {
+			list_del_init(&lo->plh_layouts);
+			if (pnfs_layout_add_bulk_destroy_list(inode,
+						layout_list))
+				continue;
+			rcu_read_unlock();
+			spin_unlock(&clp->cl_lock);
+			iput(inode);
+		} else {
+			rcu_read_unlock();
+			spin_unlock(&clp->cl_lock);
+			set_bit(NFS_LAYOUT_INODE_FREEING, &lo->plh_flags);
+		}
+		nfs_sb_deactive(server->super);
 		spin_lock(&clp->cl_lock);
 		rcu_read_lock();
 		return -EAGAIN;
@@ -778,7 +791,7 @@ pnfs_layout_free_bulk_destroy_list(struct list_head *layout_list,
 		/* Free all lsegs that are attached to commit buckets */
 		nfs_commit_inode(inode, 0);
 		pnfs_put_layout_hdr(lo);
-		iput(inode);
+		nfs_iput_and_deactive(inode);
 	}
 	return ret;
 }
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 87f144f14d1e0..965d657086c8b 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -99,6 +99,7 @@ enum {
 	NFS_LAYOUT_RETURN_REQUESTED,	/* Return this layout ASAP */
 	NFS_LAYOUT_INVALID_STID,	/* layout stateid id is invalid */
 	NFS_LAYOUT_FIRST_LAYOUTGET,	/* Serialize first layoutget */
+	NFS_LAYOUT_INODE_FREEING,	/* The inode is being freed */
 };
 
 enum layoutdriver_policy_flags {
-- 
2.20.1



