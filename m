Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3EACEC3A
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 20:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfJGS4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 14:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbfJGS4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 14:56:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 49E1E800DF5;
        Mon,  7 Oct 2019 18:56:34 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-119.ams2.redhat.com [10.36.116.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8D0C5C223;
        Mon,  7 Oct 2019 18:56:27 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] HID: i2c-hid: add Trekstor Primebook C11B to descriptor override
Date:   Mon,  7 Oct 2019 20:56:26 +0200
Message-Id: <20191007185626.247959-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Mon, 07 Oct 2019 18:56:34 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Primebook C11B uses the SIPODEV SP1064 touchpad. There are 2 versions
of this 2-in-1 and the touchpad in the older version does not supply
descriptors, so it has to be added to the override list.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index 75078c83be1a..d31ea82b84c1 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -322,6 +322,25 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		/*
+		 * There are at least 2 Primebook C11B versions, the older
+		 * version has a product-name of "Primebook C11B", and a
+		 * bios version / release / firmware revision of:
+		 * V2.1.2 / 05/03/2018 / 18.2
+		 * The new version has "PRIMEBOOK C11B" as product-name and a
+		 * bios version / release / firmware revision of:
+		 * CFALKSW05_BIOS_V1.1.2 / 11/19/2018 / 19.2
+		 * Only the older version needs this quirk, note the newer
+		 * version will not match as it has a different product-name.
+		 */
+		.ident = "Trekstor Primebook C11B",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "TREKSTOR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Primebook C11B"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{
 		.ident = "Direkt-Tek DTLAPY116-2",
 		.matches = {
-- 
2.23.0

