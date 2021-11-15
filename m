Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3395F44FF9B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 09:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbhKOIDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 03:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236486AbhKOIDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 03:03:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7830F63218;
        Mon, 15 Nov 2021 08:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636963252;
        bh=V5EwPQ0X/5E5qmAcTB0CXpNytwCMREu3BAQWJap9zHY=;
        h=From:To:Cc:Subject:Date:From;
        b=Lu0gb/T3Gni1rX0NrNmAwbWUvo4wyw1xA1V4/lz96c+05nOJ1UO5V16HO+6/29YLo
         2KnKOekHNLfBnO9fvueWhfPalU8n5SfsGN7vnyKMGUvTVk6tpCKy6ca9bw8gCCQNKx
         jvKoMdqgwZtnvAwyDHpalzTOh3XmEPZHtfloMHu2BqtRgl+I3vnlTv9UAAH8bd1FFk
         KF3dpiNNtAJ0Zg7zJuykz9RkFe4WhgK+1L21NR8p/87jAlC7SgLTxWNuv5IEBMitTD
         sVe0AzLGikJ0RhnZ9ApxxzGZbrm756w3s8XxGEy2wYd3cObXTaF6Z+OID7usXygrA3
         sHAhdz7y5DBIA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmWus-0006DB-0H; Mon, 15 Nov 2021 09:00:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH stable-4.19] USB: chipidea: fix interrupt deadlock
Date:   Mon, 15 Nov 2021 09:00:19 +0100
Message-Id: <20211115080019.23830-1-johan@kernel.org>
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
[ johan: backport to 4.19; adjust context ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---

This one should apply 4.14 as well.

Johan


 drivers/usb/chipidea/core.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index befd9235bcad..c13f9a153a5c 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -532,7 +532,7 @@ int hw_device_reset(struct ci_hdrc *ci)
 	return 0;
 }
 
-static irqreturn_t ci_irq(int irq, void *data)
+static irqreturn_t ci_irq_handler(int irq, void *data)
 {
 	struct ci_hdrc *ci = data;
 	irqreturn_t ret = IRQ_NONE;
@@ -585,6 +585,15 @@ static irqreturn_t ci_irq(int irq, void *data)
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
@@ -594,7 +603,7 @@ static int ci_cable_notifier(struct notifier_block *nb, unsigned long event,
 	cbl->connected = event;
 	cbl->changed = true;
 
-	ci_irq(ci->irq, ci);
+	ci_irq(ci);
 	return NOTIFY_DONE;
 }
 
@@ -1048,7 +1057,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = devm_request_irq(dev, ci->irq, ci_irq, IRQF_SHARED,
+	ret = devm_request_irq(dev, ci->irq, ci_irq_handler, IRQF_SHARED,
 			ci->platdata->name, ci);
 	if (ret)
 		goto stop;
@@ -1170,11 +1179,11 @@ static void ci_extcon_wakeup_int(struct ci_hdrc *ci)
 
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

