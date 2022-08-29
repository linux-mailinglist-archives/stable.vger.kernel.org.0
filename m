Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EFF5A486A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiH2LKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiH2LJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:09:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2960A6B15C;
        Mon, 29 Aug 2022 04:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3F07611B8;
        Mon, 29 Aug 2022 11:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A1FC433C1;
        Mon, 29 Aug 2022 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771182;
        bh=YlnfQbV4ZasJ5+pYHMjHHupkiCta5PQLbbUdF/59zA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXtPM+FyEq1wd+nd9vOQ/DIx4ZFMuHpEJgJYfhsNGprOy1cvHrcaeouOL6z4Uri9i
         Vo3WkCK0vjIrdZlBx0IOxmRiIcyqRSzNQ2rRRaZtTEofwUSVQkGz9911vmEamWRfML
         hKsVLzEK6qC3VjVOLVQbUlk2DLd7lMbEmzYzBG/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.19 002/158] NFS: Fix another fsync() issue after a server reboot
Date:   Mon, 29 Aug 2022 12:57:32 +0200
Message-Id: <20220829105808.934230208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 67f4b5dc49913abcdb5cc736e73674e2f352f81d upstream.

Currently, when the writeback code detects a server reboot, it redirties
any pages that were not committed to disk, and it sets the flag
NFS_CONTEXT_RESEND_WRITES in the nfs_open_context of the file descriptor
that dirtied the file. While this allows the file descriptor in question
to redrive its own writes, it violates the fsync() requirement that we
should be synchronising all writes to disk.
While the problem is infrequent, we do see corner cases where an
untimely server reboot causes the fsync() call to abandon its attempt to
sync data to disk and causing data corruption issues due to missed error
conditions or similar.

In order to tighted up the client's ability to deal with this situation
without introducing livelocks, add a counter that records the number of
times pages are redirtied due to a server reboot-like condition, and use
that in fsync() to redrive the sync to disk.

Fixes: 2197e9b06c22 ("NFS: Fix up fsync() when the server rebooted")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/file.c          |   15 ++++++---------
 fs/nfs/inode.c         |    1 +
 fs/nfs/write.c         |    6 ++++--
 include/linux/nfs_fs.h |    1 +
 4 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -221,8 +221,10 @@ nfs_file_fsync_commit(struct file *file,
 int
 nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct nfs_open_context *ctx = nfs_file_open_context(file);
 	struct inode *inode = file_inode(file);
+	struct nfs_inode *nfsi = NFS_I(inode);
+	long save_nredirtied = atomic_long_read(&nfsi->redirtied_pages);
+	long nredirtied;
 	int ret;
 
 	trace_nfs_fsync_enter(inode);
@@ -237,15 +239,10 @@ nfs_file_fsync(struct file *file, loff_t
 		ret = pnfs_sync_inode(inode, !!datasync);
 		if (ret != 0)
 			break;
-		if (!test_and_clear_bit(NFS_CONTEXT_RESEND_WRITES, &ctx->flags))
+		nredirtied = atomic_long_read(&nfsi->redirtied_pages);
+		if (nredirtied == save_nredirtied)
 			break;
-		/*
-		 * If nfs_file_fsync_commit detected a server reboot, then
-		 * resend all dirty pages that might have been covered by
-		 * the NFS_CONTEXT_RESEND_WRITES flag
-		 */
-		start = 0;
-		end = LLONG_MAX;
+		save_nredirtied = nredirtied;
 	}
 
 	trace_nfs_fsync_exit(inode, ret);
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -426,6 +426,7 @@ nfs_ilookup(struct super_block *sb, stru
 static void nfs_inode_init_regular(struct nfs_inode *nfsi)
 {
 	atomic_long_set(&nfsi->nrequests, 0);
+	atomic_long_set(&nfsi->redirtied_pages, 0);
 	INIT_LIST_HEAD(&nfsi->commit_info.list);
 	atomic_long_set(&nfsi->commit_info.ncommit, 0);
 	atomic_set(&nfsi->commit_info.rpcs_out, 0);
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1419,10 +1419,12 @@ static void nfs_initiate_write(struct nf
  */
 static void nfs_redirty_request(struct nfs_page *req)
 {
+	struct nfs_inode *nfsi = NFS_I(page_file_mapping(req->wb_page)->host);
+
 	/* Bump the transmission count */
 	req->wb_nio++;
 	nfs_mark_request_dirty(req);
-	set_bit(NFS_CONTEXT_RESEND_WRITES, &nfs_req_openctx(req)->flags);
+	atomic_long_inc(&nfsi->redirtied_pages);
 	nfs_end_page_writeback(req);
 	nfs_release_request(req);
 }
@@ -1892,7 +1894,7 @@ static void nfs_commit_release_pages(str
 		/* We have a mismatch. Write the page again */
 		dprintk_cont(" mismatch\n");
 		nfs_mark_request_dirty(req);
-		set_bit(NFS_CONTEXT_RESEND_WRITES, &nfs_req_openctx(req)->flags);
+		atomic_long_inc(&NFS_I(data->inode)->redirtied_pages);
 	next:
 		nfs_unlock_and_release_request(req);
 		/* Latency breaker */
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -182,6 +182,7 @@ struct nfs_inode {
 		/* Regular file */
 		struct {
 			atomic_long_t	nrequests;
+			atomic_long_t	redirtied_pages;
 			struct nfs_mds_commit_info commit_info;
 			struct mutex	commit_mutex;
 		};


