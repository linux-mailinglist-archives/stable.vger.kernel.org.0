Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F0038342E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbhEQPGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241151AbhEQPEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:04:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B432961A1D;
        Mon, 17 May 2021 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261693;
        bh=CIQG/ufvHpu5ZW5WhA8taivRepwav4zHcs0XSWWSKx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hg+P/BDf4IIWBWbIvIoLRMbhaqAZ9Cev5T7DYF5uzxxSXiGaJ6+TKlpaHXT7BIeua
         tW8IUUwcK6fwfd6FMWGq6GoEMoRSy/stmtjTuERiu0/dqYsdX2WRpYV77wrM51g9ap
         5OEuDmtzn5yjL4ciQzljNAj4J/aIDuCClkX7so9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 151/329] NFSv4.x: Dont return NFS4ERR_NOMATCHING_LAYOUT if were unmounting
Date:   Mon, 17 May 2021 16:01:02 +0200
Message-Id: <20210517140307.217897713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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



