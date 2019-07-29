Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2798678D0F
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 15:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfG2NnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 09:43:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:59656 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfG2NnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 09:43:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:43:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="370495874"
Received: from saranya-h97m-d3h.iind.intel.com ([10.66.254.8])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jul 2019 06:43:21 -0700
From:   Saranya Gopal <saranya.gopal@intel.com>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, fei.yang@intel.com,
        john.stultz@linaro.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Saranya Gopal <saranya.gopal@intel.com>
Subject: [PATCH 4.19.y 2/3] usb: dwc3: gadget: prevent dwc3_request from being queued twice
Date:   Mon, 29 Jul 2019 19:13:38 +0530
Message-Id: <1564407819-10746-3-git-send-email-saranya.gopal@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[Upstream commit b2b6d601365a1acb90b87c85197d79]

Queueing the same request twice can introduce hard-to-debug
problems. At least one function driver - Android's f_mtp.c - is known
to cause this problem.

While that function is out-of-tree, this is a problem that's easy
enough to avoid.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
---
 drivers/usb/dwc3/gadget.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3f337a0..a56a92a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1291,6 +1291,11 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 				&req->request, req->dep->name))
 		return -EINVAL;
 
+	if (WARN(req->status < DWC3_REQUEST_STATUS_COMPLETED,
+				"%s: request %pK already in flight\n",
+				dep->name, &req->request))
+		return -EINVAL;
+
 	pm_runtime_get(dwc->dev);
 
 	req->request.actual	= 0;
-- 
1.9.1

