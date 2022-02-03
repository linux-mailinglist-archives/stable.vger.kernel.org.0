Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CACE4A8EC9
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355572AbiBCUiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42100 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355489AbiBCUfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C53061B54;
        Thu,  3 Feb 2022 20:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B684BC36AE2;
        Thu,  3 Feb 2022 20:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920554;
        bh=Jb03Ld/1IlFjBDrxXqIoBlA0XES/Efs1bjalJ7s2rq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITrRiBPet7dtz9lRJaDbCoYF/rmx47xXQbcFLpsBEL1wIi8S6my+9UXFy2Ow5vk3H
         S9/nlB/7LLi31Egk7IgbBySKdf3ui2JziKnQa7Rwhqgsm3RaVuk/KODJEDf7uqYwjh
         Gz2UnWID8kKi2fNyF3Ts65bwQPAjBkiWtVb6raX5nje5XshpFjF/CCN1G8jkqK7BmG
         HFM43iRqwvFtfp83GE75RHXw02tfWhKyy7bo7KBYqd1DhAYokWR9NXwRfuSls9Mov8
         E4voWtp1S9Cf8LiCMfJikIYzJ7PPWaxyiGrhqG7DLgQ/uaAow1PAE9ufiq+KXTqK0E
         97iZnSJva2OXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/15] NFSv4 remove zero number of fs_locations entries error check
Date:   Thu,  3 Feb 2022 15:35:35 -0500
Message-Id: <20220203203545.3879-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203545.3879-1-sashal@kernel.org>
References: <20220203203545.3879-1-sashal@kernel.org>
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
index ea680f619438b..aa2caba38a014 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2070,6 +2070,9 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 	}
 
 	result = -NFS4ERR_NXIO;
+	if (!locations->nlocations)
+		goto out;
+
 	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 0fc08d22c9218..2b7741fe42ead 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3683,8 +3683,6 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
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

