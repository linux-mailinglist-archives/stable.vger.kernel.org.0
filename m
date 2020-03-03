Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48986177FB5
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732157AbgCCRw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732153AbgCCRw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:52:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E97B8206D5;
        Tue,  3 Mar 2020 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257946;
        bh=jlZAQx8FT/1sYWWq280Z70i7ND/ZD6aGEztd1x8wfUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppJia0nEccWiN1iS/vVjHSfbQTwpjiy8iAuefOGeE2TjDLZTNvv/cGK7s/Z3AUeZS
         DofHbAlz6p1FkFcploEJWU1GTvorgScXfj0Z8LkrQqUm4zgVCXdr49HrnJ307HSyyK
         HYcXmQkmb+/y6ICS866WvI1li0KahyFYkU8mIz2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 005/152] net: macb: ensure interface is not suspended on at91rm9200
Date:   Tue,  3 Mar 2020 18:41:43 +0100
Message-Id: <20200303174303.112368405@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit e6a41c23df0d5da01540d2abef41591589c0b4be ]

Because of autosuspend, at91ether_start is called with clocks disabled.
Ensure that pm_runtime doesn't suspend the interface as soon as it is
opened as there is no pm_runtime support is the other relevant parts of the
platform support for at91rm9200.

Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3690,6 +3690,10 @@ static int at91ether_open(struct net_dev
 	u32 ctl;
 	int ret;
 
+	ret = pm_runtime_get_sync(&lp->pdev->dev);
+	if (ret < 0)
+		return ret;
+
 	/* Clear internal statistics */
 	ctl = macb_readl(lp, NCR);
 	macb_writel(lp, NCR, ctl | MACB_BIT(CLRSTAT));
@@ -3750,7 +3754,7 @@ static int at91ether_close(struct net_de
 			  q->rx_buffers, q->rx_buffers_dma);
 	q->rx_buffers = NULL;
 
-	return 0;
+	return pm_runtime_put(&lp->pdev->dev);
 }
 
 /* Transmit packet */


