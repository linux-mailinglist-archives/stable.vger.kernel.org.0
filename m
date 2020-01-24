Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C729148487
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389759AbgAXLLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388450AbgAXLLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:11:30 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8769920708;
        Fri, 24 Jan 2020 11:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864290;
        bh=G4tfkGkVxGfOb6rWktH3tl5zNrvKAE42h5/a4FwKegY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF5HxFZcTl6LR0IblEz/QCFl84thamBRZwjfpwQ2kip78pBlVetwBv4HpSecgLr1O
         zAl1YCGqNn9HSc2XwK77SLjKoDxPOpyEPdI6jjPiCM6r+SOiRlk2EefWH4St887ZJx
         6lTyL9zK/R/GTKB9yTbQ1H5pcUGlYkUkAo2ygi0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/639] mt76: usb: fix possible memory leak in mt76u_buf_free
Date:   Fri, 24 Jan 2020 10:26:13 +0100
Message-Id: <20200124093112.459167813@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit cb83585e1121bd6d6c039cf09fa32380bf8b6258 ]

Move q->ndesc initialization before the for loop in mt76u_alloc_rx
since otherwise allocated urbs will not be freed in mt76u_buf_free
Double-check scatterlist pointer in mt76u_buf_free

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 8d40e92fb6f27..dcf927de65f39 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -273,10 +273,16 @@ EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
 	struct urb *urb = buf->urb;
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < urb->num_sgs; i++)
-		skb_free_frag(sg_virt(&urb->sg[i]));
+	for (i = 0; i < urb->num_sgs; i++) {
+		sg = &urb->sg[i];
+		if (!sg)
+			continue;
+
+		skb_free_frag(sg_virt(sg));
+	}
 	usb_free_urb(buf->urb);
 }
 EXPORT_SYMBOL_GPL(mt76u_buf_free);
@@ -478,7 +484,8 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 		nsgs = 1;
 	}
 
-	for (i = 0; i < MT_NUM_RX_ENTRIES; i++) {
+	q->ndesc = MT_NUM_RX_ENTRIES;
+	for (i = 0; i < q->ndesc; i++) {
 		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
 				      nsgs, q->buf_size,
 				      SKB_WITH_OVERHEAD(q->buf_size),
@@ -486,7 +493,6 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 		if (err < 0)
 			return err;
 	}
-	q->ndesc = MT_NUM_RX_ENTRIES;
 
 	return mt76u_submit_rx_buffers(dev);
 }
-- 
2.20.1



