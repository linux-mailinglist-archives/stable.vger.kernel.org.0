Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D66B3CE2CF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhGSPcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348314AbhGSPaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEA246115B;
        Mon, 19 Jul 2021 16:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710968;
        bh=MKvv0JDy2Rf+bA8Hb2DGAmiAM0YmdIEgaq3vBgN0j/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdcUt0nIOvdhVghBfNd95hmNhQpu5NWWg8JuiLY6jquOfX3rIDDN0GVjmsFRhxqDT
         6ySspL59AJb4RqCnEkPx01zoeenWmRzav/1jevwOhAIxlN3CT6hS9C8V03OyreL5wd
         mUYpxsx9ATwTO8X+XEtjCehw1xGlNdoci3D3o3nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 178/351] NFSv4: Fix handling of non-atomic change attrbute updates
Date:   Mon, 19 Jul 2021 16:52:04 +0200
Message-Id: <20210719144950.874359578@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 20cf7d4ea4ad7d9830b01ff7444f6ac64a727a23 ]

If the change attribute update is declared to be non-atomic by the
server, or our cached value does not match the server's value before the
operation was performed, then we should declare the inode cache invalid.

On the other hand, if the change to the directory raced with a lookup or
getattr which already updated the change attribute, then optimise away
the revalidation.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e653654c10bc..451d3d56d80c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1205,12 +1205,12 @@ nfs4_update_changeattr_locked(struct inode *inode,
 	u64 change_attr = inode_peek_iversion_raw(inode);
 
 	cache_validity |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
+	if (S_ISDIR(inode->i_mode))
+		cache_validity |= NFS_INO_INVALID_DATA;
 
 	switch (NFS_SERVER(inode)->change_attr_type) {
 	case NFS4_CHANGE_TYPE_IS_UNDEFINED:
-		break;
-	case NFS4_CHANGE_TYPE_IS_TIME_METADATA:
-		if ((s64)(change_attr - cinfo->after) > 0)
+		if (cinfo->after == change_attr)
 			goto out;
 		break;
 	default:
@@ -1218,24 +1218,21 @@ nfs4_update_changeattr_locked(struct inode *inode,
 			goto out;
 	}
 
-	if (cinfo->atomic && cinfo->before == change_attr) {
-		nfsi->attrtimeo_timestamp = jiffies;
-	} else {
-		if (S_ISDIR(inode->i_mode)) {
-			cache_validity |= NFS_INO_INVALID_DATA;
+	inode_set_iversion_raw(inode, cinfo->after);
+	if (!cinfo->atomic || cinfo->before != change_attr) {
+		if (S_ISDIR(inode->i_mode))
 			nfs_force_lookup_revalidate(inode);
-		} else {
-			if (!NFS_PROTO(inode)->have_delegation(inode,
-							       FMODE_READ))
-				cache_validity |= NFS_INO_REVAL_PAGECACHE;
-		}
 
-		if (cinfo->before != change_attr)
-			cache_validity |= NFS_INO_INVALID_ACCESS |
-					  NFS_INO_INVALID_ACL |
-					  NFS_INO_INVALID_XATTR;
+		if (!NFS_PROTO(inode)->have_delegation(inode, FMODE_READ))
+			cache_validity |=
+				NFS_INO_INVALID_ACCESS | NFS_INO_INVALID_ACL |
+				NFS_INO_INVALID_SIZE | NFS_INO_INVALID_OTHER |
+				NFS_INO_INVALID_BLOCKS | NFS_INO_INVALID_NLINK |
+				NFS_INO_INVALID_MODE | NFS_INO_INVALID_XATTR |
+				NFS_INO_REVAL_PAGECACHE;
+		nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 	}
-	inode_set_iversion_raw(inode, cinfo->after);
+	nfsi->attrtimeo_timestamp = jiffies;
 	nfsi->read_cache_jiffies = timestamp;
 	nfsi->attr_gencount = nfs_inc_attr_generation_counter();
 	nfsi->cache_validity &= ~NFS_INO_INVALID_CHANGE;
-- 
2.30.2



