Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D830723D4D0
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHFApH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:45:07 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:35910 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726202AbgHFApC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:45:02 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 43455407DB;
        Thu,  6 Aug 2020 00:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596674699; bh=VBicLDNcVNScwDulAYkGurvFt/oGO+i+hKWzC1zN3Oc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=bneXe6NcTWMyLBox+QXnClK8+2efaw5oq8XxcMPi4mLvdXK4djNb53tcr6DOrFLdU
         dTWvfvYkMkEUMpMw2+sx44qM+Lz78rXuNl0hwaTLZwqOzseIxMb161koqPRwjssTBi
         JFoXekAbZgllHeeNkuPERmrjsqSUQ/JNIl9Wa2sj1lD5stISqilheiN2WiO+0CNW0V
         y214ACJwSi3PpIAFDg9Ee1iD+fJ9kGtjqUASFZDHl5LVd2N9pUJ8oeWKbroZkbMCDu
         kI5GqMAi9qFHmwjMC04MIglq7mCIMP9vZTprxoqM+8mEWUnMtR6fCaWvYiZzjg2zsf
         TYQDQ4R3C2vWg==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id BBF46A0096;
        Thu,  6 Aug 2020 00:44:57 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 05 Aug 2020 17:44:57 -0700
Date:   Wed, 05 Aug 2020 17:44:57 -0700
Message-Id: <112874138b6af4a92c6bb4748368a576dd126d1e.1596674377.git.thinhn@synopsys.com>
In-Reply-To: <cover.1596674377.git.thinhn@synopsys.com>
References: <cover.1596674377.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 2/7] usb: dwc3: gadget: Fix handling ZLP
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The usb_request->zero doesn't apply for isoc. Also, if we prepare a
0-length (ZLP) TRB for the OUT direction, we need to prepare an extra
TRB to pad up to the MPS alignment. Use the same bounce buffer for the
ZLP TRB and the extra pad TRB.

Cc: stable@vger.kernel.org
Fixes: d6e5a549cc4d ("usb: dwc3: simplify ZLP handling")
Fixes: 04c03d10e507 ("usb: dwc3: gadget: handle request->zero")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 657616077502..c0175dff194e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1193,6 +1193,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 				req->request.no_interrupt,
 				req->request.is_last);
 	} else if (req->request.zero && req->request.length &&
+		   !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
 		   (IS_ALIGNED(req->request.length, maxp))) {
 		struct dwc3	*dwc = dep->dwc;
 		struct dwc3_trb	*trb;
@@ -1202,14 +1203,25 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		/* prepare normal TRB */
 		dwc3_prepare_one_trb(dep, req, length, true, 0);
 
-		/* Now prepare one extra TRB to handle ZLP */
+		/* Prepare one extra TRB to handle ZLP */
 		trb = &dep->trb_pool[dep->trb_enqueue];
 		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
-				false, 1, req->request.stream_id,
+				!req->direction, 1, req->request.stream_id,
 				req->request.short_not_ok,
 				req->request.no_interrupt,
 				req->request.is_last);
+
+		/* Prepare one more TRB to handle MPS alignment for OUT */
+		if (!req->direction) {
+			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
+			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp,
+					       false, 1, req->request.stream_id,
+					       req->request.short_not_ok,
+					       req->request.no_interrupt,
+					       req->request.is_last);
+		}
 	} else {
 		dwc3_prepare_one_trb(dep, req, length, false, 0);
 	}
@@ -2684,8 +2696,17 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 				status);
 
 	if (req->needs_extra_trb) {
+		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
+
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
+
+		/* Reclaim MPS padding TRB for ZLP */
+		if (!req->direction && req->request.zero && req->request.length &&
+		    !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+		    (IS_ALIGNED(req->request.length, maxp)))
+			ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event, status);
+
 		req->needs_extra_trb = false;
 	}
 
-- 
2.28.0

