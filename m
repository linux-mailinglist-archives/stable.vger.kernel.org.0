Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784E544F883
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKNObD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231831AbhKNOay (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 09:30:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B187B61027;
        Sun, 14 Nov 2021 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636900080;
        bh=cuVO6j8l9scZC2MgxkTr+YWk/w/hge8KH4uOMNY3Bkg=;
        h=Subject:To:Cc:From:Date:From;
        b=pmyFeQX0WyYxQF7ri2bYISeprHAwCsc7kv3AvpvNlma+fJrO+xfDczs43RwUJYFYE
         qndeSwHOcDBZfTb5oldA4aPMeLg/LnwNlHqSnnqL9lg+Z8QFeIWl+REUc05J2cYPwp
         T72+oUmY9s+kHAWPS/xEO/zpAtF9ojW5XEiD+ecU=
Subject: FAILED: patch "[PATCH] USB: chipidea: fix interrupt deadlock" failed to apply to 4.19-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org, peter.chen@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 15:27:45 +0100
Message-ID: <163690006542246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9aaa81c3366e8393a62374e3a1c67c69edc07b8a Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 21 Oct 2021 10:34:47 +0200
Subject: [PATCH] USB: chipidea: fix interrupt deadlock

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

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 2b18f5088ae4..a56f06368d14 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -514,7 +514,7 @@ int hw_device_reset(struct ci_hdrc *ci)
 	return 0;
 }
 
-static irqreturn_t ci_irq(int irq, void *data)
+static irqreturn_t ci_irq_handler(int irq, void *data)
 {
 	struct ci_hdrc *ci = data;
 	irqreturn_t ret = IRQ_NONE;
@@ -567,6 +567,15 @@ static irqreturn_t ci_irq(int irq, void *data)
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
@@ -576,7 +585,7 @@ static int ci_cable_notifier(struct notifier_block *nb, unsigned long event,
 	cbl->connected = event;
 	cbl->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -617,7 +626,7 @@ static int ci_usb_role_switch_set(struct usb_role_switch *sw,
 	if (cable) {
 		cable->changed = true;
 		cable->connected = false;
-		ci_irq(ci->irq, ci);
+		ci_irq(ci);
 		spin_unlock_irqrestore(&ci->lock, flags);
 		if (ci->wq && role != USB_ROLE_NONE)
 			flush_workqueue(ci->wq);
@@ -635,7 +644,7 @@ static int ci_usb_role_switch_set(struct usb_role_switch *sw,
 	if (cable) {
 		cable->changed = true;
 		cable->connected = true;
-		ci_irq(ci->irq, ci);
+		ci_irq(ci);
 	}
 	spin_unlock_irqrestore(&ci->lock, flags);
 	pm_runtime_put_sync(ci->dev);
@@ -1174,7 +1183,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = devm_request_irq(dev, ci->irq, ci_irq, IRQF_SHARED,
+	ret = devm_request_irq(dev, ci->irq, ci_irq_handler, IRQF_SHARED,
 			ci->platdata->name, ci);
 	if (ret)
 		goto stop;
@@ -1295,11 +1304,11 @@ static void ci_extcon_wakeup_int(struct ci_hdrc *ci)
 
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

