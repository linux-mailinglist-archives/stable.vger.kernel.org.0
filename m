Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769A43834A5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbhEQPLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243038AbhEQPI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5E3161C2F;
        Mon, 17 May 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261807;
        bh=8VU5IFV9XrQdAJq0Vfo44cpRfZtqg2mqkO6qIk1MVNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPBoCVBObKrhF6ZM5ceedMqsz6bL4Ho7mmYvKNl1MCObTlwDcv6BwUZikP0d30rZ/
         D1jEqAubIFc8TjCq0lub1ab6LeF1BVLyi93uLaXhprlYHU0yb2TEgX+60ahANZ7fUt
         S9KEE7Ka36bbGS0ncwh6rht7ZXaqFiy22gnw+BGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 140/329] NFS: Deal correctly with attribute generation counter overflow
Date:   Mon, 17 May 2021 16:00:51 +0200
Message-Id: <20210517140306.845864489@linuxfoundation.org>
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
index 522aa10a1a3e..fd073b1caf6c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1635,10 +1635,10 @@ EXPORT_SYMBOL_GPL(_nfs_display_fhandle);
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
@@ -2067,7 +2067,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			nfsi->attrtimeo_timestamp = now;
 		}
 		/* Set the barrier to be more recent than this fattr */
-		if ((long)fattr->gencount - (long)nfsi->attr_gencount > 0)
+		if ((long)(fattr->gencount - nfsi->attr_gencount) > 0)
 			nfsi->attr_gencount = fattr->gencount;
 	}
 
-- 
2.30.2



