Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F2A15EAF0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391070AbgBNRRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391770AbgBNQLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1CE2246A1;
        Fri, 14 Feb 2020 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696683;
        bh=JPF2rN+8oq6r0Z+/bpVeXmqbRRqTwGoYbApl8cGhl/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2V+WO+zqb94jHIXxvcyEglfSb0xKOdL6iLOod5uMae+Bv6t4/U9RF2oYBkiRo0GGO
         pTtTashdQuVdeszUi1Qh5BkkjTXYHWu7sn2t5C1ap7tyrHZQhguB8HVly9+syzCT2g
         CwtODiJOR1dUI41kTcBoPyT5lG/aiwX9t/knUetk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 451/459] NFS: Fix memory leaks
Date:   Fri, 14 Feb 2020 11:01:41 -0500
Message-Id: <20200214160149.11681-451-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 5196bfa7894d2..9b61c80a93e9e 100644
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

