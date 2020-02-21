Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2AF1676DB
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgBUH6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbgBUH6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E4E206ED;
        Fri, 21 Feb 2020 07:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271920;
        bh=72jwIr70tZSmKLso6PZnaN8QwHlfCrUagBq8IFNznWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWPqGFfghfU6inSkLCqrmz8fP2VHVrXFCN0F19mxGPJBc3bXPmliIBbRROxBY2RCa
         4J65nOj+2eMf3o53zfjBEAYmF81TpJ7hAwVAwmdNUHjRu96duAllOB97XvM3pgGDlM
         ZfEbcU5rvFUaSlqtnf/nqtAiTHoOIkz9ZpQ5Awu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 347/399] rtw88: fix potential NULL skb access in TX ISR
Date:   Fri, 21 Feb 2020 08:41:12 +0100
Message-Id: <20200221072434.452782197@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

[ Upstream commit f4f84ff8377d4cedf18317747bc407b2cf657d0f ]

Sometimes the TX queue may be empty and we could possible
dequeue a NULL pointer, crash the kernel. If the skb is NULL
then there is nothing to do, just leave the ISR.

And the TX queue should not be empty here, so print an error
to see if there is anything wrong for DMA ring.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a58e8276a41a3..a6746b5a9ff2d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -832,6 +832,11 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 
 	while (count--) {
 		skb = skb_dequeue(&ring->queue);
+		if (!skb) {
+			rtw_err(rtwdev, "failed to dequeue %d skb TX queue %d, BD=0x%08x, rp %d -> %d\n",
+				count, hw_queue, bd_idx, ring->r.rp, cur_rp);
+			break;
+		}
 		tx_data = rtw_pci_get_tx_data(skb);
 		pci_unmap_single(rtwpci->pdev, tx_data->dma, skb->len,
 				 PCI_DMA_TODEVICE);
-- 
2.20.1



