Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC7E3CD0B8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhGSIql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235740AbhGSIql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 671306108B;
        Mon, 19 Jul 2021 09:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626686841;
        bh=ZbQ+KyWFxyovTgxurHH1ME8bmNIY4JY0pW4AMRn+RHU=;
        h=Subject:To:Cc:From:Date:From;
        b=O30ymT18ZBNmE0+of89wCHQKmjApNZHcLvbpcrcKRMtoWBdgYCLTrqigrDgJfO8Ro
         BqBF1/TH354NDZR7UhZHS4t3HVjvd/BmpZ1syXre16Ar8bQNJUScpohyLm69+85nZT
         plBg3h1bno0uhk3qxpK2T4YJss+ZuIxd8wSzPMgI=
Subject: FAILED: patch "[PATCH] net: bridge: multicast: fix MRD advertisement router port" failed to apply to 5.12-stable tree
To:     nikolay@nvidia.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 11:27:08 +0200
Message-ID: <1626686828112206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 000b7287b67555fee39d39fff75229dedde0dcbf Mon Sep 17 00:00:00 2001
From: Nikolay Aleksandrov <nikolay@nvidia.com>
Date: Sun, 11 Jul 2021 12:56:29 +0300
Subject: [PATCH] net: bridge: multicast: fix MRD advertisement router port
 marking race

When an MRD advertisement is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port to the router port list. The multicast lock
protects that list, but it is not acquired in the MRD advertisement case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Cc: linus.luessing@c0d3.blue
Fixes: 4b3087c7e37f ("bridge: Snoop Multicast Router Advertisements")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3bbbc6d7b7c3..d0434dc8c03b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3277,7 +3277,9 @@ static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
 	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
 		return -ENOMSG;
 
+	spin_lock(&br->multicast_lock);
 	br_ip4_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 
 	return 0;
 }
@@ -3345,7 +3347,9 @@ static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_ip6_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,

