Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A926A1BFBFD
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgD3OCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgD3Nxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF37E24959;
        Thu, 30 Apr 2020 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254815;
        bh=ZeQ+nsfG34bCl5uEds18kIJEKqqdj1c0qRK1uyLut8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkloH/vru3NPp6yh0HeYo8YWd6sxIKafNuAb6wx6tBjEqFgo5rRnjHA5SoIlVivI9
         U+Q2pYwKd+3adiVm77awOi8W3SbZsr9a0GaqVjRp6vPfTdGHj1kHo8ia6s5Tx8ktwJ
         4c48vy/1fwUqqby81ybTufjVa2c63KmP47mK05bg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/30] usb: dwc3: gadget: Do link recovery for SS and SSP
Date:   Thu, 30 Apr 2020 09:53:03 -0400
Message-Id: <20200430135325.20762-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135325.20762-1-sashal@kernel.org>
References: <20200430135325.20762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit d0550cd20e52558ecf6847a0f96ebd5d944c17e4 ]

The controller always supports link recovery for device in SS and SSP.
Remove the speed limit check. Also, when the device is in RESUME or
RESET state, it means the controller received the resume/reset request.
The driver must send the link recovery to acknowledge the request. They
are valid states for the driver to send link recovery.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Fixes: ee5cd41c9117 ("usb: dwc3: Update speed checks for SuperSpeedPlus")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 50d2481041c85..99f6a5aa01095 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1577,7 +1577,6 @@ static int __dwc3_gadget_wakeup(struct dwc3 *dwc)
 	u32			reg;
 
 	u8			link_state;
-	u8			speed;
 
 	/*
 	 * According to the Databook Remote wakeup request should
@@ -1587,16 +1586,13 @@ static int __dwc3_gadget_wakeup(struct dwc3 *dwc)
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
-- 
2.20.1

