Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4967639003
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbfFGPsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731673AbfFGPr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:47:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9855520657;
        Fri,  7 Jun 2019 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922478;
        bh=uk9iWgIvFA2EHn8BLUy7cdyrWZfY3ejwj8TKzdlqoSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxLjQwiRGl/F2zHqwUbsGKhOsYM3QExvvrFAc6puBgjNw9bOkUmeh/NjawtiZOPMS
         3nlRiBBs7HRM3y24sLNSA8AM65b0cga9pH1lWAIH072vcCZli5XQ3DAt87JayQi3oB
         yQlD/40APxm1GbfpNhrmWZxh8ZwmgGZ8LKTMXiyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carsten Schmid <carsten_schmid@mentor.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.1 06/85] usb: xhci: avoid null pointer deref when bos field is NULL
Date:   Fri,  7 Jun 2019 17:38:51 +0200
Message-Id: <20190607153849.866407099@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carsten Schmid <carsten_schmid@mentor.com>

commit 7aa1bb2ffd84d6b9b5f546b079bb15cd0ab6e76e upstream.

With defective USB sticks we see the following error happen:
usb 1-3: new high-speed USB device number 6 using xhci_hcd
usb 1-3: device descriptor read/64, error -71
usb 1-3: device descriptor read/64, error -71
usb 1-3: new high-speed USB device number 7 using xhci_hcd
usb 1-3: device descriptor read/64, error -71
usb 1-3: unable to get BOS descriptor set
usb 1-3: New USB device found, idVendor=0781, idProduct=5581
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
...
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008

This comes from the following place:
[ 1660.215380] IP: xhci_set_usb2_hardware_lpm+0xdf/0x3d0 [xhci_hcd]
[ 1660.222092] PGD 0 P4D 0
[ 1660.224918] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 1660.425520] CPU: 1 PID: 38 Comm: kworker/1:1 Tainted: P     U  W  O    4.14.67-apl #1
[ 1660.434277] Workqueue: usb_hub_wq hub_event [usbcore]
[ 1660.439918] task: ffffa295b6ae4c80 task.stack: ffffad4580150000
[ 1660.446532] RIP: 0010:xhci_set_usb2_hardware_lpm+0xdf/0x3d0 [xhci_hcd]
[ 1660.453821] RSP: 0018:ffffad4580153c70 EFLAGS: 00010046
[ 1660.459655] RAX: 0000000000000000 RBX: ffffa295b4d7c000 RCX: 0000000000000002
[ 1660.467625] RDX: 0000000000000002 RSI: ffffffff984a55b2 RDI: ffffffff984a55b2
[ 1660.475586] RBP: ffffad4580153cc8 R08: 0000000000d6520a R09: 0000000000000001
[ 1660.483556] R10: ffffad4580a004a0 R11: 0000000000000286 R12: ffffa295b4d7c000
[ 1660.491525] R13: 0000000000010648 R14: ffffa295a84e1800 R15: 0000000000000000
[ 1660.499494] FS:  0000000000000000(0000) GS:ffffa295bfc80000(0000) knlGS:0000000000000000
[ 1660.508530] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1660.514947] CR2: 0000000000000008 CR3: 000000025a114000 CR4: 00000000003406a0
[ 1660.522917] Call Trace:
[ 1660.525657]  usb_set_usb2_hardware_lpm+0x3d/0x70 [usbcore]
[ 1660.531792]  usb_disable_device+0x242/0x260 [usbcore]
[ 1660.537439]  usb_disconnect+0xc1/0x2b0 [usbcore]
[ 1660.542600]  hub_event+0x596/0x18f0 [usbcore]
[ 1660.547467]  ? trace_preempt_on+0xdf/0x100
[ 1660.552040]  ? process_one_work+0x1c1/0x410
[ 1660.556708]  process_one_work+0x1d2/0x410
[ 1660.561184]  ? preempt_count_add.part.3+0x21/0x60
[ 1660.566436]  worker_thread+0x2d/0x3f0
[ 1660.570522]  kthread+0x122/0x140
[ 1660.574123]  ? process_one_work+0x410/0x410
[ 1660.578792]  ? kthread_create_on_node+0x60/0x60
[ 1660.583849]  ret_from_fork+0x3a/0x50
[ 1660.587839] Code: 00 49 89 c3 49 8b 84 24 50 16 00 00 8d 4a ff 48 8d 04 c8 48 89 ca 4c 8b 10 45 8b 6a 04 48 8b 00 48 89 45 c0 49 8b 86 80 03 00 00 <48> 8b 40 08 8b 40 03 0f 1f 44 00 00 45 85 ff 0f 84 81 01 00 00
[ 1660.608980] RIP: xhci_set_usb2_hardware_lpm+0xdf/0x3d0 [xhci_hcd] RSP: ffffad4580153c70
[ 1660.617921] CR2: 0000000000000008

Tracking this down shows that udev->bos is NULL in the following code:
(xhci.c, in xhci_set_usb2_hardware_lpm)
	field = le32_to_cpu(udev->bos->ext_cap->bmAttributes);  <<<<<<< here

	xhci_dbg(xhci, "%s port %d USB2 hardware LPM\n",
			enable ? "enable" : "disable", port_num + 1);

	if (enable) {
		/* Host supports BESL timeout instead of HIRD */
		if (udev->usb2_hw_lpm_besl_capable) {
			/* if device doesn't have a preferred BESL value use a
			 * default one which works with mixed HIRD and BESL
			 * systems. See XHCI_DEFAULT_BESL definition in xhci.h
			 */
			if ((field & USB_BESL_SUPPORT) &&
			    (field & USB_BESL_BASELINE_VALID))
				hird = USB_GET_BESL_BASELINE(field);
			else
				hird = udev->l1_params.besl;

The failing case is when disabling LPM. So it is sufficient to avoid
access to udev->bos by moving the instruction into the "enable" clause.

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Carsten Schmid <carsten_schmid@mentor.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4287,7 +4287,6 @@ static int xhci_set_usb2_hardware_lpm(st
 	pm_addr = ports[port_num]->addr + PORTPMSC;
 	pm_val = readl(pm_addr);
 	hlpm_addr = ports[port_num]->addr + PORTHLPMC;
-	field = le32_to_cpu(udev->bos->ext_cap->bmAttributes);
 
 	xhci_dbg(xhci, "%s port %d USB2 hardware LPM\n",
 			enable ? "enable" : "disable", port_num + 1);
@@ -4299,6 +4298,7 @@ static int xhci_set_usb2_hardware_lpm(st
 			 * default one which works with mixed HIRD and BESL
 			 * systems. See XHCI_DEFAULT_BESL definition in xhci.h
 			 */
+			field = le32_to_cpu(udev->bos->ext_cap->bmAttributes);
 			if ((field & USB_BESL_SUPPORT) &&
 			    (field & USB_BESL_BASELINE_VALID))
 				hird = USB_GET_BESL_BASELINE(field);


