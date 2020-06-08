Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8511F2E6B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgFIAlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgFHXMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE05208C7;
        Mon,  8 Jun 2020 23:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657963;
        bh=1Ikt2s4fDTnxI7w86xDYzie2Q7sfM+7MjF9rgt9ESeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtFPlK00C5wmuSDzuw2MuXdYl4VS2TPwrF/dQQaSWgh+Gg+jQNhO9r6D5HWA8Kyue
         /MRWJalxguLyAefTscGEgj+2lSoAhW1ECPYEuzbnUYdN/sA9LbbW+CLHg20nxo8RrW
         c3Y53YlcNPGX8cTsnVKdfl4bxKHIVFt92eMPsliE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Jun <jun.li@nxp.com>, Baolin Wang <baolin.wang@linaro.org>,
        Peter Chen <peter.chen@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 027/606] usb: host: xhci-plat: keep runtime active when removing host
Date:   Mon,  8 Jun 2020 19:02:32 -0400
Message-Id: <20200608231211.3363633-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/usb/host/xhci-plat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 315b4552693c..52c625c02341 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -363,6 +363,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 	struct clk *reg_clk = xhci->reg_clk;
 	struct usb_hcd *shared_hcd = xhci->shared_hcd;
 
+	pm_runtime_get_sync(&dev->dev);
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
 	usb_remove_hcd(shared_hcd);
@@ -376,8 +377,9 @@ static int xhci_plat_remove(struct platform_device *dev)
 	clk_disable_unprepare(reg_clk);
 	usb_put_hcd(hcd);
 
-	pm_runtime_set_suspended(&dev->dev);
 	pm_runtime_disable(&dev->dev);
+	pm_runtime_put_noidle(&dev->dev);
+	pm_runtime_set_suspended(&dev->dev);
 
 	return 0;
 }
-- 
2.25.1

