Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0480AAB46C
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 10:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfIFIxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 04:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfIFIxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 04:53:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A0321C04FFE0;
        Fri,  6 Sep 2019 08:53:52 +0000 (UTC)
Received: from plouf.redhat.com (ovpn-204-26.brq.redhat.com [10.40.204.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77BD5600CC;
        Fri,  6 Sep 2019 08:53:48 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH stable 5.2/4.19] Revert "Input: elantech - enable SMBus on new (2018+) systems"
Date:   Fri,  6 Sep 2019 10:53:45 +0200
Message-Id: <20190906085345.26279-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 06 Sep 2019 08:53:52 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 60956b018bfe23b879405a7d88103d0a8f06a5e3.

This patch depends on an other series:
https://patchwork.kernel.org/project/linux-input/list/?series=122327&state=%2A&archive=both

It was a mistake to backport it in the v5.2 branch, as there
is a high chance we encounter a touchpad that needs the series
above.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204733
Link: https://bugzilla.kernel.org/show_bug.cgi?id=204771
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

Hi,

this is a stable only patch aimed at kernels v5.2 and v4.19 branches.

We already have 2 bug reports of a failing touchpad, and I don't think
it is worth trying to get a smoother touchpad if we randomly
break a few of them in the way.

Cheers,
Benjamin
---
 drivers/input/mouse/elantech.c | 54 ++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index a47c7add4e0e..a4345052abd2 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1807,30 +1807,6 @@ static int elantech_create_smbus(struct psmouse *psmouse,
 				  leave_breadcrumbs);
 }
 
-static bool elantech_use_host_notify(struct psmouse *psmouse,
-				     struct elantech_device_info *info)
-{
-	if (ETP_NEW_IC_SMBUS_HOST_NOTIFY(info->fw_version))
-		return true;
-
-	switch (info->bus) {
-	case ETP_BUS_PS2_ONLY:
-		/* expected case */
-		break;
-	case ETP_BUS_SMB_HST_NTFY_ONLY:
-	case ETP_BUS_PS2_SMB_HST_NTFY:
-		/* SMbus implementation is stable since 2018 */
-		if (dmi_get_bios_year() >= 2018)
-			return true;
-	default:
-		psmouse_dbg(psmouse,
-			    "Ignoring SMBus bus provider %d\n", info->bus);
-		break;
-	}
-
-	return false;
-}
-
 /**
  * elantech_setup_smbus - called once the PS/2 devices are enumerated
  * and decides to instantiate a SMBus InterTouch device.
@@ -1850,7 +1826,7 @@ static int elantech_setup_smbus(struct psmouse *psmouse,
 		 * i2c_blacklist_pnp_ids.
 		 * Old ICs are up to the user to decide.
 		 */
-		if (!elantech_use_host_notify(psmouse, info) ||
+		if (!ETP_NEW_IC_SMBUS_HOST_NOTIFY(info->fw_version) ||
 		    psmouse_matches_pnp_id(psmouse, i2c_blacklist_pnp_ids))
 			return -ENXIO;
 	}
@@ -1870,6 +1846,34 @@ static int elantech_setup_smbus(struct psmouse *psmouse,
 	return 0;
 }
 
+static bool elantech_use_host_notify(struct psmouse *psmouse,
+				     struct elantech_device_info *info)
+{
+	if (ETP_NEW_IC_SMBUS_HOST_NOTIFY(info->fw_version))
+		return true;
+
+	switch (info->bus) {
+	case ETP_BUS_PS2_ONLY:
+		/* expected case */
+		break;
+	case ETP_BUS_SMB_ALERT_ONLY:
+		/* fall-through  */
+	case ETP_BUS_PS2_SMB_ALERT:
+		psmouse_dbg(psmouse, "Ignoring SMBus provider through alert protocol.\n");
+		break;
+	case ETP_BUS_SMB_HST_NTFY_ONLY:
+		/* fall-through  */
+	case ETP_BUS_PS2_SMB_HST_NTFY:
+		return true;
+	default:
+		psmouse_dbg(psmouse,
+			    "Ignoring SMBus bus provider %d.\n",
+			    info->bus);
+	}
+
+	return false;
+}
+
 int elantech_init_smbus(struct psmouse *psmouse)
 {
 	struct elantech_device_info info;
-- 
2.21.0

