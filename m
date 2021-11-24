Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C8045BA50
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbhKXMJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236365AbhKXMIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:08:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA09960FE7;
        Wed, 24 Nov 2021 12:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755480;
        bh=8cr3ZoFMncs/Dg1Rf9OzB0VOmW96d/RgGv4mrjh/nsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYtlLIQLn6uLTWF5FYvF7ORpjURKrcDJEB6d3wHzSA2gqiEyZxrCkSd+F/BU2LNQG
         MieS2Sg9OzNcoXvNlw0uaZJ/c/QWDEZ+x2GsGhrPk+ZebIYbygWiyH7yYHgeXxg3Y7
         vSFS/Pgb4RJXPhOvWYR35MrODPVfeOB8Mtfko19Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 110/162] USB: chipidea: fix interrupt deadlock
Date:   Wed, 24 Nov 2021 12:56:53 +0100
Message-Id: <20211124115701.884789980@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
@@ -518,7 +518,7 @@ int hw_device_reset(struct ci_hdrc *ci)
 	return 0;
 }
 
-static irqreturn_t ci_irq(int irq, void *data)
+static irqreturn_t ci_irq_handler(int irq, void *data)
 {
 	struct ci_hdrc *ci = data;
 	irqreturn_t ret = IRQ_NONE;
@@ -571,6 +571,15 @@ static irqreturn_t ci_irq(int irq, void
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
@@ -584,7 +593,7 @@ static int ci_vbus_notifier(struct notif
 
 	vbus->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -601,7 +610,7 @@ static int ci_id_notifier(struct notifie
 
 	id->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -1023,7 +1032,7 @@ static int ci_hdrc_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, ci);
-	ret = devm_request_irq(dev, ci->irq, ci_irq, IRQF_SHARED,
+	ret = devm_request_irq(dev, ci->irq, ci_irq_handler, IRQF_SHARED,
 			ci->platdata->name, ci);
 	if (ret)
 		goto stop;
@@ -1138,11 +1147,11 @@ static void ci_extcon_wakeup_int(struct
 
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


