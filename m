Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB9A4A8F0F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345985AbiBCUmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356033AbiBCUk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:40:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5835FC061160;
        Thu,  3 Feb 2022 12:36:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC5C360C5F;
        Thu,  3 Feb 2022 20:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AB7C340E8;
        Thu,  3 Feb 2022 20:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920618;
        bh=b8fL2XaRMWu5qFtd651cHRo05HAtGXpuzwwU+BnIfXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTzQdVdOfJk79q5Qq8zeT7kIox26Kr9+PXxb2UIHpW1krJI2eQEsO+ZuxatUvpH7H
         UvvA/PNQFSILVvjF2I8AV2yAQOiQBMfKyHjc2x+W7j8/1nnWoxwutBRNfKSJT2Tzo0
         WLtnvH1OLO4zpPoTz/ufI/h3e71E2f7xwLDkTZ8ueKFzc5D0B3cVh01wmRVhKBarUA
         MMEveJuRFrThRDjLlVDxxRdvJVZynYAClcqV7ZHhjXUiCDgoTm2zjoQ8tkLUovSS4e
         bYh47aflOIPNYAYgVm81J1DFGd8oCwwW5y+AK04ES8U+lamgiz7KVKJlgmZHE4AOOY
         M222zDteVzH+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/7] NFSv4 remove zero number of fs_locations entries error check
Date:   Thu,  3 Feb 2022 15:36:48 -0500
Message-Id: <20220203203651.5158-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203651.5158-1-sashal@kernel.org>
References: <20220203203651.5158-1-sashal@kernel.org>
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
index 4e63daeef6339..466c07bd06295 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1985,6 +1985,9 @@ static int nfs4_try_migration(struct nfs_server *server, struct rpc_cred *cred)
 	}
 
 	result = -NFS4ERR_NXIO;
+	if (!locations->nlocations)
+		goto out;
+
 	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 29dbb14b6fd11..b50c97c6aecb3 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3633,8 +3633,6 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
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

