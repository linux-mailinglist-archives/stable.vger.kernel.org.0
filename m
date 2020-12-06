Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF812D048A
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgLFLqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:46:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729401AbgLFLor (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:44:47 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 26/46] dpaa_eth: copy timestamp fields to new skb in A-050385 workaround
Date:   Sun,  6 Dec 2020 12:17:34 +0100
Message-Id: <20201206111557.720589520@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

[ Upstream commit 07500a6085806d97039ebcba8d9b8b29129f0106 ]

The timestamp fields should be copied to new skb too in
A-050385 workaround for later TX timestamping handling.

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Link: https://lore.kernel.org/r/20201201075258.1875-1-yangbo.lu@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2120,6 +2120,15 @@ workaround:
 	skb_copy_header(new_skb, skb);
 	new_skb->dev = skb->dev;
 
+	/* Copy relevant timestamp info from the old skb to the new */
+	if (priv->tx_tstamp) {
+		skb_shinfo(new_skb)->tx_flags = skb_shinfo(skb)->tx_flags;
+		skb_shinfo(new_skb)->hwtstamps = skb_shinfo(skb)->hwtstamps;
+		skb_shinfo(new_skb)->tskey = skb_shinfo(skb)->tskey;
+		if (skb->sk)
+			skb_set_owner_w(new_skb, skb->sk);
+	}
+
 	/* We move the headroom when we align it so we have to reset the
 	 * network and transport header offsets relative to the new data
 	 * pointer. The checksum offload relies on these offsets.
@@ -2127,7 +2136,6 @@ workaround:
 	skb_set_network_header(new_skb, skb_network_offset(skb));
 	skb_set_transport_header(new_skb, skb_transport_offset(skb));
 
-	/* TODO: does timestamping need the result in the old skb? */
 	dev_kfree_skb(skb);
 	*s = new_skb;
 


