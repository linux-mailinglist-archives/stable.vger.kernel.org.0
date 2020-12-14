Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC82D9EE6
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440813AbgLNSX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502321AbgLNRiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 053/105] ibmvnic: skip tx timeout reset while in resetting
Date:   Mon, 14 Dec 2020 18:28:27 +0100
Message-Id: <20201214172557.830952539@linuxfoundation.org>
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

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 855a631a4c11458a9cef1ab79c1530436aa95fae ]

Sometimes it takes longer than 5 seconds (watchdog timeout) to complete
failover, migration, and other resets. In stead of scheduling another
timeout reset, we wait for the current one to complete.

Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a1556673300a0..68aa9930d8187 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2358,6 +2358,12 @@ static void ibmvnic_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(dev);
 
+	if (test_bit(0, &adapter->resetting)) {
+		netdev_err(adapter->netdev,
+			   "Adapter is resetting, skip timeout reset\n");
+		return;
+	}
+
 	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
 }
 
-- 
2.27.0



