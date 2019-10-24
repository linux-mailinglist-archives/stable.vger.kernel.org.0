Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BCFE3E67
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfJXVm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:42:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727327AbfJXVm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:42:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571953376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GWq5hgO6XxTjpibA371jR/RRiUVbpcvXY7m0Wdp77ZE=;
        b=S4i2WJBCiVyJU9To1jRthuCKA0kzKGcsYHgAr488eIe+geX2FdB7E+ZmNdPcmgvldQPvIP
        7As4JhVCqOzUC4K3kGmMYpLN6c3Z3qhQaafhX7zW0VL2707pxIPziWPIzih8GKES/VJTcs
        G9KQaB49+DywqpN4uHyyeWZIGWm38Kk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-WZQJID-vPQu9FvEXYsZlLw-1; Thu, 24 Oct 2019 17:42:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DCC4800D49;
        Thu, 24 Oct 2019 21:42:51 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFBCB4107;
        Thu, 24 Oct 2019 21:42:49 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to lpss_device_links
Date:   Thu, 24 Oct 2019 23:42:46 +0200
Message-Id: <20191024214248.145429-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: WZQJID-vPQu9FvEXYsZlLw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

So far on Bay Trail (BYT) we only have been adding a device_link adding
the iGPU (LNXVIDEO) device as consumer for the I2C controller for the
PMIC for I2C5, but the PMIC only uses I2C5 on BYT CR (cost reduced) on
regular BYT platforms I2C7 is used and we were not adding the device_link
sometimes causing resume ordering issues.

This commit adds LNXVIDEO -> BYT I2C7 to the lpss_device_links table,
fixing this.

Cc: stable@vger.kernel.org
Fixes: e6ce0ce34f65 ("ACPI / LPSS: Add device link for CHT SD card ... on I=
2C")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Add Fixes: tag
---
 drivers/acpi/acpi_lpss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 60bbc5090abe..e7a4504f0fbf 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -473,9 +473,14 @@ struct lpss_device_links {
  * the supplier is not enumerated until after the consumer is probed.
  */
 static const struct lpss_device_links lpss_device_links[] =3D {
+=09/* CHT External sdcard slot controller depends on PMIC I2C ctrl */
 =09{"808622C1", "7", "80860F14", "3", DL_FLAG_PM_RUNTIME},
+=09/* CHT iGPU depends on PMIC I2C controller */
 =09{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
+=09/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
 =09{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
+=09/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
+=09{"80860F41", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
 };
=20
 static bool hid_uid_match(struct acpi_device *adev,
--=20
2.23.0

