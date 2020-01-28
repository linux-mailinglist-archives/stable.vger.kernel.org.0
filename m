Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EACB14BBC6
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgA1OtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbgA1OB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:01:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021CB24685;
        Tue, 28 Jan 2020 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220089;
        bh=Myq/2LXMUhGE3pjb10aTlx+MjlltmjfFKNnQMy3pbgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGTf9OUS8z1QsagHaHHjl1g/E4fac7VIb0TzhnVPEutXbWvAvOycyNZYEKUpTRfX4
         Mw18Ocf3B7zBTfVFKKIvi6ezYKXrBW8+Q0kTtKxOGY4trMSuEV23zyZApZzD9Dsj0P
         Unpj6yyRQSl0LoQvLJO460/+Mv5eCjKwMbVieucY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 005/104] net: bcmgenet: Use netif_tx_napi_add() for TX NAPI
Date:   Tue, 28 Jan 2020 14:59:26 +0100
Message-Id: <20200128135817.984598636@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 148965df1a990af98b2c84092c2a2274c7489284 ]

Before commit 7587935cfa11 ("net: bcmgenet: move NAPI initialization to
ring initialization") moved the code, this used to be
netif_tx_napi_add(), but we lost that small semantic change in the
process, restore that.

Fixes: 7587935cfa11 ("net: bcmgenet: move NAPI initialization to ring initialization")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2164,8 +2164,8 @@ static void bcmgenet_init_tx_ring(struct
 				  DMA_END_ADDR);
 
 	/* Initialize Tx NAPI */
-	netif_napi_add(priv->dev, &ring->napi, bcmgenet_tx_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_tx_napi_add(priv->dev, &ring->napi, bcmgenet_tx_poll,
+			  NAPI_POLL_WEIGHT);
 }
 
 /* Initialize a RDMA ring */


