Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CF02C0AB8
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgKWMZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgKWMZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:25:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9EF120728;
        Mon, 23 Nov 2020 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134354;
        bh=VoLVhji7Rc7F0jOMYsBCLnXbsBXeB80vLe+pWO4E0wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FObjknad2z8yhdohTr8hb8inBxohy8lCYZQPsIQbylxT9QFz+RG+ke34RFIK+vZ5
         Y1CvSmIVzkv85evQoetD8RMaMxe2vVtkFkWs5AVnVj1axUvlQvMM5u7s15ms2yt71q
         bKp+IuTuo05kPBlqvCAm2+L9yyLenoEjwpwMl8PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 40/47] iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type enum
Date:   Mon, 23 Nov 2020 13:22:26 +0100
Message-Id: <20201123121807.494392060@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 11e94f28c3de35d5ad1ac6a242a5b30f4378991a upstream.

Replace the boolean is_smo8500_device variable with an acpi_type enum.

For now this can be either ACPI_GENERIC or ACPI_SMO8500, this is a
preparation patch for adding special handling for the KIOX010A ACPI HID,
which will add a ACPI_KIOX010A acpi_type to the introduced enum.

For stable as needed as precursor for next patch.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Fixes: 7f6232e69539 ("iio: accel: kxcjk1013: Add KIOX010A ACPI Hardware-ID")
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201110133835.129080-2-hdegoede@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/kxcjk-1013.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -91,6 +91,11 @@ enum kx_chipset {
 	KX_MAX_CHIPS /* this must be last */
 };
 
+enum kx_acpi_type {
+	ACPI_GENERIC,
+	ACPI_SMO8500,
+};
+
 struct kxcjk1013_data {
 	struct i2c_client *client;
 	struct iio_trigger *dready_trig;
@@ -107,7 +112,7 @@ struct kxcjk1013_data {
 	bool motion_trigger_on;
 	int64_t timestamp;
 	enum kx_chipset chipset;
-	bool is_smo8500_device;
+	enum kx_acpi_type acpi_type;
 };
 
 enum kxcjk1013_axis {
@@ -1144,7 +1149,7 @@ static irqreturn_t kxcjk1013_data_rdy_tr
 
 static const char *kxcjk1013_match_acpi_device(struct device *dev,
 					       enum kx_chipset *chipset,
-					       bool *is_smo8500_device)
+					       enum kx_acpi_type *acpi_type)
 {
 	const struct acpi_device_id *id;
 
@@ -1153,7 +1158,7 @@ static const char *kxcjk1013_match_acpi_
 		return NULL;
 
 	if (strcmp(id->id, "SMO8500") == 0)
-		*is_smo8500_device = true;
+		*acpi_type = ACPI_SMO8500;
 
 	*chipset = (enum kx_chipset)id->driver_data;
 
@@ -1189,7 +1194,7 @@ static int kxcjk1013_probe(struct i2c_cl
 	} else if (ACPI_HANDLE(&client->dev)) {
 		name = kxcjk1013_match_acpi_device(&client->dev,
 						   &data->chipset,
-						   &data->is_smo8500_device);
+						   &data->acpi_type);
 	} else
 		return -ENODEV;
 
@@ -1207,7 +1212,7 @@ static int kxcjk1013_probe(struct i2c_cl
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &kxcjk1013_info;
 
-	if (client->irq > 0 && !data->is_smo8500_device) {
+	if (client->irq > 0 && data->acpi_type != ACPI_SMO8500) {
 		ret = devm_request_threaded_irq(&client->dev, client->irq,
 						kxcjk1013_data_rdy_trig_poll,
 						kxcjk1013_event_handler,


