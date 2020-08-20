Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6A724BB95
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgHTJuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729704AbgHTJuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:50:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8692C20724;
        Thu, 20 Aug 2020 09:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917003;
        bh=VjGXS5qUqznvGzS2U4eUACOqvpULSo7dVAE7teJvuEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d83Pze5JjyX14PAyFSVzqWqH24ujGKsXDTjcLJ+RpQGG9v7BtK1DiVDEngSKmHby3
         VKGv8QHAaOHO6pfZK10G2LjRmFoUiB0NXFBuMSSQ3eVdjYRZtckxz63vn35ImkK1Ni
         /n3JR9fTtNEQtvdRRWWKqWIRDoeK0wu8VAyUkMeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/152] nfs: nfs_file_write() should check for writeback errors
Date:   Thu, 20 Aug 2020 11:21:29 +0200
Message-Id: <20200820091600.023309775@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit ce368536dd614452407dc31e2449eb84681a06af ]

The NFS_CONTEXT_ERROR_WRITE flag (as well as the check of said flag) was
removed by commit 6fbda89b257f.  The absence of an error check allows
writes to be continually queued up for a server that may no longer be
able to handle them.  Fix it by adding an error check using the generic
error reporting functions.

Fixes: 6fbda89b257f ("NFS: Replace custom error reporting mechanism with generic one")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 348f67c8f3224..387a2cfa7e172 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -583,12 +583,14 @@ static const struct vm_operations_struct nfs_file_vm_ops = {
 	.page_mkwrite = nfs_vm_page_mkwrite,
 };
 
-static int nfs_need_check_write(struct file *filp, struct inode *inode)
+static int nfs_need_check_write(struct file *filp, struct inode *inode,
+				int error)
 {
 	struct nfs_open_context *ctx;
 
 	ctx = nfs_file_open_context(filp);
-	if (nfs_ctx_key_to_expire(ctx, inode))
+	if (nfs_error_is_fatal_on_server(error) ||
+	    nfs_ctx_key_to_expire(ctx, inode))
 		return 1;
 	return 0;
 }
@@ -599,6 +601,8 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(file);
 	unsigned long written = 0;
 	ssize_t result;
+	errseq_t since;
+	int error;
 
 	result = nfs_key_timeout_notify(file, inode);
 	if (result)
@@ -623,6 +627,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos > i_size_read(inode))
 		nfs_revalidate_mapping(inode, file->f_mapping);
 
+	since = filemap_sample_wb_err(file->f_mapping);
 	nfs_start_io_write(inode);
 	result = generic_write_checks(iocb, from);
 	if (result > 0) {
@@ -641,7 +646,8 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 
 	/* Return error values */
-	if (nfs_need_check_write(file, inode)) {
+	error = filemap_check_wb_err(file->f_mapping, since);
+	if (nfs_need_check_write(file, inode, error)) {
 		int err = nfs_wb_all(inode);
 		if (err < 0)
 			result = err;
-- 
2.25.1



