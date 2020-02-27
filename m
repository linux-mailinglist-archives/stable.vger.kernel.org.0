Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B27171DE8
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388882AbgB0OMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388868AbgB0OMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D90E20578;
        Thu, 27 Feb 2020 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812759;
        bh=ecMOeFQMbz8SkIbgVEjWiLYsH1nkU3TSO9zEKVRK7qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZo71bR7XuUEvEvHsyXeN0j8ajPBV4kRQAmowGyepX9wGRyKE3QNiQcQUztBBY6k2
         A8Qt+x9ce4HZyVht63Ret8cCtFkvGjrh/CnfIR6UNVX1ad11ITSf1mM+INpqMfIUsZ
         4F3UPo2BTiwJ433KblLucnbEwDN5t6val8yZ7EoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 110/135] usb: dwc2: Fix in ISOC request length checking
Date:   Thu, 27 Feb 2020 14:37:30 +0100
Message-Id: <20200227132245.741859163@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 860ef6cd3f90b84a1832f8a6485c90c34d3b588b upstream.

Moved ISOC request length checking from dwc2_hsotg_start_req() function to
dwc2_hsotg_ep_queue().

Fixes: 4fca54aa58293 ("usb: gadget: s3c-hsotg: add multi count support")
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/gadget.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1083,11 +1083,6 @@ static void dwc2_hsotg_start_req(struct
 	else
 		packets = 1;	/* send one packet if length is zero. */
 
-	if (hs_ep->isochronous && length > (hs_ep->mc * hs_ep->ep.maxpacket)) {
-		dev_err(hsotg->dev, "req length > maxpacket*mc\n");
-		return;
-	}
-
 	if (dir_in && index != 0)
 		if (hs_ep->isochronous)
 			epsize = DXEPTSIZ_MC(packets);
@@ -1391,6 +1386,13 @@ static int dwc2_hsotg_ep_queue(struct us
 	req->actual = 0;
 	req->status = -EINPROGRESS;
 
+	/* Don't queue ISOC request if length greater than mps*mc */
+	if (hs_ep->isochronous &&
+	    req->length > (hs_ep->mc * hs_ep->ep.maxpacket)) {
+		dev_err(hs->dev, "req length > maxpacket*mc\n");
+		return -EINVAL;
+	}
+
 	/* In DDMA mode for ISOC's don't queue request if length greater
 	 * than descriptor limits.
 	 */


