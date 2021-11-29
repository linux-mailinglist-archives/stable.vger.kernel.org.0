Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23930461DC1
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377665AbhK2S3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350158AbhK2S1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3B96B815C8;
        Mon, 29 Nov 2021 18:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C532DC53FCD;
        Mon, 29 Nov 2021 18:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210212;
        bh=9R3kEGHWDARzWLhwgUeEhA0Wp5mSEgJfZq+bX/ucri0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8E1d73vnnNuhpo8bhmJzD+OoAaXDO2IDY9aGZ63sd0/MZN3tESYICOXNjw8Risdd
         Yue5xfkIGEsCaWxvyjzT8znVNf5gBJ5iWA1Y0qyyaAM44STw8n89DkzQ6RCN4V1hYM
         ccPdRWoPY79zsfrzHtFsPIA3pNOzBUn2VhdANymc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.4 03/92] usb: dwc2: gadget: Fix ISOC flow for elapsed frames
Date:   Mon, 29 Nov 2021 19:17:32 +0100
Message-Id: <20211129181707.514072453@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
@@ -2855,9 +2857,12 @@ static void dwc2_gadget_handle_ep_disabl
 
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
@@ -2910,8 +2915,11 @@ static void dwc2_gadget_handle_out_token
 
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
@@ -3000,8 +3008,11 @@ static void dwc2_gadget_handle_nak(struc
 
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


