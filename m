Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DD03EB8B5
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241441AbhHMPP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242545AbhHMPOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DBF2610E9;
        Fri, 13 Aug 2021 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867636;
        bh=Hco18UYs1We3Li1fLegRYLbfoz+9PbMNOk0+KFWzBEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caTTGkxqELFTzwuT1v35BM2wgZOAfmaKkgosKB82TXnKtJg8To0SI4zTWKoGbnHvX
         GpVCJrtx5GWUo905Gvl60tLlJ8ezJJ2KpQDajuC01i0RsXr4PM4YeTod/I+/b2+oPP
         17JP7MCWyNe7ICFXEgcdXaJwLH7GqsT1idzDdJz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Wesley Cheng" <wcheng@codeaurora.org>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 07/27] usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
Date:   Fri, 13 Aug 2021 17:07:05 +0200
Message-Id: <20210813150523.611480691@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit a1383b3537a7bea1c213baa7878ccc4ecf4413b5 ]

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
@@ -1993,6 +1993,7 @@ static int dwc3_gadget_run_stop(struct d
 
 static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
 static void __dwc3_gadget_stop(struct dwc3 *dwc);
+static int __dwc3_gadget_start(struct dwc3 *dwc);
 
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
@@ -2067,6 +2068,8 @@ static int dwc3_gadget_pullup(struct usb
 						dwc->ev_buf->length;
 		}
 		dwc->connected = false;
+	} else {
+		__dwc3_gadget_start(dwc);
 	}
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
@@ -2244,10 +2247,6 @@ static int dwc3_gadget_start(struct usb_
 	}
 
 	dwc->gadget_driver	= driver;
-
-	if (pm_runtime_active(dwc->dev))
-		__dwc3_gadget_start(dwc);
-
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
@@ -2273,13 +2272,6 @@ static int dwc3_gadget_stop(struct usb_g
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
 


