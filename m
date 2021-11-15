Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3416144FF9E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 09:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhKOIEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 03:04:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236817AbhKOID7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 03:03:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4806E63219;
        Mon, 15 Nov 2021 08:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636963264;
        bh=Gvg9PuBayQuUuUQ0PJ/p8tpgZlb8vKjAFLRFIv55ViA=;
        h=From:To:Cc:Subject:Date:From;
        b=HgwmkVSo1eiNXwc5OipRo8asB6K0p0hlfI0P+Uu6/T4683Tk3eR+9IjeiCdJP5oub
         KIpFQPZSnyswDIyyUXFI6H5PEOacScb8mt/W3hVWCb9kHP+6lS3M/TahznZi4uJQuz
         DA60URjPPxyHDx6TctnphfGw3dBpb0tyaoeP0i58X+lo2om09nXKEW2r0gmqbWxk7I
         XOeQLortoHZ7CUrxitcoksx3I2LRFtDP+01M6xzGD2WC2Y7FwqjgDq/SzRC6EJY5R+
         A+XUoj+koPEAhR2SSiAfzuAFCG5hYCdMuzh5ZgAK2/SKYHjoKh9PH7PMDFKjIctgEN
         2EfIBqY81JOHA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmWv4-0006EA-Ru; Mon, 15 Nov 2021 09:00:50 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH stable-4.9] USB: chipidea: fix interrupt deadlock
Date:   Mon, 15 Nov 2021 09:00:43 +0100
Message-Id: <20211115080043.23894-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[ johan: backport to 4.9; adjust context ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---

This one should apply to 4.4 as well.

Johan


 drivers/usb/chipidea/core.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 6062a5d816a6..f4b13f0637ea 100644
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
@@ -569,6 +569,15 @@ static irqreturn_t ci_irq(int irq, void *data)
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
@@ -582,7 +591,7 @@ static int ci_vbus_notifier(struct notifier_block *nb, unsigned long event,
 
 	vbus->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -599,7 +608,7 @@ static int ci_id_notifier(struct notifier_block *nb, unsigned long event,
 
 	id->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -1011,7 +1020,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, ci);
-	ret = devm_request_irq(dev, ci->irq, ci_irq, IRQF_SHARED,
+	ret = devm_request_irq(dev, ci->irq, ci_irq_handler, IRQF_SHARED,
 			ci->platdata->name, ci);
 	if (ret)
 		goto stop;
@@ -1126,11 +1135,11 @@ static void ci_extcon_wakeup_int(struct ci_hdrc *ci)
 
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

