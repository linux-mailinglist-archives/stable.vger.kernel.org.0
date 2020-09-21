Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8714127305D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgIUQfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728806AbgIUQeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BAF2239A1;
        Mon, 21 Sep 2020 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706085;
        bh=WR+g6BJmosRtwJSoMvEhD8ZZWYEATjLLIsh6e4mzX3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zmu8crhSOmpUv13FI3MWc8ow4xHMiubgK7dvf2+QRcwoGHC1Tmg+oTTZHkRj5IeUO
         UHc5TPklGjZssbEXrYhWr90hwoV2kWKRY2aQpZ0u4gpiD3s4yx/SGhXvNls+vopWd9
         XjGhAZqqtOuk//439R7t71Mh26fstY2TsjoCn/Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/70] drivers/net/wan/lapbether: Set network_header before transmitting
Date:   Mon, 21 Sep 2020 18:27:09 +0200
Message-Id: <20200921162035.551353129@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 91244d108441013b7367b3b4dcc6869998676473 ]

Set the skb's network_header before it is passed to the underlying
Ethernet device for transmission.

This patch fixes the following issue:

When we use this driver with AF_PACKET sockets, there would be error
messages of:
   protocol 0805 is buggy, dev (Ethernet interface name)
printed in the system "dmesg" log.

This is because skbs passed down to the Ethernet device for transmission
don't have their network_header properly set, and the dev_queue_xmit_nit
function in net/core/dev.c complains about this.

Reason of setting the network_header to this place (at the end of the
Ethernet header, and at the beginning of the Ethernet payload):

Because when this driver receives an skb from the Ethernet device, the
network_header is also set at this place.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 5befc7f3f0e7a..c6db9a4e7c457 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -213,6 +213,8 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 	skb->dev = dev = lapbeth->ethdev;
 
+	skb_reset_network_header(skb);
+
 	dev_hard_header(skb, dev, ETH_P_DEC, bcast_addr, NULL, 0);
 
 	dev_queue_xmit(skb);
-- 
2.25.1



