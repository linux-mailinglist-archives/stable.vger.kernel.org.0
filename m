Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35691FDB00
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgFRBJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbgFRBJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F50621D81;
        Thu, 18 Jun 2020 01:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442579;
        bh=DR76S6pTZKwYRUjcbhVCnP8jA8NO6j21CH90ZF38xSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gst0XwWPzT/WYQ2JRdPWkXyQXhY2U25aGrWURekB6UqhkpJ97O/fX2PfECJbO6FVf
         2od6Rt/DOTDoUHKy/EYI6GJKQ+IwWGT46NtF1Z2JDqv4ES30Wrqy+Y9kT3mxMwGY1Y
         jx5uPU0xwJQpp62H8/XAge50cQc/WQuEQacBva3E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>, Jun Li <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 071/388] usb: gadget: core: sync interrupt before unbind the udc
Date:   Wed, 17 Jun 2020 21:02:48 -0400
Message-Id: <20200618010805.600873-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 3c73bc52195def14165c3a7d91bdbb33b51725f5 ]

The threaded interrupt handler may still be called after the
usb_gadget_disconnect is called, it causes the structures used
at interrupt handler was freed before it uses, eg the
usb_request. This issue usually occurs we remove the udc function
during the transfer. Below is the example when doing stress
test for android switch function, the EP0's request is freed
by .unbind (configfs_composite_unbind -> composite_dev_cleanup),
but the threaded handler accesses this request during handling
setup packet request.

In fact, there is no protection between unbind the udc
and udc interrupt handling, so we have to avoid the interrupt
handler is occurred or scheduled during the .unbind flow.

init: Sending signal 9 to service 'adbd' (pid 18077) process group...
android_work: did not send uevent (0 0 000000007bec2039)
libprocessgroup: Successfully killed process cgroup uid 0 pid 18077 in 6ms
init: Service 'adbd' (pid 18077) received signal 9
init: Sending signal 9 to service 'adbd' (pid 18077) process group...
libprocessgroup: Successfully killed process cgroup uid 0 pid 18077 in 0ms
init: processing action (init.svc.adbd=stopped) from (/init.usb.configfs.rc:14)
init: Received control message 'start' for 'adbd' from pid: 399 (/vendor/bin/hw/android.hardware.usb@1.

init: starting service 'adbd'...
read descriptors
read strings
Unable to handle kernel read from unreadable memory at virtual address 000000000000002a
android_work: sent uevent USB_STATE=CONNECTED
Mem abort info:
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=00000000e97f1000
using random self ethernet address
[000000000000002a] pgd=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 232 Comm: irq/68-5b110000 Not tainted 5.4.24-06075-g94a6b52b5815 #92
Hardware name: Freescale i.MX8QXP MEK (DT)
pstate: 00400085 (nzcv daIf +PAN -UAO)
using random host ethernet address
pc : composite_setup+0x5c/0x1730
lr : android_setup+0xc0/0x148
sp : ffff80001349bba0
x29: ffff80001349bba0 x28: ffff00083a50da00
x27: ffff8000124e6000 x26: ffff800010177950
x25: 0000000000000040 x24: ffff000834e18010
x23: 0000000000000000 x22: 0000000000000000
x21: ffff00083a50da00 x20: ffff00082e75ec40
x19: 0000000000000000 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 0000000000000000
x13: 0000000000000000 x12: 0000000000000001
x11: ffff80001180fb58 x10: 0000000000000040
x9 : ffff8000120fc980 x8 : 0000000000000000
x7 : ffff00083f98df50 x6 : 0000000000000100
x5 : 00000307e8978431 x4 : ffff800011386788
x3 : 0000000000000000 x2 : ffff800012342000
x1 : 0000000000000000 x0 : ffff800010c6d3a0
Call trace:
 composite_setup+0x5c/0x1730
 android_setup+0xc0/0x148
 cdns3_ep0_delegate_req+0x64/0x90
 cdns3_check_ep0_interrupt_proceed+0x384/0x738
 cdns3_device_thread_irq_handler+0x124/0x6e0
 cdns3_thread_irq+0x94/0xa0
 irq_thread_fn+0x30/0xa0
 irq_thread+0x150/0x248
 kthread+0xfc/0x128
 ret_from_fork+0x10/0x18
Code: 910e8000 f9400693 12001ed7 79400f79 (3940aa61)
---[ end trace c685db37f8773fba ]---
Kernel panic - not syncing: Fatal exception
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x0002,20002008
Memory Limit: none
Rebooting in 5 seconds..

Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 2 ++
 include/linux/usb/gadget.h    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 9b11046480fe..2e28dde8376f 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1297,6 +1297,8 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
 
 	usb_gadget_disconnect(udc->gadget);
+	if (udc->gadget->irq)
+		synchronize_irq(udc->gadget->irq);
 	udc->driver->unbind(udc->gadget);
 	usb_gadget_udc_stop(udc);
 
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 9411c08a5c7e..73a6113322c6 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -373,6 +373,7 @@ struct usb_gadget_ops {
  * @connected: True if gadget is connected.
  * @lpm_capable: If the gadget max_speed is FULL or HIGH, this flag
  *	indicates that it supports LPM as per the LPM ECN & errata.
+ * @irq: the interrupt number for device controller.
  *
  * Gadgets have a mostly-portable "gadget driver" implementing device
  * functions, handling all usb configurations and interfaces.  Gadget
@@ -427,6 +428,7 @@ struct usb_gadget {
 	unsigned			deactivated:1;
 	unsigned			connected:1;
 	unsigned			lpm_capable:1;
+	int				irq;
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
 
-- 
2.25.1

