Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3786186A38
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404594AbfHHTHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404590AbfHHTHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD9D2184E;
        Thu,  8 Aug 2019 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291225;
        bh=MCaVAbKTzMcskmNplwwHB7pTzUAcdXsvYlD8ZsyQ8lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJH2os6qErk++ttogxdC6FL+REjQ5ZAW9/5Ug6e4xLoj51J/Csjaquh1J3EG678jm
         IV0btzq3rtZcQSj62KXaiel7NOI9dzte8zVlzRwEpzl4NRFNqpsOngohWS103FbQjX
         6d3TFAESIuToeNh7ZhqZIv+4VsISCOq9Td/0LU2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frode Isaksen <fisaksen@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 33/56] net: stmmac: Use netif_tx_napi_add() for TX polling function
Date:   Thu,  8 Aug 2019 21:04:59 +0200
Message-Id: <20190808190454.315977400@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frode Isaksen <fisaksen@baylibre.com>

[ Upstream commit 4d97972b45f080db4c6d27cc0b54321d9cd7be17 ]

This variant of netif_napi_add() should be used from drivers
using NAPI to exclusively poll a TX queue.

Signed-off-by: Frode Isaksen <fisaksen@baylibre.com>
Tested-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4374,8 +4374,9 @@ int stmmac_dvr_probe(struct device *devi
 				       NAPI_POLL_WEIGHT);
 		}
 		if (queue < priv->plat->tx_queues_to_use) {
-			netif_napi_add(ndev, &ch->tx_napi, stmmac_napi_poll_tx,
-				       NAPI_POLL_WEIGHT);
+			netif_tx_napi_add(ndev, &ch->tx_napi,
+					  stmmac_napi_poll_tx,
+					  NAPI_POLL_WEIGHT);
 		}
 	}
 


