Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EFA383615
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244290AbhEQP2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243448AbhEQP0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52CC961929;
        Mon, 17 May 2021 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262177;
        bh=5IlApkA+vKU9uwIT7nJOHhW1gvuH1JjuqpvzepCNKJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8Vjt5nXcTnp1A7rAisavvEaKgcMgrHDTZpxgQSXDMqG2a0Ns14trKmdXtM2hTVhP
         xqHjYH+oj8jAeYyRXI84b7bpTw33Oa9s3sB0hwrWcbzdZw0Uj14p2enCvSd/PWCYHm
         1m4fgPNN69g61+TiYd3ijtAT8WtdqfFUcmgGGRVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/289] NFSv4.x: Dont return NFS4ERR_NOMATCHING_LAYOUT if were unmounting
Date:   Mon, 17 May 2021 16:00:52 +0200
Message-Id: <20210517140309.437019436@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8926cc8302819be9e67f70409ed001ecb2c924a9 ]

If the NFS super block is being unmounted, then we currently may end up
telling the server that we've forgotten the layout while it is actually
still in use by the client.
In that case, just assume that the client will soon return the layout
anyway, and so return NFS4ERR_DELAY in response to the layout recall.

Fixes: 58ac3e59235f ("NFSv4/pnfs: Clean up nfs_layout_find_inode()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index e61dbc9b86ae..be546ece383f 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -132,12 +132,12 @@ static struct inode *nfs_layout_find_inode_by_stateid(struct nfs_client *clp,
 		list_for_each_entry_rcu(lo, &server->layouts, plh_layouts) {
 			if (!pnfs_layout_is_valid(lo))
 				continue;
-			if (stateid != NULL &&
-			    !nfs4_stateid_match_other(stateid, &lo->plh_stateid))
+			if (!nfs4_stateid_match_other(stateid, &lo->plh_stateid))
 				continue;
-			if (!nfs_sb_active(server->super))
-				continue;
-			inode = igrab(lo->plh_inode);
+			if (nfs_sb_active(server->super))
+				inode = igrab(lo->plh_inode);
+			else
+				inode = ERR_PTR(-EAGAIN);
 			rcu_read_unlock();
 			if (inode)
 				return inode;
@@ -171,9 +171,10 @@ static struct inode *nfs_layout_find_inode_by_fh(struct nfs_client *clp,
 				continue;
 			if (nfsi->layout != lo)
 				continue;
-			if (!nfs_sb_active(server->super))
-				continue;
-			inode = igrab(lo->plh_inode);
+			if (nfs_sb_active(server->super))
+				inode = igrab(lo->plh_inode);
+			else
+				inode = ERR_PTR(-EAGAIN);
 			rcu_read_unlock();
 			if (inode)
 				return inode;
-- 
2.30.2



