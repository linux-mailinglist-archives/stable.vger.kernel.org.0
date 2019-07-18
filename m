Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32A46C7BD
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389443AbfGRDDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389432AbfGRDDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:03:42 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7643D21849;
        Thu, 18 Jul 2019 03:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419021;
        bh=rNZMM3N9RKTRm0K8TpzstOUDkLj8uGcAApZZJGzJxd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMZGPNn6kdLsU88mDLPuc9DoozE8m+vD3806rTCxN9U7/HMdzxoflITKshXffIE0K
         hei3rhMe2zAjtgLQ6L2xJ46gBy9h2D/ARmBQUdOttfDGGjyB9Y36nuff+mXqRLfhGE
         X8uvxFENLqjGXxxAEpSWzhTZNgzbRNSzJfLBLr7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Joseph Yasi <joe.yasi@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.2 02/21] e1000e: start network tx queue only when link is up
Date:   Thu, 18 Jul 2019 12:01:20 +0900
Message-Id: <20190718030030.975683114@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit d17ba0f616a08f597d9348c372d89b8c0405ccf3 upstream.

Driver does not want to keep packets in Tx queue when link is lost.
But present code only reset NIC to flush them, but does not prevent
queuing new packets. Moreover reset sequence itself could generate
new packets via netconsole and NIC falls into endless reset loop.

This patch wakes Tx queue only when NIC is ready to send packets.

This is proper fix for problem addressed by commit 0f9e980bf5ee
("e1000e: fix cyclic resets at link up with active tx").

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Tested-by: Joseph Yasi <joe.yasi@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4208,7 +4208,7 @@ void e1000e_up(struct e1000_adapter *ada
 		e1000_configure_msix(adapter);
 	e1000_irq_enable(adapter);
 
-	netif_start_queue(adapter->netdev);
+	/* Tx queue started by watchdog timer when link is up */
 
 	e1000e_trigger_lsc(adapter);
 }
@@ -4606,6 +4606,7 @@ int e1000e_open(struct net_device *netde
 	pm_runtime_get_sync(&pdev->dev);
 
 	netif_carrier_off(netdev);
+	netif_stop_queue(netdev);
 
 	/* allocate transmit descriptors */
 	err = e1000e_setup_tx_resources(adapter->tx_ring);
@@ -4666,7 +4667,6 @@ int e1000e_open(struct net_device *netde
 	e1000_irq_enable(adapter);
 
 	adapter->tx_hang_recheck = false;
-	netif_start_queue(netdev);
 
 	hw->mac.get_link_status = true;
 	pm_runtime_put(&pdev->dev);
@@ -5288,6 +5288,7 @@ static void e1000_watchdog_task(struct w
 			if (phy->ops.cfg_on_link_up)
 				phy->ops.cfg_on_link_up(hw);
 
+			netif_wake_queue(netdev);
 			netif_carrier_on(netdev);
 
 			if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -5301,6 +5302,7 @@ static void e1000_watchdog_task(struct w
 			/* Link status message must follow this format */
 			pr_info("%s NIC Link is Down\n", adapter->netdev->name);
 			netif_carrier_off(netdev);
+			netif_stop_queue(netdev);
 			if (!test_bit(__E1000_DOWN, &adapter->state))
 				mod_timer(&adapter->phy_info_timer,
 					  round_jiffies(jiffies + 2 * HZ));


