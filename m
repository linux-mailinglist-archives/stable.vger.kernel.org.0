Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D99127DF0
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfLTOhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbfLTOaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50AB1222C2;
        Fri, 20 Dec 2019 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852214;
        bh=jXaBrwxDSZhgZNcbKWjnrjwga5EW9gYMOJk+FGczBG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0d8tDXzbv1h9AFX4PSNWahnXLDAdGHCSeOFqvs0b9+K1ZScVH82hkfHC31/MqP+V
         tZtJ0ij5zNXkwUo83dXnn8VTlWJBCbTO+Vk84nEjqJyWjtDM49YEPA+FOP46PbFxxW
         EvGjLmqZmA2VHWc4MIbaOl4ZvhP8/MGcqIk63Qas=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/52] iio: st_accel: Fix unused variable warning
Date:   Fri, 20 Dec 2019 09:29:16 -0500
Message-Id: <20191220142954.9500-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0163c1c521ff8b09cd8ca395003cc00178161d77 ]

drivers/iio/accel/st_accel_core.c:1005:44: warning:
 mount_matrix_ext_info defined but not used [-Wunused-const-variable=]

Using stub helper while CONFIG_ACPI is disabled to fix it.

Suggested-by: Ladislav Michl <ladis@linux-mips.org>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/st_accel_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/st_accel_core.c b/drivers/iio/accel/st_accel_core.c
index 2e37f8a6d8cfc..be661396095ce 100644
--- a/drivers/iio/accel/st_accel_core.c
+++ b/drivers/iio/accel/st_accel_core.c
@@ -993,6 +993,7 @@ static const struct iio_trigger_ops st_accel_trigger_ops = {
 #define ST_ACCEL_TRIGGER_OPS NULL
 #endif
 
+#ifdef CONFIG_ACPI
 static const struct iio_mount_matrix *
 get_mount_matrix(const struct iio_dev *indio_dev,
 		 const struct iio_chan_spec *chan)
@@ -1013,7 +1014,6 @@ static const struct iio_chan_spec_ext_info mount_matrix_ext_info[] = {
 static int apply_acpi_orientation(struct iio_dev *indio_dev,
 				  struct iio_chan_spec *channels)
 {
-#ifdef CONFIG_ACPI
 	struct st_sensor_data *adata = iio_priv(indio_dev);
 	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
 	struct acpi_device *adev;
@@ -1141,10 +1141,14 @@ static int apply_acpi_orientation(struct iio_dev *indio_dev,
 out:
 	kfree(buffer.pointer);
 	return ret;
+}
 #else /* !CONFIG_ACPI */
+static int apply_acpi_orientation(struct iio_dev *indio_dev,
+				  struct iio_chan_spec *channels)
+{
 	return 0;
-#endif
 }
+#endif
 
 /*
  * st_accel_get_settings() - get sensor settings from device name
-- 
2.20.1

