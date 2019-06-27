Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9658C10
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfF0Uw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:52:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37195 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfF0Uw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:52:57 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so1818447pfa.4
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sJy5RsZ+XgQxP8NLHGHXPC++ycB1Ut5oAgR2rBDauhI=;
        b=eV+URhzutNlGwIftbtsLHQnZL/iqKcoUJpTwLk6FovaHQF/pihPA4h8aU4Zpny0ymN
         NqrEyZ9vDESdgjnnCKHLxNAjPNhH2fF7mNaRFVY1JCmUh7QwS4j7MBKU+fVjB+Av1f6m
         HZumFLQ5tSHeyaGF/unoC3vzkXGwV8/W60N80XgvyOGy4PKAT13CFRMA+TMWolda16Qt
         VjZ4RJXR9SHAGHPnQBEikUydJCmQXNitcDWkG5SJd0M2rKwrs1aWi+KOm2+F3yoLkSfe
         UrB2IWO2ozLNTSRqcwVfpjaKM292fnrMcjYqBXw2hKegjPX3X9MuFrl5BU6P8q1zTeaR
         eZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sJy5RsZ+XgQxP8NLHGHXPC++ycB1Ut5oAgR2rBDauhI=;
        b=dQ/YrWrpzle1x49J0DHxHCKad0dGSFGAcct8GLznwCHvXcysSHTihDayZne+X3D/8V
         33m2CfpEI/y944FsNZ2gI6yv3B/yafphwdfYeFcnQPoE/F1O5Yr/FNBLbmT49xTG9gcy
         OqybT/4wo4sBGlUXc4GX7lLLX8VaJ6t65qOUTb+DQVt0gN6IempoXFHOGNzHFbCp5iHU
         ACFgK1w7dxDFmkW2Ev3JA3R2vkI/KGeL69cRHKg+eCIr/UPqM/vqbqEhFOmb43Wv6ZYm
         iOtdgYlKO9c4pW8TqMGpEZHo6UCFhUbT6BmREtAEodc7w3s1CKxlOao/48bvopCQ6eIp
         X8lw==
X-Gm-Message-State: APjAAAXe8sgiMFGIkP8fUtc3FmjW2hggH9ywgx8xBZ2rqnyk+aughasg
        U1+BW5T+Y+9RSkFRkZiZqtob1ryX9Q8=
X-Google-Smtp-Source: APXvYqx6BBy9Nzx+u+U0xZbdLTdsXsNMmWr2PYmfOqM0/uZF8Eo8cbUuQX5EkeX7TpofkKfNfpKylg==
X-Received: by 2002:a17:90a:be0a:: with SMTP id a10mr8017668pjs.112.1561668775599;
        Thu, 27 Jun 2019 13:52:55 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:54 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y 7/9] usb: dwc3: gadget: remove wait_end_transfer
Date:   Thu, 27 Jun 2019 20:52:38 +0000
Message-Id: <20190627205240.38366-8-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
References: <20190627205240.38366-1-john.stultz@linaro.org>
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
index 25cdce359736..879f652c5580 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -640,8 +640,6 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 		reg |= DWC3_DALEPENA_EP(dep->number);
 		dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-		init_waitqueue_head(&dep->wait_end_transfer);
-
 		if (usb_endpoint_xfer_control(desc))
 			goto out;
 
@@ -1406,15 +1404,11 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
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
@@ -1915,8 +1909,6 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
 	unsigned long		flags;
-	int			epnum;
-	u32			tmo_eps = 0;
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
@@ -1925,36 +1917,6 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
 
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
@@ -2451,7 +2413,7 @@ static void dwc3_endpoint_interrupt(struct dwc3 *dwc,
 
 		if (cmd == DWC3_DEPCMD_ENDTRANSFER) {
 			dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
-			wake_up(&dep->wait_end_transfer);
+			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
 		}
 		break;
 	case DWC3_DEPEVT_STREAMEVT:
-- 
2.17.1

