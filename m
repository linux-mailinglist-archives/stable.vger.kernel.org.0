Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5AD88E6D
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfHJUyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53786 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-00052u-O7; Sat, 10 Aug 2019 21:43:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003Xu-Ev; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ludovic Desroches" <ludovic.desroches@microchip.com>,
        "Georg Ottinger" <g.ottinger@abatec.at>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.533012668@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 006/157] iio: adc: at91: disable adc channel
 interrupt in timeout case
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Ottinger <g.ottinger@abatec.at>

commit 09c6bdee51183a575bf7546890c8c137a75a2b44 upstream.

Having a brief look at at91_adc_read_raw() it is obvious that in the case
of a timeout the setting of AT91_ADC_CHDR and AT91_ADC_IDR registers is
omitted. If 2 different channels are queried we can end up with a
situation where two interrupts are enabled, but only one interrupt is
cleared in the interrupt handler. Resulting in a interrupt loop and a
system hang.

Signed-off-by: Georg Ottinger <g.ottinger@abatec.at>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iio/adc/at91_adc.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -702,23 +702,29 @@ static int at91_adc_read_raw(struct iio_
 		ret = wait_event_interruptible_timeout(st->wq_data_avail,
 						       st->done,
 						       msecs_to_jiffies(1000));
-		if (ret == 0)
-			ret = -ETIMEDOUT;
-		if (ret < 0) {
-			mutex_unlock(&st->lock);
-			return ret;
-		}
-
-		*val = st->last_value;
 
+		/* Disable interrupts, regardless if adc conversion was
+		 * successful or not
+		 */
 		at91_adc_writel(st, AT91_ADC_CHDR,
 				AT91_ADC_CH(chan->channel));
 		at91_adc_writel(st, AT91_ADC_IDR, BIT(chan->channel));
 
-		st->last_value = 0;
-		st->done = false;
+		if (ret > 0) {
+			/* a valid conversion took place */
+			*val = st->last_value;
+			st->last_value = 0;
+			st->done = false;
+			ret = IIO_VAL_INT;
+		} else if (ret == 0) {
+			/* conversion timeout */
+			dev_err(&idev->dev, "ADC Channel %d timeout.\n",
+				chan->channel);
+			ret = -ETIMEDOUT;
+		}
+
 		mutex_unlock(&st->lock);
-		return IIO_VAL_INT;
+		return ret;
 
 	case IIO_CHAN_INFO_SCALE:
 		*val = st->vref_mv;

