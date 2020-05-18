Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7CC1D81FE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgERRwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731000AbgERRwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:52:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADF0420674;
        Mon, 18 May 2020 17:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824354;
        bh=Je14zzXCFDmRtOIvyBQvBqQRd/NXT8DHGgDIWTJdP9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUjqKOUi1Flt7E/GtSSyD7UZFIzdUt1V7zhtIoggRmlQu2kwLLIGn/ecy/8IeU+D8
         EWtNGUt9lvrdQHKKaggSp5JJJ4JJxoWKQedNYZDPnbjYy9ae9QZCJSy94e7odd6ST2
         JJrmddDQe2R+xB9H5yatweYRPYVgGNAs0Jb61cu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Peter Chen <peter.chen@nxp.com>, Li Jun <jun.li@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 57/80] usb: host: xhci-plat: keep runtime active when removing host
Date:   Mon, 18 May 2020 19:37:15 +0200
Message-Id: <20200518173501.940945361@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 1449cb2c2253d37d998c3714aa9b95416d16d379 upstream.

While removing the host (e.g. for USB role switch from host to device),
if runtime pm is enabled by user, below oops occurs on dwc3 and cdns3
platforms.
Keeping the xhci-plat device active during host removal, and disabling
runtime pm before calling pm_runtime_set_suspended() fixes them.

oops1:
Unable to handle kernel NULL pointer dereference at virtual address
0000000000000240
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.4.3-00107-g64d454a-dirty
Hardware name: FSL i.MX8MP EVK (DT)
Workqueue: pm pm_runtime_work
pstate: 60000005 (nZCv daif -PAN -UAO)
pc : xhci_suspend+0x34/0x698
lr : xhci_plat_runtime_suspend+0x2c/0x38
sp : ffff800011ddbbc0
Call trace:
 xhci_suspend+0x34/0x698
 xhci_plat_runtime_suspend+0x2c/0x38
 pm_generic_runtime_suspend+0x28/0x40
 __rpm_callback+0xd8/0x138
 rpm_callback+0x24/0x98
 rpm_suspend+0xe0/0x448
 rpm_idle+0x124/0x140
 pm_runtime_work+0xa0/0xf8
 process_one_work+0x1dc/0x370
 worker_thread+0x48/0x468
 kthread+0xf0/0x120
 ret_from_fork+0x10/0x1c

oops2:
usb 2-1: USB disconnect, device number 2
xhci-hcd xhci-hcd.1.auto: remove, state 4
usb usb2: USB disconnect, device number 1
xhci-hcd xhci-hcd.1.auto: USB bus 2 deregistered
xhci-hcd xhci-hcd.1.auto: remove, state 4
usb usb1: USB disconnect, device number 1
Unable to handle kernel NULL pointer dereference at virtual address
0000000000000138
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 7 Comm: kworker/u8:0 Not tainted 5.6.0-rc4-next-20200304-03578
Hardware name: Freescale i.MX8QXP MEK (DT)
Workqueue: 1-0050 tcpm_state_machine_work
pstate: 20000005 (nzCv daif -PAN -UAO)
pc : xhci_free_dev+0x214/0x270
lr : xhci_plat_runtime_resume+0x78/0x88
sp : ffff80001006b5b0
Call trace:
 xhci_free_dev+0x214/0x270
 xhci_plat_runtime_resume+0x78/0x88
 pm_generic_runtime_resume+0x30/0x48
 __rpm_callback+0x90/0x148
 rpm_callback+0x28/0x88
 rpm_resume+0x568/0x758
 rpm_resume+0x260/0x758
 rpm_resume+0x260/0x758
 __pm_runtime_resume+0x40/0x88
 device_release_driver_internal+0xa0/0x1c8
 device_release_driver+0x1c/0x28
 bus_remove_device+0xd4/0x158
 device_del+0x15c/0x3a0
 usb_disable_device+0xb0/0x268
 usb_disconnect+0xcc/0x300
 usb_remove_hcd+0xf4/0x1dc
 xhci_plat_remove+0x78/0xe0
 platform_drv_remove+0x30/0x50
 device_release_driver_internal+0xfc/0x1c8
 device_release_driver+0x1c/0x28
 bus_remove_device+0xd4/0x158
 device_del+0x15c/0x3a0
 platform_device_del.part.0+0x20/0x90
 platform_device_unregister+0x28/0x40
 cdns3_host_exit+0x20/0x40
 cdns3_role_stop+0x60/0x90
 cdns3_role_set+0x64/0xd8
 usb_role_switch_set_role.part.0+0x3c/0x68
 usb_role_switch_set_role+0x20/0x30
 tcpm_mux_set+0x60/0xf8
 tcpm_reset_port+0xa4/0xf0
 tcpm_detach.part.0+0x28/0x50
 tcpm_state_machine_work+0x12ac/0x2360
 process_one_work+0x1c8/0x470
 worker_thread+0x50/0x428
 kthread+0xfc/0x128
 ret_from_fork+0x10/0x18
Code: c8037c02 35ffffa3 17ffe7c3 f9800011 (c85f7c01)
---[ end trace 45b1a173d2679e44 ]---

[minor commit message cleanup  -Mathias]
Cc: Baolin Wang <baolin.wang@linaro.org>
Cc: <stable@vger.kernel.org>
Fixes: b0c69b4bace3 ("usb: host: plat: Enable xHCI plat runtime PM")
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Tested-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200514110432.25564-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -361,6 +361,7 @@ static int xhci_plat_remove(struct platf
 	struct clk *reg_clk = xhci->reg_clk;
 	struct usb_hcd *shared_hcd = xhci->shared_hcd;
 
+	pm_runtime_get_sync(&dev->dev);
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
 	usb_remove_hcd(shared_hcd);
@@ -374,8 +375,9 @@ static int xhci_plat_remove(struct platf
 	clk_disable_unprepare(reg_clk);
 	usb_put_hcd(hcd);
 
-	pm_runtime_set_suspended(&dev->dev);
 	pm_runtime_disable(&dev->dev);
+	pm_runtime_put_noidle(&dev->dev);
+	pm_runtime_set_suspended(&dev->dev);
 
 	return 0;
 }


