Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E86F111C2E
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfLCWlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbfLCWlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5724820862;
        Tue,  3 Dec 2019 22:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412882;
        bh=N3z5o1CiS7er7wCtOiJuMZ6Yhejg/AUtOZVEhphwnGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J31A196hIdEkfGwO3kJIv0ecLAF2Ei1VL6jFm2g9CvyPFDKSi+ft63sVuwGQ9FGgD
         ZMD3BY5/zlxWHnbavshXgwSTNXCAMhlxn4p2SIROApW+PdoD7+ewO2qyXrB5xIhmYH
         6Y2Oh4UlQTDjPpGsZiBh2cGB7NOw+vTRZhvDZdRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 054/135] can: rx-offload: can_rx_offload_offload_one(): do not increase the skb_queue beyond skb_queue_len_max
Date:   Tue,  3 Dec 2019 23:34:54 +0100
Message-Id: <20191203213020.278645264@linuxfoundation.org>
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

[ Upstream commit a2dc3f5e1022a5ede8af9ab89a144f1e69db8636 ]

The skb_queue is a linked list, holding the skb to be processed in the
next NAPI call.

Without this patch, the queue length in can_rx_offload_offload_one() is
limited to skb_queue_len_max + 1. As the skb_queue is a linked list, no
array or other resources are accessed out-of-bound, however this
behaviour is counterintuitive.

This patch limits the rx-offload skb_queue length to skb_queue_len_max.

Fixes: d254586c3453 ("can: rx-offload: Add support for HW fifo based irq offloading")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index d1c8634099450..bdc27481b57f9 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -115,7 +115,7 @@ static struct sk_buff *can_rx_offload_offload_one(struct can_rx_offload *offload
 	int ret;
 
 	/* If queue is full or skb not available, read to discard mailbox */
-	if (likely(skb_queue_len(&offload->skb_queue) <=
+	if (likely(skb_queue_len(&offload->skb_queue) <
 		   offload->skb_queue_len_max))
 		skb = alloc_can_skb(offload->dev, &cf);
 
-- 
2.20.1



