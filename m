Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA468156652
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgBHSds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:33:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34308 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727906AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003gC-8D; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CQ7-OH; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "=?UTF-8?q?Nuno=20S=C3=A1?=" <nuno.sa@analog.com>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>
Date:   Sat, 08 Feb 2020 18:20:22 +0000
Message-ID: <lsq.1581185940.73830083@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 083/148] iio: adis16480: Add debugfs_reg_access entry
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit 4c35b7a51e2f291471f7221d112c6a45c63e83bc upstream.

The driver is defining debugfs entries by calling
`adis16480_debugfs_init()`. However, those entries are attached to the
iio_dev debugfs entry which won't exist if no debugfs_reg_access
callback is provided.

Fixes: 2f3abe6cbb6c ("iio:imu: Add support for the ADIS16480 and similar IMUs")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iio/imu/adis16480.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -760,6 +760,7 @@ static const struct iio_info adis16480_i
 	.read_raw = &adis16480_read_raw,
 	.write_raw = &adis16480_write_raw,
 	.update_scan_mode = adis_update_scan_mode,
+	.debugfs_reg_access = adis_debugfs_reg_access,
 	.driver_module = THIS_MODULE,
 };
 

