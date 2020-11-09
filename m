Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABD82ABAA9
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbgKINVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388046AbgKINVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:21:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C8CA2065D;
        Mon,  9 Nov 2020 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928082;
        bh=rLhjXJeRAW8D0097gZ8jQCcXv8gLYuj/zeHcbNeT4lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N29mL0v/6PRLdTDVZYYvgCmMTFskaV8kYOryouZgCGxpSa0HfdzsFxc/RsX1xCFwV
         2lDuGEjAaStJvw/ExoHMJ0EAjZ5Qmi9AF7ZMxp8M50THirHdFaR3nqMeKUGLsPBW4e
         kB0G02Vg63vGtaMufVtY+xUfbBXRSxeNqSEEvnAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.9 121/133] usb: dwc3: ep0: Fix delay status handling
Date:   Mon,  9 Nov 2020 13:56:23 +0100
Message-Id: <20201109125036.509191184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit fa27e2f6c5e674f3f1225f9ca7a7821faaf393bb upstream.

If we want to send a control status on our own time (through
delayed_status), make sure to handle a case where we may queue the
delayed status before the host requesting for it (when XferNotReady
is generated). Otherwise, the driver won't send anything because it's
not EP0_STATUS_PHASE yet. To resolve this, regardless whether
dwc->ep0state is EP0_STATUS_PHASE, make sure to clear the
dwc->delayed_status flag if dwc3_ep0_send_delayed_status() is called.
The control status can be sent when the host requests it later.

Cc: <stable@vger.kernel.org>
Fixes: d97c78a1908e ("usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/ep0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -1058,10 +1058,11 @@ void dwc3_ep0_send_delayed_status(struct
 {
 	unsigned int direction = !dwc->ep0_expect_in;
 
+	dwc->delayed_status = false;
+
 	if (dwc->ep0state != EP0_STATUS_PHASE)
 		return;
 
-	dwc->delayed_status = false;
 	__dwc3_ep0_do_control_status(dwc, dwc->eps[direction]);
 }
 


