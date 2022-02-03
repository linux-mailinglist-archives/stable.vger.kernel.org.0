Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0ECF4A8D49
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354061AbiBCU3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiBCU3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:29:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946C3C061714;
        Thu,  3 Feb 2022 12:29:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9AD61A6A;
        Thu,  3 Feb 2022 20:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE73C340E8;
        Thu,  3 Feb 2022 20:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920192;
        bh=S6jq1AUIQOTMbtbZ3xBIuNqN0kpzsRgOxa7dhQpOpws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhdB/kR/m/RJ2y8bgz+7WrjYcbA9zH4ETiRuUUZSxvB8M/wYrxpdWYwsG24mak/zp
         4C9PYmK6bcus0fixdvzG2g3oX9CFx0QFXY4FFsFuM2122uSWTs6F6QVinRuoZX0lG0
         cqyGHC4RExtopIBVHALzJ0lukC47vzkfJDYpb9J8rnVSlbDEnmA8s8cpCurL6Je9ua
         H5FUqFgsksfm+vEwEwx1Pg7mkJd6uzMsVHckOIsnggkN5rHHiZ+tWYzE0gYMMJVzLe
         y1VMoKUeX/PN8Sot7R+4vS3+WUj88bVz2j9oTZi1qVNXHdP2f1O4pUbGlK+a0zvkQs
         rdA09FDI/bjRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 03/52] nfs: nfs4clinet: check the return value of kstrdup()
Date:   Thu,  3 Feb 2022 15:28:57 -0500
Message-Id: <20220203202947.2304-3-sashal@kernel.org>
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

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit fbd2057e5329d3502a27491190237b6be52a1cb6 ]

kstrdup() returns NULL when some internal memory errors happen, it is
better to check the return value of it so to catch the memory error in
time.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index d8b5a250ca050..47a6cf892c95a 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1343,8 +1343,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
 	}
 	nfs_put_client(clp);
 
-	if (server->nfs_client->cl_hostname == NULL)
+	if (server->nfs_client->cl_hostname == NULL) {
 		server->nfs_client->cl_hostname = kstrdup(hostname, GFP_KERNEL);
+		if (server->nfs_client->cl_hostname == NULL)
+			return -ENOMEM;
+	}
 	nfs_server_insert_lists(server);
 
 	return nfs_probe_server(server, NFS_FH(d_inode(server->super->s_root)));
-- 
2.34.1

