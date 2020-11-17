Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F342B5C3B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgKQJwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbgKQJwe (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:52:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C7022168B;
        Tue, 17 Nov 2020 09:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605606752;
        bh=8I5Njg12rcmR1A2osEhMzKrScOCDj+jYC9O2fhx2EEo=;
        h=Subject:To:From:Date:From;
        b=NnQTclS2+Y2AaItAAFqjhpTKmzTZxsh6N4ZB7Er2iqwVRQEiBigoIiczNkb1gv+Gc
         DGe3bb8egmBKNylKJu3MU6mvUsyOHVu9VSWwxHf7+vIe2tKzOrD/9Rx+gTFHsEW8hn
         mm2XqPMljmNr/Yp5aTOMOmTN7s8g689hBnD9zij4=
Subject: patch "iio: cros_ec: Use default frequencies when EC returns invalid" added to staging-linus
To:     gwendal@chromium.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, enric.balletbo@collabora.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 10:53:20 +0100
Message-ID: <1605606800204190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: cros_ec: Use default frequencies when EC returns invalid

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 56e4f2dda23c6d39d327944faa89efaa4eb290d1 Mon Sep 17 00:00:00 2001
From: Gwendal Grignou <gwendal@chromium.org>
Date: Tue, 30 Jun 2020 08:37:30 -0700
Subject: iio: cros_ec: Use default frequencies when EC returns invalid
 information

Minimal and maximal frequencies supported by a sensor is queried.
On some older machines, these frequencies are not returned properly and
the EC returns 0 instead.
When returned maximal frequency is 0, ignore the information and use
default frequencies instead.

Fixes: ae7b02ad2f32 ("iio: common: cros_ec_sensors: Expose cros_ec_sensors frequency range via iio sysfs")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20200630153730.3302889-1-gwendal@chromium.org
CC: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 .../cros_ec_sensors/cros_ec_sensors_core.c       | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
index c62cacc04672..e3f507771f17 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -256,7 +256,7 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 	struct cros_ec_sensorhub *sensor_hub = dev_get_drvdata(dev->parent);
 	struct cros_ec_dev *ec = sensor_hub->ec;
 	struct cros_ec_sensor_platform *sensor_platform = dev_get_platdata(dev);
-	u32 ver_mask;
+	u32 ver_mask, temp;
 	int frequencies[ARRAY_SIZE(state->frequencies) / 2] = { 0 };
 	int ret, i;
 
@@ -311,10 +311,16 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 						 &frequencies[2],
 						 &state->fifo_max_event_count);
 		} else {
-			frequencies[1] = state->resp->info_3.min_frequency;
-			frequencies[2] = state->resp->info_3.max_frequency;
-			state->fifo_max_event_count =
-			    state->resp->info_3.fifo_max_event_count;
+			if (state->resp->info_3.max_frequency == 0) {
+				get_default_min_max_freq(state->resp->info.type,
+							 &frequencies[1],
+							 &frequencies[2],
+							 &temp);
+			} else {
+				frequencies[1] = state->resp->info_3.min_frequency;
+				frequencies[2] = state->resp->info_3.max_frequency;
+			}
+			state->fifo_max_event_count = state->resp->info_3.fifo_max_event_count;
 		}
 		for (i = 0; i < ARRAY_SIZE(frequencies); i++) {
 			state->frequencies[2 * i] = frequencies[i] / 1000;
-- 
2.29.2


