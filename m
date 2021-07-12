Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFE63C4ED3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbhGLHVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243056AbhGLHTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CE48613F3;
        Mon, 12 Jul 2021 07:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074163;
        bh=qNGeOVNDoRJC5SgsbUZisUsN8g0x+BGAXNQIvelHVUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icNvPSNTNfs+oegCutfEuzMsP0NHASyl1ylQdYINZJuwySUGnzq/RufzHzTgU9wTL
         Sh52Yad4EwX4Wc8CN1+eVtfTCfUCrnaJfoqavhiWHKM23fvw0wFoJHnYo7kZ6LebFc
         tBAk3duQuQWmMJjJCeEpxrYDWWW3mkeXY0XAwP+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 484/700] ibmvnic: account for bufs already saved in indir_buf
Date:   Mon, 12 Jul 2021 08:09:27 +0200
Message-Id: <20210712061028.078574756@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index e8f4bdb1079c..f1a6f454fe97 100644
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



