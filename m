Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3B5167222
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbgBUIAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731068AbgBUIAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:00:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92031206ED;
        Fri, 21 Feb 2020 08:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272030;
        bh=fWkVieqX4+okU8uVSg0m7NTofCEOdf4K60FWuuLXt9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9iksqhNfoGA8XiYKQWXYwQIIzhnYXFDRgu/pGrd8ouLdUhbn9rXj2z2qfQh10Tz6
         siwM0yT8C1go77NP8K+kags2aN8SXgeBYC4ZL0wUwOx1GYi7/kvYeWSkvxEyD5QTuF
         0Esg9HJTrukBoDFgMOBNhbzZop0NqoeNZOzG9bfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 388/399] NFS: Fix memory leaks
Date:   Fri, 21 Feb 2020 08:41:53 +0100
Message-Id: <20200221072437.736264325@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9637aad36bdca..e2ae54b35dfe1 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -343,14 +343,14 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 		status = handle_async_copy(res, dst_server, src_server, src,
 				dst, &args->src_stateid, restart);
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



