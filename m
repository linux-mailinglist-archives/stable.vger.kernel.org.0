Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C443C5522
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353456AbhGLIJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352868AbhGLIAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB2661A19;
        Mon, 12 Jul 2021 07:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076421;
        bh=oWIVEfJisgjGA/Uk2e+BIdHRCJdQ8T7qzbJPpW+JC2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKMoqk/Mqjmxsocg19gxsd5WkKy2k4VijTBN/6GktDgPd/o2U6qobhMyUUC4WmHNL
         KF0RDbm5M0VSdCXmJzzUs3ZRAzH2tsHTKbONSlrIcz2BNgxsnRKysuan+Y0pPx+wpV
         KKPcfYxyd6r6sQYsUmwtxHuQnv9LIEz9wmfjaibI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 636/800] iio: cros_ec_sensors: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:59 +0200
Message-Id: <20210712061034.794414373@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 8dea228b174ac9637b567e5ef54f4c40db4b3c41 ]

The samples buffer is passed to iio_push_to_buffers_with_timestamp()
which requires a buffer aligned to 8 bytes as it is assumed that
the timestamp will be naturally aligned if present.

Fixes tag is inaccurate but prior to that likely manual backporting needed
(for anything before 4.18) Earlier than that the include file to fix is
drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.h:
commit 974e6f02e27 ("iio: cros_ec_sensors_core: Add common functions
for the ChromeOS EC Sensor Hub.") present since kernel stable 4.10.
(Thanks to Gwendal for tracking this down)

Fixes: 5a0b8cb46624c ("iio: cros_ec: Move cros_ec_sensors_core.h in /include")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org
Link: https://lore.kernel.org/r/20210501171352.512953-7-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iio/common/cros_ec_sensors_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iio/common/cros_ec_sensors_core.h b/include/linux/iio/common/cros_ec_sensors_core.h
index 7ce8a8adad58..c582e1a14232 100644
--- a/include/linux/iio/common/cros_ec_sensors_core.h
+++ b/include/linux/iio/common/cros_ec_sensors_core.h
@@ -77,7 +77,7 @@ struct cros_ec_sensors_core_state {
 		u16 scale;
 	} calib[CROS_EC_SENSOR_MAX_AXIS];
 	s8 sign[CROS_EC_SENSOR_MAX_AXIS];
-	u8 samples[CROS_EC_SAMPLE_SIZE];
+	u8 samples[CROS_EC_SAMPLE_SIZE] __aligned(8);
 
 	int (*read_ec_sensors_data)(struct iio_dev *indio_dev,
 				    unsigned long scan_mask, s16 *data);
-- 
2.30.2



