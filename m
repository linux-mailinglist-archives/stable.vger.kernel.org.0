Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3491381BC1
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfHENFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbfHENFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:05:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C09A7216B7;
        Mon,  5 Aug 2019 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010351;
        bh=4W4II8kk4wjVCd2zlALoOUToCwWRtZoxjpYtjrxQjxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQdl2PV3Vgy5nFzf5lQM/U5OamVPzJphuta25N7SSAOyG5vBIx0pRA6KzOergCPV1
         VJ7JNgYw4ZkK4KyDh3OtOIVd8WQs9ZHxn5yk2I60gI1C9JUje2AdU4MGQBDSYq0Tsa
         JeiwLDgFtz6qACDGfIWOmWE3qqTC5v79rnWnUMA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/42] be2net: Signal that the device cannot transmit during reconfiguration
Date:   Mon,  5 Aug 2019 15:02:41 +0200
Message-Id: <20190805124926.601206988@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
References: <20190805124924.788666484@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7429c6c0d9cb086d8e79f0d2a48ae14851d2115e ]

While changing the number of interrupt channels, be2net stops adapter
operation (including netif_tx_disable()) but it doesn't signal that it
cannot transmit. This may lead dev_watchdog() to falsely trigger during
that time.

Add the missing call to netif_carrier_off(), following the pattern used in
many other drivers. netif_carrier_on() is already taken care of in
be_open().

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index b2eeecb26939b..289560b0f6433 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4701,8 +4701,12 @@ int be_update_queues(struct be_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	int status;
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		/* device cannot transmit now, avoid dev_watchdog timeouts */
+		netif_carrier_off(netdev);
+
 		be_close(netdev);
+	}
 
 	be_cancel_worker(adapter);
 
-- 
2.20.1



