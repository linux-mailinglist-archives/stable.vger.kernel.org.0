Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A5B4123F3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348753AbhITS27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378885AbhITS04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A11C632EE;
        Mon, 20 Sep 2021 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158764;
        bh=yg4Ps3VUDzAa+n+FwBjZD7iXQmBjHkZuZ9/f/VvJoz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMHbVti3iM9jTvM4Gr/LDV2Kd5kb33KjGFCgPkXd7iETlmj0H6kmHtT31lgUgr3Ib
         FLVmVReOWk91C+uDfAefTrS+BdqAipZD3LIawzgxsS49ce3QGAv5LmkltzsaDH5+ry
         g6jAiq7++cg0Ltq5A0lmmEVcIGbc33ymGgZ4RAGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 045/122] udp_tunnel: Fix udp_tunnel_nic work-queue type
Date:   Mon, 20 Sep 2021 18:43:37 +0200
Message-Id: <20210920163917.269126860@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

commit e50e711351bdc656a8e6ca1022b4293cae8dcd59 upstream.

Turn udp_tunnel_nic work-queue to an ordered work-queue. This queue
holds the UDP-tunnel configuration commands of the different netdevs.
When the netdevs are functions of the same NIC the order of
execution may be crucial.

Problem example:
NIC with 2 PFs, both PFs declare offload quota of up to 3 UDP-ports.
 $ifconfig eth2 1.1.1.1/16 up

 $ip link add eth2_19503 type vxlan id 5049 remote 1.1.1.2 dev eth2 dstport 19053
 $ip link set dev eth2_19503 up

 $ip link add eth2_19504 type vxlan id 5049 remote 1.1.1.3 dev eth2 dstport 19054
 $ip link set dev eth2_19504 up

 $ip link add eth2_19505 type vxlan id 5049 remote 1.1.1.4 dev eth2 dstport 19055
 $ip link set dev eth2_19505 up

 $ip link add eth2_19506 type vxlan id 5049 remote 1.1.1.5 dev eth2 dstport 19056
 $ip link set dev eth2_19506 up

NIC RX port offload infrastructure offloads the first 3 UDP-ports (on
all devices which sets NETIF_F_RX_UDP_TUNNEL_PORT feature) and not
UDP-port 19056. So both PFs gets this offload configuration.

 $ip link set dev eth2_19504 down

This triggers udp-tunnel-core to remove the UDP-port 19504 from
offload-ports-list and offload UDP-port 19056 instead.

In this scenario it is important that the UDP-port of 19504 will be
removed from both PFs before trying to add UDP-port 19056. The NIC can
stop offloading a UDP-port only when all references are removed.
Otherwise the NIC may report exceeding of the offload quota.

Fixes: cc4e3835eff4 ("udp_tunnel: add central NIC RX port offload infrastructure")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_tunnel_nic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -935,7 +935,7 @@ static int __init udp_tunnel_nic_init_mo
 {
 	int err;
 
-	udp_tunnel_nic_workqueue = alloc_workqueue("udp_tunnel_nic", 0, 0);
+	udp_tunnel_nic_workqueue = alloc_ordered_workqueue("udp_tunnel_nic", 0);
 	if (!udp_tunnel_nic_workqueue)
 		return -ENOMEM;
 


