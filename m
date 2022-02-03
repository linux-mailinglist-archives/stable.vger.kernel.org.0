Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369F04A8E8C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355392AbiBCUhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:37:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40104 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355399AbiBCUfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B52C61AAC;
        Thu,  3 Feb 2022 20:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09A6C340EB;
        Thu,  3 Feb 2022 20:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920549;
        bh=GaNj9zRP1mg0t39tKG5gR6mk37qVTAHecl2hF5K82hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRiOgSLvek7WuVD9QEi6iuoWqtGQBrPbfU+YRzl2R0gUYzb2fLg8n72T92Df3G0fs
         RDYVvmUKLkfxpVwXhH7ACx7fNRXQA/GvMl3FzrjeZgFJ6ggx2gVk51KtRgJCsABAkJ
         mk+6FdZQ2r15ZFkGwVJgLkiTJmswSe/RGjmENAMirNcPFrAXYS5GNXpuTBhToZgWxK
         sNpbBhX4Wt42T9KrcXRQW7tjy3m4BKqfg59LPUhlOj8Ok+cDjtWOPaMj5UXm0zK0YK
         qOus91ev7b/tSZOk5QawOwpUb+UB1l2SSoxpbgkfF3RZHhT1+OEuCivDvrNEynJbuE
         hPLkiHrhx5uPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/15] nfs: nfs4clinet: check the return value of kstrdup()
Date:   Thu,  3 Feb 2022 15:35:32 -0500
Message-Id: <20220203203545.3879-2-sashal@kernel.org>
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
index 8cace8350fa3d..3671a51fe5ebc 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1293,8 +1293,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
 	}
 	nfs_put_client(clp);
 
-	if (server->nfs_client->cl_hostname == NULL)
+	if (server->nfs_client->cl_hostname == NULL) {
 		server->nfs_client->cl_hostname = kstrdup(hostname, GFP_KERNEL);
+		if (server->nfs_client->cl_hostname == NULL)
+			return -ENOMEM;
+	}
 	nfs_server_insert_lists(server);
 
 	return nfs_probe_destination(server);
-- 
2.34.1

