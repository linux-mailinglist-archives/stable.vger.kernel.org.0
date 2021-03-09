Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D4E331CD1
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 03:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhCICRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 21:17:08 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:34614 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230224AbhCICQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 21:16:52 -0500
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 95A754016B;
        Tue,  9 Mar 2021 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1615256212; bh=wLMLIhb+/hvqLoumyo8tdobhhtAwqLv2YxVlGttEtxY=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=KrZvBoa36ieuluNPuxuPZdcCpZ6CORP4/n8X8Bn6nNMphryJJoLZ3pIAp9mNng+W0
         bNfD3v7OVvkAcxbSgTJZ7VfiwQn1sSzIvOcGxdtBRgs3iJIMUfHLN3Qz+HWbOkZEMy
         I4ndpCsjd8su4NaNK0Mkh1eXaMeJnGL9sjkm0mCtf/e4DwZUP4ZaNM/yYkqT4HrNZ3
         vnjrzo3ew4WQ2jIAxHzMDW5W9ofIwuIb9a4By4BmkK0G6lA8XVi4lcGz62Z40lIEB6
         uySAr5il72vAnbLkBiL9BoJNDPFCzOpVGcYdtJWaK/YoiPzTnvI71K3tRy0T1z6q15
         ZOybrFobrmkIA==
Received: from lab-vbox (unknown [10.205.145.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 30DDCA006F;
        Tue,  9 Mar 2021 02:16:50 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Mon, 08 Mar 2021 18:16:50 -0800
Date:   Mon, 08 Mar 2021 18:16:50 -0800
Message-Id: <55ac7001af73bfe9bc750c6446ef4ac8cf6f9313.1615254129.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1615254129.git.Thinh.Nguyen@synopsys.com>
References: <cover.1615254129.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 2/2] usb: dwc3: gadget: Use max speed if unspecified
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the gadget driver doesn't specify a max_speed, then use the
controller's maximum supported speed as default. For DWC_usb32 IP, the
gadget's speed maybe limited to gen2x1 rate only if the driver's
max_speed is unknown. This scenario should not occur with the current
implementation since the default gadget driver's max_speed should always
be specified. However, to make the driver more robust and help with
readability, let's cover all the scenarios in __dwc3_gadget_set_speed().

Cc: <stable@vger.kernel.org>
Fixes: 450b9e9fabd8 ("usb: dwc3: gadget: Set speed only up to the max supported")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 53696c4bed0a..a04a9757f541 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2083,7 +2083,7 @@ static void __dwc3_gadget_set_speed(struct dwc3 *dwc)
 	u32			reg;
 
 	speed = dwc->gadget_max_speed;
-	if (speed > dwc->maximum_speed)
+	if (speed == USB_SPEED_UNKNOWN || speed > dwc->maximum_speed)
 		speed = dwc->maximum_speed;
 
 	if (speed == USB_SPEED_SUPER_PLUS &&
-- 
2.28.0

