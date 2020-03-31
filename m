Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE5A198FA3
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgCaJFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730728AbgCaJFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D233208E0;
        Tue, 31 Mar 2020 09:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645510;
        bh=WIUDeeKpTGl5MXeTpSN3kNuE9hv1uES+opG8N5XZN8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4AKkkWjUEbGYpBr2f6SPLzq+5pCKEKrAkBUBJCRx/CrqlimMVWd+yQlXGyB9Mqzl
         NGGFwow1vfscEz4lFPiVRTz3JE9ftzzaSzHvUD3vq5JkHN6G2EAncZLRjSv2xZncpc
         wFOYn00a8vAqNMrb7mSDYLHhtAhyv3ppW5ZOVkOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiang Lidong <jianglidong3@jd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 069/170] veth: ignore peer tx_dropped when counting local rx_dropped
Date:   Tue, 31 Mar 2020 10:58:03 +0200
Message-Id: <20200331085431.741779499@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiang Lidong <jianglidong3@jd.com>

[ Upstream commit e25d5dbcffae62c9a7fa03517dfa4b8e67670e3d ]

When local NET_RX backlog is full due to traffic overrun,
peer veth tx_dropped counter increases. At that time, list
local veth stats, rx_dropped has double value of peer
tx_dropped, even bigger than transmit packets by peer.

In NET_RX softirq process, if any packet drop case happens,
it increases dev's rx_dropped counter and returns NET_RX_DROP.

At veth tx side, it records any error returned from peer netif_rx
into local dev tx_dropped counter.

In veth get stats process, it puts local dev rx_dropped and
peer dev tx_dropped into together as local rx_drpped value.
So that it shows double value of real dropped packets number in
this case.

This patch ignores peer tx_dropped when counting local rx_dropped,
since peer tx_dropped is duplicated to local rx_dropped at most cases.

Signed-off-by: Jiang Lidong <jianglidong3@jd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a552df37a347c..bad9e03cd32e7 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -328,7 +328,7 @@ static void veth_get_stats64(struct net_device *dev,
 	rcu_read_lock();
 	peer = rcu_dereference(priv->peer);
 	if (peer) {
-		tot->rx_dropped += veth_stats_tx(peer, &packets, &bytes);
+		veth_stats_tx(peer, &packets, &bytes);
 		tot->rx_bytes += bytes;
 		tot->rx_packets += packets;
 
-- 
2.20.1



