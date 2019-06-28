Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582485A370
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfF1SYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33171 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfF1SYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so3407824pfq.0
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=88fRjj74GZN01nX0sSKgncvdEa4gXr3r1F+OW3u4lS8=;
        b=DFywPhvkx8VftWLHnF+hjOhCP6z+9tHooSDVr5iWKkQbFcu5W0rypK+ZNa1k4CrKbB
         rgSLyJw90E0YW8ciwrDmdc6ngSaPML6MUHTa5+OAFRfKkOPKdlOYDyBfEwmV6otqdQ2k
         e4vBJlYrxYGGN3ip5ijM4/EzHyxDTV381B1Im51Bp2AzgD8zltbEBG4CmolNXogB+s1D
         Xma67Uu4qPudHxECpKjjiERRBudywazCn+n6NwdKH/6nDJw/+IhYguEkJRcAiH7ROKvH
         4BJQUbgP/bazB9mr5ekU4tc0Fo7EdK1W6PiervT5dKCKSTLcjOgUS1gbPDxUeBu8F3pi
         Zbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=88fRjj74GZN01nX0sSKgncvdEa4gXr3r1F+OW3u4lS8=;
        b=pqdARIQ5cKxE/u6kBLILsKGMCIxmWmmkvJIeUuHCf5Z3p5qIooqPTDXgi3KEZmdioJ
         x3ScttcqXXgeeuEOnHKxxwB4o6XR6CnC92/O0B2jZYiATESemunaBbVsAq7UiAc4UPzN
         aIIsARs602js8OXiWNo1rlhTOc99fOskhpR4ceo7DBtR5d6FRLmZHdy9BStYlzf+GjtC
         hibQjIM1ZJYfSXpRSzkId5yyBrhkdVxNUAhD28dYAhjxYH2viPjITMYLDuydgt5Xh/S2
         wJUN+4+0ykwItyEgqfTJArWk2hVnCdSTYbn6McMwi9ISl1kac8jQHwzz9rkRDJoBcuFV
         jaDg==
X-Gm-Message-State: APjAAAXIzuWSmZeXeTX1pI7C3O50CfdYmg/k8aGPV/nEyR1YDaVpkYoj
        sMfL/4iuLnIV/Z/ppVhQ+V+rS6LCA9E=
X-Google-Smtp-Source: APXvYqzSf+2FES9KMIflO6lAuK1yNAY9PsuuqnAtpqrmG1IdzcjRxQg9SWRS+em/RPAfgRad+TT+CA==
X-Received: by 2002:a63:f817:: with SMTP id n23mr10705991pgh.35.1561746260608;
        Fri, 28 Jun 2019 11:24:20 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:19 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y v2 2/9] usb: dwc3: gadget: combine unaligned and zero flags
Date:   Fri, 28 Jun 2019 18:24:06 +0000
Message-Id: <20190628182413.33225-3-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
References: <20190628182413.33225-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit 1a22ec643580626f439c8583edafdcc73798f2fb upstream

Both flags are used for the same purpose in dwc3: appending an extra
TRB at the end to deal with controller requirements. By combining both
flags into one, we make it clear that the situation is the same and
that they should be treated equally.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit 1a22ec643580626f439c8583edafdcc73798f2fb)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/core.h   |  7 +++----
 drivers/usb/dwc3/gadget.c | 18 +++++++++---------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 5bfb62533e0f..4872cba8699b 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -847,11 +847,11 @@ struct dwc3_hwparams {
  * @epnum: endpoint number to which this request refers
  * @trb: pointer to struct dwc3_trb
  * @trb_dma: DMA address of @trb
- * @unaligned: true for OUT endpoints with length not divisible by maxp
+ * @needs_extra_trb: true when request needs one extra TRB (either due to ZLP
+ *	or unaligned OUT)
  * @direction: IN or OUT direction flag
  * @mapped: true when request has been dma-mapped
  * @started: request is started
- * @zero: wants a ZLP
  */
 struct dwc3_request {
 	struct usb_request	request;
@@ -867,11 +867,10 @@ struct dwc3_request {
 	struct dwc3_trb		*trb;
 	dma_addr_t		trb_dma;
 
-	unsigned		unaligned:1;
+	unsigned		needs_extra_trb:1;
 	unsigned		direction:1;
 	unsigned		mapped:1;
 	unsigned		started:1;
-	unsigned		zero:1;
 };
 
 /*
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index eaa78e6c972c..8db7466e4f76 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1068,7 +1068,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 			struct dwc3	*dwc = dep->dwc;
 			struct dwc3_trb	*trb;
 
-			req->unaligned = true;
+			req->needs_extra_trb = true;
 
 			/* prepare normal TRB */
 			dwc3_prepare_one_trb(dep, req, true, i);
@@ -1112,7 +1112,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		struct dwc3	*dwc = dep->dwc;
 		struct dwc3_trb	*trb;
 
-		req->unaligned = true;
+		req->needs_extra_trb = true;
 
 		/* prepare normal TRB */
 		dwc3_prepare_one_trb(dep, req, true, 0);
@@ -1128,7 +1128,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		struct dwc3	*dwc = dep->dwc;
 		struct dwc3_trb	*trb;
 
-		req->zero = true;
+		req->needs_extra_trb = true;
 
 		/* prepare normal TRB */
 		dwc3_prepare_one_trb(dep, req, true, 0);
@@ -1410,7 +1410,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 					dwc3_ep_inc_deq(dep);
 				}
 
-				if (r->unaligned || r->zero) {
+				if (r->needs_extra_trb) {
 					trb = r->trb + r->num_pending_sgs + 1;
 					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 					dwc3_ep_inc_deq(dep);
@@ -1421,7 +1421,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 				trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 				dwc3_ep_inc_deq(dep);
 
-				if (r->unaligned || r->zero) {
+				if (r->needs_extra_trb) {
 					trb = r->trb + 1;
 					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 					dwc3_ep_inc_deq(dep);
@@ -2250,7 +2250,8 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	 * with one TRB pending in the ring. We need to manually clear HWO bit
 	 * from that TRB.
 	 */
-	if ((req->zero || req->unaligned) && !(trb->ctrl & DWC3_TRB_CTRL_CHN)) {
+
+	if (req->needs_extra_trb && !(trb->ctrl & DWC3_TRB_CTRL_CHN)) {
 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 		return 1;
 	}
@@ -2327,11 +2328,10 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
 
-	if (req->unaligned || req->zero) {
+	if (req->needs_extra_trb) {
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
-		req->unaligned = false;
-		req->zero = false;
+		req->needs_extra_trb = false;
 	}
 
 	req->request.actual = req->request.length - req->remaining;
-- 
2.17.1

