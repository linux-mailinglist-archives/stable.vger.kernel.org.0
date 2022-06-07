Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D199540E5A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353530AbiFGSyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354514AbiFGSrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2308819AB;
        Tue,  7 Jun 2022 11:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57EC2617A7;
        Tue,  7 Jun 2022 18:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681F5C385A5;
        Tue,  7 Jun 2022 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624900;
        bh=8sCIcx0aQxomEVMAr6YNxWI5i/2y9Ehb0ZbAhS4y7hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCyPeIbYZGaocwJPALAO0z4W4YLpv2lrm3BDGnnjH+YsruD4kgGtY002JwPNSlBW7
         4QkXhWqw4eZPqOOgbj8q39zoaAxaFa8+lHz87A9eQV7wY73jwxVD4AzGIC3uQti+qR
         CYAB1JVy6owLOosxOxxJ7EoSJOelyveNxtRxhyHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 495/667] NFS: Dont report ENOSPC write errors twice
Date:   Tue,  7 Jun 2022 19:02:40 +0200
Message-Id: <20220607164949.544018544@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e6005436f6cc9ed13288f936903f0151e5543485 ]

Any errors reported by the write() system call need to be cleared from
the file descriptor's error tracking. The current call to nfs_wb_all()
causes the error to be reported, but since it doesn't call
file_check_and_advance_wb_err(), we can end up reporting the same error
a second time when the application calls fsync().

Note that since Linux 4.13, the rule is that EIO may be reported for
write(), but it must be reported by a subsequent fsync(), so let's just
drop reporting it in write.

The check for nfs_ctx_key_to_expire() is just a duplicate to the one
already in nfs_write_end(), so let's drop that too.

Reported-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Fixes: ce368536dd61 ("nfs: nfs_file_write() should check for writeback errors")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 018d29a79e73..1b66362696e0 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -591,18 +591,6 @@ static const struct vm_operations_struct nfs_file_vm_ops = {
 	.page_mkwrite = nfs_vm_page_mkwrite,
 };
 
-static int nfs_need_check_write(struct file *filp, struct inode *inode,
-				int error)
-{
-	struct nfs_open_context *ctx;
-
-	ctx = nfs_file_open_context(filp);
-	if (nfs_error_is_fatal_on_server(error) ||
-	    nfs_ctx_key_to_expire(ctx, inode))
-		return 1;
-	return 0;
-}
-
 ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
@@ -630,7 +618,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_APPEND || iocb->ki_pos > i_size_read(inode)) {
 		result = nfs_revalidate_file_size(inode, file);
 		if (result)
-			goto out;
+			return result;
 	}
 
 	nfs_clear_invalid_mapping(file->f_mapping);
@@ -649,6 +637,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 
 	written = result;
 	iocb->ki_pos += written;
+	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, written);
 
 	if (mntflags & NFS_MOUNT_WRITE_EAGER) {
 		result = filemap_fdatawrite_range(file->f_mapping,
@@ -666,17 +655,22 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 	result = generic_write_sync(iocb, written);
 	if (result < 0)
-		goto out;
+		return result;
 
+out:
 	/* Return error values */
 	error = filemap_check_wb_err(file->f_mapping, since);
-	if (nfs_need_check_write(file, inode, error)) {
-		int err = nfs_wb_all(inode);
-		if (err < 0)
-			result = err;
+	switch (error) {
+	default:
+		break;
+	case -EDQUOT:
+	case -EFBIG:
+	case -ENOSPC:
+		nfs_wb_all(inode);
+		error = file_check_and_advance_wb_err(file);
+		if (error < 0)
+			result = error;
 	}
-	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, written);
-out:
 	return result;
 
 out_swapfile:
-- 
2.35.1



