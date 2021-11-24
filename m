Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CED45BBEC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245291AbhKXMZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244504AbhKXMXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:23:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B564610A0;
        Wed, 24 Nov 2021 12:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756049;
        bh=VBmhEAGjHcz+ZDTTKPv9VefqqBfp+aeGDtv6M60YmDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKXl2zsPkd1K6OmzOLzB3H2bR22s3RQLEUH9de4cFGjU49iMm3O/4ohkK5E+KwgqQ
         lyPXNnPEv4CW+CxTzHz6nQOwWzyk9LP0jswxLaAzbW/2ReJgKpaE6vgYh8ejUU4OEY
         xDCMuBMKprziVbn4Jep1GsrsbsvRack9JTQe38Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 152/207] USB: chipidea: fix interrupt deadlock
Date:   Wed, 24 Nov 2021 12:57:03 +0100
Message-Id: <20211124115708.932678518@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
 drivers/usb/chipidea/core.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -516,7 +516,7 @@ int hw_device_reset(struct ci_hdrc *ci)
 	return 0;
 }
 
-static irqreturn_t ci_irq(int irq, void *data)
+static irqreturn_t ci_irq_handler(int irq, void *data)
 {
 	struct ci_hdrc *ci = data;
 	irqreturn_t ret = IRQ_NONE;
@@ -569,6 +569,15 @@ static irqreturn_t ci_irq(int irq, void
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
 static int ci_vbus_notifier(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
@@ -582,7 +591,7 @@ static int ci_vbus_notifier(struct notif
 
 	vbus->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -599,7 +608,7 @@ static int ci_id_notifier(struct notifie
 
 	id->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -1011,7 +1020,7 @@ static int ci_hdrc_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, ci);
-	ret = devm_request_irq(dev, ci->irq, ci_irq, IRQF_SHARED,
+	ret = devm_request_irq(dev, ci->irq, ci_irq_handler, IRQF_SHARED,
 			ci->platdata->name, ci);
 	if (ret)
 		goto stop;
@@ -1126,11 +1135,11 @@ static void ci_extcon_wakeup_int(struct
 
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


