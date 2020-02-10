Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64585157ACF
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbgBJNZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbgBJMgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:53 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB2F320873;
        Mon, 10 Feb 2020 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338212;
        bh=96Km2JAKJQt5E4CSNG5FHIUcJJU0qlgelVWwZfkR42o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0X6YPykTal4iXGd3K49D1KB3pLFMYdejbn+HbUdCl7N29QBnQfcBF0xvYDK/frZD
         EVEnx1Ae7EjF54saZgDC6/QGIY4INzp0cTOIhqENiNPj6f/OzS9jkYcQ6agYQILAg5
         uXe3xsnvuVuFZGNAGiACXh9hM5d0W9Kjfc/KY9zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 038/309] usb: dwc3: gadget: Delay starting transfer
Date:   Mon, 10 Feb 2020 04:29:54 -0800
Message-Id: <20200210122409.747341371@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit da10bcdd6f70dc9977f2cf18f4783cf78520623a upstream.

If the END_TRANSFER command hasn't completed yet, then don't send the
START_TRANSFER command. The controller may not be able to start if
that's the case. Some controller revisions depend on this. See
commit 76a638f8ac0d ("usb: dwc3: gadget: wait for End Transfer to
complete"). Let's only send START_TRANSFER command after the
END_TRANSFER command had completed.

Fixes: 3aec99154db3 ("usb: dwc3: gadget: remove DWC3_EP_END_TRANSFER_PENDING")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.h   |    1 +
 drivers/usb/dwc3/gadget.c |   11 +++++++++++
 2 files changed, 12 insertions(+)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -690,6 +690,7 @@ struct dwc3_ep {
 #define DWC3_EP_TRANSFER_STARTED BIT(3)
 #define DWC3_EP_END_TRANSFER_PENDING BIT(4)
 #define DWC3_EP_PENDING_REQUEST	BIT(5)
+#define DWC3_EP_DELAY_START	BIT(6)
 
 	/* This last one is specific to EP0 */
 #define DWC3_EP0_DIR_IN		BIT(31)
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1447,6 +1447,12 @@ static int __dwc3_gadget_ep_queue(struct
 	list_add_tail(&req->list, &dep->pending_list);
 	req->status = DWC3_REQUEST_STATUS_QUEUED;
 
+	/* Start the transfer only after the END_TRANSFER is completed */
+	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING) {
+		dep->flags |= DWC3_EP_DELAY_START;
+		return 0;
+	}
+
 	/*
 	 * NOTICE: Isochronous endpoints should NEVER be prestarted. We must
 	 * wait for a XferNotReady event so we will know what's the current
@@ -2628,6 +2634,11 @@ static void dwc3_endpoint_interrupt(stru
 			dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 			dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
+			if ((dep->flags & DWC3_EP_DELAY_START) &&
+			    !usb_endpoint_xfer_isoc(dep->endpoint.desc))
+				__dwc3_gadget_kick_transfer(dep);
+
+			dep->flags &= ~DWC3_EP_DELAY_START;
 		}
 		break;
 	case DWC3_DEPEVT_STREAMEVT:


