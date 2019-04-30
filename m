Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31516F644
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfD3LpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728767AbfD3LpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D007421670;
        Tue, 30 Apr 2019 11:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624721;
        bh=FwzSA5H87nkzHWLN9SIP8WGyKmE/0RyhBEW1052fBBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjCaBePbM6D26VE2txxykpidUhg3w27BmQikuwVPwFlrG0A+sGcFHU2HnP+haWth2
         a5BRe7TH2Q7n7pEl8VSpAGQa2h4InM4jLrwJxPH9Ay6KnHgeFTtzuxGFuF8koncC34
         +/S+EN0wGCydYcBIGc4REopXS2yHmX92Ick9Bnu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/100] net/ibmvnic: Fix RTNL deadlock during device reset
Date:   Tue, 30 Apr 2019 13:37:41 +0200
Message-Id: <20190430113609.184825578@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 986103e7920cabc0b910749e77ae5589d3934d52 ]

Commit a5681e20b541 ("net/ibmnvic: Fix deadlock problem
in reset") made the change to hold the RTNL lock during
driver reset but still calls netdev_notify_peers, which
results in a deadlock. Instead, use call_netdevice_notifiers,
which is functionally the same except that it does not
take the RTNL lock again.

Fixes: a5681e20b541 ("net/ibmnvic: Fix deadlock problem in reset")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a475f36ddf8c..426789e2c23d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1859,7 +1859,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
 	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM)
-		netdev_notify_peers(netdev);
+		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 
 	netif_carrier_on(netdev);
 
-- 
2.19.1



