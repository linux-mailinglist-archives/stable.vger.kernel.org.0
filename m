Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442D82D03BD
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgLFLkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgLFLjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:39:53 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 10/32] ibmvnic: fix call_netdevice_notifiers in do_reset
Date:   Sun,  6 Dec 2020 12:17:10 +0100
Message-Id: <20201206111556.268980412@linuxfoundation.org>
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

[ Upstream commit 8393597579f5250636f1cff157ea73f402b6501e ]

When netdev_notify_peers was substituted in
commit 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset"),
call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev) was missed.
Fix it now.

Fixes: 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1878,8 +1878,10 @@ static int do_reset(struct ibmvnic_adapt
 		napi_schedule(&adapter->napi[i]);
 
 	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
-	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM)
+	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+	}
 
 	netif_carrier_on(netdev);
 


