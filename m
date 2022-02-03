Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6910A4A8E5D
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354782AbiBCUgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:36:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41052 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbiBCUex (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:34:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB8261B32;
        Thu,  3 Feb 2022 20:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A934C340F3;
        Thu,  3 Feb 2022 20:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920492;
        bh=uxBtlMvpAEk7Qv6agBQmc3iJ1oSIfEUqJj1aLSZvzl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skqnbx0UDzC5lH+guTrInV2WAWs6Rrol3WLVIWcH/ArtGb9Fy3dCpyLe/FFssj5Bx
         leP6qLmJodwNWBvnHEdJVWOxbJMqylX5zr2Y+yHN+31yWT/494wCWUM+9NKmuMI0eG
         J/WY77SsCe2QdgOifEL2ubIPTUeQx/zPg2KRdZ47OQt/e0EY2TzQdSd3yKhhMy4M3J
         bKwISV0nJpoQ/likJWPJdF3QACa2L6MrAWARdCHGOzeGqXkrLNqUNPBWxLL0BZZOSQ
         vRn0U0i9BZspNcsP+YwRTlaP0nHtv7So80I/Tktxg39Cp8itaNBzDQo1qe2yP1BiPP
         BO9K8Gr9HRJjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/25] nfs: nfs4clinet: check the return value of kstrdup()
Date:   Thu,  3 Feb 2022 15:34:24 -0500
Message-Id: <20220203203447.3570-3-sashal@kernel.org>
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
index 6d74f2e2de461..0e6437b08a3a5 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1330,8 +1330,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
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

