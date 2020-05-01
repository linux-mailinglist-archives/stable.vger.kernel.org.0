Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3E51C15EA
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgEANgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730327AbgEANgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98317216FD;
        Fri,  1 May 2020 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340161;
        bh=WM6Psp5MWsVb3j3Aezr/CMsEltwqmJ+7sheXVHai2yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hierap/HkwRAZiaqCbcTh+iZjJ+OuOoZuSmkSz0MrINS09FSBEhNRFOiJsZSRdLyn
         sEftq9aK63o+kbrxF6eR313XCmmfYYEbubaHQxaRtpSbwegZSXxZ18D9mrQsy/CQiY
         VG5sdMd7Fo5o7StTAzUwjJ+InD0EiFobnlobZSvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 05/46] usb: dwc3: gadget: Do link recovery for SS and SSP
Date:   Fri,  1 May 2020 15:22:30 +0200
Message-Id: <20200501131501.161306362@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
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
@@ -1577,7 +1577,6 @@ static int __dwc3_gadget_wakeup(struct d
 	u32			reg;
 
 	u8			link_state;
-	u8			speed;
 
 	/*
 	 * According to the Databook Remote wakeup request should
@@ -1587,16 +1586,13 @@ static int __dwc3_gadget_wakeup(struct d
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


