Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF271B3C18
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgDVKCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbgDVKC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:02:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25FB72076C;
        Wed, 22 Apr 2020 10:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549749;
        bh=UumA21lU9T2cM3PJ+RxWCkO1Rk/std/qt+SozyD2f4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xK52kKqYvFy1DpFNL1CtU/2syUX2Piezr1oxJwgh2GkHLDjxYk0iOiviV0Zy7tMjW
         AjlH2478YxwHFEmeF2Nr98llL4D7eG2VUKBA++bsJt8KSfH8R3aTpgNuh355NcAJER
         r/B9dq9Ev0zjSNzigIUvkxR/Oe3I/3I8y8SqrORA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 090/100] NFS: Fix memory leaks in nfs_pageio_stop_mirroring()
Date:   Wed, 22 Apr 2020 11:57:00 +0200
Message-Id: <20200422095039.204367531@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
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
index af1bb7353792c..f5de58c5773f6 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -886,15 +886,6 @@ static int nfs_pageio_setup_mirroring(struct nfs_pageio_descriptor *pgio,
 	return 0;
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
@@ -1287,6 +1278,14 @@ void nfs_pageio_cond_complete(struct nfs_pageio_descriptor *desc, pgoff_t index)
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



