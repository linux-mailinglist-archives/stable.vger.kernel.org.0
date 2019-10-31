Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2A4EB4ED
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 17:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfJaQo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 12:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbfJaQo0 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 31 Oct 2019 12:44:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C54A420873;
        Thu, 31 Oct 2019 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572540265;
        bh=MuiSMfYiw9dn1Bwi6Oc3CqfBuFOn3aOLlOIMGK7dQGU=;
        h=Subject:To:From:Date:From;
        b=tbCLZtV12dLIqM7et7pq7IX0xjvOh+I5pBzCl/kZIcZ7KYDlbAM6UPCn/DSa5bcGA
         QbZQFyKMBzNJhZ2zLpSvKqn4zqPjkAvMpa4ryo2SL4De9stFHKrjZTWqX/qY82X0Xz
         a53a447BMBKla5q6WflC5pVHuLuqHPnRdAuERLJE=
Subject: patch "iio: srf04: fix wrong limitation in distance measuring" added to staging-linus
To:     ak@it-klinger.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, zbynek.kocur@fel.cvut.cz
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 31 Oct 2019 17:44:14 +0100
Message-ID: <157254025422163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: srf04: fix wrong limitation in distance measuring

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 431f7667bd6889a274913162dfd19cce9d84848e Mon Sep 17 00:00:00 2001
From: Andreas Klinger <ak@it-klinger.de>
Date: Sun, 6 Oct 2019 16:29:56 +0200
Subject: iio: srf04: fix wrong limitation in distance measuring
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 drivers/iio/proximity/srf04.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/iio/proximity/srf04.c b/drivers/iio/proximity/srf04.c
index 8b50d56b0a03..01eb8cc63076 100644
--- a/drivers/iio/proximity/srf04.c
+++ b/drivers/iio/proximity/srf04.c
@@ -110,7 +110,7 @@ static int srf04_read(struct srf04_data *data)
 	udelay(data->cfg->trigger_pulse_us);
 	gpiod_set_value(data->gpiod_trig, 0);
 
-	/* it cannot take more than 20 ms */
+	/* it should not take more than 20 ms until echo is rising */
 	ret = wait_for_completion_killable_timeout(&data->rising, HZ/50);
 	if (ret < 0) {
 		mutex_unlock(&data->lock);
@@ -120,7 +120,8 @@ static int srf04_read(struct srf04_data *data)
 		return -ETIMEDOUT;
 	}
 
-	ret = wait_for_completion_killable_timeout(&data->falling, HZ/50);
+	/* it cannot take more than 50 ms until echo is falling */
+	ret = wait_for_completion_killable_timeout(&data->falling, HZ/20);
 	if (ret < 0) {
 		mutex_unlock(&data->lock);
 		return ret;
@@ -135,19 +136,19 @@ static int srf04_read(struct srf04_data *data)
 
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
@@ -159,20 +160,20 @@ static int srf04_read(struct srf04_data *data)
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
-- 
2.23.0


