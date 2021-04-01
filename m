Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F273F351AEB
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbhDASDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 14:03:42 -0400
Received: from comms.puri.sm ([159.203.221.185]:57236 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237028AbhDAR7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 13:59:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id B934CDF33F;
        Thu,  1 Apr 2021 06:11:26 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DHkhq2-1mdZF; Thu,  1 Apr 2021 06:11:24 -0700 (PDT)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     gregkh@linuxfoundation.org, balbi@kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-usb@vger.kernel.org, wcheng@codeaurora.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v2] Revert "usb: dwc3: gadget: Prevent EP queuing while stopping transfers"
Date:   Thu,  1 Apr 2021 15:11:08 +0200
Message-Id: <20210401131108.2149766-1-martin.kepplinger@puri.sm>
In-Reply-To: <YGXE0gQoj8HOzpuw@kroah.com>
References: <YGXE0gQoj8HOzpuw@kroah.com>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9de499997c ("usb: dwc3: gadget: Prevent EP queuing while stopping
transfers") results in the below error every time I connect the type-c
connector to the dwc3, configured with serial and ethernet gadgets.
I also apply the following to dwc3 on this port:

dr_mode = "otg";                                                        
snps,dis_u3_susphy_quirk;                                               
hnp-disable;                                                            
srp-disable;                                                            
adp-disable;                                                            
usb-role-switch;

[   51.148220] ------------[ cut here ]------------
[   51.148241] dwc3 38100000.usb: No resource for ep2in
[   51.148376] WARNING: CPU: 0 PID: 299 at drivers/usb/dwc3/gadget.c:360 dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
[   51.148837] CPU: 0 PID: 299 Comm: irq/64-dwc3 Not tainted 5.11.11-librem5-00334-ge4c4ff3624e9 #218
[   51.148848] Hardware name: Purism Librem 5r4 (DT)
[   51.148854] pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
[   51.148863] pc : dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
[   51.148894] lr : dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
[   51.148924] sp : ffff800011cb3ac0
[   51.148929] x29: ffff800011cb3ac0 x28: ffff0000032a7b00 
[   51.148942] x27: ffff00000327da00 x26: 0000000000000000 
[   51.148954] x25: 00000000ffffffea x24: 0000000000000006 
[   51.148967] x23: ffff0000bee1c080 x22: ffff800011cb3b7c 
[   51.148979] x21: 0000000000000406 x20: ffff0000bf170000 
[   51.148992] x19: 0000000000000001 x18: 0000000000000000 
[   51.149004] x17: 0000000000000000 x16: 0000000000000000 
[   51.149016] x15: 0000000000000000 x14: ffff8000114512c0 
[   51.149028] x13: 0000000000001698 x12: 0000000000000040 
[   51.149040] x11: ffff80001151a6f8 x10: 00000000ffffe000 
[   51.149052] x9 : ffff8000100b2b7c x8 : ffff80001146a6f8 
[   51.149065] x7 : ffff80001151a6f8 x6 : 0000000000000000 
[   51.149077] x5 : ffff0000bf939948 x4 : 0000000000000000 
[   51.149089] x3 : 0000000000000027 x2 : 0000000000000000 
[   51.149101] x1 : 0000000000000000 x0 : ffff0000049ae040 
[   51.149114] Call trace:
[   51.149120]  dwc3_send_gadget_ep_cmd+0x570/0x740 [dwc3]
[   51.149150]  __dwc3_gadget_ep_enable+0x288/0x4fc [dwc3]
[   51.149179]  dwc3_gadget_ep_enable+0x6c/0x15c [dwc3]
[   51.149209]  usb_ep_enable+0x48/0x110 [udc_core]
[   51.149251]  rndis_set_alt+0x138/0x1c0 [usb_f_rndis]
[   51.149276]  composite_setup+0x674/0x194c [libcomposite]
[   51.149314]  dwc3_ep0_interrupt+0x9c4/0xb9c [dwc3]
[   51.149344]  dwc3_thread_interrupt+0x8bc/0xe74 [dwc3]
[   51.149374]  irq_thread_fn+0x38/0xb0
[   51.149388]  irq_thread+0x170/0x294
[   51.149397]  kthread+0x164/0x16c
[   51.149407]  ret_from_fork+0x10/0x34
[   51.149419] ---[ end trace 62c6cc2ebfb18047 ]---

Linus' tree isn't affected. Revert the change.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>

---

 drivers/usb/dwc3/gadget.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 2a86ad4b12b3..ef8ecaf8655a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -783,6 +783,8 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	trace_dwc3_gadget_ep_disable(dep);
 
+	dwc3_remove_requests(dwc, dep);
+
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
 		__dwc3_gadget_ep_set_halt(dep, 0, false);
@@ -801,8 +803,6 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
-	dwc3_remove_requests(dwc, dep);
-
 	return 0;
 }
 
@@ -1617,7 +1617,7 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;
@@ -2150,7 +2150,6 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	if (!is_on) {
 		u32 count;
 
-		dwc->connected = false;
 		/*
 		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
 		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
@@ -2175,6 +2174,7 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
+		dwc->connected = false;
 	} else {
 		__dwc3_gadget_start(dwc);
 	}
@@ -3267,6 +3267,8 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 {
 	u32			reg;
 
+	dwc->connected = true;
+
 	/*
 	 * WORKAROUND: DWC3 revisions <1.88a have an issue which
 	 * would cause a missing Disconnect Event if there's a
@@ -3306,7 +3308,6 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 	 * transfers."
 	 */
 	dwc3_stop_active_transfers(dwc);
-	dwc->connected = true;
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg &= ~DWC3_DCTL_TSTCTRL_MASK;
-- 
2.30.2

