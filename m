Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3035B31D787
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 11:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBQK0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 05:26:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230475AbhBQK0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 05:26:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613557510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7D9yQe5KSdsAiSzGvNRFKBC83KBbNru7nLK5pMb4JFI=;
        b=O+QBmyCHRhrPnGewB+ZQMcUQq8u4tmI9/5oEuz2ZgXi60zGG9IzYEn/K9n7Gmr8RtJZsQM
        xP2ndwKF3aC/Dj4pgvPTzerWR9lUWmikTTTCEYxMQw8Of6XCAim1g8e+CI8G6Z8HJWAVxO
        8FqeaUYJpRLEzz+tYDXaoYyDRc1iwao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-8kjSWx8BNqiDypGfMhtx3g-1; Wed, 17 Feb 2021 05:25:05 -0500
X-MC-Unique: 8kjSWx8BNqiDypGfMhtx3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BF2B192D785;
        Wed, 17 Feb 2021 10:25:04 +0000 (UTC)
Received: from x1.localdomain (ovpn-115-224.ams2.redhat.com [10.36.115.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA0D77086D;
        Wed, 17 Feb 2021 10:25:02 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Eric Piel <eric.piel@tremplin-utc.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] misc: lis3lv02d: Fix false-positive WARN on various HP models
Date:   Wed, 17 Feb 2021 11:24:59 +0100
Message-Id: <20210217102501.31758-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before this commit lis3lv02d_get_pwron_wait() had a WARN_ONCE() to catch
a potential divide by 0. WARN macros should only be used to catch internal
kernel bugs and that is not the case here. We have been receiving a lot of
bug reports about kernel backtraces caused by this WARN.

The div value being checked comes from the lis3->odrs[] array. Which
is sized to be a power-of-2 matching the number of bits in lis3->odr_mask.

The only lis3 model where this array is not entirely filled with non zero
values. IOW the only model where we can hit the div == 0 check is the
3dc ("8 bits 3DC sensor") model:

int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};

Note the 0 value at index 0, according to the datasheet an odr index of 0
means "Power-down mode". HP typically uses a lis3 accelerometer for HDD
fall protection. What I believe is happening here is that on newer
HP devices, which only contain a SDD, the BIOS is leaving the lis3 device
powered-down since it is not used for HDD fall protection.

Note that the lis3_3dc_rates array initializer only specifies 10 values,
which matches the datasheet. So it also contains 6 zero values at the end.

Replace the WARN with a normal check, which treats an odr index of 0
as power-down and uses a normal dev_err() to report the error in case
odr index point past the initialized part of the array.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=785814
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1817027
BugLink: https://bugs.centos.org/view.php?id=10720
Fixes: 1510dd5954be ("lis3lv02d: avoid divide by zero due to unchecked")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/misc/lis3lv02d/lis3lv02d.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index dd65cedf3b12..9d14bf444481 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -208,7 +208,7 @@ static int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};
 static int lis3_3dlh_rates[4] = {50, 100, 400, 1000};
 
 /* ODR is Output Data Rate */
-static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
+static int lis3lv02d_get_odr_index(struct lis3lv02d *lis3)
 {
 	u8 ctrl;
 	int shift;
@@ -216,15 +216,23 @@ static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
 	lis3->read(lis3, CTRL_REG1, &ctrl);
 	ctrl &= lis3->odr_mask;
 	shift = ffs(lis3->odr_mask) - 1;
-	return lis3->odrs[(ctrl >> shift)];
+	return (ctrl >> shift);
 }
 
 static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
 {
-	int div = lis3lv02d_get_odr(lis3);
+	int odr_idx = lis3lv02d_get_odr_index(lis3);
+	int div = lis3->odrs[odr_idx];
 
-	if (WARN_ONCE(div == 0, "device returned spurious data"))
+	if (div == 0) {
+		if (odr_idx == 0) {
+			/* Power-down mode, not sampling no need to sleep */
+			return 0;
+		}
+
+		dev_err(&lis3->pdev->dev, "Error unknown odrs-index: %d\n", odr_idx);
 		return -ENXIO;
+	}
 
 	/* LIS3 power on delay is quite long */
 	msleep(lis3->pwron_delay / div);
@@ -816,9 +824,12 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
 	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
+	int odr_idx;
 
 	lis3lv02d_sysfs_poweron(lis3);
-	return sprintf(buf, "%d\n", lis3lv02d_get_odr(lis3));
+
+	odr_idx = lis3lv02d_get_odr_index(lis3);
+	return sprintf(buf, "%d\n", lis3->odrs[odr_idx]);
 }
 
 static ssize_t lis3lv02d_rate_set(struct device *dev,
-- 
2.30.1

