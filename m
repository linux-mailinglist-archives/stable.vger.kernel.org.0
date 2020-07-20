Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C16226B8C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgGTQma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730280AbgGTPnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:43:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7402065E;
        Mon, 20 Jul 2020 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259817;
        bh=ZJbHCFIdZH4X4ZBrUiUDxNPeZ/xp15aUJQ4HRBDeBgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqKyH4+lb9DMo1QygGXnyGsUF8guEw50Vn2+enOE3+Lp9hF90MX1wv1FlogCJ3zMb
         PnHPfNrTC5lJ8Rlsqv+LECh4R+c6OpYU21q089AmRmLFMZkXThCilh+YxzSO9TScb0
         +ffwdrAU59VJDqjzHzXH3UGhLhu4kGRWeV7CrU7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hilliard <james.hilliard1@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 69/86] USB: serial: cypress_m8: enable Simply Automated UPB PIM
Date:   Mon, 20 Jul 2020 17:37:05 +0200
Message-Id: <20200720152756.649841128@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

commit 5c45d04c5081c1830d674f4d22d4400ea2083afe upstream.

This is a UPB (Universal Powerline Bus) PIM (Powerline Interface Module)
which allows for controlling multiple UPB compatible devices from Linux
using the standard serial interface.

Based on vendor application source code there are two different models
of USB based PIM devices in addition to a number of RS232 based PIM's.

The vendor UPB application source contains the following USB ID's:

	#define USB_PCS_VENDOR_ID 0x04b4
	#define USB_PCS_PIM_PRODUCT_ID 0x5500

	#define USB_SAI_VENDOR_ID 0x17dd
	#define USB_SAI_PIM_PRODUCT_ID 0x5500

The first set of ID's correspond to the PIM variant sold by Powerline
Control Systems while the second corresponds to the Simply Automated
Incorporated PIM. As the product ID for both of these match the default
cypress HID->COM RS232 product ID it assumed that they both use an
internal variant of this HID->COM RS232 converter hardware. However
as the vendor ID for the Simply Automated variant is different we need
to also add it to the cypress_M8 driver so that it is properly
detected.

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://lore.kernel.org/r/20200616220403.1807003-1-james.hilliard1@gmail.com
Cc: stable@vger.kernel.org
[ johan: amend VID define entry ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cypress_m8.c |    2 ++
 drivers/usb/serial/cypress_m8.h |    3 +++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -63,6 +63,7 @@ static const struct usb_device_id id_tab
 
 static const struct usb_device_id id_table_cyphidcomrs232[] = {
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
+	{ USB_DEVICE(VENDOR_ID_SAI, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
 	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ }						/* Terminating entry */
@@ -77,6 +78,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB) },
 	{ USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB_LT20) },
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
+	{ USB_DEVICE(VENDOR_ID_SAI, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
 	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ USB_DEVICE(VENDOR_ID_DAZZLE, PRODUCT_ID_CA42) },
--- a/drivers/usb/serial/cypress_m8.h
+++ b/drivers/usb/serial/cypress_m8.h
@@ -24,6 +24,9 @@
 #define VENDOR_ID_CYPRESS		0x04b4
 #define PRODUCT_ID_CYPHIDCOM		0x5500
 
+/* Simply Automated HID->COM UPB PIM (using Cypress PID 0x5500) */
+#define VENDOR_ID_SAI			0x17dd
+
 /* FRWD Dongle - a GPS sports watch */
 #define VENDOR_ID_FRWD			0x6737
 #define PRODUCT_ID_CYPHIDCOM_FRWD	0x0001


