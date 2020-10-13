Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6508328C906
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 09:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389832AbgJMHPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 03:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389877AbgJMHPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 03:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602573344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=66rwCU7p6AuqjKfd58HRDui8k5Q9RzNK8szHNrdFih4=;
        b=W2f8PVvuMukhDmCSpYHmnc0mwZO/bIPvl+mxiII8BFwhs2BeiGB4VopJgJxnYbTXZgtKrB
        QHXeQmTse3YmEzKSACm6KBHP3ZG3r9xBno/5D6Y0Z/p0+U9VXaR1sDGyKaMrDS0XkMhvvz
        BCxXFQeLgq0BSMhIdSQrmpXHrkEmKYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-hPgO6CflML2S5cJzs499gQ-1; Tue, 13 Oct 2020 03:15:41 -0400
X-MC-Unique: hPgO6CflML2S5cJzs499gQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C57E118C35A7;
        Tue, 13 Oct 2020 07:15:39 +0000 (UTC)
Received: from plouf.redhat.com (ovpn-112-131.ams2.redhat.com [10.36.112.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C2255C22D;
        Tue, 13 Oct 2020 07:15:35 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] input - elantech: force query XY range after absolute mode
Date:   Tue, 13 Oct 2020 09:15:31 +0200
Message-Id: <20201013071531.225812-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For some v3 hw versions, if the ETP_FW_ID_QUERY command is
issued before the call to set_absolute_mode(), the returned
values are wrong.

Force an other ETP_FW_ID_QUERY after set_absolute_mode()
to get correct values.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=209027
Cc: stable@vger.kernel.org  # 5.3+
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/mouse/elantech.c | 161 +++++++++++++++++++--------------
 1 file changed, 91 insertions(+), 70 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 90f8765f9efc..ff8e5fb61dab 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1593,80 +1593,12 @@ static int elantech_set_properties(struct elantech_device_info *info)
 	return 0;
 }
 
-static int elantech_query_info(struct psmouse *psmouse,
-			       struct elantech_device_info *info)
+static int elantech_get_range(struct psmouse *psmouse,
+			      struct elantech_device_info *info)
 {
 	unsigned char param[3];
 	unsigned char traces;
 
-	memset(info, 0, sizeof(*info));
-
-	/*
-	 * Do the version query again so we can store the result
-	 */
-	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
-		psmouse_err(psmouse, "failed to query firmware version.\n");
-		return -EINVAL;
-	}
-	info->fw_version = (param[0] << 16) | (param[1] << 8) | param[2];
-
-	if (elantech_set_properties(info)) {
-		psmouse_err(psmouse, "unknown hardware version, aborting...\n");
-		return -EINVAL;
-	}
-	psmouse_info(psmouse,
-		     "assuming hardware version %d (with firmware version 0x%02x%02x%02x)\n",
-		     info->hw_version, param[0], param[1], param[2]);
-
-	if (info->send_cmd(psmouse, ETP_CAPABILITIES_QUERY,
-	    info->capabilities)) {
-		psmouse_err(psmouse, "failed to query capabilities.\n");
-		return -EINVAL;
-	}
-	psmouse_info(psmouse,
-		     "Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
-		     info->capabilities[0], info->capabilities[1],
-		     info->capabilities[2]);
-
-	if (info->hw_version != 1) {
-		if (info->send_cmd(psmouse, ETP_SAMPLE_QUERY, info->samples)) {
-			psmouse_err(psmouse, "failed to query sample data\n");
-			return -EINVAL;
-		}
-		psmouse_info(psmouse,
-			     "Elan sample query result %02x, %02x, %02x\n",
-			     info->samples[0],
-			     info->samples[1],
-			     info->samples[2]);
-	}
-
-	if (info->samples[1] == 0x74 && info->hw_version == 0x03) {
-		/*
-		 * This module has a bug which makes absolute mode
-		 * unusable, so let's abort so we'll be using standard
-		 * PS/2 protocol.
-		 */
-		psmouse_info(psmouse,
-			     "absolute mode broken, forcing standard PS/2 protocol\n");
-		return -ENODEV;
-	}
-
-	/* The MSB indicates the presence of the trackpoint */
-	info->has_trackpoint = (info->capabilities[0] & 0x80) == 0x80;
-
-	info->x_res = 31;
-	info->y_res = 31;
-	if (info->hw_version == 4) {
-		if (elantech_get_resolution_v4(psmouse,
-					       &info->x_res,
-					       &info->y_res,
-					       &info->bus)) {
-			psmouse_warn(psmouse,
-				     "failed to query resolution data.\n");
-		}
-	}
-
-	/* query range information */
 	switch (info->hw_version) {
 	case 1:
 		info->x_min = ETP_XMIN_V1;
@@ -1745,6 +1677,87 @@ static int elantech_query_info(struct psmouse *psmouse,
 		break;
 	}
 
+	return 0;
+}
+
+static int elantech_query_info(struct psmouse *psmouse,
+			       struct elantech_device_info *info)
+{
+	unsigned char param[3];
+	int error;
+
+	memset(info, 0, sizeof(*info));
+
+	/*
+	 * Do the version query again so we can store the result
+	 */
+	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
+		psmouse_err(psmouse, "failed to query firmware version.\n");
+		return -EINVAL;
+	}
+	info->fw_version = (param[0] << 16) | (param[1] << 8) | param[2];
+
+	if (elantech_set_properties(info)) {
+		psmouse_err(psmouse, "unknown hardware version, aborting...\n");
+		return -EINVAL;
+	}
+	psmouse_info(psmouse,
+		     "assuming hardware version %d (with firmware version 0x%02x%02x%02x)\n",
+		     info->hw_version, param[0], param[1], param[2]);
+
+	if (info->send_cmd(psmouse, ETP_CAPABILITIES_QUERY,
+	    info->capabilities)) {
+		psmouse_err(psmouse, "failed to query capabilities.\n");
+		return -EINVAL;
+	}
+	psmouse_info(psmouse,
+		     "Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
+		     info->capabilities[0], info->capabilities[1],
+		     info->capabilities[2]);
+
+	if (info->hw_version != 1) {
+		if (info->send_cmd(psmouse, ETP_SAMPLE_QUERY, info->samples)) {
+			psmouse_err(psmouse, "failed to query sample data\n");
+			return -EINVAL;
+		}
+		psmouse_info(psmouse,
+			     "Elan sample query result %02x, %02x, %02x\n",
+			     info->samples[0],
+			     info->samples[1],
+			     info->samples[2]);
+	}
+
+	if (info->samples[1] == 0x74 && info->hw_version == 0x03) {
+		/*
+		 * This module has a bug which makes absolute mode
+		 * unusable, so let's abort so we'll be using standard
+		 * PS/2 protocol.
+		 */
+		psmouse_info(psmouse,
+			     "absolute mode broken, forcing standard PS/2 protocol\n");
+		return -ENODEV;
+	}
+
+	/* The MSB indicates the presence of the trackpoint */
+	info->has_trackpoint = (info->capabilities[0] & 0x80) == 0x80;
+
+	info->x_res = 31;
+	info->y_res = 31;
+	if (info->hw_version == 4) {
+		if (elantech_get_resolution_v4(psmouse,
+					       &info->x_res,
+					       &info->y_res,
+					       &info->bus)) {
+			psmouse_warn(psmouse,
+				     "failed to query resolution data.\n");
+		}
+	}
+
+	/* query range information */
+	error = elantech_get_range(psmouse, info);
+	if (error)
+		return error;
+
 	/* check for the middle button: DMI matching or new v4 firmwares */
 	info->has_middle_button = dmi_check_system(elantech_dmi_has_middle_button) ||
 				  (ETP_NEW_IC_SMBUS_HOST_NOTIFY(info->fw_version) &&
@@ -1942,6 +1955,14 @@ static int elantech_setup_ps2(struct psmouse *psmouse,
 		goto init_fail;
 	}
 
+	/*
+	 * some hardware v3 send wrong min max coordinates if the
+	 * call to get those is made before elantech_set_absolute_mode().
+	 */
+	error = elantech_get_range(psmouse, &etd->info);
+	if (error)
+		goto init_fail;
+
 	if (info->fw_version == 0x381f17) {
 		etd->original_set_rate = psmouse->set_rate;
 		psmouse->set_rate = elantech_set_rate_restore_reg_07;
-- 
2.26.2

