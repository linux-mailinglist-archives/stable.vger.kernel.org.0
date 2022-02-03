Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D3D4A8DF8
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbiBCUeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:34:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354778AbiBCUc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:32:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BCE161A5C;
        Thu,  3 Feb 2022 20:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3993C36AE5;
        Thu,  3 Feb 2022 20:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920377;
        bh=C8dHEA5Be/M4HwoHN9qOTlysc8sgv88UKMWgUlc+Z6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKWJvKwKHaaOL1XzcvKFr/y/whEtw9PIJuMaTOfDS2RpfIy9L986eTcV4OwdwRnR1
         4tMSPtoODYqzR9hWGwV2rKv/U7LfwQXeZNzIoM0iwhvnhBLJnG8ePRe131dxbsC1Ih
         5jwFKO9p/tlO5GU1l5NfYYdENi+TVTvGANzU7JY9pdQ28RFjy9lqgaIObndufrYdkb
         d63Uz+5h9UY19cKrYgREJNnpeP/ibQal2tnw92FXxx7XJP71Z0XXfVlPWQxKO76xvR
         fxYRnOn9WoSslKb59OOcPBuIPdHnRxpM9d6JNEAaAPKun9KLXFzpnbpfjrhNgzum5j
         1NQlo296LiVKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/41] NFSv4 store server support for fs_location attribute
Date:   Thu,  3 Feb 2022 15:32:11 -0500
Message-Id: <20220203203245.3007-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 8a59bb93b7e3cca389af44781a429ac12ac49be6 ]

Define and store if server returns it supports fs_locations attribute
as a capability.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c         | 2 ++
 include/linux/nfs_fs_sb.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 443eab71c9a9e..367a1b99b7550 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3894,6 +3894,8 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 		if (res.attr_bitmask[2] & FATTR4_WORD2_SECURITY_LABEL)
 			server->caps |= NFS_CAP_SECURITY_LABEL;
 #endif
+		if (res.attr_bitmask[0] & FATTR4_WORD0_FS_LOCATIONS)
+			server->caps |= NFS_CAP_FS_LOCATIONS;
 		if (!(res.attr_bitmask[0] & FATTR4_WORD0_FILEID))
 			server->fattr_valid &= ~NFS_ATTR_FATTR_FILEID;
 		if (!(res.attr_bitmask[1] & FATTR4_WORD1_MODE))
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 2a9acbfe00f0f..9a6e70ccde56e 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -287,5 +287,5 @@ struct nfs_server {
 #define NFS_CAP_COPY_NOTIFY	(1U << 27)
 #define NFS_CAP_XATTR		(1U << 28)
 #define NFS_CAP_READ_PLUS	(1U << 29)
-
+#define NFS_CAP_FS_LOCATIONS	(1U << 30)
 #endif
-- 
2.34.1

