Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168F837D26E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345985AbhELSJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352539AbhELSDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5278861430;
        Wed, 12 May 2021 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842541;
        bh=x1HdqOJCrgG+v2vUZsVAFDnGskg7j1VjwS1E6UWMNIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMnJLwlZi2q2mRzsEOBckjNn6dZ/DZHO/avnhQZK3ZwPfTxPlyRqAl4obzisR8O68
         E/TZV6wVKcQb4LJyPC5n4BCh8ei0r2TPU8h+OhBkVqIrN6//2lKNJB/yq/rH2P3VhX
         wJpWUlvs5eHjNaD0EmogbiBH0iHeK12q0MtlpqQhdnnlXDWdwsIH48vyVHMGVGFQt2
         jwWGBQ5mtYpTG3ymE2UjekJ1N3YvRZYP1oJtKWMcwnQRZoOQcThCPSXI8JEwIVV6HK
         Kxg3cl3P5ob+Z18Ls9q85m7t0KJXeH+rdwkURNDQUsYm8jyaJklQuEXMFRCXT4tkpC
         0iajGgCqHYgyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 10/35] NFS: NFS_INO_REVAL_PAGECACHE should mark the change attribute invalid
Date:   Wed, 12 May 2021 14:01:40 -0400
Message-Id: <20210512180206.664536-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 50c7a7994dd20af56e4d47e90af10bab71b71001 ]

When we're looking to revalidate the page cache, we should just ensure
that we mark the change attribute invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 522aa10a1a3e..d11e066ab518 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -207,7 +207,8 @@ static void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 				| NFS_INO_INVALID_SIZE
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_INVALID_XATTR);
-	}
+	} else if (flags & NFS_INO_REVAL_PAGECACHE)
+		flags |= NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_SIZE;
 
 	if (inode->i_mapping->nrpages == 0)
 		flags &= ~(NFS_INO_INVALID_DATA|NFS_INO_DATA_INVAL_DEFER);
-- 
2.30.2

