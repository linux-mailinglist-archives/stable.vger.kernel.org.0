Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58253835E7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243183AbhEQP0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243633AbhEQPYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:24:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E795D61C82;
        Mon, 17 May 2021 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262129;
        bh=Q/N41Wu6G7f2vA/oK8HIXZBsFS051hfhmJgTIaQ9e7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMQv5EJLVR4aaKoHMLjoHBtLTqiEo4Og3vQy4kXJtVJru7q7DbMQjIe1svZ6VH8XJ
         pX/HFOjGGOjTCC1//cByX4InWtXJFIJ7lUDojbC+5kPTiNsGLee4Ov3U0PmvnBvvWD
         veNVhs6T19umXSb2UX0EIj6zit9A6B1nbZIr2VfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/289] NFS: Fix attribute bitmask in _nfs42_proc_fallocate()
Date:   Mon, 17 May 2021 16:00:42 +0200
Message-Id: <20210517140309.104897332@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e99812e1382f0bfb6149393262bc70645c9f537a ]

We can't use nfs4_fattr_bitmap as a bitmask, because it hasn't been
filtered to represent the attributes supported by the server. Instead,
let's revert to using server->cache_consistency_bitmask after adding in
the missing SPACE_USED attribute.

Fixes: 913eca1aea87 ("NFS: Fallocate should use the nfs4_fattr_bitmap")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 4fc61e3d098d..52d8cc253a2b 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -46,11 +46,12 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 {
 	struct inode *inode = file_inode(filep);
 	struct nfs_server *server = NFS_SERVER(inode);
+	u32 bitmask[3];
 	struct nfs42_falloc_args args = {
 		.falloc_fh	= NFS_FH(inode),
 		.falloc_offset	= offset,
 		.falloc_length	= len,
-		.falloc_bitmask	= nfs4_fattr_bitmap,
+		.falloc_bitmask	= bitmask,
 	};
 	struct nfs42_falloc_res res = {
 		.falloc_server	= server,
@@ -68,6 +69,10 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 		return status;
 	}
 
+	memcpy(bitmask, server->cache_consistency_bitmask, sizeof(bitmask));
+	if (server->attr_bitmask[1] & FATTR4_WORD1_SPACE_USED)
+		bitmask[1] |= FATTR4_WORD1_SPACE_USED;
+
 	res.falloc_fattr = nfs_alloc_fattr();
 	if (!res.falloc_fattr)
 		return -ENOMEM;
@@ -75,7 +80,8 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 	status = nfs4_call_sync(server->client, server, msg,
 				&args.seq_args, &res.seq_res, 0);
 	if (status == 0)
-		status = nfs_post_op_update_inode(inode, res.falloc_fattr);
+		status = nfs_post_op_update_inode_force_wcc(inode,
+							    res.falloc_fattr);
 
 	kfree(res.falloc_fattr);
 	return status;
-- 
2.30.2



