Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0638178130
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbgCCSBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387879AbgCCSBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9263C206E6;
        Tue,  3 Mar 2020 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258468;
        bh=CipgCvMOadAXeyMQ8M9jPx0Fsefy/L4eliHKRLT/zQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4Mzdbgyom5tRCZeOXlQ47VwU8CfI9v9Xd6gee1uv3phXdlND8isSYU6lXD+PSVfS
         08fFWTC4q2UZjBypAikmehzQWHMH9qqJRTRPR+L/DuTGmbR2J7VZy1pSZ3Csjomvw9
         cfR27gM9RFpMQi9rRSe6TLjI8xCx/u4NEqxdugMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 59/87] hv_netvsc: Fix unwanted wakeup in netvsc_attach()
Date:   Tue,  3 Mar 2020 18:43:50 +0100
Message-Id: <20200303174355.668124144@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

commit f6f13c125e05603f68f5bf31f045b95e6d493598 upstream.

When netvsc_attach() is called by operations like changing MTU, etc.,
an extra wakeup may happen while netvsc_attach() calling
rndis_filter_device_add() which sends rndis messages when queue is
stopped in netvsc_detach(). The completion message will wake up queue 0.

We can reproduce the issue by changing MTU etc., then the wake_queue
counter from "ethtool -S" will increase beyond stop_queue counter:
     stop_queue: 0
     wake_queue: 1
The issue causes queue wake up, and counter increment, no other ill
effects in current code. So we didn't see any network problem for now.

To fix this, initialize tx_disable to true, and set it to false when
the NIC is ready to be attached or registered.

Fixes: 7b2ee50c0cd5 ("hv_netvsc: common detach logic")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/hyperv/netvsc.c     |    2 +-
 drivers/net/hyperv/netvsc_drv.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -110,7 +110,7 @@ static struct netvsc_device *alloc_net_d
 
 	init_waitqueue_head(&net_device->wait_drain);
 	net_device->destroy = false;
-	net_device->tx_disable = false;
+	net_device->tx_disable = true;
 
 	net_device->max_pkt = RNDIS_MAX_PKT_DEFAULT;
 	net_device->pkt_align = RNDIS_PKT_ALIGN_DEFAULT;
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -984,6 +984,7 @@ static int netvsc_attach(struct net_devi
 	}
 
 	/* In any case device is now ready */
+	nvdev->tx_disable = false;
 	netif_device_attach(ndev);
 
 	/* Note: enable and attach happen when sub-channels setup */
@@ -2336,6 +2337,8 @@ static int netvsc_probe(struct hv_device
 	else
 		net->max_mtu = ETH_DATA_LEN;
 
+	nvdev->tx_disable = false;
+
 	ret = register_netdevice(net);
 	if (ret != 0) {
 		pr_err("Unable to register netdev.\n");


