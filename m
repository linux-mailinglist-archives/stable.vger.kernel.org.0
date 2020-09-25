Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70072788B8
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgIYM5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbgIYMux (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870182072E;
        Fri, 25 Sep 2020 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038253;
        bh=MRzBQckpmRJlzp2heEROamiSWfyqx3BWg29J4CRz/4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxXpO7GeVV1WPDB0EWZN/1UoC4PElAjQKolAF7VIT9pe4m/1hpG5bX67L5MvnVL6s
         koqJDndey1d7eacF857S1ePp4zaUUVZ6ckCqBFczkjnmvM+UhvA/awpShInu7QEZZS
         UuBNQIN7NFIIPsGA4mDO3scYb7bKr95rmSym+iO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 37/56] net: lantiq: Use napi_complete_done()
Date:   Fri, 25 Sep 2020 14:48:27 +0200
Message-Id: <20200925124733.418411190@linuxfoundation.org>
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


