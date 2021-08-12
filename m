Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650283EA94A
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhHLRR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhHLRR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:27 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54D9C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:01 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id x27so14769658lfu.5
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IbNOLHfCLiIPyAUw3tbdS+8Xfnl4agrw5winPTLu2cs=;
        b=TOYfxVH1CWHfVY4ong0sHEBwcxiHyickPUv9tutBwc3EnXOhxb/MdE0lTFVU82HMSX
         h+ueBFLK7/xDmFccTt+jZ10MydouQAdgsVX3YYbbTCnhYEr5K+joEaXLtiH84n//28UY
         SGMaVRUkhuk7dM7F+FuS7QbJj1VHwuSjG55FCNub8MKZcjGSQtBDWe91awep9PsBJ7fH
         megoXp/mfuo/s+pt2WGewia49AwmdGESGc//6QDcS0szQ3QYbiCNi3P57oA0AcYdPj4o
         Mvj2BoGizhbUmh849p475Xa5R5WWSNYDp0LUiuYnHJBqa1nlTf1zSt9FpPz53cq5NTRY
         bAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IbNOLHfCLiIPyAUw3tbdS+8Xfnl4agrw5winPTLu2cs=;
        b=NmJKPZXv1Jw7YE6wEWvJvvGjgtYgUZoMdCRh/6ohd1uiudsm9BHVBOEbpITUklBdjq
         geaxBKg4iqgg+O5Hj0baTFSsn7OKeCg3pZ11tSv5plrQML8jFa14JVFMK7wacQB4XNeE
         /jtoYc6ObeZ+wZYqnguGoy55hlF0rLsVID179sTImOsKL+EbBgrGH3y0fz0xtq+yg6Sz
         AeDSlEvhPZxsILezhC2j2TAO53H/AumFabykgm2EQ/+vsz+reEFgmxrfKShk+xoJH3qO
         1uXP1ZmjLuz+YVJeHkPWHHlhvGWFE5iZxGTkVGGaRAqm5jdnH5hVJpsYcHCT14iZhRSq
         cvgg==
X-Gm-Message-State: AOAM533hvyxp6xjrUeuqz56XfXssutptyIqSoEHocRib4PzlxnScciKU
        FT0lUfvaPFzJgG7lFuFA76S80w==
X-Google-Smtp-Source: ABdhPJytDF/dTfnYLNWsG2gyii3vyh4UfyGE8i6utKLgiR9PNJjAMeJXfJ5AYOFD3dG+QkGdFC/2ww==
X-Received: by 2002:ac2:490b:: with SMTP id n11mr3269420lfi.656.1628788620151;
        Thu, 12 Aug 2021 10:17:00 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id i22sm317969lfv.125.2021.08.12.10.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:16:59 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 4/7] usb: dwc3: gadget: Prevent EP queuing while stopping transfers
Date:   Thu, 12 Aug 2021 20:16:49 +0300
Message-Id: <20210812171652.23803-5-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit f09ddcfcb8c569675066337adac2ac205113471f ]

In the situations where the DWC3 gadget stops active transfers, once
calling the dwc3_gadget_giveback(), there is a chance where a function
driver can queue a new USB request in between the time where the dwc3
lock has been released and re-aquired.  This occurs after we've already
issued an ENDXFER command.  When the stop active transfers continues
to remove USB requests from all dep lists, the newly added request will
also be removed, while controller still has an active TRB for it.
This can lead to the controller accessing an unmapped memory address.

Fix this by ensuring parameters to prevent EP queuing are set before
calling the stop active transfers API.

Fixes: ae7e86108b12 ("usb: dwc3: Stop active transfers before halting the controller")
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1615507142-23097-1-git-send-email-wcheng@codeaurora.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e242174321d1..8702035d08f1 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -746,8 +746,6 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	trace_dwc3_gadget_ep_disable(dep);
 
-	dwc3_remove_requests(dwc, dep);
-
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
 		__dwc3_gadget_ep_set_halt(dep, 0, false);
@@ -766,6 +764,8 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
+	dwc3_remove_requests(dwc, dep);
+
 	return 0;
 }
 
@@ -1511,7 +1511,7 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;
@@ -2043,6 +2043,7 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	if (!is_on) {
 		u32 count;
 
+		dwc->connected = false;
 		/*
 		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
 		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
@@ -2067,7 +2068,6 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
-		dwc->connected = false;
 	} else {
 		__dwc3_gadget_start(dwc);
 	}
@@ -3057,8 +3057,6 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 {
 	u32			reg;
 
-	dwc->connected = true;
-
 	/*
 	 * Ideally, dwc3_reset_gadget() would trigger the function
 	 * drivers to stop any active transfers through ep disable.
@@ -3107,6 +3105,7 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 	 * transfers."
 	 */
 	dwc3_stop_active_transfers(dwc);
+	dwc->connected = true;
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg &= ~DWC3_DCTL_TSTCTRL_MASK;
-- 
2.30.2

