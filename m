Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422D1F7E21
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfKKSub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730367AbfKKSua (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53800204FD;
        Mon, 11 Nov 2019 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498229;
        bh=IfH9tq6cL2VYhnjLG1DC36yApFqfu+QxjovjyIrrBio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Re/1U4ykr/DUJhz4M3Cw7SmpnT36BwH+AcOxT55dPCLwFbc0Rf7fYnknkffPVGaNU
         OXjlMFguiArFbpqiufcEtWnLP28S3nZdOn5N8J5ut/bvdRnPBqbEZ5N7u2FMSvMGRO
         0E9daRYuBe9QvOa00ExgXgz8r3/kKQtO96poMizM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Zbyn=C4=9Bk=20Kocur?= <zbynek.kocur@fel.cvut.cz>,
        Andreas Klinger <ak@it-klinger.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 059/193] iio: srf04: fix wrong limitation in distance measuring
Date:   Mon, 11 Nov 2019 19:27:21 +0100
Message-Id: <20191111181505.341643858@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Klinger <ak@it-klinger.de>

commit 431f7667bd6889a274913162dfd19cce9d84848e upstream.

The measured time value in the driver is limited to the maximum distance
which can be read by the sensor. This limitation was wrong and is fixed
by this patch.

It also takes into account that we are supporting a variety of sensors
today and that the recently added sensors have a higher maximum
distance range.

Changes in v2:
- Added a Tested-by

Suggested-by: Zbyněk Kocur <zbynek.kocur@fel.cvut.cz>
Tested-by: Zbyněk Kocur <zbynek.kocur@fel.cvut.cz>
Signed-off-by: Andreas Klinger <ak@it-klinger.de>
Cc:<Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/proximity/srf04.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/iio/proximity/srf04.c
+++ b/drivers/iio/proximity/srf04.c
@@ -110,7 +110,7 @@ static int srf04_read(struct srf04_data
 	udelay(data->cfg->trigger_pulse_us);
 	gpiod_set_value(data->gpiod_trig, 0);
 
-	/* it cannot take more than 20 ms */
+	/* it should not take more than 20 ms until echo is rising */
 	ret = wait_for_completion_killable_timeout(&data->rising, HZ/50);
 	if (ret < 0) {
 		mutex_unlock(&data->lock);
@@ -120,7 +120,8 @@ static int srf04_read(struct srf04_data
 		return -ETIMEDOUT;
 	}
 
-	ret = wait_for_completion_killable_timeout(&data->falling, HZ/50);
+	/* it cannot take more than 50 ms until echo is falling */
+	ret = wait_for_completion_killable_timeout(&data->falling, HZ/20);
 	if (ret < 0) {
 		mutex_unlock(&data->lock);
 		return ret;
@@ -135,19 +136,19 @@ static int srf04_read(struct srf04_data
 
 	dt_ns = ktime_to_ns(ktime_dt);
 	/*
-	 * measuring more than 3 meters is beyond the capabilities of
-	 * the sensor
+	 * measuring more than 6,45 meters is beyond the capabilities of
+	 * the supported sensors
 	 * ==> filter out invalid results for not measuring echos of
 	 *     another us sensor
 	 *
 	 * formula:
-	 *         distance       3 m
-	 * time = ---------- = --------- = 9404389 ns
-	 *          speed       319 m/s
+	 *         distance     6,45 * 2 m
+	 * time = ---------- = ------------ = 40438871 ns
+	 *          speed         319 m/s
 	 *
 	 * using a minimum speed at -20 °C of 319 m/s
 	 */
-	if (dt_ns > 9404389)
+	if (dt_ns > 40438871)
 		return -EIO;
 
 	time_ns = dt_ns;
@@ -159,20 +160,20 @@ static int srf04_read(struct srf04_data
 	 *   with Temp in °C
 	 *   and speed in m/s
 	 *
-	 * use 343 m/s as ultrasonic speed at 20 °C here in absence of the
+	 * use 343,5 m/s as ultrasonic speed at 20 °C here in absence of the
 	 * temperature
 	 *
 	 * therefore:
-	 *             time     343
-	 * distance = ------ * -----
-	 *             10^6       2
+	 *             time     343,5     time * 106
+	 * distance = ------ * ------- = ------------
+	 *             10^6         2         617176
 	 *   with time in ns
 	 *   and distance in mm (one way)
 	 *
-	 * because we limit to 3 meters the multiplication with 343 just
+	 * because we limit to 6,45 meters the multiplication with 106 just
 	 * fits into 32 bit
 	 */
-	distance_mm = time_ns * 343 / 2000000;
+	distance_mm = time_ns * 106 / 617176;
 
 	return distance_mm;
 }


