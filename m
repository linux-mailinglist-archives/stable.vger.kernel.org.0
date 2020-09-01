Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AC425950B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgIAPqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbgIAPqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4D08206FA;
        Tue,  1 Sep 2020 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975162;
        bh=ETWogNxOHsaLuoYxc2Eg3dSmqUpvqHKbxRNDaG0gEL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyIDD4aqQP4fjL1FbvyLnTbiYd0spleHYklWVeLRI3fIoH3m6rJ493R1w93BoIrKW
         Nb6mujLWbzrWy9KcpqHUo5nJd+oVzf/OkpLVF+YXYGWYs+9e1zOi1dQfRErgiCu63B
         +i72+3+NiN3YYL2DhM4UIiRm9FSVTmLiKekZVGJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.8 233/255] usb: dwc3: gadget: Handle ZLP for sg requests
Date:   Tue,  1 Sep 2020 17:11:29 +0200
Message-Id: <20200901151011.915888562@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit bc9a2e226ea95e1699f7590845554de095308b75 upstream.

Currently dwc3 doesn't handle usb_request->zero for SG requests. This
change checks and prepares extra TRBs for the ZLP for SG requests.

Cc: <stable@vger.kernel.org> # v4.5+
Fixes: 04c03d10e507 ("usb: dwc3: gadget: handle request->zero")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1143,6 +1143,37 @@ static void dwc3_prepare_one_trb_sg(stru
 					req->request.short_not_ok,
 					req->request.no_interrupt,
 					req->request.is_last);
+		} else if (req->request.zero && req->request.length &&
+			   !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+			   !rem && !chain) {
+			struct dwc3	*dwc = dep->dwc;
+			struct dwc3_trb	*trb;
+
+			req->needs_extra_trb = true;
+
+			/* Prepare normal TRB */
+			dwc3_prepare_one_trb(dep, req, trb_length, true, i);
+
+			/* Prepare one extra TRB to handle ZLP */
+			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
+			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
+					       !req->direction, 1,
+					       req->request.stream_id,
+					       req->request.short_not_ok,
+					       req->request.no_interrupt,
+					       req->request.is_last);
+
+			/* Prepare one more TRB to handle MPS alignment */
+			if (!req->direction) {
+				trb = &dep->trb_pool[dep->trb_enqueue];
+				req->num_trbs++;
+				__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp,
+						       false, 1, req->request.stream_id,
+						       req->request.short_not_ok,
+						       req->request.no_interrupt,
+						       req->request.is_last);
+			}
 		} else {
 			dwc3_prepare_one_trb(dep, req, trb_length, chain, i);
 		}


