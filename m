Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08454F556A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390493AbfKHTCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732905AbfKHTCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8366120650;
        Fri,  8 Nov 2019 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239735;
        bh=j+MyTQC93gaRHL2LgewniO9lqgw9dkID6sNY6VVF/Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSaQakA0KJ24jpTDWYVB/XEAvBjoSFkDWposbo/0NXQDBga8GPRxMh/0AOS8l/FMv
         4r9+RfsmQdhS9kAg9xcFGX1wyHlxu6KlGynFo0mezjgay0DFaZ7xit9H25zjAEzHFI
         g6DzB4E88BDUZ7b604PZJG528++R4nJC31sprtpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 44/79] net: ethernet: ftgmac100: Fix DMA coherency issue with SW checksum
Date:   Fri,  8 Nov 2019 19:50:24 +0100
Message-Id: <20191108174811.488423255@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit 88824e3bf29a2fcacfd9ebbfe03063649f0f3254 ]

We are calling the checksum helper after the dma_map_single()
call to map the packet. This is incorrect as the checksumming
code will touch the packet from the CPU. This means the cache
won't be properly flushes (or the bounce buffering will leave
us with the unmodified packet to DMA).

This moves the calculation of the checksum & vlan tags to
before the DMA mapping.

This also has the side effect of fixing another bug: If the
checksum helper fails, we goto "drop" to drop the packet, which
will not unmap the DMA mapping.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Fixes: 05690d633f30 ("ftgmac100: Upgrade to NETIF_F_HW_CSUM")
Reviewed-by: Vijay Khemka <vijaykhemka@fb.com>
Tested-by: Vijay Khemka <vijaykhemka@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -739,6 +739,18 @@ static int ftgmac100_hard_start_xmit(str
 	 */
 	nfrags = skb_shinfo(skb)->nr_frags;
 
+	/* Setup HW checksumming */
+	csum_vlan = 0;
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    !ftgmac100_prep_tx_csum(skb, &csum_vlan))
+		goto drop;
+
+	/* Add VLAN tag */
+	if (skb_vlan_tag_present(skb)) {
+		csum_vlan |= FTGMAC100_TXDES1_INS_VLANTAG;
+		csum_vlan |= skb_vlan_tag_get(skb) & 0xffff;
+	}
+
 	/* Get header len */
 	len = skb_headlen(skb);
 
@@ -765,19 +777,6 @@ static int ftgmac100_hard_start_xmit(str
 	if (nfrags == 0)
 		f_ctl_stat |= FTGMAC100_TXDES0_LTS;
 	txdes->txdes3 = cpu_to_le32(map);
-
-	/* Setup HW checksumming */
-	csum_vlan = 0;
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    !ftgmac100_prep_tx_csum(skb, &csum_vlan))
-		goto drop;
-
-	/* Add VLAN tag */
-	if (skb_vlan_tag_present(skb)) {
-		csum_vlan |= FTGMAC100_TXDES1_INS_VLANTAG;
-		csum_vlan |= skb_vlan_tag_get(skb) & 0xffff;
-	}
-
 	txdes->txdes1 = cpu_to_le32(csum_vlan);
 
 	/* Next descriptor */


