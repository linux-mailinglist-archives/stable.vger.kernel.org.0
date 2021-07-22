Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA633D27FE
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhGVPyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231153AbhGVPyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 091046135A;
        Thu, 22 Jul 2021 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971683;
        bh=qfasVKEmYsDLajXsGNHUse+/BpdW2oqdgIRNXeT1/O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aU2hRjoZwC8sL2KBT3edNgb3MrAZe+rz3tu1+S1yWjnf6IcqgCJyGhQ8Ug3sFD/Tq
         6fwXukSZVoetUk5hZueCvVjPpwdhto95CuX8LYTWL138OknOyUArNrU5S9VvNhOiw+
         FowZjdSCkmLEoZg5y7XQi2YeTp7zv0soRKzwXlGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 58/71] net: bcmgenet: Ensure all TX/RX queues DMAs are disabled
Date:   Thu, 22 Jul 2021 18:31:33 +0200
Message-Id: <20210722155619.831991875@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 2b452550a203d88112eaf0ba9fc4b750a000b496 upstream.

Make sure that we disable each of the TX and RX queues in the TDMA and
RDMA control registers. This is a correctness change to be symmetrical
with the code that enables the TX and RX queues.

Tested-by: Maxime Ripard <maxime@cerno.tech>
Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2783,15 +2783,21 @@ static void bcmgenet_set_hw_addr(struct
 /* Returns a reusable dma control register value */
 static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
 {
+	unsigned int i;
 	u32 reg;
 	u32 dma_ctrl;
 
 	/* disable DMA */
 	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->tx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
 	reg &= ~dma_ctrl;
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 
+	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->rx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
 	reg &= ~dma_ctrl;
 	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);


