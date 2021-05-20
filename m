Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B0238AB9B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbhETL0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241425AbhETLY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:24:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B9D361D94;
        Thu, 20 May 2021 10:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505557;
        bh=X98kDD5YzeB93LeO0GdNS9gBYB4waJOgja3tMwkSTDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZGIVcTxr6A3VD7MmWBpcBRraEUd8pih/i63e2tPbKz3SHL5FZRjYv6g+bkLIBRdZ
         4XppUeLSjyYXKDmvEHw7OcNA45b042UXNFiNM6WvDsbEuvg9X7JXzIPtUAwOpWtZHA
         OuQWnIp2YFGloIoHjNSGy8LEg4vu6Me4sPDrULqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 155/190] NFS: Deal correctly with attribute generation counter overflow
Date:   Thu, 20 May 2021 11:23:39 +0200
Message-Id: <20210520092107.293744130@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index b15236641191..0d7b8c6e1de8 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1430,10 +1430,10 @@ EXPORT_SYMBOL_GPL(_nfs_display_fhandle);
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
 
 /*
@@ -1849,7 +1849,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			nfsi->attrtimeo_timestamp = now;
 		}
 		/* Set the barrier to be more recent than this fattr */
-		if ((long)fattr->gencount - (long)nfsi->attr_gencount > 0)
+		if ((long)(fattr->gencount - nfsi->attr_gencount) > 0)
 			nfsi->attr_gencount = fattr->gencount;
 	}
 
-- 
2.30.2



