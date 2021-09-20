Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF06411AE2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244287AbhITQxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244776AbhITQvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3348061252;
        Mon, 20 Sep 2021 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156569;
        bh=sjCbB48lyOSm12lMdVov5xle5CKJmy894Ol1fWAUADQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+iuHvsAPtckj3/H2eXP9K1Dbe2SM0BCspacMZ9itdcV5riSzS62PTDpYJhMjXtHk
         HZCmYdcbtA2PcyShKsSoCy3i1hFCA9AW572FoBfu6EDm69nuBF8CH8TfazwBt5gsj6
         I169v/d866Q8PeW/UJ9jmLZLjlddfCFnjZNy5q8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brooke Basile <brookebasile@gmail.com>,
        "Bryan ODonoghue" <bryan.odonoghue@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 092/133] usb: gadget: u_ether: fix a potential null pointer dereference
Date:   Mon, 20 Sep 2021 18:42:50 +0200
Message-Id: <20210920163915.651219302@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 8ae01239609b29ec2eff55967c8e0fe3650cfa09 ]

f_ncm tx timeout can call us with null skb to flush
a pending frame.  In this case skb is NULL to begin
with but ceases to be null after dev->wrap() completes.

In such a case in->maxpacket will be read, even though
we've failed to check that 'in' is not NULL.

Though I've never observed this fail in practice,
however the 'flush operation' simply does not make sense with
a null usb IN endpoint - there's nowhere to flush to...
(note that we're the gadget/device, and IN is from the point
 of view of the host, so here IN actually means outbound...)

Cc: Brooke Basile <brookebasile@gmail.com>
Cc: "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20210701114834.884597-6-zenczykowski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_ether.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 46c50135ef9f..4bc95ac3d448 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -507,8 +507,9 @@ static netdev_tx_t eth_start_xmit(struct sk_buff *skb,
 	}
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	if (skb && !in) {
-		dev_kfree_skb_any(skb);
+	if (!in) {
+		if (skb)
+			dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.30.2



