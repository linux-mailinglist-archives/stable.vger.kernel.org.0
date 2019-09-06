Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3ACAB9B9
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405267AbfIFNtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405266AbfIFNtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:49:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAA25206B8;
        Fri,  6 Sep 2019 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777772;
        bh=cIv8TA2XdJhfbThtH/Vg6ldC4kZ2Uq/7TJp0aEucP/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wR/fK4PLM25KA5fxxSViqwyA7FEB0rcAV8VJQTFpfujqnkWWaooRVQV0GRXcDF0yH
         QnFtpTshwy8Y6nSJ4y7opp4pCyWtLaLVxMgE6vrPAbao8/Q3pmBUDLhDqFP6MjFzqP
         Sa8dr+VSkL7T491+/8l6I9AL1yCiD0Ts+pNH3pjA=
Date:   Fri, 6 Sep 2019 15:49:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.13
Message-ID: <20190906134930.GB7628@kroah.com>
References: <20190906134925.GA7628@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906134925.GA7628@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index e26d52d93bb1..288284de8858 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 2
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Bobtail Squid
 
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
