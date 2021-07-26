Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215073D629F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhGZPgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234511AbhGZPgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:36:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4BCC60F92;
        Mon, 26 Jul 2021 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316206;
        bh=zvmH/5ENl0TxcHdJf1LcL+S/xSZwT7vPysUqP20XJLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nogzxQ2aUds7W5gjfCZUKvXmzrZQXDL71UA3KxSxYhGSBRamhwXl3LsSfxszQvnXi
         IhTjbey+GasHSdpBYJX2B9y+XH3h8iL7MWhSOF+GXr5Ij48WrDupk/1jM+0u/G8dPe
         S/P8Ao6dzAXmKi+sBdeC+I696XabBWU2zeFlp+xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 223/223] sfc: ensure correct number of XDP queues
Date:   Mon, 26 Jul 2021 17:40:15 +0200
Message-Id: <20210726153853.474810699@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 788bc000d4c2f25232db19ab3a0add0ba4e27671 ]

Commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count with the real
number of initialized queues") intended to fix a problem caused by a
round up when calculating the number of XDP channels and queues.
However, this was not the real problem. The real problem was that the
number of XDP TX queues had been reduced to half in
commit e26ca4b53582 ("sfc: reduce the number of requested xdp ev queues"),
but the variable xdp_tx_queue_count had remained the same.

Once the correct number of XDP TX queues is created again in the
previous patch of this series, this also can be reverted since the error
doesn't actually exist.

Only in the case that there is a bug in the code we can have different
values in xdp_queue_number and efx->xdp_tx_queue_count. Because of this,
and per Edward Cree's suggestion, I add instead a WARN_ON to catch if it
happens again in the future.

Note that the number of allocated queues can be higher than the number
of used ones due to the round up, as explained in the existing comment
in the code. That's why we also have to stop increasing xdp_queue_number
beyond efx->xdp_tx_queue_count.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 5b71f8a03a6d..bb48a139dd15 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -892,18 +892,20 @@ int efx_set_channels(struct efx_nic *efx)
 			if (efx_channel_is_xdp_tx(channel)) {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
 					tx_queue->queue = next_queue++;
-					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-						  channel->channel, tx_queue->label,
-						  xdp_queue_number, tx_queue->queue);
+
 					/* We may have a few left-over XDP TX
 					 * queues owing to xdp_tx_queue_count
 					 * not dividing evenly by EFX_MAX_TXQ_PER_CHANNEL.
 					 * We still allocate and probe those
 					 * TXQs, but never use them.
 					 */
-					if (xdp_queue_number < efx->xdp_tx_queue_count)
+					if (xdp_queue_number < efx->xdp_tx_queue_count) {
+						netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
+							  channel->channel, tx_queue->label,
+							  xdp_queue_number, tx_queue->queue);
 						efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-					xdp_queue_number++;
+						xdp_queue_number++;
+					}
 				}
 			} else {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
@@ -915,8 +917,7 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
-	if (xdp_queue_number)
-		efx->xdp_tx_queue_count = xdp_queue_number;
+	WARN_ON(xdp_queue_number != efx->xdp_tx_queue_count);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.30.2



