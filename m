Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CA21EFAA4
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgFEOT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbgFEOTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:19:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5003A208B8;
        Fri,  5 Jun 2020 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366755;
        bh=eBo08nm/PDjGdcH7DqDvvbaUmTpnzTyrigqj4+vtVHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=my36Q+0mdCrVKCLrz93QFSCdH4/7sK9IzzAtGq9p18w5OhOgFlg4LUO2clBXPWA4W
         RM9Gh21VRu/EtEcf3TIsLsGjYISckujvInFm8BeXvnsUzZvlmN6WXr0AwX/h1Vff9l
         /hCCcoGF9zWzgZbN4/BQ6uJkY1BPua1X7pELv5+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valentin Longchamp <valentin@longchamp.me>,
        Matteo Ghidoni <matteo.ghidoni@ch.abb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/38] net/ethernet/freescale: rework quiesce/activate for ucc_geth
Date:   Fri,  5 Jun 2020 16:15:18 +0200
Message-Id: <20200605140254.929189032@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>

[ Upstream commit 79dde73cf9bcf1dd317a2667f78b758e9fe139ed ]

ugeth_quiesce/activate are used to halt the controller when there is a
link change that requires to reconfigure the mac.

The previous implementation called netif_device_detach(). This however
causes the initial activation of the netdevice to fail precisely because
it's detached. For details, see [1].

A possible workaround was the revert of commit
net: linkwatch: add check for netdevice being present to linkwatch_do_dev
However, the check introduced in the above commit is correct and shall be
kept.

The netif_device_detach() is thus replaced with
netif_tx_stop_all_queues() that prevents any tranmission. This allows to
perform mac config change required by the link change, without detaching
the corresponding netdevice and thus not preventing its initial
activation.

[1] https://lists.openwall.net/netdev/2020/01/08/201

Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
Acked-by: Matteo Ghidoni <matteo.ghidoni@ch.abb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index f839fa94ebdd..d3b8ce734c1b 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -42,6 +42,7 @@
 #include <soc/fsl/qe/ucc.h>
 #include <soc/fsl/qe/ucc_fast.h>
 #include <asm/machdep.h>
+#include <net/sch_generic.h>
 
 #include "ucc_geth.h"
 
@@ -1548,11 +1549,8 @@ static int ugeth_disable(struct ucc_geth_private *ugeth, enum comm_dir mode)
 
 static void ugeth_quiesce(struct ucc_geth_private *ugeth)
 {
-	/* Prevent any further xmits, plus detach the device. */
-	netif_device_detach(ugeth->ndev);
-
-	/* Wait for any current xmits to finish. */
-	netif_tx_disable(ugeth->ndev);
+	/* Prevent any further xmits */
+	netif_tx_stop_all_queues(ugeth->ndev);
 
 	/* Disable the interrupt to avoid NAPI rescheduling. */
 	disable_irq(ugeth->ug_info->uf_info.irq);
@@ -1565,7 +1563,10 @@ static void ugeth_activate(struct ucc_geth_private *ugeth)
 {
 	napi_enable(&ugeth->napi);
 	enable_irq(ugeth->ug_info->uf_info.irq);
-	netif_device_attach(ugeth->ndev);
+
+	/* allow to xmit again  */
+	netif_tx_wake_all_queues(ugeth->ndev);
+	__netdev_watchdog_up(ugeth->ndev);
 }
 
 /* Called every time the controller might need to be made
-- 
2.25.1



