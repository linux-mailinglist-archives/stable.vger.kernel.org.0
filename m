Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCC72A1599
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgJaLgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbgJaLgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:36:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB6DC22228;
        Sat, 31 Oct 2020 11:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144180;
        bh=QGqN73TlyPV9Esx6Em0+u7wW5ISeEhOcwbfgUOltegY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo5dTWW3F0LSjlDtBbgmFY/ub2oPyyfWezmHaaMldfaqG365Ho0LTNUgy0ynvw2kx
         9cRY3ToS7d0cm+IxOU6tiNIy1+2ozvcHxBD9YfmuIbXU3c1h9XRXUlaZ9uSsdT3CxX
         GzK94NjGFVpHA2A7kofkmGcbj9hFofVp8dVGi9CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 36/49] p54: avoid accessing the data mapped to streaming DMA
Date:   Sat, 31 Oct 2020 12:35:32 +0100
Message-Id: <20201031113457.183530530@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
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
@@ -329,10 +329,12 @@ static void p54p_tx(struct ieee80211_hw
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
@@ -346,7 +348,7 @@ static void p54p_tx(struct ieee80211_hw
 
 	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
-	desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;
+	desc->device_addr = device_addr;
 	desc->len = cpu_to_le16(skb->len);
 	desc->flags = 0;
 


