Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B27247AD30
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhLTOus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55856 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbhLTOtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:49:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B94A3B80EE3;
        Mon, 20 Dec 2021 14:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0726C36AE7;
        Mon, 20 Dec 2021 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011747;
        bh=jCMZkkgu+eFI53slFLK/WPbXH5TQxM1d3BUo/EENv/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwG1o/E9aCicJ6PcZ1my5nV9VMUg/UcmeBkqGKB4hQ1/+RNzyQ8wZfbPWmOUgYasY
         13mXZf+oy9cep9MlTF9bVjrC66OkC0Lk2nRx7jrUh9Nppx4xWxYwArs+PIttMZzZQp
         t7uj+s9A9gjXEmsKGTaLra8KhoKJQDITZVv3oTfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 60/99] net: systemport: Add global locking for descriptor lifecycle
Date:   Mon, 20 Dec 2021 15:34:33 +0100
Message-Id: <20211220143031.411578509@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 8b8e6e782456f1ce02a7ae914bbd5b1053f0b034 ]

The descriptor list is a shared resource across all of the transmit queues, and
the locking mechanism used today only protects concurrency across a given
transmit queue between the transmit and reclaiming. This creates an opportunity
for the SYSTEMPORT hardware to work on corrupted descriptors if we have
multiple producers at once which is the case when using multiple transmit
queues.

This was particularly noticeable when using multiple flows/transmit queues and
it showed up in interesting ways in that UDP packets would get a correct UDP
header checksum being calculated over an incorrect packet length. Similarly TCP
packets would get an equally correct checksum computed by the hardware over an
incorrect packet length.

The SYSTEMPORT hardware maintains an internal descriptor list that it re-arranges
when the driver produces a new descriptor anytime it writes to the
WRITE_PORT_{HI,LO} registers, there is however some delay in the hardware to
re-organize its descriptors and it is possible that concurrent TX queues
eventually break this internal allocation scheme to the point where the
length/status part of the descriptor gets used for an incorrect data buffer.

The fix is to impose a global serialization for all TX queues in the short
section where we are writing to the WRITE_PORT_{HI,LO} registers which solves
the corruption even with multiple concurrent TX queues being used.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211215202450.4086240-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 5 ++++-
 drivers/net/ethernet/broadcom/bcmsysport.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0404aafd5ce56..1a703b95208b0 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1304,11 +1304,11 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
 	struct bcm_sysport_tx_ring *ring;
+	unsigned long flags, desc_flags;
 	struct bcm_sysport_cb *cb;
 	struct netdev_queue *txq;
 	u32 len_status, addr_lo;
 	unsigned int skb_len;
-	unsigned long flags;
 	dma_addr_t mapping;
 	u16 queue;
 	int ret;
@@ -1368,8 +1368,10 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 	ring->desc_count--;
 
 	/* Ports are latched, so write upper address first */
+	spin_lock_irqsave(&priv->desc_lock, desc_flags);
 	tdma_writel(priv, len_status, TDMA_WRITE_PORT_HI(ring->index));
 	tdma_writel(priv, addr_lo, TDMA_WRITE_PORT_LO(ring->index));
+	spin_unlock_irqrestore(&priv->desc_lock, desc_flags);
 
 	/* Check ring space and update SW control flow */
 	if (ring->desc_count == 0)
@@ -2008,6 +2010,7 @@ static int bcm_sysport_open(struct net_device *dev)
 	}
 
 	/* Initialize both hardware and software ring */
+	spin_lock_init(&priv->desc_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		ret = bcm_sysport_init_tx_ring(priv, i);
 		if (ret) {
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 3a5cb6f128f57..1276e330e9d03 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -742,6 +742,7 @@ struct bcm_sysport_priv {
 	int			wol_irq;
 
 	/* Transmit rings */
+	spinlock_t		desc_lock;
 	struct bcm_sysport_tx_ring *tx_rings;
 
 	/* Receive queue */
-- 
2.33.0



