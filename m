Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E5450FC8E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 14:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346634AbiDZMN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 08:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349835AbiDZMNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 08:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C942A275F6
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 05:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF768618AF
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 12:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEF3C385A0;
        Tue, 26 Apr 2022 12:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650975040;
        bh=FLAkOotEJNkgesGOp4hj7tdqGMDbE7SuF3pH8Gl4Msg=;
        h=Subject:To:From:Date:From;
        b=yQvnMLFpGEzq8rdfU+w+wNHchuCdRJMrEKqCsYL547op4IxXEfks7ttRxvr8JRQyE
         YgVqmVCRyJfBfCRhMGIxSoqbNItS1+6XahJUN/i/P1904gfILO7t06gCzJNJ5vRw3F
         Xv1M0wK+c5q8S13QKqEZXDY3SNUibMMBKnpj900U=
Subject: patch "usb: dwc3: gadget: Return proper request status" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 14:10:36 +0200
Message-ID: <165097503653191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Return proper request status

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c7428dbddcf4ea1919e1c8e15f715b94ca359268 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Fri, 22 Apr 2022 17:36:28 -0700
Subject: usb: dwc3: gadget: Return proper request status

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
Link: https://lore.kernel.org/r/db2c80108286cfd108adb05bad52138b78d7c3a7.1650673655.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
-- 
2.36.0


