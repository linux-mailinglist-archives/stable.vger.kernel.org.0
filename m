Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32C03AEE08
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhFUQZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhFUQXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:23:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6575A61363;
        Mon, 21 Jun 2021 16:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292440;
        bh=69/h3NmfheCHr7ttZzHKFKTZxHSCHAoFWctmoomN2W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/NbOgZe6Opj0uw3Ltr1aJ0GfYllICwWrGnm0CLxbCznIfquvAJNEdJ4VLxbjN75j
         72GSZp3RDhUkBcLQ+r1m4Zey3tHoZ6SnGLCqUi6dTgHFz3imvwbd/FaQmupjdikaGk
         HPLi7XD8b/BBF65pXIapNJ+5wABV6zRnEbXHNZrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 74/90] net: ll_temac: Make sure to free skb when it is completely used
Date:   Mon, 21 Jun 2021 18:15:49 +0200
Message-Id: <20210621154906.661716874@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
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
@@ -873,7 +873,6 @@ temac_start_xmit(struct sk_buff *skb, st
 		return NETDEV_TX_OK;
 	}
 	cur_p->phys = cpu_to_be32(skb_dma_addr);
-	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
 		if (++lp->tx_bd_tail >= TX_BD_NUM)
@@ -912,6 +911,11 @@ temac_start_xmit(struct sk_buff *skb, st
 	}
 	cur_p->app0 |= cpu_to_be32(STS_CTRL_APP0_EOP);
 
+	/* Mark last fragment with skb address, so it can be consumed
+	 * in temac_start_xmit_done()
+	 */
+	ptr_to_txbd((void *)skb, cur_p);
+
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	lp->tx_bd_tail++;
 	if (lp->tx_bd_tail >= TX_BD_NUM)


