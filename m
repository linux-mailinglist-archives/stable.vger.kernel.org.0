Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C564FD250
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243546AbiDLHJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351326AbiDLHDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:03:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9219143AC6;
        Mon, 11 Apr 2022 23:47:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AF3DB81B4D;
        Tue, 12 Apr 2022 06:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988F6C385A1;
        Tue, 12 Apr 2022 06:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746022;
        bh=WsGVm2ifufobQw4sI2QEzE15gWhPGQlXBw2iENliwjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HekywgdYkw0tKz7X2yvNYWjFaY0PqErf6QJoBTEKx7JIfgfi7YPlROLxaQdoUgBut
         maXaBzYNbZFvNvFD8nv8oHNJVYKyPgcbtXkatKcjTk33DDUJzu+/iXnPFqGylR0+Rb
         ufvjC8owC8whqej7aRepQtaP+e13xWY8wagLAqZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/277] NFS: swap-out must always use STABLE writes.
Date:   Tue, 12 Apr 2022 08:28:54 +0200
Message-Id: <20220412062945.829306431@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit c265de257f558a05c1859ee9e3fed04883b9ec0e ]

The commit handling code is not safe against memory-pressure deadlocks
when writing to swap.  In particular, nfs_commitdata_alloc() blocks
indefinitely waiting for memory, and this can consume all available
workqueue threads.

swap-out most likely uses STABLE writes anyway as COND_STABLE indicates
that a stable write should be used if the write fits in a single
request, and it normally does.  However if we ever swap with a small
wsize, or gather unusually large numbers of pages for a single write,
this might change.

For safety, make it explicit in the code that direct writes used for swap
must always use FLUSH_STABLE.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 28afc315ec0c..c220810c61d1 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -793,7 +793,7 @@ static const struct nfs_pgio_completion_ops nfs_direct_write_completion_ops = {
  */
 static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 					       struct iov_iter *iter,
-					       loff_t pos)
+					       loff_t pos, int ioflags)
 {
 	struct nfs_pageio_descriptor desc;
 	struct inode *inode = dreq->inode;
@@ -801,7 +801,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 	size_t requested_bytes = 0;
 	size_t wsize = max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
 
-	nfs_pageio_init_write(&desc, inode, FLUSH_COND_STABLE, false,
+	nfs_pageio_init_write(&desc, inode, ioflags, false,
 			      &nfs_direct_write_completion_ops);
 	desc.pg_dreq = dreq;
 	get_dreq(dreq);
@@ -947,11 +947,13 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter,
 	pnfs_init_ds_commit_info_ops(&dreq->ds_cinfo, inode);
 
 	if (swap) {
-		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos);
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
+							    FLUSH_STABLE);
 	} else {
 		nfs_start_io_direct(inode);
 
-		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos);
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
+							    FLUSH_COND_STABLE);
 
 		if (mapping->nrpages) {
 			invalidate_inode_pages2_range(mapping,
-- 
2.35.1



