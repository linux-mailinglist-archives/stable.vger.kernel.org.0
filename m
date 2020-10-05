Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C37283A48
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgJEPdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgJEPdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42272074F;
        Mon,  5 Oct 2020 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911981;
        bh=x764alEhEO1Asq4Qrf+goutq6CwlR1s9JC8/Bkn4Wj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG+XhRS+1Vw5CPitwjieJFdvfOzUXUJsqXoGXOQXutKKFRXbrH5m7MDRQjvzR7iim
         B1sDPTtk55mfwOgx04tLNMr0goM9FQiVSmbUg1j+JCVXJEu3mc2V5Ft90m2aD1Tr33
         LUpKP2KidabBhFBJ6K5ZeTzfFKidoi0IjHp4liBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 55/85] pNFS/flexfiles: Ensure we initialise the mirror bsizes correctly on read
Date:   Mon,  5 Oct 2020 17:26:51 +0200
Message-Id: <20201005142117.377710196@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ee15c7b53e52fb04583f734461244c4dcca828fa ]

While it is true that reading from an unmirrored source always uses
index 0, that is no longer true for mirrored sources when we fail over.

Fixes: 563c53e73b8b ("NFS: Fix flexfiles read failover")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 048272d60a165..f9348ed1bcdad 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -838,6 +838,7 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 	struct nfs4_ff_layout_mirror *mirror;
 	struct nfs4_pnfs_ds *ds;
 	int ds_idx;
+	u32 i;
 
 retry:
 	ff_layout_pg_check_layout(pgio, req);
@@ -864,14 +865,14 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 		goto retry;
 	}
 
-	mirror = FF_LAYOUT_COMP(pgio->pg_lseg, ds_idx);
+	for (i = 0; i < pgio->pg_mirror_count; i++) {
+		mirror = FF_LAYOUT_COMP(pgio->pg_lseg, i);
+		pgm = &pgio->pg_mirrors[i];
+		pgm->pg_bsize = mirror->mirror_ds->ds_versions[0].rsize;
+	}
 
 	pgio->pg_mirror_idx = ds_idx;
 
-	/* read always uses only one mirror - idx 0 for pgio layer */
-	pgm = &pgio->pg_mirrors[0];
-	pgm->pg_bsize = mirror->mirror_ds->ds_versions[0].rsize;
-
 	if (NFS_SERVER(pgio->pg_inode)->flags &
 			(NFS_MOUNT_SOFT|NFS_MOUNT_SOFTERR))
 		pgio->pg_maxretrans = io_maxretrans;
-- 
2.25.1



