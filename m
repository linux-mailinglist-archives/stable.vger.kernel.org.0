Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E94012F0D5
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgABW4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:56:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbgABWSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6B121582;
        Thu,  2 Jan 2020 22:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003514;
        bh=ADi4dWgw5nGqY+3If4iTJXPUNjYkDaZvDqozVpHUR4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAsBqNDRt40CCC87fp9wC5P/DlKr9O0RQEQkMwhMNHcy6MiGzQYK4Y4A/8XaFyOQ6
         TjKswII8CCG3pdORTyFX2ZBDy4nn+XbVOQB+BehC+iMWtoIgUAMQHYhLFWKfSr883l
         ORwtChwQcqANsEtAGU57K95BX3R4jEUT95Q/0Gzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 173/191] sit: do not confirm neighbor when do pmtu update
Date:   Thu,  2 Jan 2020 23:07:35 +0100
Message-Id: <20200102215847.839524945@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
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
@@ -944,7 +944,7 @@ static netdev_tx_t ipip6_tunnel_xmit(str
 		}
 
 		if (tunnel->parms.iph.daddr)
-			skb_dst_update_pmtu(skb, mtu);
+			skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->len > mtu && !skb_is_gso(skb)) {
 			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);


