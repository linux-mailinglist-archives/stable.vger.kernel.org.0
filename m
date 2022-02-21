Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFA24BDFE1
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346972AbiBUJDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347126AbiBUJAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:00:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE416275E4;
        Mon, 21 Feb 2022 00:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A174611DB;
        Mon, 21 Feb 2022 08:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAC4C340E9;
        Mon, 21 Feb 2022 08:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433743;
        bh=Sho+2EN2OREeQ4S2SFRqB7ZQHvCM/jTHANkhtSh03Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zg9I5Epw7VjzStqqgH5Y4xXTT6EhKsYaZBff/2MUY2PaMgMzH8e7fhQ3Yzc/su1zs
         T/aErMMsz67FAuD5ohA9dI4tPfWLhW0tGRRoD62jWVdVRoPNlpTtCVyJ+WzgGKi/LK
         C8I71zXXunCay277/hjDYinF4FsxTh8JN8NKzuLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 27/58] ping: fix the dif and sdif check in ping_lookup
Date:   Mon, 21 Feb 2022 09:49:20 +0100
Message-Id: <20220221084912.763102666@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 35a79e64de29e8d57a5989aac57611c0cd29e13e upstream.

When 'ping' changes to use PING socket instead of RAW socket by:

   # sysctl -w net.ipv4.ping_group_range="0 100"

There is another regression caused when matching sk_bound_dev_if
and dif, RAW socket is using inet_iif() while PING socket lookup
is using skb->dev->ifindex, the cmd below fails due to this:

  # ip link add dummy0 type dummy
  # ip link set dummy0 up
  # ip addr add 192.168.111.1/24 dev dummy0
  # ping -I dummy0 192.168.111.1 -c1

The issue was also reported on:

  https://github.com/iputils/iputils/issues/104

But fixed in iputils in a wrong way by not binding to device when
destination IP is on device, and it will cause some of kselftests
to fail, as Jianlin noticed.

This patch is to use inet(6)_iif and inet(6)_sdif to get dif and
sdif for PING socket, and keep consistent with RAW socket.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -177,16 +177,23 @@ static struct sock *ping_lookup(struct n
 	struct sock *sk = NULL;
 	struct inet_sock *isk;
 	struct hlist_nulls_node *hnode;
-	int dif = skb->dev->ifindex;
+	int dif, sdif;
 
 	if (skb->protocol == htons(ETH_P_IP)) {
+		dif = inet_iif(skb);
+		sdif = inet_sdif(skb);
 		pr_debug("try to find: num = %d, daddr = %pI4, dif = %d\n",
 			 (int)ident, &ip_hdr(skb)->daddr, dif);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		dif = inet6_iif(skb);
+		sdif = inet6_sdif(skb);
 		pr_debug("try to find: num = %d, daddr = %pI6c, dif = %d\n",
 			 (int)ident, &ipv6_hdr(skb)->daddr, dif);
 #endif
+	} else {
+		pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
+		return NULL;
 	}
 
 	read_lock_bh(&ping_table.lock);
@@ -226,7 +233,7 @@ static struct sock *ping_lookup(struct n
 		}
 
 		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-		    sk->sk_bound_dev_if != inet_sdif(skb))
+		    sk->sk_bound_dev_if != sdif)
 			continue;
 
 		sock_hold(sk);


