Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A314D5CB64
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfGBIIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbfGBIIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E10B206A2;
        Tue,  2 Jul 2019 08:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054888;
        bh=dBd5Gi/aU9o+YoIteL3TsGFh0gBXpK4pcIblhu743gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVgj0T0IXwcdw7XUjrjiwwB20P33kuwPEnH0Ib0VRyROoMukTYYUKy41xtWFNtejA
         7BUz/WbgkIkEi5ys2p8AVFcZfN2cwZ/G0dHQvkVcDI0nEp03r9Zbpt9PJ+/wKMnHUr
         eDhHkNp5aQ3hGTbgxHo0Wf1lJKiHoR9GOU/IjNeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/72] usb: dwc3: gadget: use num_trbs when skipping TRBs on ->dequeue()
Date:   Tue,  2 Jul 2019 10:01:27 +0200
Message-Id: <20190702080126.031346654@linuxfoundation.org>
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

commit c3acd59014148470dc58519870fbc779785b4bf7 upstream

Now that we track how many TRBs a request uses, it's easier to skip
over them in case of a call to usb_ep_dequeue(). Let's do so and
simplify the code a bit.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit c3acd59014148470dc58519870fbc779785b4bf7)
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index fd91c494307c..4e08904890ed 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1368,6 +1368,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 				break;
 		}
 		if (r == req) {
+			int i;
+
 			/* wait until it is processed */
 			dwc3_stop_active_transfer(dep, true);
 
@@ -1405,32 +1407,12 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 			if (!r->trb)
 				goto out0;
 
-			if (r->num_pending_sgs) {
+			for (i = 0; i < r->num_trbs; i++) {
 				struct dwc3_trb *trb;
-				int i = 0;
-
-				for (i = 0; i < r->num_pending_sgs; i++) {
-					trb = r->trb + i;
-					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
-					dwc3_ep_inc_deq(dep);
-				}
-
-				if (r->needs_extra_trb) {
-					trb = r->trb + r->num_pending_sgs + 1;
-					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
-					dwc3_ep_inc_deq(dep);
-				}
-			} else {
-				struct dwc3_trb *trb = r->trb;
 
+				trb = r->trb + i;
 				trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 				dwc3_ep_inc_deq(dep);
-
-				if (r->needs_extra_trb) {
-					trb = r->trb + 1;
-					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
-					dwc3_ep_inc_deq(dep);
-				}
 			}
 			goto out1;
 		}
@@ -1441,8 +1423,6 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 	}
 
 out1:
-	/* giveback the request */
-
 	dwc3_gadget_giveback(dep, req, -ECONNRESET);
 
 out0:
-- 
2.20.1



