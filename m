Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF087869F9
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405494AbfHHTLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405488AbfHHTL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D661208C3;
        Thu,  8 Aug 2019 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291488;
        bh=L1b5hdrCd1bDfjgrb5QgqYINlK0j1YxrUpz8BS+Hu5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ws4vKtE3CztgX1ayRfmeRsDja7ZQeVrTTilKw6jamuruAncnlkTQiH0hE6ZjS1ayx
         WatHrzLKpuuDdDNUYQ+yoBlsk2MDZvLMb170gAA1G6uG00Gt/92baDvFVSB+5Rz/rU
         HseVPTiD+EB+uXlsPa7coSI0+ci63bGqRWg1ENrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 26/33] mvpp2: refactor MTU change code
Date:   Thu,  8 Aug 2019 21:05:33 +0200
Message-Id: <20190808190454.926578477@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit 230bd958c2c846ee292aa38bc6b006296c24ca01 ]

The MTU change code can call napi_disable() with the device already down,
leading to a deadlock. Also, lot of code is duplicated unnecessarily.

Rework mvpp2_change_mtu() to avoid the deadlock and remove duplicated code.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2.c |   41 +++++++++++------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2.c
+++ b/drivers/net/ethernet/marvell/mvpp2.c
@@ -6952,6 +6952,7 @@ log_error:
 static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
+	bool running = netif_running(dev);
 	int err;
 
 	if (!IS_ALIGNED(MVPP2_RX_PKT_SIZE(mtu), 8)) {
@@ -6960,40 +6961,24 @@ static int mvpp2_change_mtu(struct net_d
 		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (!netif_running(dev)) {
-		err = mvpp2_bm_update_mtu(dev, mtu);
-		if (!err) {
-			port->pkt_size =  MVPP2_RX_PKT_SIZE(mtu);
-			return 0;
-		}
+	if (running)
+		mvpp2_stop_dev(port);
 
+	err = mvpp2_bm_update_mtu(dev, mtu);
+	if (err) {
+		netdev_err(dev, "failed to change MTU\n");
 		/* Reconfigure BM to the original MTU */
-		err = mvpp2_bm_update_mtu(dev, dev->mtu);
-		if (err)
-			goto log_error;
+		mvpp2_bm_update_mtu(dev, dev->mtu);
+	} else {
+		port->pkt_size =  MVPP2_RX_PKT_SIZE(mtu);
 	}
 
-	mvpp2_stop_dev(port);
-
-	err = mvpp2_bm_update_mtu(dev, mtu);
-	if (!err) {
-		port->pkt_size =  MVPP2_RX_PKT_SIZE(mtu);
-		goto out_start;
+	if (running) {
+		mvpp2_start_dev(port);
+		mvpp2_egress_enable(port);
+		mvpp2_ingress_enable(port);
 	}
 
-	/* Reconfigure BM to the original MTU */
-	err = mvpp2_bm_update_mtu(dev, dev->mtu);
-	if (err)
-		goto log_error;
-
-out_start:
-	mvpp2_start_dev(port);
-	mvpp2_egress_enable(port);
-	mvpp2_ingress_enable(port);
-
-	return 0;
-log_error:
-	netdev_err(dev, "failed to change MTU\n");
 	return err;
 }
 


