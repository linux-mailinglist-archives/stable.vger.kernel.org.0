Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA521451EF0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347504AbhKPAiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344603AbhKOTZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBB9D6334E;
        Mon, 15 Nov 2021 19:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002839;
        bh=0nOwMQFJRgEAUbxfVWG2dLD0o5ex6i7sgnN4t/saQ24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tisEuXRhqoQ5r/ti9ey1Ie3aHi6vCcTAyFLLps5C8hF/I+T50y0E8jcyEswe+7NNk
         nJTt7jyPdmBtQV2HQcAeQqr4m1rygpvp35KN2bSNco8tshSejPWLiJsiW1/xWF1dgD
         LJ+JROSwgm861u9uCBno0oLfanLqOqP0oRCz4PGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 716/917] NFS: Fix deadlocks in nfs_scan_commit_list()
Date:   Mon, 15 Nov 2021 18:03:31 +0100
Message-Id: <20211115165453.178948190@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 64a93dbf25d3a1368bb58ddf0f61d0a92d7479e3 ]

Partially revert commit 2ce209c42c01 ("NFS: Wait for requests that are
locked on the commit list"), since it can lead to deadlocks between
commit requests and nfs_join_page_group().
For now we should assume that any locked requests on the commit list are
either about to be removed and committed by another task, or the writes
they describe are about to be retransmitted. In either case, we should
not need to worry.

Fixes: 2ce209c42c01 ("NFS: Wait for requests that are locked on the commit list")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index eae9bf1140417..735a054747752 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1038,25 +1038,11 @@ nfs_scan_commit_list(struct list_head *src, struct list_head *dst,
 	struct nfs_page *req, *tmp;
 	int ret = 0;
 
-restart:
 	list_for_each_entry_safe(req, tmp, src, wb_list) {
 		kref_get(&req->wb_kref);
 		if (!nfs_lock_request(req)) {
-			int status;
-
-			/* Prevent deadlock with nfs_lock_and_join_requests */
-			if (!list_empty(dst)) {
-				nfs_release_request(req);
-				continue;
-			}
-			/* Ensure we make progress to prevent livelock */
-			mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
-			status = nfs_wait_on_request(req);
 			nfs_release_request(req);
-			mutex_lock(&NFS_I(cinfo->inode)->commit_mutex);
-			if (status < 0)
-				break;
-			goto restart;
+			continue;
 		}
 		nfs_request_remove_commit_list(req, cinfo);
 		clear_bit(PG_COMMIT_TO_DS, &req->wb_flags);
@@ -1936,6 +1922,7 @@ static int __nfs_commit_inode(struct inode *inode, int how,
 	int may_wait = how & FLUSH_SYNC;
 	int ret, nscan;
 
+	how &= ~FLUSH_SYNC;
 	nfs_init_cinfo_from_inode(&cinfo, inode);
 	nfs_commit_begin(cinfo.mds);
 	for (;;) {
-- 
2.33.0



