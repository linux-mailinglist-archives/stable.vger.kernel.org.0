Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E52526B66D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgIPAEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbgIOO3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:29:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5C12229EF;
        Tue, 15 Sep 2020 14:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179679;
        bh=lUSrtxYjJUxOVUSQgeAUqJGiNIU5YCTf8mKLkrJaroE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L05fT0n9tAgSWrSN6RL2dvRiFVkuzZ7tzqtogbIMBt6hik3SCu99LtviXIXabfe63
         ipI7lwFW0COZHhByVIswf/FL9QTeE8lB/S1Djb68nJbpjPKgcmEsMIiE1TwrrpcEef
         41CBf1Ucq/X6VJW/QBHPwsxjHHSAydWuNj0NQ2kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 076/132] iio: cros_ec: Set Gyroscope default frequency to 25Hz
Date:   Tue, 15 Sep 2020 16:12:58 +0200
Message-Id: <20200915140647.909531729@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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
@@ -57,10 +57,13 @@ static void get_default_min_max_freq(enu
 {
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


