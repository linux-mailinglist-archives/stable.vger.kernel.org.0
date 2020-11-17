Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE87F2B642E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733015AbgKQNh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732995AbgKQNh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 957B4207BC;
        Tue, 17 Nov 2020 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620275;
        bh=iaaVi/kG/GEXKUfnpdvNXmq4FIzllGf18xVtxHBoDFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsl6Z9az2DE6pAfNRET3LBihF0UU6OWkdQ8ngYOB0F2v7fOXBe/+/pFnjhEDYOL+h
         dBEfbnJ3fajsQgLXl2LlDVZ7dnaWw+dKloWeySK4G+X3NvdzBcMzzoZZSb+bJhlZKs
         QEcDiwywYdB2WLd9oW6VTYQ8AXjen+8GegxEuLK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 165/255] ch_ktls: Update cheksum information
Date:   Tue, 17 Nov 2020 14:05:05 +0100
Message-Id: <20201117122146.967639603@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>

[ Upstream commit 86716b51d14fc2201938939b323ba3ad99186910 ]

Checksum update was missing in the WR.

Fixes: 429765a149f1 ("chcr: handle partial end part of a record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_ktls.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index c5cce024886ac..026689d091102 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -926,6 +926,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	struct iphdr *ip;
 	int credits;
 	u8 buf[150];
+	u64 cntrl1;
 	void *pos;
 
 	iplen = skb_network_header_len(skb);
@@ -964,22 +965,28 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 			   TXPKT_PF_V(tx_info->adap->pf));
 	cpl->pack = 0;
 	cpl->len = htons(pktlen);
-	/* checksum offload */
-	cpl->ctrl1 = 0;
-
-	pos = cpl + 1;
 
 	memcpy(buf, skb->data, pktlen);
 	if (tx_info->ip_family == AF_INET) {
 		/* we need to correct ip header len */
 		ip = (struct iphdr *)(buf + maclen);
 		ip->tot_len = htons(pktlen - maclen);
+		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		ip6 = (struct ipv6hdr *)(buf + maclen);
 		ip6->payload_len = htons(pktlen - maclen - iplen);
+		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP6);
 #endif
 	}
+
+	cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
+		  TXPKT_IPHDR_LEN_V(iplen);
+	/* checksum offload */
+	cpl->ctrl1 = cpu_to_be64(cntrl1);
+
+	pos = cpl + 1;
+
 	/* now take care of the tcp header, if fin is not set then clear push
 	 * bit as well, and if fin is set, it will be sent at the last so we
 	 * need to update the tcp sequence number as per the last packet.
-- 
2.27.0



