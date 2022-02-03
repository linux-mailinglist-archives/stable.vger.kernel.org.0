Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F004A8ECD
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiBCUi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38962 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbiBCUg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:36:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8233CB835C2;
        Thu,  3 Feb 2022 20:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2C6C340EF;
        Thu,  3 Feb 2022 20:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920615;
        bh=Rk+bx6izfFhamqI62DLqstxwO1vrmy+lWTIj8j3BP2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BP+am+wv2MmFtx8THquOAmMAbzbMAuWZX+xDf005Cv1n/jFFEziqXmVqkAIaBF32t
         7V4GITe6pgMlgM1avlRXhulZPAZYzTW0vByZyU5DTjqD3BqeTDfLADfEpQ4uMme++v
         pvxDp8MhYfGmYeEDQXMpBy6LlMLU5xygGnf9BLCkGiahfewgoYO8t/Fg43uzb1ZRXl
         AsnRzLUEJo/xDH+KSDzuIx/0fK/BdEV8lBrcHAqUbRdWYhWxhf4PYsGQgEDdi/xWiI
         thYF3TaTKNsGkrPBGvDCMMUaEjQqMLdh34kkqxjJ0JCGWnrNTN2BaKHZJZqYXqjeaC
         va2mN+YVXKnNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/7] nfs: nfs4clinet: check the return value of kstrdup()
Date:   Thu,  3 Feb 2022 15:36:46 -0500
Message-Id: <20220203203651.5158-2-sashal@kernel.org>
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
index 2fb4633897084..48baa92846e5f 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1329,8 +1329,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
 		goto out;
 	}
 
-	if (server->nfs_client->cl_hostname == NULL)
+	if (server->nfs_client->cl_hostname == NULL) {
 		server->nfs_client->cl_hostname = kstrdup(hostname, GFP_KERNEL);
+		if (server->nfs_client->cl_hostname == NULL)
+			return -ENOMEM;
+	}
 	nfs_server_insert_lists(server);
 
 	error = nfs_probe_destination(server);
-- 
2.34.1

