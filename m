Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957A538A78E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhETKkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236934AbhETKhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A80361C6F;
        Thu, 20 May 2021 09:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504479;
        bh=nKRRezXCNzgWtS4yO3a5DHFve5ywiTt0seCMUzkIUKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wg1ykS8+uB1Rf88wlw+M8blaLV4sY0KTaAAzHb+d8DV23ih0jgygOtCegkuvr8NOz
         tjC11qTPIicLOVpUCDOPLU7sTl6YLbcyZOW9a4Z45B8Kx+ncmT1XJb+3wgJxv4KmXG
         bKerfcZ+srAEjLWwjZPXT4F+EHJ3iqqyPfbuFosM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 264/323] NFS: Deal correctly with attribute generation counter overflow
Date:   Thu, 20 May 2021 11:22:36 +0200
Message-Id: <20210520092129.265612512@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9fdbfad1777cb4638f489eeb62d85432010c0031 ]

We need to use unsigned long subtraction and then convert to signed in
order to deal correcly with C overflow rules.

Fixes: f5062003465c ("NFS: Set an attribute barrier on all updates")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f0534b356f07..33cc69687792 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1533,10 +1533,10 @@ EXPORT_SYMBOL_GPL(_nfs_display_fhandle);
  */
 static int nfs_inode_attrs_need_update(const struct inode *inode, const struct nfs_fattr *fattr)
 {
-	const struct nfs_inode *nfsi = NFS_I(inode);
+	unsigned long attr_gencount = NFS_I(inode)->attr_gencount;
 
-	return ((long)fattr->gencount - (long)nfsi->attr_gencount) > 0 ||
-		((long)nfsi->attr_gencount - (long)nfs_read_attr_generation_counter() > 0);
+	return (long)(fattr->gencount - attr_gencount) > 0 ||
+	       (long)(attr_gencount - nfs_read_attr_generation_counter()) > 0;
 }
 
 static int nfs_refresh_inode_locked(struct inode *inode, struct nfs_fattr *fattr)
@@ -1939,7 +1939,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			nfsi->attrtimeo_timestamp = now;
 		}
 		/* Set the barrier to be more recent than this fattr */
-		if ((long)fattr->gencount - (long)nfsi->attr_gencount > 0)
+		if ((long)(fattr->gencount - nfsi->attr_gencount) > 0)
 			nfsi->attr_gencount = fattr->gencount;
 	}
 
-- 
2.30.2



