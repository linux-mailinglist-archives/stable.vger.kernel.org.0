Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B19B8DBD6
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfHNR15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbfHNRDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B742421721;
        Wed, 14 Aug 2019 17:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802181;
        bh=a0BZRsJPSZLXdum6dP3S6nZ4tj4eiaaRbI+0p0ZpcSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq9l13cqvuONEvxa9dhUhbxxHGHci/+wuLZd07W5FOAfkU4lxqF74SShIAqk1xvAR
         W0deRHbwkjxEK2ZVe2j/Ow2e7NpRgYp6r5BWE7Py7qty73D00iIq5gfc9kPRpO9BEQ
         jtxwZ5R/HobAUGtRFNm9P89kw0TxdGdYCRIdW0Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.2 025/144] Input: elantech - enable SMBus on new (2018+) systems
Date:   Wed, 14 Aug 2019 18:59:41 +0200
Message-Id: <20190814165800.898710379@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 883a2a80f79ca5c0c105605fafabd1f3df99b34c upstream.

There are some new HP laptops with Elantech touchpad that don't support
multitouch.

Currently we use ETP_NEW_IC_SMBUS_HOST_NOTIFY() to check if SMBus is supported,
but in addition to firmware version, the bus type also informs us whether the IC
can support SMBus. To avoid breaking old ICs, we will only enable SMbus support
based the bus type on systems manufactured after 2018.

Lastly, let's consolidate all checks into elantech_use_host_notify() and use it
to determine whether to use PS/2 or SMBus.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/elantech.c |   54 ++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1807,6 +1807,30 @@ static int elantech_create_smbus(struct
 				  leave_breadcrumbs);
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
+	case ETP_BUS_SMB_HST_NTFY_ONLY:
+	case ETP_BUS_PS2_SMB_HST_NTFY:
+		/* SMbus implementation is stable since 2018 */
+		if (dmi_get_bios_year() >= 2018)
+			return true;
+	default:
+		psmouse_dbg(psmouse,
+			    "Ignoring SMBus bus provider %d\n", info->bus);
+		break;
+	}
+
+	return false;
+}
+
 /**
  * elantech_setup_smbus - called once the PS/2 devices are enumerated
  * and decides to instantiate a SMBus InterTouch device.
@@ -1826,7 +1850,7 @@ static int elantech_setup_smbus(struct p
 		 * i2c_blacklist_pnp_ids.
 		 * Old ICs are up to the user to decide.
 		 */
-		if (!ETP_NEW_IC_SMBUS_HOST_NOTIFY(info->fw_version) ||
+		if (!elantech_use_host_notify(psmouse, info) ||
 		    psmouse_matches_pnp_id(psmouse, i2c_blacklist_pnp_ids))
 			return -ENXIO;
 	}
@@ -1846,34 +1870,6 @@ static int elantech_setup_smbus(struct p
 	return 0;
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
-	case ETP_BUS_SMB_ALERT_ONLY:
-		/* fall-through  */
-	case ETP_BUS_PS2_SMB_ALERT:
-		psmouse_dbg(psmouse, "Ignoring SMBus provider through alert protocol.\n");
-		break;
-	case ETP_BUS_SMB_HST_NTFY_ONLY:
-		/* fall-through  */
-	case ETP_BUS_PS2_SMB_HST_NTFY:
-		return true;
-	default:
-		psmouse_dbg(psmouse,
-			    "Ignoring SMBus bus provider %d.\n",
-			    info->bus);
-	}
-
-	return false;
-}
-
 int elantech_init_smbus(struct psmouse *psmouse)
 {
 	struct elantech_device_info info;


