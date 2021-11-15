Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491044525DC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbhKPB7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240525AbhKOSKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:10:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DB5632A3;
        Mon, 15 Nov 2021 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998426;
        bh=p/I+joKHAcH8HOsBkoMV0niF1B0V3BPGKAVtQlgnO2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTnBXpCZxvNx2j8LvGtvaKubAdbyTd0+kabNy46JpaNL+zI3amXXPVnbjTDAb2H/j
         pPAnlTgG4OTZz5ArYrjPQAcz/O702gRwogmb988rxDOLCRttjLZ7FXVERvSRdHgcuJ
         5PRo6U0AlR+VmDY16MrKhliKWQOdZTTrRqsKvAVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 472/575] pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds
Date:   Mon, 15 Nov 2021 18:03:17 +0100
Message-Id: <20211115165400.055141252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baptiste Lepers <baptiste.lepers@gmail.com>

[ Upstream commit a2915fa06227b056a8f9b0d79b61dca08ad5cfc6 ]

_nfs4_pnfs_v3/v4_ds_connect do
   some work
   smp_wmb
   ds->ds_clp = clp;

And nfs4_ff_layout_prepare_ds currently does
   smp_rmb
   if(ds->ds_clp)
      ...

This patch places the smp_rmb after the if. This ensures that following
reads only happen once nfs4_ff_layout_prepare_ds has checked that data
has been properly initialized.

Fixes: d67ae825a59d6 ("pnfs/flexfiles: Add the FlexFile Layout Driver")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayoutdev.c | 4 ++--
 fs/nfs/pnfs_nfs.c                         | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index 3eda40a320a53..1f12297109b41 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -378,10 +378,10 @@ nfs4_ff_layout_prepare_ds(struct pnfs_layout_segment *lseg,
 		goto noconnect;
 
 	ds = mirror->mirror_ds->ds;
+	if (READ_ONCE(ds->ds_clp))
+		goto out;
 	/* matching smp_wmb() in _nfs4_pnfs_v3/4_ds_connect */
 	smp_rmb();
-	if (ds->ds_clp)
-		goto out;
 
 	/* FIXME: For now we assume the server sent only one version of NFS
 	 * to use for the DS.
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 251c4a3aef9a6..37b52b53a7e53 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -876,7 +876,7 @@ static int _nfs4_pnfs_v3_ds_connect(struct nfs_server *mds_srv,
 	}
 
 	smp_wmb();
-	ds->ds_clp = clp;
+	WRITE_ONCE(ds->ds_clp, clp);
 	dprintk("%s [new] addr: %s\n", __func__, ds->ds_remotestr);
 out:
 	return status;
@@ -949,7 +949,7 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 	}
 
 	smp_wmb();
-	ds->ds_clp = clp;
+	WRITE_ONCE(ds->ds_clp, clp);
 	dprintk("%s [new] addr: %s\n", __func__, ds->ds_remotestr);
 out:
 	return status;
-- 
2.33.0



