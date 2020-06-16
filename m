Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E271FBAD0
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgFPQOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730939AbgFPPmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:42:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396EA208E4;
        Tue, 16 Jun 2020 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322159;
        bh=f4dWbME0zvTO4lNAmFwEvgbVjHjm7e7nyr1BsvdN+HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/MFTqtrZk5z3eF9xclHqF7/oNEJmyNUCzXlWrRJ29uGVhRf4rHUZ/42xRmfVZC8W
         m59ztvXPgByI/9zfFtE12tSNu5HLToVqseTyf0XKE5cYERvD+srDxultp/jpVFxYG/
         LHXlAk/4wap4yV4ga5kEtmAt7QfPsOzraB/18Fm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Alla Segal <allas@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 005/163] bridge: Avoid infinite loop when suppressing NS messages with invalid options
Date:   Tue, 16 Jun 2020 17:32:59 +0200
Message-Id: <20200616153107.117704051@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 53fc685243bd6fb90d90305cea54598b78d3cbfc ]

When neighbor suppression is enabled the bridge device might reply to
Neighbor Solicitation (NS) messages on behalf of remote hosts.

In case the NS message includes the "Source link-layer address" option
[1], the bridge device will use the specified address as the link-layer
destination address in its reply.

To avoid an infinite loop, break out of the options parsing loop when
encountering an option with length zero and disregard the NS message.

This is consistent with the IPv6 ndisc code and RFC 4886 which states
that "Nodes MUST silently discard an ND packet that contains an option
with length zero" [2].

[1] https://tools.ietf.org/html/rfc4861#section-4.3
[2] https://tools.ietf.org/html/rfc4861#section-4.6

Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alla Segal <allas@mellanox.com>
Tested-by: Alla Segal <allas@mellanox.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_arp_nd_proxy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -276,6 +276,10 @@ static void br_nd_send(struct net_bridge
 	ns_olen = request->len - (skb_network_offset(request) +
 				  sizeof(struct ipv6hdr)) - sizeof(*ns);
 	for (i = 0; i < ns_olen - 1; i += (ns->opt[i + 1] << 3)) {
+		if (!ns->opt[i + 1]) {
+			kfree_skb(reply);
+			return;
+		}
 		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
 			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
 			break;


