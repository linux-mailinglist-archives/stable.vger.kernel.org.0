Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7F649A8CB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380552AbiAYDOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345378AbiAXTJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:09:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B10C08C5C8;
        Mon, 24 Jan 2022 11:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4270B60B88;
        Mon, 24 Jan 2022 19:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF9CC340E5;
        Mon, 24 Jan 2022 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050929;
        bh=QCtmgIcGnpfCyyzcV5Uihv/WnmLZGb5ICQw+jPbJ7zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfOllt7y4kt6cl8JiDFcmBh3RD8gXxTYUNJid4Je3l8LtVJFw8MQ00QzYYEi8PemF
         RWrAZTJfj5801+6xC66HOENXaqLwlucRaorV+1gmCOMqzMJ3sL6hOhvJOIQVleG6K0
         b/o9yiMOfRupgMoIlUwX3w7UgMNOqsclc44l2KHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Spencer <aspencer@spacex.com>,
        Jim Gruen <jgruen@spacex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 149/157] gianfar: simplify FCS handling and fix memory leak
Date:   Mon, 24 Jan 2022 19:43:59 +0100
Message-Id: <20220124183937.491196016@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Spencer <aspencer@spacex.com>

commit d903ec77118c09f93a610b384d83a6df33a64fe6 upstream.

Previously, buffer descriptors containing only the frame check sequence
(FCS) were skipped and not added to the skb. However, the page reference
count was still incremented, leading to a memory leak.

Fixing this inside gfar_add_rx_frag() is difficult due to reserved
memory handling and page reuse. Instead, move the FCS handling to
gfar_process_frame() and trim off the FCS before passing the skb up the
networking stack.

Signed-off-by: Andy Spencer <aspencer@spacex.com>
Signed-off-by: Jim Gruen <jgruen@spacex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2939,29 +2939,17 @@ static bool gfar_add_rx_frag(struct gfar
 {
 	int size = lstatus & BD_LENGTH_MASK;
 	struct page *page = rxb->page;
-	bool last = !!(lstatus & BD_LFLAG(RXBD_LAST));
-
-	/* Remove the FCS from the packet length */
-	if (last)
-		size -= ETH_FCS_LEN;
 
 	if (likely(first)) {
 		skb_put(skb, size);
 	} else {
 		/* the last fragments' length contains the full frame length */
-		if (last)
+		if (lstatus & BD_LFLAG(RXBD_LAST))
 			size -= skb->len;
 
-		/* Add the last fragment if it contains something other than
-		 * the FCS, otherwise drop it and trim off any part of the FCS
-		 * that was already received.
-		 */
-		if (size > 0)
-			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
-					rxb->page_offset + RXBUF_ALIGNMENT,
-					size, GFAR_RXB_TRUESIZE);
-		else if (size < 0)
-			pskb_trim(skb, skb->len + size);
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
+				rxb->page_offset + RXBUF_ALIGNMENT,
+				size, GFAR_RXB_TRUESIZE);
 	}
 
 	/* try reuse page */
@@ -3074,6 +3062,9 @@ static void gfar_process_frame(struct ne
 	if (priv->padding)
 		skb_pull(skb, priv->padding);
 
+	/* Trim off the FCS */
+	pskb_trim(skb, skb->len - ETH_FCS_LEN);
+
 	if (ndev->features & NETIF_F_RXCSUM)
 		gfar_rx_checksum(skb, fcb);
 


