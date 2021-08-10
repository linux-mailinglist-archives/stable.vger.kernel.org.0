Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF73E8072
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhHJRtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234353AbhHJRrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D555A61261;
        Tue, 10 Aug 2021 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617254;
        bh=RDMc6f6+oHGp9OQZkfFNST22NUvsvoZ6295xLgFaI/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEvUqV3MRyZ1UO9UPQlGwFzwiyJJhNQe/lSpij02LLvt5BEc4cPwLePaMRcwwcHJw
         hFHASQUrk2af8JMbN8GnFO3zG8iNQiql3TETBymuZJ21eRIuPVoF5VhU0OINWVHNV9
         hxJebPnuTR2hAkzLaPuNxxTXfCFSqwSGJIjF4POM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 5.10 070/135] usb: host: ohci-at91: suspend/resume ports after/before OHCI accesses
Date:   Tue, 10 Aug 2021 19:30:04 +0200
Message-Id: <20210810172958.101008340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit 00de6a572f30ee93cad7e0704ec4232e5e72bda8 upstream.

On SAMA7G5 suspending ports will cut the access to OHCI registers and
any subsequent access to them will lead to CPU being blocked trying to
access that memory. Same thing happens on resume: if OHCI memory is
accessed before resuming ports the CPU will block on that access. The
OCHI memory is accessed on suspend/resume though
ohci_suspend()/ohci_resume().

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210721132905.1970713-1-claudiu.beznea@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-at91.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -606,8 +606,6 @@ ohci_hcd_at91_drv_suspend(struct device
 	if (ohci_at91->wakeup)
 		enable_irq_wake(hcd->irq);
 
-	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
-
 	ret = ohci_suspend(hcd, ohci_at91->wakeup);
 	if (ret) {
 		if (ohci_at91->wakeup)
@@ -627,7 +625,10 @@ ohci_hcd_at91_drv_suspend(struct device
 		/* flush the writes */
 		(void) ohci_readl (ohci, &ohci->regs->control);
 		msleep(1);
+		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
 		at91_stop_clock(ohci_at91);
+	} else {
+		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
 	}
 
 	return ret;
@@ -639,6 +640,8 @@ ohci_hcd_at91_drv_resume(struct device *
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct ohci_at91_priv *ohci_at91 = hcd_to_ohci_at91_priv(hcd);
 
+	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 0);
+
 	if (ohci_at91->wakeup)
 		disable_irq_wake(hcd->irq);
 	else
@@ -646,8 +649,6 @@ ohci_hcd_at91_drv_resume(struct device *
 
 	ohci_resume(hcd, false);
 
-	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 0);
-
 	return 0;
 }
 


