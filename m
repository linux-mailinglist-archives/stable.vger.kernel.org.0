Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3518013F686
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388269AbgAPTFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388261AbgAPRCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCC424685;
        Thu, 16 Jan 2020 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194125;
        bh=sGT4U/EuUFpxYX6PNmsr5Up6MeN1x5KpmDS/cSuuv8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHqHbnPx9nc+b0nSIz6C8HVYp6Py/yrL4rkPXinym7Adygd2REDVle80ceJNgmMLA
         36fgFcx1IbF2dVPJbWzCdZBvMbEga3EJjP7UQFVCF6fa0shv8g43RKwOWBkaiPIbrX
         Qj6ovrlQxBG4bFgU+iqvTGHXFD6ItYuV9x0iqJ7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 217/671] NFS/pnfs: Bulk destroy of layouts needs to be safe w.r.t. umount
Date:   Thu, 16 Jan 2020 11:52:06 -0500
Message-Id: <20200116165940.10720-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c818f9886f61..66f699e18755 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -758,22 +758,35 @@ static int
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
@@ -811,7 +824,7 @@ pnfs_layout_free_bulk_destroy_list(struct list_head *layout_list,
 		/* Free all lsegs that are attached to commit buckets */
 		nfs_commit_inode(inode, 0);
 		pnfs_put_layout_hdr(lo);
-		iput(inode);
+		nfs_iput_and_deactive(inode);
 	}
 	return ret;
 }
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index ece367ebde69..3ba44819a88a 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -104,6 +104,7 @@ enum {
 	NFS_LAYOUT_RETURN_REQUESTED,	/* Return this layout ASAP */
 	NFS_LAYOUT_INVALID_STID,	/* layout stateid id is invalid */
 	NFS_LAYOUT_FIRST_LAYOUTGET,	/* Serialize first layoutget */
+	NFS_LAYOUT_INODE_FREEING,	/* The inode is being freed */
 };
 
 enum layoutdriver_policy_flags {
-- 
2.20.1

