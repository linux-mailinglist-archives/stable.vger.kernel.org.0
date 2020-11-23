Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CDD2C0A56
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbgKWMjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732282AbgKWMje (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F041E2076E;
        Mon, 23 Nov 2020 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135173;
        bh=6p6WLMXtvcqPhZcMzRA4cJhAPLIS/sWhYY/eAup0aRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAyfXWtoP2kcXShzZsTCDxu9wUhGalcyX1Dw0rpksbI0POWl1gv2s0+Q39wgSHMfJ
         vBPcGG3JiijTccpqIUD/KRFhagEGzj4ueeaZ83W50mjnG3LPRKCRhgHOgWOj2rCz78
         +oHzcNqGcTnWW0a4np/WuoInayfGpH+jg43Yaaj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        russianneuromancer <russianneuromancer@ya.ru>
Subject: [PATCH 5.4 131/158] iio: accel: kxcjk1013: Add support for KIOX010A ACPI DSM for setting tablet-mode
Date:   Mon, 23 Nov 2020 13:22:39 +0100
Message-Id: <20201123121826.246282806@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit e5b1032a656e9aa4c7a4df77cb9156a2a651a5f9 upstream.

Some 360 degree hinges (yoga) style 2-in-1 devices use 2 KXCJ91008-s
to allow the OS to determine the angle between the display and the base
of the device, so that the OS can determine if the 2-in-1 is in laptop
or in tablet-mode.

On Windows both accelerometers are read by a special HingeAngleService
process; and this process calls a DSM (Device Specific Method) on the
ACPI KIOX010A device node for the sensor in the display, to let the
embedded-controller (EC) know about the mode so that it can disable the
kbd and touchpad to avoid spurious input while folded into tablet-mode.

This notifying of the EC is problematic because sometimes the EC comes up
thinking that device is in tablet-mode and the kbd and touchpad do not
work. This happens for example on Irbis NB111 devices after a suspend /
resume cycle (after a complete battery drain / hard reset without having
booted Windows at least once). Other 2-in-1s which are likely affected
too are e.g. the Teclast F5 and F6 series.

The kxcjk-1013 driver may seem like a strange place to deal with this,
but since it is *the* driver for the ACPI KIOX010A device, it is also
the driver which has access to the ACPI handle needed by the DSM.

Add support for calling the DSM and on probe unconditionally tell the
EC that the device is laptop mode, fixing the kbd and touchpad sometimes
not working.

Fixes: 7f6232e69539 ("iio: accel: kxcjk1013: Add KIOX010A ACPI Hardware-ID")
Reported-and-tested-by: russianneuromancer <russianneuromancer@ya.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201110133835.129080-3-hdegoede@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/kxcjk-1013.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -129,6 +129,7 @@ enum kx_chipset {
 enum kx_acpi_type {
 	ACPI_GENERIC,
 	ACPI_SMO8500,
+	ACPI_KIOX010A,
 };
 
 struct kxcjk1013_data {
@@ -274,6 +275,32 @@ static const struct {
 			      {19163, 1, 0},
 			      {38326, 0, 1} };
 
+#ifdef CONFIG_ACPI
+enum kiox010a_fn_index {
+	KIOX010A_SET_LAPTOP_MODE = 1,
+	KIOX010A_SET_TABLET_MODE = 2,
+};
+
+static int kiox010a_dsm(struct device *dev, int fn_index)
+{
+	acpi_handle handle = ACPI_HANDLE(dev);
+	guid_t kiox010a_dsm_guid;
+	union acpi_object *obj;
+
+	if (!handle)
+		return -ENODEV;
+
+	guid_parse("1f339696-d475-4e26-8cad-2e9f8e6d7a91", &kiox010a_dsm_guid);
+
+	obj = acpi_evaluate_dsm(handle, &kiox010a_dsm_guid, 1, fn_index, NULL);
+	if (!obj)
+		return -EIO;
+
+	ACPI_FREE(obj);
+	return 0;
+}
+#endif
+
 static int kxcjk1013_set_mode(struct kxcjk1013_data *data,
 			      enum kxcjk1013_mode mode)
 {
@@ -351,6 +378,13 @@ static int kxcjk1013_chip_init(struct kx
 {
 	int ret;
 
+#ifdef CONFIG_ACPI
+	if (data->acpi_type == ACPI_KIOX010A) {
+		/* Make sure the kbd and touchpad on 2-in-1s using 2 KXCJ91008-s work */
+		kiox010a_dsm(&data->client->dev, KIOX010A_SET_LAPTOP_MODE);
+	}
+#endif
+
 	ret = i2c_smbus_read_byte_data(data->client, KXCJK1013_REG_WHO_AM_I);
 	if (ret < 0) {
 		dev_err(&data->client->dev, "Error reading who_am_i\n");
@@ -1248,6 +1282,8 @@ static const char *kxcjk1013_match_acpi_
 
 	if (strcmp(id->id, "SMO8500") == 0)
 		*acpi_type = ACPI_SMO8500;
+	else if (strcmp(id->id, "KIOX010A") == 0)
+		*acpi_type = ACPI_KIOX010A;
 
 	*chipset = (enum kx_chipset)id->driver_data;
 


