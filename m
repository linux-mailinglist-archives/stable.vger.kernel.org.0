Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9594920D31E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgF2Sz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbgF2SzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E004C2557B;
        Mon, 29 Jun 2020 15:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446143;
        bh=W7dePd+T49+WAymBopoABgrFM9QYfpKGFqbzFrsmvHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghM3z++gklN2GUqdutSN5q2oH8kJc/cV10rA05TUdDb9QpFGrwLuOOdJCtY/fb4dB
         /d42VKmrcnIAqzjplOrH4QNT7MIM8thXd3F6ErTC3zsF2D3HC9O7NTj63TfqRcpZg2
         l1tY2JNU3gE8ehpoq50OdSal5hwoTSphktB0/LPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 131/135] pNFS/flexfiles: Fix list corruption if the mirror count changes
Date:   Mon, 29 Jun 2020 11:53:05 -0400
Message-Id: <20200629155309.2495516-132-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 8b04013737341442ed914b336cde866b902664ae upstream.

If the mirror count changes in the new layout we pick up inside
ff_layout_pg_init_write(), then we can end up adding the
request to the wrong mirror and corrupting the mirror->pg_list.

Fixes: d600ad1f2bdb ("NFS41: pop some layoutget errors to application")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 6506775575aa6..17771e157e929 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -855,9 +855,8 @@ ff_layout_pg_init_write(struct nfs_pageio_descriptor *pgio,
 		goto out_mds;
 
 	/* Use a direct mapping of ds_idx to pgio mirror_idx */
-	if (WARN_ON_ONCE(pgio->pg_mirror_count !=
-	    FF_LAYOUT_MIRROR_COUNT(pgio->pg_lseg)))
-		goto out_mds;
+	if (pgio->pg_mirror_count != FF_LAYOUT_MIRROR_COUNT(pgio->pg_lseg))
+		goto out_eagain;
 
 	for (i = 0; i < pgio->pg_mirror_count; i++) {
 		ds = nfs4_ff_layout_prepare_ds(pgio->pg_lseg, i, true);
@@ -869,11 +868,15 @@ ff_layout_pg_init_write(struct nfs_pageio_descriptor *pgio,
 	}
 
 	return;
-
+out_eagain:
+	pnfs_generic_pg_cleanup(pgio);
+	pgio->pg_error = -EAGAIN;
+	return;
 out_mds:
 	pnfs_put_lseg(pgio->pg_lseg);
 	pgio->pg_lseg = NULL;
 	nfs_pageio_reset_write_mds(pgio);
+	pgio->pg_error = -EAGAIN;
 }
 
 static unsigned int
-- 
2.25.1

