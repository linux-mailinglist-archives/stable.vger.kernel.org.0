Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C6D66CA8
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfGLMVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727615AbfGLMVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870C22166E;
        Fri, 12 Jul 2019 12:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934095;
        bh=JEl2xMhTXjcFazKlCKNupjlOtV5Zgb3boqeMf0NtShA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNHIoPfh1sRJovV9Wh/7n3zwfep09WvgRov2S5VqO+UgYG2Mu0aMwGQqYhZ8pqtwm
         Fgq2yOf9MNMN0ZocFUlPCC1TGjKVDn2rY9zoDq5r7zeWt2jfoN6kdHxGM44GfaFPga
         NjLq1kWk/b+1qzPaNCIloLuZW9jSfQz7ljpzBprc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Reinhard Speyerer <rspmn@arcor.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/91] qmi_wwan: add support for QMAP padding in the RX path
Date:   Fri, 12 Jul 2019 14:18:45 +0200
Message-Id: <20190712121623.738179149@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 61356088ace1866a847a727d4d40da7bf00b67fc ]

The QMAP code in the qmi_wwan driver is based on the CodeAurora GobiNet
driver which does not process QMAP padding in the RX path correctly.
Add support for QMAP padding to qmimux_rx_fixup() according to the
description of the rmnet driver.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index e657d8947125..090227118d3d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -153,7 +153,7 @@ static bool qmimux_has_slaves(struct usbnet *dev)
 
 static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
-	unsigned int len, offset = 0;
+	unsigned int len, offset = 0, pad_len, pkt_len;
 	struct qmimux_hdr *hdr;
 	struct net_device *net;
 	struct sk_buff *skbn;
@@ -171,10 +171,16 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		if (hdr->pad & 0x80)
 			goto skip;
 
+		/* extract padding length and check for valid length info */
+		pad_len = hdr->pad & 0x3f;
+		if (len == 0 || pad_len >= len)
+			goto skip;
+		pkt_len = len - pad_len;
+
 		net = qmimux_find_dev(dev, hdr->mux_id);
 		if (!net)
 			goto skip;
-		skbn = netdev_alloc_skb(net, len);
+		skbn = netdev_alloc_skb(net, pkt_len);
 		if (!skbn)
 			return 0;
 		skbn->dev = net;
@@ -191,7 +197,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			goto skip;
 		}
 
-		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, len);
+		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, pkt_len);
 		if (netif_rx(skbn) != NET_RX_SUCCESS)
 			return 0;
 
-- 
2.20.1



