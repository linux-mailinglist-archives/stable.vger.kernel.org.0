Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0598D4527A0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhKPC3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237034AbhKORQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:16:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B2E763244;
        Mon, 15 Nov 2021 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996357;
        bh=gLyvSPB0efmbcTwgc7Mide/CPIbANIPitHDrBphWL/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1/Wdg53rFQdrKNpHv2IpR//EbBKfJqFAAzW4/yO1zjpTVtqHEdgX9HHdVGN0na95
         HA9haSvw4V/bL0n0yBjfsHgUjtiT2f96A0BHnVz5FgThBo7V+PPHY+63FcP3d/DQpx
         GF0p+glvZEfzQkY0JHMixUPWnAccUEklg27Q7syE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 111/355] USB: chipidea: fix interrupt deadlock
Date:   Mon, 15 Nov 2021 18:00:35 +0100
Message-Id: <20211115165317.396001700@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 9aaa81c3366e8393a62374e3a1c67c69edc07b8a upstream.

Chipidea core was calling the interrupt handler from non-IRQ context
with interrupts enabled, something which can lead to a deadlock if
there's an actual interrupt trying to take a lock that's already held
(e.g. the controller lock in udc_irq()).

Add a wrapper that can be used to fake interrupts instead of calling the
handler directly.

Fixes: 3ecb3e09b042 ("usb: chipidea: Use extcon framework for VBUS and ID detect")
Fixes: 876d4e1e8298 ("usb: chipidea: core: add wakeup support for extcon")
Cc: Peter Chen <peter.chen@kernel.org>
Cc: stable@vger.kernel.org      # 4.4
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211021083447.20078-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -534,7 +534,7 @@ int hw_device_reset(struct ci_hdrc *ci)
 	return 0;
 }
 
-static irqreturn_t ci_irq(int irq, void *data)
+static irqreturn_t ci_irq_handler(int irq, void *data)
 {
 	struct ci_hdrc *ci = data;
 	irqreturn_t ret = IRQ_NONE;
@@ -587,6 +587,15 @@ static irqreturn_t ci_irq(int irq, void
 	return ret;
 }
 
+static void ci_irq(struct ci_hdrc *ci)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	ci_irq_handler(ci->irq, ci);
+	local_irq_restore(flags);
+}
+
 static int ci_cable_notifier(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
@@ -596,7 +605,7 @@ static int ci_cable_notifier(struct noti
 	cbl->connected = event;
 	cbl->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -634,7 +643,7 @@ static int ci_usb_role_switch_set(struct
 	if (cable) {
 		cable->changed = true;
 		cable->connected = false;
-		ci_irq(ci->irq, ci);
+		ci_irq(ci);
 		spin_unlock_irqrestore(&ci->lock, flags);
 		if (ci->wq && role != USB_ROLE_NONE)
 			flush_workqueue(ci->wq);
@@ -652,7 +661,7 @@ static int ci_usb_role_switch_set(struct
 	if (cable) {
 		cable->changed = true;
 		cable->connected = true;
-		ci_irq(ci->irq, ci);
+		ci_irq(ci);
 	}
 	spin_unlock_irqrestore(&ci->lock, flags);
 	pm_runtime_put_sync(ci->dev);
@@ -1156,7 +1165,7 @@ static int ci_hdrc_probe(struct platform
 		}
 	}
 
-	ret = devm_request_irq(dev, ci->irq, ci_irq, IRQF_SHARED,
+	ret = devm_request_irq(dev, ci->irq, ci_irq_handler, IRQF_SHARED,
 			ci->platdata->name, ci);
 	if (ret)
 		goto stop;
@@ -1277,11 +1286,11 @@ static void ci_extcon_wakeup_int(struct
 
 	if (!IS_ERR(cable_id->edev) && ci->is_otg &&
 		(otgsc & OTGSC_IDIE) && (otgsc & OTGSC_IDIS))
-		ci_irq(ci->irq, ci);
+		ci_irq(ci);
 
 	if (!IS_ERR(cable_vbus->edev) && ci->is_otg &&
 		(otgsc & OTGSC_BSVIE) && (otgsc & OTGSC_BSVIS))
-		ci_irq(ci->irq, ci);
+		ci_irq(ci);
 }
 
 static int ci_controller_resume(struct device *dev)


