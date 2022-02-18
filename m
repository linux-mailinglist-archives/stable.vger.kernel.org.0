Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A74BBAD1
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiBROl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:41:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiBROl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:41:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA2924F06
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:41:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88630618EA
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E94CC340E9;
        Fri, 18 Feb 2022 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645195299;
        bh=Qj+NWyHorJjyUv8SRXHhXftn1Qs5G4PJJsNE1+H1CD0=;
        h=Subject:To:Cc:From:Date:From;
        b=Fyks7HbwdLfNvfdxkFYMMmIOqqu0L+pUJiP9PYasZzzgTXZbWXtipOScgV0N6Rp7h
         pe+knwx/4G5jd2kMUalEq20Q1cRtCs782+H/NvKWjB6f+uQrPrl6oJErpNbu4AWNXs
         NWXEuyFdKLlaVg6ATM6+h6u9z6yCjWllmfqoxdrQ=
Subject: FAILED: patch "[PATCH] ping: fix the dif and sdif check in ping_lookup" failed to apply to 4.9-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net, jishi@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:41:36 +0100
Message-ID: <164519529610510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 35a79e64de29e8d57a5989aac57611c0cd29e13e Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Feb 2022 00:20:52 -0500
Subject: [PATCH] ping: fix the dif and sdif check in ping_lookup

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

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index bcf7bc71cb56..3a5994b50571 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -172,16 +172,23 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
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
@@ -221,7 +228,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		}
 
 		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-		    sk->sk_bound_dev_if != inet_sdif(skb))
+		    sk->sk_bound_dev_if != sdif)
 			continue;
 
 		sock_hold(sk);

