Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117A2450D70
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbhKOR5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:57:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239290AbhKOR4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29639615A4;
        Mon, 15 Nov 2021 17:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997631;
        bh=UvVyMlsxIBSvytMH0I/fv4ddqIKt5Qv/hehfmGPIOwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBX4pa3qRP4sT0xd0clRSnSuL4d0e95jwlOR2nq8kFp/A8p9aYchG9o1G+lB5C29X
         ZiwddazTqAqdlz+6tj6j3O6xrlcYeH7KzcH6ZL+MRADjOH1WWemPMMWNFw22YYAaC4
         LQGNUcxQiAjan6gbZmG3ufkUhOxLNef8aUYsOvLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baochen Qiang <bqiang@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/575] ath11k: Change DMA_FROM_DEVICE to DMA_TO_DEVICE when map reinjected packets
Date:   Mon, 15 Nov 2021 17:58:31 +0100
Message-Id: <20211115165350.133737103@linuxfoundation.org>
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

From: Baochen Qiang <bqiang@codeaurora.org>

[ Upstream commit 86a03dad0f5ad8182ed5fcf7bf3eec71cd96577c ]

For fragmented packets, ath11k reassembles each fragment as a normal
packet and then reinjects it into HW ring. In this case, the DMA
direction should be DMA_TO_DEVICE, not DMA_FROM_DEVICE, otherwise
invalid payload will be reinjected to HW and then delivered to host.
What is more, since arbitrary memory could be allocated to the frame, we
don't know what kind of data is contained in the buffer reinjected.
Thus, as a bad result, private info may be leaked.

Note that this issue is only found on Intel platform.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1
Signed-off-by: Baochen Qiang <bqiang@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210916064617.20006-1-bqiang@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 2bff8eb507d4d..7d6fd8155bb22 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3273,7 +3273,7 @@ static int ath11k_dp_rx_h_defrag_reo_reinject(struct ath11k *ar, struct dp_rx_ti
 
 	paddr = dma_map_single(ab->dev, defrag_skb->data,
 			       defrag_skb->len + skb_tailroom(defrag_skb),
-			       DMA_FROM_DEVICE);
+			       DMA_TO_DEVICE);
 	if (dma_mapping_error(ab->dev, paddr))
 		return -ENOMEM;
 
@@ -3338,7 +3338,7 @@ err_free_idr:
 	spin_unlock_bh(&rx_refill_ring->idr_lock);
 err_unmap_dma:
 	dma_unmap_single(ab->dev, paddr, defrag_skb->len + skb_tailroom(defrag_skb),
-			 DMA_FROM_DEVICE);
+			 DMA_TO_DEVICE);
 	return ret;
 }
 
-- 
2.33.0



