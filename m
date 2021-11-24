Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC7045C04F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346181AbhKXNGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344777AbhKXNFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:05:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 688796138D;
        Wed, 24 Nov 2021 12:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757440;
        bh=kFSYdfk5uYVDZ1jLzKOOBO3ryZWHY0dCcLWqWkdUZd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1hP/3+8KG5oNcRyIpp6BdIABp2B7KWXWkHSlICzHOL0fGyUHZEYKSBF8ROxb1phf
         GLdKxAACtKbZreDL4lXV6jtG04PNg6tpXKFwQd/0UpqxcU/utw2AX1h5L6hX0onbNx
         1a8QZQieWc9EkcyxTHs6zFi24DT4Oj71yuj97o7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/323] wcn36xx: add proper DMA memory barriers in rx path
Date:   Wed, 24 Nov 2021 12:56:00 +0100
Message-Id: <20211124115724.685199899@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Li <benl@squareup.com>

[ Upstream commit 9bfe38e064af5decba2ffce66a2958ab8b10eaa4 ]

This is essentially exactly following the dma_wmb()/dma_rmb() usage
instructions in Documentation/memory-barriers.txt.

The theoretical races here are:

1. DXE (the DMA Transfer Engine in the Wi-Fi subsystem) seeing the
dxe->ctrl & WCN36xx_DXE_CTRL_VLD write before the dxe->dst_addr_l
write, thus performing DMA into the wrong address.

2. CPU reading dxe->dst_addr_l before DXE unsets dxe->ctrl &
WCN36xx_DXE_CTRL_VLD. This should generally be harmless since DXE
doesn't write dxe->dst_addr_l (no risk of freeing the wrong skb).

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Benjamin Li <benl@squareup.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211023001528.3077822-1-benl@squareup.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 06cfe8d311f39..657525988d1ee 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -565,6 +565,10 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	dxe = ctl->desc;
 
 	while (!(READ_ONCE(dxe->ctrl) & WCN36xx_DXE_CTRL_VLD)) {
+		/* do not read until we own DMA descriptor */
+		dma_rmb();
+
+		/* read/modify DMA descriptor */
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
 		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl, GFP_ATOMIC);
@@ -575,9 +579,15 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 			dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
 					DMA_FROM_DEVICE);
 			wcn36xx_rx_skb(wcn, skb);
-		} /* else keep old skb not submitted and use it for rx DMA */
+		}
+		/* else keep old skb not submitted and reuse it for rx DMA
+		 * (dropping the packet that it contained)
+		 */
 
+		/* flush descriptor changes before re-marking as valid */
+		dma_wmb();
 		dxe->ctrl = ctrl;
+
 		ctl = ctl->next;
 		dxe = ctl->desc;
 	}
-- 
2.33.0



