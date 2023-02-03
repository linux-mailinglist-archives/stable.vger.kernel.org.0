Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC9668966E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbjBCK2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjBCK21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BD6A429A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34DC661ECF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33BAC433D2;
        Fri,  3 Feb 2023 10:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420031;
        bh=qI8XpUSiZ7BxyGHnZjwjz3zSLqMEKbO+YvKFNuSgLLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXsTAiAUNVKCL1mIm0JPAyNspz1/K9a+qSnAdVeVbeFIZFVwvkPV3a6yrqTpC6DUa
         SFwdx0nxyMlI9wAvYPeBRoiQRMDuZEhcBWq3s7yovPMcAyRyo5SXot2XKqz0ddIhmx
         FWiN5mTAcduM8HXoFZwEbsJB+eJZHqzv5fbsA6gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cong Wang <cong.wang@bytedance.com>,
        Sishuai Gong <sishuai@purdue.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/134] net: fix a concurrency bug in l2tp_tunnel_register()
Date:   Fri,  3 Feb 2023 11:12:12 +0100
Message-Id: <20230203101025.068952432@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Gong, Sishuai <sishuai@purdue.edu>

[ Upstream commit 69e16d01d1de4f1249869de342915f608feb55d5 ]

l2tp_tunnel_register() registers a tunnel without fully
initializing its attribute. This can allow another kernel thread
running l2tp_xmit_core() to access the uninitialized data and
then cause a kernel NULL pointer dereference error, as shown below.

Thread 1    Thread 2
//l2tp_tunnel_register()
list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
           //pppol2tp_connect()
           tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
           // Fetch the new tunnel
           ...
           //l2tp_xmit_core()
           struct sock *sk = tunnel->sock;
           ...
           bh_lock_sock(sk);
           //Null pointer error happens
tunnel->sock = sk;

Fix this bug by initializing tunnel->sock before adding the
tunnel into l2tp_tunnel_list.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
Reported-by: Sishuai Gong <sishuai@purdue.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 421b2c89ce12..a0ec61f2295b 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1500,11 +1500,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
 
+	sk = sock->sk;
+	sock_hold(sk);
+	tunnel->sock = sk;
+
 	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
 	list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
 		if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
 			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+			sock_put(sk);
 			ret = -EEXIST;
 			goto err_sock;
 		}
@@ -1512,10 +1516,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
 	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
 
-	sk = sock->sk;
-	sock_hold(sk);
-	tunnel->sock = sk;
-
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
 			.sk_user_data = tunnel,
-- 
2.39.0



