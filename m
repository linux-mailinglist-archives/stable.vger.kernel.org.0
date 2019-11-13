Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF72FAFB1
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 12:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfKML1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 06:27:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfKML1m (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 13 Nov 2019 06:27:42 -0500
Received: from localhost (unknown [61.58.47.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A830B2245A;
        Wed, 13 Nov 2019 11:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573644462;
        bh=bGnNbsGxNsIeJlHg+ZC1MBj2ycTeEoX1iTgFP0a+zrI=;
        h=Subject:To:From:Date:From;
        b=b8k2dmcQRRD67ptzfnELyYp4h94RiSPlMWKrq/fGFXUi/Pz15oCUti5hEJ6Bo+Ivu
         6ILHIdYnO7PMWG48CirNCFwLEcEZhlAKL8+RWn+ce12Eb60iujYOsDv/l+O3EMKAqf
         +O7Jq05NcF+sHxRpJT8muPVDhKIS18CqKKRurHX4=
Subject: patch "iio: adis16480: Add debugfs_reg_access entry" added to staging-testing
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 13 Nov 2019 19:26:08 +0800
Message-ID: <1573644368150169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adis16480: Add debugfs_reg_access entry

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4c35b7a51e2f291471f7221d112c6a45c63e83bc Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Mon, 28 Oct 2019 17:33:49 +0100
Subject: iio: adis16480: Add debugfs_reg_access entry
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The driver is defining debugfs entries by calling
`adis16480_debugfs_init()`. However, those entries are attached to the
iio_dev debugfs entry which won't exist if no debugfs_reg_access
callback is provided.

Fixes: 2f3abe6cbb6c ("iio:imu: Add support for the ADIS16480 and similar IMUs")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/adis16480.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index f1d52563951c..078d49deebd4 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -923,6 +923,7 @@ static const struct iio_info adis16480_info = {
 	.read_raw = &adis16480_read_raw,
 	.write_raw = &adis16480_write_raw,
 	.update_scan_mode = adis_update_scan_mode,
+	.debugfs_reg_access = adis_debugfs_reg_access,
 };
 
 static int adis16480_stop_device(struct iio_dev *indio_dev)
-- 
2.24.0


