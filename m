Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CDF4A38B3
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 20:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356014AbiA3Ta2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 14:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355987AbiA3Ta1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 14:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DECC061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 11:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D18FDB8290B
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 19:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED9FC340E4;
        Sun, 30 Jan 2022 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643571024;
        bh=fZ9dJZRCudqE1DEneGmuvl2Zev+wRvf7qLKP0kGHmSc=;
        h=Subject:To:Cc:From:Date:From;
        b=PBqrD2BWppegsy8fwLVrhSrI+VlgwXze5U6K4NlFeLmbX0+jjqBmJxyAy5YH3L1N9
         VZUrzC+Dz5EMN+DU1Zsug1xj6hEgQ+v9sLRLBm47pI9B5zfd0tYIk7/qQtx0x7tFQr
         A401KH1Q0GdaiZsb9rA8rMlue1tLAi8SSn5APGbE=
Subject: FAILED: patch "[PATCH] ping: fix the sk_bound_dev_if match in ping_lookup" failed to apply to 4.4-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net, liuhangbin@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 20:23:32 +0100
Message-ID: <164357061217264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2afc3b5a31f9edf3ef0f374f5d70610c79c93a42 Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 22 Jan 2022 06:40:56 -0500
Subject: [PATCH] ping: fix the sk_bound_dev_if match in ping_lookup

When 'ping' changes to use PING socket instead of RAW socket by:

   # sysctl -w net.ipv4.ping_group_range="0 100"

the selftests 'router_broadcast.sh' will fail, as such command

  # ip vrf exec vrf-h1 ping -I veth0 198.51.100.255 -b

can't receive the response skb by the PING socket. It's caused by mismatch
of sk_bound_dev_if and dif in ping_rcv() when looking up the PING socket,
as dif is vrf-h1 if dif's master was set to vrf-h1.

This patch is to fix this regression by also checking the sk_bound_dev_if
against sdif so that the packets can stil be received even if the socket
is not bound to the vrf device but to the real iif.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 0e56df3a45e2..bcf7bc71cb56 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -220,7 +220,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
+		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
+		    sk->sk_bound_dev_if != inet_sdif(skb))
 			continue;
 
 		sock_hold(sk);

