Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA10CD2621
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387813AbfJJJUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJUU (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E79A21D7B;
        Thu, 10 Oct 2019 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699219;
        bh=7kyqtd1ZpG1jppKgJEY1RTSH0/DHkJq/p5pgsoY9vfI=;
        h=Subject:To:From:Date:From;
        b=Is1PVzNwHgyoj586//TIwtQOFCbVGS4B6Kjarqh45BWGv7ExxFJV+OoGXrTQj5p1d
         LwBNINFxE8c5FNl9AcV5fB28DzEELv5gWWH3sC2r4RsWgG7tkHu+R6fuwVkkHQwcHq
         pUeL3ptA2ox+VjuICSKqLJlEgmwlaKdtmXeTVioQ=
Subject: patch "iio: adc: hx711: fix bug in sampling of data" added to staging-linus
To:     ak@it-klinger.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:04 +0200
Message-ID: <157069920481203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: hx711: fix bug in sampling of data

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4043ecfb5fc4355a090111e14faf7945ff0fdbd5 Mon Sep 17 00:00:00 2001
From: Andreas Klinger <ak@it-klinger.de>
Date: Mon, 9 Sep 2019 14:37:21 +0200
Subject: iio: adc: hx711: fix bug in sampling of data

Fix bug in sampling function hx711_cycle() when interrupt occures while
PD_SCK is high. If PD_SCK is high for at least 60 us power down mode of
the sensor is entered which in turn leads to a wrong measurement.

Switch off interrupts during a PD_SCK high period and move query of DOUT
to the latest point of time which is at the end of PD_SCK low period.

This bug exists in the driver since it's initial addition. The more
interrupts on the system the higher is the probability that it happens.

Fixes: c3b2fdd0ea7e ("iio: adc: hx711: Add IIO driver for AVIA HX711")
Signed-off-by: Andreas Klinger <ak@it-klinger.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/hx711.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/hx711.c b/drivers/iio/adc/hx711.c
index 88c7fe15003b..62e6c8badd22 100644
--- a/drivers/iio/adc/hx711.c
+++ b/drivers/iio/adc/hx711.c
@@ -100,14 +100,14 @@ struct hx711_data {
 
 static int hx711_cycle(struct hx711_data *hx711_data)
 {
-	int val;
+	unsigned long flags;
 
 	/*
 	 * if preempted for more then 60us while PD_SCK is high:
 	 * hx711 is going in reset
 	 * ==> measuring is false
 	 */
-	preempt_disable();
+	local_irq_save(flags);
 	gpiod_set_value(hx711_data->gpiod_pd_sck, 1);
 
 	/*
@@ -117,7 +117,6 @@ static int hx711_cycle(struct hx711_data *hx711_data)
 	 */
 	ndelay(hx711_data->data_ready_delay_ns);
 
-	val = gpiod_get_value(hx711_data->gpiod_dout);
 	/*
 	 * here we are not waiting for 0.2 us as suggested by the datasheet,
 	 * because the oscilloscope showed in a test scenario
@@ -125,7 +124,7 @@ static int hx711_cycle(struct hx711_data *hx711_data)
 	 * and 0.56 us for PD_SCK low on TI Sitara with 800 MHz
 	 */
 	gpiod_set_value(hx711_data->gpiod_pd_sck, 0);
-	preempt_enable();
+	local_irq_restore(flags);
 
 	/*
 	 * make it a square wave for addressing cases with capacitance on
@@ -133,7 +132,8 @@ static int hx711_cycle(struct hx711_data *hx711_data)
 	 */
 	ndelay(hx711_data->data_ready_delay_ns);
 
-	return val;
+	/* sample as late as possible */
+	return gpiod_get_value(hx711_data->gpiod_dout);
 }
 
 static int hx711_read(struct hx711_data *hx711_data)
-- 
2.23.0


