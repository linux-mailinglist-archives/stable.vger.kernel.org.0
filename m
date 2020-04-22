Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DB51B3EC9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgDVKZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbgDVKZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:25:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6C120784;
        Wed, 22 Apr 2020 10:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551148;
        bh=Zvt64snqt3uHyzChEK/2HaoW1LghaS7BJDekteEpWdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLYzZLV666dzGuuILqPgeF34bo5NFeC3SuySc7Z0oaZgCWD8mNrqmednvpMjL5rtt
         GeGXHXvKcDSJ8y9WZB5J8Te0FgpDZt7Hu9e0WBCadQhWN0tC7+s96+6lFJ7CWGwYA8
         ZNWv1k2q6jDGO+S060+YQpaxx51zKHxeS9bVrJRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 113/166] NFS: Fix memory leaks in nfs_pageio_stop_mirroring()
Date:   Wed, 22 Apr 2020 11:57:20 +0200
Message-Id: <20200422095100.853959379@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 862f35c94730c9270833f3ad05bd758a29f204ed ]

If we just set the mirror count to 1 without first clearing out
the mirrors, we can leak queued up requests.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pagelist.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 8b7c525dbbf7c..b736912098eee 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -886,15 +886,6 @@ static void nfs_pageio_setup_mirroring(struct nfs_pageio_descriptor *pgio,
 	pgio->pg_mirror_count = mirror_count;
 }
 
-/*
- * nfs_pageio_stop_mirroring - stop using mirroring (set mirror count to 1)
- */
-void nfs_pageio_stop_mirroring(struct nfs_pageio_descriptor *pgio)
-{
-	pgio->pg_mirror_count = 1;
-	pgio->pg_mirror_idx = 0;
-}
-
 static void nfs_pageio_cleanup_mirroring(struct nfs_pageio_descriptor *pgio)
 {
 	pgio->pg_mirror_count = 1;
@@ -1320,6 +1311,14 @@ void nfs_pageio_cond_complete(struct nfs_pageio_descriptor *desc, pgoff_t index)
 	}
 }
 
+/*
+ * nfs_pageio_stop_mirroring - stop using mirroring (set mirror count to 1)
+ */
+void nfs_pageio_stop_mirroring(struct nfs_pageio_descriptor *pgio)
+{
+	nfs_pageio_complete(pgio);
+}
+
 int __init nfs_init_nfspagecache(void)
 {
 	nfs_page_cachep = kmem_cache_create("nfs_page",
-- 
2.20.1



