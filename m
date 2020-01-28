Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5214B63B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgA1ODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgA1ODf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2345D2468D;
        Tue, 28 Jan 2020 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220214;
        bh=Y8GCpmQnOmVHFtUiBvlcZHyG45MewdZ47K+7M+lP/AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/FWUTGuFHDJuJXrP+Y72ggRKoYpdbeGsv/5ogpSq9t8KAcA11v3JxOclbTJdfthr
         2r0sAbsTo+OcM+IEgmmRJLZbfFh5IUC50rzVv5UcMmFsRDD/cF+RrHeiNvEs1a5uA9
         EhsxFLmOXc7OhU+rJsMvFzrmnIJMDOJcV+B8NfFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 062/104] mlxsw: switchx2: Do not modify cloned SKBs during xmit
Date:   Tue, 28 Jan 2020 15:00:23 +0100
Message-Id: <20200128135826.124448690@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

commit 63963d0f9d17be83d0e419e03282847ecc2c3715 upstream.

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

Fixes: 31557f0f9755 ("mlxsw: Introduce Mellanox SwitchX-2 ASIC support")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -299,22 +299,17 @@ static netdev_tx_t mlxsw_sx_port_xmit(st
 	u64 len;
 	int err;
 
+	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
+		this_cpu_inc(mlxsw_sx_port->pcpu_stats->tx_dropped);
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
 	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
 
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sx->core, &tx_info))
 		return NETDEV_TX_BUSY;
 
-	if (unlikely(skb_headroom(skb) < MLXSW_TXHDR_LEN)) {
-		struct sk_buff *skb_orig = skb;
-
-		skb = skb_realloc_headroom(skb, MLXSW_TXHDR_LEN);
-		if (!skb) {
-			this_cpu_inc(mlxsw_sx_port->pcpu_stats->tx_dropped);
-			dev_kfree_skb_any(skb_orig);
-			return NETDEV_TX_OK;
-		}
-		dev_consume_skb_any(skb_orig);
-	}
 	mlxsw_sx_txhdr_construct(skb, &tx_info);
 	/* TX header is consumed by HW on the way so we shouldn't count its
 	 * bytes as being sent.


