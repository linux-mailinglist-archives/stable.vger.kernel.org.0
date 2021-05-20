Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B7B38A0C6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhETJZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhETJZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:25:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C75B6124C;
        Thu, 20 May 2021 09:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502678;
        bh=0UioaWyn/ev5z+NhM9QGxb++YD81myzj6kgjUMLeGw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBc6+HIAPIbHqaxCb3vVRW0ubAZ3V+/gwcQA/SwJzVM9wiXufplKOqi+nEk8iCjlW
         WQ8NNju/5pbuDnhpPbLDT4n9FL1X+jLuBHXpI6NnB2rb4XYAG7pA1JHa0DSjFwV/2Y
         1N3MDwHZp4Da4+l1fZGSp0VQZhIaa9Z5eTK/MvMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 10/45] NFS: Fix fscache invalidation in nfs_set_cache_invalid()
Date:   Thu, 20 May 2021 11:21:58 +0200
Message-Id: <20210520092053.860276300@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit beab450d8ea93cdf4c6cb7714bdc31a9e0f34738 ]

Ensure that we invalidate the fscache before we strip the
NFS_INO_INVALID_DATA flag.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 7cfeee3eeef7..8de5b3b9da91 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -223,11 +223,11 @@ void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 
 	if (!nfs_has_xattr_cache(nfsi))
 		flags &= ~NFS_INO_INVALID_XATTR;
+	if (flags & NFS_INO_INVALID_DATA)
+		nfs_fscache_invalidate(inode);
 	if (inode->i_mapping->nrpages == 0)
 		flags &= ~(NFS_INO_INVALID_DATA|NFS_INO_DATA_INVAL_DEFER);
 	nfsi->cache_validity |= flags;
-	if (flags & NFS_INO_INVALID_DATA)
-		nfs_fscache_invalidate(inode);
 }
 EXPORT_SYMBOL_GPL(nfs_set_cache_invalid);
 
-- 
2.30.2



