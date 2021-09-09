Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B89404E56
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245574AbhIIMLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349736AbhIIMFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:05:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2006617E5;
        Thu,  9 Sep 2021 11:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188040;
        bh=8SccjHQBBdBLX2oYdc8x9YK5U1X7hTEEkIPQP0ZnWro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REVgcLh2Vyu2Pag7m7EEo2B6jlzwTyfJomXWlpikD9mfIzYs/LxZs+KgpVv4pdTqb
         iRioiE6YML6SRpCyh9YTC/I0opiqljQnyMPhpmTx+O7GJI/TQLrqiCZO9DhvA03jK+
         /lYOyCsH33GB+v7j1dSdiw25N6LNENrDUkpL/OOw2X50ktCTMIZilIVs5iqCpA5D4Y
         lf2o5Js+1GkzkYft+IvTXNosRUg/XGGEvmberv6x9qXnAUDxNjKIsfL0p8AUFqVmMC
         d6wJV3tyEC5ePY8TK5UO4cCMl4X0X0b4OOwPi+z+0s+qoftBrygQOpV2skbwfSS6c8
         NQIYxRzOCM0kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Brooke Basile <brookebasile@gmail.com>,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 034/219] usb: gadget: u_ether: fix a potential null pointer dereference
Date:   Thu,  9 Sep 2021 07:43:30 -0400
Message-Id: <20210909114635.143983-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index d1d044d9f859..85a3f6d4b5af 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -492,8 +492,9 @@ static netdev_tx_t eth_start_xmit(struct sk_buff *skb,
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

