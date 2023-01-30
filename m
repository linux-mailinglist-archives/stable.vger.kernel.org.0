Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED52681333
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbjA3O3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237686AbjA3O2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7812F3F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:27:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C6ADB80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEE0C4339B;
        Mon, 30 Jan 2023 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088833;
        bh=zRWNzo5aoVWeJjJ/HZP/c2IU0EZ5EKL8odoT6ODrt10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxvfFesdtPX8uDsGogJrG8lPfy87V1JScI64X8Q64oVl2TCqoYe8v5wc1GzawmiDr
         xXErrBRmrRBdWrodpWM4T6NZdZaxpzH8bULpc/zsjCdp2TrkhYbVNNyCe5vqvQjDys
         uNgEp5KKcCQ2zbOAN4TXfx8YCqb+E0Ek3nKrIw/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/143] netlink: annotate data races around sk_state
Date:   Mon, 30 Jan 2023 14:52:59 +0100
Message-Id: <20230130134311.885627408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9b663b5cbb15b494ef132a3c937641c90646eb73 ]

netlink_getsockbyportid() reads sk_state while a concurrent
netlink_connect() can change its value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index cdecd1977583..2104fbdd63d2 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1081,7 +1081,8 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 		return -EINVAL;
 
 	if (addr->sa_family == AF_UNSPEC) {
-		sk->sk_state	= NETLINK_UNCONNECTED;
+		/* paired with READ_ONCE() in netlink_getsockbyportid() */
+		WRITE_ONCE(sk->sk_state, NETLINK_UNCONNECTED);
 		/* dst_portid and dst_group can be read locklessly */
 		WRITE_ONCE(nlk->dst_portid, 0);
 		WRITE_ONCE(nlk->dst_group, 0);
@@ -1105,7 +1106,8 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 		err = netlink_autobind(sock);
 
 	if (err == 0) {
-		sk->sk_state	= NETLINK_CONNECTED;
+		/* paired with READ_ONCE() in netlink_getsockbyportid() */
+		WRITE_ONCE(sk->sk_state, NETLINK_CONNECTED);
 		/* dst_portid and dst_group can be read locklessly */
 		WRITE_ONCE(nlk->dst_portid, nladdr->nl_pid);
 		WRITE_ONCE(nlk->dst_group, ffs(nladdr->nl_groups));
@@ -1157,8 +1159,8 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
 	/* Don't bother queuing skb if kernel socket has no input function */
 	nlk = nlk_sk(sock);
-	/* dst_portid can be changed in netlink_connect() */
-	if (sock->sk_state == NETLINK_CONNECTED &&
+	/* dst_portid and sk_state can be changed in netlink_connect() */
+	if (READ_ONCE(sock->sk_state) == NETLINK_CONNECTED &&
 	    READ_ONCE(nlk->dst_portid) != nlk_sk(ssk)->portid) {
 		sock_put(sock);
 		return ERR_PTR(-ECONNREFUSED);
-- 
2.39.0



