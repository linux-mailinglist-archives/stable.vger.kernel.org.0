Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8974290FC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbhJKOOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243035AbhJKOMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D854B611B0;
        Mon, 11 Oct 2021 14:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961023;
        bh=cU5o4ZJSpdsCaG3FQuUCFX6bud+DK3LScMu2fjPx9MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvRgIOFO1fVyZp0zHdKU5YJn/aBrCcrRVys0xWLk6ViJ6NDN4CQUCuk+8kh4peSKL
         UpVlCwMj0T7J+WG+mDD+8LxjwyBxREf2gVVvDwMt2FP5QZTygBYYIztAGuleHCBqxv
         trK9QRrQDCyZ65oL7znHeg1LenlqmY04eKpbVJyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Tao Liu <xliutaox@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 112/151] gve: fix gve_get_stats()
Date:   Mon, 11 Oct 2021 15:46:24 +0200
Message-Id: <20211011134521.435783777@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2f57d4975fa027eabd35fdf23a49f8222ef3abf2 ]

gve_get_stats() can report wrong numbers if/when u64_stats_fetch_retry()
returns true.

What is needed here is to sample values in temporary variables,
and only use them after each loop is ended.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Catherine Sullivan <csully@google.com>
Cc: Sagi Shahar <sagis@google.com>
Cc: Jon Olson <jonolson@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Luigi Rizzo <lrizzo@google.com>
Cc: Jeroen de Borst <jeroendb@google.com>
Cc: Tao Liu <xliutaox@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 29c5f994f92e..1b49e9feacac 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -41,6 +41,7 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	unsigned int start;
+	u64 packets, bytes;
 	int ring;
 
 	if (priv->rx) {
@@ -48,10 +49,12 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->rx[ring].statss);
-				s->rx_packets += priv->rx[ring].rpackets;
-				s->rx_bytes += priv->rx[ring].rbytes;
+				packets = priv->rx[ring].rpackets;
+				bytes = priv->rx[ring].rbytes;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
+			s->rx_packets += packets;
+			s->rx_bytes += bytes;
 		}
 	}
 	if (priv->tx) {
@@ -59,10 +62,12 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->tx[ring].statss);
-				s->tx_packets += priv->tx[ring].pkt_done;
-				s->tx_bytes += priv->tx[ring].bytes_done;
+				packets = priv->tx[ring].pkt_done;
+				bytes = priv->tx[ring].bytes_done;
 			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
+			s->tx_packets += packets;
+			s->tx_bytes += bytes;
 		}
 	}
 }
-- 
2.33.0



