Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318712EB142
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 18:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbhAERVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 12:21:32 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35654 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729419AbhAERVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 12:21:32 -0500
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A6EBFC00CB;
        Tue,  5 Jan 2021 17:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609867231; bh=/RmGyqHcINcHHORLwuv780eZQjviuTTupSgTvUGu42I=;
        h=Date:From:Subject:To:Cc:From;
        b=EofC0aypZkC/oMoXIzIsW6Rn4tVxNxKHxUkOvR4y9G6cBLsZhrX9n+Tnk4i6WPmZ/
         1rr/tdjInOUQif4pMK5M9TRYKTsQaglwAce2nXibTHMK2kodczgwYYkRwS6x6uq7+2
         tVLk3X53qcF8e8kKFLGPNZgyWKfBbIUxup2BBC1SlXtnI982QxPucmNjqCrblM8WXV
         GC029ejioBEuVcPuwvYm9XCBxFXKiWrcn00l2j9uORNbqnubv+cEzXc+6trsJ5NydM
         JuQlX4H3u3kqSOQgyEeGT6uAy8qs4eJtr2vZ71wnX5xNd561NgVl/0EeyASWoslW9D
         TPR44vPU4lJlQ==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id EE116A0096;
        Tue,  5 Jan 2021 17:20:28 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Tue, 05 Jan 2021 09:20:28 -0800
Date:   Tue, 05 Jan 2021 09:20:28 -0800
Message-Id: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Init only available HW eps
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Typically FPGA devices are configured with CoreConsultant parameter
DWC_USB3x_EN_LOG_PHYS_EP_SUPT=0 to reduce gate count and improve timing.
This means that the number of INs equals to OUTs endpoints. But
typically non-FPGA devices enable this CoreConsultant parameter to
support flexible endpoint mapping and potentially may have unequal
number of INs to OUTs physical endpoints.

The driver must check how many physical endpoints are available for each
direction and initialize them properly.

Cc: stable@vger.kernel.org
Fixes: 47d3946ea220 ("usb: dwc3: refactor gadget endpoint count calculation")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/core.c   |  1 +
 drivers/usb/dwc3/core.h   |  2 ++
 drivers/usb/dwc3/gadget.c | 19 ++++++++++++-------
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 841daec70b6e..1084aa8623c2 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -529,6 +529,7 @@ static void dwc3_core_num_eps(struct dwc3 *dwc)
 	struct dwc3_hwparams	*parms = &dwc->hwparams;
 
 	dwc->num_eps = DWC3_NUM_EPS(parms);
+	dwc->num_in_eps = DWC3_NUM_IN_EPS(parms);
 }
 
 static void dwc3_cache_hwparams(struct dwc3 *dwc)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 1b241f937d8f..1295dac019f9 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -990,6 +990,7 @@ struct dwc3_scratchpad_array {
  * @u1sel: parameter from Set SEL request.
  * @u1pel: parameter from Set SEL request.
  * @num_eps: number of endpoints
+ * @num_in_eps: number of IN endpoints
  * @ep0_next_event: hold the next expected event
  * @ep0state: state of endpoint zero
  * @link_state: link state
@@ -1193,6 +1194,7 @@ struct dwc3 {
 	u8			speed;
 
 	u8			num_eps;
+	u8			num_in_eps;
 
 	struct dwc3_hwparams	hwparams;
 	struct dentry		*root;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 25f654b79e48..8a38ee10c00b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2025,7 +2025,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
 {
 	u32 epnum;
 
-	for (epnum = 2; epnum < dwc->num_eps; epnum++) {
+	for (epnum = 2; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
 		struct dwc3_ep *dep;
 
 		dep = dwc->eps[epnum];
@@ -2628,16 +2628,21 @@ static int dwc3_gadget_init_endpoint(struct dwc3 *dwc, u8 epnum)
 	return 0;
 }
 
-static int dwc3_gadget_init_endpoints(struct dwc3 *dwc, u8 total)
+static int dwc3_gadget_init_endpoints(struct dwc3 *dwc)
 {
-	u8				epnum;
+	u8				i;
+	int				ret;
 
 	INIT_LIST_HEAD(&dwc->gadget->ep_list);
 
-	for (epnum = 0; epnum < total; epnum++) {
-		int			ret;
+	for (i = 0; i < dwc->num_in_eps; i++) {
+		ret = dwc3_gadget_init_endpoint(dwc, i * 2 + 1);
+		if (ret)
+			return ret;
+	}
 
-		ret = dwc3_gadget_init_endpoint(dwc, epnum);
+	for (i = 0; i < dwc->num_eps - dwc->num_in_eps; i++) {
+		ret = dwc3_gadget_init_endpoint(dwc, i * 2);
 		if (ret)
 			return ret;
 	}
@@ -3863,7 +3868,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	 * sure we're starting from a well known location.
 	 */
 
-	ret = dwc3_gadget_init_endpoints(dwc, dwc->num_eps);
+	ret = dwc3_gadget_init_endpoints(dwc);
 	if (ret)
 		goto err4;
 

base-commit: 96ebc9c871d8a28fb22aa758dd9188a4732df482
-- 
2.28.0

