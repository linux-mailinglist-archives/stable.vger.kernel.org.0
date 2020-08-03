Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6F723A692
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgHCMtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbgHCMYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B28D20825;
        Mon,  3 Aug 2020 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457441;
        bh=94u6uDODwtksPuc/mYpRSJxDWjbi/Mty9QyjDfExNxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cl2dvY+vjMfsWI8P+mbdshORNk6igrxxEdkHNN4M2ojAZfvZ+n9tbAw/+J2FVVO/0
         hdjo3nSegy+9bNjUK88A6O3agzCuDK/g5C7HUhPuze1BAIR/9EGSXHDc058e2AVA9M
         w77zPCZCQTUEuVXcYbUWl3rdWe/9YoXWGB5eO2hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 069/120] bareudp: forbid mixing IP and MPLS in multiproto mode
Date:   Mon,  3 Aug 2020 14:18:47 +0200
Message-Id: <20200803121906.164574206@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 302d201b5cdf6f4781ee6cd9862f377f975d6c43 ]

In multiproto mode, bareudp_xmit() accepts sending multicast MPLS and
IPv6 packets regardless of the bareudp ethertype. In practice, this
let an IP tunnel send multicast MPLS packets, or an MPLS tunnel send
IPv6 packets.

We need to restrict the test further, so that the multiproto mode only
enables
  * IPv6 for IPv4 tunnels,
  * or multicast MPLS for unicast MPLS tunnels.

To improve clarity, the protocol validation is moved to its own
function, where each logical test has its own condition.

v2: s/ntohs/htons/

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 3dd46cd551145..88e7900853db9 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -407,19 +407,34 @@ free_dst:
 	return err;
 }
 
+static bool bareudp_proto_valid(struct bareudp_dev *bareudp, __be16 proto)
+{
+	if (bareudp->ethertype == proto)
+		return true;
+
+	if (!bareudp->multi_proto_mode)
+		return false;
+
+	if (bareudp->ethertype == htons(ETH_P_MPLS_UC) &&
+	    proto == htons(ETH_P_MPLS_MC))
+		return true;
+
+	if (bareudp->ethertype == htons(ETH_P_IP) &&
+	    proto == htons(ETH_P_IPV6))
+		return true;
+
+	return false;
+}
+
 static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bareudp_dev *bareudp = netdev_priv(dev);
 	struct ip_tunnel_info *info = NULL;
 	int err;
 
-	if (skb->protocol != bareudp->ethertype) {
-		if (!bareudp->multi_proto_mode ||
-		    (skb->protocol !=  htons(ETH_P_MPLS_MC) &&
-		     skb->protocol !=  htons(ETH_P_IPV6))) {
-			err = -EINVAL;
-			goto tx_error;
-		}
+	if (!bareudp_proto_valid(bareudp, skb->protocol)) {
+		err = -EINVAL;
+		goto tx_error;
 	}
 
 	info = skb_tunnel_info(skb);
-- 
2.25.1



