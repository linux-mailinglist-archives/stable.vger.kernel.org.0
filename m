Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD459382FC1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhEQOUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239118AbhEQOSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940DE61221;
        Mon, 17 May 2021 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260622;
        bh=CIQG/ufvHpu5ZW5WhA8taivRepwav4zHcs0XSWWSKx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+ZXsLsRpG/HeZzoCZrnVPAtUD5nk8NGeAu1BluRQOFHNQoLYPF+BPb4wAFV8pU/A
         p6kvUpkr0yHODuuryZuROHY2b5ywiWY4W7Lwvucsq3TshYvdesaGGrUnI/CNkrO5zR
         9XmbTQqSVqachHsjW/4YJPiryCoY5U57R9VHLsRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 165/363] NFSv4.x: Dont return NFS4ERR_NOMATCHING_LAYOUT if were unmounting
Date:   Mon, 17 May 2021 16:00:31 +0200
Message-Id: <20210517140308.183347345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index f7786e00a6a7..ed9d580826f5 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -137,12 +137,12 @@ static struct inode *nfs_layout_find_inode_by_stateid(struct nfs_client *clp,
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
@@ -176,9 +176,10 @@ static struct inode *nfs_layout_find_inode_by_fh(struct nfs_client *clp,
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



