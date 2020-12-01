Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A62C9C50
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389340AbgLAJMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389951AbgLAJMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 177D82223C;
        Tue,  1 Dec 2020 09:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813910;
        bh=QMgFT7eZ7p9XTU4VKlCUyBLGUrgptRgdSiaQPb1iQGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBy8XC5zU08UrOlr7WcnHFBk8S2eHsITv83aVNVRwhpm2KcXyazDxswW2bWZpiDpH
         XZXo2OcnHJDVTvw4qT/5/cDnfqg1lwys64EFbwwj5r/77JgJeqj5hP8F+h6gxxBn4R
         SMoQOBKaXYaIz5xD/fG22fTXaBeQTcwTF4oWGWgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 101/152] ibmvnic: notify peers when failover and migration happen
Date:   Tue,  1 Dec 2020 09:53:36 +0100
Message-Id: <20201201084725.083799234@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 723651b34f94d..0341089743ff1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2087,7 +2087,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	if (adapter->reset_reason != VNIC_RESET_FAILOVER) {
+	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
+	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
 	}
@@ -2160,6 +2161,9 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc)
 		return IBMVNIC_OPEN_FAILED;
 
+	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+
 	return 0;
 }
 
-- 
2.27.0



