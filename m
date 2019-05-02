Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3C411ED7
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfEBPlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbfEBP2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:28:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DAA2081C;
        Thu,  2 May 2019 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810929;
        bh=V1HWFjRUq82B7czqaNCXtkC+enHSA7l4SPNztlvxQ20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ninHftC0WeHfQYnjwcOlhp7KCWhAzMSxZLQiNcehq8A1vrSZctIAIMyl4qu+iCwOZ
         zKNsJ5nHbtxFT/tAVi2+ldPPA2GGIfnrGjnAVvESh6x9IDH4zZDVG7toc8khLz8mZ3
         DGU0OkeVN1DLIUaUSgy5D5RZ0zY9lR+1ckNkU7Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 011/101] mt76x02: fix hdr pointer in write txwi for USB
Date:   Thu,  2 May 2019 17:20:13 +0200
Message-Id: <20190502143340.859568458@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7b25d3b8e485c7721cba9c71b44d1c286e61c8e7 ]

Since we add txwi at the begining of skb->data, it no longer point
to ieee80211_hdr. This breaks settings TS bit for probe response and
beacons.

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 81970cf777c0..8cafa5a749ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -81,8 +81,9 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 
 	mt76x02_insert_hdr_pad(skb);
 
-	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
+	txwi = (struct mt76x02_txwi *)(skb->data - sizeof(struct mt76x02_txwi));
 	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
+	skb_push(skb, sizeof(struct mt76x02_txwi));
 
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
-- 
2.19.1



