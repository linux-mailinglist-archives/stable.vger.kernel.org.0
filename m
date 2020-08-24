Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AE824FA37
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgHXJyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgHXIhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF0B4221E2;
        Mon, 24 Aug 2020 08:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258257;
        bh=BtnyVmk8EG3RJP7QrC5NvOWIju1VwmHKfCJG0w1OciQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfwjxw98+kxcXC/UrLbSn5B/Yx1P6Uyw3ALHT+oXiyolHFFJVtXBo5RddW95YsDR/
         kcPoVmJ/MkBZ2UQPBiK4+FS7d+ca/BXixkqtLpdsWjVLBZOpRsIDHQbEFm1B7Gehdb
         HxKifpH0uxDSUxrPuzWQ7I+04sVN45zqqBuG7Q/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Agroskin <shayagr@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 133/148] net: ena: Prevent reset after device destruction
Date:   Mon, 24 Aug 2020 10:30:31 +0200
Message-Id: <20200824082420.388699703@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>

[ Upstream commit 63d4a4c145cca2e84dc6e62d2ef5cb990c9723c2 ]

The reset work is scheduled by the timer routine whenever it
detects that a device reset is required (e.g. when a keep_alive signal
is missing).
When releasing device resources in ena_destroy_device() the driver
cancels the scheduling of the timer routine without destroying the reset
work explicitly.

This creates the following bug:
    The driver is suspended and the ena_suspend() function is called
	-> This function calls ena_destroy_device() to free the net device
	   resources
	    -> The driver waits for the timer routine to finish
	    its execution and then cancels it, thus preventing from it
	    to be called again.

    If, in its final execution, the timer routine schedules a reset,
    the reset routine might be called afterwards,and a redundant call to
    ena_restore_device() would be made.

By changing the reset routine we allow it to read the device's state
accurately.
This is achieved by checking whether ENA_FLAG_TRIGGER_RESET flag is set
before resetting the device and making both the destruction function and
the flag check are under rtnl lock.
The ENA_FLAG_TRIGGER_RESET is cleared at the end of the destruction
routine. Also surround the flag check with 'likely' because
we expect that the reset routine would be called only when
ENA_FLAG_TRIGGER_RESET flag is set.

The destruction of the timer and reset services in __ena_shutoff() have to
stay, even though the timer routine is destroyed in ena_destroy_device().
This is to avoid a case in which the reset routine is scheduled after
free_netdev() in __ena_shutoff(), which would create an access to freed
memory in adapter->flags.

Fixes: 8c5c7abdeb2d ("net: ena: add power management ops to the ENA driver")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index dda4b8fc9525e..1a2a464fb2f5f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3523,16 +3523,14 @@ static void ena_fw_reset_device(struct work_struct *work)
 {
 	struct ena_adapter *adapter =
 		container_of(work, struct ena_adapter, reset_task);
-	struct pci_dev *pdev = adapter->pdev;
 
-	if (unlikely(!test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
-		dev_err(&pdev->dev,
-			"device reset schedule while reset bit is off\n");
-		return;
-	}
 	rtnl_lock();
-	ena_destroy_device(adapter, false);
-	ena_restore_device(adapter);
+
+	if (likely(test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
+		ena_destroy_device(adapter, false);
+		ena_restore_device(adapter);
+	}
+
 	rtnl_unlock();
 }
 
@@ -4366,8 +4364,11 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 		netdev->rx_cpu_rmap = NULL;
 	}
 #endif /* CONFIG_RFS_ACCEL */
-	del_timer_sync(&adapter->timer_service);
 
+	/* Make sure timer and reset routine won't be called after
+	 * freeing device resources.
+	 */
+	del_timer_sync(&adapter->timer_service);
 	cancel_work_sync(&adapter->reset_task);
 
 	rtnl_lock(); /* lock released inside the below if-else block */
-- 
2.25.1



