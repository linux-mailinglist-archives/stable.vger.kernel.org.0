Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867001991EE
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgCaJHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730885AbgCaJHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64FE620675;
        Tue, 31 Mar 2020 09:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645630;
        bh=zHxf+uGEgqh8WSxt3UwJ9PZzI3+QF9J16NeIV/VzbHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXaA763475eKJZWQCtgNVWdW36GANosbIosJnDTHiSxh+ZPqil3+QIjpYrWVT4bJF
         x8AQmj3BEjHo55TjKsCPJIYTTjAoG2j0mg+CpLMk/6c7K3BlXoMe9zzoLm7JjKXt8b
         a2bDWALbq63cEIs42QzUyneOSkpxKp51hbyIABaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juliet Kim <julietk@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 074/170] ibmvnic: Do not process device remove during device reset
Date:   Tue, 31 Mar 2020 10:58:08 +0200
Message-Id: <20200331085432.209416242@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juliet Kim <julietk@linux.vnet.ibm.com>

[ Upstream commit 7d7195a026bac47ac9943f11f84b7546276209dd ]

The ibmvnic driver does not check the device state when the device
is removed. If the device is removed while a device reset is being
processed, the remove may free structures needed by the reset,
causing an oops.

Fix this by checking the device state before processing device remove.

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 24 ++++++++++++++++++++++--
 drivers/net/ethernet/ibm/ibmvnic.h |  6 +++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 830791ab4619c..3c7295056c85d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2142,6 +2142,8 @@ static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_rwi *rwi;
 	struct ibmvnic_adapter *adapter;
+	bool saved_state = false;
+	unsigned long flags;
 	u32 reset_state;
 	int rc = 0;
 
@@ -2153,17 +2155,25 @@ static void __ibmvnic_reset(struct work_struct *work)
 		return;
 	}
 
-	reset_state = adapter->state;
-
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
+		spin_lock_irqsave(&adapter->state_lock, flags);
+
 		if (adapter->state == VNIC_REMOVING ||
 		    adapter->state == VNIC_REMOVED) {
+			spin_unlock_irqrestore(&adapter->state_lock, flags);
 			kfree(rwi);
 			rc = EBUSY;
 			break;
 		}
 
+		if (!saved_state) {
+			reset_state = adapter->state;
+			adapter->state = VNIC_RESETTING;
+			saved_state = true;
+		}
+		spin_unlock_irqrestore(&adapter->state_lock, flags);
+
 		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
 			/* CHANGE_PARAM requestor holds rtnl_lock */
 			rc = do_change_param_reset(adapter, rwi, reset_state);
@@ -5091,6 +5101,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 			  __ibmvnic_delayed_reset);
 	INIT_LIST_HEAD(&adapter->rwi_list);
 	spin_lock_init(&adapter->rwi_lock);
+	spin_lock_init(&adapter->state_lock);
 	mutex_init(&adapter->fw_lock);
 	init_completion(&adapter->init_done);
 	init_completion(&adapter->fw_done);
@@ -5163,8 +5174,17 @@ static int ibmvnic_remove(struct vio_dev *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(&dev->dev);
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->state_lock, flags);
+	if (adapter->state == VNIC_RESETTING) {
+		spin_unlock_irqrestore(&adapter->state_lock, flags);
+		return -EBUSY;
+	}
 
 	adapter->state = VNIC_REMOVING;
+	spin_unlock_irqrestore(&adapter->state_lock, flags);
+
 	rtnl_lock();
 	unregister_netdevice(netdev);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 60eccaf91b122..f8416e1d4cf09 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -941,7 +941,8 @@ enum vnic_state {VNIC_PROBING = 1,
 		 VNIC_CLOSING,
 		 VNIC_CLOSED,
 		 VNIC_REMOVING,
-		 VNIC_REMOVED};
+		 VNIC_REMOVED,
+		 VNIC_RESETTING};
 
 enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
 			   VNIC_RESET_MOBILITY,
@@ -1090,4 +1091,7 @@ struct ibmvnic_adapter {
 
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
+
+	/* Used for serializatin of state field */
+	spinlock_t state_lock;
 };
-- 
2.20.1



