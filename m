Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70C11AC7FB
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390838AbgDPPCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898793AbgDPNyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5FDA20732;
        Thu, 16 Apr 2020 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045249;
        bh=qnKjeRFljIsmqkFccDcOzXGYVkd2gtcV3xBaAQ+3WqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PO55uwNR3wL0m17vha4JFGz5pk30l0QeS67hsI/2IHEbgxrnp/YQLKuTpuUAiBbm/
         lHBxVpv4hf1TdpQRE92133M0NHVX+IodFaNXhrdwJUAnMPFrIyu6pE+Vf2SPaZQLM8
         Lja/+SqMOPy8Bd22wRCPNErcf/vP/V/ny+vO3PPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 016/254] iio: imu: st_lsm6dsx: check return value from st_lsm6dsx_sensor_set_enable
Date:   Thu, 16 Apr 2020 15:21:45 +0200
Message-Id: <20200416131327.850290960@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit f20dbe11e2e904547597ae7371c1f635e3be9cad ]

Add missing return value check in st_lsm6dsx_shub_read_oneshot disabling
the slave device connected to the st_lsm6dsx i2c controller.
The issue is reported by coverity with the following error:

Unchecked return value:
If the function returns an error value, the error value may be mistaken
for a normal value.

Addresses-Coverity-ID: 1456767 ("Unchecked return value")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
index eea555617d4aa..95ddd19d1aa7c 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -464,9 +464,10 @@ st_lsm6dsx_shub_read_oneshot(struct st_lsm6dsx_sensor *sensor,
 
 	len = min_t(int, sizeof(data), ch->scan_type.realbits >> 3);
 	err = st_lsm6dsx_shub_read(sensor, ch->address, data, len);
+	if (err < 0)
+		return err;
 
-	st_lsm6dsx_shub_set_enable(sensor, false);
-
+	err = st_lsm6dsx_shub_set_enable(sensor, false);
 	if (err < 0)
 		return err;
 
-- 
2.20.1



