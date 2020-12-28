Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD12E65E5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392960AbgL1QGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389506AbgL1N0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BAF22072C;
        Mon, 28 Dec 2020 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161980;
        bh=JMp0wial69jrL6aFyW+zOQgg+WkIMrPu8HjSfNA2Cf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bE7pYMZmUXaJN2XFTVmtBYSSCppBYM9WeBhBnz+/l317U3BtS2wnhj4ZSCbv/A+ak
         lZJJaMJ5lBH/hyI5JhQUxf1izG0RO1Bp6g6aXJ5YfHTLubrk3QXC7U+p8inyxE7wj3
         KVPZVC7NrroMELpnhZ0RrYBn0SYPsIdtjWDq+a/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jander <david@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/346] Input: ads7846 - fix race that causes missing releases
Date:   Mon, 28 Dec 2020 13:47:46 +0100
Message-Id: <20201228124926.896197443@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index a2f45aefce08a..0fbad337e45a3 100644
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
@@ -605,14 +629,6 @@ static const struct attribute_group ads784x_attr_group = {
 
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
@@ -871,16 +887,8 @@ static irqreturn_t ads7846_irq(int irq, void *handle)
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



