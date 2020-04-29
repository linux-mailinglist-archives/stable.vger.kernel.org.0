Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EDA1BDA0D
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 12:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgD2Kq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 06:46:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21020 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726608AbgD2Kq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 06:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588157217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xOsqPnWiZhtfwDIB7QTbIZdiYQw00zAWNxTlyvbJBw8=;
        b=AvbxSZ6gkonVZaW2xZEdKDYqRZ19LLcYclkKlyJVJfwdbCRGj8sdeYXd9pGeo9gUqIxrFK
        QUoPy110P61Ig5id5H4W88E4jTUD5l8X+lDnY1lyqnLAcqC052BT3AbHNC0UJVQoU7FKmH
        fZAZk/IeX746xN6taKCygRuqtSVXxiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-H8xxEMhdMYSiJE6i707DpQ-1; Wed, 29 Apr 2020 06:46:54 -0400
X-MC-Unique: H8xxEMhdMYSiJE6i707DpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9091F45F;
        Wed, 29 Apr 2020 10:46:53 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-115-57.ams2.redhat.com [10.36.115.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DAE460C18;
        Wed, 29 Apr 2020 10:46:51 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO, 1) gets called
Date:   Wed, 29 Apr 2020 12:46:51 +0200
Message-Id: <20200429104651.63643-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
that this is best fixed inside the cherryview pinctrl driver.

This commit adds a workaround to the cherryview pinctrl driver so
that the DSDT's expectations of _REG always getting called for the
GeneralPurposeIo OpRegion are met.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl=
/intel/pinctrl-cherryview.c
index 4c74fdde576d..e0f11f1f841f 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1755,6 +1755,27 @@ static int chv_pinctrl_probe(struct platform_devic=
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
+	if (acpi_has_method(adev->handle, "_REG")) {
+		struct acpi_object_list input;
+		union acpi_object params[2];
+
+		input.count =3D 2;
+		input.pointer =3D params;
+		params[0].type =3D ACPI_TYPE_INTEGER;
+		params[0].integer.value =3D ACPI_ADR_SPACE_GPIO;
+		params[1].type =3D ACPI_TYPE_INTEGER;
+		params[1].integer.value =3D 1;
+		acpi_evaluate_object(adev->handle, "_REG", &input, NULL);
+	}
+
 	platform_set_drvdata(pdev, pctrl);
=20
 	return 0;
--=20
2.26.0

