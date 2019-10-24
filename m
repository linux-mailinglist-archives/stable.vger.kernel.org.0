Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867B4E3EA5
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfJXV5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:57:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29301 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729763AbfJXV5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571954250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uzOi1pT4E0kyiRylICAWY1WoaBhKfsbLJBwVvcFjipo=;
        b=Ro1k6E6iqj4z58KoJZu0Q5cLtiUhDYcE5dOTPcefdOUGxMB65y+vGlv8ibW9+5KgIrqaf4
        AaAc3BuKXt+gu8cyHhGajVzT0BaufM2vE0yesVXmBOw3n7IGeySsbvKVnJ6mX3ABuFfZs2
        NGGJtrenL7xTvGodng+Qzz7y5dtBCzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-mGNSMMj1PMajaiuHt-a-Eg-1; Thu, 24 Oct 2019 17:57:27 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA50B476;
        Thu, 24 Oct 2019 21:57:25 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AB0960A97;
        Thu, 24 Oct 2019 21:57:24 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to lpss_device_links
Date:   Thu, 24 Oct 2019 23:57:21 +0200
Message-Id: <20191024215723.145922-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: mGNSMMj1PMajaiuHt-a-Eg-1
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
Fixes: 2d71ee0ce72f ("ACPI / LPSS: Add a device link from the GPU to the BY=
T I2C5 controller")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Add Fixes: tag

Changes in v3:
-Point Fixes tag to a more apropriate commit
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

