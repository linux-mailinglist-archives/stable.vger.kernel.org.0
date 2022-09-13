Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C18B5B70E5
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiIMOd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiIMOct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:32:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BF236DE0;
        Tue, 13 Sep 2022 07:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AC5BB80FA7;
        Tue, 13 Sep 2022 14:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2581C433C1;
        Tue, 13 Sep 2022 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078756;
        bh=30co+0g9tvrzIWB1JDTXNeJSJcGGRVr+u4DdiwaS87I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITkbsersK/bbNtbaPomM5ZvNpZ0jcvKRKW8q2wubpuKoxFO+gXiQWjfGXzJUgyyOS
         rEpwB20+pcOeQi7XAIMmRGUgJTUvJkvike+IeoaekYjJTGNVGYJRHu0rOo8ckMZLkp
         THbFfJHGXDAJhWDsdJmpHP9Vt9knRr80Po48wAbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/121] NFS: Fix another fsync() issue after a server reboot
Date:   Tue, 13 Sep 2022 16:03:56 +0200
Message-Id: <20220913140359.301552710@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

[ Upstream commit 67f4b5dc49913abcdb5cc736e73674e2f352f81d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c          | 15 ++++++---------
 fs/nfs/inode.c         |  1 +
 fs/nfs/write.c         |  6 ++++--
 include/linux/nfs_fs.h |  1 +
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index a8693cc50c7ca..ad5114e480097 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -223,8 +223,10 @@ nfs_file_fsync_commit(struct file *file, int datasync)
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
@@ -239,15 +241,10 @@ nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
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
index dc057ab6b30d1..e4524635a129a 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -434,6 +434,7 @@ nfs_ilookup(struct super_block *sb, struct nfs_fattr *fattr, struct nfs_fh *fh)
 static void nfs_inode_init_regular(struct nfs_inode *nfsi)
 {
 	atomic_long_set(&nfsi->nrequests, 0);
+	atomic_long_set(&nfsi->redirtied_pages, 0);
 	INIT_LIST_HEAD(&nfsi->commit_info.list);
 	atomic_long_set(&nfsi->commit_info.ncommit, 0);
 	atomic_set(&nfsi->commit_info.rpcs_out, 0);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index cdb29fd235492..be70874bc3292 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1394,10 +1394,12 @@ static void nfs_initiate_write(struct nfs_pgio_header *hdr,
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
@@ -1870,7 +1872,7 @@ static void nfs_commit_release_pages(struct nfs_commit_data *data)
 		/* We have a mismatch. Write the page again */
 		dprintk_cont(" mismatch\n");
 		nfs_mark_request_dirty(req);
-		set_bit(NFS_CONTEXT_RESEND_WRITES, &nfs_req_openctx(req)->flags);
+		atomic_long_inc(&NFS_I(data->inode)->redirtied_pages);
 	next:
 		nfs_unlock_and_release_request(req);
 		/* Latency breaker */
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index d0855352cd6fc..71467d661fb66 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -180,6 +180,7 @@ struct nfs_inode {
 		/* Regular file */
 		struct {
 			atomic_long_t	nrequests;
+			atomic_long_t	redirtied_pages;
 			struct nfs_mds_commit_info commit_info;
 			struct mutex	commit_mutex;
 		};
-- 
2.35.1



