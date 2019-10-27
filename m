Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9687DE6796
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbfJ0VWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732094AbfJ0VWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:13 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEFF620717;
        Sun, 27 Oct 2019 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211332;
        bh=1DqdVSCGOeEaLk2suDyeDQnHxAo6s39gquWznHsssWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhOl0lKtVjZEEy7ENtsvkTj/bs0mWGmmpcp0gAGLn4X9mmVKoDVcMFrhFGJiIhzIv
         nb5oOhYsz1ypc/yIpgAxsmDDROpvwo5SLHQACCETaRYGdrC3FqkXq6+mp7O40Rfrk7
         qDSKX7OO3xZOEs42vAreS+HcIOirfzA6uyMd6K7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 114/197] Revert "Input: elantech - enable SMBus on new (2018+) systems"
Date:   Sun, 27 Oct 2019 22:00:32 +0100
Message-Id: <20191027203357.897770970@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit c324345ce89c3cc50226372960619c7ee940f616 upstream.

This reverts commit 883a2a80f79ca5c0c105605fafabd1f3df99b34c.

Apparently use dmi_get_bios_year() as manufacturing date isn't accurate
and this breaks older laptops with new BIOS update.

So let's revert this patch.

There are still new HP laptops still need to use SMBus to support all
features, but it'll be enabled via a whitelist.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191001070845.9720-1-kai.heng.feng@canonical.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/elantech.c |   55 +++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1827,31 +1827,6 @@ static int elantech_create_smbus(struct
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
-		/* fall through */
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
@@ -1871,7 +1846,7 @@ static int elantech_setup_smbus(struct p
 		 * i2c_blacklist_pnp_ids.
 		 * Old ICs are up to the user to decide.
 		 */
-		if (!elantech_use_host_notify(psmouse, info) ||
+		if (!ETP_NEW_IC_SMBUS_HOST_NOTIFY(info->fw_version) ||
 		    psmouse_matches_pnp_id(psmouse, i2c_blacklist_pnp_ids))
 			return -ENXIO;
 	}
@@ -1891,6 +1866,34 @@ static int elantech_setup_smbus(struct p
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


