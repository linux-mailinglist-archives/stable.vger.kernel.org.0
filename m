Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F1CC1583
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfI2ODM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfI2ODL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:03:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57FB42082F;
        Sun, 29 Sep 2019 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765790;
        bh=c4Emmf62b9QMXx+axLNFOlNMCcRHCTFEmCCh3amIwI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0yuST4mamoDwvFbTRgT+pMxEHM5VIFO3D+QwQeirmcVqp5iBXrhTSIgBS92BeV1o
         Vo5muRQJJaacvdR3sa8YVBKgP2dIiFc9z7Jh7EiPvJ54nGjYB92Bdsj5EjEgCrj91F
         2Xt8zvRQHf19vei1qpwGSEWSv3M+yxRPW61Ddr7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.3 14/25] HID: Add quirk for HP X500 PIXART OEM mouse
Date:   Sun, 29 Sep 2019 15:56:17 +0200
Message-Id: <20190929135014.773043738@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Parschauer <s.parschauer@gmx.de>

commit 2acf40f0454d41b8d51c95d317283c20c931164d upstream.

The PixArt OEM mice are known for disconnecting every minute in
runlevel 1 or 3 if they are not always polled. So add quirk
ALWAYS_POLL for this one as well.

Ville Viinikka (viinikv) reported and tested the quirk.
Link: https://github.com/sriemer/fix-linux-mouse issue 15

Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
CC: stable@vger.kernel.org # v4.16+
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -568,6 +568,7 @@
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A	0x0b4a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE		0x134a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A	0x094a
+#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0941	0x0941
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641	0x0641
 
 #define USB_VENDOR_ID_HUION		0x256c
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -92,6 +92,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0941), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },


