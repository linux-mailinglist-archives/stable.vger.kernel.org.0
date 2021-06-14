Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F003A62EF
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhFNLGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235158AbhFNLEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C6E861922;
        Mon, 14 Jun 2021 10:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667504;
        bh=GZTvuJ4ltC2xa1h+xkROpdxuA/Sh+xJtoNitjtceiRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItY5Dp/grATxrdRpIzrydR4XdSP89HUZkv1OllMGEBVRgQQICyNuhogOzq3wZJD2G
         c3c6ftoZQAbCnhbTEwpY3J/hb52NUvawIMJuaU+xT5Q8wfoJJM+ZPFAfyrKzeT7koc
         ddwYBycSmusWXPULe5faOLnTJapiZm0zl/7WEOFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.10 097/131] usb: dwc3: gadget: Disable gadget IRQ during pullup disable
Date:   Mon, 14 Jun 2021 12:27:38 +0200
Message-Id: <20210614102656.303490027@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit 8212937305f84ef73ea81036dafb80c557583d4b upstream.

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
@@ -2143,13 +2143,10 @@ static int dwc3_gadget_pullup(struct usb
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
 
@@ -2187,6 +2184,8 @@ static int dwc3_gadget_pullup(struct usb
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	enable_irq(dwc->irq_gadget);
+
 	pm_runtime_put(dwc->dev);
 
 	return ret;


