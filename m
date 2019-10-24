Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AD2E3E27
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfJXV3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:29:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44458 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729262AbfJXV3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571952589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4FC5d5eI0lcfZeTtKb+Os1wCwIA2NsNDq5BVpX5ys4=;
        b=KQbyJfUn5uZhCfO0gV1yjRKRSQtC7Kirr4BOZqTQ4aTbremzE2NX5sFiFCdb2CdgsRlwYN
        I7aQz8wAlWoU5BXpyNF32jmJwbX6EvxZcyNS1f+TZhCKaSg3P2Hk3c18dziJi23Lahdg2U
        z44k/HRZf1SFAn3vQViLiudKG94tM0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-rW2wR28fPxCA5IuGUOkKKw-1; Thu, 24 Oct 2019 17:29:43 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9B1C1800E00;
        Thu, 24 Oct 2019 21:29:41 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F0356CE50;
        Thu, 24 Oct 2019 21:29:40 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C1 to lpss_device_links
Date:   Thu, 24 Oct 2019 23:29:35 +0200
Message-Id: <20191024212936.144648-2-hdegoede@redhat.com>
In-Reply-To: <20191024212936.144648-1-hdegoede@redhat.com>
References: <20191024212936.144648-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: rW2wR28fPxCA5IuGUOkKKw-1
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
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
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

