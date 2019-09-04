Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9A0A8CF0
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfIDQTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731911AbfIDP6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F3032339D;
        Wed,  4 Sep 2019 15:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612700;
        bh=mbAnJLPux9j3NgtOPTJIbHRprF1T00ylq5JsIks4E2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuVNa3xDl6B66zQry2q7Yzh4122zN3scBRr+Vf2A8wNfc7qU6hd0dwV9ZYfF5qtHk
         QYfTGYpG7IrjrJ57eynp599Gu7Y6AKazziP+D0V48eRXoReFh89pjtGgc3hQmBaJD7
         LpfCGVE2uo5ObziWcy/319TlHppktRFkLZE1zYFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 28/94] NFS: On fatal writeback errors, we need to call nfs_inode_remove_request()
Date:   Wed,  4 Sep 2019 11:56:33 -0400
Message-Id: <20190904155739.2816-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 06c9fdf3b9f1acc6e53753c99c54c39764cc979f ]

If the writeback error is fatal, we need to remove the tracking structures
(i.e. the nfs_page) from the inode.

Fixes: 6fbda89b257f ("NFS: Replace custom error reporting mechanism...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 059a7c38bc4fc..bf3a3f5e1884e 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -57,6 +57,7 @@ static const struct rpc_call_ops nfs_commit_ops;
 static const struct nfs_pgio_completion_ops nfs_async_write_completion_ops;
 static const struct nfs_commit_completion_ops nfs_commit_completion_ops;
 static const struct nfs_rw_ops nfs_rw_write_ops;
+static void nfs_inode_remove_request(struct nfs_page *req);
 static void nfs_clear_request_commit(struct nfs_page *req);
 static void nfs_init_cinfo_from_inode(struct nfs_commit_info *cinfo,
 				      struct inode *inode);
@@ -591,7 +592,9 @@ nfs_lock_and_join_requests(struct page *page)
 
 static void nfs_write_error(struct nfs_page *req, int error)
 {
+	nfs_set_pageerror(page_file_mapping(req->wb_page));
 	nfs_mapping_set_error(req->wb_page, error);
+	nfs_inode_remove_request(req);
 	nfs_end_page_writeback(req);
 	nfs_release_request(req);
 }
-- 
2.20.1

