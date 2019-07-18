Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3CC6C51A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfGRDCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfGRDCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:02:47 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91ED2173B;
        Thu, 18 Jul 2019 03:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563418966;
        bh=gSFbszvSG8ctxWaISTu18j8/g8MHZEt81N9uRblgKz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ED/IB9uk1inJmBsY6bgukKhgltUA32E+nXZqqI6S/FmnwBZ7phEXZOLrj5zwMivut
         xiDUti9ro1wPZcBXT321nZpWiCAGJKSQFq58qVJvj8cQSwIQxFhrG05FCHppB5+U4E
         lJ0KBsBmiiQpg1W9wRti6XELvIUwsY3lPW+Cj5VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Joseph Yasi <joe.yasi@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.2 01/21] Revert "e1000e: fix cyclic resets at link up with active tx"
Date:   Thu, 18 Jul 2019 12:01:19 +0900
Message-Id: <20190718030030.832297722@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit caff422ea81e144842bc44bab408d85ac449377b upstream.

This reverts commit 0f9e980bf5ee1a97e2e401c846b2af989eb21c61.

That change cased false-positive warning about hardware hang:

e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
e1000e 0000:00:1f.6 eth0: Detected Hardware Unit Hang:
   TDH                  <0>
   TDT                  <1>
   next_to_use          <1>
   next_to_clean        <0>
buffer_info[next_to_clean]:
   time_stamp           <fffba7a7>
   next_to_watch        <0>
   jiffies              <fffbb140>
   next_to_watch.status <0>
MAC Status             <40080080>
PHY Status             <7949>
PHY 1000BASE-T Status  <0>
PHY Extended Status    <3000>
PCI Status             <10>
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

Besides warning everything works fine.
Original issue will be fixed property in following patch.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reported-by: Joseph Yasi <joe.yasi@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203175
Tested-by: Joseph Yasi <joe.yasi@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5308,13 +5308,8 @@ static void e1000_watchdog_task(struct w
 			/* 8000ES2LAN requires a Rx packet buffer work-around
 			 * on link down event; reset the controller to flush
 			 * the Rx packet buffer.
-			 *
-			 * If the link is lost the controller stops DMA, but
-			 * if there is queued Tx work it cannot be done.  So
-			 * reset the controller to flush the Tx packet buffers.
 			 */
-			if ((adapter->flags & FLAG_RX_NEEDS_RESTART) ||
-			    e1000_desc_unused(tx_ring) + 1 < tx_ring->count)
+			if (adapter->flags & FLAG_RX_NEEDS_RESTART)
 				adapter->flags |= FLAG_RESTART_NOW;
 			else
 				pm_schedule_suspend(netdev->dev.parent,
@@ -5337,6 +5332,14 @@ link_up:
 	adapter->gotc_old = adapter->stats.gotc;
 	spin_unlock(&adapter->stats64_lock);
 
+	/* If the link is lost the controller stops DMA, but
+	 * if there is queued Tx work it cannot be done.  So
+	 * reset the controller to flush the Tx packet buffers.
+	 */
+	if (!netif_carrier_ok(netdev) &&
+	    (e1000_desc_unused(tx_ring) + 1 < tx_ring->count))
+		adapter->flags |= FLAG_RESTART_NOW;
+
 	/* If reset is necessary, do it outside of interrupt context. */
 	if (adapter->flags & FLAG_RESTART_NOW) {
 		schedule_work(&adapter->reset_task);


