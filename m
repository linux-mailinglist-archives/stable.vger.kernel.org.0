Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D282AA8A47
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbfIDP6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbfIDP6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 599FE22CF7;
        Wed,  4 Sep 2019 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612731;
        bh=d5uaYS9gM3soHszTjTVFuR9hBYYxU5cMWBxXdZnzURQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC0E/pTygzPdnM5KTooOdg/7kVVAJpxavFZWzrMgrBV3NrsSKUBHXKSSTU7WHX3Bu
         UAWFdiKDoijDBByIFsVGG8eGxMRltqZpva5mN18FmacGbbI4DU4deE74ERy5wYklX3
         22y500/YVV3sYF9hiPyVtQcMmxMbLD8IgWpWaZCo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 47/94] pNFS/flexfiles: Don't time out requests on hard mounts
Date:   Wed,  4 Sep 2019 11:56:52 -0400
Message-Id: <20190904155739.2816-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 7af46292dadcf8870946916f79fdddf79bd7267f ]

If the mount is hard, we should ignore the 'io_maxretrans' module
parameter so that we always keep retrying.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index bcff3bf5ae09e..e7d365ccc258b 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/nfs_fs.h>
+#include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/module.h>
 #include <linux/sched/mm.h>
@@ -928,7 +929,9 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 	pgm = &pgio->pg_mirrors[0];
 	pgm->pg_bsize = mirror->mirror_ds->ds_versions[0].rsize;
 
-	pgio->pg_maxretrans = io_maxretrans;
+	if (NFS_SERVER(pgio->pg_inode)->flags &
+			(NFS_MOUNT_SOFT|NFS_MOUNT_SOFTERR))
+		pgio->pg_maxretrans = io_maxretrans;
 	return;
 out_nolseg:
 	if (pgio->pg_error < 0)
@@ -936,6 +939,7 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 out_mds:
 	pnfs_put_lseg(pgio->pg_lseg);
 	pgio->pg_lseg = NULL;
+	pgio->pg_maxretrans = 0;
 	nfs_pageio_reset_read_mds(pgio);
 }
 
@@ -996,12 +1000,15 @@ ff_layout_pg_init_write(struct nfs_pageio_descriptor *pgio,
 		pgm->pg_bsize = mirror->mirror_ds->ds_versions[0].wsize;
 	}
 
-	pgio->pg_maxretrans = io_maxretrans;
+	if (NFS_SERVER(pgio->pg_inode)->flags &
+			(NFS_MOUNT_SOFT|NFS_MOUNT_SOFTERR))
+		pgio->pg_maxretrans = io_maxretrans;
 	return;
 
 out_mds:
 	pnfs_put_lseg(pgio->pg_lseg);
 	pgio->pg_lseg = NULL;
+	pgio->pg_maxretrans = 0;
 	nfs_pageio_reset_write_mds(pgio);
 }
 
-- 
2.20.1

