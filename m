Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D93AEF12
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhFUQfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232335AbhFUQdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:33:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5121561418;
        Mon, 21 Jun 2021 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292790;
        bh=MsSNp23Mq1jV3Q5GrB1f+cvgk6IwxVyFRLbJw+MfcV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD/CwHI8kyn6RloAZ9fB7udveCjFYXAepjZZAlrsT0i+dGFJuylv8gQkSv+7/1wt5
         PNerd8LT7ZaZDmpNvMdvHepTiZezIVyZZD1mZjQ3ocniBh7rCVBi9XBNxYSF4886mW
         L+ViZugcoMxQorGmJOFnYCUHtsyycFB6cPWhVrBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 132/146] net: ll_temac: Make sure to free skb when it is completely used
Date:   Mon, 21 Jun 2021 18:16:02 +0200
Message-Id: <20210621154919.931906299@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

commit 6aa32217a9a446275440ee8724b1ecaf1838df47 upstream.

With the skb pointer piggy-backed on the TX BD, we have a simple and
efficient way to free the skb buffer when the frame has been transmitted.
But in order to avoid freeing the skb while there are still fragments from
the skb in use, we need to piggy-back on the TX BD of the skb, not the
first.

Without this, we are doing use-after-free on the DMA side, when the first
BD of a multi TX BD packet is seen as completed in xmit_done, and the
remaining BDs are still being processed.

Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -876,7 +876,6 @@ temac_start_xmit(struct sk_buff *skb, st
 		return NETDEV_TX_OK;
 	}
 	cur_p->phys = cpu_to_be32(skb_dma_addr);
-	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
 		if (++lp->tx_bd_tail >= lp->tx_bd_num)
@@ -915,6 +914,11 @@ temac_start_xmit(struct sk_buff *skb, st
 	}
 	cur_p->app0 |= cpu_to_be32(STS_CTRL_APP0_EOP);
 
+	/* Mark last fragment with skb address, so it can be consumed
+	 * in temac_start_xmit_done()
+	 */
+	ptr_to_txbd((void *)skb, cur_p);
+
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	lp->tx_bd_tail++;
 	if (lp->tx_bd_tail >= lp->tx_bd_num)


