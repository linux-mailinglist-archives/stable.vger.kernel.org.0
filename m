Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EDF461EC9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352276AbhK2SkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:40:08 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54316 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379923AbhK2SiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:38:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A345ECE13DD;
        Mon, 29 Nov 2021 18:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521AEC53FCF;
        Mon, 29 Nov 2021 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210875;
        bh=r+cdGAWafnI5B8xTzdtLe6uKIJkRhxm/YQwEFcrefQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0xB/88nlmPY9K8TSCkbkF/LokpgxTY9g/djC8y04oHN+5tmc1KNUMOhuqGJzdAH2
         SsxaqTJAwarTfpZAd3z4TfYgES8Pt0CoL5wLyBGL7fB/P+Vzy6QfDxRfmnGHLc03+N
         3CjkjcegnP/GUR1mrldvd73LP8+m/1FKF6JE/fBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.15 007/179] usb: dwc2: gadget: Fix ISOC flow for elapsed frames
Date:   Mon, 29 Nov 2021 19:16:41 +0100
Message-Id: <20211129181719.181391686@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 7ad4a0b1d46b2612f4429a72afd8f137d7efa9a9 upstream.

Added updating of request frame number for elapsed frames,
otherwise frame number will remain as previous use of request.
This will allow function driver to correctly track frames in
case of Missed ISOC occurs.

Added setting request actual length to 0 for elapsed frames.
In Slave mode when pushing data to RxFIFO by dwords, request
actual length incrementing accordingly. But before whole packet
will be pushed into RxFIFO and send to host can occurs Missed
ISOC and data will not send to host. So, in this case request
actual length should be reset to 0.

Fixes: 91bb163e1e4f ("usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/c356baade6e9716d312d43df08d53ae557cb8037.1636011277.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1198,6 +1198,8 @@ static void dwc2_hsotg_start_req(struct
 			}
 			ctrl |= DXEPCTL_CNAK;
 		} else {
+			hs_req->req.frame_number = hs_ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
 			return;
 		}
@@ -2857,9 +2859,12 @@ static void dwc2_gadget_handle_ep_disabl
 
 	do {
 		hs_req = get_ep_head(hs_ep);
-		if (hs_req)
+		if (hs_req) {
+			hs_req->req.frame_number = hs_ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req,
 						    -ENODATA);
+		}
 		dwc2_gadget_incr_frame_num(hs_ep);
 		/* Update current frame number value. */
 		hsotg->frame_number = dwc2_hsotg_read_frameno(hsotg);
@@ -2912,8 +2917,11 @@ static void dwc2_gadget_handle_out_token
 
 	while (dwc2_gadget_target_frame_elapsed(ep)) {
 		hs_req = get_ep_head(ep);
-		if (hs_req)
+		if (hs_req) {
+			hs_req->req.frame_number = ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, ep, hs_req, -ENODATA);
+		}
 
 		dwc2_gadget_incr_frame_num(ep);
 		/* Update current frame number value. */
@@ -3002,8 +3010,11 @@ static void dwc2_gadget_handle_nak(struc
 
 	while (dwc2_gadget_target_frame_elapsed(hs_ep)) {
 		hs_req = get_ep_head(hs_ep);
-		if (hs_req)
+		if (hs_req) {
+			hs_req->req.frame_number = hs_ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
+		}
 
 		dwc2_gadget_incr_frame_num(hs_ep);
 		/* Update current frame number value. */


