Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09001334C0
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgAGU5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbgAGU5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:57:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40420214D8;
        Tue,  7 Jan 2020 20:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430630;
        bh=TcsprVe1IdveFCzA/IRQMOseJaWh4UkmVgXoo9tnPXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1pM9kskZPzuCzrtTFWTdYRnwTgTyhYvJJu2+ktKCSEgc7jQeNBDuUex/qR9rkK2u
         66JKWWyLCBKgQBTgPn7llZy0E1vSy4xUCfHxgd12BruxqZKxfU1zAPx/kN9cOrsc23
         iPyQ4xx4VfIavmBfSWBSRw5oete3KEufv8qeha9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ladislav Michl <ladis@linux-mips.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/191] iio: st_accel: Fix unused variable warning
Date:   Tue,  7 Jan 2020 21:52:14 +0100
Message-Id: <20200107205333.770282694@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2e37f8a6d8cf..be661396095c 100644
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



