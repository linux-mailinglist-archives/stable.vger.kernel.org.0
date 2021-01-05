Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3942EB0B4
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbhAEQ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:57:37 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:34518 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728245AbhAEQ5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:57:37 -0500
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8B713C00B8;
        Tue,  5 Jan 2021 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609865796; bh=BeNyS+piEo9lXyF0Mp4EaHrXB9yVe3bHjhk0IftGpic=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=OWQ1YE2l4JFVjsRQPkWeAA+YfUjzFY/lc6aBD2ZpfCll+g62RoWuMBCkcpFAj2BBJ
         ZxCqxha6wwiaeS/SKtv5UsGjf/49PAU0ZBfBT5cWQBIpS848xuv3OqNNyygPx2vXXo
         eytRF08Umc3lSL6U/H4t7dwVNFo1tKqvvexBEbVLgyOuBzokQbdQ8dqC0STMcVcw7V
         6fWOm8Uo27Ed8ghIXPRAI3Rwl0+Tddns1i4TON3V4sd/bky0D4RJHidUCT2ZJ+Z/67
         kP7g7r42WYw+UBBD5bCi+zki6xajJP4kpVyZ7tV4U9JbBtEcW4w1pZVZ3PhP2QrGtt
         XmRbNop8+t5PA==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 07B00A006F;
        Tue,  5 Jan 2021 16:56:34 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Tue, 05 Jan 2021 08:56:34 -0800
Date:   Tue, 05 Jan 2021 08:56:34 -0800
Message-Id: <92118292e053f3a1a9238facfec91630468ba752.1609865348.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 1/2] usb: dwc3: gadget: Check if the gadget had started
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the gadget had already started, don't try to start again. Otherwise,
we may request the same threaded irq with the same dev_id, it will mess
up the interrupt freeing logic. This can happen if a user tries to
trigger a soft-connect from soft_connect sysfs multiple times. Check to
make sure that the gadget had started before proceeding to request
threaded irq. Fix this by checking if there's bounded gadget driver.

Cc: stable@vger.kernel.org
Fixes: b0d7ffd44ba9 ("usb: dwc3: gadget: don't request IRQs in atomic")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 25f654b79e48..51d81a32ce78 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2303,35 +2303,27 @@ static int dwc3_gadget_start(struct usb_gadget *g,
 	int			ret = 0;
 	int			irq;
 
+	if (dwc->gadget_driver) {
+		dev_err(dwc->dev, "%s is already bound to %s\n",
+				dwc->gadget->name,
+				dwc->gadget_driver->driver.name);
+		return -EBUSY;
+	}
+
 	irq = dwc->irq_gadget;
 	ret = request_threaded_irq(irq, dwc3_interrupt, dwc3_thread_interrupt,
 			IRQF_SHARED, "dwc3", dwc->ev_buf);
 	if (ret) {
 		dev_err(dwc->dev, "failed to request irq #%d --> %d\n",
 				irq, ret);
-		goto err0;
+		return ret;
 	}
 
 	spin_lock_irqsave(&dwc->lock, flags);
-	if (dwc->gadget_driver) {
-		dev_err(dwc->dev, "%s is already bound to %s\n",
-				dwc->gadget->name,
-				dwc->gadget_driver->driver.name);
-		ret = -EBUSY;
-		goto err1;
-	}
-
 	dwc->gadget_driver	= driver;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
-
-err1:
-	spin_unlock_irqrestore(&dwc->lock, flags);
-	free_irq(irq, dwc);
-
-err0:
-	return ret;
 }
 
 static void __dwc3_gadget_stop(struct dwc3 *dwc)
-- 
2.28.0

