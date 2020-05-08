Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14E61CAEB7
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgEHMq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbgEHMq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99F4208D6;
        Fri,  8 May 2020 12:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941986;
        bh=XW0RkQR6yn1N3zX53QBJtLJWccqmnQoeGLO076VMjwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZ9qyT/oEEKKcOZRqjrDwpNLvOKHIJw8RSEbBlaWy6cK1GgURnCadL4o4TbT0ZYKG
         lwXgyfNKlx/PhCuCtnRj14dHI1mQjz3+py0OVEy5K1C5z4Swjo3HNW70MeoeGWSfIR
         75NP7inzSLTDY5LtMuDNQcbCNnQaFRZc31qsHZpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petri Gynther <pgynther@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 251/312] net: bcmgenet: fix skb_len in bcmgenet_xmit_single()
Date:   Fri,  8 May 2020 14:34:02 +0200
Message-Id: <20200508123142.066988233@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petri Gynther <pgynther@google.com>

commit 7dd399130efb5a454daf24075b7563d197114e39 upstream.

skb_len needs to be skb_headlen(skb) in bcmgenet_xmit_single().

Fragmented skbs can have only Ethernet + IP + TCP headers (14+20+20=54 bytes)
in the linear buffer, followed by the rest in fragments. Bumping skb_len to
ETH_ZLEN would be incorrect for this case, as it would introduce garbage
between TCP header and the fragment data.

This also works with regular/non-fragmented small packets < ETH_ZLEN bytes.
Successfully tested this on GENETv3 with 42-byte ARP frames.

For testing, I used:
ethtool -K eth0 tx-checksum-ipv4 off
ethtool -K eth0 tx-checksum-ipv6 off
echo 0 > /proc/sys/net/ipv4/tcp_timestamps

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Petri Gynther <pgynther@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1346,7 +1346,7 @@ static int bcmgenet_xmit_single(struct n
 
 	tx_cb_ptr->skb = skb;
 
-	skb_len = skb_headlen(skb) < ETH_ZLEN ? ETH_ZLEN : skb_headlen(skb);
+	skb_len = skb_headlen(skb);
 
 	mapping = dma_map_single(kdev, skb->data, skb_len, DMA_TO_DEVICE);
 	ret = dma_mapping_error(kdev, mapping);


