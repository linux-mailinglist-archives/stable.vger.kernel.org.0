Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5352A521D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgKCUq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730006AbgKCUqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78DCC20719;
        Tue,  3 Nov 2020 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436414;
        bh=ETAY37V9+jSoGTqnl9UcgPunUWhPQ0cJvaAKy8DAllg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyK3qJJN31RpE2WvSoVmNisRPqflDXFiqaGFiFJd76Y1ZbvdELaNN4tjBDTpryBwZ
         vQU1i12U/xWvt9Rf/0bNyeZ4rbp4TMkNB+bg+edRibbDhytBJ/7fGCLKJgZzdXpl8b
         QRJvaHhBePpVpdc8uGdUgHRuKzNKXE24OXxKssFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.9 240/391] usb: dwc3: ep0: Fix ZLP for OUT ep0 requests
Date:   Tue,  3 Nov 2020 21:34:51 +0100
Message-Id: <20201103203403.200683135@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 66706077dc89c66a4777a4c6298273816afb848c upstream.

The current ZLP handling for ep0 requests is only for control IN
requests. For OUT direction, DWC3 needs to check and setup for MPS
alignment.

Usually, control OUT requests can indicate its transfer size via the
wLength field of the control message. So usb_request->zero is usually
not needed for OUT direction. To handle ZLP OUT for control endpoint,
make sure the TRB is MPS size.

Cc: stable@vger.kernel.org
Fixes: c7fcdeb2627c ("usb: dwc3: ep0: simplify EP0 state machine")
Fixes: d6e5a549cc4d ("usb: dwc3: simplify ZLP handling")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/ep0.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -942,12 +942,16 @@ static void dwc3_ep0_xfer_complete(struc
 static void __dwc3_ep0_do_control_data(struct dwc3 *dwc,
 		struct dwc3_ep *dep, struct dwc3_request *req)
 {
+	unsigned int		trb_length = 0;
 	int			ret;
 
 	req->direction = !!dep->number;
 
 	if (req->request.length == 0) {
-		dwc3_ep0_prepare_one_trb(dep, dwc->ep0_trb_addr, 0,
+		if (!req->direction)
+			trb_length = dep->endpoint.maxpacket;
+
+		dwc3_ep0_prepare_one_trb(dep, dwc->bounce_addr, trb_length,
 				DWC3_TRBCTL_CONTROL_DATA, false);
 		ret = dwc3_ep0_start_trans(dep);
 	} else if (!IS_ALIGNED(req->request.length, dep->endpoint.maxpacket)
@@ -994,9 +998,12 @@ static void __dwc3_ep0_do_control_data(s
 
 		req->trb = &dwc->ep0_trb[dep->trb_enqueue - 1];
 
+		if (!req->direction)
+			trb_length = dep->endpoint.maxpacket;
+
 		/* Now prepare one extra TRB to align transfer size */
 		dwc3_ep0_prepare_one_trb(dep, dwc->bounce_addr,
-					 0, DWC3_TRBCTL_CONTROL_DATA,
+					 trb_length, DWC3_TRBCTL_CONTROL_DATA,
 					 false);
 		ret = dwc3_ep0_start_trans(dep);
 	} else {


