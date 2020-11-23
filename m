Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328432C08EB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbgKWNDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387647AbgKWMvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D83D1204EF;
        Mon, 23 Nov 2020 12:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135905;
        bh=S7zmh5aV0FU9niFOr+iYpFRN/m+bkJ4/VR93e5GqSbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUQu5Oueuj+7KF1fQVxbdEi0uHSrDr8yFTj1Hy7vr6hFoMvNYU9EofTIBstk4rmW8
         c+cyzZiKgZu3XJ0RREURBjzIaT8GiKQXgH/Z8t8mldCFW1PDbAlKwnsNQbv6+QFqee
         1cfAs6Z4gC9KEfQZ+UyP1/J7wG2PN0eTdb6Yt0JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 211/252] iio: cros_ec: Use default frequencies when EC returns invalid information
Date:   Mon, 23 Nov 2020 13:22:41 +0100
Message-Id: <20201123121845.752483346@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit 56e4f2dda23c6d39d327944faa89efaa4eb290d1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c |   16 +++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -255,7 +255,7 @@ int cros_ec_sensors_core_init(struct pla
 	struct cros_ec_sensorhub *sensor_hub = dev_get_drvdata(dev->parent);
 	struct cros_ec_dev *ec = sensor_hub->ec;
 	struct cros_ec_sensor_platform *sensor_platform = dev_get_platdata(dev);
-	u32 ver_mask;
+	u32 ver_mask, temp;
 	int frequencies[ARRAY_SIZE(state->frequencies) / 2] = { 0 };
 	int ret, i;
 
@@ -310,10 +310,16 @@ int cros_ec_sensors_core_init(struct pla
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


