Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3C26DC57
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgIQMwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 08:52:04 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:53012 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbgIQMid (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 08:38:33 -0400
X-Greylist: delayed 1962 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 08:37:38 EDT
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4BsbGy2wP2z9x2S;
        Thu, 17 Sep 2020 14:04:10 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BsbGR4pKsz2TTN4;
        Thu, 17 Sep 2020 14:03:43 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.80) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 17 Sep
 2020 14:03:43 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Jonathan Cameron <jic23@kernel.org>
CC:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>, <stable@vger.kernel.org>
Subject: [PATCH v2] iio: trigger: Don't use RT priority
Date:   Thu, 17 Sep 2020 14:03:33 +0200
Message-ID: <20200917120333.2337-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.80]
X-RMX-ID: 20200917-140343-4BsbGR4pKsz2TTN4-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Triggers may raise transactions on slow busses like I2C.  Using the
original RT priority of a threaded IRQ may prevent other important IRQ
handlers from being run.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
In my particular case (on a RT kernel), the RT priority of the sysfstrig
threaded IRQ handler caused (temporarily) raising the prio of a user
space process which was holding the I2C bus mutex.

Due to a bug in the i2c-imx driver, this process spent 500 ms in a busy-wait
loop and prevented all threaded IRQ handlers from being run during this
time.

v2:
- Use sched_set_normal() instead of sched_setscheduler_nocheck()

 drivers/iio/industrialio-trigger.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
index 6f16357fd732..7ed00ad695c7 100644
--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -9,7 +9,10 @@
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 
 #include <linux/iio/iio.h>
@@ -245,6 +248,7 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
 	int ret = 0;
 	bool notinuse
 		= bitmap_empty(trig->pool, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+	struct irq_desc *irq_desc;
 
 	/* Prevent the module from being removed whilst attached to a trigger */
 	__module_get(pf->indio_dev->driver_module);
@@ -264,6 +268,12 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
 	if (ret < 0)
 		goto out_put_irq;
 
+	/* Triggers may raise transactions on slow busses like I2C.  Using the original RT priority
+	 * of a threaded IRQ may prevent other threaded IRQ handlers from being run.
+	 */
+	irq_desc = irq_to_desc(pf->irq);
+	sched_set_normal(irq_desc->action->thread, 0);
+
 	/* Enable trigger in driver */
 	if (trig->ops && trig->ops->set_trigger_state && notinuse) {
 		ret = trig->ops->set_trigger_state(trig, true);
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

