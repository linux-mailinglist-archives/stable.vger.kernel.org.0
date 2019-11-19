Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43FB101533
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfKSFli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbfKSFli (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A07208C3;
        Tue, 19 Nov 2019 05:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142097;
        bh=cOvdCOcKRIUMA17RsSGKk8JBcOVGa9f5VjXMvf73OFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VD/DCjIEdUGu9NR42GOli+DChG2UE8JonAzQoXVWg6SisGKUJqDxhVt7IAV8gu9dt
         S7g1d73TFtQPCmlqrm59tfSsTBaKXntyoEhbCpEjvu54oogfWW5Anb8WRNRCjbNMQx
         7P9H0f520ZbXY5PIKbFxCvUfapDoJquQn3aDj4uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 386/422] Bluetooth: btrsi: fix bt tx timeout issue
Date:   Tue, 19 Nov 2019 06:19:43 +0100
Message-Id: <20191119051424.093781980@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>

[ Upstream commit 7cbfd1e2aad410d96fa6162aeb3f9cff1fecfc58 ]

observed sometimes data is coming with unaligned address from kernel
BT stack. If unaligned address is passed, some data in payload is
stripped when packet is loading to firmware and this results, BT
connection timeout is happening.

sh# hciconfig hci0 up
Can't init device hci0: hci0 command 0x0c03 tx timeout

Fixed this by moving the data to aligned address.

Signed-off-by: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrsi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
index 60d1419590bab..3951f7b238404 100644
--- a/drivers/bluetooth/btrsi.c
+++ b/drivers/bluetooth/btrsi.c
@@ -21,8 +21,9 @@
 #include <net/rsi_91x.h>
 #include <net/genetlink.h>
 
-#define RSI_HEADROOM_FOR_BT_HAL	16
+#define RSI_DMA_ALIGN	8
 #define RSI_FRAME_DESC_SIZE	16
+#define RSI_HEADROOM_FOR_BT_HAL	(RSI_FRAME_DESC_SIZE + RSI_DMA_ALIGN)
 
 struct rsi_hci_adapter {
 	void *priv;
@@ -70,6 +71,16 @@ static int rsi_hci_send_pkt(struct hci_dev *hdev, struct sk_buff *skb)
 		bt_cb(new_skb)->pkt_type = hci_skb_pkt_type(skb);
 		kfree_skb(skb);
 		skb = new_skb;
+		if (!IS_ALIGNED((unsigned long)skb->data, RSI_DMA_ALIGN)) {
+			u8 *skb_data = skb->data;
+			int skb_len = skb->len;
+
+			skb_push(skb, RSI_DMA_ALIGN);
+			skb_pull(skb, PTR_ALIGN(skb->data,
+						RSI_DMA_ALIGN) - skb->data);
+			memmove(skb->data, skb_data, skb_len);
+			skb_trim(skb, skb_len);
+		}
 	}
 
 	return h_adapter->proto_ops->coex_send_pkt(h_adapter->priv, skb,
-- 
2.20.1



