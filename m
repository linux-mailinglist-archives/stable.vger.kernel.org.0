Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589EC2D0394
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgLFLjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbgLFLjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:39:31 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 11/32] ibmvnic: notify peers when failover and migration happen
Date:   Sun,  6 Dec 2020 12:17:11 +0100
Message-Id: <20201206111556.317195640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 98025bce3a6200a0c4637272a33b5913928ba5b8 ]

Commit 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
excluded the failover case for notify call because it said
netdev_notify_peers() can cause network traffic to stall or halt.
Current testing does not show network traffic stall
or halt because of the notify call for failover event.
netdev_notify_peers may be used when a device wants to inform the
rest of the network about some sort of a reconfiguration
such as failover or migration.

It is unnecessary to call that in other events like
FATAL, NON_FATAL, CHANGE_PARAM, and TIMEOUT resets
since in those scenarios the hardware does not change.
If the driver must do a hard reset, it is necessary to notify peers.

Fixes: 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Suggested-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1877,8 +1877,9 @@ static int do_reset(struct ibmvnic_adapt
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
-	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM) {
+	if ((adapter->reset_reason != VNIC_RESET_FAILOVER &&
+	     adapter->reset_reason != VNIC_RESET_CHANGE_PARAM) ||
+	     adapter->reset_reason == VNIC_RESET_MOBILITY) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
 	}
@@ -2106,6 +2107,9 @@ static int ibmvnic_reset(struct ibmvnic_
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
 	schedule_work(&adapter->ibmvnic_reset);
 
+	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+
 	return 0;
 err:
 	if (adapter->wait_for_reset)


