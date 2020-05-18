Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF231D8388
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgERSFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733063AbgERSFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FEE20671;
        Mon, 18 May 2020 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825137;
        bh=iVaQ01TA7rrWyhKD+pi6al0fOTLwJwW1sYYX16Xtivw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNUbu+RC2w/OXk50ZOP4HtpDEGyp6pMB3u98oOV7knozTRVYYbTqiwXXmzEXt7UDK
         cxXcrIqJrLH+n2ZLIbv4gqjvfP1zsxmioftk8d81UUolovvg/0YPk3aUwsHdiH2a8w
         jVhQC+0bzJVXn4wZj6lpPRMJYfVOV5nPLHQYkKNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.6 144/194] usb: cdns3: gadget: prev_req->trb is NULL for ep0
Date:   Mon, 18 May 2020 19:37:14 +0200
Message-Id: <20200518173543.271587521@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/usb/cdns3/gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2548,7 +2548,7 @@ found:
 	link_trb = priv_req->trb;
 
 	/* Update ring only if removed request is on pending_req_list list */
-	if (req_on_hw_ring) {
+	if (req_on_hw_ring && link_trb) {
 		link_trb->buffer = TRB_BUFFER(priv_ep->trb_pool_dma +
 			((priv_req->end_trb + 1) * TRB_SIZE));
 		link_trb->control = (link_trb->control & TRB_CYCLE) |


