Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA3A45C08F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345292AbhKXNJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347428AbhKXNHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A91960F12;
        Wed, 24 Nov 2021 12:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757537;
        bh=ljPT7A1YN/mMAkgWgGEM2AOMbks2PZMKUWAiKnuxAW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUuIF8fDTu5fGoEhoqj4ExtcSl1rVVU5/N+v3LSrFJ6xeRG/q92DbE8O9pwsoG7Rg
         isxHw8sq22AK8u/zX2idBWaF9KcxS9bOkoHtBa61HQGt0CnGCefImjTkCxTo8aVJc7
         o3ECumFlzF9kI97s5JRp4REaDWjrVcTIv15mv/5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/323] pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds
Date:   Wed, 24 Nov 2021 12:56:32 +0100
Message-Id: <20211124115725.762384193@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 8da239b6cc16f..f1f0519f1ecef 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -429,10 +429,10 @@ nfs4_ff_layout_prepare_ds(struct pnfs_layout_segment *lseg, u32 ds_idx,
 		goto out_fail;
 
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
index 3f0c2436254ac..bd6190d794c49 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -635,7 +635,7 @@ static int _nfs4_pnfs_v3_ds_connect(struct nfs_server *mds_srv,
 	}
 
 	smp_wmb();
-	ds->ds_clp = clp;
+	WRITE_ONCE(ds->ds_clp, clp);
 	dprintk("%s [new] addr: %s\n", __func__, ds->ds_remotestr);
 out:
 	return status;
@@ -708,7 +708,7 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 	}
 
 	smp_wmb();
-	ds->ds_clp = clp;
+	WRITE_ONCE(ds->ds_clp, clp);
 	dprintk("%s [new] addr: %s\n", __func__, ds->ds_remotestr);
 out:
 	return status;
-- 
2.33.0



