Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2F615E839
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404192AbgBNQQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392705AbgBNQQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:16:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F3BD24691;
        Fri, 14 Feb 2020 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697018;
        bh=na6MCkvM/gU1JTmFSKwL58UmWb1R7nW/sp5fjyKvY64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auVYCH5/qDW/bAK4wkJ5M/0oigy0UU0PFYZyOBZOm1heeGdqa0Gp0euF4I9sB7Se1
         I6IPu1k1aIYcE03W8DvPHBd5EB5UzalbOhiNlRSCL8Z/lwIigAtR3Skift+ziDP3pC
         1Ix0MnGVpsm30gPoBqPew2Kxcf9Ub2RrD1gx+2B0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 247/252] NFS: Fix memory leaks
Date:   Fri, 14 Feb 2020 11:11:42 -0500
Message-Id: <20200214161147.15842-247-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 123c23c6a7b7ecd2a3d6060bea1d94019f71fd66 ]

In _nfs42_proc_copy(), 'res->commit_res.verf' is allocated through
kzalloc() if 'args->sync' is true. In the following code, if
'res->synchronous' is false, handle_async_copy() will be invoked. If an
error occurs during the invocation, the following code will not be executed
and the error will be returned . However, the allocated
'res->commit_res.verf' is not deallocated, leading to a memory leak. This
is also true if the invocation of process_copy_commit() returns an error.

To fix the above leaks, redirect the execution to the 'out' label if an
error is encountered.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 94f98e190e632..526441de89c1d 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -283,14 +283,14 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 		status = handle_async_copy(res, server, src, dst,
 				&args->src_stateid);
 		if (status)
-			return status;
+			goto out;
 	}
 
 	if ((!res->synchronous || !args->sync) &&
 			res->write_res.verifier.committed != NFS_FILE_SYNC) {
 		status = process_copy_commit(dst, pos_dst, res);
 		if (status)
-			return status;
+			goto out;
 	}
 
 	truncate_pagecache_range(dst_inode, pos_dst,
-- 
2.20.1

