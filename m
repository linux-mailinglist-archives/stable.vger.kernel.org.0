Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563554991CA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345501AbiAXUO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:14:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39412 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379764AbiAXUMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:12:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB57A6091A;
        Mon, 24 Jan 2022 20:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94A1C340E5;
        Mon, 24 Jan 2022 20:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055144;
        bh=l+gtYq5zMqIJC9T7FFg/WoG6gd4YYnKZA2mw7RhH/1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQ2unch9TiZcLbJoE1EFFSRp/D8blHkfBJ+OgQa5BEJZf41ykkWWE0KEaFDYhmwm3
         AY7JBY8bL6DLNuRwSh+e5ukqIFrIVr0YezjR+QCZl8fiID6CgteoBcJsDbhh7Eyhyt
         HMbPncvnf7EsUYs48e1uXa60Ucbc1VpOmbAasUOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Stable@vger.kernel.org
Subject: [PATCH 5.15 056/846] iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046
Date:   Mon, 24 Jan 2022 19:32:53 +0100
Message-Id: <20220124184102.903148761@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 9020ef659885f2622cfb386cc229b6d618362895 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |   36 +++++++++++++++++++++++++++++++++++-
 include/linux/iio/trigger.h        |    2 ++
 2 files changed, 37 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -162,6 +162,39 @@ static struct iio_trigger *iio_trigger_a
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
@@ -173,7 +206,7 @@ void iio_trigger_poll(struct iio_trigger
 			if (trig->subirqs[i].enabled)
 				generic_handle_irq(trig->subirq_base + i);
 			else
-				iio_trigger_notify_done(trig);
+				iio_trigger_notify_done_atomic(trig);
 		}
 	}
 }
@@ -535,6 +568,7 @@ struct iio_trigger *viio_trigger_alloc(s
 	trig->dev.type = &iio_trig_type;
 	trig->dev.bus = &iio_bus_type;
 	device_initialize(&trig->dev);
+	INIT_WORK(&trig->reenable_work, iio_reenable_work_fn);
 
 	mutex_init(&trig->pool_lock);
 	trig->subirq_base = irq_alloc_descs(-1, 0,
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
 
 


