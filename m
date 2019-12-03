Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C4B111FAB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfLCWlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbfLCWle (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1650820684;
        Tue,  3 Dec 2019 22:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412893;
        bh=rU29GQKb3JthhKJVz13Cku6tYwkfIafBv+cnoeqH27E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynky+d2g2CIYcBd7QNblCDB6czpCMh8eAyNRj1i+7wmh4Zi/ZDX4dQNv5FdeUydiG
         lVUKC2Sn3a1Vn1A7pqSCh+539wzMLKvAd21Lo+dN8UYrYWu1osc5ib9aT1CGBsKIye
         RaQEk19+GZIiP9orqsp7dcXKJxcUslxxtbqHNto8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 058/135] can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error
Date:   Tue,  3 Dec 2019 23:34:58 +0100
Message-Id: <20191203213021.202307197@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 1f7f504dcd9d1262437bdcf4fa071e41dec1af03 ]

In case of a resource shortage, i.e. the rx_offload queue will overflow
or a skb fails to be allocated (due to OOM),
can_rx_offload_offload_one() will call mailbox_read() to discard the
mailbox and return an ERR_PTR.

If the hardware FIFO is empty can_rx_offload_offload_one() will return
NULL.

In case a CAN frame was read from the hardware,
can_rx_offload_offload_one() returns the skb containing it.

Without this patch can_rx_offload_irq_offload_fifo() bails out if no skb
returned, regardless of the reason.

Similar to can_rx_offload_irq_offload_timestamp() in case of a resource
shortage the whole FIFO should be discarded, to avoid an IRQ storm and
give the system some time to recover. However if the FIFO is empty the
loop can be left.

With this patch the loop is left in case of empty FIFO, but not on
errors.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 2ea8676579a9c..84cae167e42f6 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -248,7 +248,9 @@ int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload)
 
 	while (1) {
 		skb = can_rx_offload_offload_one(offload, 0);
-		if (IS_ERR_OR_NULL(skb))
+		if (IS_ERR(skb))
+			continue;
+		if (!skb)
 			break;
 
 		skb_queue_tail(&offload->skb_queue, skb);
-- 
2.20.1



