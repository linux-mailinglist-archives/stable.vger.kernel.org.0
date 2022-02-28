Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2814C6509
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 09:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiB1IuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 03:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiB1IuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 03:50:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465D05C36F;
        Mon, 28 Feb 2022 00:49:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E4F4B80DDB;
        Mon, 28 Feb 2022 08:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6E0C340E7;
        Mon, 28 Feb 2022 08:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646038175;
        bh=Gp2xIeSJ1sUTEYJM2h23SUgb0rACV58he4FCprUnvXY=;
        h=From:To:Cc:Subject:Date:From;
        b=qOqf/uA2DXNqmbhpWNdgV2C7SEoNHxMY4dWuH5HT3R56E67KC4Up3I7C/xsLeDKkw
         ESFTY4UlhO7+nw3KNRwMcPyybMDFhVCMnTjxK3fo2WXzltU98zibiRRbUPFdf/+8BV
         0vWThKE/sgFUrRln/HeBlhePK7nN63lbca1XAJNE4SFa+XHfuJAP5azjxIh2Xh86T4
         +5Lf0UPCb0JUwXwAYd1YOasvPKqr1VTx5gnWLsWxvIUx3JC3Qruw2Qlx2C1hXS29vL
         b/XrLd9u/fhBIasHQsgbz5Zq6ECUeFIsCbnvaeQkbzJpohBRGFnZhh0sr3P9Fktusk
         FljCZ2Z/EMY2A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nObil-0002m8-Tm; Mon, 28 Feb 2022 09:49:31 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] USB: serial: simple: add Nokia phone driver
Date:   Mon, 28 Feb 2022 09:49:19 +0100
Message-Id: <20220228084919.10656-1-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a new "simple" driver for certain Nokia phones, including Nokia 130
(RM-1035) which exposes two serial ports in "charging only" mode:

Bus 001 Device 009: ID 0421:069a Nokia Mobile Phones 130 [RM-1035] (Charging only)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x0421 Nokia Mobile Phones
  idProduct          0x069a 130 [RM-1035] (Charging only)
  bcdDevice            1.00
  iManufacturer           1 Nokia
  iProduct                2 Nokia 130 (RM-1035)
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0037
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Changes in v2
 - don't use the multiport macro since only one port per interface
 - drop reported-by tag


 drivers/usb/serial/Kconfig             | 1 +
 drivers/usb/serial/usb-serial-simple.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index de5c01257060..ef8d1c73c754 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -66,6 +66,7 @@ config USB_SERIAL_SIMPLE
 		- Libtransistor USB console
 		- a number of Motorola phones
 		- Motorola Tetra devices
+		- Nokia mobile phones
 		- Novatel Wireless GPS receivers
 		- Siemens USB/MPI adapter.
 		- ViVOtech ViVOpay USB device.
diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
index bd23a7cb1be2..4c6747889a19 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -91,6 +91,11 @@ DEVICE(moto_modem, MOTO_IDS);
 	{ USB_DEVICE(0x0cad, 0x9016) }	/* TPG2200 */
 DEVICE(motorola_tetra, MOTOROLA_TETRA_IDS);
 
+/* Nokia mobile phone driver */
+#define NOKIA_IDS()			\
+	{ USB_DEVICE(0x0421, 0x069a) }	/* Nokia 130 (RM-1035) */
+DEVICE(nokia, NOKIA_IDS);
+
 /* Novatel Wireless GPS driver */
 #define NOVATEL_IDS()			\
 	{ USB_DEVICE(0x09d7, 0x0100) }	/* NovAtel FlexPack GPS */
@@ -123,6 +128,7 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&vivopay_device,
 	&moto_modem_device,
 	&motorola_tetra_device,
+	&nokia_device,
 	&novatel_gps_device,
 	&hp4x_device,
 	&suunto_device,
@@ -140,6 +146,7 @@ static const struct usb_device_id id_table[] = {
 	VIVOPAY_IDS(),
 	MOTO_IDS(),
 	MOTOROLA_TETRA_IDS(),
+	NOKIA_IDS(),
 	NOVATEL_IDS(),
 	HP4X_IDS(),
 	SUUNTO_IDS(),
-- 
2.34.1

