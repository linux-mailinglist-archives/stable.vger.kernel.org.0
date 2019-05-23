Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B230E28879
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391394AbfEWT0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391389AbfEWT0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3647206BA;
        Thu, 23 May 2019 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639600;
        bh=dXu6vL91nMy3bz87zBqHyFSpPCE7kSEJxLm1GK61tzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/TgycbV5sxEqwIOCc7RdEkPGzIN+96gCm62A2x7S1iHsyMVoEYa39DfgmmLZ19MA
         W2za+wjR2xUBkQtvbgwMBDZhOOCtkhYWKZLh2nPv3KEWx9AKAmSfm7XXuHxhHqqhrW
         JM8bgTIH8PPC2J4p3J/eDj4/YoE7luH7DKU91z3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 008/122] nfp: flower: add rcu locks when accessing netdev for tunnels
Date:   Thu, 23 May 2019 21:05:30 +0200
Message-Id: <20190523181706.119321601@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

[ Upstream commit cb07d915bf278a7a3938b983bbcb4921366b5eff ]

Add rcu locks when accessing netdev when processing route request
and tunnel keep alive messages received from hardware.

Fixes: 8e6a9046b66a ("nfp: flower vxlan neighbour offload")
Fixes: 856f5b135758 ("nfp: flower vxlan neighbour keep-alive")
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |   17 ++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -168,6 +168,7 @@ void nfp_tunnel_keep_alive(struct nfp_ap
 		return;
 	}
 
+	rcu_read_lock();
 	for (i = 0; i < count; i++) {
 		ipv4_addr = payload->tun_info[i].ipv4;
 		port = be32_to_cpu(payload->tun_info[i].egress_port);
@@ -183,6 +184,7 @@ void nfp_tunnel_keep_alive(struct nfp_ap
 		neigh_event_send(n, NULL);
 		neigh_release(n);
 	}
+	rcu_read_unlock();
 }
 
 static int
@@ -366,9 +368,10 @@ void nfp_tunnel_request_route(struct nfp
 
 	payload = nfp_flower_cmsg_get_data(skb);
 
+	rcu_read_lock();
 	netdev = nfp_app_repr_get(app, be32_to_cpu(payload->ingress_port));
 	if (!netdev)
-		goto route_fail_warning;
+		goto fail_rcu_unlock;
 
 	flow.daddr = payload->ipv4_addr;
 	flow.flowi4_proto = IPPROTO_UDP;
@@ -378,21 +381,23 @@ void nfp_tunnel_request_route(struct nfp
 	rt = ip_route_output_key(dev_net(netdev), &flow);
 	err = PTR_ERR_OR_ZERO(rt);
 	if (err)
-		goto route_fail_warning;
+		goto fail_rcu_unlock;
 #else
-	goto route_fail_warning;
+	goto fail_rcu_unlock;
 #endif
 
 	/* Get the neighbour entry for the lookup */
 	n = dst_neigh_lookup(&rt->dst, &flow.daddr);
 	ip_rt_put(rt);
 	if (!n)
-		goto route_fail_warning;
-	nfp_tun_write_neigh(n->dev, app, &flow, n, GFP_KERNEL);
+		goto fail_rcu_unlock;
+	nfp_tun_write_neigh(n->dev, app, &flow, n, GFP_ATOMIC);
 	neigh_release(n);
+	rcu_read_unlock();
 	return;
 
-route_fail_warning:
+fail_rcu_unlock:
+	rcu_read_unlock();
 	nfp_flower_cmsg_warn(app, "Requested route not found.\n");
 }
 


