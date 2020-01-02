Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947CD12EFEB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgABWtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgABW0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:26:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0BF220863;
        Thu,  2 Jan 2020 22:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004012;
        bh=MAti0OlISvYe2Sbp3dLgsxncdP9uwIFvy9lyu826KbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxa9ml2EKf7CP8p9U1A44ovzyenVPj++OLl/D4z7EjxUPOAuhl0eKbRdCPaoUVfx2
         rt6uWfzGz+wKdhTXWnlinRMAy+VqaHOfkQHHCmiJlOq5wI5nfSN7nxRKu0hVtfOVf+
         71dx6pznoIRFi26C8Roqcr1L4JW2O6biNkbBhc9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 85/91] sit: do not confirm neighbor when do pmtu update
Date:   Thu,  2 Jan 2020 23:08:07 +0100
Message-Id: <20200102220451.506717250@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4d42df46d6372ece4cb4279870b46c2ea7304a47 ]

When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -932,7 +932,7 @@ static netdev_tx_t ipip6_tunnel_xmit(str
 		}
 
 		if (tunnel->parms.iph.daddr)
-			skb_dst_update_pmtu(skb, mtu);
+			skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->len > mtu && !skb_is_gso(skb)) {
 			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);


