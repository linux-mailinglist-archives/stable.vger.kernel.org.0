Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0DB483303
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiACOcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:32:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60116 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiACOap (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC3A8B80EF6;
        Mon,  3 Jan 2022 14:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0AEC36AED;
        Mon,  3 Jan 2022 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220243;
        bh=Goj2JFIB+X4sTeoEYCvsPRk0fpH2kSWZeV7RcRz7v5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSQTu2TBgDPGUccSpvloRTw6z8+HtTD6OfO/UIV0hWBiy7DvoIpou8s4Q/LQgTNw8
         Hp4XmyotK7k2gz/X6s90gRhQbB1KBwqaab8MP5WpQp6y+V4F5tiJkNHKk7Ua3x2egG
         OJvLJOOp8cWODDvRTigoL6O5j3Mf411ELvFnQBVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/48] net: lantiq_xrx200: fix statistics of received bytes
Date:   Mon,  3 Jan 2022 15:23:58 +0100
Message-Id: <20220103142054.188635921@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 5be60a945329d82f06fc755a43eeefbfc5f77d72 ]

Received frames have FCS truncated. There is no need
to subtract FCS length from the statistics.

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 072075bc60ee9..500511b72ac60 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -209,7 +209,7 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	skb->protocol = eth_type_trans(skb, net_dev);
 	netif_receive_skb(skb);
 	net_dev->stats.rx_packets++;
-	net_dev->stats.rx_bytes += len - ETH_FCS_LEN;
+	net_dev->stats.rx_bytes += len;
 
 	return 0;
 }
-- 
2.34.1



