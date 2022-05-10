Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8F252177C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244014AbiEJN1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbiEJNZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7458E5EBF6;
        Tue, 10 May 2022 06:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F6EBB81CE7;
        Tue, 10 May 2022 13:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BF8C385C2;
        Tue, 10 May 2022 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188701;
        bh=5DaDxR42mwGSr1uVDRE0OYynjZnYKWwQ0Cz0LyU4kj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajEPrs5R6QczeNACTMc+XWS+AyXsU1gWmlDZJ+v9Jplwk9f20IpUN4XZkgKWpn+Sw
         LbDU+8K/Apt8GXm4hxvOiNLu//iNYXZeOHHnjo6iMmavF791pQlWsu6XJuhEo8W7fQ
         Z/26byzUYdDD3HgCDKXf8TYGvhpVFIoShQLvUOJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 16/88] usb: dwc3: gadget: Return proper request status
Date:   Tue, 10 May 2022 15:07:01 +0200
Message-Id: <20220510130734.217598344@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit c7428dbddcf4ea1919e1c8e15f715b94ca359268 upstream.

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
 drivers/usb/dwc3/gadget.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2415,6 +2415,7 @@ static int dwc3_gadget_ep_cleanup_comple
 		const struct dwc3_event_depevt *event,
 		struct dwc3_request *req, int status)
 {
+	int request_status;
 	int ret;
 
 	if (req->request.num_mapped_sgs)
@@ -2444,7 +2445,35 @@ static int dwc3_gadget_ep_cleanup_comple
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


