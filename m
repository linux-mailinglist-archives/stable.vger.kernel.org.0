Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772EA37D243
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbhELSHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352073AbhELSC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 097F86142C;
        Wed, 12 May 2021 18:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842480;
        bh=qwoYgyRCT7R8e2KUDxnrGQ3wOCWfQODJ49rpHCBVy6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNejDGZsu3+GFH1CViWzer8B2kSWrj/DmWvCAcfqcVXrjLp8eIXhluNBJ3kqdqwjy
         ofifcjY/ayHvd4U/Wynxch3D8ELKyEEyvgm7XXSBM8EYOhDSFLfoLG3ga0V3MnfdsL
         lGBrHBzy/wz8GyT1LnyiKTNoiVgKjlqUjppKrw7mraczhKHGh+D1Q6zn5b2NGCtlq8
         EOKvz+5kc1jMRGaVqdhVBHdphLIJTzMLnvvN0HFF/3MQGxb1uqxbfp5qIQkfs15Odl
         RYbbs05AERT7M2yXelBI8XBrASGik9tWdv9h3FDMaRGGGEyixS8/pp1G6FAZH/CBtf
         cEoNU8Fch7F2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 11/37] NFS: NFS_INO_REVAL_PAGECACHE should mark the change attribute invalid
Date:   Wed, 12 May 2021 14:00:38 -0400
Message-Id: <20210512180104.664121-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
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
index ff737be559dc..97cce24f5085 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -219,7 +219,8 @@ void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 				| NFS_INO_INVALID_SIZE
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_INVALID_XATTR);
-	}
+	} else if (flags & NFS_INO_REVAL_PAGECACHE)
+		flags |= NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_SIZE;
 
 	if (!nfs_has_xattr_cache(nfsi))
 		flags &= ~NFS_INO_INVALID_XATTR;
-- 
2.30.2

