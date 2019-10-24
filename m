Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A86EE3E68
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfJXVm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:42:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44698 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728257AbfJXVm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:42:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571953376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XmM6AYKYw5XaQhpeC/WQyTinNGC288QQtrxvUlj2K0=;
        b=TqoC6hTe4iYl8HBrlr53Om4yAQgMWoX52oHJrydTFqxPnz1nj6AU5BYohIz5F6o8IEOHOP
        knn/yU/X5RUK5leZ2MXpGhKfCKadbicKqd15LNQT/fhT+XpriK7W0Lctk8rxsSQlj3CP9F
        drB7k/bWvBuo1JfzCqGDW/QGzMOjNTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-6amlH899M9mBOZ__XomEdw-1; Thu, 24 Oct 2019 17:42:53 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C76471800E00;
        Thu, 24 Oct 2019 21:42:52 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62A293CCA;
        Thu, 24 Oct 2019 21:42:51 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 2/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C1 to lpss_device_links
Date:   Thu, 24 Oct 2019 23:42:47 +0200
Message-Id: <20191024214248.145429-2-hdegoede@redhat.com>
In-Reply-To: <20191024214248.145429-1-hdegoede@redhat.com>
References: <20191024214248.145429-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 6amlH899M9mBOZ__XomEdw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Various Asus Bay Trail devices (T100TA, T100CHI, T200TA) have an embedded
controller connected to I2C1 and the iGPU (LNXVIDEO) _PS0/_PS3 methods
access it, so we need to add a consumer link from LNXVIDEO to I2C1 on
these devices to avoid suspend/resume ordering problems.

Cc: stable@vger.kernel.org
Fixes: e6ce0ce34f65 ("ACPI / LPSS: Add device link for CHT SD card ... on I=
2C")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Add Fixes: tag
---
 drivers/acpi/acpi_lpss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index e7a4504f0fbf..cd8cf3333f04 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -477,6 +477,8 @@ static const struct lpss_device_links lpss_device_links=
[] =3D {
 =09{"808622C1", "7", "80860F14", "3", DL_FLAG_PM_RUNTIME},
 =09/* CHT iGPU depends on PMIC I2C controller */
 =09{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
+=09/* BYT iGPU depends on the Embedded Controller I2C controller (UID 1) *=
/
+=09{"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
 =09/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
 =09{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
 =09/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
--=20
2.23.0

