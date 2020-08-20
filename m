Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11BD24B7FB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgHTLHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbgHTKLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:11:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B0F92075E;
        Thu, 20 Aug 2020 10:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918279;
        bh=GhooaW3hdtXKn0ItJgcmyjtUMw/enKseYIB8M75Zn+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miHySCJ3NbZ7MKjO213dBKGzGvkyGTMtiT7S0OGFGRECqKUt2PJK1GAVbnSM3GGPJ
         a7BMIyknjhsf8Do9CcE3qmAsT7DrGItu6ECNJ5IcYDGQ6ooPYTkGYYNxz9v8gUGxap
         SuenK9Qu4UOHSpc2s8mMjWRlIe7ZlrtpxrvLcegg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 114/228] usb: dwc2: Fix error path in gadget registration
Date:   Thu, 20 Aug 2020 11:21:29 +0200
Message-Id: <20200820091613.291069275@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 33a06f1300a79cfd461cea0268f05e969d4f34ec ]

When gadget registration fails, one should not call usb_del_gadget_udc().
Ensure this by setting gadget->udc to NULL. Also in case of a failure
there is no need to disable low-level hardware, so return immiedetly
instead of jumping to error_init label.

This fixes the following kernel NULL ptr dereference on gadget failure
(can be easily triggered with g_mass_storage without any module
parameters):

dwc2 12480000.hsotg: dwc2_check_params: Invalid parameter besl=1
dwc2 12480000.hsotg: dwc2_check_params: Invalid parameter g_np_tx_fifo_size=1024
dwc2 12480000.hsotg: EPs: 16, dedicated fifos, 7808 entries in SPRAM
Mass Storage Function, version: 2009/09/11
LUN: removable file: (no medium)
no file given for LUN0
g_mass_storage 12480000.hsotg: failed to start g_mass_storage: -22
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000104
pgd = (ptrval)
[00000104] *pgd=00000000
Internal error: Oops: 805 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.8.0-rc5 #3133
Hardware name: Samsung Exynos (Flattened Device Tree)
Workqueue: events deferred_probe_work_func
PC is at usb_del_gadget_udc+0x38/0xc4
LR is at __mutex_lock+0x31c/0xb18
...
Process kworker/0:1 (pid: 12, stack limit = 0x(ptrval))
Stack: (0xef121db0 to 0xef122000)
...
[<c076bf3c>] (usb_del_gadget_udc) from [<c0726bec>] (dwc2_hsotg_remove+0x10/0x20)
[<c0726bec>] (dwc2_hsotg_remove) from [<c0711208>] (dwc2_driver_probe+0x57c/0x69c)
[<c0711208>] (dwc2_driver_probe) from [<c06247c0>] (platform_drv_probe+0x6c/0xa4)
[<c06247c0>] (platform_drv_probe) from [<c0621df4>] (really_probe+0x200/0x48c)
[<c0621df4>] (really_probe) from [<c06221e8>] (driver_probe_device+0x78/0x1fc)
[<c06221e8>] (driver_probe_device) from [<c061fcd4>] (bus_for_each_drv+0x74/0xb8)
[<c061fcd4>] (bus_for_each_drv) from [<c0621b54>] (__device_attach+0xd4/0x16c)
[<c0621b54>] (__device_attach) from [<c0620c98>] (bus_probe_device+0x88/0x90)
[<c0620c98>] (bus_probe_device) from [<c06211b0>] (deferred_probe_work_func+0x3c/0xd0)
[<c06211b0>] (deferred_probe_work_func) from [<c0149280>] (process_one_work+0x234/0x7dc)
[<c0149280>] (process_one_work) from [<c014986c>] (worker_thread+0x44/0x51c)
[<c014986c>] (worker_thread) from [<c0150b1c>] (kthread+0x158/0x1a0)
[<c0150b1c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
Exception stack(0xef121fb0 to 0xef121ff8)
...
---[ end trace 9724c2fc7cc9c982 ]---

While fixing this also fix the double call to dwc2_lowlevel_hw_disable()
if dr_mode is set to USB_DR_MODE_PERIPHERAL. In such case low-level
hardware is already disabled before calling usb_add_gadget_udc(). That
function correctly preserves low-level hardware state, there is no need
for the second unconditional dwc2_lowlevel_hw_disable() call.

Fixes: 207324a321a8 ("usb: dwc2: Postponed gadget registration to the udc class driver")
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 442cb93935dd4..405dccf92a315 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -459,6 +459,7 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	if (hsotg->gadget_enabled) {
 		retval = usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
 		if (retval) {
+			hsotg->gadget.udc = NULL;
 			dwc2_hsotg_remove(hsotg);
 			goto error;
 		}
@@ -467,7 +468,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	return 0;
 
 error:
-	dwc2_lowlevel_hw_disable(hsotg);
+	if (hsotg->dr_mode != USB_DR_MODE_PERIPHERAL)
+		dwc2_lowlevel_hw_disable(hsotg);
 	return retval;
 }
 
-- 
2.25.1



