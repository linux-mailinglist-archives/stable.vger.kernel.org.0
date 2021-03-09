Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3687B331CD3
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 03:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhCICRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 21:17:08 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:34608 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229750AbhCICQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 21:16:45 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A667D4016B;
        Tue,  9 Mar 2021 02:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1615256205; bh=LzV3W6moBk7atuKQ8g/fYRr9qhafHcwgywKKZEEIrl8=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=i1CtvjaWaaECWGycPF75jKqJoLSA3Ud0u4MVm/Tpezg+S7VM3aBP39gm6TWkmMVtw
         /1fm7Tb3Jsz5VVOA67gBOM6pjEB7qLNG2WyS7Z9kX4fhqQ4yra6riVowpgUT+grGez
         vahz0tzKPFuPDWl1zcZr7LWDEVPMTg2vdioFNI/uOY37gjYUwwDiaLDQ7g1C+vaZaQ
         yEDeUpkgc7oryoSE17OYk2ic2L6zpncBQMrggG4u99AzlniDnErH5k3lVVpyW6rg6N
         D+PxqaxA+jEy4SrZiW5SRtA+LtjLgRX6kBaIb6ud4l8525XKmLOxp21m0tr3/heelj
         8esuIal2wKKJQ==
Received: from lab-vbox (unknown [10.205.145.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 75DB2A005E;
        Tue,  9 Mar 2021 02:16:44 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Mon, 08 Mar 2021 18:16:44 -0800
Date:   Mon, 08 Mar 2021 18:16:44 -0800
Message-Id: <0b2732e2f380d9912ee87f39dc82c2139223bad9.1615254129.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1615254129.git.Thinh.Nguyen@synopsys.com>
References: <cover.1615254129.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 1/2] usb: dwc3: gadget: Set gadget_max_speed when set ssp_rate
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set the dwc->gadget_max_speed to SuperSpeed Plus if the user sets the
ssp_rate. The udc_set_ssp_rate() is intended for setting the gadget's
speed to SuperSpeed Plus at the specified rate.

Cc: <stable@vger.kernel.org>
Fixes: 072cab8a0fe2 ("usb: dwc3: gadget: Implement setting of SSP rate")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index aebcf8ec0716..53696c4bed0a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2523,6 +2523,7 @@ static void dwc3_gadget_set_ssp_rate(struct usb_gadget *g,
 	unsigned long		flags;
 
 	spin_lock_irqsave(&dwc->lock, flags);
+	dwc->gadget_max_speed = USB_SPEED_SUPER_PLUS;
 	dwc->gadget_ssp_rate = rate;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 }
-- 
2.28.0

