Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4D62A1688
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgJaLqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgJaLqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96A0920731;
        Sat, 31 Oct 2020 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144784;
        bh=coC2MkhbsCmTxSc28G9JNMoXJoKHXKra6v42o5z4eEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwRdE9eY2vKFjG4LrhGa4LR88f1Wduck9y7E230CodrhcMfugTY5hBblITDBM15Zo
         xffocZL6FKtVRaf+pOHy/uN+T3fjNcE7OOi5bK6dj0RefjlVYIrLkWmH5gcTey0BlS
         3fx+3Mi9d95IYnVTqbVhw0fCM5RL8jT+Hs7Oi5DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.9 61/74] p54: avoid accessing the data mapped to streaming DMA
Date:   Sat, 31 Oct 2020 12:36:43 +0100
Message-Id: <20201031113502.951130106@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>

commit 478762855b5ae9f68fa6ead1edf7abada70fcd5f upstream.

In p54p_tx(), skb->data is mapped to streaming DMA on line 337:
  mapping = pci_map_single(..., skb->data, ...);

Then skb->data is accessed on line 349:
  desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;

This access may cause data inconsistency between CPU cache and hardware.

To fix this problem, ((struct p54_hdr *)skb->data)->req_id is stored in
a local variable before DMA mapping, and then the driver accesses this
local variable instead of skb->data.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200802132949.26788-1-baijiaju@tsinghua.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intersil/p54/p54pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -333,10 +333,12 @@ static void p54p_tx(struct ieee80211_hw
 	struct p54p_desc *desc;
 	dma_addr_t mapping;
 	u32 idx, i;
+	__le32 device_addr;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
+	device_addr = ((struct p54_hdr *)skb->data)->req_id;
 
 	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
 				 DMA_TO_DEVICE);
@@ -350,7 +352,7 @@ static void p54p_tx(struct ieee80211_hw
 
 	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
-	desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;
+	desc->device_addr = device_addr;
 	desc->len = cpu_to_le16(skb->len);
 	desc->flags = 0;
 


