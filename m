Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE3278897
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgIYM4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729350AbgIYMww (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB1F0206DB;
        Fri, 25 Sep 2020 12:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038371;
        bh=7xJT5bsd2R2cQLeb29FUYx4+OUR/2fbeBMWRiz6+Hzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdWT5BjdzJx9d7q0G6Kftu8hsXtKZhuI0UKYgXszN8zYTnMVTnFaq1jaoTIWzcFPL
         /O0WSwCo5zmhIhZwsnpxpxyrjOy+E7qLjuBnwvxQo2Zx4LN2GswWjGjto6g6XqUuJ4
         7nu4NuTtK2/jUWjMYbDczf4DcF4XHMyIsYwjcBh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 35/43] net: lantiq: use netif_tx_napi_add() for TX NAPI
Date:   Fri, 25 Sep 2020 14:48:47 +0200
Message-Id: <20200925124728.858742600@linuxfoundation.org>
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

[ Upstream commit 74c7b80e222b58d3cea731d31e2a31a77fea8345 ]

netif_tx_napi_add() should be used for NAPI in the TX direction instead
of the netif_napi_add() function.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/lantiq_xrx200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -501,7 +501,7 @@ static int xrx200_probe(struct platform_
 
 	/* setup NAPI */
 	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx, 32);
-	netif_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping, 32);
+	netif_tx_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping, 32);
 
 	platform_set_drvdata(pdev, priv);
 


