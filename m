Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F28D3EA947
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhHLRR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbhHLRRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:22 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FD6C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:16:56 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id m17so7823916ljp.7
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zHvbBW4lV0QizVxi+vaN4KwZHXd+SWvkHulD44y2YEs=;
        b=E53g7PYcPF+Fyb6+TRDW5Ox6YNr3Gl3QL6i/I6cEjn8jkkFFv0sJ9xmGbfDUTPcP5o
         q74i8RfxtRJHJf6QUsBJkx7dZztqyzt0kdQI8aJbZQopTmitsJRslmLdZ0Ifalgs0J+d
         sD9FSVB39UeTKUBSsvWGDktT3XgARl3gKqJSGVmJHfMIqRSVzE3UxxiYwxBdDIMqyd+G
         +RXFUAG6ztp3dpwCDYTLQn+AvPcQryChpLAEZtmEzY42oR57i5njnjvO+r/AEp3tbD8i
         LyWyVRCF4EHl/UVajBW+cRx0dICZaoP/VUcHRLE5Z/pK9bE78OuJzTzGmLDi+JuZvNHr
         gOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zHvbBW4lV0QizVxi+vaN4KwZHXd+SWvkHulD44y2YEs=;
        b=mO7FAt/w6FuOe1lCSTVXB+RqdFs5+2qFpjTxAhFQKx43EuNykmMlR3zCFUKvxey7gf
         ZbDvXJMXfbikxNVegGp6/kNPJe78dbKDBZUiGEChjix8uAnpY94FzHwmT3dZ2M9j1yV9
         zbJKCzBup/hbOMMk33/IxwoZXJ84js7senPVsx7oR8rVgxJKHrNa1TdorQ8ejrQxA5wt
         kdESesmP0xxvou3LEbUYRzxkIvFwFQEn2F7KJX/uhvIkHelMz5AQK6nNIw6yU9rbsh+G
         QsBkQaUWuICj+imDAE0QYzkfpMX6VO9hiOhIJ1F0ysh8eEyFDh8ngnJl/05qKTe4kbgn
         7Wiw==
X-Gm-Message-State: AOAM532duwPLQJjXAvTjLqj9OyXV1ycctVsXsKnl9Tj/OxfafA5dSR5Q
        qktNVdI+WHVHZyrWS6uJvb6iiA==
X-Google-Smtp-Source: ABdhPJwwbW5Om9A7h0DuaanCqDG+CMyAaAqwhd35qejTKaScjakgCtnDGAnMowqghTxmR1Kzmv2f8A==
X-Received: by 2002:a2e:9956:: with SMTP id r22mr3790854ljj.68.1628788615058;
        Thu, 12 Aug 2021 10:16:55 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id j1sm372905lji.124.2021.08.12.10.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:16:54 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 1/7] usb: dwc3: Stop active transfers before halting the controller
Date:   Thu, 12 Aug 2021 20:16:46 +0300
Message-Id: <20210812171652.23803-2-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit ae7e86108b12351028fa7e8796a59f9b2d9e1774 ]

In the DWC3 databook, for a device initiated disconnect or bus reset, the
driver is required to send dependxfer commands for any pending transfers.
In addition, before the controller can move to the halted state, the SW
needs to acknowledge any pending events.  If the controller is not halted
properly, there is a chance the controller will continue accessing stale or
freed TRBs and buffers.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/dwc3/ep0.c    |  2 +-
 drivers/usb/dwc3/gadget.c | 66 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 03b444f753aa..4f28122f1bb8 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -197,7 +197,7 @@ int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 	int				ret;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-	if (!dep->endpoint.desc) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		ret = -ESHUTDOWN;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 9cf66636b19d..94c430dcce5d 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1511,7 +1511,7 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;
@@ -1931,6 +1931,21 @@ static int dwc3_gadget_set_selfpowered(struct usb_gadget *g,
 	return 0;
 }
 
+static void dwc3_stop_active_transfers(struct dwc3 *dwc)
+{
+	u32 epnum;
+
+	for (epnum = 2; epnum < dwc->num_eps; epnum++) {
+		struct dwc3_ep *dep;
+
+		dep = dwc->eps[epnum];
+		if (!dep)
+			continue;
+
+		dwc3_remove_requests(dwc, dep);
+	}
+}
+
 static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 {
 	u32			reg;
@@ -1976,6 +1991,9 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 	return 0;
 }
 
+static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
+static void __dwc3_gadget_stop(struct dwc3 *dwc);
+
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
@@ -1999,7 +2017,46 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 		}
 	}
 
+	/*
+	 * Synchronize any pending event handling before executing the controller
+	 * halt routine.
+	 */
+	if (!is_on) {
+		dwc3_gadget_disable_irq(dwc);
+		synchronize_irq(dwc->irq_gadget);
+	}
+
 	spin_lock_irqsave(&dwc->lock, flags);
+
+	if (!is_on) {
+		u32 count;
+
+		/*
+		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
+		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
+		 * disconnect, the SW needs to ensure that it sends "a DEPENDXFER
+		 * command for any active transfers" before clearing the RunStop
+		 * bit.
+		 */
+		dwc3_stop_active_transfers(dwc);
+		__dwc3_gadget_stop(dwc);
+
+		/*
+		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
+		 * Section 1.3.4, it mentions that for the DEVCTRLHLT bit, the
+		 * "software needs to acknowledge the events that are generated
+		 * (by writing to GEVNTCOUNTn) while it is waiting for this bit
+		 * to be set to '1'."
+		 */
+		count = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
+		count &= DWC3_GEVNTCOUNT_MASK;
+		if (count > 0) {
+			dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), count);
+			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
+						dwc->ev_buf->length;
+		}
+	}
+
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -3038,6 +3095,13 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 	}
 
 	dwc3_reset_gadget(dwc);
+	/*
+	 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
+	 * Section 4.1.2 Table 4-2, it states that during a USB reset, the SW
+	 * needs to ensure that it sends "a DEPENDXFER command for any active
+	 * transfers."
+	 */
+	dwc3_stop_active_transfers(dwc);
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg &= ~DWC3_DCTL_TSTCTRL_MASK;
-- 
2.30.2

