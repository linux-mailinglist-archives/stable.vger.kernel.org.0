Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD2727880E
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgIYMwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgIYMwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBB5421741;
        Fri, 25 Sep 2020 12:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038343;
        bh=s4ATMnBSYkXOXQrhlpLJ0RE193m51HwvO1xKH0/sLzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAC1K0ScQtCndGa1/GFUjzEpiNNdTjpOLg4o+LCHoBpHnWZweCEWq75ED/b2YZD9E
         iH2c4WkxZPk8Y1HIof3sF3V1VVynme2a/H7W9Tv670LkjcNuSPPTosssMEbDsDZgUl
         KkPdWfPDGXgcOqqooV0Mcqv2ufWhN4+aaGmlg+G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 34/43] net: lantiq: Wake TX queue again
Date:   Fri, 25 Sep 2020 14:48:46 +0200
Message-Id: <20200925124728.728954724@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
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


