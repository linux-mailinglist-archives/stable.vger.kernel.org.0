Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5BB14564A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgAVNYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbgAVNYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:48 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A23424688;
        Wed, 22 Jan 2020 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699487;
        bh=AXzGzg7aB76QJhArJB3cCflXRp9u84Qf07aZ4biO7Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jgSovNa2tRsD9uXPWp068r8BRPKqgMGKf1rHY8lCLyLEyvqcKudnYa0KRpd6fBbA
         6JvJ4wnVk0ik68Jk3rQx7enW/d364Vmsfkbe2wCE7Yr5+1Yli3sba6dABkRbze3FE9
         gyAO4TLUKySzsbktuAqe3hrWdHPQ0wiSVkswEeAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 161/222] mlxsw: spectrum: Do not modify cloned SKBs during xmit
Date:   Wed, 22 Jan 2020 10:29:07 +0100
Message-Id: <20200122092845.242283226@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

commit 2da51ce75d86ab1f7770ac1391a9a1697ddaa60c upstream.

The driver needs to prepend a Tx header to each packet it is
transmitting. The header includes information such as the egress port
and traffic class.

The addition of the header requires the driver to modify the SKB's
header and therefore it must not be shared. Otherwise, we risk hitting
various race conditions.

For example, when a packet is flooded (cloned) by the bridge driver to
two switch ports swp1 and swp2:

t0 - mlxsw_sp_port_xmit() is called for swp1. Tx header is prepended with
     swp1's port number
t1 - mlxsw_sp_port_xmit() is called for swp2. Tx header is prepended with
     swp2's port number, overwriting swp1's port number
t2 - The device processes data buffer from t0. Packet is transmitted via
     swp2
t3 - The device processes data buffer from t1. Packet is transmitted via
     swp2

Usually, the device is fast enough and transmits the packet before its
Tx header is overwritten, but this is not the case in emulated
environments.

Fix this by making sure the SKB's header is writable by calling
skb_cow_head(). Since the function ensures we have headroom to push the
Tx header, the check further in the function can be removed.

v2:
* Use skb_cow_head() instead of skb_unshare() as suggested by Jakub
* Remove unnecessary check regarding headroom

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -812,23 +812,17 @@ static netdev_tx_t mlxsw_sp_port_xmit(st
 	u64 len;
 	int err;
 
+	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
+		this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
 	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
 
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sp->core, &tx_info))
 		return NETDEV_TX_BUSY;
 
-	if (unlikely(skb_headroom(skb) < MLXSW_TXHDR_LEN)) {
-		struct sk_buff *skb_orig = skb;
-
-		skb = skb_realloc_headroom(skb, MLXSW_TXHDR_LEN);
-		if (!skb) {
-			this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
-			dev_kfree_skb_any(skb_orig);
-			return NETDEV_TX_OK;
-		}
-		dev_consume_skb_any(skb_orig);
-	}
-
 	if (eth_skb_pad(skb)) {
 		this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
 		return NETDEV_TX_OK;


