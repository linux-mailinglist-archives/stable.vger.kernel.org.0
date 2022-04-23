Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E584750C5C3
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 02:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiDWAj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 20:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiDWAj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 20:39:27 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3452A1183B9;
        Fri, 22 Apr 2022 17:36:31 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7E3C540D64;
        Sat, 23 Apr 2022 00:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1650674191; bh=DnHvG1JYIBFvxuDziZvdv9NZ+DsGNRuiIeCpxELUYMU=;
        h=Date:From:Subject:To:Cc:From;
        b=NdhRWpOtkCwdkm/6hJBytJvIrWMhI+kApCtmp8HQBzOsRY7ryIWkZWIppX6Y7eEdx
         IFsHCQ4Mlqa+XevEV9TEH5AJSrNkJNWJCkkTTl4dCtA2kvjtAjhOCYm9C9lsc+WoZC
         R4TWWl2LRWU9Xa5ceUHGME62QfCFsO1vuccFekGvfNe7/FjBs/fi5PznMl8P4Y1D3u
         4mUEd610fNn8GdWktBG1sa0J51AjmQc/YMO6hBYTiStnef+cORIK6bmwmb3ARUDkuy
         vX6Ex2u2fnmM9w3knhNbQjbdW4FJpVmii6K3lkglDL5cZqyVmClOVFuVazJM/szEP7
         ikFDKf79HRYXQ==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 6DA9FA0070;
        Sat, 23 Apr 2022 00:36:28 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Fri, 22 Apr 2022 17:36:28 -0700
Date:   Fri, 22 Apr 2022 17:36:28 -0700
Message-Id: <db2c80108286cfd108adb05bad52138b78d7c3a7.1650673655.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Return proper request status
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        <stable@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the user sets the usb_request's no_interrupt, then there will be no
completion event for the request. Currently the driver incorrectly uses
the event status of a different request to report the status for a
request with no_interrupt. The dwc3 driver needs to check the TRB status
associated with the request when reporting its status.

Note: this is only applicable to missed_isoc TRB completion status, but
the other status are also listed for completeness/documentation.

Fixes: 6d8a019614f3 ("usb: dwc3: gadget: check for Missed Isoc from event status")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index ab725d2262d6..0b9c2493844a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3274,6 +3274,7 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		const struct dwc3_event_depevt *event,
 		struct dwc3_request *req, int status)
 {
+	int request_status;
 	int ret;
 
 	if (req->request.num_mapped_sgs)
@@ -3294,7 +3295,35 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		req->needs_extra_trb = false;
 	}
 
-	dwc3_gadget_giveback(dep, req, status);
+	/*
+	 * The event status only reflects the status of the TRB with IOC set.
+	 * For the requests that don't set interrupt on completion, the driver
+	 * needs to check and return the status of the completed TRBs associated
+	 * with the request. Use the status of the last TRB of the request.
+	 */
+	if (req->request.no_interrupt) {
+		struct dwc3_trb *trb;
+
+		trb = dwc3_ep_prev_trb(dep, dep->trb_dequeue);
+		switch (DWC3_TRB_SIZE_TRBSTS(trb->size)) {
+		case DWC3_TRBSTS_MISSED_ISOC:
+			/* Isoc endpoint only */
+			request_status = -EXDEV;
+			break;
+		case DWC3_TRB_STS_XFER_IN_PROG:
+			/* Applicable when End Transfer with ForceRM=0 */
+		case DWC3_TRBSTS_SETUP_PENDING:
+			/* Control endpoint only */
+		case DWC3_TRBSTS_OK:
+		default:
+			request_status = 0;
+			break;
+		}
+	} else {
+		request_status = status;
+	}
+
+	dwc3_gadget_giveback(dep, req, request_status);
 
 out:
 	return ret;

base-commit: f4fd84ae0765a80494b28c43b756a95100351a94
-- 
2.28.0

