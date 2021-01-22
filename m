Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293AC3005E3
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbhAVOrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:47:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbhAVOZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14EAD23BC4;
        Fri, 22 Jan 2021 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325155;
        bh=gW1vNCkMSg0vv8yxO6E35Q77Lmc5LcE/IB/sMFXOaO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqTAuM4HweEf6iEI0XPS0FJN5GIJE4GPXBaU3seEaMChp/heTIGqySMC3Q3Ebg6cw
         oFNI6eUK0k3RbMbsC8pOHkDKC7KzHxv1q31LC+iE2gx/fDILNsMGx95krvR3j2Ke2D
         OcIlWLRIBRSucGQoGWe4zlP+Rf8cpsDGhxIzSAQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 36/43] can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check
Date:   Fri, 22 Jan 2021 15:12:52 +0100
Message-Id: <20210122135737.125521429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit ca4c6ebeeb50112f5178f14bfb6d9e8ddf148545 ]

If alloc_canfd_skb() returns NULL, 'cfg' is an uninitialized variable, so we
should check 'skb' rather than 'cfd' after calling alloc_canfd_skb(priv->ndev,
&cfd).

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210113073100.79552-1-miaoqinglang@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1432,7 +1432,7 @@ mcp251xfd_handle_rxif_one(struct mcp251x
 	else
 		skb = alloc_can_skb(priv->ndev, (struct can_frame **)&cfd);
 
-	if (!cfd) {
+	if (!skb) {
 		stats->rx_dropped++;
 		return 0;
 	}


