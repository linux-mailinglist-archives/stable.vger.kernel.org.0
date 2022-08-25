Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2655A0E46
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbiHYKqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241409AbiHYKqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F839C1D4
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 03:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D8AA6193C
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 10:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157DBC433D6;
        Thu, 25 Aug 2022 10:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661424357;
        bh=B4RWSf7YU6tiJKQrimKf/Zu57aA1TItt9t8YRqX3ICU=;
        h=Subject:To:Cc:From:Date:From;
        b=pMwPAIlofVrK2aYTekFU65cSVnUt3azoBvdqkkmdmGz7zUVurpzHOeBR9Tmj5dApz
         w9eDUGfB0ALfyXEQkWJAqFsubPBFzAofT3ynWhF0vZkIcSeBa+zWmXiai2A6xycK78
         zvxoeyiLGINYp81SjkvQJ9LN1N2OxA1hJvM4WGgU=
Subject: FAILED: patch "[PATCH] NFS: Fix another fsync() issue after a server reboot" failed to apply to 5.15-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Aug 2022 12:45:54 +0200
Message-ID: <1661424354236133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 67f4b5dc49913abcdb5cc736e73674e2f352f81d Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Sat, 13 Aug 2022 08:22:25 -0400
Subject: [PATCH] NFS: Fix another fsync() issue after a server reboot

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

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 54237a231687..749e5487df50 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -221,8 +221,10 @@ nfs_file_fsync_commit(struct file *file, int datasync)
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
@@ -237,15 +239,10 @@ nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
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
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index b4e46b0ffa2d..bea7c005119c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -426,6 +426,7 @@ nfs_ilookup(struct super_block *sb, struct nfs_fattr *fattr, struct nfs_fh *fh)
 static void nfs_inode_init_regular(struct nfs_inode *nfsi)
 {
 	atomic_long_set(&nfsi->nrequests, 0);
+	atomic_long_set(&nfsi->redirtied_pages, 0);
 	INIT_LIST_HEAD(&nfsi->commit_info.list);
 	atomic_long_set(&nfsi->commit_info.ncommit, 0);
 	atomic_set(&nfsi->commit_info.rpcs_out, 0);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 4a3796811b4b..989c734cf91d 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1420,10 +1420,12 @@ static void nfs_initiate_write(struct nfs_pgio_header *hdr,
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
@@ -1904,7 +1906,7 @@ static void nfs_commit_release_pages(struct nfs_commit_data *data)
 		/* We have a mismatch. Write the page again */
 		dprintk_cont(" mismatch\n");
 		nfs_mark_request_dirty(req);
-		set_bit(NFS_CONTEXT_RESEND_WRITES, &nfs_req_openctx(req)->flags);
+		atomic_long_inc(&NFS_I(data->inode)->redirtied_pages);
 	next:
 		nfs_unlock_and_release_request(req);
 		/* Latency breaker */
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index b32ed68e7dc4..f08e581f0161 100644
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

