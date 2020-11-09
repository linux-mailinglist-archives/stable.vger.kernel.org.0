Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEDE2ABD1A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgKINnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730500AbgKINAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:00:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A16C420789;
        Mon,  9 Nov 2020 13:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926823;
        bh=Mq9T2I5lz78Cwv1Ns8Lttt5Ot8InoesOyxtqrAR41+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJcDzyGX194LnPxPk5dn6cCU9tMsUpFO3LVySSYE+y7clb6OBcQzJTMXjBWyaYbRW
         iy4icyixd8+z9sBQjezcmGbP4Tu/5sPbOfBAP+7KFVpb80Z4kLZYKlsOJmr+R7Ohw7
         yc6l4Dg2RNvCx1VVkVNJQl2fLSnjcxANaIh14UYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 009/117] p54: avoid accessing the data mapped to streaming DMA
Date:   Mon,  9 Nov 2020 13:53:55 +0100
Message-Id: <20201109125026.092455728@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
@@ -332,10 +332,12 @@ static void p54p_tx(struct ieee80211_hw
 	struct p54p_desc *desc;
 	dma_addr_t mapping;
 	u32 idx, i;
+	__le32 device_addr;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
+	device_addr = ((struct p54_hdr *)skb->data)->req_id;
 
 	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
 				 PCI_DMA_TODEVICE);
@@ -349,7 +351,7 @@ static void p54p_tx(struct ieee80211_hw
 
 	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
-	desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;
+	desc->device_addr = device_addr;
 	desc->len = cpu_to_le16(skb->len);
 	desc->flags = 0;
 


