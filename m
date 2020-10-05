Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471EF283A46
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgJEPdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728084AbgJEPc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EC6E20637;
        Mon,  5 Oct 2020 15:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911978;
        bh=zrFlTWQdT25tD5lwSZ2qAtsFrtZbfkw1DbkKK0s4JQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJa69vfA1m/bBOiMeYUdQGk2b2jwaEDiLpWgOs8oEjsJLn2IfUwZICEkN+wBeZ8HI
         E/2WFaTfAVxcLn2anxSPO4CkgJ9vjA8loX4YTeSQeDDK1kLah1K/GoYcbmnf7iIRAl
         siJ4rft+VUe2C3Qx2qzH39+i0Kmlt3F9umZQOrSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 54/85] NFSv4.2: fix clients attribute cache management for copy_file_range
Date:   Mon,  5 Oct 2020 17:26:50 +0200
Message-Id: <20201005142117.328602192@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 16abd2a0c124a6c3543c88ca4c53c997c9fb4114 ]

After client is done with the COPY operation, it needs to invalidate
its pagecache (as it did no reading or writing of the data locally)
and it needs to invalidate it's attributes just like it would have
for a read on the source file and write on the destination file.

Once the linux server started giving out read delegations to
read+write opens, the destination file of the copy_file range
started having delegations and not doing syncup on close of the
file leading to xfstest failures for generic/430,431,432,433,565.

v2: changing cache_validity needs to be protected by the i_lock.

Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Fixes: 2e72448b07dc ("NFS: Add COPY nfs operation")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index e2ae54b35dfe1..395a468e349b0 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -355,7 +355,15 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 
 	truncate_pagecache_range(dst_inode, pos_dst,
 				 pos_dst + res->write_res.count);
-
+	spin_lock(&dst_inode->i_lock);
+	NFS_I(dst_inode)->cache_validity |= (NFS_INO_REVAL_PAGECACHE |
+			NFS_INO_REVAL_FORCED | NFS_INO_INVALID_SIZE |
+			NFS_INO_INVALID_ATTR | NFS_INO_INVALID_DATA);
+	spin_unlock(&dst_inode->i_lock);
+	spin_lock(&src_inode->i_lock);
+	NFS_I(src_inode)->cache_validity |= (NFS_INO_REVAL_PAGECACHE |
+			NFS_INO_REVAL_FORCED | NFS_INO_INVALID_ATIME);
+	spin_unlock(&src_inode->i_lock);
 	status = res->write_res.count;
 out:
 	if (args->sync)
-- 
2.25.1



