Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7271C3DDA
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 17:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgEDPAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 11:00:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726948AbgEDPAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 11:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588604403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3Xw+Uaums8e6DhRGeikQZLeNUe/5GzNdvE9z9LG9DVI=;
        b=JzjhuDw5efVeD2YIBM8ZHpqWg3iPSB1WvAtTxp4BCc+GSCrc27nWA5B1/rauJ+V7OZw7Cu
        1ZJOOZrj672NrBjyPOcZYppZv/EMdh6icIBce0tzw0FzI2kdOTr1lrrncvYkD3oviOHrzb
        kXi9zHcWN8XQyuaHdiB9iZp8NAOvvXY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-8-fWDiVGMxyZoe0CE84Qfg-1; Mon, 04 May 2020 11:00:02 -0400
X-MC-Unique: 8-fWDiVGMxyZoe0CE84Qfg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 927DB19057C0;
        Mon,  4 May 2020 15:00:00 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-114-224.ams2.redhat.com [10.36.114.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 237CA60621;
        Mon,  4 May 2020 14:59:58 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-acpi@vger.kernel.org,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO, 1) gets called
Date:   Mon,  4 May 2020 16:59:57 +0200
Message-Id: <20200504145957.480418-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Cherry Trail devices there are 2 possible ACPI OpRegions for
accessing GPIOs. The standard GeneralPurposeIo OpRegion and the Cherry
Trail specific UserDefined 0x9X OpRegions.

Having 2 different types of OpRegions leads to potential issues with
checks for OpRegion availability, or in other words checks if _REG has
been called for the OpRegion which the ACPI code wants to use.

The ACPICA core does not call _REG on an ACPI node which does not
define an OpRegion matching the type being registered; and the reference
design DSDT, from which most Cherry Trail DSDTs are derived, does not
define GeneralPurposeIo, nor UserDefined(0x93) OpRegions for the GPO2
(UID 3) device, because no pins were assigned ACPI controlled functions
in the reference design.

Together this leads to the perfect storm, at least on the Cherry Trail
based Medion Akayo E1239T. This design does use a GPO2 pin from its ACPI
code and has added the Cherry Trail specific UserDefined(0x93) opregion
to its GPO2 ACPI node to access this pin.

But it uses a has _REG been called availability check for the standard
GeneralPurposeIo OpRegion. This clearly is a bug in the DSDT, but this
does work under Windows. This issue leads to the intel_vbtn driver
reporting the device always being in tablet-mode at boot, even if it
is in laptop mode. Which in turn causes userspace to ignore touchpad
events. So iow this issues causes the touchpad to not work at boot.

Since the bug in the DSDT stems from the confusion of having 2 different
OpRegion types for accessing GPIOs on Cherry Trail devices, I believe
that this is best fixed inside the Cherryview pinctrl driver.

This commit adds a workaround to the Cherryview pinctrl driver so
that the DSDT's expectations of _REG always getting called for the
GeneralPurposeIo OpRegion are met.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Drop unnecessary if (acpi_has_method(adev->handle, "_REG")) check
- Fix Cherryview spelling in the commit message
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl=
/intel/pinctrl-cherryview.c
index 4c74fdde576d..4817aec114d6 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1693,6 +1693,8 @@ static acpi_status chv_pinctrl_mmio_access_handler(=
u32 function,
=20
 static int chv_pinctrl_probe(struct platform_device *pdev)
 {
+	struct acpi_object_list input;
+	union acpi_object params[2];
 	struct chv_pinctrl *pctrl;
 	struct acpi_device *adev;
 	acpi_status status;
@@ -1755,6 +1757,22 @@ static int chv_pinctrl_probe(struct platform_devic=
e *pdev)
 	if (ACPI_FAILURE(status))
 		dev_err(&pdev->dev, "failed to install ACPI addr space handler\n");
=20
+	/*
+	 * Some DSDT-s use the chv_pinctrl_mmio_access_handler while checking
+	 * for the regular GeneralPurposeIo OpRegion availability, mixed with
+	 * the DSDT not defining a GeneralPurposeIo OpRegion at all. In this
+	 * case the ACPICA code will not call _REG to signal availability of
+	 * the GeneralPurposeIo OpRegion. Manually call _REG here so that
+	 * the DSDT-s GeneralPurposeIo availability checks will succeed.
+	 */
+	params[0].type =3D ACPI_TYPE_INTEGER;
+	params[0].integer.value =3D ACPI_ADR_SPACE_GPIO;
+	params[1].type =3D ACPI_TYPE_INTEGER;
+	params[1].integer.value =3D 1;
+	input.count =3D 2;
+	input.pointer =3D params;
+	acpi_evaluate_object(adev->handle, "_REG", &input, NULL);
+
 	platform_set_drvdata(pdev, pctrl);
=20
 	return 0;
--=20
2.26.0

