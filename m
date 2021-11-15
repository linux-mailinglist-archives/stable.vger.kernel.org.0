Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E4E450E15
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbhKOSKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239965AbhKOSFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4037632F9;
        Mon, 15 Nov 2021 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998050;
        bh=gYFZ0b5aZN9Ni542rnRuOLNtYn27+QfJj0MpK/5OOlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snc6g+WC+BQnsWl/3QKdHWr97kb2e7F5JD+ps4wxGt7jjTmqcU+wkDhJx8MAjkAs5
         6ofW5s5HfoXPehR2wSkXh95HBcy2XOlJDFRPBTqp47knKYblQrJyXjlcaLp7/vUWLk
         f06+ku6VHi7yfd92pRBudK7mJD2ain9lG7Y5Q8BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 370/575] wcn36xx: add proper DMA memory barriers in rx path
Date:   Mon, 15 Nov 2021 18:01:35 +0100
Message-Id: <20211115165356.588272972@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 70c46c327512f..cf4eb0fb28151 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -606,6 +606,10 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	dxe = ctl->desc;
 
 	while (!(READ_ONCE(dxe->ctrl) & WCN36xx_DXE_CTRL_VLD)) {
+		/* do not read until we own DMA descriptor */
+		dma_rmb();
+
+		/* read/modify DMA descriptor */
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
 		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl, GFP_ATOMIC);
@@ -616,9 +620,15 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
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



