Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD3E3CE5AA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245671AbhGSPwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245373AbhGSPq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C3156143E;
        Mon, 19 Jul 2021 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712027;
        bh=qAOrF9B0QCnF2sSl9P3Z0vFbu1w7HEbgskEF8O8ND3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5prX5bhPz0lPscz1eQpS5A0YwdXZnAUn58ekt7OwZluqq2moQcg8oiNwQycCvMuc
         EC0Tt/w5+i8PZsFeb4fcD8rfGRogNGcO6DC+aKw2AbtLV4Jot2jGStOiw4fer2pSHj
         2Ig8wCfc45hKjm/RSpXXqbmM2JVsLQIeRnq5Gkao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 221/292] NFSv4/pNFS: Dont call _nfs4_pnfs_v3_ds_connect multiple times
Date:   Mon, 19 Jul 2021 16:54:43 +0200
Message-Id: <20210719144950.243350238@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit f46f84931a0aa344678efe412d4b071d84d8a805 ]

After we grab the lock in nfs4_pnfs_ds_connect(), there is no check for
whether or not ds->ds_clp has already been initialised, so we can end up
adding the same transports multiple times.

Fixes: fc821d59209d ("pnfs/NFSv4.1: Add multipath capabilities to pNFS flexfiles servers over NFSv3")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs_nfs.c | 52 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 49d3389bd813..1c2c0d08614e 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -805,19 +805,16 @@ out:
 }
 EXPORT_SYMBOL_GPL(nfs4_pnfs_ds_add);
 
-static void nfs4_wait_ds_connect(struct nfs4_pnfs_ds *ds)
+static int nfs4_wait_ds_connect(struct nfs4_pnfs_ds *ds)
 {
 	might_sleep();
-	wait_on_bit(&ds->ds_state, NFS4DS_CONNECTING,
-			TASK_KILLABLE);
+	return wait_on_bit(&ds->ds_state, NFS4DS_CONNECTING, TASK_KILLABLE);
 }
 
 static void nfs4_clear_ds_conn_bit(struct nfs4_pnfs_ds *ds)
 {
 	smp_mb__before_atomic();
-	clear_bit(NFS4DS_CONNECTING, &ds->ds_state);
-	smp_mb__after_atomic();
-	wake_up_bit(&ds->ds_state, NFS4DS_CONNECTING);
+	clear_and_wake_up_bit(NFS4DS_CONNECTING, &ds->ds_state);
 }
 
 static struct nfs_client *(*get_v3_ds_connect)(
@@ -993,30 +990,33 @@ int nfs4_pnfs_ds_connect(struct nfs_server *mds_srv, struct nfs4_pnfs_ds *ds,
 {
 	int err;
 
-again:
-	err = 0;
-	if (test_and_set_bit(NFS4DS_CONNECTING, &ds->ds_state) == 0) {
-		if (version == 3) {
-			err = _nfs4_pnfs_v3_ds_connect(mds_srv, ds, timeo,
-						       retrans);
-		} else if (version == 4) {
-			err = _nfs4_pnfs_v4_ds_connect(mds_srv, ds, timeo,
-						       retrans, minor_version);
-		} else {
-			dprintk("%s: unsupported DS version %d\n", __func__,
-				version);
-			err = -EPROTONOSUPPORT;
-		}
+	do {
+		err = nfs4_wait_ds_connect(ds);
+		if (err || ds->ds_clp)
+			goto out;
+		if (nfs4_test_deviceid_unavailable(devid))
+			return -ENODEV;
+	} while (test_and_set_bit(NFS4DS_CONNECTING, &ds->ds_state) != 0);
 
-		nfs4_clear_ds_conn_bit(ds);
-	} else {
-		nfs4_wait_ds_connect(ds);
+	if (ds->ds_clp)
+		goto connect_done;
 
-		/* what was waited on didn't connect AND didn't mark unavail */
-		if (!ds->ds_clp && !nfs4_test_deviceid_unavailable(devid))
-			goto again;
+	switch (version) {
+	case 3:
+		err = _nfs4_pnfs_v3_ds_connect(mds_srv, ds, timeo, retrans);
+		break;
+	case 4:
+		err = _nfs4_pnfs_v4_ds_connect(mds_srv, ds, timeo, retrans,
+					       minor_version);
+		break;
+	default:
+		dprintk("%s: unsupported DS version %d\n", __func__, version);
+		err = -EPROTONOSUPPORT;
 	}
 
+connect_done:
+	nfs4_clear_ds_conn_bit(ds);
+out:
 	/*
 	 * At this point the ds->ds_clp should be ready, but it might have
 	 * hit an error.
-- 
2.30.2



