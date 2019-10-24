Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631D8E3EA7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfJXV5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:57:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729853AbfJXV5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:57:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571954252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tgKcp/UQQkirFK3j3v0j43XKjPdGb1ZdrCxUT50lT/k=;
        b=R94kkVBVpLp1aMl79OFMAjWIAs3KeiEPncOPnJVFIAAvOyhPMtSlNlVjle7sSuqzNk3Z2r
        yP6MtS/Ws8qSHE887SNW+v0twJnQc+ZQNstVu1BhyqGP5vRazWcNtQxTLZS90pUi3W9nHT
        XDOP3lS/1pES4HTmBwJh11Tw0J+phSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-3KWzjhRVO4mRKAVwwKl9ng-1; Thu, 24 Oct 2019 17:57:28 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C4021005500;
        Thu, 24 Oct 2019 21:57:27 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A3756092D;
        Thu, 24 Oct 2019 21:57:26 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 2/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C1 to lpss_device_links
Date:   Thu, 24 Oct 2019 23:57:22 +0200
Message-Id: <20191024215723.145922-2-hdegoede@redhat.com>
In-Reply-To: <20191024215723.145922-1-hdegoede@redhat.com>
References: <20191024215723.145922-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 3KWzjhRVO4mRKAVwwKl9ng-1
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
Fixes: 2d71ee0ce72f ("ACPI / LPSS: Add a device link from the GPU to the BY=
T I2C5 controller")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Add Fixes: tag

Changes in v3:
-Point Fixes tag to a more apropriate commit
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

