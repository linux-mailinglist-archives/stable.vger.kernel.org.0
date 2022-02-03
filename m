Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC804A8ED2
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355733AbiBCUjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355013AbiBCUhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:37:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECA0C06134C;
        Thu,  3 Feb 2022 12:34:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5193261B0D;
        Thu,  3 Feb 2022 20:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA61C340EF;
        Thu,  3 Feb 2022 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920496;
        bh=zfKL74C9P9xxo2vZoT+VWgv6AeaT2EL9L1gQ53CIxTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3gmS97/FDXOXTLfHFAIkhea3OwpGHCaHQkTn0Qq2BFkEUUPgkiWljERQAV06h20f
         gXlawpcPX9iZnFHodM2ULEp72OtuL835qPsQHYGwdU/y4POobXeFgM6u1PJEJHLiXb
         lH4dRfmLFzVPIMCM2jMYek7A0+8mmm2c601vDaQ5mZsuQPA+rM8INFmHtvX3PSX7mC
         plfB6oI5KB2ZI8stFLnBt1wNIsDkUcy14v6YFUO944wsdekiXOcAFeHn9yLvAMizQG
         YDwEkWarxPyXV2aRhIgf2r0KJsaHfl5Squ4msHod+Fq2SNimDhteaiyIsxCNarzwPv
         Z/e1GBzlA+2eQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/25] NFSv4 remove zero number of fs_locations entries error check
Date:   Thu,  3 Feb 2022 15:34:27 -0500
Message-Id: <20220203203447.3570-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
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
index 4bf10792cb5b1..cbeec29e9f21a 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2104,6 +2104,9 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 	}
 
 	result = -NFS4ERR_NXIO;
+	if (!locations->nlocations)
+		goto out;
+
 	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 9f8bd45379e72..e2f0e3446e22a 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3680,8 +3680,6 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
 	if (unlikely(!p))
 		goto out_eio;
 	n = be32_to_cpup(p);
-	if (n <= 0)
-		goto out_eio;
 	for (res->nlocations = 0; res->nlocations < n; res->nlocations++) {
 		u32 m;
 		struct nfs4_fs_location *loc;
-- 
2.34.1

