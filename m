Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1279BB8737
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404996AbfISWI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393502AbfISWI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:08:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8994821927;
        Thu, 19 Sep 2019 22:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930937;
        bh=Au2opSr7JKBzP5lhHQCa+HofEwWR2Wj4MUH/7+LDhsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+3Hw9Gl1RbtjkEqbJE12t8jEM2k+NVxbov4cEJS3m2tmBM2ob+Hr1tD8NFNDGDtp
         z3I02KX7UOqZK7NWAPwzTA4QuTUhK9m/QSSEmkjfd/AJwDfv6hKkXm7uCAGrRpabEU
         PdV3aPSAAjV24X69GEepqM7583Z4dkJ3WcUeXKsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 067/124] pNFS/flexfiles: Dont time out requests on hard mounts
Date:   Fri, 20 Sep 2019 00:02:35 +0200
Message-Id: <20190919214821.437000252@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c67cdbb36ce7c..38d9158142219 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/nfs_fs.h>
+#include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/module.h>
 #include <linux/sched/mm.h>
@@ -928,7 +929,9 @@ retry:
 	pgm = &pgio->pg_mirrors[0];
 	pgm->pg_bsize = mirror->mirror_ds->ds_versions[0].rsize;
 
-	pgio->pg_maxretrans = io_maxretrans;
+	if (NFS_SERVER(pgio->pg_inode)->flags &
+			(NFS_MOUNT_SOFT|NFS_MOUNT_SOFTERR))
+		pgio->pg_maxretrans = io_maxretrans;
 	return;
 out_nolseg:
 	if (pgio->pg_error < 0)
@@ -936,6 +939,7 @@ out_nolseg:
 out_mds:
 	pnfs_put_lseg(pgio->pg_lseg);
 	pgio->pg_lseg = NULL;
+	pgio->pg_maxretrans = 0;
 	nfs_pageio_reset_read_mds(pgio);
 }
 
@@ -996,12 +1000,15 @@ retry:
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



