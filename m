Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB84F47D175
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbhLVMFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:05:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50566 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhLVMFx (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 22 Dec 2021 07:05:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DBA1B81C01
        for <Stable@vger.kernel.org>; Wed, 22 Dec 2021 12:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DF0C36AEA;
        Wed, 22 Dec 2021 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640174751;
        bh=PgDFnPgaL6HjLNUTmc0Ex4wMBjQFu/Q1bqscoV/UUeE=;
        h=Subject:To:From:Date:From;
        b=vHnKEpEV957eh0GQwYVzy73BSyRl6d2b05p0PSRz2BKm7MRQEhNBGdWGSLPoHME3i
         nav5gIvhTsRSnsSF/iNvezVBy13W+V5CAqnQO3dYimULPHBjBqtBtgzTSArGMkE+c8
         n8hpN/xqTFY9L2GwN2o772Xc8BvUpTlnwa0mu9JA=
Subject: patch "iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046" added to char-misc-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        o.rempel@pengutronix.de
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 Dec 2021 12:51:45 +0100
Message-ID: <164017390569191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 9020ef659885f2622cfb386cc229b6d618362895 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 17 Oct 2021 18:22:09 +0100
Subject: iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046

IIO triggers are software IRQ chips that split an incoming IRQ into
separate IRQs routed to all devices using the trigger.
When all consumers are done then a trigger callback reenable() is
called.  There are a few circumstances under which this can happen
in atomic context.

1) A single user of the trigger that calls the iio_trigger_done()
function from interrupt context.
2) A race between disconnecting the last device from a trigger and
the trigger itself sucessfully being disabled.

To avoid a resulting scheduling whilst atomic, close this second corner
by using schedule_work() to ensure the reenable is not done in atomic
context.

Note that drivers must be careful to manage the interaction of
set_state() and reenable() callbacks to ensure appropriate reference
counting if they are relying on the same hardware controls.

Deliberately taking this the slow path rather than via a fixes tree
because the error has hard to hit and I would like it to soak for a while
before hitting a release kernel.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211017172209.112387-1-jic23@kernel.org
---
 drivers/iio/industrialio-trigger.c | 36 +++++++++++++++++++++++++++++-
 include/linux/iio/trigger.h        |  2 ++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
index b23caa2f2aa1..d3bdc9800b4a 100644
--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -162,6 +162,39 @@ static struct iio_trigger *iio_trigger_acquire_by_name(const char *name)
 	return trig;
 }
 
+static void iio_reenable_work_fn(struct work_struct *work)
+{
+	struct iio_trigger *trig = container_of(work, struct iio_trigger,
+						reenable_work);
+
+	/*
+	 * This 'might' occur after the trigger state is set to disabled -
+	 * in that case the driver should skip reenabling.
+	 */
+	trig->ops->reenable(trig);
+}
+
+/*
+ * In general, reenable callbacks may need to sleep and this path is
+ * not performance sensitive, so just queue up a work item
+ * to reneable the trigger for us.
+ *
+ * Races that can cause this.
+ * 1) A handler occurs entirely in interrupt context so the counter
+ *    the final decrement is still in this interrupt.
+ * 2) The trigger has been removed, but one last interrupt gets through.
+ *
+ * For (1) we must call reenable, but not in atomic context.
+ * For (2) it should be safe to call reenanble, if drivers never blindly
+ * reenable after state is off.
+ */
+static void iio_trigger_notify_done_atomic(struct iio_trigger *trig)
+{
+	if (atomic_dec_and_test(&trig->use_count) && trig->ops &&
+	    trig->ops->reenable)
+		schedule_work(&trig->reenable_work);
+}
+
 void iio_trigger_poll(struct iio_trigger *trig)
 {
 	int i;
@@ -173,7 +206,7 @@ void iio_trigger_poll(struct iio_trigger *trig)
 			if (trig->subirqs[i].enabled)
 				generic_handle_irq(trig->subirq_base + i);
 			else
-				iio_trigger_notify_done(trig);
+				iio_trigger_notify_done_atomic(trig);
 		}
 	}
 }
@@ -535,6 +568,7 @@ struct iio_trigger *viio_trigger_alloc(struct device *parent,
 	trig->dev.type = &iio_trig_type;
 	trig->dev.bus = &iio_bus_type;
 	device_initialize(&trig->dev);
+	INIT_WORK(&trig->reenable_work, iio_reenable_work_fn);
 
 	mutex_init(&trig->pool_lock);
 	trig->subirq_base = irq_alloc_descs(-1, 0,
diff --git a/include/linux/iio/trigger.h b/include/linux/iio/trigger.h
index 096f68dd2e0c..4c69b144677b 100644
--- a/include/linux/iio/trigger.h
+++ b/include/linux/iio/trigger.h
@@ -55,6 +55,7 @@ struct iio_trigger_ops {
  * @attached_own_device:[INTERN] if we are using our own device as trigger,
  *			i.e. if we registered a poll function to the same
  *			device as the one providing the trigger.
+ * @reenable_work:	[INTERN] work item used to ensure reenable can sleep.
  **/
 struct iio_trigger {
 	const struct iio_trigger_ops	*ops;
@@ -74,6 +75,7 @@ struct iio_trigger {
 	unsigned long pool[BITS_TO_LONGS(CONFIG_IIO_CONSUMERS_PER_TRIGGER)];
 	struct mutex			pool_lock;
 	bool				attached_own_device;
+	struct work_struct		reenable_work;
 };
 
 
-- 
2.34.1


