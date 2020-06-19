Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79DE201368
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392253AbgFSQBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403947AbgFSPNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47DF921924;
        Fri, 19 Jun 2020 15:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579614;
        bh=zxngluHz2pk5rOkA2jhUGxWiZNaTeVTu7uT5sEE0ucs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvMkdclaQe3+uDB5MgJ96U/dcm0fNxWaKgf31Uh1SSEVbR7QvAhXryxwbrxxthEoB
         foToInQbNZjFJhf6i0qgp2Fc4TlXEoo9MIl4QnJANMYXHtfNPj9YaBkP0hkWJnRlZl
         fToilNlGC69TesYVPrzoHpbyRM1J49eO+jec5eOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 202/261] Bluetooth: hci_bcm: fix freeing not-requested IRQ
Date:   Fri, 19 Jun 2020 16:33:33 +0200
Message-Id: <20200619141659.572460914@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 81bd5d0c62437c02caac6b3f942fcda874063cb0 upstream.

When BT module can't be initialized, but it has an IRQ, unloading
the driver WARNs when trying to free not-yet-requested IRQ. Fix it by
noting whether the IRQ was requested.

WARNING: CPU: 2 PID: 214 at kernel/irq/devres.c:144 devm_free_irq+0x49/0x4ca
[...]
WARNING: CPU: 2 PID: 214 at kernel/irq/manage.c:1746 __free_irq+0x8b/0x27c
Trying to free already-free IRQ 264
Modules linked in: hci_uart(-) btbcm bluetooth ecdh_generic ecc libaes
CPU: 2 PID: 214 Comm: rmmod Tainted: G        W         5.6.1mq-00044-ga5f9ea098318-dirty #928
[...]
[<b016aefb>] (devm_free_irq) from [<af8ba1ff>] (bcm_close+0x97/0x118 [hci_uart])
[<af8ba1ff>] (bcm_close [hci_uart]) from [<af8b736f>] (hci_uart_unregister_device+0x33/0x3c [hci_uart])
[<af8b736f>] (hci_uart_unregister_device [hci_uart]) from [<b035930b>] (serdev_drv_remove+0x13/0x20)
[<b035930b>] (serdev_drv_remove) from [<b037093b>] (device_release_driver_internal+0x97/0x118)
[<b037093b>] (device_release_driver_internal) from [<b0370a0b>] (driver_detach+0x2f/0x58)
[<b0370a0b>] (driver_detach) from [<b036f855>] (bus_remove_driver+0x41/0x94)
[<b036f855>] (bus_remove_driver) from [<af8ba8db>] (bcm_deinit+0x1b/0x740 [hci_uart])
[<af8ba8db>] (bcm_deinit [hci_uart]) from [<af8ba86f>] (hci_uart_exit+0x13/0x30 [hci_uart])
[<af8ba86f>] (hci_uart_exit [hci_uart]) from [<b01900bd>] (sys_delete_module+0x109/0x1d0)
[<b01900bd>] (sys_delete_module) from [<b0101001>] (ret_fast_syscall+0x1/0x5a)
[...]

Cc: stable@vger.kernel.org
Fixes: 6cc4396c8829 ("Bluetooth: hci_bcm: Add wake-up capability")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_bcm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -107,6 +107,7 @@ struct bcm_device {
 	u32			oper_speed;
 	int			irq;
 	bool			irq_active_low;
+	bool			irq_acquired;
 
 #ifdef CONFIG_PM
 	struct hci_uart		*hu;
@@ -319,6 +320,8 @@ static int bcm_request_irq(struct bcm_da
 		goto unlock;
 	}
 
+	bdev->irq_acquired = true;
+
 	device_init_wakeup(bdev->dev, true);
 
 	pm_runtime_set_autosuspend_delay(bdev->dev,
@@ -487,7 +490,7 @@ static int bcm_close(struct hci_uart *hu
 	}
 
 	if (bdev) {
-		if (IS_ENABLED(CONFIG_PM) && bdev->irq > 0) {
+		if (IS_ENABLED(CONFIG_PM) && bdev->irq_acquired) {
 			devm_free_irq(bdev->dev, bdev->irq, bdev);
 			device_init_wakeup(bdev->dev, false);
 			pm_runtime_disable(bdev->dev);


