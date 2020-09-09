Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA222631B9
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgIIQYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:24:53 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:47913 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbgIIQXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 12:23:12 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4BmnP26wDzz9sp2;
        Wed,  9 Sep 2020 18:22:46 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BmnNc1mPXz2TSDs;
        Wed,  9 Sep 2020 18:22:24 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.16) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 9 Sep
 2020 18:22:23 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Jonathan Cameron <jic23@kernel.org>
CC:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>, <stable@vger.kernel.org>
Subject: [PATCH] iio: trigger: Don't use RT priority
Date:   Wed, 9 Sep 2020 18:22:16 +0200
Message-ID: <20200909162216.13765-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.16]
X-RMX-ID: 20200909-182224-4BmnNc1mPXz2TSDs-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Triggers may raise transactions on slow busses like I2C.  Using the
original RT priority of a threaded IRQ may prevent other important IRQ
handlers from being run.

In my particular case (on a RT kernel), the RT priority of the sysfstrig
threaded IRQ handler caused (temporarily) raising the prio of a user
space process which was holding the I2C bus mutex.

Although this process did nothing more than blocking on i2c-dev ioctl(),
no other threaded IRQ handlers (like DMA) were switched in during this
time.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
 drivers/iio/industrialio-trigger.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
index 6f16357fd732..b74180293da2 100644
--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -9,8 +9,12 @@
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
+#include <uapi/linux/sched/types.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/trigger.h>
@@ -245,6 +249,8 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
 	int ret = 0;
 	bool notinuse
 		= bitmap_empty(trig->pool, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+	struct sched_param sched_param = { .sched_priority = 0 };
+	struct irq_desc *irq_desc;
 
 	/* Prevent the module from being removed whilst attached to a trigger */
 	__module_get(pf->indio_dev->driver_module);
@@ -264,6 +270,12 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
 	if (ret < 0)
 		goto out_put_irq;
 
+	/* Triggers may raise transactions on slow busses like I2C.  Using the original RT priority
+	 * of a threaded IRQ may prevent other threaded IRQ handlers from being run.
+	 */
+	irq_desc = irq_to_desc(pf->irq);
+	sched_setscheduler_nocheck(irq_desc->action->thread, SCHED_NORMAL, &sched_param);
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

