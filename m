Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B2D3EB896
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241835AbhHMPOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242059AbhHMPNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB66960F51;
        Fri, 13 Aug 2021 15:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867578;
        bh=a3vDXSCCIlpHRHwFA5jZwKxG6ZSprg6N7/40bTR/5Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuRTzxfHWylV6ycdaUOdy4Hr+TQp4nc3q3bygxxEPxMynijyeMK/wSOR4X5fUPeu4
         mWFeyIy2hUncWsf7RCsXSIoDAlfGoHSzf6Etp/IujrTLe2jkixOZhe9dL4Yh9OheSY
         a/+yEJmDtzK+Gs1hykNrq/aB68AOMgasDGwtJm4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Wesley Cheng" <wcheng@codeaurora.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 10/27] usb: dwc3: gadget: Disable gadget IRQ during pullup disable
Date:   Fri, 13 Aug 2021 17:07:08 +0200
Message-Id: <20210813150523.706201928@linuxfoundation.org>
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

[ Upstream commit 8212937305f84ef73ea81036dafb80c557583d4b ]

Current sequence utilizes dwc3_gadget_disable_irq() alongside
synchronize_irq() to ensure that no further DWC3 events are generated.
However, the dwc3_gadget_disable_irq() API only disables device
specific events.  Endpoint events can still be generated.  Briefly
disable the interrupt line, so that the cleanup code can run to
prevent device and endpoint events. (i.e. __dwc3_gadget_stop() and
dwc3_stop_active_transfers() respectively)

Without doing so, it can lead to both the interrupt handler and the
pullup disable routine both writing to the GEVNTCOUNT register, which
will cause an incorrect count being read from future interrupts.

Fixes: ae7e86108b12 ("usb: dwc3: Stop active transfers before halting the controller")
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1621571037-1424-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2030,13 +2030,10 @@ static int dwc3_gadget_pullup(struct usb
 	}
 
 	/*
-	 * Synchronize any pending event handling before executing the controller
-	 * halt routine.
+	 * Synchronize and disable any further event handling while controller
+	 * is being enabled/disabled.
 	 */
-	if (!is_on) {
-		dwc3_gadget_disable_irq(dwc);
-		synchronize_irq(dwc->irq_gadget);
-	}
+	disable_irq(dwc->irq_gadget);
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
@@ -2074,6 +2071,8 @@ static int dwc3_gadget_pullup(struct usb
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	enable_irq(dwc->irq_gadget);
+
 	pm_runtime_put(dwc->dev);
 
 	return ret;


