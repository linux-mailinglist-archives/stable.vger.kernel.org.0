Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D293C5456
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348382AbhGLH5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352427AbhGLHyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E27C611AD;
        Mon, 12 Jul 2021 07:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076295;
        bh=c/5O6VMFqRkdIb4xZ3AOpLOa8tC8c0b/yN8bNbwlByQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOUI4MSVlYlnvHl4Ja5pkrXLHWfBjDHWbO5VZ4u5o3s+7fC2g6KgPpIP8Byt+MTxE
         C8cR77y+qTM08G7wn6z3bNlw9+ahhZeTbSnFUFmtISRHyc5S/qu/KZiHOrA7luCLQh
         QnYrElowUP4Y7kSTrU8F+RUY1dDlfQZENoAnqU8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 565/800] ibmvnic: account for bufs already saved in indir_buf
Date:   Mon, 12 Jul 2021 08:09:48 +0200
Message-Id: <20210712061027.567141165@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 72368f8b2b9e4106072a2728bed3367d54641c22 ]

This fixes a crash in replenish_rx_pool() when called from ibmvnic_poll()
after a previous call to replenish_rx_pool() encountered an error when
allocating a socket buffer.

Thanks to Rick Lindsley and Dany Madden for helping debug the crash.

Fixes: 4f0b6812e9b9 ("ibmvnic: Introduce batched RX buffer descriptor transmission")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2d15b446ceb3..779de81a54a6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -328,7 +328,14 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 
 	rx_scrq = adapter->rx_scrq[pool->index];
 	ind_bufp = &rx_scrq->ind_buf;
-	for (i = 0; i < count; ++i) {
+
+	/* netdev_skb_alloc() could have failed after we saved a few skbs
+	 * in the indir_buf and we would not have sent them to VIOS yet.
+	 * To account for them, start the loop at ind_bufp->index rather
+	 * than 0. If we pushed all the skbs to VIOS, ind_bufp->index will
+	 * be 0.
+	 */
+	for (i = ind_bufp->index; i < count; ++i) {
 		skb = netdev_alloc_skb(adapter->netdev, pool->buff_size);
 		if (!skb) {
 			dev_err(dev, "Couldn't replenish rx buff\n");
-- 
2.30.2



