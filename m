Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3335CB97
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfGBIOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbfGBIGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E83620659;
        Tue,  2 Jul 2019 08:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054772;
        bh=f31brRCLJwDLQmLPVh+HVaNtwvSkOXwIuRLFN02XLk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiAK2WldXgM9gPEnZb+KGesKg7uk8vV5SMPFVyvdSMfKIYtsB4vaGAgUYU2073uOv
         ZJznXlXfcg6FSeixClqi/2yjCXImZvyGd+D6nXewlnqfkR1R/XEf+jSrB7N69+s7DY
         nYAwneJpfJdIyGYprMTP0XZdkK2uS8uo4uClTOzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/72] usb: dwc3: gadget: remove wait_end_transfer
Date:   Tue,  2 Jul 2019 10:01:31 +0200
Message-Id: <20190702080126.229595910@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fec9095bdef4e7c988adb603d0d4f92ee735d4a1 upstream

Now that we have a list of cancelled requests, we can skip over TRBs
when END_TRANSFER command completes.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit fec9095bdef4e7c988adb603d0d4f92ee735d4a1)
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h   |  3 ---
 drivers/usb/dwc3/gadget.c | 40 +--------------------------------------
 2 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 24f0b108b7f6..131028501752 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -639,7 +639,6 @@ struct dwc3_event_buffer {
  * @cancelled_list: list of cancelled requests for this endpoint
  * @pending_list: list of pending requests for this endpoint
  * @started_list: list of started requests on this endpoint
- * @wait_end_transfer: wait_queue_head_t for waiting on End Transfer complete
  * @lock: spinlock for endpoint request queue traversal
  * @regs: pointer to first endpoint register
  * @trb_pool: array of transaction buffers
@@ -664,8 +663,6 @@ struct dwc3_ep {
 	struct list_head	pending_list;
 	struct list_head	started_list;
 
-	wait_queue_head_t	wait_end_transfer;
-
 	spinlock_t		lock;
 	void __iomem		*regs;
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8291fa1624e1..843586f20572 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -638,8 +638,6 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 		reg |= DWC3_DALEPENA_EP(dep->number);
 		dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-		init_waitqueue_head(&dep->wait_end_transfer);
-
 		if (usb_endpoint_xfer_control(desc))
 			goto out;
 
@@ -1404,15 +1402,11 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		if (r == req) {
 			/* wait until it is processed */
 			dwc3_stop_active_transfer(dep, true);
-			wait_event_lock_irq(dep->wait_end_transfer,
-					!(dep->flags & DWC3_EP_END_TRANSFER_PENDING),
-					dwc->lock);
 
 			if (!r->trb)
 				goto out0;
 
 			dwc3_gadget_move_cancelled_request(req);
-			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
 			goto out0;
 		}
 		dev_err(dwc->dev, "request %pK was not queued to %s\n",
@@ -1913,8 +1907,6 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
 	unsigned long		flags;
-	int			epnum;
-	u32			tmo_eps = 0;
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
@@ -1923,36 +1915,6 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
 
 	__dwc3_gadget_stop(dwc);
 
-	for (epnum = 2; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
-		struct dwc3_ep  *dep = dwc->eps[epnum];
-		int ret;
-
-		if (!dep)
-			continue;
-
-		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING))
-			continue;
-
-		ret = wait_event_interruptible_lock_irq_timeout(dep->wait_end_transfer,
-			    !(dep->flags & DWC3_EP_END_TRANSFER_PENDING),
-			    dwc->lock, msecs_to_jiffies(5));
-
-		if (ret <= 0) {
-			/* Timed out or interrupted! There's nothing much
-			 * we can do so we just log here and print which
-			 * endpoints timed out at the end.
-			 */
-			tmo_eps |= 1 << epnum;
-			dep->flags &= DWC3_EP_END_TRANSFER_PENDING;
-		}
-	}
-
-	if (tmo_eps) {
-		dev_err(dwc->dev,
-			"end transfer timed out on endpoints 0x%x [bitmap]\n",
-			tmo_eps);
-	}
-
 out:
 	dwc->gadget_driver	= NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
@@ -2449,7 +2411,7 @@ static void dwc3_endpoint_interrupt(struct dwc3 *dwc,
 
 		if (cmd == DWC3_DEPCMD_ENDTRANSFER) {
 			dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
-			wake_up(&dep->wait_end_transfer);
+			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
 		}
 		break;
 	case DWC3_DEPEVT_STREAMEVT:
-- 
2.20.1



