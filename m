Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6999938A9A1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhETLFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238908AbhETLB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1FE61D11;
        Thu, 20 May 2021 10:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505038;
        bh=luXZQP9Rz2/4d6Wl+X/ZCEKV/DqB17C0PCwyfQdo5ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnfPjEtp4/7hpP2tXtctmHCvBr81fKuBbFNaiJz0OjuZnmXvgot5akXMITqGFV4tU
         3+bz7WfrkhHrqxjyNcF8FQxelHMFHmBrdTjJrQwtRuaMCvswWnAEBaP+WjY8tudauh
         NSsEcg91PK2+B5xRcysPSjld93IOtWf74eCC2rT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 195/240] NFSv4.2: Always flush out writes in nfs42_proc_fallocate()
Date:   Thu, 20 May 2021 11:23:07 +0200
Message-Id: <20210520092115.210265542@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 99f23783224355e7022ceea9b8d9f62c0fd01bd8 ]

Whether we're allocating or delallocating space, we should flush out the
pending writes in order to avoid races with attribute updates.

Fixes: 1e564d3dbd68 ("NFSv4.2: Fix a race in nfs42_proc_deallocate()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 5cda392028ce..7e9fb1119bcf 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -56,7 +56,8 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 static int nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 				loff_t offset, loff_t len)
 {
-	struct nfs_server *server = NFS_SERVER(file_inode(filep));
+	struct inode *inode = file_inode(filep);
+	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs4_exception exception = { };
 	struct nfs_lock_context *lock;
 	int err;
@@ -65,9 +66,13 @@ static int nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 	if (IS_ERR(lock))
 		return PTR_ERR(lock);
 
-	exception.inode = file_inode(filep);
+	exception.inode = inode;
 	exception.state = lock->open_context->state;
 
+	err = nfs_sync_inode(inode);
+	if (err)
+		goto out;
+
 	do {
 		err = _nfs42_proc_fallocate(msg, filep, lock, offset, len);
 		if (err == -ENOTSUPP) {
@@ -76,7 +81,7 @@ static int nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 		}
 		err = nfs4_handle_exception(server, err, &exception);
 	} while (exception.retry);
-
+out:
 	nfs_put_lock_context(lock);
 	return err;
 }
@@ -114,16 +119,13 @@ int nfs42_proc_deallocate(struct file *filep, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	inode_lock(inode);
-	err = nfs_sync_inode(inode);
-	if (err)
-		goto out_unlock;
 
 	err = nfs42_proc_fallocate(&msg, filep, offset, len);
 	if (err == 0)
 		truncate_pagecache_range(inode, offset, (offset + len) -1);
 	if (err == -EOPNOTSUPP)
 		NFS_SERVER(inode)->caps &= ~NFS_CAP_DEALLOCATE;
-out_unlock:
+
 	inode_unlock(inode);
 	return err;
 }
-- 
2.30.2



