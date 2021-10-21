Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3B3435CF7
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 10:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhJUIh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 04:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231315AbhJUIh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Oct 2021 04:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B029E61056;
        Thu, 21 Oct 2021 08:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634805311;
        bh=o3tW0iefZ6vlMLLc4RHDUV7tkmTYHx0jXWdwLQLUb2E=;
        h=From:To:Cc:Subject:Date:From;
        b=qjddEYRRqpHNrO8tAyjy1wm9sehv/oPArfmEAVS9WYbm/HHgZxtIZhA6voaV01c4N
         kwzlGwYpl4a0tMWN0NSQ3wADYaSN/BhPFs5rIjz7LCDaNkXC4swkp42ZN2vtfD6wq0
         ug04d6GEwAjnpLDm84IElUu+IF/ulCDZuhCnahGMK0F0JXuICX06YCNiYDAlevXHTL
         4qu/9Cet5t8uhoognvTPB3rwgpbkEih9MQB8XRBu4jV5tb13irLwpzIkndB63mP0li
         IWpVJh1IxO1g4MuTO3zJjstaTYWGBpJygGU1LEn0ow2wW8jVMfMfSy/xfp6/DSwSWG
         4HujS8xBRtVKQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mdTXO-0005Ec-3w; Thu, 21 Oct 2021 10:34:58 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Peter Chen <peter.chen@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] USB: chipidea: fix interrupt deadlock
Date:   Thu, 21 Oct 2021 10:34:47 +0200
Message-Id: <20211021083447.20078-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chipidea core was calling the interrupt handler from non-IRQ context
with interrupts enabled, something which can lead to a deadlock if
there's an actual interrupt trying to take a lock that's already held
(e.g. the controller lock in udc_irq()).

Add a wrapper that can be used to fake interrupts instead of calling the
handler directly.

Fixes: 3ecb3e09b042 ("usb: chipidea: Use extcon framework for VBUS and ID detect")
Fixes: 876d4e1e8298 ("usb: chipidea: core: add wakeup support for extcon")
Cc: stable@vger.kernel.org      # 4.4
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/chipidea/core.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

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
-- 
2.32.0

