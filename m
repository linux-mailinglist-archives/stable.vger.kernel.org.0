Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F0D681332
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbjA3O3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236493AbjA3O2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AC841B6C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 738256108C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF0BC4339C;
        Mon, 30 Jan 2023 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088830;
        bh=FOrWclK/P0rEEhEXdcM6zCjB1H1VbFAlLto+gydGcgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGW22FOjoFT+bDtkJeIsZQRXA4Insf8sAAzaUXZ/NVYcX85+LQZrT74ghLiCFIto8
         0gUCXXxd8wvHggZD7XhcxHUscDsaGy7RqTViqTIDSfRROxxRJ9AVPkY4VJT1kdUYGe
         OX3KymUZGfIPLLbPohG3BzEg3Bxw3Ri0dUnsbMRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/143] netlink: annotate data races around dst_portid and dst_group
Date:   Mon, 30 Jan 2023 14:52:58 +0100
Message-Id: <20230130134311.844246062@linuxfoundation.org>
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

[ Upstream commit 004db64d185a5f23dfb891d7701e23713b2420ee ]

netlink_getname(), netlink_sendmsg() and netlink_getsockbyportid()
can read nlk->dst_portid and nlk->dst_group while another
thread is changing them.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 438f45222ca5..cdecd1977583 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1082,8 +1082,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	if (addr->sa_family == AF_UNSPEC) {
 		sk->sk_state	= NETLINK_UNCONNECTED;
-		nlk->dst_portid	= 0;
-		nlk->dst_group  = 0;
+		/* dst_portid and dst_group can be read locklessly */
+		WRITE_ONCE(nlk->dst_portid, 0);
+		WRITE_ONCE(nlk->dst_group, 0);
 		return 0;
 	}
 	if (addr->sa_family != AF_NETLINK)
@@ -1105,8 +1106,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	if (err == 0) {
 		sk->sk_state	= NETLINK_CONNECTED;
-		nlk->dst_portid = nladdr->nl_pid;
-		nlk->dst_group  = ffs(nladdr->nl_groups);
+		/* dst_portid and dst_group can be read locklessly */
+		WRITE_ONCE(nlk->dst_portid, nladdr->nl_pid);
+		WRITE_ONCE(nlk->dst_group, ffs(nladdr->nl_groups));
 	}
 
 	return err;
@@ -1123,8 +1125,9 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
 	nladdr->nl_pad = 0;
 
 	if (peer) {
-		nladdr->nl_pid = nlk->dst_portid;
-		nladdr->nl_groups = netlink_group_mask(nlk->dst_group);
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		nladdr->nl_pid = READ_ONCE(nlk->dst_portid);
+		nladdr->nl_groups = netlink_group_mask(READ_ONCE(nlk->dst_group));
 	} else {
 		/* Paired with WRITE_ONCE() in netlink_insert() */
 		nladdr->nl_pid = READ_ONCE(nlk->portid);
@@ -1154,8 +1157,9 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
 	/* Don't bother queuing skb if kernel socket has no input function */
 	nlk = nlk_sk(sock);
+	/* dst_portid can be changed in netlink_connect() */
 	if (sock->sk_state == NETLINK_CONNECTED &&
-	    nlk->dst_portid != nlk_sk(ssk)->portid) {
+	    READ_ONCE(nlk->dst_portid) != nlk_sk(ssk)->portid) {
 		sock_put(sock);
 		return ERR_PTR(-ECONNREFUSED);
 	}
@@ -1891,8 +1895,9 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			goto out;
 		netlink_skb_flags |= NETLINK_SKB_DST;
 	} else {
-		dst_portid = nlk->dst_portid;
-		dst_group = nlk->dst_group;
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		dst_portid = READ_ONCE(nlk->dst_portid);
+		dst_group = READ_ONCE(nlk->dst_group);
 	}
 
 	/* Paired with WRITE_ONCE() in netlink_insert() */
-- 
2.39.0



