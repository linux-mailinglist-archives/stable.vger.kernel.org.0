Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7CE2F13EC
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbhAKNQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732499AbhAKNQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04F3D2255F;
        Mon, 11 Jan 2021 13:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370969;
        bh=lkq7ObhJRbo7/out0sskq5kFZuIs0ut907Nze18cRWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvXThu4asIuH1IQugiMcTm6BaEgOkcuCl+zk8bYDdgdAhMNgtuyKulRxQE4VUWRGA
         hBrsgENAxzduh1i3GJz98zpdzh+Gx+W6/A0kdRNsbeqTIfZLGmuX6NSFwg0bIYdyHe
         xo2PoPdBWP0N5xGDefhy1Hl4vZsSHxj9g0vc55nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.10 083/145] usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
Date:   Mon, 11 Jan 2021 14:01:47 +0100
Message-Id: <20210111130052.518265351@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit a1383b3537a7bea1c213baa7878ccc4ecf4413b5 upstream.

usb_gadget_deactivate/usb_gadget_activate does not execute the UDC start
operation, which may leave EP0 disabled and event IRQs disabled when
re-activating the function. Move the enabling/disabling of USB EP0 and
device event IRQs to be performed in the pullup routine.

Fixes: ae7e86108b12 ("usb: dwc3: Stop active transfers before halting the controller")
Tested-by: Michael Tretter <m.tretter@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Reported-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1609282837-21666-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2083,6 +2083,7 @@ static int dwc3_gadget_run_stop(struct d
 
 static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
 static void __dwc3_gadget_stop(struct dwc3 *dwc);
+static int __dwc3_gadget_start(struct dwc3 *dwc);
 
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
@@ -2145,6 +2146,8 @@ static int dwc3_gadget_pullup(struct usb
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
+	} else {
+		__dwc3_gadget_start(dwc);
 	}
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
@@ -2319,10 +2322,6 @@ static int dwc3_gadget_start(struct usb_
 	}
 
 	dwc->gadget_driver	= driver;
-
-	if (pm_runtime_active(dwc->dev))
-		__dwc3_gadget_start(dwc);
-
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
@@ -2348,13 +2347,6 @@ static int dwc3_gadget_stop(struct usb_g
 	unsigned long		flags;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-
-	if (pm_runtime_suspended(dwc->dev))
-		goto out;
-
-	__dwc3_gadget_stop(dwc);
-
-out:
 	dwc->gadget_driver	= NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 


