Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15677621CCD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiKHTPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKHTPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:15:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83A25E3CF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 11:15:02 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1osU3h-0008PQ-2T; Tue, 08 Nov 2022 20:14:53 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <mgr@pengutronix.de>)
        id 1osU3e-0037HI-BD; Tue, 08 Nov 2022 20:14:51 +0100
Received: from mgr by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <mgr@pengutronix.de>)
        id 1osU3e-00C63s-6H; Tue, 08 Nov 2022 20:14:50 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     Thinh.Nguyen@synopsys.com
Cc:     balbi@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, kernel@pengutronix.de,
        John.Youn@synopsys.com, stable@vger.kernel.org
Subject: [PATCH] usb: dwc3: gadget: fix status value on remove_request
Date:   Tue,  8 Nov 2022 20:14:45 +0100
Message-Id: <20221108191445.2883161-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <3421859485cb32d77e2068549679a6c07a7797bc.1667875427.git.Thinh.Nguyen@synopsys.com>
References: <3421859485cb32d77e2068549679a6c07a7797bc.1667875427.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the patch b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove
requests") the driver is now returning different request status values
in different conditions of disabled endpoint and stopped transfers.
The patch however has swapped the actual status results they should
have. We fix this now with this patch.

Fixes: b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---

I had this patch prepared already, but forgot about it. Sorry about the
delay. Thanks for catching up on this, Thinh!

mgr

 drivers/usb/dwc3/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index ecddb144871bec..cd5ace438d40ee 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1029,7 +1029,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
-	dwc3_remove_requests(dwc, dep, -ECONNRESET);
+	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
 	dep->type = 0;
@@ -2375,7 +2375,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
 		if (!dep)
 			continue;
 
-		dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
+		dwc3_remove_requests(dwc, dep, -ECONNRESET);
 	}
 }
 
-- 
2.30.2

