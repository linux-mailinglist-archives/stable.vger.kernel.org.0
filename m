Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3C8B8423
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393370AbfISWIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393369AbfISWIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:08:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E06218AF;
        Thu, 19 Sep 2019 22:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930892;
        bh=4UVjTMRfyo4/iT3zFZt/WN2rfF3f6IP/Scn344Vv84M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkmMAbKb1GMnXXEtIcQVRdZAQyGSTRI2b/XwzZb1Uyu/iHl2oAU3NV5Jycd9g6kJd
         1lFa1beferAsXNUhaNBz84uY4/hHi0DBo0CVxxoZGFkGBM5KJ8WWgTdDx3fF0V5edC
         2z2Z8VNRZmZyPd0JUmiA0hJEGJO3U/+I4ByW8ha0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 053/124] NFS: On fatal writeback errors, we need to call nfs_inode_remove_request()
Date:   Fri, 20 Sep 2019 00:02:21 +0200
Message-Id: <20190919214820.932342115@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -591,7 +592,9 @@ release_request:
 
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



