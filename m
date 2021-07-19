Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A187C3CE1CA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbhGSP1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348221AbhGSPYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF1F61456;
        Mon, 19 Jul 2021 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710597;
        bh=jCT26X888WcBIdKNcDNO9R0A1V4zgmbY4LfCssXov4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJ+oIPZ4wYeC8f1vLqdpC0cMTPXcSmh6TxTs4nGvdqDB9TU2dBCxuYthazNJvyT5J
         jCKwDEnsDp4ba/s7pJhMVK8rmGGOtSudi2qrwLTrqy0oez7YSYZtGsF2vvpCcPDH2a
         Uz152ZYgbb9m2X39E3e8lKVN2i0/gK1KerLpOYdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linus.luessing@c0d3.blue,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 038/351] net: bridge: multicast: fix MRD advertisement router port marking race
Date:   Mon, 19 Jul 2021 16:49:44 +0200
Message-Id: <20210719144945.793424215@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit 000b7287b67555fee39d39fff75229dedde0dcbf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3100,7 +3100,9 @@ static int br_ip4_multicast_mrd_rcv(stru
 	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
 		return -ENOMSG;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 
 	return 0;
 }
@@ -3168,7 +3170,9 @@ static void br_ip6_multicast_mrd_rcv(str
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,


