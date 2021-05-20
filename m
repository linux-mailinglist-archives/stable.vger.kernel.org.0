Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9C638A0D2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhETJ0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231575AbhETJ0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B02786121E;
        Thu, 20 May 2021 09:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502689;
        bh=B3A+n1zVtc3QtO78N4DSfLAKzHJNFypaNnHymOaCGE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxW7v94lY1FRDfdr3ECKoNKTsUPO8fIPLpLuKSrlv8vbFpXOkcVMu1I6rJy6Yc9ui
         V8bit/E5gnTMEbxawJVSGrxTFX0vwvIBTAh9X/4HVJ3tTeBwZ6SLPug65JOo1u7MOw
         qD4oxj2n1vF0n9f9jxFfZhLRhGuLrYbeCkwb6+OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 15/45] NFS: NFS_INO_REVAL_PAGECACHE should mark the change attribute invalid
Date:   Thu, 20 May 2021 11:22:03 +0200
Message-Id: <20210520092054.022679935@linuxfoundation.org>
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

[ Upstream commit 50c7a7994dd20af56e4d47e90af10bab71b71001 ]

When we're looking to revalidate the page cache, we should just ensure
that we mark the change attribute invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 8de5b3b9da91..ae8bc84e39fb 100644
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



