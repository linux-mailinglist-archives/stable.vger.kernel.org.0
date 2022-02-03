Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D24A8EA8
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354665AbiBCUiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38428 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354762AbiBCUgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:36:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49C5BB835B9;
        Thu,  3 Feb 2022 20:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5A7C340F2;
        Thu,  3 Feb 2022 20:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920577;
        bh=Q0rgJ3uuJVNFnx5+PCV403tRiCwPGUedbmAIe320ilg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icnMIrubaNfWSmZsry9UswP5HsArDSLhaDYbtYDNsiOF65mCqwzeSzJJjHPAqjbNt
         YrhxBj4nSmInCKz+UzndzKO3McpQC6Cum4wuLGYd6ej9Ldl9h5lEr9KyzNJxo7/W3X
         36GC4PV6xiioFuyVbaKnFrLAxqg+lp2uO8r5yfi0R9mdBAzRF+kQdscjT2g+/im6+I
         puJBw9UtCWXf3aTtISxUh4pLwwGXHcFOs4/GSQMIhEgNXHj7jgw6GHkI46zwzjMGYa
         uOP5ocIp0DYluyLiv5tHo1BlvA1PgpTVLjUmGfXdnM+ef8bvt6dl/vohg8rh+Z4QE/
         Ie4b3PmBGD6dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/10] nfs: nfs4clinet: check the return value of kstrdup()
Date:   Thu,  3 Feb 2022 15:36:05 -0500
Message-Id: <20220203203613.4165-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203613.4165-1-sashal@kernel.org>
References: <20220203203613.4165-1-sashal@kernel.org>
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
index 43659326b5191..c97ec2fa0bbcd 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1273,8 +1273,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
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

