Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5733E8180
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhHJSAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238023AbhHJR6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C559610A0;
        Tue, 10 Aug 2021 17:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617542;
        bh=751qO+TV5abJ1E4piigMO3mEmCHr9WzRj2++EBajwGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUQDmXm9dilZMdzn4UEQzTT4P+3a+6Q+9+BPTcQ8zSYAfyleFvEGSnQ8daipxwBEM
         bxkvDiLL0P6AXpwo0WSdgF89WqTxX0t0XvLs2MCzC6eaTHUzLl7OS3hX8WFGjKVHPE
         DSaGW6JkMs1HKiWWcsSfqd/pZzien/TCL9jXJsks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 5.13 097/175] usb: host: ohci-at91: suspend/resume ports after/before OHCI accesses
Date:   Tue, 10 Aug 2021 19:30:05 +0200
Message-Id: <20210810173004.144648038@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
@@ -611,8 +611,6 @@ ohci_hcd_at91_drv_suspend(struct device
 	if (ohci_at91->wakeup)
 		enable_irq_wake(hcd->irq);
 
-	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
-
 	ret = ohci_suspend(hcd, ohci_at91->wakeup);
 	if (ret) {
 		if (ohci_at91->wakeup)
@@ -632,7 +630,10 @@ ohci_hcd_at91_drv_suspend(struct device
 		/* flush the writes */
 		(void) ohci_readl (ohci, &ohci->regs->control);
 		msleep(1);
+		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
 		at91_stop_clock(ohci_at91);
+	} else {
+		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
 	}
 
 	return ret;
@@ -644,6 +645,8 @@ ohci_hcd_at91_drv_resume(struct device *
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct ohci_at91_priv *ohci_at91 = hcd_to_ohci_at91_priv(hcd);
 
+	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 0);
+
 	if (ohci_at91->wakeup)
 		disable_irq_wake(hcd->irq);
 	else
@@ -651,8 +654,6 @@ ohci_hcd_at91_drv_resume(struct device *
 
 	ohci_resume(hcd, false);
 
-	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 0);
-
 	return 0;
 }
 


