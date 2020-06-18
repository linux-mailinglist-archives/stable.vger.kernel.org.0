Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09EE1FEDFF
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 10:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgFRInb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 04:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgFRIn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 04:43:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9580F20EDD;
        Thu, 18 Jun 2020 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592469806;
        bh=AHIXgOMXF0nixoA/tAHQfqUzr73l4+ZmuxLYclPw8Dw=;
        h=Subject:To:From:Date:From;
        b=yFjx44ko3xMV8O8iQNKcazKsonRr0dhYfVV0TOeYtHTTVIng3I/5ovrV9rJ7bacAa
         6bwNM+k42VF335TxI5gZa0g6j9SrVrFGsPGJKgvIWiUPiD7Xvxj8zf+bcflIqWbMXE
         OERH9pWif4ZHZTDKcajtkaROFyMdbwCnIMZPe9io=
Subject: patch "usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs" added to usb-linus
To:     jun.li@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, john.stultz@linaro.org,
        linux@roeck-us.net, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 10:43:09 +0200
Message-ID: <1592469789162249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 302c570bf36e997d55ad0d60628a2feec76954a4 Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Thu, 4 Jun 2020 19:21:18 +0800
Subject: usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs

John reported screaming irq caused by rt1711h when system boot[1],
this is because irq request is done before tcpci_register_port(),
so the chip->tcpci has not been setup, irq handler is entered but
can't do anything, this patch is to address this by moving the irq
request after tcpci_register_port().

[1] https://lore.kernel.org/linux-usb/20200530040157.31038-1-john.stultz@linaro.org

Fixes: ce08eaeb6388 ("staging: typec: rt1711h typec chip driver")
Cc: stable <stable@vger.kernel.org> # v4.18+
Cc: John Stultz <john.stultz@linaro.org>
Reported-and-tested-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/20200604112118.38062-1-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci_rt1711h.c | 31 +++++++++-----------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_rt1711h.c b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
index 017389021b96..b56a0880a044 100644
--- a/drivers/usb/typec/tcpm/tcpci_rt1711h.c
+++ b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
@@ -179,26 +179,6 @@ static irqreturn_t rt1711h_irq(int irq, void *dev_id)
 	return tcpci_irq(chip->tcpci);
 }
 
-static int rt1711h_init_alert(struct rt1711h_chip *chip,
-			      struct i2c_client *client)
-{
-	int ret;
-
-	/* Disable chip interrupts before requesting irq */
-	ret = rt1711h_write16(chip, TCPC_ALERT_MASK, 0);
-	if (ret < 0)
-		return ret;
-
-	ret = devm_request_threaded_irq(chip->dev, client->irq, NULL,
-					rt1711h_irq,
-					IRQF_ONESHOT | IRQF_TRIGGER_LOW,
-					dev_name(chip->dev), chip);
-	if (ret < 0)
-		return ret;
-	enable_irq_wake(client->irq);
-	return 0;
-}
-
 static int rt1711h_sw_reset(struct rt1711h_chip *chip)
 {
 	int ret;
@@ -260,7 +240,8 @@ static int rt1711h_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	ret = rt1711h_init_alert(chip, client);
+	/* Disable chip interrupts before requesting irq */
+	ret = rt1711h_write16(chip, TCPC_ALERT_MASK, 0);
 	if (ret < 0)
 		return ret;
 
@@ -271,6 +252,14 @@ static int rt1711h_probe(struct i2c_client *client,
 	if (IS_ERR_OR_NULL(chip->tcpci))
 		return PTR_ERR(chip->tcpci);
 
+	ret = devm_request_threaded_irq(chip->dev, client->irq, NULL,
+					rt1711h_irq,
+					IRQF_ONESHOT | IRQF_TRIGGER_LOW,
+					dev_name(chip->dev), chip);
+	if (ret < 0)
+		return ret;
+	enable_irq_wake(client->irq);
+
 	return 0;
 }
 
-- 
2.27.0


