Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A02FF55BD
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391003AbfKHTEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388466AbfKHTEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4B11214DB;
        Fri,  8 Nov 2019 19:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239860;
        bh=v6nFBkWHje+2l2y3JQvhgZHFjpuNz+PM0WRCuLYQOo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1L2sbc+6YtL8GzPTy7d0+D9oybGGy3JjEhaggZVYZcpr0fuEZyAuT6P6lCiEfr7ME
         DzHqzXhfrU/qzMhx8Ahsqm3gsQdOLa3zdeqivSepeWNGvTgb6QBux8ku2V9am6qfoW
         ncEHxCHLw/2t04yD/ol/ne5txCdlIJQ18PH8BYHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 79/79] usb: gadget: udc: core: Fix segfault if udc_bind_to_driver() for pending driver fails
Date:   Fri,  8 Nov 2019 19:50:59 +0100
Message-Id: <20191108174829.668154458@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

commit 163be6ff7739b12ff300d77897d340f661821da2 upstream.

If a gadget driver is in the pending drivers list, a UDC
becomes available and udc_bind_to_driver() fails, then it
gets deleted from the pending list.
i.e. list_del(&driver->pending) in check_pending_gadget_drivers().

Then if that gadget driver is unregistered,
usb_gadget_unregister_driver() does a list_del(&driver->pending)
again thus causing a page fault as that list entry has been poisoned
by the previous list_del().

Fix this by using list_del_init() instead of list_del() in
check_pending_gadget_drivers().

Test case:

- Make sure no UDC is available
- modprobe g_mass_storage file=wrongfile
- Load UDC driver so it becomes available
	lun0: unable to open backing file: wrongfile
- modprobe -r g_mass_storage

[   60.900431] Unable to handle kernel paging request at virtual address dead000000000108
[   60.908346] Mem abort info:
[   60.911145]   ESR = 0x96000044
[   60.914227]   Exception class = DABT (current EL), IL = 32 bits
[   60.920162]   SET = 0, FnV = 0
[   60.923217]   EA = 0, S1PTW = 0
[   60.926354] Data abort info:
[   60.929228]   ISV = 0, ISS = 0x00000044
[   60.933058]   CM = 0, WnR = 1
[   60.936011] [dead000000000108] address between user and kernel address ranges
[   60.943136] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[   60.948691] Modules linked in: g_mass_storage(-) usb_f_mass_storage libcomposite xhci_plat_hcd xhci_hcd usbcore ti_am335x_adc kfifo_buf omap_rng cdns3 rng_core udc_core crc32_ce xfrm_user crct10dif_ce snd_so6
[   60.993995] Process modprobe (pid: 834, stack limit = 0x00000000c2aebc69)
[   61.000765] CPU: 0 PID: 834 Comm: modprobe Not tainted 4.19.59-01963-g065f42a60499 #92
[   61.008658] Hardware name: Texas Instruments SoC (DT)
[   61.014472] pstate: 60000005 (nZCv daif -PAN -UAO)
[   61.019253] pc : usb_gadget_unregister_driver+0x7c/0x108 [udc_core]
[   61.025503] lr : usb_gadget_unregister_driver+0x30/0x108 [udc_core]
[   61.031750] sp : ffff00001338fda0
[   61.035049] x29: ffff00001338fda0 x28: ffff800846d40000
[   61.040346] x27: 0000000000000000 x26: 0000000000000000
[   61.045642] x25: 0000000056000000 x24: 0000000000000800
[   61.050938] x23: ffff000008d7b0d0 x22: ffff0000088b07c8
[   61.056234] x21: ffff000001100000 x20: ffff000002020260
[   61.061530] x19: ffff0000010ffd28 x18: 0000000000000000
[   61.066825] x17: 0000000000000000 x16: 0000000000000000
[   61.072121] x15: 0000000000000000 x14: 0000000000000000
[   61.077417] x13: ffff000000000000 x12: ffffffffffffffff
[   61.082712] x11: 0000000000000030 x10: 7f7f7f7f7f7f7f7f
[   61.088008] x9 : fefefefefefefeff x8 : 0000000000000000
[   61.093304] x7 : ffffffffffffffff x6 : 000000000000ffff
[   61.098599] x5 : 8080000000000000 x4 : 0000000000000000
[   61.103895] x3 : ffff000001100020 x2 : ffff800846d40000
[   61.109190] x1 : dead000000000100 x0 : dead000000000200
[   61.114486] Call trace:
[   61.116922]  usb_gadget_unregister_driver+0x7c/0x108 [udc_core]
[   61.122828]  usb_composite_unregister+0x10/0x18 [libcomposite]
[   61.128643]  msg_cleanup+0x18/0xfce0 [g_mass_storage]
[   61.133682]  __arm64_sys_delete_module+0x17c/0x1f0
[   61.138458]  el0_svc_common+0x90/0x158
[   61.142192]  el0_svc_handler+0x2c/0x80
[   61.145926]  el0_svc+0x8/0xc
[   61.148794] Code: eb03003f d10be033 54ffff21 a94d0281 (f9000420)
[   61.154869] ---[ end trace afb22e9b637bd9a7 ]---
Segmentation fault

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1149,7 +1149,7 @@ static int check_pending_gadget_drivers(
 						dev_name(&udc->dev)) == 0) {
 			ret = udc_bind_to_driver(udc, driver);
 			if (ret != -EPROBE_DEFER)
-				list_del(&driver->pending);
+				list_del_init(&driver->pending);
 			break;
 		}
 


