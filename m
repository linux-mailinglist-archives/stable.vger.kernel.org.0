Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A878640DFC4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhIPQNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232885AbhIPQMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:12:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE0161357;
        Thu, 16 Sep 2021 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808557;
        bh=qvQw3czIoSzqsNb0fcpfM4nAqg3/+tvIWVs+0JqcKCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfKQ78v4fEOFZwnPxjuWWWtiCI5WpEHyfbo/tG7Umhp2gLLu3AkjTliA0nf+IPCw9
         cLLRfypKkZl3vEL+KHKHF6wbwXiI68k6GFaDFwtA6AkGZnh/yLdKyPPcxxQW4Tp0EU
         2tBGa5/RLqrXIrooi2gisdsRpxhH2W5eEW/Q4tP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brooke Basile <brookebasile@gmail.com>,
        "Bryan ODonoghue" <bryan.odonoghue@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/306] usb: gadget: u_ether: fix a potential null pointer dereference
Date:   Thu, 16 Sep 2021 17:57:59 +0200
Message-Id: <20210916155758.616987541@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index c019f2b0c0af..a9cb647bac6f 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -491,8 +491,9 @@ static netdev_tx_t eth_start_xmit(struct sk_buff *skb,
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



