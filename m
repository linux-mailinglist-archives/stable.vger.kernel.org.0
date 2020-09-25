Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F640278832
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgIYMxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbgIYMxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29EBF206DB;
        Fri, 25 Sep 2020 12:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038411;
        bh=MRzBQckpmRJlzp2heEROamiSWfyqx3BWg29J4CRz/4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9ddGr1yGdCoZyhSbiYPh1gPpadzP9yOucqt+mbKwav5RSUwWjb6kQAL0vL0kXzqg
         eVMjjUCzk8y/vBSO4fv8PNmESSy7QBs/mseXBudbgwVfV2FCe+fBT3+BXGuDovpMhs
         9LdRQM2Abv6l8jqkpAWaQA2xgV1+mpuiawMmyXI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 36/43] net: lantiq: Use napi_complete_done()
Date:   Fri, 25 Sep 2020 14:48:48 +0200
Message-Id: <20200925124729.005705070@linuxfoundation.org>
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

[ Upstream commit c582a7fea9dad4d309437d1a7e22e6d2cb380e2e ]

Use napi_complete_done() and activate the interrupts when this function
returns true. This way the generic NAPI code can take care of activating
the interrupts.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/lantiq_xrx200.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -230,8 +230,8 @@ static int xrx200_poll_rx(struct napi_st
 	}
 
 	if (rx < budget) {
-		napi_complete(&ch->napi);
-		ltq_dma_enable_irq(&ch->dma);
+		if (napi_complete_done(&ch->napi, rx))
+			ltq_dma_enable_irq(&ch->dma);
 	}
 
 	return rx;
@@ -272,8 +272,8 @@ static int xrx200_tx_housekeeping(struct
 		netif_wake_queue(net_dev);
 
 	if (pkts < budget) {
-		napi_complete(&ch->napi);
-		ltq_dma_enable_irq(&ch->dma);
+		if (napi_complete_done(&ch->napi, pkts))
+			ltq_dma_enable_irq(&ch->dma);
 	}
 
 	return pkts;


