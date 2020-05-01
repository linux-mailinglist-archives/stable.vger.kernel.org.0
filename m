Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91D81C167B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgEANtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729765AbgEANlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FCF420757;
        Fri,  1 May 2020 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340491;
        bh=OjR8h7N5ftFb4/Z9Ego9JsTtJSIyUIZxeTJX+rOmBi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJXGwytIibJP1sznECwp6wWbklwXdaa8wWcZJiZR+quI1bDSAggLJM2qxswy5J2wt
         LTZnKk4xNmLai01OEp28xaDFBrBFmKHHqb2rUpfYmIyPiZtrXkKbG1Yz5TvIKb5Flu
         CY2+Qf1z8DzmhhNZ6nqi3BrPPHTWCBCr/zsocfKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.6 004/106] usb: dwc3: gadget: Do link recovery for SS and SSP
Date:   Fri,  1 May 2020 15:22:37 +0200
Message-Id: <20200501131543.985322480@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit d0550cd20e52558ecf6847a0f96ebd5d944c17e4 upstream.

The controller always supports link recovery for device in SS and SSP.
Remove the speed limit check. Also, when the device is in RESUME or
RESET state, it means the controller received the resume/reset request.
The driver must send the link recovery to acknowledge the request. They
are valid states for the driver to send link recovery.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Fixes: ee5cd41c9117 ("usb: dwc3: Update speed checks for SuperSpeedPlus")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1728,7 +1728,6 @@ static int __dwc3_gadget_wakeup(struct d
 	u32			reg;
 
 	u8			link_state;
-	u8			speed;
 
 	/*
 	 * According to the Databook Remote wakeup request should
@@ -1738,16 +1737,13 @@ static int __dwc3_gadget_wakeup(struct d
 	 */
 	reg = dwc3_readl(dwc->regs, DWC3_DSTS);
 
-	speed = reg & DWC3_DSTS_CONNECTSPD;
-	if ((speed == DWC3_DSTS_SUPERSPEED) ||
-	    (speed == DWC3_DSTS_SUPERSPEED_PLUS))
-		return 0;
-
 	link_state = DWC3_DSTS_USBLNKST(reg);
 
 	switch (link_state) {
+	case DWC3_LINK_STATE_RESET:
 	case DWC3_LINK_STATE_RX_DET:	/* in HS, means Early Suspend */
 	case DWC3_LINK_STATE_U3:	/* in HS, means SUSPEND */
+	case DWC3_LINK_STATE_RESUME:
 		break;
 	default:
 		return -EINVAL;


