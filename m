Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406AB78D11
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 15:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfG2Nn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 09:43:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:59656 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfG2Nn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 09:43:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:43:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="370495888"
Received: from saranya-h97m-d3h.iind.intel.com ([10.66.254.8])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jul 2019 06:43:25 -0700
From:   Saranya Gopal <saranya.gopal@intel.com>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, fei.yang@intel.com,
        john.stultz@linaro.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Saranya Gopal <saranya.gopal@intel.com>
Subject: [PATCH 4.19.y 3/3] usb: dwc3: gadget: remove req->started flag
Date:   Mon, 29 Jul 2019 19:13:39 +0530
Message-Id: <1564407819-10746-4-git-send-email-saranya.gopal@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[Upstream commit 7c3d7dc89e57a1d43acea935882dd8713c9e639f]

Now that we have req->status, we don't need this extra flag
anymore. It's safe to remove it.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
---
 drivers/usb/dwc3/core.h   | 2 --
 drivers/usb/dwc3/gadget.c | 1 -
 drivers/usb/dwc3/gadget.h | 2 --
 3 files changed, 5 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 301bf94..6ea3e48 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -852,7 +852,6 @@ struct dwc3_hwparams {
  *	or unaligned OUT)
  * @direction: IN or OUT direction flag
  * @mapped: true when request has been dma-mapped
- * @started: request is started
  */
 struct dwc3_request {
 	struct usb_request	request;
@@ -881,7 +880,6 @@ struct dwc3_request {
 	unsigned		needs_extra_trb:1;
 	unsigned		direction:1;
 	unsigned		mapped:1;
-	unsigned		started:1;
 };
 
 /*
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a56a92a..f29068d 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -174,7 +174,6 @@ static void dwc3_gadget_del_and_unmap_request(struct dwc3_ep *dep,
 {
 	struct dwc3			*dwc = dep->dwc;
 
-	req->started = false;
 	list_del(&req->list);
 	req->remaining = 0;
 	req->needs_extra_trb = false;
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index 6aebe8c..3ed738e 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -75,7 +75,6 @@ static inline void dwc3_gadget_move_started_request(struct dwc3_request *req)
 {
 	struct dwc3_ep		*dep = req->dep;
 
-	req->started = true;
 	req->status = DWC3_REQUEST_STATUS_STARTED;
 	list_move_tail(&req->list, &dep->started_list);
 }
@@ -91,7 +90,6 @@ static inline void dwc3_gadget_move_cancelled_request(struct dwc3_request *req)
 {
 	struct dwc3_ep		*dep = req->dep;
 
-	req->started = false;
 	req->status = DWC3_REQUEST_STATUS_CANCELLED;
 	list_move_tail(&req->list, &dep->cancelled_list);
 }
-- 
1.9.1

