Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C7926B444
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgIOXUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbgIOOiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6028A23C86;
        Tue, 15 Sep 2020 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180106;
        bh=WyPRPDDMhDNd364LL+v4oD/VM27iV+qS5w6Qty5f96w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAv8g96Vel1CS6avozAOmiEk+XlcFos29vqF01ov0VdQ7VMcUAxjuhF4R8NoFCItU
         V5cnKMkFTNlRJXcj/Jc6idijnOQV6e9fmRYnHROAZb+MvP7mShuJLroSUbWcZ/aQxS
         LMDg+5pPaPETP58sck67QlDQ0I8nCoN3RiAriPeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.8 111/177] iio: cros_ec: Set Gyroscope default frequency to 25Hz
Date:   Tue, 15 Sep 2020 16:13:02 +0200
Message-Id: <20200915140658.968463694@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit 336306790b2bbf7ce837625fa3b24ba724d05838 upstream.

BMI160 Minimium gyroscope frequency in normal mode is 25Hz.
When older EC firmware do not report their sensors frequencies,
use 25Hz as the minimum for gyroscope to be sure it works on BMI160.

Fixes: ae7b02ad2f32d ("iio: common: cros_ec_sensors: Expose cros_ec_sensors frequency range via iio sysfs")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -72,10 +72,13 @@ static void get_default_min_max_freq(enu
 
 	switch (type) {
 	case MOTIONSENSE_TYPE_ACCEL:
-	case MOTIONSENSE_TYPE_GYRO:
 		*min_freq = 12500;
 		*max_freq = 100000;
 		break;
+	case MOTIONSENSE_TYPE_GYRO:
+		*min_freq = 25000;
+		*max_freq = 100000;
+		break;
 	case MOTIONSENSE_TYPE_MAG:
 		*min_freq = 5000;
 		*max_freq = 25000;


