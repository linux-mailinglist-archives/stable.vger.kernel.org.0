Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EAB2787D0
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgIYMuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728553AbgIYMuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BECC206DB;
        Fri, 25 Sep 2020 12:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038237;
        bh=s4ATMnBSYkXOXQrhlpLJ0RE193m51HwvO1xKH0/sLzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18sL+Sboh9vE+EaN/gtT/uJli3JyFs5DurGjYJ91fvJGRvfDRe8x2lHYsflcEha8w
         I3sX33VBs/hMTu7z0AZ1Xc5j7nd57D033wG1kMgW6NklOuTR7ji29m4SvfBy/uJxO9
         8u7XG1y74YLKLPtklzUCXgqhqJtiA71RUnbu3DSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 35/56] net: lantiq: Wake TX queue again
Date:   Fri, 25 Sep 2020 14:48:25 +0200
Message-Id: <20200925124733.132024997@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit dea36631e6f186d4b853af67a4aef2e35cfa8bb7 ]

The call to netif_wake_queue() when the TX descriptors were freed was
missing. When there are no TX buffers available the TX queue will be
stopped, but it was not started again when they are available again,
this is fixed in this patch.

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/lantiq_xrx200.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -268,6 +268,9 @@ static int xrx200_tx_housekeeping(struct
 	net_dev->stats.tx_bytes += bytes;
 	netdev_completed_queue(ch->priv->net_dev, pkts, bytes);
 
+	if (netif_queue_stopped(net_dev))
+		netif_wake_queue(net_dev);
+
 	if (pkts < budget) {
 		napi_complete(&ch->napi);
 		ltq_dma_enable_irq(&ch->dma);


