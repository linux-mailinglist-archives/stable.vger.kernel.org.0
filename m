Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75645E3E24
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfJXV3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:29:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbfJXV3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571952584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xdAm26JwyHkgbR50QvC+H2Fp7CLfPYdFaLeSX5jyse4=;
        b=gNU5HAcTU72K2fLLjN8q/6Jzf8PNDHcPNyi3Gv47coU2s1PQe7IHIkmOqu/EcErFCfNn3v
        rLTrkhYjPnNHxaVaherXjaVmzv/aH9sjc2bhjn4HZnYZbJl5ZuQkZVU7YJ3sdWkr2NXMwA
        0JSvRROexBZylKQHJ6a5az5cXX4dUsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-3NOf5ZZyM5yQtgW52tvnVg-1; Thu, 24 Oct 2019 17:29:41 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09A90800D49;
        Thu, 24 Oct 2019 21:29:40 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DB0760BF3;
        Thu, 24 Oct 2019 21:29:38 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to lpss_device_links
Date:   Thu, 24 Oct 2019 23:29:34 +0200
Message-Id: <20191024212936.144648-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 3NOf5ZZyM5yQtgW52tvnVg-1
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
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
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

