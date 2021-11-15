Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7D34522DE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352233AbhKPBQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244662AbhKOTRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36553615A4;
        Mon, 15 Nov 2021 18:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000570;
        bh=2uBG98njyRcAWRJVScVJIz9Ar2oswvT+HqjAEIe/IO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncafXMwdfATodAfR2auv/tfIbtqeJmQ8V9VErruCHjwD/ScYtTAay4zVkdQQAFiVz
         7uRpG2PxhwoH6Qy+WWPyasw2nmZTMdDF3v4u0RJhyQAZbozM8q4wsNpoJJDgNjVyKo
         HDQu4gTcg3Sks+N1E7peMSXfAhzWhTb0H5IDgUa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 677/849] NFS: Ignore the directory size when marking for revalidation
Date:   Mon, 15 Nov 2021 18:02:40 +0100
Message-Id: <20211115165443.174769922@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit a6a361c4ca3cc3e6f3b39d1b6bca1de90f5f4b11 ]

If we want to revalidate the directory, then just mark the change
attribute as invalid.

Fixes: 13c0b082b6a9 ("NFS: Replace use of NFS_INO_REVAL_PAGECACHE when checking cache validity")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 1a6d2867fba4f..085b8ecdc17d9 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1413,7 +1413,7 @@ out_force:
 static void nfs_mark_dir_for_revalidate(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-	nfs_set_cache_invalid(inode, NFS_INO_REVAL_PAGECACHE);
+	nfs_set_cache_invalid(inode, NFS_INO_INVALID_CHANGE);
 	spin_unlock(&inode->i_lock);
 }
 
-- 
2.33.0



