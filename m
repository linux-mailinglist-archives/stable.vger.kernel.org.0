Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7941F2E6A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgFIAlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729179AbgFHXMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED3E120B80;
        Mon,  8 Jun 2020 23:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657964;
        bh=Pw+uE7w66ONxK6HEqx37M2kKiXg5EV9h56q4lFMzfmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+Ar3MN3qA881h/WWKARibazK8fywXO33Xer+JnsXZotC1Nbpf/j3QU62oLINVC02
         b3zCpMMnIWDdYV1wkQgn7hGyV2Xc3mshoboCZMbNnyFzeRONdKp2dxJgmamnVzAiwH
         pmfOT4hZf70F0KMzc2nEck8JP4JUSfRIzQU4PcSE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 028/606] usb: cdns3: gadget: prev_req->trb is NULL for ep0
Date:   Mon,  8 Jun 2020 19:02:33 -0400
Message-Id: <20200608231211.3363633-28-sashal@kernel.org>
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

From: Peter Chen <peter.chen@nxp.com>

commit 95cd7dc47abd71d1a0c9c43594ff2fa32552f46c upstream.

And there are no multiple TRBs on EP0 and WA1 workaround,
so it doesn't need to change TRB for EP0. It fixes below oops.

configfs-gadget gadget: high-speed config #1: b
android_work: sent uevent USB_STATE=CONFIGURED
Unable to handle kernel read from unreadable memory at virtual address 0000000000000008
Mem abort info:
android_work: sent uevent USB_STATE=DISCONNECTED
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits

  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=00000008b5bb7000
[0000000000000008] pgd=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 430 Comm: HwBinder:401_1 Not tainted 5.4.24-06071-g6fa8921409c1-dirty #77
Hardware name: Freescale i.MX8QXP MEK (DT)
pstate: 60400085 (nZCv daIf +PAN -UAO)
pc : cdns3_gadget_ep_dequeue+0x1d4/0x270
lr : cdns3_gadget_ep_dequeue+0x48/0x270
sp : ffff800012763ba0
x29: ffff800012763ba0 x28: ffff00082c653c00
x27: 0000000000000000 x26: ffff000068fa7b00
x25: ffff0000699b2000 x24: ffff00082c6ac000
x23: ffff000834f0a480 x22: ffff000834e87b9c
x21: 0000000000000000 x20: ffff000834e87800
x19: ffff000069eddc00 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 0000000000000000
x13: 0000000000000000 x12: 0000000000000001
x11: ffff80001180fbe8 x10: 0000000000000001
x9 : ffff800012101558 x8 : 0000000000000001
x7 : 0000000000000006 x6 : ffff000835d9c668
x5 : ffff000834f0a4c8 x4 : 0000000096000000
x3 : 0000000000001810 x2 : 0000000000000000
x1 : ffff800024bd001c x0 : 0000000000000001
Call trace:
 cdns3_gadget_ep_dequeue+0x1d4/0x270
 usb_ep_dequeue+0x34/0xf8
 composite_dev_cleanup+0x154/0x170
 configfs_composite_unbind+0x6c/0xa8
 usb_gadget_remove_driver+0x44/0x70
 usb_gadget_unregister_driver+0x74/0xe0
 unregister_gadget+0x28/0x58
 gadget_dev_desc_UDC_store+0x80/0x110
 configfs_write_file+0x1e0/0x2a0
 __vfs_write+0x48/0x90
 vfs_write+0xe4/0x1c8
 ksys_write+0x78/0x100
 __arm64_sys_write+0x24/0x30
 el0_svc_common.constprop.0+0x74/0x168
 el0_svc_handler+0x34/0xa0
 el0_svc+0x8/0xc
Code: 52830203 b9407660 f94042e4 11000400 (b9400841)
---[ end trace 1574516e4c1772ca ]---
Kernel panic - not syncing: Fatal exception
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x0002,20002008
Memory Limit: none
Rebooting in 5 seconds..

Fixes: f616c3bda47e ("usb: cdns3: Fix dequeue implementation")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 3574dbb09366..a5cccbd5d356 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2548,7 +2548,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	link_trb = priv_req->trb;
 
 	/* Update ring only if removed request is on pending_req_list list */
-	if (req_on_hw_ring) {
+	if (req_on_hw_ring && link_trb) {
 		link_trb->buffer = TRB_BUFFER(priv_ep->trb_pool_dma +
 			((priv_req->end_trb + 1) * TRB_SIZE));
 		link_trb->control = (link_trb->control & TRB_CYCLE) |
-- 
2.25.1

