Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335804A8EC1
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354837AbiBCUip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42946 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiBCUgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:36:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFCD260A6B;
        Thu,  3 Feb 2022 20:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B89C36AE2;
        Thu,  3 Feb 2022 20:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920602;
        bh=HvOdQTY9G06pOPmVVUWFW37MhjqeFcqZr++os+rIBhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzXSGOP/n7dO4ND4PSD8Si/R4qcE3Un7VhzTsABuYqkhh44CNHKmXR2P49TiNNfac
         M2J6KrqQ+koNmtJNcNbR/NdUYIZrmzqKB1kYSnLqZr6AwofosuTnQNklR7BiBLXrzk
         3KRPYG3TjrAXVRcNrMvOMJsSvhuIM7dzo5rogAyBdnNjR59VMqvj2TJ+Yb68BhVgST
         xfiN0OKdokYGBJYMwt1c/7+Mr92j+PUFJltOmwC7BUNFKLISixsGo7tKZTjsVtVtxw
         VbLnSv86bq8+ygud76R5nepKBskvWMSOAy/eXOQSKsNhIdrbkDx9x/u7UwI1UZLyKo
         sBHovVBqC52Mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/9] NFSv4 remove zero number of fs_locations entries error check
Date:   Thu,  3 Feb 2022 15:36:29 -0500
Message-Id: <20220203203633.4685-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203633.4685-1-sashal@kernel.org>
References: <20220203203633.4685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 90e12a3191040bd3854d3e236c35921e4e92a044 ]

Remove the check for the zero length fs_locations reply in the
xdr decoding, and instead check for that in the migration code.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 3 +++
 fs/nfs/nfs4xdr.c   | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index f92bfc787c5fe..c0987557d4ab4 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2003,6 +2003,9 @@ static int nfs4_try_migration(struct nfs_server *server, struct rpc_cred *cred)
 	}
 
 	result = -NFS4ERR_NXIO;
+	if (!locations->nlocations)
+		goto out;
+
 	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 99facb5f186fd..ccdc0ca699c39 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3731,8 +3731,6 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
 	if (unlikely(!p))
 		goto out_overflow;
 	n = be32_to_cpup(p);
-	if (n <= 0)
-		goto out_eio;
 	for (res->nlocations = 0; res->nlocations < n; res->nlocations++) {
 		u32 m;
 		struct nfs4_fs_location *loc;
-- 
2.34.1

