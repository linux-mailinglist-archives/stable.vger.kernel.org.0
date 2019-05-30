Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D38C2F6A5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfE3E5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbfE3DJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA4DB244A2;
        Thu, 30 May 2019 03:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185792;
        bh=ZkNZh9SIMk+1zb+7Px4neMQcWkOjdcIr0kEfZFVoaqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zrf4cth+hLZ0gRR18KlySnMtb3sdfZY2eAUq+6r/rWQn13oiCJWz8SrLp3aR5Pj1P
         +9UkL2zCclE82KfnAV6F66bF7WfxyG0wIN8NAyF9cR4kSn6r9LG2Vcxa2Y2qjW0RpS
         9IyxHb7JLph6u3Jrad2rT0dp9nyYvD6wJMlHuW5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Stephan Klein <stephan.klein@wegfinder.at>
Subject: [PATCH 5.1 066/405] hv_netvsc: fix race that may miss tx queue wakeup
Date:   Wed, 29 May 2019 20:01:04 -0700
Message-Id: <20190530030544.279942933@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 93aa4792c3908eac87ddd368ee0fe0564148232b ]

When the ring buffer is almost full due to RX completion messages, a
TX packet may reach the "low watermark" and cause the queue stopped.
If the TX completion arrives earlier than queue stopping, the wakeup
may be missed.

This patch moves the check for the last pending packet to cover both
EAGAIN and success cases, so the queue will be reliably waked up when
necessary.

Reported-and-tested-by: Stephan Klein <stephan.klein@wegfinder.at>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index e0dce373cdd9d..3d4a166a49d58 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -875,12 +875,6 @@ static inline int netvsc_send_pkt(
 	} else if (ret == -EAGAIN) {
 		netif_tx_stop_queue(txq);
 		ndev_ctx->eth_stats.stop_queue++;
-		if (atomic_read(&nvchan->queue_sends) < 1 &&
-		    !net_device->tx_disable) {
-			netif_tx_wake_queue(txq);
-			ndev_ctx->eth_stats.wake_queue++;
-			ret = -ENOSPC;
-		}
 	} else {
 		netdev_err(ndev,
 			   "Unable to send packet pages %u len %u, ret %d\n",
@@ -888,6 +882,15 @@ static inline int netvsc_send_pkt(
 			   ret);
 	}
 
+	if (netif_tx_queue_stopped(txq) &&
+	    atomic_read(&nvchan->queue_sends) < 1 &&
+	    !net_device->tx_disable) {
+		netif_tx_wake_queue(txq);
+		ndev_ctx->eth_stats.wake_queue++;
+		if (ret == -EAGAIN)
+			ret = -ENOSPC;
+	}
+
 	return ret;
 }
 
-- 
2.20.1



