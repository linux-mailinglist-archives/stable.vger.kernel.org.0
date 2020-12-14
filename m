Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B712D9F95
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgLNSvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502246AbgLNRhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:37 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 021/105] ibmvnic: reduce wait for completion time
Date:   Mon, 14 Dec 2020 18:27:55 +0100
Message-Id: <20201214172556.293225821@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit 98c41f04a67abf5e7f7191d55d286e905d1430ef ]

Reduce the wait time for Command Response Queue response from 30 seconds
to 20 seconds, as recommended by VIOS and Power Hypervisor teams.

Fixes: bd0b672313941 ("ibmvnic: Move login and queue negotiation into ibmvnic_open")
Fixes: 53da09e92910f ("ibmvnic: Add set_link_state routine for setting adapter link state")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index de25d1860f16f..a1556673300a0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -846,7 +846,7 @@ static void release_napi(struct ibmvnic_adapter *adapter)
 static int ibmvnic_login(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	int retry_count = 0;
 	int retries = 10;
 	bool retry;
@@ -950,7 +950,7 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 {
 	struct net_device *netdev = adapter->netdev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	union ibmvnic_crq crq;
 	bool resend;
 	int rc;
@@ -5081,7 +5081,7 @@ map_failed:
 static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 {
 	struct device *dev = &adapter->vdev->dev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	u64 old_num_rx_queues, old_num_tx_queues;
 	int rc;
 
-- 
2.27.0



