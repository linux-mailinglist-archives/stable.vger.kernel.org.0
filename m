Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AE933B6E1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhCON7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232154AbhCON5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1555364F41;
        Mon, 15 Mar 2021 13:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816672;
        bh=61hwE0aosy0oCTorMejB+6tfBdUSKc8uckX85DtWClM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsVHfcXf+4Cx2237AuAVaT8gTAYqabcF1lEy4dCfJqpkchLFaZjMvbxBut+6Hv/jQ
         D5jghqHa9SPheMo3Dz5DKgqLuRwiktKKGc429Jyd07hjOi2f9Fuf8OUOS9i2GRttIp
         DlVj5AlpL3Sjo1Ju5rcCozCZFrV7xw4Uaw0dSskI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 055/306] net: ethernet: mtk-star-emac: fix wrong unmap in RX handling
Date:   Mon, 15 Mar 2021 14:51:58 +0100
Message-Id: <20210315135509.511797491@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Biao Huang <biao.huang@mediatek.com>

commit 95b39f07a17faef3a9b225248ba449b976e529c8 upstream.

mtk_star_dma_unmap_rx() should unmap the dma_addr of old skb rather than
that of new skb.
Assign new_dma_addr to desc_data.dma_addr after all handling of old skb
ends to avoid unexpected receive side error.

Fixes: f96e9641e92b ("net: ethernet: mtk-star-emac: fix error path in RX handling")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1225,8 +1225,6 @@ static int mtk_star_receive_packet(struc
 		goto push_new_skb;
 	}
 
-	desc_data.dma_addr = new_dma_addr;
-
 	/* We can't fail anymore at this point: it's safe to unmap the skb. */
 	mtk_star_dma_unmap_rx(priv, &desc_data);
 
@@ -1236,6 +1234,9 @@ static int mtk_star_receive_packet(struc
 	desc_data.skb->dev = ndev;
 	netif_receive_skb(desc_data.skb);
 
+	/* update dma_addr for new skb */
+	desc_data.dma_addr = new_dma_addr;
+
 push_new_skb:
 	desc_data.len = skb_tailroom(new_skb);
 	desc_data.skb = new_skb;


