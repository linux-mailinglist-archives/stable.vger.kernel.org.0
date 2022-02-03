Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7655D4A8D4D
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354128AbiBCUaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354098AbiBCUaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663C3C061741;
        Thu,  3 Feb 2022 12:30:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AF8EB835A1;
        Thu,  3 Feb 2022 20:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC506C340E8;
        Thu,  3 Feb 2022 20:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920198;
        bh=YM/MiN94tclE5DakqWiee+fJMcKbPpmVpnWIdmn1l24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIk7BFz/1qG9sFMTrLcuE5Mg5yhan9Weg1NbW6sCguT1R4bH9eYxJi6x6qfj6lZJZ
         fP1IHgpRyE5gj4segN2HMv6QNGgOE+bvuiNFs4Ca5BJiBZC0WPwur7JiCKXmB6GtsU
         eKP/UVPY39fvsa9fCaWNFLtS81oBqJfjv/ADM8VLtSG/zFmH+NKdWCtrOfcOQWILWR
         1sPHcyiO47iphcmC6ipLdg/Te/WdXg8Hu1pYKKZIYp50Lm4i10HOvbVwlZI46trbNi
         cgqcQ38jAg92sUHo3SJ4feyIR5r67cuV6zp7IReCQRx+66OIrp+835m6JNKPF04gLA
         yF9tQXWWWio4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 07/52] NFSv4 store server support for fs_location attribute
Date:   Thu,  3 Feb 2022 15:29:01 -0500
Message-Id: <20220203202947.2304-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 322ff45ad15ca..f924d3029d13b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3874,6 +3874,8 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
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

