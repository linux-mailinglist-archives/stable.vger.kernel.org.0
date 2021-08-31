Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554553FC7D5
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 15:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhHaNGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 09:06:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232604AbhHaNGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 09:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630415113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F7EjQETfnoBHWzQ9AKWabwVHwHQLRkOd1pRL+0bECbc=;
        b=B+ZkfZdj6S+Git0LgR2QiyQQzxkZNnRxhHVdDIPfBYMpzK4bCbiXsJ+3/uzlknohJDAJXk
        o9rEhvoJ2jth0X8cC6PI7lIYrslY0XCB1ym6rgjQjGfNLirZUekq0hlmogCcCPdzIvMJou
        4NIOUBDCMbiO6jVPSWuTgMkOgrgzIfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-xIDVd-q3MaydZZ6fj9A1nA-1; Tue, 31 Aug 2021 09:05:12 -0400
X-MC-Unique: xIDVd-q3MaydZZ6fj9A1nA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F9A66414A;
        Tue, 31 Aug 2021 13:05:11 +0000 (UTC)
Received: from x1.localdomain.com (unknown [10.39.193.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A448D76BF9;
        Tue, 31 Aug 2021 13:05:09 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jean Delvare <jdelvare@suse.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>,
        Erwan Velu <e.velu@criteo.com>
Subject: [PATCH regression fix] firmware/dmi: Move product_sku info to the end of the modalias
Date:   Tue, 31 Aug 2021 15:05:08 +0200
Message-Id: <20210831130508.14511-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit e26f023e01ef ("firmware/dmi: Include product_sku info to modalias")
added a new field to the modalias in the middle of the modalias, breaking
some existing udev/hwdb matches on the whole modalias without a wildcard
('*') in between the pvr and rvn fields.

All modalias matches in e.g. :
https://github.com/systemd/systemd/blob/main/hwdb.d/60-sensor.hwdb
deliberately end in ':*' so that new fields can be added at *the end* of
the modalias, but adding a new field in the middle like this breaks things.

Move the new sku field to the end of the modalias to fix some hwdb
entries no longer matching.

The new sku field has already been put to use in 2 new hwdb entries:

 sensor:modalias:platform:HID-SENSOR-200073:dmi:*svnDell*:sku0A3E:*
  ACCEL_LOCATION=base

 sensor:modalias:platform:HID-SENSOR-200073:dmi:*svnDell*:sku0B0B:*
  ACCEL_LOCATION=base

The wildcard use before and after the sku in these matches means that they
should keep working with the sku moved to the end.

Note that there is a second instance of in essence the same problem,
commit f5152f4ded3c ("firmware/dmi: Report DMI Bios & EC firmware release")

Added 2 new br and efr fields in the middle of the modalias. This too
breaks some hwdb modalias matches, but this has gone unnoticed for over
a year. So some newer hwdb modalias matches actually depend on these
fields being in the middle of the string. Moving these to the end now
would break 3 hwdb entries, while fixing 8 entries.

Since there is no good answer for the new br and efr fields I have chosen
to leave these as is. Instead I'll submit a hwdb update to put a wildcard
at the place where these fields may or may not be present depending on the
kernel version.

BugLink: https://github.com/systemd/systemd/issues/20550
Link: https://github.com/systemd/systemd/pull/20562
Fixes: e26f023e01ef ("firmware/dmi: Include product_sku info to modalias")
Cc: stable@vger.kernel.org
Cc: Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>
Cc: Erwan Velu <e.velu@criteo.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/firmware/dmi-id.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index 4d5421d14a41..940ddf916202 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -73,6 +73,10 @@ static void ascii_filter(char *d, const char *s)
 
 static ssize_t get_modalias(char *buffer, size_t buffer_size)
 {
+	/*
+	 * Note new fields need to be added at the end to keep compatibility
+	 * with udev's hwdb which does matches on "`cat dmi/id/modalias`*".
+	 */
 	static const struct mafield {
 		const char *prefix;
 		int field;
@@ -85,13 +89,13 @@ static ssize_t get_modalias(char *buffer, size_t buffer_size)
 		{ "svn", DMI_SYS_VENDOR },
 		{ "pn",  DMI_PRODUCT_NAME },
 		{ "pvr", DMI_PRODUCT_VERSION },
-		{ "sku", DMI_PRODUCT_SKU },
 		{ "rvn", DMI_BOARD_VENDOR },
 		{ "rn",  DMI_BOARD_NAME },
 		{ "rvr", DMI_BOARD_VERSION },
 		{ "cvn", DMI_CHASSIS_VENDOR },
 		{ "ct",  DMI_CHASSIS_TYPE },
 		{ "cvr", DMI_CHASSIS_VERSION },
+		{ "sku", DMI_PRODUCT_SKU },
 		{ NULL,  DMI_NONE }
 	};
 
-- 
2.31.1

