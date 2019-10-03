Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED6CAA77
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbfJCRF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392384AbfJCQir (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 120202070B;
        Thu,  3 Oct 2019 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120726;
        bh=/QZ43/W/Cy9WuI7fzA5ePZm73v8V4eY8UHAZpiVx6ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRAheUaStKiPxqRuJT0viAdjy1W/KwDV63DkNshqf8Z4wPCdatuL+mERo6lQE61Z9
         TATy6kimoNqOxshU1FFHk5u+TJI1Ffr/HA/vVPo6c58hNfOtyTGkpU+Tl7g55j0xry
         3MBaptL5wetIiVGub+8/FS+aUoUr4gj3ipSVNld4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit <benoit.sansoni@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 016/344] skge: fix checksum byte order
Date:   Thu,  3 Oct 2019 17:49:41 +0200
Message-Id: <20191003154541.689473938@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 5aafeb74b5bb65b34cc87c7623f9fa163a34fa3b ]

Running old skge driver on PowerPC causes checksum errors
because hardware reported 1's complement checksum is in little-endian
byte order.

Reported-by: Benoit <benoit.sansoni@gmail.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/skge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3108,7 +3108,7 @@ static struct sk_buff *skge_rx_get(struc
 	skb_put(skb, len);
 
 	if (dev->features & NETIF_F_RXCSUM) {
-		skb->csum = csum;
+		skb->csum = le16_to_cpu(csum);
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
 


