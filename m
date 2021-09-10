Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5D2406BA8
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhIJMd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhIJMdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 226706120D;
        Fri, 10 Sep 2021 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277115;
        bh=E/0i4XKBdZIg6SDJZ+2oudkgwjpIz3s7QixcSpy6H4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBAV0A/gPOPqW8jbMDo+Abegff7qS/DtZHP5jHXW6E4rjWJn12LcIXqBnAiLUqDt0
         sPj9rRa5Gs335Zx3lpIhLsI2wqmk9H6lAnahiB20pu9ZMnsgoDeP2JXu1FyfQpmH0v
         CfPMw+AO010gcl87AWeEHihyY2l/5qzneEJIJAQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>,
        Erwan Velu <e.velu@criteo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 5.13 01/22] firmware: dmi: Move product_sku info to the end of the modalias
Date:   Fri, 10 Sep 2021 14:30:00 +0200
Message-Id: <20210910122915.989375641@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
References: <20210910122915.942645251@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit f97a2103f1a75ca70f23deadb4d96a16c4d85e7d upstream.

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
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/dmi-id.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -73,6 +73,10 @@ static void ascii_filter(char *d, const
 
 static ssize_t get_modalias(char *buffer, size_t buffer_size)
 {
+	/*
+	 * Note new fields need to be added at the end to keep compatibility
+	 * with udev's hwdb which does matches on "`cat dmi/id/modalias`*".
+	 */
 	static const struct mafield {
 		const char *prefix;
 		int field;
@@ -85,13 +89,13 @@ static ssize_t get_modalias(char *buffer
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
 


