Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FDF4522DF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378655AbhKPBQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244661AbhKOTRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BBB860EE2;
        Mon, 15 Nov 2021 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000568;
        bh=UXXQVHeHtyJP2cKEqWskxuA237ekK3ZYRAQatTnXhXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlzsmhV7dyfUaimKrar6rcnc5nvNq/WopyZ9pYU4lUSGuUf5Z79jNiCJcUU9UIX6N
         FNxAvVXTBmU0scE0GnwBFDPYy4J0C4rl1es1eEKGO58NSQ3Ok2avwu5irtmjX3ONDg
         TxXlKA1Hwdcm111H55eXBT2DodFNja4F7c6aqItE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 676/849] NFS: Dont set NFS_INO_DATA_INVAL_DEFER and NFS_INO_INVALID_DATA
Date:   Mon, 15 Nov 2021 18:02:39 +0100
Message-Id: <20211115165443.143026632@linuxfoundation.org>
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

[ Upstream commit 488796ec1e39fb9194cc8175f770823d40fbf0ed ]

NFS_INO_DATA_INVAL_DEFER and NFS_INO_INVALID_DATA should be considered
mutually exclusive.

Fixes: 1c341b777501 ("NFS: Add deferred cache invalidation for close-to-open consistency violations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 6ea1bde33cb62..f9d3ad3acf114 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -210,10 +210,15 @@ void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 		flags &= ~NFS_INO_INVALID_XATTR;
 	if (flags & NFS_INO_INVALID_DATA)
 		nfs_fscache_invalidate(inode);
-	if (inode->i_mapping->nrpages == 0)
-		flags &= ~(NFS_INO_INVALID_DATA|NFS_INO_DATA_INVAL_DEFER);
 	flags &= ~(NFS_INO_REVAL_PAGECACHE | NFS_INO_REVAL_FORCED);
+
 	nfsi->cache_validity |= flags;
+
+	if (inode->i_mapping->nrpages == 0)
+		nfsi->cache_validity &= ~(NFS_INO_INVALID_DATA |
+					  NFS_INO_DATA_INVAL_DEFER);
+	else if (nfsi->cache_validity & NFS_INO_INVALID_DATA)
+		nfsi->cache_validity &= ~NFS_INO_DATA_INVAL_DEFER;
 }
 EXPORT_SYMBOL_GPL(nfs_set_cache_invalid);
 
-- 
2.33.0



