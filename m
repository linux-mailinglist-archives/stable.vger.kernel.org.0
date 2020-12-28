Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C92E3CDA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391713AbgL1OH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438530AbgL1OHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 848F4207B7;
        Mon, 28 Dec 2020 14:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164430;
        bh=pgtsrClJizQ/wQVo0vnfVl3kWNHgUMZD0StS8Qa/PH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/RCT6kIrgDcZxFuXfLHsNa9aCDQAvLhjhx3u7cux9BBlycJY1VsljomNPVV8pTCE
         BHDKSMUKxMeMA/wzZe9KYMyiJirfpQLx/Czs93ONGHCrhMUJDWAV6AxP68d0OMycsE
         v9EulYvtk5LfFmiVTfkPYsgwFgQvZYsGn0MK/1Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jander <david@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/717] Input: ads7846 - fix race that causes missing releases
Date:   Mon, 28 Dec 2020 13:42:25 +0100
Message-Id: <20201228125028.006095142@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Jander <david@protonic.nl>

[ Upstream commit e52cd628a03f72a547dbf90ccb703ee64800504a ]

If touchscreen is released while busy reading HWMON device, the release
can be missed. The IRQ thread is not started because no touch is active
and BTN_TOUCH release event is never sent.

Fixes: f5a28a7d4858f94a ("Input: ads7846 - avoid pen up/down when reading hwmon")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20201027105416.18773-1-o.rempel@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 44 +++++++++++++++++------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 8fd7fc39c4fd7..69992d5e53118 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -199,6 +199,26 @@ struct ads7846 {
 #define	REF_ON	(READ_12BIT_DFR(x, 1, 1))
 #define	REF_OFF	(READ_12BIT_DFR(y, 0, 0))
 
+static int get_pendown_state(struct ads7846 *ts)
+{
+	if (ts->get_pendown_state)
+		return ts->get_pendown_state();
+
+	return !gpio_get_value(ts->gpio_pendown);
+}
+
+static void ads7846_report_pen_up(struct ads7846 *ts)
+{
+	struct input_dev *input = ts->input;
+
+	input_report_key(input, BTN_TOUCH, 0);
+	input_report_abs(input, ABS_PRESSURE, 0);
+	input_sync(input);
+
+	ts->pendown = false;
+	dev_vdbg(&ts->spi->dev, "UP\n");
+}
+
 /* Must be called with ts->lock held */
 static void ads7846_stop(struct ads7846 *ts)
 {
@@ -215,6 +235,10 @@ static void ads7846_stop(struct ads7846 *ts)
 static void ads7846_restart(struct ads7846 *ts)
 {
 	if (!ts->disabled && !ts->suspended) {
+		/* Check if pen was released since last stop */
+		if (ts->pendown && !get_pendown_state(ts))
+			ads7846_report_pen_up(ts);
+
 		/* Tell IRQ thread that it may poll the device. */
 		ts->stopped = false;
 		mb();
@@ -606,14 +630,6 @@ static const struct attribute_group ads784x_attr_group = {
 
 /*--------------------------------------------------------------------------*/
 
-static int get_pendown_state(struct ads7846 *ts)
-{
-	if (ts->get_pendown_state)
-		return ts->get_pendown_state();
-
-	return !gpio_get_value(ts->gpio_pendown);
-}
-
 static void null_wait_for_sync(void)
 {
 }
@@ -868,16 +884,8 @@ static irqreturn_t ads7846_irq(int irq, void *handle)
 				   msecs_to_jiffies(TS_POLL_PERIOD));
 	}
 
-	if (ts->pendown && !ts->stopped) {
-		struct input_dev *input = ts->input;
-
-		input_report_key(input, BTN_TOUCH, 0);
-		input_report_abs(input, ABS_PRESSURE, 0);
-		input_sync(input);
-
-		ts->pendown = false;
-		dev_vdbg(&ts->spi->dev, "UP\n");
-	}
+	if (ts->pendown && !ts->stopped)
+		ads7846_report_pen_up(ts);
 
 	return IRQ_HANDLED;
 }
-- 
2.27.0



