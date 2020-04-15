Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77A11A9E37
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897666AbgDOLvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409450AbgDOLsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:48:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 988512137B;
        Wed, 15 Apr 2020 11:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951298;
        bh=JPbhoqeFUPHJpXc+rO/mAZalsSq5l5AOvG/Eb06Qy8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmaRB2C0Gj3jnumoF09ojCr/TS+/F/XEJynsTXdeInZCeB0ytpSGNQ8wgqV2w1aX5
         0op5pnon53nHcnLftOm+nWW+Me+n62U3RsI46JRp7KDlF5/F5mXdU2kr+qxRkBy5Y4
         jHt4mtOMmOGKG5SaK8zznUDypSBXc++c5rpNv9HI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/14] NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails
Date:   Wed, 15 Apr 2020 07:48:03 -0400
Message-Id: <20200415114814.15954-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114814.15954-1-sashal@kernel.org>
References: <20200415114814.15954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

[ Upstream commit 8605cf0e852af3b2c771c18417499dc4ceed03d5 ]

When dreq is allocated by nfs_direct_req_alloc(), dreq->kref is
initialized to 2. Therefore we need to call nfs_direct_req_release()
twice to release the allocated dreq. Usually it is called in
nfs_file_direct_{read, write}() and nfs_direct_complete().

However, current code only calls nfs_direct_req_relese() once if
nfs_get_lock_context() fails in nfs_file_direct_{read, write}().
So, that case would result in memory leak.

Fix this by adding the missing call.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 88cb8e0d60149..7789f0b9b999e 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -605,6 +605,7 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
 	l_ctx = nfs_get_lock_context(dreq->ctx);
 	if (IS_ERR(l_ctx)) {
 		result = PTR_ERR(l_ctx);
+		nfs_direct_req_release(dreq);
 		goto out_release;
 	}
 	dreq->l_ctx = l_ctx;
@@ -1015,6 +1016,7 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 	l_ctx = nfs_get_lock_context(dreq->ctx);
 	if (IS_ERR(l_ctx)) {
 		result = PTR_ERR(l_ctx);
+		nfs_direct_req_release(dreq);
 		goto out_release;
 	}
 	dreq->l_ctx = l_ctx;
-- 
2.20.1

