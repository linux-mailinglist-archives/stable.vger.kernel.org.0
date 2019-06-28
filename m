Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6030B5A37B
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfF1SYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36185 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfF1SYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so2950928pgg.3
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QyWp4X95ZOlj3HRqIqq5Np/f7SP+VBBbMvRFL8CO2Wg=;
        b=XIPcfHO4VsSPLqfzuX9EknWyUzKfZeNAGlgIl5DvpfyFARsmMtjqfOY9qznNxUVvDi
         caVVSaQpoCa65JBY0X3Qb5xTxNujl3yXqzpywqRXH0uQs/6Ud50ltEiY4l5cJHqIjgtP
         dSryzxy3/sMCJTZsQa49DUJPyZ3DpIf4ywu+RZS917/y8pAWmhf1gDGDxUEHFe9AiSaC
         1plqPiHWm+iGP+KJ4nVifefFRThInHn0fUUDeOYrBiL3i4yuXW2BHiFk4+6r3Y35ciR0
         ENHyMYGYZNAcKNDDTAwP+2Ll45JJZCUTAk+14Y5vguVCp0jILTZP3wCpSpAxbBF8d7rF
         us4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QyWp4X95ZOlj3HRqIqq5Np/f7SP+VBBbMvRFL8CO2Wg=;
        b=FyHH0r7pCu06uWZt5saZbcp2QYPKi3SH+7vRyzk0NqOvia7nyhmVVwDXWzQvew+yJ7
         uioVzu1AVN1h1CUrqgnTq95BF3nGj2mVZ5L1gQli+1lYtHAHWwwJhitTEND+ThOION7C
         QB5qDe49JElMWzWKeMTOvyb/1gJHCLl1zjca6eRhpD2i5JWGgGZWmepB4qBBXrYSTEyo
         KZv0HJ0XkFNGRKj4Akvtff2oN+o2KhQAjpMAPSg4A/nEvMjqfLydbKmkNWBXo5ulTLHx
         xhMNkcXmGpsnDWV8vUUXQrMBBGnjDzYCmCsfsJZ4I4kLjVIwJl8u2syGQVClUHAwyori
         NWVw==
X-Gm-Message-State: APjAAAUoBqCWiw49x7lgWZLnKzJqCBJwn9ruZJBo343nemLgUdMc4KfE
        K7Qhm20AfbZllhu6Dd0hmJWVOwormw8=
X-Google-Smtp-Source: APXvYqy2cKPm9RfrknaLyyXtYPWo4W7FTtXpZsIaLCs1GrPvCW6CaTrvDh1U3tvruLyd2zuJea0bHg==
X-Received: by 2002:a63:c0f:: with SMTP id b15mr10554185pgl.33.1561746271000;
        Fri, 28 Jun 2019 11:24:31 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:30 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y v2 8/9] usb: dwc3: gadget: remove wait_end_transfer
Date:   Fri, 28 Jun 2019 18:24:12 +0000
Message-Id: <20190628182413.33225-9-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
References: <20190628182413.33225-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

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
2.17.1

