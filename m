Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E84643207
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiLETXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbiLETXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:23:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EFF2AC5A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:18:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B94C6130C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAC8C433C1;
        Mon,  5 Dec 2022 19:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267924;
        bh=tB+l4si3oVg8eSvSZ4saYt8SxsawC1OJAFr2ag7qlCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aWv2ZY6lK5Z6ZXMxT35zmbIhAZ/PmudjS6LcVtaNzUO3AYzCZdq0WwEeBrotAYu8
         Jn4H/o24suMrBiOCV8nZS+Wyj9zbpjzMxSdoR+QTdjRSDI4xiaJG5sFPkEiz502fPv
         LrYQtSqx28eVeF09uBaNtV+kYTgTplYFWtgbe9KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/105] tipc: set con sock in tipc_conn_alloc
Date:   Mon,  5 Dec 2022 20:08:55 +0100
Message-Id: <20221205190803.935704139@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 0e5d56c64afcd6fd2d132ea972605b66f8a7d3c4 ]

A crash was reported by Wei Chen:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  RIP: 0010:tipc_conn_close+0x12/0x100
  Call Trace:
   tipc_topsrv_exit_net+0x139/0x320
   ops_exit_list.isra.9+0x49/0x80
   cleanup_net+0x31a/0x540
   process_one_work+0x3fa/0x9f0
   worker_thread+0x42/0x5c0

It was caused by !con->sock in tipc_conn_close(). In tipc_topsrv_accept(),
con is allocated in conn_idr then its sock is set:

  con = tipc_conn_alloc();
  ...                    <----[1]
  con->sock = newsock;

If tipc_conn_close() is called in anytime of [1], the null-pointer-def
is triggered by con->sock->sk due to con->sock is not yet set.

This patch fixes it by moving the con->sock setting to tipc_conn_alloc()
under s->idr_lock. So that con->sock can never be NULL when getting the
con from s->conn_idr. It will be also safer to move con->server and flag
CF_CONNECTED setting under s->idr_lock, as they should all be set before
tipc_conn_alloc() is called.

Fixes: c5fa7b3cf3cb ("tipc: introduce new TIPC server infrastructure")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5a88a93e67ef..8ac27bd786f3 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -184,7 +184,7 @@ static void tipc_conn_close(struct tipc_conn *con)
 	conn_put(con);
 }
 
-static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
+static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *sock)
 {
 	struct tipc_conn *con;
 	int ret;
@@ -210,10 +210,11 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
 	}
 	con->conid = ret;
 	s->idr_in_use++;
-	spin_unlock_bh(&s->idr_lock);
 
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
+	con->sock = sock;
+	spin_unlock_bh(&s->idr_lock);
 
 	return con;
 }
@@ -474,7 +475,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
 			return;
-		con = tipc_conn_alloc(srv);
+		con = tipc_conn_alloc(srv, newsock);
 		if (IS_ERR(con)) {
 			ret = PTR_ERR(con);
 			sock_release(newsock);
@@ -486,7 +487,6 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		newsk->sk_data_ready = tipc_conn_data_ready;
 		newsk->sk_write_space = tipc_conn_write_space;
 		newsk->sk_user_data = con;
-		con->sock = newsock;
 		write_unlock_bh(&newsk->sk_callback_lock);
 
 		/* Wake up receive process in case of 'SYN+' message */
@@ -584,12 +584,11 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.filter = filter;
 	*(u64 *)&sub.usr_handle = (u64)port;
 
-	con = tipc_conn_alloc(tipc_topsrv(net));
+	con = tipc_conn_alloc(tipc_topsrv(net), NULL);
 	if (IS_ERR(con))
 		return false;
 
 	*conid = con->conid;
-	con->sock = NULL;
 	rc = tipc_conn_rcv_sub(tipc_topsrv(net), con, &sub);
 	if (rc >= 0)
 		return true;
-- 
2.35.1



