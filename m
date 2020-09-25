Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD4127878F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgIYMsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727248AbgIYMsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:48:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C28221741;
        Fri, 25 Sep 2020 12:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038112;
        bh=qrGrQGi+49D1Bobayjx6dob/oyG0cJnyBGPihvoBMYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q84Wj1uDgyFrxrdpyYctJxEVjUD9JACn0d0UKuZDrRFf3WAIJfBcrHDcCxOc75D9I
         UxamSA4kpBCePanVZi+Xn5KyoLV1aHctOL3MZBYQOj/gwXOlLJrscMmYWB5u1AEVbw
         rWHz/OHpqy/O9yYLp9SRFObxI1NrrF1E1adbeMKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mingming Cao <mmc@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 01/56] ibmvnic fix NULL tx_pools and rx_tools issue at do_reset
Date:   Fri, 25 Sep 2020 14:47:51 +0200
Message-Id: <20200925124728.045381703@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingming Cao <mmc@linux.vnet.ibm.com>

[ Upstream commit 9f13457377907fa253aef560e1a37e1ca4197f9b ]

At the time of do_rest, ibmvnic tries to re-initalize the tx_pools
and rx_pools to avoid re-allocating the long term buffer. However
there is a window inside do_reset that the tx_pools and
rx_pools were freed before re-initialized making it possible to deference
null pointers.

This patch fix this issue by always check the tx_pool
and rx_pool are not NULL after ibmvnic_login. If so, re-allocating
the pools. This will avoid getting into calling reset_tx/rx_pools with
NULL adapter tx_pools/rx_pools pointer. Also add null pointer check in
reset_tx_pools and reset_rx_pools to safe handle NULL pointer case.

Signed-off-by: Mingming Cao <mmc@linux.vnet.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5afb3c9c52d20..d3a774331afc7 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -479,6 +479,9 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 	int i, j, rc;
 	u64 *size_array;
 
+	if (!adapter->rx_pool)
+		return -1;
+
 	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
 		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
 
@@ -649,6 +652,9 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 	int tx_scrqs;
 	int i, rc;
 
+	if (!adapter->tx_pool)
+		return -1;
+
 	tx_scrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
 	for (i = 0; i < tx_scrqs; i++) {
 		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
@@ -2011,7 +2017,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		    adapter->req_rx_add_entries_per_subcrq !=
 		    old_num_rx_slots ||
 		    adapter->req_tx_entries_per_subcrq !=
-		    old_num_tx_slots) {
+		    old_num_tx_slots ||
+		    !adapter->rx_pool ||
+		    !adapter->tso_pool ||
+		    !adapter->tx_pool) {
 			release_rx_pools(adapter);
 			release_tx_pools(adapter);
 			release_napi(adapter);
@@ -2024,10 +2033,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		} else {
 			rc = reset_tx_pools(adapter);
 			if (rc)
+				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
+						rc);
 				goto out;
 
 			rc = reset_rx_pools(adapter);
 			if (rc)
+				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
+						rc);
 				goto out;
 		}
 		ibmvnic_disable_irqs(adapter);
-- 
2.25.1



