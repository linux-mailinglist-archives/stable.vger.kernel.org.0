Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00272689504
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbjBCKPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjBCKPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DF78E68D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C078161E54
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F07C4339B;
        Fri,  3 Feb 2023 10:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419345;
        bh=7UwvYFByB20saoVSvH1j/CggmuIiRUMJjLAS0+X/jfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLRAEV621Sl/OwxldWKHzV+7Wsr1XrmJN/VtwZrAe8JngGSZP8pzNKB9RQP9P5cMb
         5WVV+lohTJV4M51XpuGILhRVsOLgbom3VwDmprXEbAucGFEVgWDQ29CqtJo1RpgRpS
         MDpZhJWbcWYOYprWUIVNvourL8dbf0a4/hEvmyTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/62] netlink: annotate data races around dst_portid and dst_group
Date:   Fri,  3 Feb 2023 11:12:26 +0100
Message-Id: <20230203101014.311613084@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 1b2e99ce54e5..1547d0825668 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1062,8 +1062,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
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
@@ -1085,8 +1086,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	if (err == 0) {
 		sk->sk_state	= NETLINK_CONNECTED;
-		nlk->dst_portid = nladdr->nl_pid;
-		nlk->dst_group  = ffs(nladdr->nl_groups);
+		/* dst_portid and dst_group can be read locklessly */
+		WRITE_ONCE(nlk->dst_portid, nladdr->nl_pid);
+		WRITE_ONCE(nlk->dst_group, ffs(nladdr->nl_groups));
 	}
 
 	return err;
@@ -1104,8 +1106,9 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
 	*addr_len = sizeof(*nladdr);
 
 	if (peer) {
-		nladdr->nl_pid = nlk->dst_portid;
-		nladdr->nl_groups = netlink_group_mask(nlk->dst_group);
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		nladdr->nl_pid = READ_ONCE(nlk->dst_portid);
+		nladdr->nl_groups = netlink_group_mask(READ_ONCE(nlk->dst_group));
 	} else {
 		nladdr->nl_pid = nlk->portid;
 		netlink_lock_table();
@@ -1134,8 +1137,9 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
 	/* Don't bother queuing skb if kernel socket has no input function */
 	nlk = nlk_sk(sock);
+	/* dst_portid can be changed in netlink_connect() */
 	if (sock->sk_state == NETLINK_CONNECTED &&
-	    nlk->dst_portid != nlk_sk(ssk)->portid) {
+	    READ_ONCE(nlk->dst_portid) != nlk_sk(ssk)->portid) {
 		sock_put(sock);
 		return ERR_PTR(-ECONNREFUSED);
 	}
@@ -1847,8 +1851,9 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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



